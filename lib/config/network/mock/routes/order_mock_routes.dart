import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace_app_member/util/format_helper.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

import '../pending_api_mock.dart';

/// Rute mock domain order (pasca-beli). Lihat `PendingApiMock` untuk aturannya
/// dan `assets/mock/pending_api/README.md` (bagian **Orders & Reviews**) untuk
/// kontrak yang diusulkan.
///
/// Konvensi fixture domain ini: setiap berkas di
/// `assets/mock/pending_api/order/` adalah **isi `data`** (bukan amplop
/// lengkap). Rute memakainya sebagai templat lalu menimpa id dan stempel
/// waktunya.
///
/// Semuanya **stateful di memori** dan hilang saat app dimulai ulang.
///
/// Yang sengaja **tidak** di-mock karena endpoint-nya sudah ada:
/// `POST /media/upload`, `POST /orders/{id}/refund-request` (field
/// `evidence_urls` hanya diusulkan — server mengabaikannya), dan
/// `POST /orders/{id}/insurance/opt-in`. Dua yang terakhir malah **diamati**
/// (`onResponse`) supaya rute mock di sebelahnya konsisten dengan server.
List<MockRoute> get orderMockRoutes => [
      // Mengingat status & baris pesanan dari `GET /orders/{id}` SUNGGUHAN.
      // Tidak menambah field, jadi tidak menandai `mock_fields`. Dipakai
      // untuk menegakkan gerbang status permohonan pembatalan dan untuk
      // mengisi nama produk di "Ulasan Saya".
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/orders/(\d+)$'),
        onResponse: (response, match) async => _rememberOrder(_data(response)),
      ),

      // -- Ajukan Pembatalan sesudah resi (docs/22 #3) -----------------------
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/orders/(\d+)/cancellation-request$'),
        onRequest: (options, match) async {
          final request = OrderMockState._cancellations[int.parse(match.group(1)!)];
          return MockReply.ok(request == null ? null : _resolveIfDue(request));
        },
      ),
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/orders/(\d+)/cancellation-request$'),
        onRequest: (options, match) async =>
            _createCancellation(int.parse(match.group(1)!), _body(options.data)),
      ),

      // -- Riwayat perjalanan kurir (field `tracking_history`) ---------------
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/orders/(\d+)/tracking$'),
        onResponse: (response, match) async => _enrichTracking(response),
      ),

      // -- Status Secure+ (GET diusulkan; opt-in sungguhan diamati) ----------
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/orders/(\d+)/insurance$'),
        onRequest: (options, match) async =>
            MockReply.ok(OrderMockState._policies[int.parse(match.group(1)!)]),
      ),
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/orders/(\d+)/insurance/opt-in$'),
        onResponse: (response, match) async {
          final data = _data(response);
          if (data == null) return;
          final policy =
              await MockFixtures.load<Map<String, dynamic>>('order/insurance_policy.json');
          OrderMockState._policies[int.parse(match.group(1)!)] = policy
            ..['id'] = data['id']
            ..['tier'] = data['tier'] ?? 'secure_plus'
            ..['premium_amount'] = data['premium_amount']
            // Balasan opt-in tidak membawa nilai pertanggungan; server
            // mengisinya dengan `grand_total`, yang tidak diketahui mock.
            ..['coverage_amount'] = null
            ..['status'] = 'active'
            ..['created_at'] = formatForServer(OrderMockState.now());
        },
      ),

      // -- Ulasan Saya + ubah ulasan 30 hari (docs/22 #8) --------------------
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/me/reviews$'),
        onRequest: (options, match) async =>
            _listReviews(asInt(options.queryParameters['page'], fallback: 1)),
      ),
      MockRoute(
        method: 'PATCH',
        path: RegExp(r'^/reviews/(\d+)$'),
        onRequest: (options, match) async =>
            _updateReview(int.parse(match.group(1)!), _body(options.data)),
      ),
      // Ulasan yang dibuat lewat endpoint SUNGGUHAN ikut masuk daftar mock,
      // supaya "Ulasan Saya" tidak kosong sesudah user benar-benar mengulas.
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/order-items/(\d+)/review$'),
        onResponse: (response, match) async => _rememberCreatedReview(
          int.parse(match.group(1)!),
          _data(response),
          _body(response.requestOptions.data),
        ),
      ),
    ];

/// Keadaan mock domain order. Publik hanya untuk test (lewat
/// [debugResetOrderMockState]); layar tidak pernah membacanya.
abstract final class OrderMockState {
  /// Jam yang dipakai mock; bisa diganti test.
  static DateTime Function() now = DateTime.now;

