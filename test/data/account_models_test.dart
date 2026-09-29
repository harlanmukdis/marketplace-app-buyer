/// Model akun dan `AccountRepositoryImpl`: pengelompokan sesi login (satu
/// baris per refresh), penanda perangkat ini, dan token reset dev.
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/account_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/repositories/account_repository_impl.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';

/// Potongan `GET /me/sessions` apa adanya dari server (29 September 2026):
/// angka sebagai string, waktu WIB, dua baris dari satu perangkat karena
/// refresh tidak mencabut baris lama.
const _serverSessions = [
  {
    'id': '2476',
    'device_id': null,
    'ip_address': '127.0.0.1',
    'user_agent': 'Dart/3.11 (dart:io)',
    'created_at': '2026-09-29 11:16:00',
    'expires_at': '2026-10-29 11:16:00',
  },
  {
    'id': '2474',
    'device_id': null,
    'ip_address': '127.0.0.1',
    'user_agent': 'curl/8.7.1',
    'created_at': '2026-09-29 11:01:46',
    'expires_at': '2026-10-29 11:01:46',
  },
  {
    'id': '2459',
    'device_id': null,
    'ip_address': '127.0.0.1',
    'user_agent': 'Dart/3.11 (dart:io)',
    'created_at': '2026-09-29 01:12:41',
    'expires_at': '2026-10-29 01:12:41',
  },
];

class _Server implements HttpClientAdapter {
  _Server(this.routes);

  final Map<String, Object?> routes;
  final List<String> hits = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream,
      Future<void>? cancelFuture) async {
    final key = '${options.method} ${options.path}';
    hits.add(key);
    return ResponseBody.fromString(
      jsonEncode({'success': true, 'data': routes[key] ?? routes[options.method], 'error': null}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

List<LoginSessionModel> _parse() =>
    [for (final j in _serverSessions) LoginSessionModel.fromJson(Map<String, dynamic>.from(j))];

void main() {
  test('baris server terbaca: id string, waktu WIB jadi instan UTC', () {
    final s = _parse().first;
    expect(s.id, 2476);
    expect(s.createdAt, DateTime.utc(2026, 9, 29, 4, 16));
    expect(s.isCurrent, isNull);
  });

  group('groupLoginSessions', () {
    test('satu perangkat = sesi dengan device/UA/IP yang sama', () {
      final devices = groupLoginSessions(_parse());
      expect(devices, hasLength(2));
      final app = devices.firstWhere((d) => d.label == 'Aplikasi Xpedia');
      expect(app.sessionIds, [2476, 2459], reason: 'terbaru dulu');
      expect(app.lastSeenAt, DateTime.utc(2026, 9, 29, 4, 16));
    });

    test('perangkat ini = created_at terdekat dengan terbitnya token', () {
      final devices = groupLoginSessions(
        _parse(),
        // 11:16:30 WIB — token diterbitkan 30 detik sesudah baris 2476.
        tokenIssuedAt: DateTime.utc(2026, 9, 29, 4, 16, 30),
      );
      expect(devices.first.isCurrent, isTrue, reason: 'perangkat ini paling atas');
      expect(devices.first.sessionIds, contains(2476));
      expect(devices.where((d) => d.isCurrent), hasLength(1));
    });

    test('selisih di atas toleransi: tidak ada yang ditandai', () {
      final devices = groupLoginSessions(
        _parse(),
        tokenIssuedAt: DateTime.utc(2026, 9, 29, 5),
      );
      expect(devices.any((d) => d.isCurrent), isFalse);
    });

    test('is_current dari server (usulan) menang atas tebakan', () {
      final sessions = _parse();
      sessions[1] = sessions[1].copyWith(isCurrent: true);
      final devices = groupLoginSessions(
        sessions,
        tokenIssuedAt: DateTime.utc(2026, 9, 29, 4, 16, 30),
      );
      expect(devices.first.label, 'curl');
      expect(devices.first.isCurrent, isTrue);
    });
  });

  test('describeUserAgent', () {
    expect(describeUserAgent(null), 'Perangkat tidak dikenal');
    expect(describeUserAgent('Dart/3.11 (dart:io)'), 'Aplikasi Xpedia');
    expect(
      describeUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/129.0 Safari/537.36'),
      'Chrome di macOS',
    );
    expect(
      describeUserAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 '
          '(KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1'),
      'Safari di iOS',
    );
  });

  group('AccountRepositoryImpl', () {
    late _Server server;
    late AccountRepositoryImpl repo;

    setUp(() {
      server = _Server({
        'GET /me/sessions': _serverSessions,
        'POST /auth/forgot-password': {
          'message': 'Bila email terdaftar, instruksi reset password sudah dikirim',
          'dev_reset_token': 'abc123',
        },
        'DELETE': null,
      });
      final dio = Dio(BaseOptions(baseUrl: 'http://x/api/v1'))..httpClientAdapter = server;
      repo = AccountRepositoryImpl(
        AccountService(dio),
        AuthService(dio),
        tokenIssuedAt: () => DateTime.utc(2026, 9, 29, 4, 16, 10),
      );
    });

    test('fetchDevices mengelompokkan dan menandai perangkat ini', () async {
      final result = await repo.fetchDevices();
      final devices = (result as DataSuccess<List<LoginDevice>>).data;
      expect(devices.first.isCurrent, isTrue);
      expect(devices, hasLength(2));
    });

    test('revokeDevice mencabut SEMUA baris perangkat itu, lalu membaca ulang', () async {
      final devices = (await repo.fetchDevices() as DataSuccess<List<LoginDevice>>).data;
      server.hits.clear();
      await repo.revokeDevice(devices.first);
      expect(server.hits, [
        'DELETE /me/sessions/2476',
        'DELETE /me/sessions/2459',
        'GET /me/sessions',
      ]);
    });

    test('forgot-password meneruskan dev_reset_token', () async {
      final result = await repo.requestPasswordReset('budi@contoh.id');
      expect((result as DataSuccess<PasswordResetRequest>).data.devResetToken, 'abc123');
    });
  });
}
