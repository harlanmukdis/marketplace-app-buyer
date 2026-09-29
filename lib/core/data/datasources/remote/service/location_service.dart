import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/location/location_models.dart';

/// Master lokasi (publik): `GET /locations/provinces` dan
/// `GET /locations/cities?province_id=`.
///
/// Hanya baris `active = 1` yang dikirim, terurut nama. Tanpa `province_id`,
/// `cities` mengembalikan **seluruh** kota aktif — dipakai saat user memilih
/// kota sebelum provinsi (urutan field formulir alamat memang kota dulu).
class LocationService {
  LocationService(this._dio);

  final Dio _dio;

  Future<ApiEnvelope<List<ProvinceModel>>> fetchProvinces() async {
    const context = 'GET /locations/provinces';
    try {
      final response = await _dio.get<dynamic>('/locations/provinces');
      return parseEnvelopeList(response, ProvinceModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<List<CityModel>>> fetchCities({int? provinceId}) async {
    const context = 'GET /locations/cities';
    try {
      final response = await _dio.get<dynamic>(
        '/locations/cities',
        queryParameters: {if (provinceId != null) 'province_id': provinceId},
      );
      return parseEnvelopeList(response, CityModel.fromJson, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
