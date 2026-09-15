import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';

/// Ulasan beserta sebaran bintangnya.
///
/// Digabung karena halaman ulasan selalu menampilkan keduanya, dan histogram
/// datang di `meta` permintaan yang sama — memisahkannya berarti dua panggilan
/// untuk satu layar.
class ReviewPage {
  const ReviewPage({
    required this.reviews,
    this.histogram = RatingHistogram.empty,
    this.total = 0,
  });

  final List<ReviewModel> reviews;
  final RatingHistogram histogram;

  /// Jumlah ulasan yang cocok dengan filter aktif, dari `meta.total`.
  final int total;

  static const empty = ReviewPage(reviews: []);
}

abstract class ReviewRepository {
  /// Ulasan sebuah produk, opsional disaring per bintang.
  ///
  /// Berbeda dari `/orders`, filter di endpoint ini benar-benar bekerja.
  Future<DataState<ReviewPage>> fetchForProduct(
    int productId, {
    int page,
    int? rating,
  });

  /// Mengirim ulasan untuk satu order item.
  ///
  /// ⚠️ Hanya sah untuk pesanan berstatus `completed`; status lain dibalas
  /// `404 ORDER_ITEM_NOT_FOUND`.
  Future<DataState<int>> create(int orderItemId, ReviewDraft draft);

  Future<DataState<void>> report(int reviewId, {String? reason});
}
