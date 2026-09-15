import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';

/// Panggilan HTTP untuk `/checkout/sessions*`.
///
/// **Id sesi adalah UUID string**, bukan integer — rutenya `(:any)`.
///
/// 🔴 **`PATCH /checkout/sessions/{id}/address` tidak dibuatkan method di sini
/// dengan sengaja: endpoint itu rusak.** Controllernya membaca body dengan
/// `$this->post('address_id')` pada rute PATCH, sehingga nilainya selalu
/// `null` dan server menjalankan `UPDATE … SET shipping_address_id = NULL`,
/// yang ditolak foreign key. Hasilnya **selalu 500 halaman HTML**, apa pun
/// encoding body-nya (JSON, form, query string — ketiganya sudah diuji).
///
/// Jalan memutarnya: alamat ditetapkan saat sesi dibuat lewat [createSession].
/// Untuk menggantinya, **batalkan sesi lalu buat sesi baru** — itulah yang
/// dilakukan `CheckoutCubit.changeAddress`.
///
/// ⚠️ **`Idempotency-Key` belum diimplementasikan backend**, jadi mengulang
/// [confirm] secara otomatis berisiko menggandakan order. Jangan pasang retry
/// pada endpoint ini.
class CheckoutService {
  CheckoutService(this._dio);

  final Dio _dio;

  /// `POST /checkout/sessions` — membuat sesi dari **baris keranjang yang
  /// tercentang**, sekaligus mereservasi stok selama 15 menit.
  ///
  /// Balasannya membawa `expires_at` dalam **UTC** (lihat
  /// `ServerUtcDateTimeJson`).
  Future<ApiEnvelope<CheckoutSessionCreated>> createSession({
    required int addressId,
    String? voucherCode,
  }) async {
    const context = 'POST /checkout/sessions';
    try {
      final response = await _dio.post<dynamic>(
        '/checkout/sessions',
        data: {
          'address_id': addressId,
          if (voucherCode != null && voucherCode.isNotEmpty)
            'voucher_code': voucherCode,
        },
      );
      return parseEnvelope(
        response,
        (raw) => CheckoutSessionCreated.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<CheckoutSessionModel>> fetchSession(String id) async {
    final context = 'GET /checkout/sessions/$id';
    try {
      final response = await _dio.get<dynamic>('/checkout/sessions/$id');
      return parseEnvelope(
        response,
        (raw) => CheckoutSessionModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /checkout/sessions/{id}/shipping-options`.
  ///
  /// ⚠️ Balasannya **map berkunci `store_id` (string)**, bukan list:
  /// `{"1": [ … ], "2": [ … ]}`. Tiap toko punya daftar opsinya sendiri karena
  /// ongkir dihitung dari gudang toko itu ke alamat tujuan.
  Future<ApiEnvelope<Map<String, List<ShippingOptionModel>>>>
      fetchShippingOptions(String id) async {
    final context = 'GET /checkout/sessions/$id/shipping-options';
    try {
      final response =
          await _dio.get<dynamic>('/checkout/sessions/$id/shipping-options');
      return parseEnvelope(
        response,
        (raw) {
          if (raw is! Map) return <String, List<ShippingOptionModel>>{};
          return raw.map((key, value) {
            final options = value is List
                ? value
                    .whereType<Map>()
                    .map((e) => ShippingOptionModel.fromJson(
                        Map<String, dynamic>.from(e)))
                    .toList()
                : <ShippingOptionModel>[];
            return MapEntry(key.toString(), options);
          });
        },
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `PATCH /checkout/sessions/{id}/shipping` — memilih kurir **per toko**.
  ///
  /// Body-nya map berkunci `store_id`, sama seperti bentuk opsinya:
  /// `{"1": {"courier_code": "jnt", "service_code": "ez"}}`.
  ///
  /// Berbeda dari endpoint `/address` yang rusak, yang ini membaca body dengan
  /// benar (`$this->body()` di controller).
  Future<ApiEnvelope<ShippingSelectionResult>> setShipping(
    String id,
    Map<String, ({String courierCode, String serviceCode})> selection,
  ) async {
    final context = 'PATCH /checkout/sessions/$id/shipping';
    try {
      final response = await _dio.patch<dynamic>(
        '/checkout/sessions/$id/shipping',
        data: {
          for (final entry in selection.entries)
            entry.key: {
              'courier_code': entry.value.courierCode,
              'service_code': entry.value.serviceCode,
            },
        },
      );
      return parseEnvelope(
        response,
        (raw) => ShippingSelectionResult.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /checkout/sessions/{id}/confirm` → order terbentuk.
  ///
  /// Mengonfirmasi sesi yang sudah dikonfirmasi dibalas
  /// `422 CHECKOUT_CONFIRM_FAILED`.
  Future<ApiEnvelope<CheckoutConfirmResult>> confirm(
    String id, {
    required String paymentMethod,
  }) async {
    final context = 'POST /checkout/sessions/$id/confirm';
    try {
      final response = await _dio.post<dynamic>(
        '/checkout/sessions/$id/confirm',
        data: {'payment_method': paymentMethod},
      );
      return parseEnvelope(
        response,
        (raw) => CheckoutConfirmResult.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /checkout/sessions/{id}/cancel` — melepas reservasi stok.
  ///
  /// Sesudahnya status sesi jadi **`expired`**, bukan `cancelled`.
  Future<ApiEnvelope<dynamic>> cancel(String id) async {
    final context = 'POST /checkout/sessions/$id/cancel';
    try {
      final response =
          await _dio.post<dynamic>('/checkout/sessions/$id/cancel');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
