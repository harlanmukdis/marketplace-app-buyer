import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

/// Satu ulasan produk dari `GET /products/{id}/reviews`.
///
/// ⚠️ **Yang TIDAK dikirim server, walau tabelnya ada:**
///
/// * **Nama pengulas.** Responsnya hanya membawa `user_id`; tidak ada nama
///   maupun avatar, dan tidak ada endpoint publik untuk menukar id jadi nama.
///   Jadi layar ulasan hanya bisa menulis "Pembeli" — lihat [displayName].
/// * **Foto/video ulasan.** Tabel `review_media` ada dan `POST` menerimanya,
///   tapi `list_for_product` tidak ikut menggabungkannya.
///
/// ✅ **Balasan penjual kini IKUT dikirim** (commit backend `d614bd8`).
/// Sebelumnya `list_for_product` hanya `SELECT *` dari tabel `reviews`,
/// sehingga balasan yang sudah tersimpan lewat `POST /reviews/{id}/reply`
/// tidak pernah sampai ke siapa pun — bukan ke pembeli, bukan pula ke
/// penjualnya sendiri. Sekarang ada LEFT JOIN ke `review_replies`, yang aman
/// karena `review_id`-nya UNIQUE (maksimal satu balasan per ulasan).
///
/// Karena itu [isAnonymous] praktis tidak berpengaruh apa-apa di aplikasi
/// member: tanpa nama, semua ulasan sudah anonim.
///
/// Daftar hanya memuat ulasan ber-`status = 'published'`; `hidden`/`flagged`
/// disaring server.
@freezed
abstract class ReviewModel with _$ReviewModel {
  const ReviewModel._();

  const factory ReviewModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'order_item_id') @Default(0) int orderItemId,
    @IntJson() @JsonKey(name: 'user_id') @Default(0) int userId,
    @IntJson() @JsonKey(name: 'product_id') @Default(0) int productId,

    /// 1–5.
    @IntJson() @Default(0) int rating,

    @StringOrNullJson() String? comment,
    @BoolJson() @JsonKey(name: 'is_anonymous') @Default(false) bool isAnonymous,
    @StringJson() @Default('published') String status,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,

    /// Balasan penjual, atau `null` kalau belum dibalas.
    ///
    /// Dirakit server jadi objek bersarang — **bukan** string JSON seperti
    /// `data` di notifikasi atau `selected_couriers` di sesi checkout.
    ReviewReplyModel? reply,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  bool get hasComment => (comment ?? '').trim().isNotEmpty;

  /// Nama yang bisa ditampilkan.
  ///
  /// Selalu generik: server tidak mengirim nama pengulas sama sekali.
  /// Ditulis di sini supaya layar tidak tergoda menampilkan `user_id` mentah.
  String get displayName => 'Pembeli';

  /// Ada balasan penjual yang benar-benar berisi teks.
  ///
  /// Dipisah dari `reply != null` karena `reply_text` bisa saja kosong —
  /// tidak ada validasi panjang di endpoint balasannya.
  bool get hasReply => reply?.hasText ?? false;
}

/// Balasan penjual atas satu ulasan, dari field `reply` di
/// `GET /products/{id}/reviews`.
///
/// ⚠️ **Tanpa nama penjual.** Yang dikirim hanya `reply_text` dan
/// `created_at`; nama tokonya harus diambil dari konteks halaman produk
/// (`ProductModel.storeId`), bukan dari ulasannya.
@freezed
abstract class ReviewReplyModel with _$ReviewReplyModel {
  const ReviewReplyModel._();

