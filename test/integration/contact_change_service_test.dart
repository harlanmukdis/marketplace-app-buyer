/// Kontrak ganti email / nomor HP (backend `b501fc3`, docs/22 #10) terhadap
/// marketplace-api yang **benar-benar jalan**.
///
/// Satu tahap: `change-request` → token 64 hex (30 menit) ke kontak **lama**
/// → `change-confirm {token}` → tersimpan dengan status belum terverifikasi.
/// Token dibaca dari `dev_verification_token` (backend mode development).
///
/// Memakai akun uji `kontak` sendiri karena emailnya BERUBAH tiap putaran;
/// token refresh tetap sah, jadi cache akunnya tetap bisa dipakai. Kuota 3
/// permintaan per jam dikosongkan lewat `support/dev_db.dart`.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/account_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';

import 'support/dev_db.dart';
import 'support/test_account.dart';

void main() {
  late Dio dio;
  late AccountService account;
  late AuthService auth;
  late int userId;

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    account = AccountService(dio);
    auth = AuthService(dio);
    await sharedAccount(dio, purpose: 'kontak');
    userId = await currentUserId(dio);
    await resetContactChangeAttempts(userId);
  });

  tearDown(() => dio.close(force: true));

  String uniqueEmail() =>
      'uji.kontak.baru.${DateTime.now().microsecondsSinceEpoch}@marketplace.local';
  String uniquePhone() {
    final stamp = DateTime.now().microsecondsSinceEpoch.toString();
    return '0857${stamp.substring(stamp.length - 8)}';
  }

  Future<DataError> errorOf(Future<Object?> call) async {
    try {
      await call;
    } on ApiException catch (e) {
      return e.error;
    }
    fail('seharusnya ditolak');
  }

  group('email', () {
    test('minta token → konfirmasi → email berganti, belum terverifikasi',
        () async {
      final newEmail = uniqueEmail();
      final requested = await account.requestContactChange(
          type: ContactType.email, newValue: newEmail);
      final token = requested.data.devVerificationToken;
      expect(token, isNotNull, reason: 'backend dev mengirim token di respons');
      expect(token, hasLength(64), reason: 'hex 64 karakter, bukan OTP 6 angka');

      final confirmed =
          await account.confirmContactChange(type: ContactType.email, token: token!);
      expect(confirmed.data, isNull, reason: 'data null — baca ulang GET /me');

      final me = (await auth.me()).data;
      expect(me.email, newEmail);
      expect(me.emailVerified, isFalse,
          reason: 'hanya kepemilikan email LAMA yang dibuktikan');
    });

    test('🔴 email akun sendiri dibalas EMAIL_TAKEN', () async {
      // Server menganggap akun ini sendiri "pemakai" — karena itu
      // ContactChangeCubit menolak nilai yang sama lebih dulu.
      final own = (await auth.me()).data.email!;
      final error = await errorOf(account.requestContactChange(
          type: ContactType.email, newValue: own));
      expect(error.code, ApiErrorCode.emailTaken);
      expect(error.statusCode, 409);
    });

    test('🔴 format TIDAK divalidasi server; kosong → VALIDATION_ERROR',
        () async {
      final accepted = await account.requestContactChange(
          type: ContactType.email, newValue: 'bukan-email');
      expect(accepted.data.devVerificationToken, isNotNull,
          reason: 'validasi format hanya ada di aplikasi');

      final error = await errorOf(
          account.requestContactChange(type: ContactType.email, newValue: ''));
      expect(error.code, ApiErrorCode.validationError);
    });

    test('token salah → INVALID_TOKEN', () async {
      final error = await errorOf(account.confirmContactChange(
          type: ContactType.email, token: 'a' * 64));
      expect(error.code, ApiErrorCode.invalidToken);
      expect(error.statusCode, 422);
    });

    test('permintaan baru MEMBATALKAN token lama ("kirim ulang")', () async {
      final newEmail = uniqueEmail();
      final first = await account.requestContactChange(
          type: ContactType.email, newValue: newEmail);
      final second = await account.requestContactChange(
          type: ContactType.email, newValue: newEmail);

      final error = await errorOf(account.confirmContactChange(
          type: ContactType.email,
          token: first.data.devVerificationToken!));
      expect(error.code, ApiErrorCode.invalidToken);

      await account.confirmContactChange(
          type: ContactType.email, token: second.data.devVerificationToken!);
      expect((await auth.me()).data.email, newEmail);
    });

    test('🔴 lebih dari 3 permintaan per jam → 429, kirim ulang ikut dihitung',
        () async {
      for (var i = 0; i < 3; i++) {
        await account.requestContactChange(
            type: ContactType.email, newValue: uniqueEmail());
      }
      final error = await errorOf(account.requestContactChange(
          type: ContactType.email, newValue: uniqueEmail()));
      expect(error.code, ApiErrorCode.tooManyRequests);
      expect(error.statusCode, 429);
    });
  });

  group('nomor HP', () {
    test('minta token → konfirmasi → nomor berganti, belum terverifikasi',
        () async {
      // 🔴 Server TIDAK mengirim token ke mana pun untuk HP (tidak ada SMS di
      // backend) — hanya `dev_verification_token` di mode development. Di
      // produksi penggantian HP tidak bisa diselesaikan.
      final newPhone = uniquePhone();
      final requested = await account.requestContactChange(
          type: ContactType.phone, newValue: newPhone);
      final token = requested.data.devVerificationToken!;

      await account.confirmContactChange(type: ContactType.phone, token: token);

      final me = (await auth.me()).data;
      expect(me.phone, newPhone);
      expect(me.phoneVerified, isFalse);
    });

    test('token email tidak bisa dipakai untuk HP', () async {
      final requested = await account.requestContactChange(
          type: ContactType.email, newValue: uniqueEmail());
      final error = await errorOf(account.confirmContactChange(
          type: ContactType.phone,
          token: requested.data.devVerificationToken!));
      expect(error.code, ApiErrorCode.invalidToken);
    });
  });
}
