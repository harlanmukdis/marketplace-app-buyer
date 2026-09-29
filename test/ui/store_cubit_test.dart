/// Perilaku cubit toko ([StoreProfileCubit], [StoreProductsCubit],
/// [FollowedStoresCubit]) terhadap repository palsu.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/followed_stores_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/store_products_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/store_profile_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/widgets/store_widgets.dart';

import 'support/fake_catalog_repository.dart';

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

StorePerformanceModel _performance({int reviews = 0, int orders = 0}) =>
    StorePerformanceModel(
      ratingAverage: reviews > 0 ? 4.8 : 0,
      totalReviews: reviews,
      ratingDistribution: const {},
      totalOrders: orders,
      successRatePercent: orders > 0 ? 98.7 : 0,
      cancellationRatePercent: 0,
      responseRatePercent: 0,
    );

class _FakeStoreRepository implements StoreRepository {
  DataState<StoreModel> store = const DataSuccess(StoreModel(id: 1, name: 'Toko A'));
  DataState<StorePerformanceModel> performance = DataSuccess(_performance());
  DataState<StoreModel>? followResult;
  final Map<int, DataState<List<FollowedStoreModel>>> pages = {};
  final List<String> calls = [];

  @override
  Future<DataState<StoreModel>> fetchStore(int id) async {
    calls.add('store:$id');
    return store;
  }

  @override
  Future<DataState<StorePerformanceModel>> fetchPerformance(int id) async {
    calls.add('performance:$id');
    return performance;
  }

  @override
  Future<DataState<StoreModel>> setFollowing(int id, {required bool follow}) async {
    calls.add('${follow ? 'follow' : 'unfollow'}:$id');
    return followResult ??
        DataSuccess(StoreModel(id: id, name: 'Toko A', isFollowing: follow));
  }

  @override
  Future<DataState<List<FollowedStoreModel>>> fetchFollowing({int page = 1}) async {
    calls.add('following:$page');
    return pages[page] ?? const DataEmpty();
  }
}

class _ListingCatalog extends FakeCatalogRepository {
  final Map<int, DataState<List<ProductModel>>> pages = {};
  final List<({int? storeId, int page})> listingCalls = [];

  @override
  Future<DataState<List<ProductModel>>> fetchProducts({
    String? query,
    int? categoryId,
    int? storeId,
    double? minPrice,
    double? maxPrice,
    int? minRating,
    String? city,
    String? province,
    String? courier,
    String? destCity,
    String? destProvince,
    ProductSort sort = ProductSort.latest,
    int page = 1,
    int perPage = 20,
  }) async {
    listingCalls.add((storeId: storeId, page: page));
    return pages[page] ?? const DataEmpty();
  }
}

List<FollowedStoreModel> _followed(Iterable<int> ids) =>
    [for (final id in ids) FollowedStoreModel(id: id, name: 'Toko $id')];