  /// Hasil otomatis permohonan pembatalan **khusus debug**, supaya keadaan
  /// "disetujui"/"ditolak" bisa dilihat tanpa aplikasi penjual:
  ///
  /// ```bash
  /// flutter run --dart-define=MOCK_CANCELLATION_OUTCOME=approved   # atau rejected
  /// flutter run --dart-define=MOCK_CANCELLATION_RESOLVE_SECONDS=10  # default 20
  /// ```
  ///
  /// Kosong (default) berarti permohonan tetap `pending` — perilaku yang
  /// paling jujur, karena di dunia nyata penjual yang memutuskan.
  static String cancellationOutcome =
      const String.fromEnvironment('MOCK_CANCELLATION_OUTCOME');
  static Duration cancellationResolveAfter = const Duration(
      seconds: int.fromEnvironment('MOCK_CANCELLATION_RESOLVE_SECONDS', defaultValue: 20));

  static final Map<int, String> _orderStatuses = {};
  static final Map<int, Map<String, dynamic>> _orderItems = {};
  static final Map<int, Map<String, dynamic>> _cancellations = {};
  static final Map<int, Map<String, dynamic>> _policies = {};
  static List<Map<String, dynamic>>? _reviews;
  static int _nextId = 9001;
}

/// Mengosongkan seluruh keadaan mock order (untuk test).
@visibleForTesting
void debugResetOrderMockState() {
  OrderMockState.now = DateTime.now;
  OrderMockState.cancellationOutcome = const String.fromEnvironment('MOCK_CANCELLATION_OUTCOME');
  OrderMockState.cancellationResolveAfter = const Duration(
      seconds: int.fromEnvironment('MOCK_CANCELLATION_RESOLVE_SECONDS', defaultValue: 20));
  OrderMockState._orderStatuses.clear();
  OrderMockState._orderItems.clear();
  OrderMockState._cancellations.clear();
  OrderMockState._policies.clear();
  OrderMockState._reviews = null;
  OrderMockState._nextId = 9001;
}

/// Status yang boleh mengajukan pembatalan: sesudah penjual mengemas atau
/// membuat resi. Sebelumnya pembeli membatalkan langsung
/// (`POST /orders/{id}/cancel`); sesudah diterima, jalurnya komplain.
const _cancellableStatuses = {'packed', 'shipped'};

const _maxNote = 500;
const _reviewPageSize = 20;

Map<String, dynamic> _body(Object? data) =>
    data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};

Map<String, dynamic>? _data(Response<dynamic> response) {
  final body = response.data;
  final data = body is Map ? body['data'] : null;
  return data is Map ? Map<String, dynamic>.from(data) : null;
}

String _ts(DateTime instant) => formatForServer(instant)!;

void _rememberOrder(Map<String, dynamic>? order) {
  if (order == null) return;
  final id = asIntOrNull(order['id']);
  if (id == null) return;
  OrderMockState._orderStatuses[id] = order['status']?.toString() ?? '';
  final items = order['items'];
  if (items is! List) return;
  for (final raw in items.whereType<Map>()) {
    final itemId = asIntOrNull(raw['id']);
    if (itemId == null) continue;
    OrderMockState._orderItems[itemId] = {
      'order_id': id,
      'store_id': order['store_id'],
      'product_name': raw['product_name_snapshot'],
      'variant_options': raw['variant_options_snapshot'],
    };
  }
}

// ---------------------------------------------------------------------------
// Permohonan pembatalan
// ---------------------------------------------------------------------------

Future<MockReply> _createCancellation(int orderId, Map<String, dynamic> body) async {
  // Status yang tidak dikenal mock (detail pesanan belum pernah dibuka di
  // sesi ini) diloloskan: mock tidak bisa bertanya ke server, dan layar
  // selalu memuat detail lebih dulu.
  final status = OrderMockState._orderStatuses[orderId];
  if (status != null && !_cancellableStatuses.contains(status)) {
    return MockReply.error(
      'CANCELLATION_NOT_ALLOWED',
      'Permohonan pembatalan hanya untuk pesanan yang sedang dikemas atau dikirim',
    );
  }
  if (OrderMockState._cancellations.containsKey(orderId)) {
    return MockReply.error(
      'CANCELLATION_REQUEST_EXISTS',
      'Pesanan ini sudah punya permohonan pembatalan',
      statusCode: 409,
    );
  }
  final reason = body['reason']?.toString();
  const reasons = {
    'wrong_address',
    'wrong_variant',
    'change_order',
    'eta_too_long',
    'changed_mind',
    'other',
  };
  if (reason == null || !reasons.contains(reason)) {
    return MockReply.error('VALIDATION_ERROR', 'reason wajib salah satu kode alasan yang sah');
  }
  final note = body['note']?.toString().trim();
  if (note != null && note.length > _maxNote) {
    return MockReply.error('VALIDATION_ERROR', 'note maksimal $_maxNote karakter');
  }

  final now = OrderMockState.now();
  final request = await MockFixtures.load<Map<String, dynamic>>('order/cancellation_request.json')
    ..['id'] = OrderMockState._nextId++
    ..['order_id'] = orderId
    ..['status'] = 'pending'
    ..['reason'] = reason
    ..['note'] = (note == null || note.isEmpty) ? null : note
    ..['rejection_reason'] = null
    ..['created_at'] = _ts(now)
    ..['seller_response_deadline'] = _ts(now.add(const Duration(hours: 24)))
    ..['resolved_at'] = null;
  OrderMockState._cancellations[orderId] = request;
  return MockReply.ok(request, statusCode: 201);
}

