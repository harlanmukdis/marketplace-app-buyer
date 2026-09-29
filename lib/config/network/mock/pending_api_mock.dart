import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'routes/account_mock_routes.dart';
import 'routes/checkout_mock_routes.dart';
import 'routes/discovery_mock_routes.dart';
import 'routes/order_mock_routes.dart';

/// Mock untuk **API yang belum dibangun backend** (docs/22 blueprint buyer
/// dan celah lain yang tercatat di CLAUDE.md).
///
/// ## Aturannya
///
/// * **Hanya endpoint atau field yang BELUM ADA** yang di-mock. Endpoint yang
///   sudah ada tapi datanya kosong di dev (voucher, home CMS) tetap memakai
///   server sungguhan — mock di sana hanya menyembunyikan keadaan sebenarnya.
/// * Service ditulis terhadap **kontrak yang diusulkan**, persis seolah
///   endpoint-nya sudah ada. Begitu backend membangunnya, **hapus rute mock-nya
///   saja**; service, repository, dan layar tidak berubah. Kalau backend
///   memilih bentuk lain, fixture di `assets/mock/pending_api/` dan
///   `README.md` di sana adalah daftar yang harus disesuaikan.
/// * Setiap respons mock membawa `meta.mock = true` (dan `meta.mock_fields`
///   untuk field yang disisipkan ke respons sungguhan), supaya layar bisa
///   menandainya "Simulasi" lewat [isMockMeta]. Data simulasi tidak boleh
///   terlihat seperti data sungguhan.
/// * **Aktif hanya di debug**, dan bisa dimatikan:
///   `flutter run --dart-define=PENDING_API_MOCK=false`. Release tidak pernah
///   memasangnya. Test integrasi memakai `DioClient.createBare`, jadi tetap
///   memaku perilaku server yang sebenarnya.
abstract final class PendingApiMock {
  static const bool enabled =
      bool.fromEnvironment('PENDING_API_MOCK', defaultValue: kDebugMode);

  static List<MockRoute> get routes => [
        ...accountMockRoutes,
        ...checkoutMockRoutes,
        ...orderMockRoutes,
        ...discoveryMockRoutes,
      ];
}

/// `true` kalau blok `meta` sebuah respons berasal (seluruhnya atau sebagian)
/// dari mock.
bool isMockMeta(Map<String, dynamic>? meta) =>
    meta != null && (meta['mock'] == true || meta['mock_fields'] is List);

/// Balasan mock untuk satu request.
class MockReply {
  const MockReply(this.body, {this.statusCode = 200});

  /// Amplop lengkap `{success, data, error, meta}`.
  final Map<String, dynamic> body;
  final int statusCode;

  factory MockReply.ok(Object? data, {int statusCode = 200, Map<String, dynamic>? meta}) =>
      MockReply(
        {
          'success': true,
          'data': data,
          'error': null,
          'meta': {...?meta, 'mock': true},
        },
        statusCode: statusCode,
      );

  factory MockReply.error(String code, String message, {int statusCode = 422}) => MockReply(
        {
          'success': false,
          'data': null,
          'error': {'code': code, 'message': message, 'details': null},
          'meta': {'mock': true},
        },
        statusCode: statusCode,
      );
}

/// Satu rute mock.
///
/// * [onRequest] — mengembalikan [MockReply] untuk menjawab tanpa menyentuh
///   server, atau `null` untuk meneruskan (boleh mengubah `options` lebih
///   dulu).
/// * [onResponse] — memperkaya respons **sungguhan** dengan field yang belum
///   dikirim server. Wajib menambahkan nama field-nya ke `meta.mock_fields`
///   (pakai [markMockFields]).
class MockRoute {
  const MockRoute({
    required this.method,
    required this.path,
    this.onRequest,
    this.onResponse,
  });

  final String method;

  /// Dicocokkan dengan `RequestOptions.path` (tanpa base URL, tanpa query).
  final RegExp path;
  final Future<MockReply?> Function(RequestOptions options, RegExpMatch match)? onRequest;
  final Future<void> Function(Response<dynamic> response, RegExpMatch match)? onResponse;

  RegExpMatch? matches(RequestOptions options) {
    if (options.method.toUpperCase() != method) return null;
    final path = Uri.parse(options.path).path;
    return this.path.firstMatch(path);
  }
}

/// Menandai field yang disisipkan mock ke respons sungguhan.
void markMockFields(Response<dynamic> response, List<String> fields) {
  final body = response.data;
  if (body is! Map) return;
  final meta = body['meta'] is Map ? Map<String, dynamic>.from(body['meta'] as Map) : <String, dynamic>{};
  meta['mock_fields'] = [...?(meta['mock_fields'] as List?), ...fields];
  body['meta'] = meta;
}

/// Memuat fixture JSON dari `assets/mock/pending_api/`, sekali saja.
abstract final class MockFixtures {
  static final Map<String, Object?> _cache = {};

  static Future<T> load<T>(String path) async {
    final cached = _cache[path];
    if (cached != null) return _clone(cached) as T;
    final text = await rootBundle.loadString('assets/mock/pending_api/$path');
    final decoded = jsonDecode(text);
    _cache[path] = decoded;
    return _clone(decoded) as T;
  }

  /// Salinan dalam, supaya mutasi oleh satu rute tidak mencemari cache.
  static Object? _clone(Object? value) => jsonDecode(jsonEncode(value));
}

class PendingApiMockInterceptor extends Interceptor {
  PendingApiMockInterceptor(this.routes);

  final List<MockRoute> routes;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    for (final route in routes) {
      final match = route.matches(options);
      if (match == null || route.onRequest == null) continue;
      final reply = await route.onRequest!(options, match);
      if (reply == null) break;
      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: reply.statusCode,
        data: reply.body,
        headers: Headers.fromMap({
          'x-mock': ['pending-api'],
        }),
      );
      if (reply.statusCode >= 200 && reply.statusCode < 300) {
        handler.resolve(response, true);
      } else {
        handler.reject(
          DioException.badResponse(
            statusCode: reply.statusCode,
            requestOptions: options,
            response: response,
          ),
          true,
        );
      }
      return;
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    if (response.headers.value('x-mock') == null) {
      for (final route in routes) {
        final match = route.matches(response.requestOptions);
        if (match == null || route.onResponse == null) continue;
        try {
          await route.onResponse!(response, match);
        } catch (e) {
          debugPrint('PendingApiMock: gagal memperkaya ${response.requestOptions.path}: $e');
        }
      }
    }
    handler.next(response);
  }
}
