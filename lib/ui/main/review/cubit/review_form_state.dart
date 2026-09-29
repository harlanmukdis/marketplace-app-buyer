part of 'review_form_cubit.dart';

/// Status formulir "Beri Ulasan" / "Ubah Ulasan".
@freezed
sealed class ReviewFormState with _$ReviewFormState {
  const ReviewFormState._();

  const factory ReviewFormState.loading() = ReviewFormLoading;

  const factory ReviewFormState.ready({
    /// Snapshot dari baris pesanan (ulasan baru) atau dari `GET /me/reviews`
    /// (ubah ulasan) — dua sumber, jadi yang disimpan hanya yang dibutuhkan
    /// layar, bukan `OrderModel`.
    required String productName,
    @Default('') String optionLabel,
    @Default(0) int storeId,

    /// Ulasan yang sedang diubah; `null` untuk ulasan baru.
    MyReviewModel? editing,

    /// Default 5, seperti desain.
    @Default(5) int rating,
    @Default('') String comment,
    @Default(false) bool isAnonymous,
    @Default(false) bool isSubmitting,
    DataError? submitError,

    /// Ulasan diterima server. Layar menutup diri begitu ini `true`.
    @Default(false) bool submitted,

    /// Hasil `PATCH /reviews/{id}` (mode ubah), dikembalikan layar lewat
    /// `pop` supaya "Ulasan Saya" bisa mengganti barisnya tanpa memuat ulang.
    MyReviewModel? updated,
  }) = ReviewFormReady;

  /// Pesanan gagal dimuat, barisnya tidak ada, pesanannya belum selesai, atau
  /// jendela ubah 30 hari sudah lewat.
  const factory ReviewFormState.error(DataError error) = ReviewFormError;

  bool get isEditing => switch (this) {
        ReviewFormReady(:final editing) => editing != null,
        _ => false,
      };
}
