import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

/// Panggilan HTTP untuk `/wallet*` **sisi pembeli**.
///
/// ⚠️ **`POST /wallet/transfer` sengaja tidak dibuatkan method.** Endpointnya
/// ada dan berfungsi, tapi menuntut `to_user_id` — **id internal numerik**
/// penerima. Satu-satunya endpoint yang bisa menukar email/nama jadi id adalah
/// `/admin/users*`, yang dijawab `403` untuk token buyer. Jadi tidak ada cara
/// sah bagi app member menemukan id tujuan, dan menyediakan method-nya hanya
/// mengundang layar yang tidak mungkin diisi. Tambahkan begitu backend
/// menyediakan pencarian penerima.
///
/// ⚠️ **`/stores/{id}/wallet` juga tidak ada di sini** — itu dompet toko,
/// butuh permission `wallet.view`, dan ditolak untuk pembeli biasa.
class WalletService {
  WalletService(this._dio);

  final Dio _dio;

  /// `GET /wallet` — saldo beserta riwayat mutasi.
  ///
  /// Dompet **dibuat otomatis** kalau belum ada, jadi akun baru dapat saldo
  /// `0`, bukan `404`.
  ///
  /// ⚠️ Riwayatnya dipatok **50 terakhir** di server, tanpa paginasi maupun
  /// filter. Tidak ada cara mengambil mutasi yang lebih lama.
  Future<ApiEnvelope<WalletModel>> fetchWallet() async {
    const context = 'GET /wallet';
    try {
      final response = await _dio.get<dynamic>('/wallet');
      return parseEnvelope(
        response,
        (raw) => WalletModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /wallet/topup` — memulai pengisian saldo.
  ///
  /// ⚠️ **Saldo belum bertambah sesudah panggilan ini.** Yang terbentuk hanya
  /// `payment_transactions` berstatus `pending`; saldo dikredit callback
  /// penyedia setelah topup dibayar. `payment_transaction_id` di balasannya
  /// dipakai langsung oleh layar pembayaran yang sudah ada.
  ///
  /// [paymentMethod] default `qris` di server kalau tidak dikirim.
  Future<ApiEnvelope<WalletTopupResult>> topup({
    required double amount,
    String paymentMethod = 'qris',
  }) async {
    const context = 'POST /wallet/topup';
    try {
      final response = await _dio.post<dynamic>(
        '/wallet/topup',
        data: {'amount': amount, 'payment_method': paymentMethod},
      );
      return parseEnvelope(
        response,
        (raw) => WalletTopupResult.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /wallet/withdraw` → id pengajuan penarikan.
  ///
  /// ⚠️ **Dua penolakan yang sangat berbeda memakai kode yang sama.** Baik
  /// "di bawah minimum" maupun "saldo tidak mencukupi" dibalas
  /// `422 WITHDRAWAL_REJECTED`; hanya `message`-nya berbeda, dan panduan FE
  /// melarang mencocokkan `message`. Karena itu batas minimum diperiksa lebih
  /// dulu di aplikasi (lihat `WithdrawalDraft.meetsMinimum`), sehingga kode
  /// yang benar-benar sampai ke user praktis hanya berarti saldo kurang.
  ///
  /// Saldo **langsung didebit** saat pengajuan dibuat, bukan saat disetujui
  /// admin.
  Future<ApiEnvelope<int>> withdraw(WithdrawalDraft draft) async {
    const context = 'POST /wallet/withdraw';
    try {
      final response = await _dio.post<dynamic>(
        '/wallet/withdraw',
        data: draft.toJson(),
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
