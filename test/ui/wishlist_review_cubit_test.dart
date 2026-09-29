/// Perilaku [WishlistCubit] dan [ProductReviewsCubit] terhadap repository
/// palsu.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/wishlist_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/product_reviews_cubit.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';

WishlistItemModel _item(int productId) =>
    WishlistItemModel(productId: productId, wishlistItemId: productId + 100);

ReviewModel _review(int id, {int rating = 5}) =>
    ReviewModel(id: id, rating: rating, productId: 1);

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeWishlistRepository implements WishlistRepository {
  DataState<List<WishlistItemModel>> result = DataSuccess([_item(3)]);
  final List<String> calls = [];

  @override
  Future<DataState<List<WishlistItemModel>>> fetch() async {
    calls.add('fetch');
    return result;
  }

  @override
  Future<DataState<List<WishlistItemModel>>> add(int productId) async {
    calls.add('add:$productId');
    return result;
  }

  @override
  Future<DataState<List<WishlistItemModel>>> remove(int productId) async {
    calls.add('remove:$productId');
    return result;
  }

  DataState<List<WishlistItemModel>>? alertResult;

  @override
  Future<DataState<List<WishlistItemModel>>> setAlert(int productId, {required bool enabled}) async {
    calls.add('alert:$productId:$enabled');
    return alertResult ?? result;
  }
}

class _FakeReviewRepository implements ReviewRepository {
  DataState<ReviewPage> result = DataSuccess(
    ReviewPage(reviews: [_review(1)], total: 1),
  );
  final List<String> calls = [];
  int? lastRating;

  @override
  Future<DataState<ReviewPage>> fetchForProduct(
    int productId, {
    int page = 1,
    int? rating,
  }) async {
    calls.add('fetch:$page');
    lastRating = rating;
    return result;
  }

  @override
  Future<DataState<int>> create(int orderItemId, ReviewDraft draft) async {
    calls.add('create:$orderItemId');
    return const DataSuccess(9);
  }

  @override
  Future<DataState<void>> report(int reviewId, {String? reason}) async {
    calls.add('report:$reviewId');
    return const DataSuccess(null);
  }

  // Method ulasan-saya (domain lain) tidak dipakai test ini.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeWishlistRepository wishlist;
  late _FakeReviewRepository reviews;

