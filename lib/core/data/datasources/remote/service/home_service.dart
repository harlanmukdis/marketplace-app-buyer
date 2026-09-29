import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';

/// Home CMS (docs/16): `GET /home/layout`.
///
/// Publik, tapi **opsional login**: dengan token, section `category_bar`
/// bermode `AUTO_FAVORITE` dipersonalisasi dari `user_category_scores`; tanpa
/// token jatuh ke kategori terlaris platform. Karena itu dipanggil lewat Dio
/// "api" biasa, yang menyisipkan token kalau ada.
///
/// Tidak di-mock: endpoint-nya sungguhan, hanya datanya yang kosong di dev.
class HomeService {
  HomeService(this._dio);

  final Dio _dio;

  Future<ApiEnvelope<List<HomeSectionModel>>> fetchLayout() async {
    const context = 'GET /home/layout';
    try {
      final response = await _dio.get<dynamic>('/home/layout');
      return parseEnvelopeList(response, HomeSectionModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
