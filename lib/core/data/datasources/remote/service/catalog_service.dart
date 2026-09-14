import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';

/// Urutan hasil `GET /products`.
///
/// Nilai di luar daftar ini diabaikan server dan diperlakukan sebagai
/// [latest], jadi enum ini sekaligus mencegah salah ketik yang gagal diam-diam.
enum ProductSort {
  latest('latest'),
  popular('popular'),
  trending('trending'),
  priceAsc('price_asc'),
  priceDesc('price_desc'),
  rating('rating');

  const ProductSort(this.code);
  final String code;
}

/// Panggilan HTTP untuk katalog publik: `/products`, `/categories`,
/// `/couriers`.
///
/// Seluruh endpoint di sini **publik** — tidak butuh token. Tetap dilewatkan
/// `Dio` bernama `"api"` yang sama supaya base URL, timeout, dan logging
/// seragam; `AuthInterceptor` menempelkan token kalau ada, dan server
/// mengabaikannya.
///
/// `/search/*` sengaja **tidak ada di sini**. Endpoint itu butuh
/// Elasticsearch di port 9200 dan membalas `503 SEARCH_UNAVAILABLE` selama ES
/// mati — yang merupakan keadaan normal di lingkungan dev. Pencarian dilayani
/// [fetchProducts] dengan parameter `q`, yang berbasis MySQL dan sekaligus
/// mengembalikan `meta.facets`.
class CatalogService {
  CatalogService(this._dio);

  final Dio _dio;

  /// Cache detail produk per id.
  ///
  /// Detail adalah panggilan termahal di katalog (varian + gambar + kurir +
  /// stok dalam satu respons) dan paling sering diulang: user membuka produk,
  /// kembali ke listing, lalu membukanya lagi. Cache ini dibersihkan lewat
  /// [invalidateProduct] setelah aksi yang mengubah stok.
  final Map<int, ProductModel> _productCache = {};

  /// `GET /products` — listing sekaligus pencarian.
  ///
  /// ⚠️ Hasilnya **tidak membawa gambar, stok, varian, maupun kurir**; semua
  /// itu hanya ada di [fetchProduct]. Jangan menembak detail per kartu untuk
  /// menambalnya — itu N+1 request untuk satu layar.
  ///
  /// `meta` yang dikembalikan membawa `page`/`per_page`/`total` **dan**
  /// `facets` untuk sidebar filter, jadi jangan dibuang di repository.
  Future<ApiEnvelope<List<ProductModel>>> fetchProducts({
    String? query,
    int? categoryId,
    int? storeId,
    double? minPrice,
    double? maxPrice,
    int? minRating,
    String? city,
    String? province,
    String? courier,
    ProductSort sort = ProductSort.latest,
    int page = 1,
    int perPage = 20,
  }) async {
    const context = 'GET /products';
    try {
      final response = await _dio.get<dynamic>(
        '/products',
        queryParameters: <String, dynamic>{
          if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
          if (categoryId != null) 'category_id': categoryId,
          if (storeId != null) 'store_id': storeId,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
          if (minRating != null) 'min_rating': minRating,
          if (city != null && city.isNotEmpty) 'city': city,
          if (province != null && province.isNotEmpty) 'province': province,
          if (courier != null && courier.isNotEmpty) 'courier': courier,
          'sort_by': sort.code,
          'page': page,
          // Server memotong di 100; dipatok di sini juga supaya permintaan yang
          // terlalu besar tidak diam-diam menghasilkan halaman lebih kecil dari
          // yang diminta pemanggil.
          'per_page': perPage.clamp(1, 100),
        },
      );
      return parseEnvelopeList(response, ProductModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /products/{id}` — cukup untuk merender seluruh halaman detail.
  ///
  /// Membawa `variants`, `images`, `couriers`, `stock` (integer), dan
  /// `compare_at_price`; `flash_sale` hanya muncul saat produk sedang promo.
  Future<ApiEnvelope<ProductModel>> fetchProduct(
    int id, {
    bool forceRefresh = false,
  }) async {
    final cached = _productCache[id];
    if (!forceRefresh && cached != null) {
      return ApiEnvelope<ProductModel>(data: cached, statusCode: 200);
    }

    final context = 'GET /products/$id';
    try {
      final response = await _dio.get<dynamic>('/products/$id');
      final envelope = parseEnvelope(
        response,
        (raw) => ProductModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
      _productCache[id] = envelope.data;
      return envelope;
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// Membuang satu produk dari cache — panggil setelah aksi yang mengubah
  /// stok (tambah ke keranjang, checkout) supaya angka "tersisa N" tidak basi.
  void invalidateProduct(int id) => _productCache.remove(id);

  void clearCache() => _productCache.clear();

  /// `GET /categories` — pohon lengkap dalam satu panggilan.
  ///
  /// Respons sudah bersarang (`children`), jadi tidak perlu merakit dari
  /// `parent_id`. Tidak ada endpoint untuk satu kategori.
  Future<ApiEnvelope<List<CategoryModel>>> fetchCategories() async {
    const context = 'GET /categories';
    try {
      final response = await _dio.get<dynamic>('/categories');
      return parseEnvelopeList(response, CategoryModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /couriers` — daftar kurir aktif se-platform.
  ///
  /// Berbeda dari `couriers` di detail produk, yang hanya berisi kurir yang
  /// dilayani toko pemilik produk tersebut.
  Future<ApiEnvelope<List<CourierModel>>> fetchCouriers() async {
    const context = 'GET /couriers';
    try {
      final response = await _dio.get<dynamic>('/couriers');
      return parseEnvelopeList(response, CourierModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