/// Menjalankan hasil otomatis debug (lihat [OrderMockState.cancellationOutcome]).
Map<String, dynamic> _resolveIfDue(Map<String, dynamic> request) {
  final outcome = OrderMockState.cancellationOutcome;
  if (request['status'] != 'pending' || (outcome != 'approved' && outcome != 'rejected')) {
    return request;
  }
  final createdAt = parseServerInstant(request['created_at']?.toString());
  if (createdAt == null) return request;
  final dueAt = createdAt.add(OrderMockState.cancellationResolveAfter);
  if (OrderMockState.now().toUtc().isBefore(dueAt)) return request;
  request
    ..['status'] = outcome
    ..['resolved_at'] = _ts(dueAt)
    ..['rejection_reason'] =
        outcome == 'rejected' ? 'Paket sudah diserahkan ke kurir (simulasi).' : null;
  return request;
}

// ---------------------------------------------------------------------------
// Riwayat perjalanan kurir
// ---------------------------------------------------------------------------

/// Menyisipkan `tracking_history` ke baris pengiriman SUNGGUHAN yang belum
/// punya riwayat, **konsisten dengan status dan stempel waktu pengirimannya**:
/// jumlah peristiwa mengikuti `status`, dan waktunya dipadatkan ke rentang
/// `shipped_at` … `delivered_at` (atau sekarang) supaya tidak ada peristiwa
/// di masa depan.
Future<void> _enrichTracking(Response<dynamic> response) async {
  final body = response.data;
  if (body is! Map) return;
  final data = body['data'];
  if (data is! Map) return;
  final existing = data['tracking_history'];
  final hasHistory = existing is List
      ? existing.isNotEmpty
      : existing is String && existing.trim().isNotEmpty && existing.trim() != '[]';
  if (hasHistory) return;

  final status = data['status']?.toString() ?? 'pending';
  final template = await MockFixtures.load<Map<String, dynamic>>('order/tracking_history.json');
  final journey = (template['tracking_history'] as List)
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList()
      .reversed
      .toList(); // terlama dulu

  final count = switch (status) {
    'picked_up' => 1,
    'in_transit' => journey.length - 1,
    'delivered' => journey.length,
    'returned' || 'lost' => 4,
    _ => 0,
  };
  if (count == 0) return;
  var events = journey.take(count).toList();
  if (status == 'returned') {
    events = [
      ...events,
      {
        'status': 'returned',
        'description': 'Paket dikembalikan ke penjual',
        'location': 'Gudang sortir kota asal',
        'occurred_at': null,
      },
    ];
  }

  final now = OrderMockState.now().toUtc();
  final shippedAt =
      parseServerInstant(data['shipped_at']?.toString()) ?? now.subtract(const Duration(hours: 2));
  final deliveredAt = parseServerInstant(data['delivered_at']?.toString());
  final end = status == 'delivered' ? (deliveredAt ?? now) : now;

  // Jarak antarperistiwa diambil dari fixture, lalu dipadatkan kalau tidak
  // muat di rentang yang tersedia.
  final fixtureTimes = [
    for (final e in journey) parseServerInstant(e['occurred_at']?.toString()) ?? shippedAt,
  ];
  final offsets = [
    for (var i = 0; i < events.length; i++)
      (i < fixtureTimes.length ? fixtureTimes[i] : fixtureTimes.last)
          .difference(fixtureTimes.first)
          .inSeconds
          .toDouble(),
  ];
  // Peristiwa "returned" tambahan diletakkan satu jam sesudah yang terakhir.
  if (status == 'returned') offsets[offsets.length - 1] = offsets[offsets.length - 2] + 3600;
  final span = offsets.last;
  final available = end.difference(shippedAt).inSeconds.toDouble().clamp(0, double.infinity);
  final scale = span == 0
      ? 0.0
      : status == 'delivered'
          ? available / span
          : (available < span ? available / span : 1.0);

  final out = [
    for (var i = 0; i < events.length; i++)
      {
        ...events[i],
        'occurred_at': _ts(shippedAt.add(Duration(seconds: (offsets[i] * scale).round()))),
      },
  ].reversed.toList(); // terbaru dulu, seperti API kurir

  data['tracking_history'] = out;
  markMockFields(response, ['tracking_history']);
}

