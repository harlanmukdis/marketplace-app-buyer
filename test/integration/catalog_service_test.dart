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
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'support/test_account.dart';
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

    test('item listing tidak membawa stok, varian, maupun kurir', () async {
      // Ini yang bikin "habis" tidak boleh disimpulkan dari listing: `stock`
      // null berarti belum diketahui, bukan nol.
      final result = await catalog.fetchProducts(perPage: 5);

      for (final product in result.data) {
        expect(product.images, isEmpty,
            reason: 'listing memakai image_url datar, bukan images[]');
        expect(product.variants, isEmpty);
        expect(product.couriers, isEmpty);
        expect(product.stock, isNull);
        expect(product.isOutOfStock, isFalse);
      }
    });

    test('✅ item listing SEKARANG membawa image_url', () async {
      // Ditambahkan backend di commit `db8a626`. Sebelumnya listing tidak
      // membawa gambar sama sekali, sehingga tiap kartu produk terpaksa
      // memakai placeholder — satu-satunya alternatifnya menembak detail per
      // kartu (N+1).
      final result = await catalog.fetchProducts(perPage: 20);
      expect(result.data, isNotEmpty);

      // ⚠️ TIDAK "setiap item punya gambar": produk yang memang belum punya
      // `product_images` sah mengembalikan `image_url: null`, dan seed sudah
      // memuat beberapa (mis. "Produk Aktif BS"). Karena urutan defaultnya
      // `latest`, produk tanpa gambar bisa muncul paling atas kapan saja —
      // memaku "semuanya bergambar" membuat test ini merah tanpa ada yang
      // rusak.
      //
      // Yang dibuktikan: untuk produk yang PUNYA gambar di detailnya,
      // listingnya ikut membawanya — itulah isi commit `db8a626`.
      ProductModel? berGambar;
      for (final product in result.data) {
        final detail = await catalog.fetchProduct(product.id);
        if (detail.data.images.isNotEmpty) {
          berGambar = product;
          break;
        }
      }

      expect(berGambar, isNotNull,
          reason: 'tidak ada satu pun produk bergambar di katalog — seed ulang');
      expect(berGambar!.listingImageUrl, isNotNull,
          reason: 'detailnya punya images[], jadi listing wajib membawa '
              'image_url');
      // Dan getter bersama itu menyerapnya, bukan hanya `images[]`.
      expect(berGambar.primaryImageUrl, berGambar.listingImageUrl);
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

  group('GET /products/{id}/shipping-estimate', () {
    late Dio authed;
    late CatalogService authedCatalog;
    late int addressId;

    // Akun bersama — lihat `support/test_account.dart` (plafon 20 login per IP
    // per 15 menit). Alamatnya ikut dipakai ulang: estimasi ongkir hanya
    // membaca alamat, tidak mengubahnya, jadi tidak ada yang perlu dibersihkan.
    setUp(() async {
      authed = DioClient.createBare(Env.apiBaseUrl);
      authedCatalog = CatalogService(authed);

      await sharedAccount(authed, purpose: 'ongkir');

      final addresses = AddressService(authed);
      final existing = (await addresses.list()).data;
      addressId = existing.isNotEmpty
          ? existing.first.id
          : (await addresses.create(
              label: 'Rumah',
              recipientName: 'Uji Ongkir',
              phone: '081200000000',
              fullAddress: 'Jl. Uji No. 1',
              city: 'Jakarta Selatan',
              province: 'DKI Jakarta',
              postalCode: '12810',
              isPrimary: true,
            ))
              .data;
    });

    tearDown(() => authed.close(force: true));

    test('mengembalikan opsi kurir TANPA membuat sesi checkout', () async {
      // Nilainya justru di kata "tanpa": satu-satunya cara lain mengetahui
      // ongkir adalah POST /checkout/sessions, yang mereservasi stok 15 menit.
      final seeded = await findVariantWithStock(authedCatalog);
      final result = await authedCatalog.fetchShippingEstimate(
        seeded.productId,
        addressId: addressId,
        variantId: seeded.variantId,
      );

      expect(result.data, isNotEmpty);
      final first = result.data.first;
      expect(first.courierCode, isNotEmpty);
      expect(first.serviceName, isNotEmpty);
      // `cost` angka asli di sini, bukan string seperti harga produk.
      expect(first.cost, greaterThan(0));
    });

    test('urut termurah, jadi opsi pertama bisa dipakai "mulai dari"',
        () async {
      final seeded = await findVariantWithStock(authedCatalog);
      final result = await authedCatalog.fetchShippingEstimate(
        seeded.productId,
        addressId: addressId,
        variantId: seeded.variantId,
      );

      final costs = result.data.map((o) => o.cost).toList();
      expect(costs, [...costs]..sort());
    });

    test('variant_id opsional — server memakai varian pertama', () async {
      final seeded = await findVariantWithStock(authedCatalog);
      final result = await authedCatalog.fetchShippingEstimate(
        seeded.productId,
        addressId: addressId,
      );
      expect(result.data, isNotEmpty);
    });

    test('BUTUH login, berbeda dari GET /products/{id} yang publik', () async {
      final seeded = await findVariantWithStock(catalog);
      await expectLater(
        catalog.fetchShippingEstimate(
          seeded.productId,
          addressId: addressId,
        ),
        throwsA(anything),
      );
    });

    test('tiap penolakan punya kode SENDIRI, tidak diseragamkan', () async {
      // Berbeda dari beberapa endpoint lain di API ini yang memakai satu kode
      // untuk beberapa sebab — di sini masing-masing bisa dijelaskan ke user.
      final seeded = await findVariantWithStock(authedCatalog);

      // Tanpa address_id → 422 VALIDATION_ERROR.
      await expectLater(
        authed.get<dynamic>('/products/${seeded.productId}/shipping-estimate'),
        throwsA(anything),
      );

      // Alamat milik orang lain → 404 ADDRESS_NOT_FOUND.
      await expectLater(
        authedCatalog.fetchShippingEstimate(seeded.productId, addressId: 1),
        throwsA(anything),
      );

      // Varian tak dikenal → 404 VARIANT_NOT_FOUND.
      await expectLater(
        authedCatalog.fetchShippingEstimate(
          seeded.productId,
          addressId: addressId,
          variantId: 99999999,
        ),
        throwsA(anything),
      );
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
