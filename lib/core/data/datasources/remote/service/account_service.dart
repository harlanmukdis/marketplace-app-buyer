import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';

/// Keamanan akun: sesi login, verifikasi identitas, dan ganti kontak.
///
/// Dua jenis endpoint bercampur di sini, dan bedanya penting:
///
/// * **Sungguhan**: `GET /me/sessions`, `DELETE /me/sessions/{id}`.
/// * **Sungguhan** (backend `b501fc3`, docs/22 #10):
///   `/me/{email,phone}/change-request` dan `change-confirm`.
/// * **Usulan, dijawab mock di debug** (`account_mock_routes.dart`):
///   `/me/identity-verification` (docs/22 #4). Dengan mock mati, rutenya
///   dibalas **404 HTML** CodeIgniter → `DataError.isRouteNotFound`, dan
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

  /// `POST /me/{email|phone}/change-request` `{new_email|new_phone}` —
  /// token verifikasi dikirim ke kontak **lama**.
  ///
  /// Permintaan baru untuk jenis yang sama **membatalkan** token lama, jadi
  /// "kirim ulang" cukup memanggil ini lagi. Penolakannya: kosong →
  /// `422 VALIDATION_ERROR` (format **tidak** divalidasi server), sudah
  /// dipakai akun mana pun — termasuk akun ini sendiri — → `409
  /// EMAIL_TAKEN`/`PHONE_TAKEN`, lebih dari 3 permintaan per jam → `429`
  /// (setiap permintaan dihitung, termasuk kirim ulang).
  Future<ApiEnvelope<ContactChangeRequest>> requestContactChange({
    required ContactType type,
    required String newValue,
  }) async {
    final context = 'POST /me/${type.code}/change-request';
    try {
      final response = await _dio.post<dynamic>(
        '/me/${type.code}/change-request',
        data: {type.field: newValue},
      );
      return parseEnvelope(response, ContactChangeRequest.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/{email|phone}/change-confirm` `{token}` — menyimpan kontak
  /// baru. Balasannya `data: null`; pemanggil membaca ulang `GET /me`.
  ///
  /// Token salah, kedaluwarsa (30 menit), atau sudah terpakai →
  /// `422 INVALID_TOKEN`. Kontak yang keburu dipakai akun lain → `409
  /// EMAIL_TAKEN`/`PHONE_TAKEN` — dan 🔴 **tokennya tetap hangus** (dikonsumsi
  /// sebelum diperiksa), jadi pembeli harus meminta kode baru.
  Future<ApiEnvelope<dynamic>> confirmContactChange({
    required ContactType type,
    required String token,
  }) async {
    final context = 'POST /me/${type.code}/change-confirm';
    try {
      final response = await _dio.post<dynamic>(
        '/me/${type.code}/change-confirm',
        data: {'token': token},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
