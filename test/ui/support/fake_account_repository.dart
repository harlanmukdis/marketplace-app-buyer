/// `AccountRepository` palsu untuk test cubit dan layar akun.
///
/// Setiap hasil bisa disetel per test, dan setiap panggilan dicatat di
/// [calls] supaya test bisa memastikan validasi lokal **tidak** menyentuh
/// jaringan.
library;

import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';

const mockMeta = <String, dynamic>{'mock': true};

class FakeAccountRepository implements AccountRepository {
  final List<String> calls = [];

  DataState<List<LoginDevice>> devices = const DataEmpty();
  DataState<List<LoginDevice>>? afterRevoke;
  DataState<IdentityVerificationModel> identity = const DataSuccess(
    IdentityVerificationModel(),
    meta: mockMeta,
  );
  DataState<IdentityVerificationModel> submitResult = const DataSuccess(
    IdentityVerificationModel(status: 'pending', idCardNumberMasked: '************3456'),
    meta: mockMeta,
  );
  DataState<ContactChangeChallenge> startResult = const DataSuccess(
    ContactChangeChallenge(requestId: 'r1', otpSentTo: 'e2***@example.id'),
    meta: mockMeta,
  );
  List<DataState<ContactChangeChallenge>> verifyResults = [];
  DataState<PasswordResetRequest> resetRequest =
      const DataSuccess(PasswordResetRequest(devResetToken: 'dev-token-1'));
  DataState<void> resetResult = const DataSuccess(null);

  @override
  Future<DataState<List<LoginDevice>>> fetchDevices() async {
    calls.add('fetchDevices');
    return devices;
  }

  @override
  Future<DataState<List<LoginDevice>>> revokeDevice(LoginDevice device) async {
    calls.add('revoke:${device.sessionIds.join(',')}');
    return afterRevoke ?? devices;
  }

  @override
  Future<DataState<IdentityVerificationModel>> fetchIdentityVerification() async {
    calls.add('fetchIdentity');
    return identity;
  }

  @override
  Future<DataState<IdentityVerificationModel>> submitIdentityVerification({
    required String idCardNumber,
    required String fullName,
  }) async {
    calls.add('submitIdentity:$idCardNumber:$fullName');
    return submitResult;
  }

  @override
  Future<DataState<ContactChangeChallenge>> startContactChange({
    required ContactType type,
    required String newValue,
  }) async {
    calls.add('startContact:${type.code}:$newValue');
    return startResult;
  }

  @override
  Future<DataState<ContactChangeChallenge>> verifyContactChange({
    required String requestId,
    required String otp,
  }) async {
    calls.add('verifyContact:$requestId:$otp');
    return verifyResults.removeAt(0);
  }

  @override
  Future<DataState<PasswordResetRequest>> requestPasswordReset(String email) async {
    calls.add('forgot:$email');
    return resetRequest;
  }

  @override
  Future<DataState<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    calls.add('reset:$token');
    return resetResult;
  }
}

LoginDevice device(int id, {bool current = false, String ua = 'Dart/3.11 (dart:io)'}) =>
    LoginDevice(
      key: 'k$id',
      isCurrent: current,
      sessions: [
        LoginSessionModel(
          id: id,
          userAgent: ua,
          ipAddress: '10.0.0.$id',
          createdAt: DateTime.utc(2026, 9, 29, 3, id),
        ),
      ],
    );
