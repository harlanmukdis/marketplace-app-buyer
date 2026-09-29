/// Perilaku [CatalogHomeCubit] terhadap repository palsu.
///
/// Fokusnya bukan "apakah HTTP-nya jalan" (itu `test/integration/`), tapi
/// keputusan yang mudah salah: paginasi, kegagalan sebagian, dan membedakan
/// "tidak ada hasil" dari "gagal memuat".
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/catalog_home_cubit.dart';

ProductModel _product(int id) => ProductModel(id: id, name: 'Produk $id');

const _category = CategoryModel(id: 1, name: 'Elektronik');

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeCatalogRepository implements CatalogRepository {
  DataState<List<CategoryModel>> categoriesResult =
      const DataSuccess([_category]);

  /// Hasil per halaman; halaman yang tidak terdaftar dianggap kosong.
  Map<int, DataState<List<ProductModel>>> pages = {};

  /// Halaman yang benar-benar diminta, untuk memastikan `loadMore` tidak
  /// menembak dua kali.
  final List<int> requestedPages = [];

  CatalogQuery? lastQuery;

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
    requestedPages.add(page);
    lastQuery = CatalogQuery(
      text: query,
      categoryId: categoryId,
      minRating: minRating,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
    );
    return pages[page] ?? const DataEmpty();
  }

  @override
  Future<DataState<ProductModel>> fetchProduct(int id,
          {bool forceRefresh = false}) async =>
      DataSuccess(_product(id));

  @override
  Future<DataState<List<CategoryModel>>> fetchCategories() async =>
      categoriesResult;

  @override
  Future<DataState<List<CourierModel>>> fetchCouriers() async =>
      const DataEmpty();

  @override
  Future<DataState<List<ShippingOptionModel>>> fetchShippingEstimate(
    int productId, {
    required int addressId,
    int? variantId,
  }) async =>
      const DataEmpty();
}

