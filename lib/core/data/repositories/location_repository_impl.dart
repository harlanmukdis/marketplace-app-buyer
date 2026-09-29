import 'package:marketplace_app_member/core/data/datasources/remote/service/location_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/location/location_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/location_repository.dart';

/// Menyimpan hasil di memori: master lokasi jarang berubah, dan formulir
/// alamat bisa dibuka berkali-kali dalam satu sesi. Kegagalan tidak disimpan,
/// jadi pembukaan berikutnya mencoba lagi.
class LocationRepositoryImpl
    with RepositoryGuard
    implements LocationRepository {
  LocationRepositoryImpl(this._service);

  final LocationService _service;

  DataState<List<ProvinceModel>>? _provinces;
  final Map<int?, DataState<List<CityModel>>> _cities = {};

  @override
  Future<DataState<List<ProvinceModel>>> fetchProvinces() async {
    final cached = _provinces;
    if (cached != null) return cached;
    final result = await guardList(_service.fetchProvinces);
    if (result is! DataFailed) _provinces = result;
    return result;
  }

  @override
  Future<DataState<List<CityModel>>> fetchCities({int? provinceId}) async {
    final cached = _cities[provinceId];
    if (cached != null) return cached;
    final result =
        await guardList(() => _service.fetchCities(provinceId: provinceId));
    if (result is! DataFailed) _cities[provinceId] = result;
    return result;
  }
}