  const factory ReviewReplyModel({
    @StringOrNullJson() @JsonKey(name: 'reply_text') String? replyText,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ReviewReplyModel;

  factory ReviewReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewReplyModelFromJson(json);

  bool get hasText => (replyText ?? '').trim().isNotEmpty;
}

/// Sebaran bintang dari `meta.rating_histogram` pada
/// `GET /products/{id}/reviews`.
///
/// ⚠️ **Jangan tertukar dengan `meta.facets.rating` di `GET /products`.** Yang
/// ini menghitung **ulasan per bintang persis** untuk satu produk; yang itu
/// menghitung **produk per ambang rating** dan bersifat kumulatif.
class RatingHistogram {
  const RatingHistogram({this.total = 0, this.breakdown = const []});

  final int total;

  /// Satu entri per bintang 5..1, selalu lengkap walau hitungannya nol.
  final List<RatingBucket> breakdown;

  static const empty = RatingHistogram();

  bool get isEmpty => total == 0;

  /// Rata-rata bintang dihitung dari sebarannya.
  ///
  /// Dipakai sebagai cadangan kalau `product.rating_avg` belum ter-update —
  /// nilainya dihitung backend secara terpisah dan bisa tertinggal.
  double get average {
    if (total == 0) return 0;
    final sum = breakdown.fold<int>(0, (acc, b) => acc + b.rating * b.count);
    return sum / total;
  }

  factory RatingHistogram.fromMeta(Map<String, dynamic> meta) {
    final raw = meta['rating_histogram'];
    if (raw is! Map) return empty;

    final breakdownRaw = raw['breakdown'];
    return RatingHistogram(
      total: asInt(raw['total']),
      breakdown: breakdownRaw is List
          ? breakdownRaw
              .whereType<Map>()
              .map((e) => RatingBucket.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

/// Jumlah ulasan untuk satu nilai bintang.
class RatingBucket {
  const RatingBucket({
    required this.rating,
    required this.count,
    required this.percentage,
  });

  final int rating;
  final int count;

  /// Persentase dari total, sudah dihitung server.
  final double percentage;

  factory RatingBucket.fromJson(Map<String, dynamic> json) => RatingBucket(
        rating: asInt(json['rating']),
        count: asInt(json['count']),
        percentage: asDouble(json['percentage']),
      );

  /// 0..1, untuk bar sebaran.
  double get ratio => (percentage / 100).clamp(0, 1).toDouble();
}

/// Isian formulir ulasan untuk `POST /order-items/{id}/review`.
///
/// ⚠️ **Hanya bisa dikirim untuk order berstatus `completed`.** Server
/// mencari order item dengan `orders.status = 'completed'`; status lain
/// dibalas `404 ORDER_ITEM_NOT_FOUND` — bukan `403`, jadi pesannya harus
/// diterjemahkan supaya user tidak mengira pesanannya hilang.
///
/// Satu order item hanya boleh diulas sekali (`UNIQUE KEY` di tabel).
class ReviewDraft {
  const ReviewDraft({
    required this.rating,
    this.comment,
    this.isAnonymous = false,
    this.media = const [],
  });

  final int rating;
  final String? comment;
  final bool isAnonymous;

  /// `{type: 'photo'|'video', url}`. URL-nya berasal dari `POST /media/upload`.
  final List<ReviewMediaDraft> media;

  /// Rating di luar 1–5 ditolak di sini, bukan di server: model backend
  /// membaca `$data['rating']` tanpa validasi, jadi nilai aneh tersimpan apa
  /// adanya.
  bool get isValid => rating >= 1 && rating <= 5;

  Map<String, dynamic> toJson() => {
        'rating': rating,
        if ((comment ?? '').trim().isNotEmpty) 'comment': comment!.trim(),
        'is_anonymous': isAnonymous ? 1 : 0,
        if (media.isNotEmpty)
          'media': [for (final m in media) m.toJson()],
      };
}

/// Satu lampiran ulasan.
class ReviewMediaDraft {
  const ReviewMediaDraft({required this.type, required this.url});

  /// `photo` atau `video` — sesuai `ENUM` kolom `review_media.media_type`.
  final String type;
  final String url;

  Map<String, dynamic> toJson() => {'type': type, 'url': url};
}