void main() {
  late _FakeCatalogRepository repository;

  setUp(() {
    repository = _FakeCatalogRepository();
    injector.registerSingleton<CatalogRepository>(repository);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('load', () {
    test('sukses membawa produk, kategori, dan facet sekaligus', () async {
      repository.pages = {
        1: DataSuccess(
          [_product(1), _product(2)],
          meta: const {
            'total': 2,
            'facets': {
              'rating': [
                {'min_rating': 4, 'count': 1},
              ],
            },
          },
        ),
      };

      final cubit = CatalogHomeCubit();
      await cubit.load();

      final state = cubit.state as CatalogLoaded;
      expect(state.products.length, 2);
      expect(state.categories, [_category]);
      expect(state.facets.ratings.single.count, 1);
      // total 2, sudah termuat 2 → tidak ada halaman lagi.
      expect(state.hasMore, isFalse);
      await cubit.close();
    });

    test('hasil kosong jadi CatalogEmpty, bukan error', () async {
      repository.pages = {1: const DataEmpty()};

      final cubit = CatalogHomeCubit();
      await cubit.load();

      // Bedanya penting: layar menawarkan "hapus filter", bukan "coba lagi".
      expect(cubit.state, isA<CatalogEmpty>());
      await cubit.close();
    });

    test('gagal memuat produk jadi CatalogError', () async {
      repository.pages = {1: DataFailed(_error('NETWORK'))};

      final cubit = CatalogHomeCubit();
      await cubit.load();

      expect(cubit.state, isA<CatalogError>());
      await cubit.close();
    });

    test('kategori gagal TIDAK menggagalkan layar', () async {
      // Katalog masih berguna tanpa baris kategori; yang tidak berguna adalah
      // layar kosong karena satu permintaan pelengkap gagal.
      repository.categoriesResult = DataFailed(_error('NETWORK'));
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };

      final cubit = CatalogHomeCubit();
      await cubit.load();

      final state = cubit.state as CatalogLoaded;
      expect(state.products.length, 1);
      expect(state.categories, isEmpty);
      await cubit.close();
    });

    test('total lebih besar dari yang termuat berarti masih ada halaman', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 40}),
      };

      final cubit = CatalogHomeCubit();
      await cubit.load();

      expect((cubit.state as CatalogLoaded).hasMore, isTrue);
      await cubit.close();
    });

    test('meta tanpa total dianggap habis, bukan memuat tanpa akhir', () async {
      repository.pages = {
        1: DataSuccess([_product(1)]),
      };

      final cubit = CatalogHomeCubit();
      await cubit.load();

      expect((cubit.state as CatalogLoaded).hasMore, isFalse);
      await cubit.close();
    });
  });

  group('loadMore', () {
    Future<CatalogHomeCubit> loadedWithMore() async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 3}),
        2: DataSuccess([_product(2)], meta: const {'total': 3}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.load();
      return cubit;
    }

    test('menambah halaman berikutnya ke daftar yang sudah ada', () async {
      final cubit = await loadedWithMore();
      await cubit.loadMore();

      final state = cubit.state as CatalogLoaded;
      expect(state.products.map((p) => p.id), [1, 2]);
      expect(state.page, 2);
      expect(state.isLoadingMore, isFalse);
      await cubit.close();
    });

    test('diabaikan kalau sudah tidak ada halaman lagi', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.load();
      repository.requestedPages.clear();

      await cubit.loadMore();

      // Listener scroll memanggil ini terus-menerus di dasar daftar.
      expect(repository.requestedPages, isEmpty);
      await cubit.close();
    });

    test('gagal menambah halaman TIDAK menghapus daftar yang sudah tampil',
        () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 3}),
        2: DataFailed(_error('NETWORK')),
      };
      final cubit = CatalogHomeCubit();
      await cubit.load();
      await cubit.loadMore();

      final state = cubit.state as CatalogLoaded;
      expect(state.products.length, 1, reason: 'posisi gulir user harus utuh');
      expect(state.loadMoreError, isNotNull);
      expect(state.isLoadingMore, isFalse);
      await cubit.close();
    });

    test('halaman berikutnya yang kosong menutup paginasi', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 99}),
        // total bohong; halaman 2 ternyata kosong.
      };
      final cubit = CatalogHomeCubit();
      await cubit.load();
      await cubit.loadMore();

      final state = cubit.state as CatalogLoaded;
      expect(state.hasMore, isFalse);
      await cubit.close();
    });
  });

  group('filter', () {
    test('search meneruskan teks ke repository', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.search('kopi');

      expect(repository.lastQuery?.text, 'kopi');
      await cubit.close();
    });

    test('search kosong melepas filter teks', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.search('kopi');
      await cubit.search('   ');

      expect(repository.lastQuery?.text, isNull);
      await cubit.close();
    });

    test('selectCategory(null) benar-benar melepas filter kategori', () async {
      // copyWith freezed harus bisa menyetel balik ke null di sini — kalau
      // tidak, tombol "Semua" tidak akan pernah bekerja.
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.selectCategory(7);
      expect(repository.lastQuery?.categoryId, 7);

      await cubit.selectCategory(null);
      expect(repository.lastQuery?.categoryId, isNull);
      await cubit.close();
    });

    test('mengganti urutan mempertahankan filter lain', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.search('kopi');
      await cubit.changeSort(ProductSort.priceAsc);

      expect(repository.lastQuery?.text, 'kopi');
      expect(repository.lastQuery?.sort, ProductSort.priceAsc);
      await cubit.close();
    });

    test('clearFilters mengembalikan ke listing default', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.search('kopi');
      await cubit.selectCategory(3);
      await cubit.clearFilters();

      expect(repository.lastQuery?.text, isNull);
      expect(repository.lastQuery?.categoryId, isNull);
      expect(repository.lastQuery?.sort, ProductSort.recommended);
      await cubit.close();
    });

    test('retry mengulang permintaan terakhir apa adanya', () async {
      repository.pages = {
        1: DataSuccess([_product(1)], meta: const {'total': 1}),
      };
      final cubit = CatalogHomeCubit();
      await cubit.search('kopi');
      await cubit.retry();

      expect(repository.lastQuery?.text, 'kopi');
      await cubit.close();
    });
  });
}
