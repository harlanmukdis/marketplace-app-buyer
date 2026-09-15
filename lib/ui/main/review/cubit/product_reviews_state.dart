part of 'product_reviews_cubit.dart';

/// Status daftar ulasan sebuah produk.
@freezed
sealed class ProductReviewsState with _$ProductReviewsState {
  const ProductReviewsState._();

  const factory ProductReviewsState.loading() = ProductReviewsLoading;

  const factory ProductReviewsState.loaded({
    required ReviewPage page,
    @Default(1) int pageNumber,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,

    /// Filter bintang aktif (1–5); `null` berarti semua.
    int? ratingFilter,
    DataError? loadMoreError,
  }) = ProductReviewsLoaded;

  /// Produk belum punya ulasan sama sekali, atau tidak ada yang cocok dengan
  /// filter bintang.
  const factory ProductReviewsState.empty({
    @Default(RatingHistogram.empty) RatingHistogram histogram,
    int? ratingFilter,
  }) = ProductReviewsEmpty;

  const factory ProductReviewsState.error(DataError error) =
      ProductReviewsError;

  /// Sebaran bintang tetap ditampilkan walau hasil tersaring kosong — ia
  /// dihitung server untuk seluruh produk, bukan untuk hasil yang tersaring.
  RatingHistogram get histogram => switch (this) {
        ProductReviewsLoaded(:final page) => page.histogram,
        ProductReviewsEmpty(:final histogram) => histogram,
        _ => RatingHistogram.empty,
      };

  int? get activeRating => switch (this) {
        ProductReviewsLoaded(:final ratingFilter) => ratingFilter,
        ProductReviewsEmpty(:final ratingFilter) => ratingFilter,
        _ => null,
      };
}
