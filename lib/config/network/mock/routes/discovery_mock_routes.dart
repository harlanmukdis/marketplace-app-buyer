import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../pending_api_mock.dart';

/// Rute mock domain discovery. Lihat `PendingApiMock` untuk aturannya dan
/// `assets/mock/pending_api/README.md` (bagian **Discovery**) untuk kontrak
/// yang diusulkan.
///
/// Konvensi fixture domain ini: berkas di `assets/mock/pending_api/discovery/`
/// berisi **payload `data`** saja (bukan amplop penuh); amplopnya dirakit
/// [MockReply.ok].
///
/// Yang di-mock di sini hanya yang **belum ada** di backend:
///
/// * `GET /live-sessions` — daftar sesi live untuk pembeli (hanya ada
///   `/live-sessions/{id}` dan rute penjual);
/// * `service_performance.online_status` + `last_active_at` di
///   `GET /stores/{id}/partners-performance` — server selalu mengirim `null`;
/// * `PATCH /wishlist/items/{product_id}` + `alert_enabled` di `GET /wishlist`
///   — pantau harga & stok (docs/22 #13).
///
/// Home CMS (`GET /home/layout`) dan master lokasi **tidak** di-mock: keduanya
/// endpoint sungguhan.
List<MockRoute> get discoveryMockRoutes => [
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/live-sessions$'),
        onRequest: (options, match) async {
          final all = await MockFixtures.load<List<dynamic>>('discovery/live_sessions.json');
          final query = options.queryParameters;
          final statuses = (query['status']?.toString() ?? 'live')
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toSet();
          final storeId = query['store_id']?.toString();
          final page = int.tryParse(query['page']?.toString() ?? '') ?? 1;
          final filtered = all.whereType<Map>().where((row) {
            if (!statuses.contains(row['status'])) return false;
            return storeId == null || row['store_id'].toString() == storeId;
          }).toList();
          const perPage = 20;
          final start = (page - 1) * perPage;
          final slice = start >= filtered.length
              ? const <Map>[]
              : filtered.sublist(start, (start + perPage).clamp(0, filtered.length));
          return MockReply.ok(slice, meta: {
            'page': page,
            'per_page': perPage,
            'total': filtered.length,
          });
        },
      ),
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/stores/(\d+)/partners-performance$'),
        onResponse: (response, match) async {
          final data = response.data is Map ? response.data['data'] : null;
          if (data is! Map) return;
          final service = data['service_performance'];
          if (service is! Map) return;
          // Hanya mengisi yang masih null: begitu backend mengirim nilainya,
          // mock berhenti menimpa dengan sendirinya.
          if (service['online_status'] != null) return;
          final fixture =
              await MockFixtures.load<Map<String, dynamic>>('discovery/store_online_status.json');
          final entry = (fixture[match.group(1)] ?? fixture['default']) as Map;
          final minutesAgo = (entry['last_active_minutes_ago'] as num?)?.toInt() ?? 0;
          service['online_status'] = entry['online_status'];
          service['last_active_at'] = _wibTimestamp(
            DateTime.now().subtract(Duration(minutes: minutesAgo)),
          );
          markMockFields(response, [
            'service_performance.online_status',
            'service_performance.last_active_at',
          ]);
        },
      ),
      MockRoute(
        method: 'PATCH',
        path: RegExp(r'^/wishlist/items/(\d+)$'),
        onRequest: (options, match) async {
          final body = _bodyOf(options);
          final enabled = body['alert_enabled'];
          if (enabled is! bool) {
            return MockReply.error(
              'VALIDATION_ERROR',
              "Field 'alert_enabled' wajib berupa boolean",
            );
          }
          final productId = int.parse(match.group(1)!);
          _wishlistAlerts[productId] = enabled;
          final reply =
              await MockFixtures.load<Map<String, dynamic>>('discovery/wishlist_alert.json');
          reply['product_id'] = '$productId';
          reply['alert_enabled'] = enabled;
          return MockReply.ok(reply);
        },
      ),
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/wishlist$'),
        onResponse: (response, match) async {
          final rows = response.data is Map ? response.data['data'] : null;
          if (rows is! List) return;
          var touched = false;
          for (final row in rows.whereType<Map>()) {
            if (row.containsKey('alert_enabled')) continue;
            final productId = int.tryParse(row['product_id']?.toString() ?? '');
            row['alert_enabled'] = _wishlistAlerts[productId] ?? false;
            touched = true;
          }
          // Wishlist kosong tetap ditandai: layar tidak menampilkan apa pun
          // yang disimulasikan, tapi baris pertama yang disimpan akan membawa
          // field-nya.
          if (touched || rows.isEmpty) markMockFields(response, ['alert_enabled']);
        },
      ),
    ];

/// Keadaan pantau harga yang "disimpan server" mock, per id produk. Hidup
/// selama proses app — cukup untuk menguji alur, dan jujur bahwa tidak ada
/// yang benar-benar tersimpan.
final Map<int, bool> _wishlistAlerts = {};

@visibleForTesting
void resetDiscoveryMockState() => _wishlistAlerts.clear();

Map<String, dynamic> _bodyOf(RequestOptions options) {
  final data = options.data;
  if (data is Map) return Map<String, dynamic>.from(data);
  if (data is String && data.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      return const {};
    }
  }
  return const {};
}

/// `YYYY-MM-DD HH:MM:SS` waktu dinding WIB, seperti seluruh timestamp API.
String _wibTimestamp(DateTime instant) {
  final w = instant.toUtc().add(const Duration(hours: 7));
  String two(int v) => v.toString().padLeft(2, '0');
  return '${w.year}-${two(w.month)}-${two(w.day)} '
      '${two(w.hour)}:${two(w.minute)}:${two(w.second)}';
}
