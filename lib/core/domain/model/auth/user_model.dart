import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Profil user dari `GET /me`.
///
/// Perubahan mendasar dari API lama: **satu akun boleh punya banyak peran**
/// sekaligus, jadi tidak ada lagi satu kolom `role`. `roles[]` berisi
/// `{code, name}`, dan `stores[]` berisi toko yang dimiliki user — pembeli
/// yang juga berjualan tetap satu akun, bukan dua.
///
/// Karena itu jangan pernah menulis `user.role == 'buyer'`; pakai [isBuyer]
/// / [hasRole], supaya akun yang merangkap peran tidak salah dibaca.
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @IntJson() required int id,
    @StringOrNullJson() String? email,
    @StringOrNullJson() String? phone,
    @StringOrNullJson() @JsonKey(name: 'full_name') String? fullName,
    @StringOrNullJson() @JsonKey(name: 'avatar_url') String? avatarUrl,

    /// `pending_verification` / `active` / `suspended` / `banned` — huruf
    /// kecil di API ini, berbeda dari API lama yang memakai huruf besar.
    ///
    /// **Inilah penanda terverifikasi yang benar**, bukan [emailVerified].
    /// Akun baru lahir sebagai `pending_verification`, dan
    /// `POST /auth/verify-email` mengubahnya jadi `active`.
    @StringJson() @Default('') String status,

    /// Dikirim sebagai `"0"`/`"1"` (tinyint), bukan boolean JSON.
    ///
    /// 🔴 **Jangan dipakai sebagai penanda verifikasi.** Sudah diuji ke
    /// server: `verify-email` menaikkan [status] ke `active` tapi
    /// membiarkan kolom ini `"0"` selamanya. Aplikasi yang menunggu nilai ini
    /// berubah akan menahan user di layar "verifikasi dulu" tanpa jalan
    /// keluar. Pakai [isVerified].
    @BoolJson()
    @JsonKey(name: 'email_verified')
    @Default(false)
    bool emailVerified,
    @BoolJson()
    @JsonKey(name: 'phone_verified')
    @Default(false)
    bool phoneVerified,

    /// API ini memakai `created_at` secara konsisten di seluruh endpoint —
    /// tidak ada lagi campuran `created_date`/`created_at` seperti backend
    /// sebelumnya.
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default(<UserRoleModel>[]) List<UserRoleModel> roles,
    @Default(<UserStoreModel>[]) List<UserStoreModel> stores,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  bool hasRole(String code) => roles.any((r) => r.code == code);

  bool get isBuyer => hasRole('buyer');
  bool get isSeller => hasRole('seller') || stores.isNotEmpty;

  bool get isActive => status == 'active';
  bool get isSuspended => status == 'suspended' || status == 'banned';

  /// Email sudah diverifikasi.
  ///
  /// Dibaca dari [status], bukan `email_verified` — lihat catatan di field
  /// itu. Verifikasi **bukan syarat login**: akun `pending_verification`
  /// tetap mendapat token, jadi jangan memakai ini untuk memblokir masuk.
  bool get isVerified => isActive;

  bool get needsEmailVerification => status == 'pending_verification';

  /// Nama yang layak ditampilkan. Email dipakai sebagai cadangan karena
  /// `full_name` boleh kosong, dan menampilkan string kosong di header
  /// terlihat seperti layar gagal dimuat.
  String get displayName {
    final name = fullName;
    if (name != null && name.trim().isNotEmpty) return name.trim();
    return email ?? phone ?? 'Pengguna';
  }
}

/// Satu peran yang dimiliki user. `code` yang dipakai logika; `name` untuk
/// ditampilkan.
@freezed
abstract class UserRoleModel with _$UserRoleModel {
  const factory UserRoleModel({
    @StringJson() @Default('') String code,
    @StringOrNullJson() String? name,
  }) = _UserRoleModel;

  factory UserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleModelFromJson(json);
}

/// Toko milik user. Kosong untuk pembeli biasa.
@freezed
abstract class UserStoreModel with _$UserStoreModel {
  const factory UserStoreModel({
    @IntJson() required int id,
    @StringOrNullJson() String? name,
    @StringOrNullJson() String? slug,
    @StringOrNullJson() String? status,
  }) = _UserStoreModel;

  factory UserStoreModel.fromJson(Map<String, dynamic> json) =>
      _$UserStoreModelFromJson(json);
}
