/// Cubit domain akun: lupa kata sandi, verifikasi KTP, ganti kontak, dan
/// perangkat aktif — dengan repository palsu.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/password_reset_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/contact_change_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/identity_verification_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/login_devices_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

import 'support/fake_account_repository.dart';

class _FakeAuth implements AuthRepository {
  _FakeAuth({this.hasSession = false});

  @override
  final bool hasSession;
  int logouts = 0;

  @override
  Future<void> logout() async => logouts++;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const _htmlNotFound = DataError(
  code: 'CLIENT_BAD_RESPONSE',
  message: 'html',
  statusCode: 404,
  kind: DataErrorKind.server,
);

void main() {
  late FakeAccountRepository repo;
  late _FakeAuth auth;

  void register({bool hasSession = false}) {
    repo = FakeAccountRepository();
    auth = _FakeAuth(hasSession: hasSession);
    injector
      ..registerSingleton<AccountRepository>(repo)
      ..registerSingleton<AuthRepository>(auth);
  }

  tearDown(() async => injector.reset());

  group('PasswordResetCubit', () {
    test('email tanpa @ ditolak tanpa menyentuh jaringan', () async {
      register();
      final cubit = PasswordResetCubit();
      await cubit.requestReset('budi');
      expect(cubit.state.error?.code, kLocalValidationCode);
      expect(repo.calls, isEmpty);
    });

    test('permintaan diterima membawa token dev', () async {
      register();
      final cubit = PasswordResetCubit();
      await cubit.requestReset(' budi@contoh.id ');
      expect(repo.calls, ['forgot:budi@contoh.id']);
      expect(cubit.state.sentToEmail, 'budi@contoh.id');
      expect(cubit.state.devResetToken, 'dev-token-1');
    });

    test('rate limit sampai sebagai error, bukan sukses', () async {
      register();
      repo.resetRequest = const DataFailed(DataError(
          code: ApiErrorCode.tooManyRequests, message: 'x', statusCode: 429, kind: DataErrorKind.api));
      final cubit = PasswordResetCubit();
      await cubit.requestReset('budi@contoh.id');
      expect(cubit.state.error?.code, ApiErrorCode.tooManyRequests);
      expect(cubit.state.sentToEmail, isNull);
    });

    test('konfirmasi berbeda dan sandi pendek ditolak lokal', () async {
      register();
      final cubit = PasswordResetCubit();
      await cubit.resetPassword(token: 't', password: '12345', confirmation: '12345');
      expect(cubit.state.error?.message, contains('minimal'));
      await cubit.resetPassword(token: 't', password: '123456', confirmation: '123457');
      expect(cubit.state.error?.message, contains('tidak sama'));
      await cubit.resetPassword(token: ' ', password: '123456', confirmation: '123456');
      expect(cubit.state.error?.message, contains('Kode reset'));
      expect(repo.calls, isEmpty);
    });

    test('reset berhasil membuang sesi lokal yang sudah dicabut server', () async {
      register(hasSession: true);
      final cubit = PasswordResetCubit();
      await cubit.resetPassword(token: 'tok', password: '123456', confirmation: '123456');
      expect(repo.calls, ['reset:tok']);
      expect(auth.logouts, 1);
      expect(cubit.state.resetDone, isTrue);
    });

    test('INVALID_TOKEN tidak mengeluarkan siapa pun', () async {
      register(hasSession: true);
      repo.resetResult = const DataFailed(DataError(
          code: ApiErrorCode.invalidToken, message: 'x', statusCode: 422, kind: DataErrorKind.api));
      final cubit = PasswordResetCubit();
      await cubit.resetPassword(token: 'tok', password: '123456', confirmation: '123456');
      expect(auth.logouts, 0);
      expect(cubit.state.resetDone, isFalse);
      expect(cubit.state.error?.code, ApiErrorCode.invalidToken);
    });
  });

  group('IdentityVerificationCubit', () {
    test('endpoint belum ada (404 HTML) → unavailable, bukan error', () async {
      register();
      repo.identity = const DataFailed(_htmlNotFound);
      final cubit = IdentityVerificationCubit();
      await cubit.load();
      expect(cubit.state, isA<IdentityVerificationUnavailable>());
    });

    test('NIK bukan 16 digit ditolak lokal', () async {
      register();
      final cubit = IdentityVerificationCubit();
      await cubit.load();
      expect(await cubit.submit(idCardNumber: '12345', fullName: 'Budi Santoso'), isFalse);
      final state = cubit.state as IdentityVerificationReady;
      expect(state.submitError?.code, kLocalValidationCode);
      expect(repo.calls, ['fetchIdentity']);
    });

    test('pengajuan sah → pending, nama terkunci', () async {
      register();
      final cubit = IdentityVerificationCubit();
      await cubit.load();
      expect(await cubit.submit(idCardNumber: '3171 0101 0101 3456', fullName: ' Budi '), isTrue);
      expect(repo.calls.last, 'submitIdentity:3171010101013456:Budi');
      final state = cubit.state as IdentityVerificationReady;
      expect(state.verification.isPending, isTrue);
      expect(state.verification.locksFullName, isTrue);
    });
  });

  group('ContactChangeCubit', () {
    test('format dan nilai yang sama ditolak lokal', () async {
      register();
      final cubit = ContactChangeCubit(type: ContactType.email, currentValue: 'budi@contoh.id');
      await cubit.request('bukan-email');
      expect(cubit.state.error?.code, kLocalValidationCode);
      // Server menolak nilai yang sama sebagai EMAIL_TAKEN — pesan yang
      // menyesatkan, jadi dicegah di sini.
      await cubit.request('BUDI@contoh.id');
      expect(cubit.state.error?.message, contains('sama'));
      final phone = ContactChangeCubit(type: ContactType.phone);
      await phone.request('12345');
      expect(phone.state.error?.code, kLocalValidationCode);
      expect(repo.calls, isEmpty);
    });

    test('minta kode → masukkan kode → tersimpan', () async {
      register();
      final cubit = ContactChangeCubit(type: ContactType.email, currentValue: 'budi@contoh.id');
      await cubit.request('baru@contoh.id');
      expect(cubit.state.awaitingToken, isTrue);
      expect(cubit.state.request?.devVerificationToken, 'dev-contact-token');

      await cubit.confirm('   ');
      expect(cubit.state.error?.code, kLocalValidationCode);

      // Spasi/baris baru dari tempelan email dibuang.
      await cubit.confirm(' abc123\n');
      expect(cubit.state.completed, isTrue);
      expect(repo.calls, [
        'requestContact:email:baru@contoh.id',
        'confirmContact:email:abc123',
      ]);
    });

    test('kode salah tetap menunggu kode', () async {
      register();
      repo.contactConfirmResults = [const DataFailed(DataError(
          code: 'INVALID_TOKEN', message: 'x', statusCode: 422, kind: DataErrorKind.api))];
      final cubit = ContactChangeCubit(type: ContactType.phone);
      await cubit.request('0812 3456 7890');
      await cubit.confirm('salah');

      expect(cubit.state.error?.code, 'INVALID_TOKEN');
      expect(cubit.state.awaitingToken, isTrue);
      expect(repo.calls.first, 'requestContact:phone:081234567890');
    });

    test('kontak keburu dipakai saat konfirmasi → kembali ke langkah awal',
        () async {
      // Server mengonsumsi token sebelum memeriksa, jadi kode itu sudah
      // hangus — menunggu kode lagi akan buntu.
      register();
      repo.contactConfirmResults = [const DataFailed(DataError(
          code: 'EMAIL_TAKEN', message: 'x', statusCode: 409, kind: DataErrorKind.api))];
      final cubit = ContactChangeCubit(type: ContactType.email);
      await cubit.request('baru@contoh.id');
      await cubit.confirm('abc');

      expect(cubit.state.awaitingToken, isFalse);
      expect(cubit.state.error?.code, 'EMAIL_TAKEN');
      expect(cubit.state.newValue, 'baru@contoh.id');
    });
  });

  group('LoginDevicesCubit', () {
    test('perangkat ini tidak dicabut lewat DELETE', () async {
      register();
      repo.devices = DataSuccess([device(1, current: true), device(2)]);
      final cubit = LoginDevicesCubit();
      await cubit.load();
      await cubit.revoke((cubit.state as LoginDevicesReady).devices.first);
      expect(repo.calls, ['fetchDevices']);
    });

    test('keluarkan semua perangkat lain, satu per satu', () async {
      register();
      repo
        ..devices = DataSuccess([device(1, current: true), device(2), device(3)])
        ..afterRevoke = DataSuccess([device(1, current: true)]);
      final cubit = LoginDevicesCubit();
      await cubit.load();
      await cubit.revokeOthers();
      expect(repo.calls, ['fetchDevices', 'revoke:2', 'revoke:3']);
      expect((cubit.state as LoginDevicesReady).devices, hasLength(1));
    });

    test('gagal mencabut mempertahankan daftar dan menampilkan error', () async {
      register();
      repo
        ..devices = DataSuccess([device(1, current: true), device(2)])
        ..afterRevoke = const DataFailed(DataError(
            code: ClientErrorCode.network, message: 'x', kind: DataErrorKind.network));
      final cubit = LoginDevicesCubit();
      await cubit.load();
      await cubit.revoke((cubit.state as LoginDevicesReady).devices.last);
      final state = cubit.state as LoginDevicesReady;
      expect(state.devices, hasLength(2));
      expect(state.revokingKey, isNull);
      expect(state.actionError?.code, ClientErrorCode.network);
    });
  });
}
