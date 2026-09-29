import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

part 'password_reset_cubit.freezed.dart';
part 'password_reset_state.dart';

/// Lupa kata sandi → atur ulang, dua endpoint sungguhan.
///
/// Dipisah dari `AuthCubit` dengan sengaja: `AuthCubit` memancarkan
/// `unauthenticated(error)` untuk setiap kegagalan, dan layar splash/login
/// membaca itu sebagai "sesi berakhir". Gagal meminta tautan reset bukan
/// peristiwa sesi.
class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit()
      : _repository = injector<AccountRepository>(),
        _auth = injector<AuthRepository>(),
        super(const PasswordResetState());

  static PasswordResetCubit get(BuildContext context) => BlocProvider.of(context);

  /// Sama dengan layar daftar. Server sendiri **tidak** memvalidasi panjang
  /// kata sandi baru sama sekali (`reset_password_post` hanya memeriksa
  /// field-nya ada), jadi aturan ini satu-satunya yang berlaku.
  static const int minPasswordLength = 6;

  final AccountRepository _repository;
  final AuthRepository _auth;

  /// `POST /auth/forgot-password`.
  ///
  /// 🔴 Dibatasi **3× per email per jam**, dan penghitungnya bertambah
  /// sebelum email dicari — email yang tidak terdaftar pun menghabiskan
  /// kuota. Karena itu tidak ada kirim ulang otomatis; tombolnya hanya
  /// muncul atas permintaan user.
  Future<void> requestReset(String email) async {
    if (state.isSubmitting) return;
    final value = email.trim();
    if (value.isEmpty || !value.contains('@')) {
      emit(state.copyWith(error: localValidationError('Masukkan email akunmu yang benar.')));
      return;
    }
    emit(state.copyWith(isSubmitting: true, error: null));
    final result = await _repository.requestPasswordReset(value);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => state.copyWith(
          isSubmitting: false,
          sentToEmail: value,
          devResetToken: data.devResetToken,
        ),
      DataFailed(:final error) => state.copyWith(isSubmitting: false, error: error),
      _ => state.copyWith(isSubmitting: false, sentToEmail: value),
    });
  }

  /// Kembali ke formulir email (mis. salah ketik alamat).
  void editEmail() => emit(const PasswordResetState());

  /// `POST /auth/reset-password`.
  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmation,
  }) async {
    if (state.isSubmitting) return;
    final t = token.trim();
    final DataError? invalid = t.isEmpty
        ? localValidationError('Kode reset wajib diisi. Salin dari email yang kami kirim.')
        : password.length < minPasswordLength
            ? localValidationError('Kata sandi minimal $minPasswordLength karakter.')
            : password != confirmation
                ? localValidationError('Konfirmasi kata sandi tidak sama.')
                : null;
    if (invalid != null) {
      emit(state.copyWith(error: invalid));
      return;
    }
    emit(state.copyWith(isSubmitting: true, error: null));
    final result = await _repository.resetPassword(token: t, newPassword: password);
    if (result is DataFailed<void>) {
      if (!isClosed) emit(state.copyWith(isSubmitting: false, error: result.error));
      return;
    }
    // Server mencabut SEMUA sesi akun itu (`revoke_all_for_user`). Kalau
    // perangkat ini sedang masuk (reset dibuka dari Keamanan Akun), token
    // lokalnya ikut dibuang — kalau tidak, app memulihkan sesi yang sudah
    // mati saat dibuka lagi, lalu baru terlempar keluar 15 menit kemudian.
    if (_auth.hasSession) await _auth.logout();
    if (!isClosed) emit(state.copyWith(isSubmitting: false, resetDone: true));
  }
}
