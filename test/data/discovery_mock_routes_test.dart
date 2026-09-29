/// Perilaku rute mock domain discovery: kontrak yang diusulkan ke backend
/// (daftar sesi live, status online toko, pantau harga wishlist) harus
/// berperilaku persis seperti yang ditulis di
/// `assets/mock/pending_api/README.md`, bagian Discovery — lewat service
/// sungguhan, supaya parsing model ikut teruji.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/config/network/mock/routes/discovery_mock_routes.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/live_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/store_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wishlist_service.dart';

/// "Server" palsu yang menjawab rute yang SUDAH ada.
class _Server implements HttpClientAdapter {
  final List<String> hits = [];
  String onlineStatus = 'null';

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream,
      Future<void>? cancelFuture) async {
    hits.add('${options.method} ${options.path}');
    String body;
    var status = 200;
    if (RegExp(r'^/stores/\d+/partners-performance$').hasMatch(options.path)) {
      body = '{"success":true,"data":{"rating":{"average":4.5,"total_reviews":2,"distribution":[]},'
          '"order_performance":{"total_orders":3,"success_rate_percent":100,"cancellation_rate_percent":0},'
          '"service_performance":{"response_rate_percent":80,"avg_reply_minutes":4.5,'
          '"operating_hours":null,"online_status":$onlineStatus}},"error":null}';
    } else if (options.path == '/wishlist') {
      body = '{"success":true,"data":[{"wishlist_item_id":"101","product_id":"1","name":"Satu",'
          '"min_price":"10000.00","product_status":"active"},{"wishlist_item_id":"102",'
          '"product_id":"2","name":"Dua","min_price":"20000.00","product_status":"active"}],"error":null}';
    } else {
      status = 404;
      body = '<html>404</html>';
    }
    return ResponseBody.fromString(body, status, headers: {
      // CodeIgniter menyajikan 404 rute tak terdaftar sebagai HTML.
      Headers.contentTypeHeader: [status == 404 ? 'text/html' : Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late _Server server;

  setUp(() {
    resetDiscoveryMockState();
    server = _Server();
    dio = Dio(BaseOptions(baseUrl: 'http://x/api/v1'))..httpClientAdapter = server;
    dio.interceptors.add(PendingApiMockInterceptor(discoveryMockRoutes));
  });

  group('GET /live-sessions (usulan)', () {
    test('bawaan: hanya yang tayang, tanpa menyentuh server, bertanda mock', () async {
      final env = await LiveService(dio).fetchSessions();
      expect(server.hits, isEmpty);
      expect(env.data, isNotEmpty);
      expect(env.data.every((s) => s.isLive), isTrue);
      expect(isMockMeta(env.meta), isTrue);
      expect(env.meta['per_page'], 20);
    });

    test('store_id + status=live,scheduled menyaring per toko', () async {
      final env = await LiveService(dio)
          .fetchSessions(statuses: const ['live', 'scheduled'], storeId: 1);
      expect(env.data.map((s) => s.storeId).toSet(), {1});
      expect(env.data.any((s) => s.isScheduled), isTrue);
      final scheduled = env.data.firstWhere((s) => s.isScheduled);
      expect(scheduled.scheduledAt, isNotNull);
    });

    test('toko tanpa sesi → daftar kosong, bukan error', () async {
      final env = await LiveService(dio).fetchSessions(storeId: 999);
      expect(env.data, isEmpty);
    });

    test('tanpa mock: rute belum ada → 404 HTML, dikenali sebagai rute tak dikenal', () async {
      final bare = Dio(BaseOptions(baseUrl: 'http://x/api/v1'))..httpClientAdapter = server;
      await expectLater(
        LiveService(bare).fetchSessions(),
        throwsA(isA<ApiException>().having((e) => e.error.isRouteNotFound, 'route', isTrue)),
      );
    });
  });

  group('partners-performance online_status (usulan)', () {
    test('null dari server diisi fixture per id toko + ditandai mock_fields', () async {
      final env = await StoreService(dio).fetchPerformance(1);
      expect(server.hits, ['GET /stores/1/partners-performance']);
      expect(env.data.onlineStatus, 'online');
      expect(env.data.lastActiveAt, isNotNull);
      // Angka sungguhan tidak disentuh.
      expect(env.data.avgReplyMinutes, 5);
      expect(env.meta['mock_fields'], contains('service_performance.online_status'));
    });

    test('toko tak terdaftar di fixture memakai "default" (offline)', () async {
      final env = await StoreService(dio).fetchPerformance(77);
      expect(env.data.onlineStatus, 'offline');
      expect(env.data.isOnline, isFalse);
      expect(env.data.lastActiveAt!.isBefore(DateTime.now()), isTrue);
    });

    test('begitu server mengirim nilainya, mock berhenti menimpa', () async {
      server.onlineStatus = '"offline"';
      final env = await StoreService(dio).fetchPerformance(1);
      expect(env.data.onlineStatus, 'offline');
      expect(isMockMeta(env.meta), isFalse);
    });
  });

  group('pantau harga wishlist (usulan, docs/22 #13)', () {
    test('GET /wishlist diperkaya alert_enabled=false bawaan', () async {
      final env = await WishlistService(dio).fetch();
      expect(env.data.map((i) => i.alertEnabled), [false, false]);
      expect(env.meta['mock_fields'], ['alert_enabled']);
    });

    test('PATCH menyimpan keadaan per id PRODUK dan GET berikutnya memantulkannya', () async {
      final service = WishlistService(dio);
      final reply = await service.setAlert(2, enabled: true);
      expect(reply.data, {'product_id': '2', 'alert_enabled': true});
      expect(server.hits, isNot(contains('PATCH /wishlist/items/2')));

      final env = await service.fetch();
      expect(env.data.firstWhere((i) => i.productId == 2).isWatched, isTrue);
      expect(env.data.firstWhere((i) => i.productId == 1).isWatched, isFalse);
    });

    test('alert_enabled bukan boolean → 422 VALIDATION_ERROR', () async {
      await expectLater(
        dio.patch<dynamic>('/wishlist/items/2', data: {'alert_enabled': 'ya'}),
        throwsA(isA<DioException>().having(
            (e) => e.response?.data['error']['code'], 'code', 'VALIDATION_ERROR')),
      );
    });
  });
}
