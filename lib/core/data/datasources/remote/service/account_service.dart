import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';

/// Keamanan akun: sesi login, verifikasi identitas, dan ganti kontak.
///
/// Dua jenis endpoint bercampur di sini, dan bedanya penting:
///
/// * **Sungguhan**: `GET /me/sessions`, `DELETE /me/sessions/{id}`.
/// * **Usulan, dijawab mock di debug** (`account_mock_routes.dart`):
///   `/me/identity-verification` (docs/22 #4) dan `/me/contact-change*`
///   (docs/22 #10). Ditulis persis seolah sudah ada; begitu backend
///   membangunnya, cukup hapus rute mock-nya. Dengan mock mati, rute-rute
///   ini dibalas **404 HTML** CodeIgniter → `DataError.isRouteNotFound`, dan
///   layar menyembunyikan fiturnya alih-alih menampilkan error.
class AccountService {
  AccountService(this._dio);

  final Dio _dio;

  /// `GET /me/sessions` — sesi yang belum dicabut dan belum kedaluwarsa,
  /// terbaru dulu. Lihat [LoginSessionModel] soal satu baris per refresh.
  Future<ApiEnvelope<List<LoginSessionModel>>> fetchSessions() async {
    const context = 'GET /me/sessions';
    try {
      final response = await _dio.get<dynamic>('/me/sessions');
      return parseEnvelopeList(response, LoginSessionModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `DELETE /me/sessions/{id}`.
  ///
  /// ⚠️ Selalu `200 data: null` — id yang tidak ada atau milik orang lain
  /// pun (klausa `WHERE user_id` tetap melindungi datanya). Sukses bukan
  /// bukti; repository membaca ulang daftarnya.
  ///
  /// Server **tidak** menolak pencabutan sesi yang sedang dipakai (komentar
  /// kodenya bilang "selain yang dipakai sekarang", tapi tidak ditegakkan),
  /// dan access token yang sudah terbit tetap sah sampai kedaluwarsa
  /// (≤15 menit) — hanya refresh berikutnya yang gagal.
  Future<ApiEnvelope<dynamic>> revokeSession(int id) async {
    final context = 'DELETE /me/sessions/$id';
    try {
      final response = await _dio.delete<dynamic>('/me/sessions/$id');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /me/identity-verification` — **usulan** (mock).
  Future<ApiEnvelope<IdentityVerificationModel>>
      fetchIdentityVerification() async {
    const context = 'GET /me/identity-verification';
    try {
      final response = await _dio.get<dynamic>('/me/identity-verification');
      return parseEnvelope(
        response,
        (raw) => IdentityVerificationModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/identity-verification` — **usulan** (mock). NIK 16 digit.
  /// NIK yang sudah dipakai akun lain → `409 ID_CARD_ALREADY_USED`
  /// (aturan "1 KTP = 1 akun", docs/22 #4).
  Future<ApiEnvelope<IdentityVerificationModel>> submitIdentityVerification({
    required String idCardNumber,
    required String fullName,
  }) async {
    const context = 'POST /me/identity-verification';
    try {
      final response = await _dio.post<dynamic>(
        '/me/identity-verification',
        data: {'id_card_number': idCardNumber, 'full_name': fullName},
      );
      return parseEnvelope(
        response,
        (raw) => IdentityVerificationModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/contact-change` — **usulan** (mock). Memulai penggantian dan
  /// mengirim OTP pertama ke **kontak lama**.
  Future<ApiEnvelope<ContactChangeChallenge>> startContactChange({
    required ContactType type,
    required String newValue,
  }) async {
    const context = 'POST /me/contact-change';
    try {
      final response = await _dio.post<dynamic>(
        '/me/contact-change',
        data: {'type': type.code, 'new_value': newValue},
      );
      return parseEnvelope(
        response,
        (raw) => ContactChangeChallenge.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/contact-change/{id}/verify` — **usulan** (mock). Balasannya
  /// tantangan berikutnya (`new_contact`) atau `stage: completed`.
  ///
  /// Jangan diulang otomatis: tiap panggilan menghabiskan satu percobaan
  /// OTP, dan batasnya lima.
  Future<ApiEnvelope<ContactChangeChallenge>> verifyContactChange({
    required String requestId,
    required String otp,
  }) async {
    final context = 'POST /me/contact-change/$requestId/verify';
    try {
      final response = await _dio.post<dynamic>(
        '/me/contact-change/$requestId/verify',
        data: {'otp': otp},
      );
      return parseEnvelope(
        response,
        (raw) => ContactChangeChallenge.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
