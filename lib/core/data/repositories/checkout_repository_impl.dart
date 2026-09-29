import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  CheckoutRepositoryImpl(this._service);

  final CheckoutService _service;

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
    required String paymentMethod,
    String? pin,
  }) async {
    try {
      final env = await _service.confirm(
        sessionId,
        paymentMethod: paymentMethod,
        pin: pin,
      );
      return DataSuccess(env.data, meta: env.meta, statusCode: env.statusCode);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<WalletSummaryModel>> fetchWalletSummary(
      String sessionId) async {
    try {
      final env = await _service.fetchWalletSummary(sessionId);
      return DataSuccess(env.data, meta: env.meta, statusCode: env.statusCode);
    } on ApiException catch (e) {
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
