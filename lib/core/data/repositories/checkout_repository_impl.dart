import 'dart:async';

import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  CheckoutRepositoryImpl(this._service, this._wallet);

  final CheckoutService _service;
  final WalletService _wallet;

  /// Minimum top up (blueprint Rp 10.000). Sejak backend `7ce3b92` ikut
  /// ditegakkan server di `POST /wallet/topup`, tapi nilainya tidak dikirim ke
  /// mana pun — jadi tetap disalin di sini.
  static const double minimumTopup = 10000;

  @override
  Future<DataState<CheckoutSnapshot>> startSession({
    required int addressId,
    String? voucherCode,
  }) async {
    try {
      final created = await _service.createSession(
        addressId: addressId,
        voucherCode: voucherCode,
      );
      return _load(created.data.id);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<CheckoutSnapshot>> refresh(String sessionId) =>
      _load(sessionId);

  @override
  Future<DataState<CheckoutSnapshot>> changeAddress(
    String sessionId, {
    required int addressId,
  }) async {
    try {
      await _service.changeAddress(sessionId, addressId: addressId);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    // Balasannya `data: null`, jadi sesinya dibaca ulang — satu-satunya cara
    // tahu alamatnya benar-benar berubah.
    return _load(sessionId);
  }

  @override
  Future<DataState<CheckoutSnapshot>> setShipping(
    String sessionId,
    Map<String, CourierChoice> selection,
  ) async {
    try {
      await _service.setShipping(sessionId, selection);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    // Balasan PATCH membawa total terbaru, tapi bukan sesi utuh — dan layar
    // butuh `selected_couriers` yang tersimpan di sesi. Jadi dibaca ulang.
    return _load(sessionId);
  }

  @override
  Future<DataState<CheckoutConfirmResult>> confirm(
    String sessionId, {
    required String pin,
  }) async {
    try {
      final env = await _service.confirm(sessionId, pin: pin);
      // Server wallet-only: konfirmasi yang berhasil PASTI sudah dibayar,
      // walau balasannya tidak menyebutnya.
      final result = env.data.copyWith(
        paid: true,
        balanceAfter: await _availableBalanceOrNull(),
      );
      return DataSuccess(result, meta: env.meta, statusCode: env.statusCode);
    } on ApiException catch (e) {
      if (e.error.code != ApiErrorCode.checkoutConfirmFailed) {
        return DataFailed(e.error);
      }
      return DataFailed(await _explainConfirmFailure(sessionId, e.error));
    }
  }

  /// `CHECKOUT_CONFIRM_FAILED` dipakai server untuk empat hal: PIN salah, PIN
  /// belum dibuat, sesi kedaluwarsa, dan sesi yang sudah dikonfirmasi —
  /// bedanya hanya di `message`, yang tidak boleh dicocokkan.
  ///
  /// Dua yang terakhir mengubah status sesi, dua yang pertama tidak (PIN
  /// diperiksa sebelum transaksi apa pun dimulai). Jadi sesi yang **masih**
  /// `stock_reserved` dan belum lewat tenggat berarti masalahnya di PIN —
  /// dilaporkan sebagai [WalletPayErrorCode.invalidPin] supaya tampil di
  /// lembar PIN. Salah dan belum-dibuat tetap tidak bisa dibedakan; pesannya
  /// menyebut keduanya.
  Future<DataError> _explainConfirmFailure(
    String sessionId,
    DataError original,
  ) async {
    try {
      final session = (await _service.fetchSession(sessionId)).data;
      final expires = session.expiresAt;
      final stillOpen = session.isStockReserved &&
          (expires == null || expires.isAfter(DateTime.now()));
      if (!stillOpen) return original;
      return DataError(
        code: WalletPayErrorCode.invalidPin,
        message: original.message,
        details: const {'pin_maybe_not_set': true},
        statusCode: original.statusCode,
        kind: original.kind,
      );
    } on ApiException {
      return original;
    }
  }

  /// Saldo yang bisa dipakai, atau `null` kalau `GET /wallet` gagal — hanya
  /// pelengkap layar sukses, tidak boleh menggagalkan apa pun.
  Future<double?> _availableBalanceOrNull() async {
    try {
      return (await _wallet.fetchWallet()).data.availableBalance;
    } on ApiException {
      return null;
    }
  }

  @override
  Future<DataState<WalletSummaryModel>> fetchWalletSummary(
      String sessionId) async {
    // Ditembak paralel, di-`await` terpisah (lihat `_load`).
    final walletFuture = _wallet.fetchWallet();
    final sessionFuture = _service.fetchSession(sessionId);
    try {
      final wallet = (await walletFuture).data;
      final session = (await sessionFuture).data;
      final balance = wallet.availableBalance;
      final total = session.grandTotal;
      final shortfall = total > balance ? total - balance : 0.0;
      return DataSuccess(WalletSummaryModel(
        walletBalance: balance,
        grandTotal: total,
        shortfall: shortfall,
        canPay: shortfall == 0,
        minTopup: minimumTopup,
        pinSet: true,
      ));
    } on ApiException catch (e) {
      // Pastikan future yang satunya tidak jadi unhandled error.
      unawaited(sessionFuture.then((_) {}, onError: (_) {}));
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<void>> cancelSession(String sessionId) async {
    try {
      await _service.cancel(sessionId);
      return const DataSuccess(null);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  /// Memuat sesi beserta opsi kirimnya.
  ///
  /// Keduanya ditembak paralel tapi di-`await` terpisah, supaya kegagalan yang
  /// satu tidak meninggalkan yang lain sebagai *unhandled async error*.
  ///
  /// Kegagalan mengambil **opsi kirim** tidak menggagalkan seluruhnya: sesi
  /// yang sudah dikonfirmasi tidak lagi butuh opsi kurir, dan menampilkan
  /// ringkasannya tetap berguna. Kegagalan sesinya sendiri fatal.
  Future<DataState<CheckoutSnapshot>> _load(String sessionId) async {
    final sessionFuture = _service.fetchSession(sessionId);
    final optionsFuture = _service.fetchShippingOptions(sessionId);

    CheckoutSessionModel? session;
    DataError? sessionError;
    var options = const <String, List<ShippingOptionModel>>{};

    try {
      session = (await sessionFuture).data;
    } on ApiException catch (e) {
      sessionError = e.error;
    }

    try {
      options = (await optionsFuture).data;
    } on ApiException catch (_) {
      // Sengaja diabaikan — lihat catatan di atas.
    }

    if (session == null) return DataFailed(sessionError!);
    return DataSuccess(
      CheckoutSnapshot(session: session, shippingOptions: options),
    );
  }
}
