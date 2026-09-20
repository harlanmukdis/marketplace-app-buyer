part of 'auth_cubit.dart';

/// Status autentikasi.
///
/// Union `freezed` — bukan marker state seperti pola sample di
/// `lib/features/`, karena data yang dibawa (user, error) memang bagian dari
/// status itu sendiri.
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;

  /// Sedang login / mendaftar / memuat profil.
  const factory AuthState.loading() = AuthLoading;

  /// Sesi aktif. [user] `null` kalau profil belum berhasil dimuat — sesi tetap
  /// sah, jadi user tidak boleh ditendang ke login hanya karena `GET /auth/me`
  /// gagal.
  const factory AuthState.authenticated({
    UserModel? user,

    /// Sedang menyimpan perubahan profil (`PATCH /me`).
    @Default(false) bool isSaving,

    /// Kegagalan aksi profil.
    ///
    /// Dipisahkan dari [AuthUnauthenticated.error] dengan sengaja: gagal
    /// menyimpan nama **bukan** alasan melempar user ke layar masuk.
    DataError? actionError,
  }) = AuthAuthenticated;

  /// Belum login. [error] terisi kalau penyebabnya kegagalan, bukan keadaan
  /// awal atau logout biasa.
  const factory AuthState.unauthenticated({DataError? error}) =
      AuthUnauthenticated;

  /// Akun terdaftar tapi login otomatisnya gagal — akun **sudah terbentuk**,
  /// jadi UI harus mengarahkan ke layar login, bukan menyuruh mendaftar lagi
  /// (yang akan kena `409 PHONE_TAKEN`).
  const factory AuthState.registeredNeedsLogin() = AuthRegisteredNeedsLogin;
}
