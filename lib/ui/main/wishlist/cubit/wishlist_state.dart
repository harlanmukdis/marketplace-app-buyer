part of 'wishlist_cubit.dart';

/// Status wishlist.
@freezed
sealed class WishlistState with _$WishlistState {
  const WishlistState._();

  const factory WishlistState.loading() = WishlistLoading;

  const factory WishlistState.ready({
    @Default(<WishlistItemModel>[]) List<WishlistItemModel> items,

    /// Id **produk** yang sedang dikirim ke server, supaya hanya barisnya yang
    /// terkunci — bukan seluruh layar.
    @Default(<int>{}) Set<int> mutatingProductIds,
    DataError? actionError,
  }) = WishlistReady;

  const factory WishlistState.error(DataError error) = WishlistError;

  bool get isEmpty => switch (this) {
        WishlistReady(:final items) => items.isEmpty,
        _ => false,
      };

  /// Apakah sebuah produk ada di wishlist. Dipakai tombol hati di halaman
  /// detail produk.
  bool contains(int productId) => switch (this) {
        WishlistReady(:final items) =>
          items.any((i) => i.productId == productId),
        _ => false,
      };
}
