/// [HomeLayoutCubit] (home CMS, endpoint sungguhan) dan [LiveSessionsCubit]
/// (endpoint usulan) terhadap repository palsu.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/home_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/live_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/home_layout_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/live_sessions_cubit.dart';

class _Home implements HomeRepository {
  DataState<List<HomeSectionModel>> result = const DataEmpty();

  @override
  Future<DataState<List<HomeSectionModel>>> fetchLayout() async => result;
}

class _Live implements LiveRepository {
  DataState<List<LiveSessionModel>> result = const DataEmpty();

  @override
  Future<DataState<List<LiveSessionModel>>> fetchLiveNow({int page = 1}) async => result;

  @override
  Future<DataState<List<LiveSessionModel>>> fetchForStore(int storeId) async => result;
}

const _routeNotFound = DataError(
  code: 'CLIENT_BAD_RESPONSE',
  message: 'x',
  kind: DataErrorKind.server,
  statusCode: 404,
);

void main() {
  late _Home home;
  late _Live live;

  setUp(() {
    home = _Home();
    live = _Live();
    injector
      ..registerSingleton<HomeRepository>(home)
      ..registerSingleton<LiveRepository>(live);
  });

  tearDown(() => injector.reset());

  group('HomeLayoutCubit', () {
    test('[] dari server (keadaan normal di dev) → hidden', () async {
      final cubit = HomeLayoutCubit();
      await cubit.load();
      expect(cubit.state, const HomeLayoutState.hidden());
      await cubit.close();
    });

    test('gagal → hidden, bukan error di puncak beranda', () async {
      home.result = const DataFailed(_routeNotFound);
      final cubit = HomeLayoutCubit();
      await cubit.load();
      expect(cubit.state, isA<HomeLayoutHidden>());
      await cubit.close();
    });

    test('section tanpa isi dan jenis tak dikenal dilewati', () async {
      home.result = DataSuccess([
        HomeSectionModel.fromJson(const {'section_id': 1, 'type': 'flash_sale_widget', 'flash_sales': []}),
        HomeSectionModel.fromJson(const {'section_id': 2, 'type': 'baru', 'banners': [
          {'id': 1, 'image_url': 'x', 'action_type': 'URL', 'action_value': 'x'},
        ]}),
        HomeSectionModel.fromJson(const {'section_id': 3, 'type': 'hero_banner', 'banners': [
          {'id': 1, 'image_url': 'x', 'action_type': 'PRODUCT', 'action_value': '4'},
        ]}),
      ]);
      final cubit = HomeLayoutCubit();
      await cubit.load();
      final state = cubit.state as HomeLayoutLoaded;
      expect(state.sections.map((s) => s.sectionId), [3]);
      await cubit.close();
    });
  });

  group('LiveSessionsCubit', () {
    test('tayang dulu, lalu jadwal terdekat; meta simulasi diteruskan', () async {
      live.result = DataSuccess([
        LiveSessionModel(id: 1, status: 'scheduled', scheduledAt: DateTime.utc(2026, 10, 2)),
        LiveSessionModel(id: 2, status: 'live', startedAt: DateTime.utc(2026, 9, 29, 1)),
        LiveSessionModel(id: 3, status: 'scheduled', scheduledAt: DateTime.utc(2026, 10, 1)),
      ], meta: const {'mock': true});
      final cubit = LiveSessionsCubit.forStore(3);
      await cubit.load();
      final state = cubit.state as LiveSessionsLoaded;
      expect(state.sessions.map((s) => s.id), [2, 3, 1]);
      expect(state.live.map((s) => s.id), [2]);
      expect(state.meta['mock'], isTrue);
      await cubit.close();
    });

    test('rute belum ada (mock mati) → unavailable', () async {
      live.result = const DataFailed(_routeNotFound);
      final cubit = LiveSessionsCubit.liveNow();
      await cubit.load();
      expect(cubit.state, isA<LiveSessionsUnavailable>());
      expect(cubit.state.live, isEmpty);
      await cubit.close();
    });
  });
}
