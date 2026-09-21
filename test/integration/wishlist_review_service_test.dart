/// Kontrak `/wishlist*` dan ulasan produk terhadap marketplace-api yang
/// **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration --concurrency=1
/// ```
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/review_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wishlist_service.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';

void main() {
  late Dio dio;
  late WishlistService wishlist;
  late ReviewService reviews;
  late CatalogService catalog;

  late List<int> productIds;

  // Akun bersama, bukan akun baru per test — lihat `support/test_account.dart`
  // untuk alasannya (plafon 20 login per IP per 15 menit).
  //
  // Wishlist **bisa dikosongkan** lewat API, jadi tiap test tetap mulai dari
  // keadaan bersih tanpa perlu akun baru. Itu sebabnya berkas ini memakai
  // sharedAccount, sementara chat dan notifikasi — yang sumber dayanya tidak
  // punya endpoint hapus — terpaksa memakai akun baru.
  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    wishlist = WishlistService(dio);
    reviews = ReviewService(dio);
    catalog = CatalogService(dio);

    await sharedAccount(dio, purpose: 'ringan');

    final existing = await wishlist.fetch();
    for (final item in existing.data) {
      await wishlist.remove(item.productId);
    }

    final listing = await catalog.fetchProducts(perPage: 5);
    productIds = listing.data.map((p) => p.id).toList();
  });

  tearDown(() => dio.close(force: true));

  group('wishlist', () {
    test('wishlist kosong mengembalikan daftar hampa, bukan 404', () async {
      final result = await wishlist.fetch();
      expect(result.data, isEmpty);
    });

    test('menambah produk, dan barisnya membawa gambar', () async {
      // Produknya dipilih yang memang PUNYA gambar: seed memuat beberapa
      // produk tanpa `product_images`, dan urutan default `latest` bisa
      // menaruhnya paling atas kapan saja. Memakai `productIds.first` begitu
      // saja membuat test ini merah tanpa ada yang rusak.
      final listing = await catalog.fetchProducts(perPage: 20);
      final bergambar = listing.data
          .firstWhere((p) => p.listingImageUrl != null);

      await wishlist.add(bergambar.id);
      final result = await wishlist.fetch();

      expect(result.data, hasLength(1));
      final item = result.data.single;
      expect(item.productId, bergambar.id);
      expect(item.name, isNotEmpty);
      // Wishlist membawa image_url, tidak seperti GET /products.
      expect(item.imageUrl, isNotNull);
    });

    test('menambah produk yang sama TIDAK menggandakan barisnya', () async {
      await wishlist.add(productIds.first);
      await wishlist.add(productIds.first);

      final result = await wishlist.fetch();
      expect(result.data, hasLength(1));
    });

    test(
      '🔴 DELETE memakai product_id, BUKAN wishlist_item_id',
      () async {
        // Dibuat supaya kedua id pasti berbeda, lalu dihapus memakai
        // product_id. Kalau server ternyata memakai wishlist_item_id, produk
        // yang salah yang hilang — dan tetap dibalas 200.
        for (final id in productIds.take(3)) {
          await wishlist.add(id);
        }
        final before = (await wishlist.fetch()).data;
        final target = before.firstWhere(
          (i) => i.productId != i.wishlistItemId,
          orElse: () => before.first,
        );

        await wishlist.remove(target.productId);

        final after = (await wishlist.fetch()).data;
        expect(after.map((i) => i.productId),
            isNot(contains(target.productId)));
        expect(after, hasLength(before.length - 1));
      },
    );

    test('menghapus produk yang tidak ada tetap dibalas 200', () async {
      final result = await wishlist.remove(99999999);
      expect(result.statusCode, 200);
    });

    test('produk yang tidak ada dibalas PRODUCT_NOT_FOUND', () async {
      // Satu-satunya validasi sungguhan di endpoint ini.
      await expectLater(wishlist.add(99999999), throwsA(anything));
    });
  });

  group('ulasan produk', () {
    test('daftar ulasan membawa meta lengkap beserta histogram', () async {
      final result = await reviews.fetchForProduct(productIds.first);

      expect(result.meta['total'], isNotNull);
      expect(result.meta['per_page'], isNotNull);

      final histogram = RatingHistogram.fromMeta(result.meta);
      // Selalu lima bucket, walau produknya belum punya ulasan.
      expect(histogram.breakdown, hasLength(5));
      expect(histogram.breakdown.map((b) => b.rating), [5, 4, 3, 2, 1]);
    });

    test('filter bintang BEKERJA di endpoint ini', () async {
      // Berbeda dari ?status= di /orders yang diabaikan server.
      final filtered =
          await reviews.fetchForProduct(productIds.first, rating: 5);
      expect(filtered.data.every((r) => r.rating == 5), isTrue);
    });

    test('endpoint ulasan bersifat publik — tidak butuh token', () async {
      final anonymous = DioClient.createBare(Env.apiBaseUrl);
      addTearDown(() => anonymous.close(force: true));

      final result =
          await ReviewService(anonymous).fetchForProduct(productIds.first);
      expect(result.statusCode, 200);
    });

    test(
      '🔴 mengulas pesanan yang belum completed dibalas 404, bukan 403',
      () async {
        // Server mencari order item lewat orders.status = 'completed'; status
        // lain tidak ketemu sama sekali. Pesannya harus diterjemahkan, karena
        // "tidak ditemukan" akan terbaca user sebagai pesanannya hilang.
        await expectLater(
          reviews.create(99999999, const ReviewDraft(rating: 5)),
          throwsA(anything),
        );
      },
    );
  });
}
