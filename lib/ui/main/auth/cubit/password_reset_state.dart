part of 'password_reset_cubit.dart';

@freezed
abstract class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState({
    @Default(false) bool isSubmitting,
    DataError? error,

    /// Terisi sesudah `forgot-password` diterima server. Server menjawab sama
    /// untuk email terdaftar maupun tidak, jadi ini **bukan** bukti email
    /// terkirim.
    String? sentToEmail,

    /// Token reset yang dikirim backend development. `null` di production,
    /// dan juga `null` kalau emailnya tidak terdaftar.
    String? devResetToken,

    /// Kata sandi baru tersimpan; seluruh sesi akun itu sudah dicabut server.
    @Default(false) bool resetDone,
  }) = _PasswordResetState;
}
