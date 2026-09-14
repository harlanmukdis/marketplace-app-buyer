import 'package:marketplace_app_member/util/json_converters.dart';

/// Isi `meta.facets` dari `GET /products`, untuk sidebar filter.
///
/// **Dua facet-nya berbeda bentuk, dan itu bukan kelalaian yang bisa
/// dinormalkan sepihak** — keduanya memang dikirim berbeda oleh server:
///
/// | | `facets.rating` | `facets.category` |
/// |---|---|---|
/// | kapan muncul | selalu | **hanya kalau ada parameter `q`** |
/// | bentuk | `{min_rating, count}` | `{category_id, cnt}` |
/// | tipe angkanya | `count` **integer** | `cnt` **string** |
/// | sifat | kumulatif (`>= n`) | hitungan per kategori |
///
/// Karena itu kelas ini tidak dibuat `freezed`: bentuknya tidak seragam, dan
/// memaksakan satu `fromJson` generik justru menyembunyikan perbedaan yang
/// harus terlihat. Parsing-nya manual dan toleran — facet yang hilang jadi
/// list kosong, bukan lemparan, karena filter adalah pelengkap halaman dan
/// tidak boleh menggagalkan listing-nya.
///
/// Jangan tertukar dengan `meta.rating_histogram` di
/// `GET /products/{id}/reviews`: yang itu menghitung **ulasan per bintang
/// persis** untuk satu produk, sedangkan ini menghitung **produk per ambang
/// rating**.
class ProductFacets {
  const ProductFacets({
    this.ratings = const [],
    this.categories = const [],
  });

  final List<RatingFacet> ratings;
  final List<CategoryFacet> categories;

  static const empty = ProductFacets();

  bool get isEmpty => ratings.isEmpty && categories.isEmpty;

  /// Membaca `meta.facets` dari blok `meta` sebuah `ApiEnvelope`.
  factory ProductFacets.fromMeta(Map<String, dynamic> meta) {
    final raw = meta['facets'];
    if (raw is! Map) return empty;

    final ratingRaw = raw['rating'];
    final categoryRaw = raw['category'];

    return ProductFacets(
      ratings: ratingRaw is List
          ? ratingRaw
              .whereType<Map>()
              .map((e) => RatingFacet.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      categories: categoryRaw is List
          ? categoryRaw
              .whereType<Map>()
              .map((e) => CategoryFacet.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

/// Jumlah produk dengan rating **minimal** [minRating].
///
/// Kumulatif: produk berating 4.5 ikut terhitung di ambang 4, 3, 2, dan 1.
/// Dihitung dengan filter aktif lainnya, tapi mengabaikan `min_rating` itu
/// sendiri — jadi angkanya tidak berubah saat user mengklik ambang lain.
class RatingFacet {
  const RatingFacet({required this.minRating, required this.count});

  final int minRating;

  /// Dikirim sebagai **integer**, berbeda dari [CategoryFacet.count].
  final int count;

  factory RatingFacet.fromJson(Map<String, dynamic> json) => RatingFacet(
        minRating: asInt(json['min_rating']),
        count: asInt(json['count']),
      );

  bool get hasProducts => count > 0;
}

/// Jumlah produk per kategori untuk hasil pencarian.
///
/// Hanya dikirim kalau permintaan membawa `q`. Jangan berasumsi ada.
class CategoryFacet {
  const CategoryFacet({required this.categoryId, required this.count});

  final int categoryId;

  /// Dikirim dengan key `cnt` dan bertipe **string** — berbeda dari
  /// [RatingFacet.count] yang integer.
  final int count;

  factory CategoryFacet.fromJson(Map<String, dynamic> json) => CategoryFacet(
        categoryId: asInt(json['category_id']),
        // `cnt`, bukan `count` — dan string, bukan integer. `asInt` menyerap
        // keduanya sehingga perbedaannya tidak bocor ke pemanggil.
        count: asInt(json['cnt']),
      );
}
