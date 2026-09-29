/// Perilaku mock domain account (`account_mock_routes.dart`): verifikasi KTP,
/// kunci nama di `PATCH /me`, dan ganti kontak dua tahap — lewat
/// `AccountService` sungguhan, supaya fixture dan model ikut teruji.
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/config/network/mock/routes/account_mock_routes.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/account_service.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';

/// "Server" palsu untuk rute yang diteruskan mock.
class _Server implements HttpClientAdapter {
  final List<String> hits = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream,
      Future<void>? cancelFuture) async {
    hits.add('${options.method} ${options.path}');
    final data = options.path == '/me' && options.method == 'GET'
        ? {'id': '3', 'email': 'budi@contoh.id', 'phone': '081234567890'}
        : null;
    return ResponseBody.fromString(
      jsonEncode({'success': true, 'data': data, 'error': null}),
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
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late _Server server;
  late AccountService service;
  late DateTime now;

  setUp(() {
    resetAccountMockState();
    now = DateTime.utc(2026, 9, 29, 3);
    accountMockClock = () => now;
    server = _Server();
    dio = Dio(BaseOptions(baseUrl: 'http://x/api/v1'))..httpClientAdapter = server;
    dio.interceptors.add(PendingApiMockInterceptor(accountMockRoutes));
    service = AccountService(dio);
  });

  tearDown(resetAccountMockState);

  Future<String> errorCode(Future<Object?> call) async {
    try {
      await call;
    } on ApiException catch (e) {
      return e.error.code;
    }
    fail('diharapkan gagal');
  }

  group('verifikasi identitas', () {
    test('belum pernah mengajukan: none, bertanda mock, tanpa menyentuh server', () async {
      final env = await service.fetchIdentityVerification();
      expect(env.data.statusValue, IdentityStatus.none);
      expect(isMockMeta(env.meta), isTrue);
      expect(server.hits, isEmpty);
    });

    test('validasi, NIK terpakai, lalu pending → verified sesudah 10 detik', () async {
      expect(
        await errorCode(service.submitIdentityVerification(idCardNumber: '123', fullName: 'Budi')),
        'VALIDATION_ERROR',
      );
      expect(
        await errorCode(service.submitIdentityVerification(
            idCardNumber: '1111111111111111', fullName: 'Budi')),
        'ID_CARD_ALREADY_USED',
      );

      final submitted = await service.submitIdentityVerification(
          idCardNumber: '3171010101013456', fullName: 'Budi Santoso');
      expect(submitted.statusCode, 201);
      expect(submitted.data.statusValue, IdentityStatus.pending);
      expect(submitted.data.idCardNumberMasked, '************3456');

      now = now.add(const Duration(seconds: 5));
      expect((await service.fetchIdentityVerification()).data.isPending, isTrue);

      now = now.add(const Duration(seconds: 5));
      final done = (await service.fetchIdentityVerification()).data;
      expect(done.isVerified, isTrue);
      expect(done.verifiedAt, isNotNull);

      expect(
        await errorCode(service.submitIdentityVerification(
            idCardNumber: '3171010101019999', fullName: 'Budi')),
        'INVALID_STATE',
      );
    });

    test('NIK berakhiran 0000 ditolak dan boleh diajukan ulang', () async {
      await service.submitIdentityVerification(
          idCardNumber: '3171010101010000', fullName: 'Budi');
      now = now.add(kMockIdentityReviewDelay);
      final rejected = (await service.fetchIdentityVerification()).data;
      expect(rejected.statusValue, IdentityStatus.rejected);
      expect(rejected.rejectionReason, isNotEmpty);
      expect(rejected.canSubmit, isTrue);
    });

    test('PATCH /me: nama ditolak selama pending, field lain diteruskan', () async {
      await dio.patch<dynamic>('/me', data: {'full_name': 'Nama Baru'});
      expect(server.hits, ['PATCH /me'], reason: 'belum mengajukan: tidak dikunci');

      await service.submitIdentityVerification(
          idCardNumber: '3171010101013456', fullName: 'Budi');
      await expectLater(
        dio.patch<dynamic>('/me', data: {'full_name': 'Nama Baru'}),
        throwsA(isA<DioException>().having(
            (e) => e.response?.data['error']['code'], 'code', 'IDENTITY_LOCKED')),
      );
      await dio.patch<dynamic>('/me', data: {'avatar_url': 'https://x/a.png'});
      expect(server.hits, ['PATCH /me', 'PATCH /me']);
    });
  });

  group('ganti kontak', () {
    test('OTP ke kontak lama (dari GET /me sungguhan), lalu ke kontak baru', () async {
      await dio.get<dynamic>('/me');

      final first = await service.startContactChange(
          type: ContactType.email, newValue: 'baru@contoh.id');
      expect(first.statusCode, 201);
      expect(first.data.stageValue, ContactChangeStage.currentContact);
      expect(first.data.otpSentTo, 'bu***@contoh.id');
      expect(first.meta['mock_otp'], kMockOtp);

      expect(
        await errorCode(
            service.verifyContactChange(requestId: first.data.requestId, otp: '000000')),
        'INVALID_OTP',
      );

      final second =
          await service.verifyContactChange(requestId: first.data.requestId, otp: kMockOtp);
      expect(second.data.stageValue, ContactChangeStage.newContact);
      expect(second.data.otpSentTo, 'ba***@contoh.id');

      final done =
          await service.verifyContactChange(requestId: first.data.requestId, otp: kMockOtp);
      expect(done.data.isCompleted, isTrue);
      expect(done.data.newValue, 'baru@contoh.id');

      expect(
        await errorCode(
            service.verifyContactChange(requestId: first.data.requestId, otp: kMockOtp)),
        'CONTACT_CHANGE_NOT_FOUND',
      );
    });

    test('nilai sama dengan kontak sekarang, email/HP terpakai', () async {
      await dio.get<dynamic>('/me');
      expect(
        await errorCode(
            service.startContactChange(type: ContactType.email, newValue: 'budi@contoh.id')),
        'VALIDATION_ERROR',
      );
      expect(
        await errorCode(
            service.startContactChange(type: ContactType.email, newValue: 'terpakai@contoh.id')),
        'EMAIL_TAKEN',
      );
      expect(
        await errorCode(
            service.startContactChange(type: ContactType.phone, newValue: '081200000000')),
        'PHONE_TAKEN',
      );
    });

    test('OTP kedaluwarsa dan batas lima kali salah', () async {
      final a = await service.startContactChange(
          type: ContactType.phone, newValue: '081298765432');
      expect(a.data.otpSentTo, 'nomor HP terdaftar', reason: 'GET /me belum pernah dibaca');
      for (var i = 0; i < kMockOtpMaxAttempts; i++) {
        await errorCode(service.verifyContactChange(requestId: a.data.requestId, otp: '999999'));
      }
      expect(
        await errorCode(service.verifyContactChange(requestId: a.data.requestId, otp: kMockOtp)),
        'TOO_MANY_REQUESTS',
      );

      final b = await service.startContactChange(
          type: ContactType.phone, newValue: '081298765432');
      now = now.add(kMockOtpLifetime);
      expect(
        await errorCode(service.verifyContactChange(requestId: b.data.requestId, otp: kMockOtp)),
        'OTP_EXPIRED',
      );
    });

    test('maksimal tiga permintaan per jenis per jam', () async {
      for (var i = 0; i < kMockContactChangePerHour; i++) {
        await service.startContactChange(type: ContactType.email, newValue: 'baru$i@contoh.id');
      }
      expect(
        await errorCode(
            service.startContactChange(type: ContactType.email, newValue: 'lagi@contoh.id')),
        'TOO_MANY_REQUESTS',
      );
      // Jenis lain punya kuotanya sendiri, dan kuota pulih sesudah sejam.
      await service.startContactChange(type: ContactType.phone, newValue: '081298765432');
      now = now.add(const Duration(hours: 1));
      await service.startContactChange(type: ContactType.email, newValue: 'lagi@contoh.id');
    });
  });

  test('maskContact', () {
    expect(maskContact('email', 'ab@contoh.id'), 'a***@contoh.id');
    expect(maskContact('phone', '081234567890'), '0812****7890');
  });
}
