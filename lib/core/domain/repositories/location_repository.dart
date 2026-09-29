import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/location/location_models.dart';

/// Master provinsi & kota untuk formulir alamat.
abstract class LocationRepository {
  Future<DataState<List<ProvinceModel>>> fetchProvinces();

  /// Tanpa [provinceId]: seluruh kota aktif.
  Future<DataState<List<CityModel>>> fetchCities({int? provinceId});
}
