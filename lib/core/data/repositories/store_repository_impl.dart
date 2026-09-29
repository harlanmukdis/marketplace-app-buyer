import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/store_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';

class StoreRepositoryImpl with RepositoryGuard implements StoreRepository {
  StoreRepositoryImpl(this._service);

  final StoreService _service;

  @override
  Future<DataState<StoreModel>> fetchStore(int id) =>
      guard(() => _service.fetchStore(id));

  @override
  Future<DataState<StorePerformanceModel>> fetchPerformance(int id) =>
      guard(() => _service.fetchPerformance(id));

  @override
  Future<DataState<StoreModel>> setFollowing(int id,
      {required bool follow}) async {
    try {
      follow ? await _service.follow(id) : await _service.unfollow(id);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return guard(() => _service.fetchStore(id));
  }

  @override
  Future<DataState<List<FollowedStoreModel>>> fetchFollowing({int page = 1}) =>
      guardList(() => _service.fetchFollowing(page: page));
}