  setUp(() {
    wishlist = _FakeWishlistRepository();
    reviews = _FakeReviewRepository();
    injector.registerSingleton<WishlistRepository>(wishlist);
    injector.registerSingleton<ReviewRepository>(reviews);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('WishlistCubit — pantau harga (🔶 kontrak usulan)', () {
    test('setAlert memakai id produk dan membawa meta simulasi', () async {
      wishlist.result = const DataSuccess([
        WishlistItemModel(productId: 3, wishlistItemId: 103, alertEnabled: false),
      ]);
      wishlist.alertResult = const DataSuccess(
        [WishlistItemModel(productId: 3, wishlistItemId: 103, alertEnabled: true)],
        meta: {
          'mock_fields': ['alert_enabled'],
        },
      );
      final cubit = WishlistCubit();
      await cubit.load();

      final watched = await cubit.setAlert(3, enabled: true);

      expect(watched, isTrue);
      expect(wishlist.calls, contains('alert:3:true'));
      final state = cubit.state as WishlistReady;
      expect(state.watchedCount, 1);
      expect(state.meta['mock_fields'], ['alert_enabled']);
      expect(state.alertMutatingIds, isEmpty);
      await cubit.close();
    });

    test('gagal menyimpan tidak mengosongkan daftar dan melaporkan error', () async {
      wishlist.alertResult = DataFailed(_error('VALIDATION_ERROR'));
      final cubit = WishlistCubit();
      await cubit.load();

      final watched = await cubit.setAlert(3, enabled: true);

      expect(watched, isNull);
      final state = cubit.state as WishlistReady;
      expect(state.items, hasLength(1));
      expect(state.actionError?.code, 'VALIDATION_ERROR');
      expect(state.alertMutatingIds, isEmpty);
      await cubit.close();
    });

    test('baris tanpa alert_enabled = fitur belum didukung, lonceng disembunyikan', () {
      final item = WishlistItemModel.fromJson(const {'product_id': '3', 'name': 'A'});
      expect(item.supportsAlert, isFalse);
      final withField =
          WishlistItemModel.fromJson(const {'product_id': '3', 'alert_enabled': '1'});
      expect(withField.supportsAlert, isTrue);
      expect(withField.isWatched, isTrue);
    });
  });

  group('WishlistCubit', () {
    test('contains membaca dari id PRODUK, bukan wishlist_item_id', () async {
      // Ini yang menentukan tombol hati menyala atau tidak.
      final cubit = WishlistCubit();
      await cubit.load();

      expect(cubit.state.contains(3), isTrue);
      expect(cubit.state.contains(103), isFalse,
          reason: '103 adalah wishlist_item_id, bukan product_id');
      await cubit.close();
    });

    test('toggle menambah kalau belum tersimpan', () async {
      wishlist.result = const DataSuccess([]);
      final cubit = WishlistCubit();
      await cubit.load();
      wishlist.calls.clear();

      await cubit.toggle(7);

      expect(wishlist.calls, contains('add:7'));
      await cubit.close();
    });

    test('toggle menghapus kalau sudah tersimpan', () async {
      final cubit = WishlistCubit();
      await cubit.load();
      wishlist.calls.clear();

      await cubit.toggle(3);

      expect(wishlist.calls, contains('remove:3'));
      await cubit.close();
    });

    test('toggle kedua pada produk sama diabaikan selagi menunggu', () async {
      final cubit = WishlistCubit();
      await cubit.load();
      wishlist.calls.clear();

      final first = cubit.toggle(3);
      final second = cubit.toggle(3);
      await Future.wait([first, second]);

      expect(wishlist.calls.where((c) => c.startsWith('remove:')).length, 1);
      await cubit.close();
    });

    test('gagal menyimpan mempertahankan daftar yang sudah tampil', () async {
      final cubit = WishlistCubit();
      await cubit.load();
      wishlist.result = DataFailed(_error('NETWORK'));

      await cubit.toggle(3);

      final state = cubit.state as WishlistReady;
      expect(state.items, hasLength(1));
      expect(state.actionError?.code, 'NETWORK');
      expect(state.mutatingProductIds, isEmpty);
      await cubit.close();
    });
  });

  group('ProductReviewsCubit', () {
    test('paginasi DIHITUNG dari meta.total, bukan ditebak', () async {
      // Berbeda dari /orders yang tidak mengirim meta sama sekali.
      reviews.result = DataSuccess(
        ReviewPage(reviews: [_review(1), _review(2)], total: 5),
      );
      final cubit = ProductReviewsCubit(1);
      await cubit.load();

      final state = cubit.state as ProductReviewsLoaded;
      expect(state.hasMore, isTrue);
      await cubit.close();
    });

    test('tidak ada lanjutan kalau jumlah termuat sama dengan total', () async {
      reviews.result = DataSuccess(ReviewPage(reviews: [_review(1)], total: 1));
      final cubit = ProductReviewsCubit(1);
      await cubit.load();

      expect((cubit.state as ProductReviewsLoaded).hasMore, isFalse);
      await cubit.close();
    });

    test('filter bintang diteruskan ke repository', () async {
      final cubit = ProductReviewsCubit(1);
      await cubit.filterByRating(4);

      expect(reviews.lastRating, 4);
      expect(cubit.state.activeRating, 4);
      await cubit.close();
    });

    test('filter dilepas dengan null', () async {
      final cubit = ProductReviewsCubit(1);
      await cubit.filterByRating(4);
      await cubit.filterByRating(null);

      expect(reviews.lastRating, isNull);
      await cubit.close();
    });

    test('hasil kosong tetap membawa histogram', () async {
      // Histogram dihitung server untuk seluruh produk, bukan untuk hasil
      // tersaring — jadi barnya harus tetap tampil saat filter kosong.
      reviews.result = const DataSuccess(
        ReviewPage(
          reviews: [],
          histogram: RatingHistogram(
            total: 3,
            breakdown: [RatingBucket(rating: 5, count: 3, percentage: 100)],
          ),
          total: 0,
        ),
      );
      final cubit = ProductReviewsCubit(1);
      await cubit.filterByRating(2);

      expect(cubit.state, isA<ProductReviewsEmpty>());
      expect(cubit.state.histogram.total, 3);
      expect(cubit.state.activeRating, 2);
      await cubit.close();
    });

    test('loadMore menambahkan halaman berikutnya', () async {
      reviews.result = DataSuccess(
        ReviewPage(reviews: [_review(1)], total: 2),
      );
      final cubit = ProductReviewsCubit(1);
      await cubit.load();

      reviews.result = DataSuccess(
        ReviewPage(reviews: [_review(2)], total: 2),
      );
      await cubit.loadMore();

      final state = cubit.state as ProductReviewsLoaded;
      expect(state.page.reviews.map((r) => r.id), [1, 2]);
      expect(state.hasMore, isFalse);
      await cubit.close();
    });

    test('report mengembalikan true saat diterima', () async {
      final cubit = ProductReviewsCubit(1);
      await cubit.load();

      expect(await cubit.report(1, reason: 'palsu'), isTrue);
      expect(reviews.calls, contains('report:1'));
      await cubit.close();
    });
  });
}
