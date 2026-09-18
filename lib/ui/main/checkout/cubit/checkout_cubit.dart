import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/payment_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'checkout_cubit.freezed.dart';
part 'checkout_state.dart';

/// Alur checkout: buat sesi → pilih kurir per toko → konfirmasi.
///
/// Membuat sesi **mereservasi stok selama 15 menit**, jadi cubit ini memegang
/// sumber daya di server — bukan sekadar menampilkan data. Itu sebabnya
/// [close] membatalkan sesi yang belum dikonfirmasi: kalau tidak, stok orang
/// lain tertahan sampai tenggat hanya karena user menutup layar.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit()
      : _repository = injector<CheckoutRepository>(),
        _payments = injector<PaymentRepository>(),
        super(const CheckoutState.preparing());

  static CheckoutCubit get(BuildContext context) => BlocProvider.of(context);

  final CheckoutRepository _repository;
  final PaymentRepository _payments;

  /// Metode bayar dimuat sekali dan disimpan di cubit, bukan diambil ulang
  /// setiap sesi dibuat — daftarnya tidak bergantung pada isi keranjang.
  List<PaymentMethodModel> _paymentMethods = const [];
  String _selectedPaymentMethod = '';

  /// Alamat yang dipakai sesi berjalan, disimpan supaya sesi bisa dibuat ulang
  /// saat alamatnya diganti.
  int? _addressId;
  String? _voucherCode;

  /// Id sesi yang masih menahan reservasi stok dan perlu dibatalkan kalau
  /// ditinggalkan.
  String? _openSessionId;

  Future<void> start({required int addressId, String? voucherCode}) async {
    emit(const CheckoutState.preparing());
    _addressId = addressId;
    _voucherCode = voucherCode;

    // Metode bayar ditembak paralel dengan pembuatan sesi; keduanya tidak
    // saling bergantung. Kegagalan mengambil metode tidak menggagalkan
    // checkout — layar menampilkan daftar kosong dan tombol bayar tetap mati
    // sampai ada metode, yang lebih jelas daripada layar error penuh.
    final methodsFuture = _paymentMethods.isEmpty
        ? _payments.fetchMethods()
        : Future.value(DataSuccess(_paymentMethods));

    final result = await _repository.startSession(
      addressId: addressId,
      voucherCode: voucherCode,
    );
    final methods = await methodsFuture;
    if (isClosed) return;

    if (methods is DataSuccess<List<PaymentMethodModel>>) {
      _paymentMethods = methods.data;
      if (_selectedPaymentMethod.isEmpty && methods.data.isNotEmpty) {
        _selectedPaymentMethod = methods.data.first.code;
      }
    }

    _apply(result);
  }

  /// Mengganti metode pembayaran.
  void selectPaymentMethod(String code) {
    _selectedPaymentMethod = code;
    final current = state;
    if (current is! CheckoutReady) return;
    emit(current.copyWith(selectedPaymentMethod: code));
  }

  /// Mengganti alamat tujuan **pada sesi yang sedang berjalan**.
  ///
  /// Reservasi stoknya dipertahankan. Sampai backend memperbaiki
  /// `PATCH /checkout/sessions/{id}/address` (commit `8235c33`), ini terpaksa
  /// dilakukan dengan membatalkan sesi lalu membuat yang baru — cara yang
  /// melepas reservasi lalu mengambilnya lagi, sehingga user bisa kehilangan
  /// barangnya ke pembeli lain hanya karena salah pilih alamat.
  ///
  /// Kalau belum ada sesi terbuka, alamat ini dipakai untuk memulai satu.
  Future<void> changeAddress(int addressId) async {
    final id = _openSessionId;
    if (id == null) {
      await start(addressId: addressId, voucherCode: _voucherCode);
      return;
    }

    final current = state;
    if (current is CheckoutReady && current.isSubmitting) return;

    emit(const CheckoutState.preparing());
    final result = await _repository.changeAddress(id, addressId: addressId);
    if (isClosed) return;
    _apply(result);
  }

  Future<void> refresh() async {
    final id = _openSessionId;
    if (id == null) return;
    final result = await _repository.refresh(id);
    if (isClosed) return;
    _apply(result);
  }

  /// Memilih kurir untuk satu toko, mempertahankan pilihan toko lain.
  Future<void> selectCourier(String storeId, ShippingOptionModel option) async {
    final current = state;
    if (current is! CheckoutReady || current.isSubmitting) return;
    final id = _openSessionId;
    if (id == null) return;

    // Kirim seluruh pilihan, bukan hanya yang berubah: endpointnya mengganti
    // isi `selected_couriers`, jadi mengirim satu toko saja akan menghapus
    // pilihan toko lain.
    final selection = <String, CourierChoice>{};
    for (final otherStore in current.snapshot.storeIds) {
      final existing = current.snapshot.selectedFor(otherStore);
      if (existing != null) {
        selection[otherStore] = (
          courierCode: existing.courierCode,
          serviceCode: existing.serviceCode,
        );
      }
    }
    selection[storeId] =
        (courierCode: option.courierCode, serviceCode: option.serviceCode);

    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result = await _repository.setShipping(id, selection);
    if (isClosed) return;
    _apply(result, previous: current);
  }

  /// Mengonfirmasi checkout.
  ///
  /// ⚠️ **Tidak pernah diulang otomatis.** Backend belum menangani
  /// `Idempotency-Key`, jadi percobaan ulang berisiko membuat order ganda —
  /// user yang memutuskan menekan tombolnya lagi, bukan aplikasi.
  Future<void> confirm() async {
    final current = state;
    if (current is! CheckoutReady || current.isSubmitting) return;
    final id = _openSessionId;
    if (id == null) return;

    final paymentMethod = current.selectedPaymentMethod;
    if (paymentMethod.isEmpty) {
      emit(current.copyWith(
        actionError: const DataError(
          code: ApiErrorCode.validationError,
          message: 'Pilih metode pembayaran dulu',
          kind: DataErrorKind.api,
        ),
      ));
      return;
    }

    if (!current.snapshot.session.canConfirm) {
      emit(current.copyWith(
        actionError: const DataError(
          code: ApiErrorCode.checkoutConfirmFailed,
          message: 'Sesi belum siap dikonfirmasi',
          kind: DataErrorKind.api,
        ),
      ));
      return;
    }

    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result =
        await _repository.confirm(id, paymentMethod: paymentMethod);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        // Sesinya sudah jadi order — tidak perlu (dan tidak boleh) dibatalkan
        // saat cubit ditutup.
        _openSessionId = null;
        emit(CheckoutState.confirmed(data));
      case DataFailed(:final error):
        emit(current.copyWith(isSubmitting: false, actionError: error));
      case DataEmpty():
      case DataLoading():
        emit(current.copyWith(isSubmitting: false));
    }
  }

  /// Membatalkan sesi atas permintaan user.
  Future<void> cancel() async {
    final id = _openSessionId;
    if (id == null) return;
    _openSessionId = null;
    await _repository.cancelSession(id);
    if (isClosed) return;
    emit(const CheckoutState.preparing());
  }

  void clearActionError() {
    final current = state;
    if (current is! CheckoutReady || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  /// Melepas reservasi stok kalau layar ditutup sebelum konfirmasi.
  ///
  /// Sengaja tidak di-`await` oleh `close()` — `Cubit.close` tidak boleh
  /// menunggu jaringan — tapi permintaannya tetap dikirim. Kalaupun gagal,
  /// server melepas reservasinya sendiri saat tenggat 15 menit lewat.
  @override
  Future<void> close() {
    final id = _openSessionId;
    if (id != null) {
      _openSessionId = null;
      // Dibungkus try/catch: repository memang tidak melempar, tapi tanpa ini
      // kegagalan tak terduga jadi unhandled async error setelah cubit mati.
      unawaited(() async {
        try {
          await _repository.cancelSession(id);
        } catch (_) {
          // Tidak ada yang bisa dilakukan — layarnya sudah tidak ada. Server
          // melepas reservasinya sendiri saat tenggat 15 menit lewat.
        }
      }());
    }
    return super.close();
  }

  void _apply(
    DataState<CheckoutSnapshot> result, {
    CheckoutReady? previous,
  }) {
    switch (result) {
      case DataSuccess(:final data):
        _openSessionId =
            data.session.isStockReserved ? data.session.id : null;
        emit(CheckoutState.ready(
          snapshot: data,
          paymentMethods: _paymentMethods,
          selectedPaymentMethod: _selectedPaymentMethod,
        ));
      case DataFailed(:final error):
        if (previous != null) {
          // Kegagalan memilih kurir tidak boleh membuang sesi yang sudah
          // berjalan — reservasi stoknya masih hidup.
          emit(previous.copyWith(isSubmitting: false, actionError: error));
        } else {
          emit(CheckoutState.error(error));
        }
      case DataEmpty():
      case DataLoading():
        break;
    }
  }

  int? get addressId => _addressId;
}
