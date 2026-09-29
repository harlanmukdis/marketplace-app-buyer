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
      await cubit.start('bukan-email');
      expect(cubit.state.error?.code, kLocalValidationCode);
      await cubit.start('BUDI@contoh.id');
      expect(cubit.state.error?.message, contains('sama'));
      final phone = ContactChangeCubit(type: ContactType.phone);
      await phone.start('12345');
      expect(phone.state.error?.code, kLocalValidationCode);
      expect(repo.calls, isEmpty);
    });

    test('dua tahap OTP sampai selesai', () async {
      register();
      repo.verifyResults = [
        const DataSuccess(
          ContactChangeChallenge(requestId: 'r1', stage: 'new_contact', otpSentTo: 'ba***@contoh.id'),
          meta: mockMeta,
        ),
        const DataSuccess(
          ContactChangeChallenge(requestId: 'r1', stage: 'completed', newValue: 'baru@contoh.id'),
          meta: mockMeta,
        ),
      ];
      final cubit = ContactChangeCubit(type: ContactType.email, currentValue: 'budi@contoh.id');
      await cubit.start('baru@contoh.id');
      expect(cubit.state.challenge?.stageValue, ContactChangeStage.currentContact);

      await cubit.verify('12');
      expect(cubit.state.error?.code, kLocalValidationCode, reason: 'OTP harus 6 angka');

      await cubit.verify('123456');
      expect(cubit.state.challenge?.stageValue, ContactChangeStage.newContact);
      await cubit.verify('123456');
      expect(cubit.state.isCompleted, isTrue);
      expect(repo.calls, [
        'startContact:email:baru@contoh.id',
        'verifyContact:r1:123456',
        'verifyContact:r1:123456',
      ]);
    });

    test('endpoint belum ada → unavailable', () async {
      register();
      repo.startResult = const DataFailed(_htmlNotFound);
      final cubit = ContactChangeCubit(type: ContactType.phone);
      await cubit.start('081234567890');
      expect(cubit.state.unavailable, isTrue);
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
