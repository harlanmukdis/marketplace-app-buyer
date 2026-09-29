import 'package:marketplace_app_member/core/data/datasources/remote/service/live_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/live_repository.dart';

class LiveRepositoryImpl with RepositoryGuard implements LiveRepository {
  LiveRepositoryImpl(this._service);

  final LiveService _service;

  @override
  Future<DataState<List<LiveSessionModel>>> fetchLiveNow({int page = 1}) =>
      guardList(() => _service.fetchSessions(page: page));

  @override
  Future<DataState<List<LiveSessionModel>>> fetchForStore(int storeId) =>
      guardList(
        () => _service.fetchSessions(
            statuses: const ['live', 'scheduled'], storeId: storeId),
      );
}
