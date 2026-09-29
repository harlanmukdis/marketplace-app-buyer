/// Perilaku rute mock domain order: kontrak yang diusulkan ke backend
/// (permohonan pembatalan, riwayat kurir, status Secure+, ulasan saya) harus
/// berperilaku persis seperti yang ditulis di `assets/mock/pending_api/README.md`.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/config/network/mock/routes/order_mock_routes.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/review_service.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// "Server" palsu yang menjawab rute yang SUDAH ada.
class _Server implements HttpClientAdapter {
  final List<String> hits = [];
  String orderStatus = 'packed';
  String? trackingJson;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream,
      Future<void>? cancelFuture) async {
    hits.add('${options.method} ${options.path}');
    String body;
    var status = 200;
    if (RegExp(r'^/orders/\d+$').hasMatch(options.path)) {
      body = '{"success":true,"data":{"id":"12","store_id":"2","status":"$orderStatus",'
          '"items":[{"id":"31","product_name_snapshot":"Kopi Gayo",'
          '"variant_options_snapshot":"{\\"ukuran\\":\\"250g\\"}"}]},"error":null}';
    } else if (options.path.endsWith('/tracking')) {
      body = '{"success":true,"data":${trackingJson ?? 'null'},"error":null}';
    } else if (options.path.endsWith('/insurance/opt-in')) {
      status = 201;
      body = '{"success":true,"data":{"id":77,"premium_amount":835,"tier":"secure_plus"},"error":null}';
    } else if (options.path.endsWith('/review')) {
      status = 201;
      body = '{"success":true,"data":{"id":4242},"error":null}';
    } else {
      status = 404;
      body = '<html>404</html>';
    }
    return ResponseBody.fromString(body, status, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late _Server server;
  late OrderService orders;
  late ReviewService reviews;
  var now = DateTime.utc(2026, 9, 29, 3);

  setUp(() {
    debugResetOrderMockState();
    now = DateTime.utc(2026, 9, 29, 3);
    OrderMockState.now = () => now;
    server = _Server();
    dio = Dio(BaseOptions(baseUrl: 'http://x/api/v1'))..httpClientAdapter = server;
    dio.interceptors.add(PendingApiMockInterceptor(orderMockRoutes));
    orders = OrderService(dio);
    reviews = ReviewService(dio);
  });

  group('permohonan pembatalan', () {
    test('belum ada → data null, tanpa menyentuh server', () async {
      final env = await orders.fetchCancellationRequest(12);
      expect(env.data, isNull);
      expect(isMockMeta(env.meta), isTrue);
      expect(server.hits, isEmpty);
    });

    test('dibuat untuk pesanan packed, lalu terbaca kembali', () async {
      await orders.fetchOrder(12); // mock mengingat statusnya
      final created = await orders.requestCancellation(12,
          reason: CancellationReason.wrongAddress, note: 'Salah kota');
      expect(created.statusCode, 201);
      expect(created.data.status, CancellationRequestStatus.pending);
      expect(created.data.reasonLabel, 'Alamat salah');
      expect(created.data.sellerResponseDeadline!.difference(created.data.createdAt!),
          const Duration(hours: 24));

      final read = await orders.fetchCancellationRequest(12);
      expect(read.data!.id, created.data.id);
      expect(read.data!.note, 'Salah kota');
    });

    test('status selain packed/shipped → 422 CANCELLATION_NOT_ALLOWED', () async {
      server.orderStatus = 'paid';
      await orders.fetchOrder(12);
      await expectLater(
        orders.requestCancellation(12, reason: CancellationReason.other),
        throwsA(predicate((e) => '$e'.contains('CANCELLATION_NOT_ALLOWED'))),
      );
    });

    test('permohonan kedua → 409 CANCELLATION_REQUEST_EXISTS', () async {
      await orders.fetchOrder(12);
      await orders.requestCancellation(12, reason: CancellationReason.changedMind);
      await expectLater(
        orders.requestCancellation(12, reason: CancellationReason.changedMind),
        throwsA(predicate((e) => '$e'.contains('CANCELLATION_REQUEST_EXISTS'))),
      );
    });

    test('hasil otomatis debug: ditolak sesudah jeda, dengan alasan', () async {
      OrderMockState.cancellationOutcome = 'rejected';
      OrderMockState.cancellationResolveAfter = const Duration(seconds: 10);
      await orders.fetchOrder(12);
      await orders.requestCancellation(12, reason: CancellationReason.etaTooLong);

      expect((await orders.fetchCancellationRequest(12)).data!.isPending, isTrue);
      now = now.add(const Duration(seconds: 11));
      final resolved = (await orders.fetchCancellationRequest(12)).data!;
      expect(resolved.status, CancellationRequestStatus.rejected);
      expect(resolved.rejectionReason, isNotEmpty);
      expect(resolved.resolvedAt, isNotNull);
    });
  });

  group('riwayat kurir', () {
    test('tracking null dibiarkan null', () async {
      final env = await orders.fetchTracking(12);
      expect(env.data, isNull);
      expect(env.meta['mock_fields'], isNull);
    });

    test('in_transit: disisipkan, terbaru dulu, tak ada yang di masa depan', () async {
      server.trackingJson = '{"courier_code":"jne","service_type":"reg","awb_number":"JN1",'
          '"status":"in_transit","shipped_at":"${formatForServer(now.subtract(const Duration(hours: 3)))}",'
          '"tracking_history":null}';
      final env = await orders.fetchTracking(12);
      final history = env.data!.trackingHistory;
      expect(env.meta['mock_fields'], ['tracking_history']);
      expect(history, hasLength(5));
      expect(history.any((e) => e.isDelivered), isFalse);
      expect(history.last.status, 'picked_up');
      for (var i = 1; i < history.length; i++) {
        expect(history[i - 1].occurredAt!.isAfter(history[i].occurredAt!) ||
            history[i - 1].occurredAt == history[i].occurredAt, isTrue);
      }
      expect(history.first.occurredAt!.isAfter(now), isFalse);
    });

    test('delivered: peristiwa terakhir tepat di delivered_at', () async {
      final delivered = now.subtract(const Duration(hours: 1));
      server.trackingJson = '{"courier_code":"jne","service_type":"reg","status":"delivered",'
          '"shipped_at":"${formatForServer(now.subtract(const Duration(days: 2)))}",'
          '"delivered_at":"${formatForServer(delivered)}"}';
      final history = (await orders.fetchTracking(12)).data!.trackingHistory;
      expect(history, hasLength(6));
      expect(history.first.isDelivered, isTrue);
      expect(history.first.occurredAt, delivered);
    });

    test('riwayat yang sudah dikirim server tidak ditimpa', () async {
      server.trackingJson = '{"courier_code":"jne","service_type":"reg","status":"in_transit",'
          '"tracking_history":"[{\\"status\\":\\"in_transit\\",\\"description\\":\\"Asli\\"}]"}';
      final env = await orders.fetchTracking(12);
      expect(env.meta['mock_fields'], isNull);
      expect(env.data!.trackingHistory.single.description, 'Asli');
    });
  });

  group('Secure+', () {
    test('GET null sebelum opt-in; opt-in sungguhan diingat', () async {
      expect((await orders.fetchInsurance(12)).data, isNull);
      final opted = await orders.optInSecurePlus(12);
      expect(server.hits, contains('POST /orders/12/insurance/opt-in'));
      expect(opted.data.premiumAmount, 835);

      final policy = (await orders.fetchInsurance(12)).data!;
      expect(policy.isSecurePlus, isTrue);
      expect(policy.isActive, isTrue);
      expect(policy.id, 77);
    });
  });

  group('ulasan saya', () {
    test('seed: satu bisa diubah, satu terkunci, dengan meta paginasi', () async {
      final env = await reviews.fetchMine();
      expect(env.meta['total'], 2);
      expect(env.data, hasLength(2));
      final editable = env.data.first;
      final locked = env.data.last;
      expect(editable.canEdit(now), isTrue);
      expect(locked.canEdit(now), isFalse);
      expect(editable.editableUntil!.difference(editable.createdAt!), MyReviewModel.editWindow);
    });

    test('PATCH memperbarui dan membalas ulasan baru', () async {
      final first = (await reviews.fetchMine()).data.first;
      now = now.add(const Duration(minutes: 5));
      final updated = await reviews.update(
          first.id, const ReviewUpdateDraft(rating: 3, comment: 'Diubah', isAnonymous: true));
      expect(updated.data.rating, 3);
      expect(updated.data.comment, 'Diubah');
      expect(updated.data.isAnonymous, isTrue);
      expect(updated.data.wasEdited, isTrue);
    });

    test('PATCH sesudah 30 hari → REVIEW_EDIT_WINDOW_CLOSED', () async {
      final locked = (await reviews.fetchMine()).data.last;
      await expectLater(
        reviews.update(locked.id, const ReviewUpdateDraft(rating: 5)),
        throwsA(predicate((e) => '$e'.contains('REVIEW_EDIT_WINDOW_CLOSED'))),
      );
    });

    test('rating di luar 1–5 → VALIDATION_ERROR; id asing → REVIEW_NOT_FOUND', () async {
      final first = (await reviews.fetchMine()).data.first;
      await expectLater(reviews.update(first.id, const ReviewUpdateDraft(rating: 9)),
          throwsA(predicate((e) => '$e'.contains('VALIDATION_ERROR'))));
      await expectLater(reviews.update(1, const ReviewUpdateDraft(rating: 5)),
          throwsA(predicate((e) => '$e'.contains('REVIEW_NOT_FOUND'))));
    });

    test('ulasan yang dibuat lewat endpoint sungguhan ikut masuk daftar', () async {
      await orders.fetchOrder(12);
      await reviews.create(31, const ReviewDraft(rating: 4, comment: 'Mantap'));
      final mine = (await reviews.fetchMine()).data;
      final created = mine.firstWhere((r) => r.id == 4242);
      expect(created.productName, 'Kopi Gayo');
      expect(created.orderId, 12);
      expect(created.optionLabel, '250g');
      expect(created.canEdit(now), isTrue);
    });
  });

  test('model: tracking_history berupa string JSON ikut terbaca', () {
    final model = OrderTrackingModel.fromJson({
      'tracking_history': '[{"status":"delivered","description":"x","occurred_at":"2026-09-29 10:00:00"}]',
    });
    expect(model.trackingHistory.single.isDelivered, isTrue);
    expect(OrderTrackingModel.fromJson({'tracking_history': 'bukan json'}).trackingHistory, isEmpty);
  });
}
