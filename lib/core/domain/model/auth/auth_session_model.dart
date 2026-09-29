import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'auth_session_model.freezed.dart';
part 'auth_session_model.g.dart';

/// Sesi dari `POST /auth/login` dan `POST /auth/refresh`.
///
/// **Tidak membawa data user sama sekali** — tidak ada `user_id`, `role`,
/// maupun nama. Identitas harus diambil terpisah lewat `GET /me`. Ini
/// berbeda dari API sebelumnya yang menyelipkan `user_id` dan `role` di
/// respons login.
///
/// `expires_in` = **900 detik (15 menit)**, jauh lebih pendek dari 2 jam di
/// API lama. Artinya refresh berjalan sering, dan mekanisme single-flight di
/// `TokenRefresher` jadi penting: tanpa itu, satu layar yang menembak empat
/// request sekaligus akan memicu empat refresh paralel dan saling
/// membatalkan token.
@freezed
abstract class AuthSessionModel with _$AuthSessionModel {
  const AuthSessionModel._();

  const factory AuthSessionModel({
    @StringJson() @JsonKey(name: 'access_token') required String accessToken,
    @StringOrNullJson() @JsonKey(name: 'refresh_token') String? refreshToken,
    @IntOrNullJson() @JsonKey(name: 'expires_in') int? expiresIn,

    /// UU PDP: kebijakan privasi berubah dan user harus menyetujui ulang.
    /// Sesi tetap sah, tapi aplikasi wajib menampilkan layar persetujuan.
    @BoolJson()
    @JsonKey(name: 'requires_reconsent')
    @Default(false)
    bool requiresReconsent,
  }) = _AuthSessionModel;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionModelFromJson(json);

  /// Kapan access token kedaluwarsa, dihitung saat respons diterima.
  Duration get lifetime => Duration(seconds: expiresIn ?? 900);
}

/// Hasil `POST /auth/register`.
///
/// ⚠️ **Register tidak mengembalikan token apa pun** — hanya `user_id` dan,
/// di mode dev, `dev_verification_token`. Jadi alur pendaftaran tidak bisa
/// langsung masuk ke aplikasi seperti sebelumnya: setelah daftar, aplikasi
/// harus memanggil `login` sendiri dengan kredensial yang baru saja diisi.
@freezed
abstract class RegisterResultModel with _$RegisterResultModel {
  const RegisterResultModel._();

  const factory RegisterResultModel({
    @IntJson() @JsonKey(name: 'user_id') required int userId,

    /// Hanya ada saat backend berjalan dalam mode dev. Jangan pernah
    /// ditampilkan ke user — ini token verifikasi yang di produksi dikirim
    /// lewat email.
    @StringOrNullJson()
    @JsonKey(name: 'dev_verification_token')
    String? devVerificationToken,
  }) = _RegisterResultModel;

  factory RegisterResultModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResultModelFromJson(json);
}
