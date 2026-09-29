/// Uji asap layar penemuan produk: detail produk, pencarian, storefront,
/// toko diikuti, dan wishlist dirender dengan repository palsu tanpa
/// overflow maupun exception, dan aturan desain yang bisa dipatok (tanpa
/// "0,0", tanpa filter/urutan di pencarian) benar-benar dipegang.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/home_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/live_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/wishlist_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/catalog/screens/catalog_home_screen.dart';
import 'package:marketplace_app_member/ui/main/catalog/screens/product_detail_screen.dart';
import 'package:marketplace_app_member/ui/main/catalog/screens/search_screen.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/store/screens/followed_stores_screen.dart';
import 'package:marketplace_app_member/ui/main/store/screens/store_screen.dart';
import 'package:marketplace_app_member/ui/main/wishlist/screens/wishlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_catalog_repository.dart';

const _variants = [
  ProductVariantModel(id: 10, price: 150000, stock: 8, variantOptions: {'warna': 'Hitam'}),
  ProductVariantModel(id: 11, price: 150000, stock: 0, variantOptions: {'warna': 'Putih'}),
];

ProductModel _product(int id, {int ratingCount = 0, bool discounted = true}) => ProductModel(
      id: id,
      storeId: 3,
      name: 'Produk uji nomor $id dengan nama yang cukup panjang untuk dua baris',
      basePrice: 150000,
      compareAtPrice: discounted ? 200000 : null,
      ratingAvg: ratingCount > 0 ? 4.6 : 0,
      ratingCount: ratingCount,
      soldCount: 1200,
      description: 'Deskripsi produk. ' * 30,
      variants: _variants,
      couriers: const [CourierModel(code: 'jne', name: 'JNE')],
    );

class _Catalog extends FakeCatalogRepository {
  ProductModel detail = _product(1);
  DataState<List<ProductModel>> listing =
      DataSuccess([_product(1), _product(2), _product(3)], meta: const {'total': 3});

  @override
  Future<DataState<ProductModel>> fetchProduct(int id, {bool forceRefresh = false}) async =>
      DataSuccess(detail);

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
  }) async =>
      listing;
}

class _Stores implements StoreRepository {
  Map<String, dynamic> performanceMeta = const {};
  StorePerformanceModel performance = const StorePerformanceModel(
    ratingAverage: 0,
    totalReviews: 0,
    ratingDistribution: {},
    totalOrders: 0,
    successRatePercent: 0,
    cancellationRatePercent: 0,
    responseRatePercent: 0,
  );

  @override
  Future<DataState<StoreModel>> fetchStore(int id) async => DataSuccess(StoreModel(
        id: id,
        name: 'Toko Uji Resmi',
        description: 'Toko uji.',
        primaryStatus: 'official_store',
        hasSignatureBadge: true,
        followerCount: 28700,
      ));

  @override
  Future<DataState<StorePerformanceModel>> fetchPerformance(int id) async =>
      DataSuccess(performance, meta: performanceMeta);

  @override
  Future<DataState<StoreModel>> setFollowing(int id, {required bool follow}) async =>
      DataSuccess(StoreModel(id: id, name: 'Toko Uji Resmi', isFollowing: follow));

  @override
  Future<DataState<List<FollowedStoreModel>>> fetchFollowing({int page = 1}) async =>
      const DataSuccess([
        FollowedStoreModel(id: 3, name: 'Toko Uji Resmi', ratingAvg: 4.5, ratingCount: 10),
        FollowedStoreModel(id: 4, name: 'Toko Tanpa Ulasan'),
      ]);
}

class _Reviews implements ReviewRepository {
  DataState<ReviewPage> page = const DataEmpty();

