import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/review_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'product_reviews_cubit.freezed.dart';
part 'product_reviews_state.dart';

/// Ulasan sebuah produk, dengan filter bintang dan paginasi.
///
/// Berbeda dari `OrderListCubit`, paginasi di sini **dihitung**, bukan ditebak:
/// endpoint ulasan mengirim `meta.total`. Filter bintangnya juga benar-benar
/// bekerja di server — tidak seperti `?status=` di `/orders`.
class ProductReviewsCubit extends Cubit<ProductReviewsState> {
  ProductReviewsCubit(this.productId)
      : _repository = injector<ReviewRepository>(),
        super(const ProductReviewsState.loading());

  static ProductReviewsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final int productId;
  final ReviewRepository _repository;

  Future<void> load({int? rating}) async {
    emit(const ProductReviewsState.loading());
    final result = await _repository.fetchForProduct(
      productId,
      page: 1,
      rating: rating,
    );
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        if (data.reviews.isEmpty) {
          emit(ProductReviewsState.empty(
            histogram: data.histogram,
            ratingFilter: rating,
          ));
        } else {
          emit(ProductReviewsState.loaded(
            page: data,
            hasMore: data.reviews.length < data.total,
            ratingFilter: rating,
          ));
        }
      case DataEmpty():
        emit(ProductReviewsState.empty(ratingFilter: rating));
      case DataFailed(:final error):
        emit(ProductReviewsState.error(error));
      case DataLoading():
        break;
    }
  }

  /// Menyaring per bintang. `null` mengembalikan ke semua ulasan.
  Future<void> filterByRating(int? rating) => load(rating: rating);

  Future<void> refresh() => load(rating: state.activeRating);

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProductReviewsLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final nextPage = current.pageNumber + 1;
    final result = await _repository.fetchForProduct(
      productId,
      page: nextPage,
      rating: current.ratingFilter,
    );
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        final merged = [...current.page.reviews, ...data.reviews];
        emit(current.copyWith(
          page: ReviewPage(
            reviews: merged,
            histogram: data.histogram,
            total: data.total,
          ),
          pageNumber: nextPage,
          hasMore: merged.length < data.total,
          isLoadingMore: false,
        ));
      case DataEmpty():
        emit(current.copyWith(hasMore: false, isLoadingMore: false));
      case DataFailed(:final error):
        emit(current.copyWith(isLoadingMore: false, loadMoreError: error));
      case DataLoading():
        break;
    }
  }

  /// Melaporkan ulasan yang dianggap palsu.
  ///
  /// Tidak mengubah daftar: moderasinya berjalan di sisi admin, dan ulasannya
  /// tetap tampil sampai ditindak. Mengembalikan `true` kalau laporannya
  /// diterima server.
  Future<bool> report(int reviewId, {String? reason}) async {
    final result = await _repository.report(reviewId, reason: reason);
    return result is DataSuccess<void>;
  }

  /// Ukuran halaman server, untuk pemanggil yang perlu tahu.
  static int get pageSize => ReviewService.serverPageSize;
}
