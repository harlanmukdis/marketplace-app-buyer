import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'my_reviews_cubit.freezed.dart';

@freezed
sealed class MyReviewsState with _$MyReviewsState {
  const factory MyReviewsState.loading() = MyReviewsLoading;

  const factory MyReviewsState.loaded({
    required List<MyReviewModel> reviews,

    /// `meta` halaman pertama — membawa `mock: true` selama `GET /me/reviews`
    /// masih disimulasikan.
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
    @Default(1) int page,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    DataError? loadMoreError,
  }) = MyReviewsLoaded;

  const factory MyReviewsState.empty({@Default(<String, dynamic>{}) Map<String, dynamic> meta}) =
      MyReviewsEmpty;

  /// `GET /me/reviews` belum ada di server (404 HTML) dan mock dimatikan.
  /// Dipisah dari [MyReviewsState.error] karena tidak ada yang bisa dicoba
  /// ulang — fiturnya memang belum dibangun backend.
  const factory MyReviewsState.unsupported() = MyReviewsUnsupported;

  const factory MyReviewsState.error(DataError error) = MyReviewsError;
}

/// "Ulasan Saya" — ulasan milik pembeli beserta jendela ubah 30 harinya
/// (docs/22 #8).
///
/// ⚠️ `GET /me/reviews` **diusulkan, belum ada di backend**; di build debug
/// dijawab mock. Paginasinya dihitung dari `meta.total` (kontrak yang
/// diusulkan mengikuti `GET /products/{id}/reviews`, bukan `/orders` yang
/// tanpa `meta`).
class MyReviewsCubit extends Cubit<MyReviewsState> {
  MyReviewsCubit()
      : _repository = injector<ReviewRepository>(),
        super(const MyReviewsState.loading());

  final ReviewRepository _repository;

  Future<void> load() async {
    emit(const MyReviewsState.loading());
    final result = await _repository.fetchMine();
    if (isClosed) return;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        emit(MyReviewsState.loaded(
          reviews: data,
          meta: meta,
          hasMore: _hasMore(meta, data.length),
        ));
      case DataEmpty(:final meta):
        emit(MyReviewsState.empty(meta: meta));
      case DataFailed(:final error) when error.isRouteNotFound:
        emit(const MyReviewsState.unsupported());
      case DataFailed(:final error):
        emit(MyReviewsState.error(error));
      case DataLoading():
        break;
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MyReviewsLoaded || !current.hasMore || current.isLoadingMore) return;
    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));
    final result = await _repository.fetchMine(page: current.page + 1);
    if (isClosed) return;
    final latest = state;
    if (latest is! MyReviewsLoaded) return;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        final known = latest.reviews.map((r) => r.id).toSet();
        final merged = [...latest.reviews, ...data.where((r) => !known.contains(r.id))];
        emit(latest.copyWith(
          reviews: merged,
          page: latest.page + 1,
          isLoadingMore: false,
          hasMore: _hasMore(meta, merged.length),
        ));
      case DataEmpty():
        emit(latest.copyWith(isLoadingMore: false, hasMore: false));
      case DataFailed(:final error):
        emit(latest.copyWith(isLoadingMore: false, loadMoreError: error));
      case DataLoading():
        break;
    }
  }

  /// Mengganti satu baris dengan hasil `PATCH /reviews/{id}` tanpa memuat
  /// ulang seluruh daftar (dan tanpa melompatkan posisi gulir).
  void replace(MyReviewModel updated) {
    final current = state;
    if (current is! MyReviewsLoaded) return;
    emit(current.copyWith(reviews: [
      for (final r in current.reviews) r.id == updated.id ? updated : r,
    ]));
  }

  static bool _hasMore(Map<String, dynamic> meta, int loaded) {
    final total = asIntOrNull(meta['total']);
    return total != null && loaded < total;
  }
}
