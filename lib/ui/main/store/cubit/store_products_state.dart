part of 'store_products_cubit.dart';

@freezed
sealed class StoreProductsState with _$StoreProductsState {
  const factory StoreProductsState.loading() = StoreProductsLoading;

  const factory StoreProductsState.loaded({
    required List<ProductModel> products,

    /// `meta.total` — `null` kalau server tidak mengirimnya.
    int? total,
    @Default(1) int page,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    DataError? loadMoreError,
  }) = StoreProductsLoaded;

  const factory StoreProductsState.empty() = StoreProductsEmpty;

  const factory StoreProductsState.error(DataError error) = StoreProductsError;
}
