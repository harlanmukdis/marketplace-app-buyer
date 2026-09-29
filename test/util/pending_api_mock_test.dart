/// Perilaku `PendingApiMockInterceptor`: menjawab rute yang belum ada,
/// meneruskan sisanya, dan menandai data simulasi.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';

/// Adapter palsu: mencatat request yang benar-benar sampai ke "server".
class _Server implements HttpClientAdapter {
  final List<String> hits = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream,
      Future<void>? cancelFuture) async {
    hits.add('${options.method} ${options.path}');
    return ResponseBody.fromString(
      '{"success":true,"data":{"id":"1"},"error":null}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _Server server;

  setUp(() {
    server = _Server();
    dio = Dio(BaseOptions(baseUrl: 'http://x/api/v1'))..httpClientAdapter = server;
    dio.interceptors.add(PendingApiMockInterceptor([
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/belum-ada/(\d+)$'),
        onRequest: (options, match) async => MockReply.ok({'id': match.group(1)}),
      ),
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/ditolak$'),
        onRequest: (options, match) async => MockReply.error('INVALID_PIN', 'PIN salah'),
      ),
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/sudah-ada$'),
        onResponse: (response, match) async {
          (response.data['data'] as Map)['field_baru'] = true;
          markMockFields(response, ['field_baru']);
        },
      ),
    ]));
  });

  test('rute yang belum ada dijawab mock tanpa menyentuh server', () async {
    final response = await dio.get<dynamic>('/belum-ada/7');
    expect(server.hits, isEmpty);
    expect(response.data['data'], {'id': '7'});
    expect(isMockMeta(Map<String, dynamic>.from(response.data['meta'] as Map)), isTrue);
  });

  test('error mock sampai sebagai DioException berisi amplop error', () async {
    await expectLater(
      dio.post<dynamic>('/ditolak'),
      throwsA(isA<DioException>().having(
          (e) => e.response?.data['error']['code'], 'code', 'INVALID_PIN')),
    );
    expect(server.hits, isEmpty);
  });

  test('respons sungguhan diperkaya dan ditandai mock_fields', () async {
    final response = await dio.get<dynamic>('/sudah-ada');
    expect(server.hits, ['GET /sudah-ada']);
    expect(response.data['data']['field_baru'], isTrue);
    expect(response.data['meta']['mock_fields'], ['field_baru']);
  });

  test('rute lain diteruskan apa adanya', () async {
    final response = await dio.get<dynamic>('/lain');
    expect(server.hits, ['GET /lain']);
    expect(isMockMeta(null), isFalse);
    expect(response.data['meta'], isNull);
  });
}
