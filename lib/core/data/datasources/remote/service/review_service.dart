import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

/// Panggilan HTTP untuk ulasan produk.
///
/// ⚠️ **`POST /reviews/{id}/reply` tidak dibuatkan method** — itu balasan
/// penjual dan butuh permission `review.reply`; token buyer ditolak.
class ReviewService {
  ReviewService(this._dio);

  final Dio _dio;

  /// Ukuran halaman yang dipatok server (`perPage = 20`, tidak bisa diubah
  /// klien). Berbeda dari `/orders`, endpoint ini **mengirim `meta.total`**,
  /// jadi paginasi bisa dihitung, bukan ditebak.
  static const int serverPageSize = 20;

  /// `GET /products/{id}/reviews` — publik.
  ///
  /// Hanya ulasan ber-`status = 'published'` yang dikembalikan.
  ///
  /// [rating] menyaring per bintang persis (1–5). Berbeda dari `/orders`,
  /// filter di endpoint ini **benar-benar bekerja** — controllernya membaca
  /// `?rating=`.
  ///
  /// `meta` membawa `page`/`per_page`/`total` **dan** `rating_histogram`;
  /// keduanya dipakai layar, jadi jangan dibuang di repository.
  Future<ApiEnvelope<List<ReviewModel>>> fetchForProduct(
    int productId, {
    int page = 1,
    int? rating,
  }) async {
    final context = 'GET /products/$productId/reviews';
    try {
      final response = await _dio.get<dynamic>(
        '/products/$productId/reviews',
        queryParameters: <String, dynamic>{
          'page': page,
          if (rating != null) 'rating': rating,
        },
      );
      return parseEnvelopeList(response, ReviewModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /order-items/{id}/review` → id ulasan baru.
  ///
  /// ⚠️ **Hanya untuk order berstatus `completed`.** Server mencari order item
  /// lewat `orders.status = 'completed'`; status lain dibalas
  /// `404 ORDER_ITEM_NOT_FOUND` — bukan `403`. Pesan itu harus diterjemahkan,
  /// karena "tidak ditemukan" akan terbaca user sebagai pesanannya hilang.
  ///
  /// Satu order item hanya bisa diulas sekali; percobaan kedua ditolak unique
  /// key di database.
  Future<ApiEnvelope<int>> create(
    int orderItemId,
    ReviewDraft draft,
  ) async {
    final context = 'POST /order-items/$orderItemId/review';
    try {
      final response = await _dio.post<dynamic>(
        '/order-items/$orderItemId/review',
        data: draft.toJson(),
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /reviews/{id}/report` — melaporkan ulasan palsu.
  Future<ApiEnvelope<dynamic>> report(int reviewId, {String? reason}) async {
    final context = 'POST /reviews/$reviewId/report';
    try {
      final response = await _dio.post<dynamic>(
        '/reviews/$reviewId/report',
        data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /me/reviews?page=` — ulasan milik user login, terbaru dulu.
  ///
  /// ⚠️ **Diusulkan, belum ada di backend** (docs/22 #8) — dijawab mock di
  /// build debug. `meta` membawa `page`/`per_page`/`total`, seperti ulasan
  /// produk.
  Future<ApiEnvelope<List<MyReviewModel>>> fetchMine({int page = 1}) async {
    const context = 'GET /me/reviews';
    try {
      final response = await _dio.get<dynamic>(
        '/me/reviews',
        queryParameters: <String, dynamic>{'page': page},
      );
      return parseEnvelopeList(response, MyReviewModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `PATCH /reviews/{id}` — memperbarui ulasan sendiri dalam 30 hari.
  ///
  /// ⚠️ **Diusulkan, belum ada di backend** (docs/22 #8). Lewat tenggat →
  /// `422 REVIEW_EDIT_WINDOW_CLOSED`; ulasan orang lain / tidak ada →
  /// `404 REVIEW_NOT_FOUND`. Balasan berisi ulasan hasil perubahan — berbeda
  /// dari kebanyakan mutasi di API ini yang membalas `data: null`, karena
  /// kontrak ini masih bisa ditentukan dari sisi klien.
  Future<ApiEnvelope<MyReviewModel>> update(
      int reviewId, ReviewUpdateDraft draft) async {
    final context = 'PATCH /reviews/$reviewId';
    try {
      final response =
          await _dio.patch<dynamic>('/reviews/$reviewId', data: draft.toJson());
      return parseEnvelope(
        response,
        (raw) => MyReviewModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
