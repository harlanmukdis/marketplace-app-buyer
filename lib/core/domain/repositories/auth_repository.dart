import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/auth/auth_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';

/// Kontrak autentikasi yang dikonsumsi `AuthCubit`.
///
/// Tidak ada method yang melempar — semuanya mengembalikan [DataState].
abstract interface class AuthRepository {
  /// Mendaftar **lalu login otomatis**, dalam satu operasi.
  ///
  /// Digabung dengan sengaja, dan di API ini alasannya makin kuat:
  /// `POST /auth/register` **tidak mengembalikan token sama sekali**, hanya
  /// `user_id`. Kalau app berhenti di situ, user yang baru mendaftar berdiri
  /// di layar tanpa sesi apa pun. Menyatukannya di sini membuat urutan itu
  /// tidak mungkin terlupakan pemanggil.
  ///
  /// Kalau pendaftaran berhasil tapi login otomatisnya gagal, hasilnya tetap
  /// [DataSuccess] dengan `meta['auto_login'] = false` — akunnya sungguh
  /// terbentuk, jadi mengarahkan user ke layar login jauh lebih benar
  /// daripada bilang pendaftaran gagal dan membuatnya mencoba lagi dengan
  /// email yang kini sudah terpakai.
  Future<DataState<AuthSessionModel>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  });

  /// Login dan simpan sesi. API ini **berbasis email**, bukan nomor HP.
  Future<DataState<AuthSessionModel>> login({
    required String email,
    required String password,
  });

  /// Profil user aktif. Sekaligus menyimpan identitas ke penyimpanan lokal.
  ///
  /// Wajib dipanggil setelah login: respons login tidak membawa data user
  /// sama sekali, jadi ini satu-satunya sumber id, nama, dan peran.
  Future<DataState<UserModel>> me();

  /// `PATCH /me`.
  Future<DataState<UserModel>> updateProfile({
    String? fullName,
    String? avatarUrl,
  });

  /// Meminta tautan reset password ke email.
  Future<DataState<void>> forgotPassword(String email);

  /// Menyetel password baru dengan token dari email.
  Future<DataState<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Mencabut sesi di server **dan** menghapusnya di perangkat.
  ///
  /// Berbeda dari API sebelumnya yang tidak punya endpoint logout: refresh
  /// token sekarang benar-benar dicabut, bukan sekadar dibuang dari
  /// perangkat. Kegagalan jaringan tidak menghalangi penghapusan lokal —
  /// user yang menekan "keluar" harus selalu keluar.
  Future<void> logout();

  /// Ada token tersimpan yang bisa dipakai memulihkan sesi.
  bool get hasSession;
}
