/// Kontrak katalog terhadap marketplace-api yang **benar-benar jalan** di
/// `API_BASE_URL`.
///
/// ```bash
/// flutter test test/integration/
/// ```
///
/// Butuh backend hidup dan database ter-seed. Tujuannya bukan menguji logika
/// aplikasi (itu `test/data/` dan `test/ui/`), melainkan **mematok kejanggalan
/// bentuk data** yang sudah tiga kali menyesatkan proyek ini — supaya kalau
/// backend mengubahnya diam-diam, yang merah adalah test, bukan layar user.
///
/// Seluruh endpoint di sini publik, jadi tidak ada login sama sekali.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_facets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';

import 'support/seeded_product.dart';

void main() {
  late CatalogService catalog;
  late Dio dio;

  setUp(() {
    dio = DioClient.createBare(Env.apiBaseUrl);
    catalog = CatalogService(dio);
  });

  tearDown(() => dio.close(force: true));

  group('GET /products', () {
    test('mengembalikan produk beserta meta paginasi', () async {
      final result = await catalog.fetchProducts(perPage: 5);

      expect(result.data, isNotEmpty,
          reason: 'database backend harus sudah di-seed');
      expect(result.meta['total'], isNotNull);
      expect(result.data.length, lessThanOrEqualTo(5));
    });

    test('item listing TIDAK membawa gambar, stok, varian, maupun kurir',
        () async {
      // Ini yang bikin kartu produk harus pakai placeholder, dan yang bikin
      // "habis" tidak boleh disimpulkan dari listing.
      final result = await catalog.fetchProducts(perPage: 5);

      for (final product in result.data) {
        expect(product.images, isEmpty);
        expect(product.variants, isEmpty);
        expect(product.couriers, isEmpty);
        expect(product.stock, isNull);
        expect(product.isOutOfStock, isFalse);
      }
    });

    test('facet rating selalu ada, dan `count`-nya integer', () async {
      final result = await catalog.fetchProducts(perPage: 1);
      final facets = ProductFacets.fromMeta(result.meta);

      expect(facets.ratings, isNotEmpty);
      expect(facets.ratings.map((r) => r.minRating), containsAll([1, 5]));
    });

    test('facet category HANYA muncul saat ada q', () async {
      final tanpaQ = ProductFacets.fromMeta(
        (await catalog.fetchProducts(perPage: 1)).meta,
      );
      expect(tanpaQ.categories, isEmpty);

      final denganQ = ProductFacets.fromMeta(
        (await catalog.fetchProducts(query: 'kopi', perPage: 5)).meta,
      );
      // Kalau seed berubah dan 'kopi' tidak lagi cocok, facet-nya boleh kosong
      // — yang diuji di sini adalah bentuknya terbaca, bukan isinya.
      for (final facet in denganQ.categories) {
        expect(facet.categoryId, greaterThan(0));
        expect(facet.count, greaterThanOrEqualTo(0));
      }
    });

    test('pencarian lewat ?q= bekerja tanpa Elasticsearch', () async {
      // Ini alasan `/search/products` tidak dipakai: ia 503 selama ES mati,
      // sedangkan jalur ini berbasis MySQL dan selalu tersedia.
      final result = await catalog.fetchProducts(query: 'kopi', perPage: 5);
      expect(result.meta['total'], isNotNull);
    });

    test('urutan harga menaik benar-benar terurut', () async {
      final result = await catalog.fetchProducts(
        sort: ProductSort.priceAsc,
        perPage: 10,
      );
      final prices = result.data.map((p) => p.basePrice).toList();
      final sorted = [...prices]..sort();
      expect(prices, sorted);
    });

    test('filter kategori tidak melempar walau kategorinya kosong', () async {
      final result = await catalog.fetchProducts(categoryId: 999999);
      expect(result.data, isEmpty);
    });
  });

  group('GET /products/{id}', () {
    late ProductModel detail;

    setUp(() async {
      final listing = await catalog.fetchProducts(perPage: 1);
      final id = listing.data.first.id;
      detail = (await catalog.fetchProduct(id)).data;
    });

    test('membawa stok sebagai INTEGER, bukan string', () async {
      expect(detail.stock, isNotNull);
      expect(detail.stock, isA<int>());
    });

    test('selalu punya minimal satu varian, walau produk tanpa pilihan',
        () async {
      // `cart_items` merujuk product_variant_id, jadi produk tanpa varian
      // akan membuat "tambah ke keranjang" mustahil.
      expect(detail.variants, isNotEmpty);
      expect(detail.variants.first.stock, isA<int>());
    });

    test('varian BERSTOK membawa lokasi gudang pengirim', () async {
      // Ditambahkan backend bersama endpoint shipping-estimate. Dipakai
      // menampilkan "Dikirim dari …" tanpa memanggil endpoint apa pun.
      //
      // Harus memakai varian berstok: gudang asal diturunkan dari gudang yang
      // menyimpan varian itu, jadi varian yang stoknya habis di semua gudang
      // memang tidak punya asal kirim — perilaku yang dipatok di
      // `test/data/catalog_model_test.dart`.
      final seeded = await findVariantWithStock(catalog);
      final stocked = (await catalog.fetchProduct(seeded.productId)).data;
      final variant =
          stocked.variants.firstWhere((v) => v.id == seeded.variantId);

      expect(variant.shippingOrigin, isNotEmpty);
    });

    test('cukup untuk merender halaman detail tanpa panggilan susulan',
        () async {
      expect(detail.name, isNotEmpty);
      expect(detail.basePrice, greaterThan(0));
      // `images` boleh kosong untuk produk tertentu, tapi field-nya harus ada
      // dan terbaca sebagai list.
      expect(detail.images, isA<List<ProductImageModel>>());
      expect(detail.couriers, isA<List<CourierModel>>());
    });

    test('produk yang tidak ada dibalas error, bukan data kosong', () async {
      await expectLater(
        catalog.fetchProduct(99999999),
        throwsA(anything),
      );
    });
  });

  test('variant_options yang berisi JSON string terbaca sebagai map', () async {
    // Dicari di seluruh katalog karena tidak semua produk punya varian
    // beropsi; kalau seed berubah dan tidak ada satu pun, test ini lewat
    // tanpa menuduh backend salah.
    final listing = await catalog.fetchProducts(perPage: 100);

    for (final item in listing.data.take(20)) {
      final detail = (await catalog.fetchProduct(item.id)).data;
      final withOptions = detail.variants
          .where((v) => v.variantOptions != null)
          .toList();
      if (withOptions.isEmpty) continue;

      expect(withOptions.first.variantOptions, isA<Map<String, dynamic>>());
      expect(withOptions.first.optionLabel, isNotEmpty);
      return;
    }
  }, timeout: const Timeout(Duration(seconds: 60)));

  group('GET /categories', () {
    test('mengembalikan pohon, bukan daftar datar', () async {
      final result = await catalog.fetchCategories();

      expect(result.data, isNotEmpty);
      expect(result.data.any((c) => c.hasChildren), isTrue,
          reason: 'kategori induk harus membawa children');
      expect(result.data.every((c) => c.parentId == null), isTrue,
          reason: 'tingkat teratas tidak boleh punya parent');
    });
  });

  group('GET /couriers', () {
    test('mengembalikan daftar kurir aktif', () async {
      final result = await catalog.fetchCouriers();
      expect(result.data, isNotEmpty);
      expect(result.data.first.code, isNotEmpty);
    });
  });

  test('cache detail menahan permintaan kedua untuk id yang sama', () async {
    final listing = await catalog.fetchProducts(perPage: 1);
    final id = listing.data.first.id;

    final first = await catalog.fetchProduct(id);
    final second = await catalog.fetchProduct(id);
    expect(identical(first.data, second.data), isTrue);

    final refreshed = await catalog.fetchProduct(id, forceRefresh: true);
    expect(identical(first.data, refreshed.data), isFalse);
  });
}
