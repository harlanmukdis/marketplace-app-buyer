import 'package:marketplace_app_member/core/data/datasources/remote/service/home_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/home_repository.dart';

class HomeRepositoryImpl with RepositoryGuard implements HomeRepository {
  HomeRepositoryImpl(this._service);

  final HomeService _service;

  @override
  Future<DataState<List<HomeSectionModel>>> fetchLayout() =>
      guardList(_service.fetchLayout);
}
