import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';

/// Keamanan akun dan pemulihan kata sandi. Tidak ada method yang melempar.
///
/// Verifikasi identitas dan ganti kontak memakai **kontrak usulan** yang
/// dijawab mock di debug. Tanpa mock, keduanya gagal dengan
/// `DataError.isRouteNotFound` — pemanggil memperlakukannya sebagai "fitur
/// belum tersedia", bukan error.
abstract interface class AccountRepository {
  /// Perangkat yang sedang login, sudah dikelompokkan (lihat
  /// `groupLoginSessions`). `meta` diteruskan dari `GET /me/sessions`.
  Future<DataState<List<LoginDevice>>> fetchDevices();

  /// Mencabut **semua** sesi milik [device], lalu membaca ulang daftarnya —
  /// `DELETE /me/sessions/{id}` selalu `200`, jadi hanya daftar baru yang
  /// membuktikan sesinya hilang.
  Future<DataState<List<LoginDevice>>> revokeDevice(LoginDevice device);

  Future<DataState<IdentityVerificationModel>> fetchIdentityVerification();

  Future<DataState<IdentityVerificationModel>> submitIdentityVerification({
    required String idCardNumber,
    required String fullName,
  });

  Future<DataState<ContactChangeChallenge>> startContactChange({
    required ContactType type,
    required String newValue,
  });

  Future<DataState<ContactChangeChallenge>> verifyContactChange({
    required String requestId,
    required String otp,
  });

  /// `POST /auth/forgot-password`, **dengan** token dev kalau server
  /// mengirimkannya. `AuthRepository.forgotPassword` membuang isi respons,
  /// jadi token itu hanya bisa didapat lewat sini.
  Future<DataState<PasswordResetRequest>> requestPasswordReset(String email);

  /// `POST /auth/reset-password`. Server mencabut **semua** sesi akun itu
  /// sesudahnya (`revoke_all_for_user`).
  Future<DataState<void>> resetPassword({
    required String token,
    required String newPassword,
  });
}
