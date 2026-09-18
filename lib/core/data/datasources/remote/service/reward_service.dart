import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';

/// Panggilan HTTP untuk poin, koin, loyalitas, dan cashback sisi pembeli.
///
/// ## 🔴 `POST /me/points/redeem` SENGAJA TIDAK DIBUATKAN METHOD
///
/// Dua alasan, keduanya diverifikasi ke server dan ke kode backend.
///
/// **1. Menukar poin tidak memberi apa pun.** `Reward_model::redeem_points()`
/// hanya mengurangi `user_points.balance` lalu mencatat satu baris
/// `point_transactions` bertipe `redeem`. Tidak ada voucher yang terbit, tidak
/// ada saldo yang dikredit, dan **tidak ada satu pun kode lain di backend yang
/// membaca baris itu**. Menyediakan tombolnya berarti mengundang user
/// menghanguskan poinnya sendiri tanpa imbalan.
///
/// **2. Nominal negatif MENCETAK poin.** Penjaganya ditulis
/// `if ($wallet->balance < $amount) throw` — untuk `amount = -1000` itu
/// `0 < -1000`, yang `false`, sehingga lolos; lalu `balance - (-1000)`
/// **menambah** saldo. Diuji ke server: saldo `0` → tukar `-1000` → saldo
/// `1000`, dan poin hasilnya benar-benar bisa dibelanjakan. Nominal `0` juga
/// diterima, dan body tanpa `amount` membalas **500 halaman HTML**.
///
/// Tambahkan method ini begitu backend memperbaiki penjaganya **dan**
/// menyediakan imbalan yang nyata untuk penukaran.
class RewardService {
  RewardService(this._dio);

  final Dio _dio;

  /// `GET /me/points` — saldo poin.
  ///
  /// Barisnya dibuat otomatis kalau belum ada, jadi akun baru mendapat `0`,
  /// bukan `404`.
  Future<ApiEnvelope<RewardBalanceModel>> fetchPoints() =>
      _fetchBalance('/me/points');

  /// `GET /me/coins` — saldo koin. Bentuk responsnya identik dengan poin.
  Future<ApiEnvelope<RewardBalanceModel>> fetchCoins() =>
      _fetchBalance('/me/coins');

  Future<ApiEnvelope<RewardBalanceModel>> _fetchBalance(String path) async {
    final context = 'GET $path';
    try {
      final response = await _dio.get<dynamic>(path);
      return parseEnvelope(
        response,
        (raw) =>
            RewardBalanceModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /me/loyalty` — keanggotaan beserta objek `tier` yang **sudah
  /// disisipkan**, jadi nama tingkat tidak butuh panggilan kedua.
  Future<ApiEnvelope<LoyaltyMembershipModel>> fetchLoyalty() async {
    const context = 'GET /me/loyalty';
    try {
      final response = await _dio.get<dynamic>('/me/loyalty');
      return parseEnvelope(
        response,
        (raw) => LoyaltyMembershipModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /loyalty/tiers` — daftar tingkat, **publik** (tanpa token).
  ///
  /// Dibutuhkan hanya untuk menghitung jarak ke tingkat berikutnya; tingkat
  /// yang sedang berlaku sudah ikut di [fetchLoyalty].
  Future<ApiEnvelope<List<LoyaltyTierModel>>> fetchTiers() async {
    const context = 'GET /loyalty/tiers';
    try {
      final response = await _dio.get<dynamic>('/loyalty/tiers');
      return parseEnvelopeList(response, LoyaltyTierModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /me/cashback` — riwayat cashback.
  ///
  /// ⚠️ Endpoint ini **tidak tercantum di dokumen rute reward mana pun**,
  /// tapi terdaftar di `routes.php` dan hidup. Isinya `[]` di dev karena
  /// cashback baru terbit dari pesanan yang selesai.
  Future<ApiEnvelope<List<CashbackTransactionModel>>> fetchCashback() async {
    const context = 'GET /me/cashback';
    try {
      final response = await _dio.get<dynamic>('/me/cashback');
      return parseEnvelopeList(response, CashbackTransactionModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /checkout/calculate` — estimasi koin dari isi keranjang.
  ///
  /// Rutenya di bawah `/checkout`, tapi muatannya murni reward dan ia
  /// **tidak membuat sesi checkout maupun mereservasi stok** — jadi aman
  /// dipanggil dari layar keranjang, dan tempatnya di sini.
  ///
  /// 🔴 Hasilnya **estimasi, bukan saldo**: `status: "pending_release"`
  /// berarti koinnya baru dilepas saat pesanan selesai, dan dibatalkan kalau
  /// pesanan batal.
  Future<ApiEnvelope<RewardPreviewModel>> previewFromCart() async {
    const context = 'POST /checkout/calculate';
    try {
      final response = await _dio.post<dynamic>('/checkout/calculate');
      return parseEnvelope(
        response,
        (raw) => RewardPreviewModel.fromResponse(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
