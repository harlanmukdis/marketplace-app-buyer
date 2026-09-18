import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';

/// Poin, koin, loyalitas, dan cashback pembeli.
///
/// Tidak ada method "tukar poin": endpointnya tidak memberi imbalan apa pun,
/// dan nominal negatif justru mencetak poin — lihat `RewardService`.
abstract class RewardRepository {
  /// Memuat seluruh isi layar reward dalam satu panggilan.
  ///
  /// Empat endpoint ditembak bersamaan, dan **hanya saldo poin yang fatal**
  /// kalau gagal — sisanya boleh kosong daripada menggagalkan seluruh layar.
  Future<DataState<RewardOverview>> fetchOverview();

  /// Estimasi koin dari isi keranjang, tanpa membuat sesi checkout.
  Future<DataState<RewardPreviewModel>> previewFromCart();
}

/// Isi layar reward dalam satu bentuk.
///
/// Digabung di repository, bukan dirakit ulang di cubit, supaya urutan dan
/// penanganan kegagalan per endpoint hanya ditulis sekali.
class RewardOverview {
  const RewardOverview({
    required this.points,
    required this.coins,
    this.loyalty,
    this.tiers = const [],
    this.cashback = const [],
  });

  final RewardBalanceModel points;
  final RewardBalanceModel coins;

  /// `null` kalau `GET /me/loyalty` gagal — layar tetap menampilkan saldo.
  final LoyaltyMembershipModel? loyalty;

  /// Dipakai menghitung jarak ke tingkat berikutnya. Kosong kalau gagal
  /// dimuat; layar cukup menyembunyikan bar kemajuannya.
  final List<LoyaltyTierModel> tiers;

  final List<CashbackTransactionModel> cashback;

  /// Tingkat berikutnya, `null` kalau sudah tertinggi atau datanya tidak ada.
  LoyaltyTierModel? get nextTier => loyalty?.nextTier(tiers);

  bool get hasCashback => cashback.isNotEmpty;
}
