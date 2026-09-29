import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/config/network/interceptors/auth_interceptor.dart';
import 'package:marketplace_app_member/core/domain/model/auth/auth_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';

/// Panggilan HTTP untuk `/auth/*` dan `/me`.
///
/// Sesuai kontrak lapisan: menangkap [DioException] dan melemparkannya kembali
/// sebagai [ApiException] berkonteks. Tidak mengubah status login — itu tugas
/// repository.
///
/// `POST /auth/refresh` **tidak ada di sini** dengan sengaja: refresh dimiliki
/// `TokenRefresher`, yang memakai `Dio` polos supaya tidak memicu
/// `AuthInterceptor` secara rekursif.
class AuthService {
  AuthService(this._dio);

  final Dio _dio;

  /// `POST /auth/register`.
  ///
  /// Tidak ada field `role`: di marketplace ini satu akun bisa merangkap
  /// banyak peran, dan peran `buyer` diberikan server secara otomatis.
  ///
  /// ⚠️ Responsnya **tanpa token**. Untuk membawa user langsung masuk,
  /// pemanggil harus melanjutkan dengan [login] memakai kredensial yang sama
  /// — lihat `AuthRepositoryImpl.register`.
  ///
  /// [phone] **wajib**, walau contoh di koleksi Postman tidak menandainya
  /// begitu: tanpa nomor, server membalas `422 VALIDATION_ERROR` dengan pesan
  /// "Field wajib belum lengkap" dan `details: null` — tidak menyebut field
  /// mana. Nomor yang sudah dipakai akun lain dibalas `PHONE_TAKEN`.
  ///
  /// [idCardNumber] (NIK KTP) **wajib** sejak backend `3e8906d` (docs/22 #4,
  /// "1 KTP = 1 akun buyer"): kosong → `422` "Field wajib belum lengkap" yang
  /// sama, bukan 16 digit angka → `422 VALIDATION_ERROR`, sudah dipakai akun
  /// lain → `409 IDENTITY_TAKEN`.
  Future<ApiEnvelope<RegisterResultModel>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  }) async {
    const context = 'POST /auth/register';
    try {
      final response = await _dio.post<dynamic>(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
          'phone': phone,
          'id_card_number': idCardNumber,
        },
        options: noAuthOptions(),
      );
      return parseEnvelope(
        response,
        (raw) =>
            RegisterResultModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /auth/login` — **berbasis email**, bukan nomor HP.
  ///
  /// Verifikasi email belum menjadi syarat: akun yang belum terverifikasi
  /// tetap mendapat token (sudah diuji ke server). Jadi jangan memblokir
  /// masuk hanya karena `email_verified` masih false.
  Future<ApiEnvelope<AuthSessionModel>> login({
    required String email,
    required String password,
  }) async {
    const context = 'POST /auth/login';
    try {
      final response = await _dio.post<dynamic>(
        '/auth/login',
        data: {'email': email, 'password': password},
        options: noAuthOptions(),
      );
      return parseEnvelope(
        response,
        (raw) =>
            AuthSessionModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /auth/logout` — mencabut refresh token di server.
  ///
  /// Endpoint ini **tidak ada** di API sebelumnya; dulu logout hanya berarti
  /// membuang token di perangkat, sehingga refresh token tetap sah sampai
  /// kedaluwarsa. Sekarang bisa dicabut betulan.
  Future<ApiEnvelope<dynamic>> logout({required String refreshToken}) async {
    const context = 'POST /auth/logout';
    try {
      final response = await _dio.post<dynamic>(
        '/auth/logout',
        data: {'refresh_token': refreshToken},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /auth/verify-email`.
  ///
  /// 🔴 Sudah diverifikasi ke server: endpoint ini **mengonsumsi token tapi
  /// tidak menandai akun terverifikasi**. Panggilan kedua dengan token yang
  /// sama dibalas `INVALID_TOKEN`, sementara `GET /me` tetap menunjukkan
  /// `email_verified: "0"`. Jangan bangun alur yang menunggu status itu
  /// berubah — user akan terjebak selamanya.
  Future<ApiEnvelope<dynamic>> verifyEmail({required String token}) async {
    const context = 'POST /auth/verify-email';
    try {
      final response = await _dio.post<dynamic>(
        '/auth/verify-email',
        data: {'token': token},
        options: noAuthOptions(),
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<dynamic>> resendVerification({
    required String email,
  }) async {
    const context = 'POST /auth/resend-verification';
    try {
      final response = await _dio.post<dynamic>(
        '/auth/resend-verification',
        data: {'email': email},
        options: noAuthOptions(),
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /auth/forgot-password`.
  ///
  /// Endpoint ini **baru ada di API ini**. Di backend sebelumnya tidak ada
  /// sama sekali, sehingga layar reset password kit tidak punya yang bisa
  /// dipanggil.
  Future<ApiEnvelope<dynamic>> forgotPassword({required String email}) async {
    const context = 'POST /auth/forgot-password';
    try {
      final response = await _dio.post<dynamic>(
        '/auth/forgot-password',
        data: {'email': email},
        options: noAuthOptions(),
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    const context = 'POST /auth/reset-password';
    try {
      final response = await _dio.post<dynamic>(
        '/auth/reset-password',
        data: {'token': token, 'new_password': newPassword},
        options: noAuthOptions(),
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /me` — dulu `GET /auth/me`.
  Future<ApiEnvelope<UserModel>> me() async {
    const context = 'GET /me';
    try {
      final response = await _dio.get<dynamic>('/me');
      return parseEnvelope(
        response,
        (raw) => UserModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `PATCH /me` — profil kini **bisa diubah**.
  ///
  /// API sebelumnya tidak punya endpoint ini sama sekali, jadi layar profil
  /// terpaksa read-only.
  ///
  /// Responsnya `data: null` — perubahannya tersimpan tapi user hasilnya
  /// tidak dikembalikan. Karena itu return-nya `dynamic`, bukan [UserModel];
  /// pemanggil yang butuh data terbaru harus membaca [me] lagi (lihat
  /// `AuthRepositoryImpl.updateProfile`). Mencoba mem-parse respons ini jadi
  /// user akan gagal dengan "Null is not a subtype of Map".
  Future<ApiEnvelope<dynamic>> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    const context = 'PATCH /me';
    try {
      final response = await _dio.patch<dynamic>(
        '/me',
        data: {
          if (fullName != null) 'full_name': fullName,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        },
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
