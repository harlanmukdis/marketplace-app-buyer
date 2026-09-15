import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';

/// Panggilan HTTP untuk `/orders*` **sisi pembeli**.
///
/// ⚠️ **Endpoint sisi penjual sengaja tidak ada di sini**:
/// `/orders/{id}/accept|pack|ship` dan `/stores/{id}/orders` semuanya dijawab
/// `403 PERMISSION_DENIED` untuk token buyer. Menambahkannya berarti alur yang
/// salah sisi sedang dibangun.
///
/// ⚠️ **`GET /orders` hanya menerima `page`.** Controllernya meneruskan
/// persis satu parameter ke model (`list_for_buyer($userId, $page)`), jadi:
///
/// * **`?status=` diabaikan** — meminta `completed` tetap mengembalikan
///   pesanan `pending` dan `cancelled`. (Sisi penjual, `list_for_store`,
///   memang mendukungnya; sisi pembeli tidak.) Karena itu [fetchOrders] tidak
///   punya parameter status: menyediakannya berarti menawarkan filter yang
///   diam-diam tidak bekerja.
/// * **`?per_page=` diabaikan** — ukuran halaman dipatok [serverPageSize] di
///   server.
/// * **`meta` tidak dikirim sama sekali** — tidak ada `total`. Adanya halaman
///   berikutnya hanya bisa **disimpulkan** dari jumlah item yang kembali.
class OrderService {
  OrderService(this._dio);

  final Dio _dio;

  /// Ukuran halaman yang dipakai server (`list_for_buyer`, default 20) dan
  /// **tidak bisa diubah klien**. Dipakai untuk menebak adanya halaman
  /// berikutnya.
  static const int serverPageSize = 20;

  /// `GET /orders` — pesanan milik user login, terbaru dulu.
  ///
  /// Hasilnya **tanpa** `items`, `status_history`, dan `refund`; ketiganya
  /// hanya ada di [fetchOrder].
  Future<ApiEnvelope<List<OrderModel>>> fetchOrders({int page = 1}) async {
    const context = 'GET /orders';
    try {
      final response = await _dio.get<dynamic>(
        '/orders',
        queryParameters: <String, dynamic>{'page': page},
      );
      return parseEnvelopeList(response, OrderModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /orders/{id}` — detail lengkap.
  ///
  /// Order milik user lain dibalas `403 PERMISSION_DENIED`, bukan `404`.
  Future<ApiEnvelope<OrderModel>> fetchOrder(int id) async {
    final context = 'GET /orders/$id';
    try {
      final response = await _dio.get<dynamic>('/orders/$id');
      return parseEnvelope(
        response,
        (raw) => OrderModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/cancel` — pembeli membatalkan sebelum diproses.
  Future<ApiEnvelope<dynamic>> cancel(int id, {String? reason}) async {
    final context = 'POST /orders/$id/cancel';
    try {
      final response = await _dio.post<dynamic>(
        '/orders/$id/cancel',
        data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/confirm-delivery` — `shipped` → `delivered`.
  ///
  /// Transisi yang tidak sah dibalas `422 VALIDATION_ERROR` dengan rapi.
  Future<ApiEnvelope<dynamic>> confirmDelivery(int id) async {
    final context = 'POST /orders/$id/confirm-delivery';
    try {
      final response =
          await _dio.post<dynamic>('/orders/$id/confirm-delivery');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/complete` — `delivered` → `completed`.
  ///
  /// 🔴 **Endpoint ini tidak menangani transisi tidak sah dengan benar.**
  /// Berbeda dari [confirmDelivery] yang membungkusnya jadi
  /// `422 VALIDATION_ERROR`, controller `complete_post` tidak punya
  /// try/catch — `RuntimeException`-nya lolos dan dirender sebagai **halaman
  /// HTML dengan status `200`**. Dio tidak menganggapnya error (status 2xx),
  /// dan `parseEnvelope` menolaknya sebagai `CLIENT_BAD_RESPONSE`.
  ///
  /// Karena itu pemanggil **wajib memeriksa status order lebih dulu**
  /// (`OrderModel.canComplete`) daripada mengandalkan pesan error server.
  Future<ApiEnvelope<dynamic>> complete(int id) async {
    final context = 'POST /orders/$id/complete';
    try {
      final response = await _dio.post<dynamic>('/orders/$id/complete');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    } on ApiException catch (e) {
      // Menerjemahkan halaman HTML 200 itu jadi kegagalan transisi yang bisa
      // dipahami, alih-alih "respons server bukan objek JSON".
      if (e.error.code == ClientErrorCode.badResponse) {
        throw ApiException(DataError(
          code: ApiErrorCode.invalidTransition,
          message: 'Status pesanan tidak memungkinkan aksi ini',
          statusCode: e.error.statusCode,
          kind: DataErrorKind.api,
        ));
      }
      rethrow;
    }
  }

  /// `GET /orders/{id}/tracking`.
  ///
  /// Membalas `data: null` selama belum ada pengiriman — itu keadaan normal,
  /// bukan error.
  Future<ApiEnvelope<dynamic>> fetchTracking(int id) async {
    final context = 'GET /orders/$id/tracking';
    try {
      final response = await _dio.get<dynamic>('/orders/$id/tracking');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