// ---------------------------------------------------------------------------
// Ulasan Saya
// ---------------------------------------------------------------------------

/// Daftar awal dari fixture, **digeser relatif ke hari ini** supaya dua
/// keadaan — masih bisa diubah dan sudah terkunci — selalu terlihat, kapan
/// pun app dijalankan.
Future<List<Map<String, dynamic>>> _reviewStore() async {
  final existing = OrderMockState._reviews;
  if (existing != null) return existing;
  final seed = (await MockFixtures.load<List<dynamic>>('order/my_reviews.json'))
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  final times = [for (final r in seed) parseServerInstant(r['created_at']?.toString())];
  final newest = times.whereType<DateTime>().fold<DateTime?>(
      null, (acc, t) => acc == null || t.isAfter(acc) ? t : acc);
  if (newest != null) {
    final delta = OrderMockState.now().toUtc().subtract(const Duration(days: 2)).difference(newest);
    for (var i = 0; i < seed.length; i++) {
      final created = times[i];
      if (created == null) continue;
      final updated = parseServerInstant(seed[i]['updated_at']?.toString()) ?? created;
      seed[i]
        ..['created_at'] = _ts(created.add(delta))
        ..['updated_at'] = _ts(updated.add(delta));
    }
  }
  return OrderMockState._reviews = seed;
}

/// `editable_until` dan `is_editable` dihitung saat menjawab, bukan disimpan —
/// persis seperti yang diharapkan dari server.
Map<String, dynamic> _withWindow(Map<String, dynamic> review) {
  final created = parseServerInstant(review['created_at']?.toString());
  if (created == null) return {...review, 'editable_until': null, 'is_editable': 0};
  final until = created.add(const Duration(days: 30));
  return {
    ...review,
    'editable_until': _ts(until),
    'is_editable': OrderMockState.now().toUtc().isBefore(until) ? 1 : 0,
  };
}

Future<MockReply> _listReviews(int page) async {
  final all = [...await _reviewStore()]..sort((a, b) =>
      (b['created_at']?.toString() ?? '').compareTo(a['created_at']?.toString() ?? ''));
  final start = (page - 1) * _reviewPageSize;
  final slice = start >= all.length
      ? const <Map<String, dynamic>>[]
      : all.sublist(start, (start + _reviewPageSize).clamp(0, all.length));
  return MockReply.ok(
    [for (final r in slice) _withWindow(r)],
    meta: {'page': page, 'per_page': _reviewPageSize, 'total': all.length},
  );
}

Future<MockReply> _updateReview(int id, Map<String, dynamic> body) async {
  final store = await _reviewStore();
  final review = store.where((r) => asIntOrNull(r['id']) == id).firstOrNull;
  if (review == null) {
    return MockReply.error('REVIEW_NOT_FOUND', 'Ulasan tidak ditemukan', statusCode: 404);
  }
  if (_withWindow(review)['is_editable'] != 1) {
    return MockReply.error(
      'REVIEW_EDIT_WINDOW_CLOSED',
      'Ulasan hanya bisa diubah dalam 30 hari setelah dikirim',
    );
  }
  final rating = asIntOrNull(body['rating']);
  if (rating == null || rating < 1 || rating > 5) {
    return MockReply.error('VALIDATION_ERROR', 'rating wajib 1-5');
  }
  final comment = body['comment']?.toString().trim() ?? '';
  if (comment.length > _maxNote) {
    return MockReply.error('VALIDATION_ERROR', 'comment maksimal $_maxNote karakter');
  }
  review
    ..['rating'] = '$rating'
    ..['comment'] = comment.isEmpty ? null : comment
    ..['is_anonymous'] = asBool(body['is_anonymous']) ? '1' : '0'
    ..['updated_at'] = _ts(OrderMockState.now());
  return MockReply.ok(_withWindow(review));
}

Future<void> _rememberCreatedReview(
  int orderItemId,
  Map<String, dynamic>? data,
  Map<String, dynamic> request,
) async {
  final id = asIntOrNull(data?['id']);
  if (id == null) return;
  final store = await _reviewStore();
  if (store.any((r) => asIntOrNull(r['id']) == id)) return;
  final item = OrderMockState._orderItems[orderItemId] ?? const <String, dynamic>{};
  final now = _ts(OrderMockState.now());
  store.add({
    'id': '$id',
    'order_id': item['order_id'],
    'order_item_id': '$orderItemId',
    'product_id': null,
    'store_id': item['store_id'],
    'product_name': item['product_name'],
    'variant_options': item['variant_options'],
    'rating': '${asInt(request['rating'])}',
    'comment': request['comment'],
    'is_anonymous': asBool(request['is_anonymous']) ? '1' : '0',
    'created_at': now,
    'updated_at': now,
  });
}
