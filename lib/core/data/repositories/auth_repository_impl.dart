import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/auth/auth_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/core/services/token_store.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service, this._tokens);

  final AuthService _service;
  final TokenStore _tokens;

  @override
  bool get hasSession => _tokens.hasSession;

  @override
  Future<DataState<AuthSessionModel>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  }) async {
    try {
      final registered = await _service.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        idCardNumber: idCardNumber,
      );

      // Register tidak memberi token apa pun, jadi tidak ada yang bisa
      // disimpan di sini — login otomatis bukan kenyamanan, melainkan
      // satu-satunya cara user yang baru mendaftar punya sesi.
      try {
        final session = await _service.login(email: email, password: password);
        await _persist(session.data);
        // `GET /me` wajib menyusul: respons login tidak membawa identitas.
        await _loadProfileQuietly();
        return DataSuccess(
          session.data,
          meta: {
            ...registered.meta,
            'auto_login': true,
            'user_id': registered.data.userId,
          },
          statusCode: registered.statusCode,
        );
      } on ApiException {
        // Akunnya sudah benar-benar terbentuk. Melaporkan ini sebagai
        // kegagalan akan membuat user mendaftar ulang dan kena penolakan
        // "email sudah terpakai" — jadi tetap sukses, dengan penanda supaya
        // UI mengarahkannya ke layar login.
        return DataSuccess(
          const AuthSessionModel(accessToken: ''),
          meta: {
            ...registered.meta,
            'auto_login': false,
            'user_id': registered.data.userId,
          },
          statusCode: registered.statusCode,
        );
      }
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<AuthSessionModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _service.login(email: email, password: password);
      await _persist(session.data);
      await _loadProfileQuietly();
      return DataSuccess(
        session.data,
        meta: session.meta,
        statusCode: session.statusCode,
      );
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<UserModel>> me() async {
    try {
      final profile = await _service.me();
      await _saveIdentity(profile.data);
      return DataSuccess(
        profile.data,
        meta: profile.meta,
        statusCode: profile.statusCode,
      );
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<UserModel>> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      await _service.updateProfile(fullName: fullName, avatarUrl: avatarUrl);
      // `PATCH /me` tidak mengembalikan user hasil perubahan, jadi dibaca
      // ulang — supaya pemanggil selalu menerima profil yang sungguh
      // tersimpan, bukan tebakan dari apa yang dikirim.
      return me();
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<void>> forgotPassword(String email) async {
    try {
      await _service.forgotPassword(email: email);
      return const DataSuccess(null);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _service.resetPassword(token: token, newPassword: newPassword);
      return const DataSuccess(null);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  /// Mencabut sesi di server lalu menghapusnya di perangkat.
  ///
  /// Penghapusan lokal berjalan **apa pun** hasil panggilan server: kalau
  /// jaringan mati, user yang menekan "keluar" tetap harus keluar. Refresh
  /// token yang gagal dicabut akan kedaluwarsa sendiri.
  @override
  Future<void> logout() async {
    final refreshToken = _tokens.refreshToken;
    if (refreshToken != null) {
      try {
        await _service.logout(refreshToken: refreshToken);
      } on ApiException {
        // Sengaja ditelan — lihat catatan di atas.
      }
    }
    await _tokens.clear();
  }

  Future<void> _persist(AuthSessionModel session) {
    return _tokens.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresIn: session.expiresIn,
    );
  }

  Future<void> _saveIdentity(UserModel user) {
    return _tokens.saveProfile(
      userId: user.id,
      role: user.roles.map((r) => r.code).join(','),
      fullName: user.fullName,
    );
  }

  /// Mengambil profil tanpa memunculkan error.
  ///
  /// Dipakai tepat setelah login: identitasnya dibutuhkan aplikasi, tapi
  /// kegagalannya tidak boleh membatalkan login yang sudah berhasil — token
  /// sudah tersimpan, dan `GET /me` bisa diulang kapan saja.
  Future<void> _loadProfileQuietly() async {
    try {
      final profile = await _service.me();
      await _saveIdentity(profile.data);
    } on ApiException {
      // Diabaikan dengan sengaja.
    }
  }
}
