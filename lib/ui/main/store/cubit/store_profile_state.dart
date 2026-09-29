part of 'store_profile_cubit.dart';

@freezed
sealed class StoreProfileState with _$StoreProfileState {
  const StoreProfileState._();

  const factory StoreProfileState.loading() = StoreProfileLoading;

  const factory StoreProfileState.loaded({
    required StoreModel store,

    /// `null` kalau `partners-performance` gagal — baris metrik disembunyikan,
    /// bukan diisi nol.
    StorePerformanceModel? performance,

    /// `meta` respons performance. `meta.mock_fields` memuat
    /// `service_performance.online_status` selama status online toko masih
    /// disimulasikan — dipakai `SimulatedBadge` di metrik "Online".
    @Default(<String, dynamic>{}) Map<String, dynamic> performanceMeta,
    @Default(false) bool isFollowBusy,
    DataError? actionError,
  }) = StoreProfileLoaded;

  const factory StoreProfileState.error(DataError error) = StoreProfileError;
}
