import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/core/services/order_payment_link_store.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

part 'checkout_cubit.freezed.dart';
part 'checkout_state.dart';

/// Penolakan yang dibuat aplikasi sendiri; hanya kode ini yang `message`-nya
/// ditampilkan `errorMessageFor`.
DataError _localValidation(String message) => DataError(
      code: ClientErrorCode.localValidation,
      message: message,
      kind: DataErrorKind.api,
    );

/// Alur checkout: buat sesi → pilih kurir per toko → konfirmasi.
///
/// **Satu cara membayar: Xpedia Wallet + PIN** ([payWithWallet]). Sejak
/// backend `d9ecb33` (docs/22 #1–#2) checkout wallet-only — pemilih metode
/// pembayaran lama (QRIS/VA) sudah dibuang, karena server tidak lagi membaca
/// `payment_method` dan menolak konfirmasi tanpa PIN. Aturan keselamatannya:
/// satu konfirmasi pada satu waktu, tidak pernah diulang otomatis.
///
/// Membuat sesi **mereservasi stok selama 15 menit**, jadi cubit ini memegang
/// sumber daya di server — bukan sekadar menampilkan data. Itu sebabnya
/// [close] membatalkan sesi yang belum dikonfirmasi: kalau tidak, stok orang
/// lain tertahan sampai tenggat hanya karena user menutup layar.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit()
      : _repository = injector<CheckoutRepository>(),
        super(const CheckoutState.preparing());

  static CheckoutCubit get(BuildContext context) => BlocProvider.of(context);

  final CheckoutRepository _repository;

  /// Alamat yang dipakai sesi berjalan, disimpan supaya sesi bisa dibuat ulang
  /// saat alamatnya diganti.
  int? _addressId;
  String? _voucherCode;

  /// Id sesi yang masih menahan reservasi stok dan perlu dibatalkan kalau
  /// ditinggalkan.
  String? _openSessionId;

  /// Ringkasan Wallet terakhir, dipegang di cubit supaya tidak hilang
  /// setiap kali [CheckoutState.ready] dibuat ulang dari snapshot baru.
  CheckoutPaymentMode _paymentMode = CheckoutPaymentMode.detecting;
  WalletSummaryModel? _wallet;
  Map<String, dynamic>? _walletMeta;

  /// Nomor muat ringkasan Wallet, supaya balasan lama yang tiba belakangan
  /// tidak menimpa yang lebih baru (kurir diganti dua kali berturut-turut).
  int _walletRequest = 0;

  /// Minimum top up — blueprint Xpedia (docs/22 #12). Ditegakkan server juga
  /// sejak backend `7ce3b92`, tapi dicek di sini dulu supaya pesannya tepat.
  static const double minimumTopup = 10000;

  Future<void> start({required int addressId, String? voucherCode}) async {
    emit(const CheckoutState.preparing());
    _addressId = addressId;
    _voucherCode = voucherCode;

    final result = await _repository.startSession(
      addressId: addressId,
      voucherCode: voucherCode,
    );
    if (isClosed) return;
    _apply(result);
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

  /// Mengonfirmasi **dan membayar** dari saldo Xpedia Wallet dengan [pin].
  ///
  /// Semua yang bisa diperiksa tanpa jaringan diperiksa dulu — format PIN,
  /// PIN sudah dibuat, saldo cukup — supaya percobaan PIN yang dibatasi
  /// server (5 per 15 menit) tidak terbuang untuk penolakan yang sudah pasti.
  ///
  /// Penolakan PIN ([WalletPayErrorCode.invalidPin] — hasil terjemahan
  /// repository, lihat `CheckoutRepositoryImpl.confirm` — dan
  /// `TOO_MANY_REQUESTS`) masuk ke
  /// [CheckoutReady.pinError] supaya tampil di lembar PIN; penolakan lain
  /// menutup lembarnya lewat [CheckoutReady.actionError], dan untuk saldo /
  /// PIN yang ternyata belum dibuat, ringkasan Wallet dimuat ulang supaya
  /// layar menunjukkan jalan keluarnya.
  ///
  /// ⚠️ **Tidak pernah diulang otomatis**: backend belum menangani
  /// `Idempotency-Key`, jadi pengulangan bisa membuat order ganda.
  Future<void> payWithWallet(String pin) async {
    final current = state;
    if (current is! CheckoutReady || current.isSubmitting) return;
    final id = _openSessionId;
    if (id == null) return;
    if (current.paymentMode != CheckoutPaymentMode.wallet) return;

    final wallet = current.wallet;
    if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
      emit(current.copyWith(
          pinError: _localValidation('PIN harus 6 digit angka.')));
      return;
    }
    if (wallet == null || current.walletLoading) {
      emit(current.copyWith(
        actionError: _localValidation('Saldo Wallet sedang dimuat. Coba lagi.'),
      ));
      return;
    }
    if (!wallet.pinSet) {
      emit(current.copyWith(
        actionError: _localValidation('Buat PIN Wallet dulu untuk membayar.'),
      ));
      return;
    }
    if (!wallet.canPay) {
      emit(current.copyWith(
        actionError: _localValidation(
            'Saldo Wallet kurang ${formatRupiah(wallet.shortfall)}. '
            'Top up dulu untuk melanjutkan.'),
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

    emit(current.copyWith(
        isSubmitting: true, actionError: null, pinError: null));
    final result =
        await _repository.confirm(id, pin: pin);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data, :final meta):
        await _onConfirmed(data, meta);
      case DataFailed(:final error):
        final latest =
            state is CheckoutReady ? state as CheckoutReady : current;
        final isPinProblem = error.code == WalletPayErrorCode.invalidPin ||
            error.code == ApiErrorCode.tooManyRequests;
        emit(latest.copyWith(
          isSubmitting: false,
          pinError: isPinProblem ? error : null,
          actionError: isPinProblem ? null : error,
        ));
        if (error.code == ApiErrorCode.insufficientBalance ||
            error.code == WalletPayErrorCode.pinNotSet) {
          await reloadWallet();
        }
      case DataEmpty():
      case DataLoading():
        emit(current.copyWith(isSubmitting: false));
    }
  }

  void clearPinError() {
    final current = state;
    if (current is! CheckoutReady || current.pinError == null) return;
    emit(current.copyWith(pinError: null));
  }

  /// Membuat transaksi top up untuk menutup kekurangan saldo.
  ///
  /// Saldo **belum** bertambah di sini (`POST /wallet/topup` hanya membuat
  /// transaksi pending); layar membuka `PaymentScreen` untuk
  /// [CheckoutReady.pendingTopupTxId], lalu memuat ulang ringkasan sesudah
  /// kembali. Reservasi stok tetap berjalan selama itu — hitung mundurnya
  /// tetap tampil.
  ///
  /// `WalletRepository` diambil saat dipakai, bukan di konstruktor: hanya
  /// jalur ini yang membutuhkannya.
  Future<void> startTopup(double amount) async {
    final current = state;
    if (current is! CheckoutReady || current.isToppingUp) return;
    final minimum = current.wallet?.minTopup ?? minimumTopup;
    if (amount < minimum) {
      emit(current.copyWith(
        actionError:
            _localValidation('Minimal top up ${formatRupiah(minimum)}.'),
      ));
      return;
    }

    emit(current.copyWith(isToppingUp: true, actionError: null));
    final result = await injector<WalletRepository>().topup(amount: amount);
    if (isClosed) return;
    final latest = state is CheckoutReady ? state as CheckoutReady : current;
    switch (result) {
      case DataSuccess(:final data):
        emit(latest.copyWith(
          isToppingUp: false,
          pendingTopupTxId: data.paymentTransactionId,
        ));
      case DataFailed(:final error):
        emit(latest.copyWith(isToppingUp: false, actionError: error));
      case DataEmpty():
      case DataLoading():
        emit(latest.copyWith(isToppingUp: false));
    }
  }

  /// Layar sudah mengambil [CheckoutReady.pendingTopupTxId] untuk dibuka.
  ///
  /// Dikosongkan **sebelum** layar pembayaran dibuka, supaya emisi state
  /// berikutnya tidak membuka layar yang sama dua kali. Saldo dimuat ulang
  /// oleh layar lewat [reloadWallet] sesudah pembeli kembali.
  void topupHandled() {
    final current = state;
    if (current is CheckoutReady && current.pendingTopupTxId != null) {
      emit(current.copyWith(pendingTopupTxId: null));
    }
  }

  /// Memuat ulang ringkasan Wallet (sesudah top up, membuat PIN, atau
  /// ditolak server karena saldo).
  Future<void> reloadWallet() async {
    final id = _openSessionId;
    if (id == null) return;
    await _loadWallet(id);
  }

  /// Menyimpan pasangan order → transaksi (tidak ada endpoint yang
  /// memetakannya, lihat [OrderPaymentLinkStore]) lalu pindah ke
  /// [CheckoutConfirmed].
  Future<void> _onConfirmed(
    CheckoutConfirmResult data,
    Map<String, dynamic> meta,
  ) async {
    // Sesinya sudah jadi order — tidak perlu (dan tidak boleh) dibatalkan
    // saat cubit ditutup.
    _openSessionId = null;
    final txId = data.paymentTransactionId;
    if (txId != null && data.orderIds.isNotEmpty) {
      try {
        await OrderPaymentLinkStore.save(data.orderIds, txId);
      } catch (_) {
        // Tautan lokal hanya kemudahan; gagal menyimpannya tidak boleh
        // menyembunyikan fakta bahwa order sudah terbentuk.
      }
    }
    if (isClosed) return;
    emit(CheckoutState.confirmed(data, meta: meta.isEmpty ? null : meta));
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
        _openSessionId = data.session.isStockReserved ? data.session.id : null;
        final loadWallet = _openSessionId != null;
        emit(CheckoutState.ready(
          snapshot: data,
          paymentMode: _paymentMode,
          wallet: _wallet,
          walletMeta: _walletMeta,
          walletLoading: loadWallet,
        ));
        // Total bisa berubah (kurir, alamat), jadi ringkasan saldo dimuat
        // ulang setiap snapshot baru — bukan hanya sekali.
        if (loadWallet) unawaited(_loadWallet(_openSessionId!));
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

  /// Memuat ringkasan saldo Wallet vs total sesi.
  ///
  /// Kegagalan (jaringan, 500) disimpan sebagai [CheckoutReady.walletError]
  /// dengan tombol coba lagi; tombol bayar mati sampai ringkasannya ada.
  Future<void> _loadWallet(String sessionId) async {
    final request = ++_walletRequest;
    final before = state;
    if (before is CheckoutReady && !before.walletLoading) {
      emit(before.copyWith(walletLoading: true, walletError: null));
    }

    final result = await _repository.fetchWalletSummary(sessionId);
    if (isClosed || request != _walletRequest) return;
    final current = state;

    switch (result) {
      case DataSuccess(:final data, :final meta):
        _paymentMode = CheckoutPaymentMode.wallet;
        _wallet = data;
        _walletMeta = meta;
        if (current is CheckoutReady) {
          emit(current.copyWith(
            paymentMode: _paymentMode,
            wallet: data,
            walletMeta: meta,
            walletLoading: false,
            walletError: null,
          ));
        }
      case DataFailed(:final error):
        if (current is CheckoutReady) {
          emit(current.copyWith(walletLoading: false, walletError: error));
        }
      case DataEmpty():
      case DataLoading():
        if (current is CheckoutReady) {
          emit(current.copyWith(walletLoading: false));
        }
    }
  }

  int? get addressId => _addressId;
}
