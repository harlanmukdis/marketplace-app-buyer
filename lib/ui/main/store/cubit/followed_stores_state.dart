part of 'followed_stores_cubit.dart';

@freezed
sealed class FollowedStoresState with _$FollowedStoresState {
  const factory FollowedStoresState.loading() = FollowedStoresLoading;

  const factory FollowedStoresState.loaded({
    required List<FollowedStoreModel> stores,
    @Default(1) int page,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    DataError? loadMoreError,

    /// Id toko yang sedang dilepas, supaya hanya barisnya yang terkunci.
    @Default(<int>{}) Set<int> mutatingIds,
    DataError? actionError,
  }) = FollowedStoresLoaded;

  const factory FollowedStoresState.error(DataError error) = FollowedStoresError;
}
