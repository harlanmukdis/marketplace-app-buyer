import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/voucher_model.dart';

/// Panggilan HTTP voucher **di luar** pemasangan ke keranjang.
///
/// Memasang dan melepas voucher tetap di `CartService`
/// (`POST /cart/apply-voucher`, `DELETE /cart/vouchers/{code}`), karena
/// keduanya mutasi keranjang yang harus dibaca ulang lewat `CartRepository`.
/// Yang ada di sini: dompet voucher milik pembeli, klaim, dan rekomendasi.
///
/// Semua endpoint di sini **sungguhan dan hidup**, hanya kosong di dev —
/// tidak ada voucher yang di-seed. Jadi tidak ada satu pun yang di-mock:
/// keadaan kosong adalah keadaan normal yang harus dirender (lihat aturan di
/// `PendingApiMock`).
///
/// 🔴 `GET /cart/recommended-vouchers` dan `POST /cart/vouchers/auto-apply`
/// **membalas 500 HTML kalau tidak ada baris tercentang**:
/// `list_eligible_vouchers` menyusun `store_id IN ()` dari toko di keranjang,
/// yang bukan SQL sah saat daftarnya kosong. Pemanggil wajib memastikan
/// `CartSummaryModel.itemCount > 0` lebih dulu — `VoucherCubit` yang
/// menjaganya.
class VoucherService {
  VoucherService(this._dio);

  final Dio _dio;

  /// `GET /me/vouchers` — voucher yang sudah diklaim, terbaru dulu.
  Future<ApiEnvelope<List<VoucherModel>>> fetchMyVouchers() async {
    const context = 'GET /me/vouchers';
    try {
      final response = await _dio.get<dynamic>('/me/vouchers');
      return parseEnvelopeList(response, VoucherModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /vouchers/claim` `{code}` → `201 {id}`.
  ///
  /// Hanya **POST** — `GET` dibalas 405. Penolakannya: `422 VALIDATION_ERROR`
  /// (tanpa kode), `422 VOUCHER_INVALID`, `422 VOUCHER_QUOTA_EXCEEDED`, dan
  /// `409 VOUCHER_ALREADY_CLAIMED`.
  Future<ApiEnvelope<void>> claim(String code) async {
    const context = 'POST /vouchers/claim';
    try {
      final response =
          await _dio.post<dynamic>('/vouchers/claim', data: {'code': code});
      return parseEnvelope(response, (_) {}, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /cart/recommended-vouchers` — voucher terbaik **per slot**
  /// (1 ongkir + 1 platform + 1 per toko), **tanpa** memasang apa pun.
  ///
  /// Bentuk entrinya sama dengan `vouchers[]` di `GET /cart/summary`
  /// ditambah `voucher_id` dan `value` (perkiraan rupiah).
  Future<ApiEnvelope<List<AppliedVoucherModel>>> fetchRecommended() async {
    const context = 'GET /cart/recommended-vouchers';
    try {
      final response = await _dio.get<dynamic>('/cart/recommended-vouchers');
      return parseEnvelopeList(response, AppliedVoucherModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /cart/vouchers/auto-apply` — menghitung kombinasi terbaik lalu
  /// **langsung memasangnya** (mengganti isi slot yang sama). Balasannya
  /// daftar yang benar-benar terpasang; `[]` kalau tidak ada yang eligible.
  Future<ApiEnvelope<List<AppliedVoucherModel>>> autoApply() async {
    const context = 'POST /cart/vouchers/auto-apply';
    try {
      final response = await _dio.post<dynamic>('/cart/vouchers/auto-apply');
      return parseEnvelopeList(response, AppliedVoucherModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
