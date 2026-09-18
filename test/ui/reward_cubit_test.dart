/// Perilaku [RewardCubit] terhadap repository palsu.
///
/// Yang diuji terutama **ketahanan sebagian**: layar reward menggabungkan lima
/// endpoint, dan hanya saldo poin yang boleh menggagalkan seluruhnya.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/reward/cubit/reward_cubit.dart';

const _tiers = <LoyaltyTierModel>[
  LoyaltyTierModel(id: 1, code: 'bronze', name: 'Bronze', minPoints: 0),
  LoyaltyTierModel(id: 2, code: 'silver', name: 'Silver', minPoints: 1000),
  LoyaltyTierModel(id: 3, code: 'gold', name: 'Gold', minPoints: 5000),
];

RewardOverview _overview({
  int points = 1500,
  LoyaltyMembershipModel? loyalty,
  List<LoyaltyTierModel> tiers = _tiers,
}) =>
    RewardOverview(
      points: RewardBalanceModel(balance: points),
      coins: const RewardBalanceModel(balance: 320),
      loyalty: loyalty ??
          const LoyaltyMembershipModel(
            tierPoints: 1500,
            tier: LoyaltyTierModel(
                id: 2, code: 'silver', name: 'Silver', minPoints: 1000),
          ),
      tiers: tiers,
    );

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeRewardRepository implements RewardRepository {
  DataState<RewardOverview> overviewResult = DataSuccess(_overview());
  DataState<RewardPreviewModel> previewResult =
      const DataSuccess(RewardPreviewModel(estimatedCoins: 50));

  final List<String> calls = [];

  @override
  Future<DataState<RewardOverview>> fetchOverview() async {
    calls.add('overview');
    return overviewResult;
  }

  @override
  Future<DataState<RewardPreviewModel>> previewFromCart() async {
    calls.add('preview');
    return previewResult;
  }
}

void main() {
  late _FakeRewardRepository repository;

  setUp(() {
    repository = _FakeRewardRepository();
    injector.registerSingleton<RewardRepository>(repository);
  });

  tearDown(() async {
    await injector.reset();
  });

  test('memuat saldo, loyalitas, dan tingkat berikutnya', () async {
    final cubit = RewardCubit();
    await cubit.load();

    final state = cubit.state as RewardReady;
    expect(state.overview.points.balance, 1500);
    expect(state.overview.coins.balance, 320);
    expect(state.overview.loyalty?.tierName, 'Silver');
    expect(state.overview.nextTier?.code, 'gold');
    await cubit.close();
  });

  test('gagal memuat saldo poin berakhir di status error', () async {
    // Saldo poin satu-satunya yang fatal — tanpa itu layarnya kosong.
    repository.overviewResult = DataFailed(_error('NETWORK'));

    final cubit = RewardCubit();
    await cubit.load();

    expect(cubit.state, isA<RewardError>());
    await cubit.close();
  });

  test('loyalitas yang gagal dimuat TIDAK mengosongkan layar', () async {
    // Repository mengembalikan overview tanpa loyalty; layar tetap harus
    // menampilkan saldo.
    repository.overviewResult = const DataSuccess(
      RewardOverview(
        points: RewardBalanceModel(balance: 900),
        coins: RewardBalanceModel(balance: 10),
      ),
    );

    final cubit = RewardCubit();
    await cubit.load();

    final state = cubit.state as RewardReady;
    expect(state.overview.points.balance, 900);
    expect(state.overview.loyalty, isNull);
    expect(state.overview.nextTier, isNull,
        reason: 'tanpa loyalitas tidak ada tingkat berikutnya');
    await cubit.close();
  });

  test('daftar tingkat yang kosong tidak membuat nextTier melempar', () async {
    // Terjadi kalau `GET /loyalty/tiers` gagal sementara loyalitas berhasil.
    repository.overviewResult = DataSuccess(_overview(tiers: const []));

    final cubit = RewardCubit();
    await cubit.load();

    expect((cubit.state as RewardReady).overview.nextTier, isNull);
    await cubit.close();
  });

  test('cashback kosong bukan keadaan error', () async {
    final cubit = RewardCubit();
    await cubit.load();

    final state = cubit.state as RewardReady;
    expect(state.overview.hasCashback, isFalse);
    await cubit.close();
  });

  test('refresh menembak ulang', () async {
    final cubit = RewardCubit();
    await cubit.load();
    await cubit.refresh();

    expect(repository.calls, ['overview', 'overview']);
    await cubit.close();
  });
}
