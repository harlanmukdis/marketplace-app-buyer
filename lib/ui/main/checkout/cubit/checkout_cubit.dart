import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/payment_repository.dart';
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
/// **Dua cara membayar**, dipilih dengan mendeteksi kemampuan server (lihat
/// [CheckoutPaymentMode]): Xpedia Wallet + PIN ([payWithWallet], kontrak yang
/// diusulkan, docs/22 #1–#2) atau alur lama ([confirm] dengan metode bayar
/// terpilih). Keduanya berbagi aturan keselamatan yang sama: satu konfirmasi
/// pada satu waktu, tidak pernah diulang otomatis.
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

  /// Hasil deteksi pembayaran Wallet, dipegang di cubit supaya tidak hilang
  /// setiap kali [CheckoutState.ready] dibuat ulang dari snapshot baru.
  /// Sekali `legacy`, tidak dideteksi lagi selama layar ini hidup — rute
  /// yang tidak ada tidak akan muncul di tengah checkout.
  CheckoutPaymentMode _paymentMode = CheckoutPaymentMode.detecting;
  WalletSummaryModel? _wallet;
  Map<String, dynamic>? _walletMeta;

  /// Nomor muat `wallet-summary`, supaya balasan lama yang tiba belakangan
  /// tidak menimpa yang lebih baru (kurir diganti dua kali berturut-turut).
  int _walletRequest = 0;

  /// Minimum top up — blueprint Xpedia; **tidak** ditegakkan server
  /// (docs/22 #12), jadi aplikasi yang menjaganya. `wallet-summary` boleh
  /// mengirim nilai lain lewat `min_topup`.
  static const double minimumTopup = 10000;

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

  /// Mengonfirmasi checkout pada **alur lama** (tanpa Wallet).
  ///
  /// ⚠️ **Tidak pernah diulang otomatis.** Backend belum menangani
  /// `Idempotency-Key`, jadi percobaan ulang berisiko membuat order ganda —
  /// user yang memutuskan menekan tombolnya lagi, bukan aplikasi.
  Future<void> confirm() async {
    final current = state;
    if (current is! CheckoutReady || current.isSubmitting) return;
    final id = _openSessionId;
    if (id == null) return;

    if (current.paymentMode == CheckoutPaymentMode.detecting) {
      // Belum tahu apakah server menuntut Wallet; mengonfirmasi dengan metode
      // lama sekarang bisa membuat order dengan cara bayar yang salah.
      emit(current.copyWith(
        actionError: _localValidation('Metode pembayaran sedang diperiksa.'),
      ));
      return;
    }
    if (current.paymentMode == CheckoutPaymentMode.wallet) {
      // Pada alur Wallet setiap pembayaran menuntut PIN (design_buyer.md §5,
      // aturan 5) — tidak ada jalan pintas satu ketukan.
      emit(current.copyWith(
        actionError: _localValidation('Masukkan PIN Wallet untuk membayar.'),
      ));
      return;
    }

    final paymentMethod = current.selectedPaymentMethod;
    if (paymentMethod.isEmpty) {
      emit(current.copyWith(
        actionError: _localValidation('Pilih metode pembayaran dulu.'),
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
    final result = await _repository.confirm(id, paymentMethod: paymentMethod);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data, :final meta):
        await _onConfirmed(data, meta);
      case DataFailed(:final error):
        emit(current.copyWith(isSubmitting: false, actionError: error));
      case DataEmpty():
      case DataLoading():
        emit(current.copyWith(isSubmitting: false));
    }
  }

  /// Mengonfirmasi **dan membayar** dari saldo Xpedia Wallet dengan [pin].
  ///
  /// Semua yang bisa diperiksa tanpa jaringan diperiksa dulu — format PIN,
  /// PIN sudah dibuat, saldo cukup — supaya percobaan PIN yang dibatasi
  /// server (5 per 15 menit) tidak terbuang untuk penolakan yang sudah pasti.
  ///
  /// Penolakan PIN (`INVALID_PIN`, `TOO_MANY_REQUESTS`) masuk ke
  /// [CheckoutReady.pinError] supaya tampil di lembar PIN; penolakan lain
  /// menutup lembarnya lewat [CheckoutReady.actionError], dan untuk saldo /
  /// PIN yang ternyata belum dibuat, ringkasan Wallet dimuat ulang supaya
  /// layar menunjukkan jalan keluarnya.
  ///
  /// ⚠️ Seperti [confirm]: **tidak pernah diulang otomatis**.
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
        await _repository.confirm(id, paymentMethod: 'wallet', pin: pin);
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
    if (id == null || _paymentMode == CheckoutPaymentMode.legacy) return;
    await _loadWallet(id);
  }

  /// Menyimpan pasangan order → transaksi (tidak ada endpoint yang
  /// memetakannya, lihat [OrderPaymentLinkStore]) lalu pindah ke
  /// [CheckoutConfirmed]. Berlaku untuk **kedua** alur: pesanan alur lama
  /// yang belum dibayar jadi bisa dibayar lagi dari detail pesanan.
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
        final loadWallet = _openSessionId != null &&
            _paymentMode != CheckoutPaymentMode.legacy;
        emit(CheckoutState.ready(
          snapshot: data,
          paymentMethods: _paymentMethods,
          selectedPaymentMethod: _selectedPaymentMethod,
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

  /// Memuat `wallet-summary` dan sekaligus mendeteksi apakah server
  /// mendukung pembayaran Wallet.
  ///
  /// Hanya rute yang **tidak dikenal** yang memindahkan checkout ke alur
  /// lama. Kegagalan lain (jaringan, 500) disimpan sebagai
  /// [CheckoutReady.walletError] dengan tombol coba lagi — menyerah ke alur
  /// lama karena satu request gagal akan menawarkan cara bayar yang tidak
  /// lagi berlaku begitu Wallet sudah wajib.
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
        if (error.isRouteNotFound) {
          _paymentMode = CheckoutPaymentMode.legacy;
          _wallet = null;
          _walletMeta = null;
        }
        if (current is CheckoutReady) {
          emit(current.copyWith(
            paymentMode: _paymentMode,
            wallet: _wallet,
            walletMeta: _walletMeta,
            walletLoading: false,
            walletError: error.isRouteNotFound ? null : error,
          ));
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
