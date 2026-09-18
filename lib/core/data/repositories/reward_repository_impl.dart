import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/reward_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';

class RewardRepositoryImpl with RepositoryGuard implements RewardRepository {
  RewardRepositoryImpl(this._service);

  final RewardService _service;

  /// Menembak lima endpoint bersamaan, lalu menyusunnya jadi satu
  /// [RewardOverview].
  ///
  /// Kelimanya dijalankan paralel tapi **di-`await` terpisah**, supaya
  /// kegagalan salah satunya tidak meninggalkan yang lain sebagai *unhandled
  /// async error* — pola yang sama dengan `CheckoutRepositoryImpl._load`.
  ///
  /// Hanya **saldo poin** yang fatal. Loyalitas, daftar tingkat, koin, dan
  /// cashback boleh gagal tanpa mengosongkan layar: masing-masing hanya
  /// mengisi satu bagian, dan menampilkan sisanya jauh lebih berguna daripada
  /// layar error penuh karena satu endpoint sampingan bermasalah.
  @override
  Future<DataState<RewardOverview>> fetchOverview() async {
    final pointsFuture = _service.fetchPoints();
    final coinsFuture = _service.fetchCoins();
    final loyaltyFuture = _service.fetchLoyalty();
    final tiersFuture = _service.fetchTiers();
    final cashbackFuture = _service.fetchCashback();

    RewardBalanceModel? points;
    DataError? pointsError;
    var coins = const RewardBalanceModel();
    LoyaltyMembershipModel? loyalty;
    var tiers = const <LoyaltyTierModel>[];
    var cashback = const <CashbackTransactionModel>[];

    try {
      points = (await pointsFuture).data;
    } on ApiException catch (e) {
      pointsError = e.error;
    }

    try {
      coins = (await coinsFuture).data;
    } on ApiException catch (_) {
      // Sengaja diabaikan — lihat catatan di atas.
    }

    try {
      loyalty = (await loyaltyFuture).data;
    } on ApiException catch (_) {}

    try {
      tiers = (await tiersFuture).data;
    } on ApiException catch (_) {}

    try {
      cashback = (await cashbackFuture).data;
    } on ApiException catch (_) {}

    if (points == null) return DataFailed(pointsError!);

    return DataSuccess(
      RewardOverview(
        points: points,
        coins: coins,
        loyalty: loyalty,
        tiers: tiers,
        cashback: cashback,
      ),
    );
  }

  @override
  Future<DataState<RewardPreviewModel>> previewFromCart() =>
      guard(_service.previewFromCart);
}