void main() {
  late _FakeStoreRepository stores;
  late _ListingCatalog catalog;

  setUp(() {
    stores = _FakeStoreRepository();
    catalog = _ListingCatalog();
    injector.registerSingleton<StoreRepository>(stores);
    injector.registerSingleton<CatalogRepository>(catalog);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('StoreProfileCubit', () {
    test('kinerja gagal tidak menggagalkan storefront', () async {
      stores.performance = DataFailed(_error('SERVER_ERROR'));
      final cubit = StoreProfileCubit(1);
      await cubit.load();

      final state = cubit.state;
      expect(state, isA<StoreProfileLoaded>());
      expect((state as StoreProfileLoaded).performance, isNull);
      await cubit.close();
    });

    test('toko gagal dimuat = layar error', () async {
      stores.store = DataFailed(_error('NOT_FOUND'));
      final cubit = StoreProfileCubit(1);
      await cubit.load();

      expect(cubit.state, isA<StoreProfileError>());
      await cubit.close();
    });

    test('arah follow diturunkan dari is_following server', () async {
      // POST /follow tidak idempoten: 422 kalau sudah mengikuti. Toko yang
      // sudah diikuti harus memicu unfollow, bukan follow kedua.
      stores.store = const DataSuccess(StoreModel(id: 1, name: 'A', isFollowing: true));
      final cubit = StoreProfileCubit(1);
      await cubit.load();

      await cubit.toggleFollow();

      expect(stores.calls, contains('unfollow:1'));
      expect((cubit.state as StoreProfileLoaded).store.isFollowing, isFalse);
      await cubit.close();
    });

    test('ketukan kedua selagi follow berjalan diabaikan', () async {
      final cubit = StoreProfileCubit(1);
      await cubit.load();

      await Future.wait([cubit.toggleFollow(), cubit.toggleFollow()]);

      expect(stores.calls.where((c) => c.startsWith('follow:')).length, 1);
      await cubit.close();
    });

    test('follow gagal mempertahankan toko dan mengisi actionError', () async {
      stores.followResult = DataFailed(_error('UNAUTHENTICATED'));
      final cubit = StoreProfileCubit(1);
      await cubit.load();

      await cubit.toggleFollow();

      final state = cubit.state as StoreProfileLoaded;
      expect(state.store.name, 'Toko A');
      expect(state.isFollowBusy, isFalse);
      expect(state.actionError?.code, 'UNAUTHENTICATED');
      await cubit.close();
    });
  });

  group('storeMetricsOf', () {
    test('toko tanpa ulasan dan tanpa pesanan tidak menampilkan angka nol', () {
      // design_buyer.md §5: tidak pernah "0,0" — dan "0%" transaksi sukses
      // untuk toko baru terbaca sebagai toko buruk.
      expect(storeMetricsOf(_performance()), isEmpty);
    });

    test('rating dan transaksi sukses muncul begitu ada dasarnya', () {
      final metrics = storeMetricsOf(_performance(reviews: 12, orders: 30));
      expect(metrics.map((m) => m.label), containsAll(['12 ulasan', 'Transaksi sukses']));
    });
  });

  group('StoreProductsCubit', () {
    test('memuat produk toko dan paginasi dari meta.total', () async {
      catalog.pages[1] = DataSuccess(
        [for (var i = 1; i <= 2; i++) ProductModel(id: i, storeId: 5)],
        meta: const {'total': 3},
      );
      catalog.pages[2] = const DataSuccess(
        [ProductModel(id: 3, storeId: 5)],
        meta: {'total': 3},
      );
      final cubit = StoreProductsCubit(5, pageSize: 2);
      await cubit.load();

      expect(catalog.listingCalls.first.storeId, 5);
      expect((cubit.state as StoreProductsLoaded).hasMore, isTrue);

      await cubit.loadMore();
      final state = cubit.state as StoreProductsLoaded;
      expect(state.products.map((p) => p.id), [1, 2, 3]);
      expect(state.hasMore, isFalse);
      expect(state.total, 3);
      await cubit.close();
    });

    test('toko tanpa produk = empty, bukan error', () async {
      final cubit = StoreProductsCubit(5);
      await cubit.load();
      expect(cubit.state, isA<StoreProductsEmpty>());
      await cubit.close();
    });
  });

  group('FollowedStoresCubit', () {
    test('halaman penuh berarti mungkin ada halaman berikutnya', () async {
      final size = FollowedStoresCubit.pageSize;
      stores.pages[1] = DataSuccess(_followed(List.generate(size, (i) => i + 1)));
      // Halaman 2 mengulang satu toko dari halaman 1 (OFFSET bergeser).
      stores.pages[2] = DataSuccess(_followed([size, size + 1]));
      final cubit = FollowedStoresCubit();
      await cubit.load();
      expect((cubit.state as FollowedStoresLoaded).hasMore, isTrue);

      await cubit.loadMore();
      final state = cubit.state as FollowedStoresLoaded;
      expect(state.stores.length, size + 1, reason: 'baris berulang dibuang');
      expect(state.hasMore, isFalse);
      await cubit.close();
    });

    test('daftar kosong tetap loaded dengan list hampa', () async {
      final cubit = FollowedStoresCubit();
      await cubit.load();
      final state = cubit.state;
      expect(state, isA<FollowedStoresLoaded>());
      expect((state as FollowedStoresLoaded).stores, isEmpty);
      await cubit.close();
    });

    test('unfollow membuang baris dan mengembalikan toko terbaru', () async {
      stores.pages[1] = DataSuccess(_followed([1, 2]));
      final cubit = FollowedStoresCubit();
      await cubit.load();

      final updated = await cubit.unfollow(1);

      expect(stores.calls, contains('unfollow:1'));
      expect(updated?.isFollowing, isFalse);
      expect((cubit.state as FollowedStoresLoaded).stores.map((s) => s.id), [2]);
      await cubit.close();
    });

    test('unfollow gagal mempertahankan baris', () async {
      stores.pages[1] = DataSuccess(_followed([1]));
      stores.followResult = DataFailed(_error('SERVER_ERROR'));
      final cubit = FollowedStoresCubit();
      await cubit.load();

      final updated = await cubit.unfollow(1);

      final state = cubit.state as FollowedStoresLoaded;
      expect(updated, isNull);
      expect(state.stores.map((s) => s.id), [1]);
      expect(state.mutatingIds, isEmpty);
      expect(state.actionError, isNotNull);
      await cubit.close();
    });
  });
}
