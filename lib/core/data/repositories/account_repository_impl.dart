import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/account_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';

class AccountRepositoryImpl with RepositoryGuard implements AccountRepository {
  AccountRepositoryImpl(
    this._service,
    this._auth, {
    DateTime? Function()? tokenIssuedAt,
  }) : _tokenIssuedAt = tokenIssuedAt ?? _issuedAtFromPrefs;

  final AccountService _service;
  final AuthService _auth;
  final DateTime? Function() _tokenIssuedAt;

  /// Saat access token yang sedang dipegang diterbitkan, dihitung mundur dari
  /// kedaluwarsanya. `TokenStore` menyimpan kedaluwarsa itu di prefs sebagai
  /// ISO UTC; `expires_in` sendiri tidak disimpan, jadi dipakai 900 detik
  /// yang terbukti konsisten di server ini.
  static DateTime? _issuedAtFromPrefs() {
    final raw = CachedHelper.getData(kAccessTokenExpiry);
    final expiry = raw is String ? DateTime.tryParse(raw) : null;
    return expiry?.toUtc().subtract(kAccessTokenLifetime);
  }

  @override
  Future<DataState<List<LoginDevice>>> fetchDevices() async {
    final result = await guardList(_service.fetchSessions);
    return switch (result) {
      DataSuccess(:final data, :final meta, :final statusCode) => DataSuccess(
          groupLoginSessions(data, tokenIssuedAt: _tokenIssuedAt()),
          meta: meta,
          statusCode: statusCode,
        ),
      DataEmpty(:final meta) => DataEmpty(meta: meta),
      DataFailed(:final error) => DataFailed(error),
      DataLoading() => const DataLoading(),
    };
  }

  @override
  Future<DataState<List<LoginDevice>>> revokeDevice(LoginDevice device) async {
    // Berurutan, bukan Future.wait: `php -S` single-threaded, dan satu
    // perangkat bisa punya puluhan baris (satu per refresh).
    for (final id in device.sessionIds) {
      try {
        await _service.revokeSession(id);
      } on ApiException catch (e) {
        return DataFailed(e.error);
      }
    }
    return fetchDevices();
  }

  @override
  Future<DataState<IdentityVerificationModel>> fetchIdentityVerification() =>
      guard(_service.fetchIdentityVerification);

  @override
  Future<DataState<IdentityVerificationModel>> submitIdentityVerification({
    required String idCardNumber,
    required String fullName,
  }) =>
      guard(() => _service.submitIdentityVerification(
            idCardNumber: idCardNumber,
            fullName: fullName,
          ));

  @override
  Future<DataState<ContactChangeRequest>> requestContactChange({
    required ContactType type,
    required String newValue,
  }) =>
      guard(() => _service.requestContactChange(type: type, newValue: newValue));

  @override
  Future<DataState<void>> confirmContactChange({
    required ContactType type,
    required String token,
  }) async {
    try {
      final env = await _service.confirmContactChange(type: type, token: token);
      return DataSuccess(null, meta: env.meta, statusCode: env.statusCode);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<PasswordResetRequest>> requestPasswordReset(
      String email) async {
    try {
      final env = await _auth.forgotPassword(email: email);
      final data = env.data;
      final token = data is Map ? data['dev_reset_token']?.toString() : null;
      return DataSuccess(
        PasswordResetRequest(
            devResetToken: (token ?? '').isEmpty ? null : token),
        meta: env.meta,
        statusCode: env.statusCode,
      );
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<void>> resetPassword({
    required String token,
    required String newPassword,
  }) =>
      guardVoid(
          () => _auth.resetPassword(token: token, newPassword: newPassword));
}
