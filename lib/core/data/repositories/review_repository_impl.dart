import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/review_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl(this._service);

  final ReviewService _service;

  @override
  Future<DataState<ReviewPage>> fetchForProduct(
    int productId, {
    int page = 1,
    int? rating,
  }) async {
    try {
      final env = await _service.fetchForProduct(
        productId,
        page: page,
        rating: rating,
      );
      return DataSuccess(
        ReviewPage(
          reviews: env.data,
          // Histogram selalu dibaca dari meta, termasuk saat filter bintang
          // aktif — server menghitungnya untuk seluruh produk, bukan untuk
          // hasil yang tersaring, jadi barnya tidak berubah saat difilter.
          histogram: RatingHistogram.fromMeta(env.meta),
          total: asInt(env.meta['total']),
        ),
        meta: env.meta,
        statusCode: env.statusCode,
      );
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<int>> create(int orderItemId, ReviewDraft draft) async {
    try {
      final env = await _service.create(orderItemId, draft);
      return DataSuccess(env.data, statusCode: env.statusCode);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }

  @override
  Future<DataState<void>> report(int reviewId, {String? reason}) async {
    try {
      await _service.report(reviewId, reason: reason);
      return const DataSuccess(null);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }
}
