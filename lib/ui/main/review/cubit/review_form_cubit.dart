import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'review_form_cubit.freezed.dart';
part 'review_form_state.dart';

/// Formulir ulasan satu baris pesanan (`POST /order-items/{id}/review`),
/// **atau** pengubahan ulasan sendiri dalam 30 hari (`PATCH /reviews/{id}`,
/// diusulkan — docs/22 #8) kalau [existing] diisi.
///
/// Untuk ulasan baru, pesanannya dimuat lebih dulu (`GET /orders/{id}`)
/// karena dua alasan: layar perlu menampilkan barang yang diulas — snapshot
/// nama dan varian hanya ada di baris pesanan — dan **statusnya harus
/// `completed`**. Server membalas status lain dengan `404
/// ORDER_ITEM_NOT_FOUND`, kode yang sama dengan baris yang benar-benar tidak
/// ada; memeriksanya di sini membuat formulir tidak pernah bisa diisi untuk
/// pesanan yang pasti ditolak.
///
/// Untuk ubah ulasan, barangnya sudah dibawa [MyReviewModel], jadi tidak ada
/// panggilan pesanan; yang diperiksa adalah jendela 30 harinya.
///
/// Tidak ada lampiran foto/video di formulir ini (widget ulasan di halaman
/// produk juga belum menampilkannya).
class ReviewFormCubit extends Cubit<ReviewFormState> {
  ReviewFormCubit({required this.orderId, required this.orderItemId, this.existing})
      : _orders = injector<OrderRepository>(),
        _reviews = injector<ReviewRepository>(),
        super(const ReviewFormState.loading());

  static ReviewFormCubit get(BuildContext context) => BlocProvider.of(context);

  /// Batas panjang ulasan, mengikuti penghitung "0/500" di desain. Server
  /// sendiri tidak membatasi, jadi ini penjaga kewarasan di aplikasi.
  static const maxCommentLength = 500;

  final int orderId;
  final int orderItemId;

  /// Ulasan yang diubah; `null` = ulasan baru.
  final MyReviewModel? existing;
  final OrderRepository _orders;
  final ReviewRepository _reviews;

  Future<void> load() async {
    final review = existing;
    if (review != null) {
      emit(review.canEdit()
          ? ReviewFormState.ready(
              productName: review.productName ?? 'Produk',
              optionLabel: review.optionLabel,
              storeId: review.storeId,
              editing: review,
              rating: review.rating.clamp(1, 5),
              comment: review.comment ?? '',
              isAnonymous: review.isAnonymous,
            )
          : const ReviewFormState.error(DataError(
              code: 'REVIEW_EDIT_WINDOW_CLOSED',
              message: 'Jendela ubah ulasan sudah lewat',
              kind: DataErrorKind.api,
            )));
      return;
    }
    emit(const ReviewFormState.loading());
    final result = await _orders.fetchOrder(orderId);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        final item = data.items.where((i) => i.id == orderItemId).firstOrNull;
        if (item == null) {
          emit(const ReviewFormState.error(DataError(
            code: ApiErrorCode.orderNotFound,
            message: 'Baris pesanan tidak ada di pesanan ini',
            kind: DataErrorKind.api,
          )));
        } else if (!data.isCompleted) {
          emit(const ReviewFormState.error(DataError(
            code: ApiErrorCode.orderItemNotFound,
            message: 'Pesanan belum selesai',
            kind: DataErrorKind.api,
          )));
        } else {
          emit(ReviewFormState.ready(
            productName: item.productName,
            optionLabel: item.optionLabel,
            storeId: data.storeId,
          ));
        }
      case DataFailed(:final error):
        emit(ReviewFormState.error(error));
      case DataEmpty():
        emit(const ReviewFormState.error(DataError(
          code: ApiErrorCode.orderNotFound,
          message: 'Pesanan kosong',
          kind: DataErrorKind.api,
        )));
      case DataLoading():
        break;
    }
  }

  void setRating(int rating) {
    final current = state;
    if (current is! ReviewFormReady || current.isSubmitting) return;
    if (rating < 1 || rating > 5) return;
    emit(current.copyWith(rating: rating, submitError: null));
  }

  void setComment(String comment) {
    final current = state;
    if (current is! ReviewFormReady || current.isSubmitting) return;
    final clipped = comment.length > maxCommentLength
        ? comment.substring(0, maxCommentLength)
        : comment;
    emit(current.copyWith(comment: clipped, submitError: null));
  }

  void setAnonymous(bool value) {
    final current = state;
    if (current is! ReviewFormReady || current.isSubmitting) return;
    emit(current.copyWith(isAnonymous: value));
  }

  /// Mengirim ulasan baru atau perubahannya. Ketukan kedua selagi yang
  /// pertama berjalan diabaikan — satu baris pesanan hanya boleh diulas
  /// sekali (`UNIQUE KEY`), jadi permintaan kembar hanya akan berujung error
  /// untuk yang kedua.
  Future<void> submit() async {
    final current = state;
    if (current is! ReviewFormReady || current.isSubmitting || current.submitted) return;

    final editing = current.editing;
    if (current.rating < 1 || current.rating > 5) return;

    emit(current.copyWith(isSubmitting: true, submitError: null));
    final DataState<Object?> result = editing == null
        ? await _reviews.create(
            orderItemId,
            ReviewDraft(
              rating: current.rating,
              comment: current.comment,
              isAnonymous: current.isAnonymous,
            ),
          )
        : await _reviews.update(
            editing.id,
            ReviewUpdateDraft(
              rating: current.rating,
              comment: current.comment,
              isAnonymous: current.isAnonymous,
            ),
          );
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(current.copyWith(
          isSubmitting: false,
          submitted: true,
          updated: data is MyReviewModel ? data : null,
        ));
      case DataEmpty():
        emit(current.copyWith(isSubmitting: false, submitted: true));
      case DataFailed(:final error):
        emit(current.copyWith(isSubmitting: false, submitError: error));
      case DataLoading():
        break;
    }
  }

  void clearSubmitError() {
    final current = state;
    if (current is! ReviewFormReady || current.submitError == null) return;
    emit(current.copyWith(submitError: null));
  }
}
