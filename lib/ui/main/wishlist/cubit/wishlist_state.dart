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

    /// Id produk yang sakelar pantau harganya sedang dikirim.
    @Default(<int>{}) Set<int> alertMutatingIds,

    /// `meta` baca terakhir. `meta.mock_fields` berisi `alert_enabled`
    /// selama pantau harga masih disimulasikan (docs/22 #13).
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
    DataError? actionError,
  }) = WishlistReady;

  const factory WishlistState.error(DataError error) = WishlistError;

  bool get isEmpty => switch (this) {
        WishlistReady(:final items) => items.isEmpty,
        _ => false,
      };

  /// Apakah sebuah produk ada di wishlist. Dipakai tombol hati di halaman
  /// detail produk.
  /// Jumlah produk yang sedang dipantau harganya.
  int get watchedCount => switch (this) {
        WishlistReady(:final items) => items.where((i) => i.isWatched).length,
        _ => 0,
      };

  bool contains(int productId) => switch (this) {
        WishlistReady(:final items) =>
          items.any((i) => i.productId == productId),
        _ => false,
      };
}
