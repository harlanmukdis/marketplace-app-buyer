import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';

/// Panggilan HTTP untuk `/payment-methods` dan `/payments/{txId}*`.
///
/// ⚠️ **`POST /payments/callback/{provider}` tidak dibuatkan method** — itu
/// webhook milik penyedia pembayaran, diverifikasi tanda tangan HMAC, dan
/// tidak pernah dipanggil aplikasi.
///
/// ⚠️ **Jangan pasang retry otomatis pada [pay]**: backend belum menangani
/// `Idempotency-Key`.
class PaymentService {
  PaymentService(this._dio);

  final Dio _dio;

  /// `GET /payment-methods` — publik, tidak butuh token.
  Future<ApiEnvelope<List<PaymentMethodModel>>> fetchMethods() async {
    const context = 'GET /payment-methods';
    try {
      final response = await _dio.get<dynamic>('/payment-methods');
      return parseEnvelopeList(response, PaymentMethodModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /payments/{txId}` — status transaksi.
  Future<ApiEnvelope<PaymentModel>> fetchPayment(int txId) async {
    final context = 'GET /payments/$txId';
    try {
      final response = await _dio.get<dynamic>('/payments/$txId');
      return parseEnvelope(
        response,
        (raw) => PaymentModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /payments/{txId}/pay` — meminta instruksi bayar (QRIS / VA).
  ///
  /// ⚠️ **Tidak menerima pilihan metode.** Field `payment_method` di body
  /// **diabaikan server**: transaksi sudah terikat metode yang dipilih saat
  /// `POST /checkout/sessions/{id}/confirm`, dan mengirim `qris` pada
  /// transaksi `virtual_account` tetap membalas instruksi VA. Sudah diuji
  /// untuk lima metode. Karena itu method ini sengaja tidak punya parameter
  /// metode — menyediakannya akan menyesatkan pemanggil.
  ///
  /// Bentuk balasannya berbeda per metode; lihat [PaymentInstructionModel].
  Future<ApiEnvelope<PaymentInstructionModel>> pay(int txId) async {
    final context = 'POST /payments/$txId/pay';
    try {
      final response = await _dio.post<dynamic>('/payments/$txId/pay');
      return parseEnvelope(
        response,
        (raw) => PaymentInstructionModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
