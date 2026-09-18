part of 'reward_cubit.dart';

/// Status layar reward.
///
/// Tidak ada `empty()`: akun baru selalu punya baris poin, koin, dan
/// keanggotaan — server membuatnya otomatis saat pertama dibaca. Yang kosong
/// hanyalah angkanya, dan itu bukan keadaan tersendiri.
@freezed
sealed class RewardState with _$RewardState {
  const RewardState._();

  const factory RewardState.loading() = RewardLoading;

  const factory RewardState.ready({required RewardOverview overview}) =
      RewardReady;

  const factory RewardState.error(DataError error) = RewardError;
}
