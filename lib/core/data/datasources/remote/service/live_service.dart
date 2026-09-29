import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';

/// Daftar sesi live commerce untuk pembeli.
///
/// 🔶 **Endpoint usulan** — `GET /live-sessions` belum terdaftar di
/// `routes.php` (yang ada hanya `/live-sessions/{id}` dan rute penjual).
/// Path-nya sengaja memakai resource `live-sessions` yang sudah ada, bukan
/// `/live/sessions`, supaya backend cukup menambah aksi `index_get` di
/// controller `Live` yang sama. Di debug dijawab `discoveryMockRoutes`;
/// tanpa mock server membalas 404 HTML (`DataError.isRouteNotFound`) dan
/// layar menyembunyikan seksinya.
class LiveService {
  LiveService(this._dio);

  final Dio _dio;

  /// Ukuran halaman usulan.
  static const int pageSize = 20;

  /// [statuses] dikirim dipisah koma (`live,scheduled`).
  Future<ApiEnvelope<List<LiveSessionModel>>> fetchSessions({
    List<String> statuses = const ['live'],
    int? storeId,
    int page = 1,
  }) async {
    const context = 'GET /live-sessions';
    try {
      final response = await _dio.get<dynamic>(
        '/live-sessions',
        queryParameters: {
          'status': statuses.join(','),
          if (storeId != null) 'store_id': storeId,
          'page': page,
        },
      );
      return parseEnvelopeList(response, LiveSessionModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
