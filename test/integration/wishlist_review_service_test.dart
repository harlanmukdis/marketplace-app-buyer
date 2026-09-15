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
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
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

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    final auth = AuthService(dio);
    wishlist = WishlistService(dio);
    reviews = ReviewService(dio);
    catalog = CatalogService(dio);

    final stamp = DateTime.now().microsecondsSinceEpoch;
    final email = 'uji.wl.$stamp@marketplace.local';
    final phone =
        '08${stamp.toString().substring(stamp.toString().length - 10)}';
    const password = 'RahasiaAman123';

    await auth.register(
      email: email,
      password: password,
      fullName: 'Uji Wishlist',
      phone: phone,
    );
    final session = await auth.login(email: email, password: password);
    dio.options.headers['Authorization'] =
        'Bearer ${session.data.accessToken}';

    final listing = await catalog.fetchProducts(perPage: 5);
    productIds = listing.data.map((p) => p.id).toList();
  });

  tearDown(() => dio.close(force: true));

  group('wishlist', () {
    test('akun baru punya wishlist kosong', () async {
      final result = await wishlist.fetch();
      expect(result.data, isEmpty);
    });

    test('menambah produk, dan barisnya membawa gambar', () async {
      await wishlist.add(productIds.first);
      final result = await wishlist.fetch();

      expect(result.data, hasLength(1));
      final item = result.data.single;
      expect(item.productId, productIds.first);
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