  @override
  Future<DataState<ReviewPage>> fetchForProduct(int productId, {int page = 1, int? rating}) async =>
      this.page;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Addresses implements AddressRepository {
  @override
  Future<DataState<List<AddressModel>>> fetchAddresses() async => const DataEmpty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Wishlist implements WishlistRepository {
  List<WishlistItemModel> items = const [];

  @override
  Future<DataState<List<WishlistItemModel>>> fetch() async =>
      items.isEmpty ? const DataEmpty() : DataSuccess(items);

  @override
  Future<DataState<List<WishlistItemModel>>> add(int productId) => fetch();

  @override
  Future<DataState<List<WishlistItemModel>>> remove(int productId) async {
    items = items.where((i) => i.productId != productId).toList();
    return fetch();
  }

  @override
  Future<DataState<List<WishlistItemModel>>> setAlert(int productId, {required bool enabled}) async {
    items = [
      for (final i in items) i.productId == productId ? i.copyWith(alertEnabled: enabled) : i,
    ];
    return DataSuccess(items, meta: const {
      'mock_fields': ['alert_enabled'],
    });
  }
}

class _Live implements LiveRepository {
  DataState<List<LiveSessionModel>> result = const DataEmpty();
  final List<String> calls = [];

  @override
  Future<DataState<List<LiveSessionModel>>> fetchLiveNow({int page = 1}) async {
    calls.add('now');
    return result;
  }

  @override
  Future<DataState<List<LiveSessionModel>>> fetchForStore(int storeId) async {
    calls.add('store:$storeId');
    return result;
  }
}

class _Home implements HomeRepository {
  DataState<List<HomeSectionModel>> result = const DataEmpty();

  @override
  Future<DataState<List<HomeSectionModel>>> fetchLayout() async => result;
}

class _Wallet implements WalletRepository {
  @override
  Future<DataState<WalletModel>> fetchWallet() async => const DataFailed(
      DataError(code: 'NETWORK', message: 'x', kind: DataErrorKind.network));

  @override
  Future<DataState<List<BankAccountModel>>> fetchBankAccounts() async => const DataEmpty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _liveMeta = {'mock': true};

const _liveNow = LiveSessionModel(
  id: 9001,
  storeId: 3,
  storeName: 'Toko Simulasi Satu',
  title: 'Simulasi Live: Promo Uji',
  viewerCount: 1240,
  promoLabel: 'Diskon 35%',
  soldCount: 86,
);

class _Cart implements CartRepository {
  @override
  Future<DataState<CartSnapshot>> fetchCart() async => const DataSuccess(CartSnapshot.empty);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Chat implements ChatRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

late _Catalog _catalog;
late _Stores _stores;
late _Reviews _reviews;
late _Wishlist _wishlist;
late _Live _live;
late _Home _home;

Future<void> _pump(WidgetTester tester, Widget screen) async {
  tester.view.physicalSize = const Size(390, 844) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => screen),
    GoRoute(path: '/:rest(.*)', builder: (_, __) => const SizedBox()),
  ]);
  await tester.pumpWidget(MaterialApp.router(
    routerConfig: router,
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    builder: (context, child) => AppScope(child: child!),
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    _catalog = _Catalog();
    _stores = _Stores();
    _reviews = _Reviews();
    _wishlist = _Wishlist();
    _live = _Live();
    _home = _Home();
    injector
      ..registerSingleton<CatalogRepository>(_catalog)
      ..registerSingleton<StoreRepository>(_stores)
      ..registerSingleton<ReviewRepository>(_reviews)
      ..registerSingleton<AddressRepository>(_Addresses())
      ..registerSingleton<WishlistRepository>(_wishlist)
      ..registerSingleton<CartRepository>(_Cart())
      ..registerSingleton<ChatRepository>(_Chat())
      ..registerSingleton<LiveRepository>(_live)
      ..registerSingleton<HomeRepository>(_home)
      ..registerSingleton<WalletRepository>(_Wallet());
  });

  tearDown(() async {
    await injector.reset();
  });

  group('ProductDetailScreen', () {
    testWidgets('produk tanpa ulasan tidak menampilkan bintang maupun 0,0', (tester) async {
      await _pump(tester, const ProductDetailScreen(productId: 1));

      expect(find.text('Detail Produk'), findsOneWidget);
      expect(find.text('Rp 150.000'), findsWidgets);
      expect(find.textContaining('0,0'), findsNothing);
      expect(find.text('Belum ada ulasan untuk produk ini.'), findsOneWidget);
      expect(find.text('Beli Sekarang'), findsOneWidget);
      // Pemilih varian tidak pernah digambar sebagai chip di halaman.
      expect(find.text('Putih (Habis)'), findsNothing);

      await tester.scrollUntilVisible(find.text('Kunjungi Toko'), 200);
      expect(find.text('Toko Uji Resmi'), findsWidgets);
      expect(find.text('Xpedia Signature'), findsOneWidget);
      expect(find.text('Chat Penjual'), findsOneWidget);
    });

    testWidgets('ulasan dengan balasan penjual dan histogram', (tester) async {
      _catalog.detail = _product(1, ratingCount: 2);
      _stores.performance = const StorePerformanceModel(
        ratingAverage: 4.5,
        totalReviews: 2,
        ratingDistribution: {5: 1, 4: 1},
        totalOrders: 10,
        successRatePercent: 90,
        cancellationRatePercent: 10,
        responseRatePercent: 80,
        avgReplyMinutes: 4,
      );
      _reviews.page = const DataSuccess(ReviewPage(
        reviews: [
          ReviewModel(
            id: 1,
            rating: 4,
            comment: 'Bagus',
            reply: ReviewReplyModel(replyText: 'Terima kasih'),
          ),
        ],
        histogram: RatingHistogram(total: 2, breakdown: [
          RatingBucket(rating: 5, count: 1, percentage: 50),
          RatingBucket(rating: 4, count: 1, percentage: 50),
          RatingBucket(rating: 3, count: 0, percentage: 0),
          RatingBucket(rating: 2, count: 0, percentage: 0),
          RatingBucket(rating: 1, count: 0, percentage: 0),
        ]),
        total: 1,
      ));
      await _pump(tester, const ProductDetailScreen(productId: 1));

      await tester.scrollUntilVisible(find.text('Terima kasih'), 200);
      expect(find.text('Balasan Penjual'), findsOneWidget);
      expect(find.text('Ulasan Pembeli'), findsOneWidget);
    });

    testWidgets('Beli Sekarang membuka sheet varian', (tester) async {
      await _pump(tester, const ProductDetailScreen(productId: 1));

      await tester.tap(find.text('Beli Sekarang'));
      await tester.pumpAndSettle();

      expect(find.text('Putih (Habis)'), findsOneWidget);
      expect(find.textContaining('Beli Sekarang •'), findsOneWidget);
    });
  });

  group('SearchScreen', () {
    testWidgets('hasil tanpa kontrol filter maupun urutan', (tester) async {
      await _pump(tester, const SearchScreen(query: 'kaos'));

      expect(find.textContaining('"kaos"'), findsOneWidget);
      expect(find.text('3 produk'), findsOneWidget);
      expect(find.textContaining('Filter'), findsNothing);
      expect(find.textContaining('Urutkan'), findsNothing);
      expect(find.textContaining('asuransi'), findsNothing);
    });

    testWidgets('tanpa hasil menampilkan empty state', (tester) async {
      _catalog.listing = const DataEmpty();
      await _pump(tester, const SearchScreen(query: 'zzz'));
      expect(find.text('Produk tidak ditemukan'), findsOneWidget);
    });

    testWidgets('kata kunci kosong menampilkan ajakan mencari', (tester) async {
      await _pump(tester, const SearchScreen(query: ''));
      expect(find.text('Cari produk di Xpedia'), findsOneWidget);
    });
  });

  group('StoreScreen', () {
    testWidgets('seluruh tab bisa dibuka; tab Live kosong tanpa sesi', (tester) async {
      await _pump(tester, const StoreScreen(storeId: 3));

      expect(find.text('Toko Uji Resmi'), findsWidgets);
      expect(find.text('Ikuti Toko'), findsOneWidget);
      // Tanpa sesi tayang tidak ada pita "Lihat Live".
      expect(find.text('Lihat Live'), findsNothing);
      expect(_live.calls, ['store:3']);
      for (final tab in ['Produk', 'Live', 'Ulasan', 'Tentang Toko', 'Beranda Toko']) {
        final finder = find.text(tab, skipOffstage: false).first;
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }
      final reviews = find.text('Ulasan', skipOffstage: false).first;
      await tester.ensureVisible(reviews);
      await tester.pumpAndSettle();
      await tester.tap(reviews);
      await tester.pumpAndSettle();
      expect(find.text('Belum ada ulasan'), findsOneWidget);

      await tester.tap(find.text('Ikuti Toko'));
      await tester.pumpAndSettle();
      expect(find.text('Mengikuti'), findsOneWidget);

      final liveTab = find.text('Live', skipOffstage: false).first;
      await tester.ensureVisible(liveTab);
      await tester.pumpAndSettle();
      await tester.tap(liveTab);
      await tester.pumpAndSettle();
      expect(find.text('Belum ada live'), findsOneWidget);
    });

    testWidgets('🔶 sesi live simulasi: pita, tab, dan lencana Simulasi', (tester) async {
      _live.result = const DataSuccess([_liveNow], meta: _liveMeta);
      await _pump(tester, const StoreScreen(storeId: 3));

      expect(find.text('Lihat Live'), findsOneWidget);
      expect(find.text('Simulasi'), findsWidgets);
      await tester.tap(find.text('Lihat Live'));
      await tester.pumpAndSettle();
      expect(find.text('Live Sekarang'), findsOneWidget);
      expect(find.text('Pemutar live belum tersedia di aplikasi.'), findsOneWidget);
    });

    testWidgets('🔶 metrik Online dari online_status simulasi', (tester) async {
      _stores.performance = const StorePerformanceModel(
        ratingAverage: 4.5,
        totalReviews: 2,
        ratingDistribution: {5: 1, 4: 1},
        totalOrders: 10,
        successRatePercent: 90,
        cancellationRatePercent: 10,
        responseRatePercent: 80,
        avgReplyMinutes: 5,
        onlineStatus: 'online',
      );
      _stores.performanceMeta = const {
        'mock_fields': ['service_performance.online_status', 'service_performance.last_active_at'],
      };
      await _pump(tester, const StoreScreen(storeId: 3));

      expect(find.text('Online'), findsOneWidget);
      expect(find.text('Aktif sekarang'), findsOneWidget);
      expect(find.text('Balas ± 5 mnt'), findsOneWidget);
      expect(find.text('Status online toko masih simulasi.'), findsOneWidget);
    });
  });

  group('CatalogHomeScreen', () {
    testWidgets('layout CMS kosong + tanpa live: beranda seperti biasa', (tester) async {
      await _pump(tester, const CatalogHomeScreen());

      expect(find.text('Rekomendasi Spesial'), findsOneWidget);
      expect(find.text('Xpedia Live Interaktif'), findsNothing);
      expect(find.byType(PageView), findsNothing);
      expect(find.text('Simulasi'), findsNothing);
    });

    testWidgets('section CMS dan strip LIVE NOW dirender', (tester) async {
      _home.result = DataSuccess([
        HomeSectionModel.fromJson(const {
          'section_id': 1,
          'type': 'hero_banner',
          'title': 'Hero',
          'banners': [
            {'id': '1', 'image_url': '', 'title': 'Promo Uji', 'action_type': 'PRODUCT', 'action_value': '1'},
            {'id': '2', 'image_url': '', 'title': null, 'action_type': 'URL', 'action_value': 'https://x'},
          ],
        }),
        HomeSectionModel.fromJson(const {
          'section_id': 3,
          'type': 'flash_sale_widget',
          'title': 'Flash Sale Hari Ini',
          'flash_sales': [
            {
              'id': 1,
              'name': 'Kilat Siang',
              'start_at': '2026-09-29 10:00:00',
              'end_at': '2026-09-29 14:00:00',
              'products': [
                {
                  'product_id': '1',
                  'product_name': 'Kopi Flash',
                  'flash_price': '9000.00',
                  'original_price': '15000.00',
                  'sold_count': '5',
                  'stock_quota': '10',
                },
              ],
            },
          ],
        }),
      ]);
      _live.result = const DataSuccess([_liveNow], meta: _liveMeta);
      await _pump(tester, const CatalogHomeScreen());

      expect(find.byType(PageView), findsOneWidget);
      expect(find.text('Promo Uji'), findsOneWidget);
      expect(find.text('Kilat Siang'), findsOneWidget);
      expect(find.text('Kopi Flash'), findsOneWidget);
      expect(find.text('Rp 9.000'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Xpedia Live Interaktif'),
        200,
        scrollable: find
            .byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down)
            .first,
      );
      expect(find.text('LIVE NOW'), findsOneWidget);
      expect(find.text('Simulasi'), findsOneWidget);
      expect(find.text('Diskon 35%'), findsOneWidget);
    });
  });

  testWidgets('FollowedStoresScreen: rating disembunyikan kalau tanpa ulasan', (tester) async {
    await _pump(tester, const FollowedStoresScreen());

    expect(find.text('Toko Tanpa Ulasan'), findsOneWidget);
    expect(find.text('4,5'), findsOneWidget);
    expect(find.text('Berhenti Mengikuti'), findsNWidgets(2));
  });

  group('WishlistScreen', () {
    testWidgets('tanpa alert_enabled dari server: lonceng tidak digambar', (tester) async {
      _wishlist.items = const [WishlistItemModel(productId: 1, name: 'Satu', minPrice: 10000)];
      await _pump(tester, WishlistScreen(onLogoTap: () {}));
      expect(find.bySemanticsLabel('Pantau harga'), findsNothing);
      expect(find.text('Simulasi'), findsNothing);
    });

    testWidgets('🔶 lonceng pantau harga: Pantau + toast', (tester) async {
      _wishlist.items = const [
        WishlistItemModel(productId: 1, name: 'Satu', minPrice: 10000, alertEnabled: false),
      ];
      await _pump(tester, WishlistScreen(onLogoTap: () {}));

      await tester.tap(find.bySemanticsLabel('Pantau harga'));
      await tester.pumpAndSettle();

      expect(find.text('Pantau'), findsOneWidget);
      expect(find.text('Notifikasi perubahan harga aktif'), findsOneWidget);
      expect(find.text('Simulasi'), findsOneWidget);
      expect(find.bySemanticsLabel('Berhenti pantau harga'), findsOneWidget);
    });

    testWidgets('kosong', (tester) async {
      await _pump(tester, WishlistScreen(onLogoTap: () {}));
      expect(find.text('Wishlist Belum Ada'), findsOneWidget);
      expect(find.text('Mulai Cari Produk'), findsOneWidget);
    });

    testWidgets('grid dan hapus', (tester) async {
      _wishlist.items = const [
        WishlistItemModel(productId: 1, name: 'Satu', minPrice: 10000),
        WishlistItemModel(productId: 2, name: 'Dua', minPrice: 20000, productStatus: 'archived'),
      ];
      await _pump(tester, WishlistScreen(onLogoTap: () {}));

      expect(find.text('Tidak tersedia'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Hapus dari wishlist').first);
      await tester.pumpAndSettle();
      expect(find.text('Satu'), findsNothing);
      expect(find.text('Dihapus dari Wishlist'), findsOneWidget);
    });
  });
}
