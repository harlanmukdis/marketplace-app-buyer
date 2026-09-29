import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';

/// Panggilan HTTP untuk toko **sisi pembeli**: profil publik, transparansi,
/// dan mengikuti toko.
///
/// Produk sebuah toko **tidak** diambil di sini — pakai `CatalogService`
/// dengan `store_id`, supaya kartu produk storefront dan katalog berasal dari
/// satu model. `/stores/{id}/products` adalah endpoint penjual (`403`).
class StoreService {
  StoreService(this._dio);

  final Dio _dio;

  /// `GET /stores/{id}` — publik. Toko nonaktif dibalas `404 STORE_NOT_FOUND`.
  Future<ApiEnvelope<StoreModel>> fetchStore(int id) async {
    final context = 'GET /stores/$id';
    try {
      final response = await _dio.get<dynamic>('/stores/$id');
      return parseEnvelope(
        response,
        (raw) => StoreModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /stores/{id}/partners-performance` — publik.
  Future<ApiEnvelope<StorePerformanceModel>> fetchPerformance(int id) async {
    final context = 'GET /stores/$id/partners-performance';
    try {
      final response =
          await _dio.get<dynamic>('/stores/$id/partners-performance');
      return parseEnvelope(
        response,
        (raw) => StorePerformanceModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /stores/{id}/follow`.
  ///
  /// ⚠️ **Tidak idempoten**: mengikuti toko yang sudah diikuti dibalas
  /// `422 VALIDATION_ERROR`. Layar karena itu hanya menawarkan "Ikuti" saat
  /// `is_following` false.
  Future<ApiEnvelope<dynamic>> follow(int id) async {
    final context = 'POST /stores/$id/follow';
    try {
      final response = await _dio.post<dynamic>('/stores/$id/follow');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `DELETE /stores/{id}/follow` — `200` walau belum mengikuti.
  Future<ApiEnvelope<dynamic>> unfollow(int id) async {
    final context = 'DELETE /stores/$id/follow';
    try {
      final response = await _dio.delete<dynamic>('/stores/$id/follow');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// Ukuran halaman `GET /me/following` yang dipatok server.
  static const int followingPageSize = 20;

  /// `GET /me/following?page=` — terbaru diikuti dulu.
  Future<ApiEnvelope<List<FollowedStoreModel>>> fetchFollowing(
      {int page = 1}) async {
    const context = 'GET /me/following';
    try {
      final response = await _dio.get<dynamic>(
        '/me/following',
        queryParameters: {'page': page},
      );
      return parseEnvelopeList(response, FollowedStoreModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
