import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
// `ShippingOptionModel` sengaja dipakai ulang dari checkout, bukan disalin:
// bentuk opsi kurirnya benar-benar sama, dan dua salinan akan berbeda diam-diam
// begitu salah satunya diperbarui.
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';

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
  rating('rating'),

  /// Peringkat server menurut `natural_performance_score` (backend v1.x).
  /// Ini yang dipakai beranda dan pencarian: blueprint melarang kontrol
  /// urutan di sisi pembeli (design_buyer.md §5 no. 1) — relevansi dan
  /// kelayakan kirim ditentukan server.
  recommended('recommended');

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
  /// ⚠️ Hasilnya **tidak membawa stok, varian, maupun kurir**; semua itu
  /// hanya ada di [fetchProduct]. Jangan menembak detail per kartu untuk
  /// menambalnya — itu N+1 request untuk satu layar.
  ///
  /// 🔴 **Sejak backend v1.x listing menyembunyikan produk**: `discontinued`
  /// dan `ready_stock` yang stoknya nol tidak pernah muncul, di semua
  /// `sort_by` termasuk pencarian. Detail tetap mengembalikannya — jadi
  /// produk dari tautan langsung atau wishlist bisa dibuka walau tidak bisa
  /// ditemukan lewat pencarian.
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
    String? destCity,
    String? destProvince,
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
          // Tujuan kirim pembeli — BUKAN lokasi gudang seperti `city`.
          // Produk yang jangkauan kirimnya tidak mencakup tujuan ini dibuang
          // server, jadi yang tampil memang bisa dibeli ke alamat itu.
          if (destCity != null && destCity.isNotEmpty) 'dest_city': destCity,
          if (destProvince != null && destProvince.isNotEmpty)
            'dest_province': destProvince,
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

  /// `GET /products/{id}/shipping-estimate` — ongkir ke satu alamat, **tanpa
  /// membuat sesi checkout**.
  ///
  /// Nilainya justru di kata "tanpa": satu-satunya cara lain mengetahui ongkir
  /// adalah `POST /checkout/sessions`, yang **mereservasi stok 15 menit**.
  /// Memakainya hanya untuk mengintip ongkir di halaman produk berarti menahan
  /// stok orang lain setiap kali seseorang penasaran.
  ///
  /// Balasannya memakai ulang [ShippingOptionModel] yang sama dengan checkout,
  /// sudah disaring menurut kurir yang dilayani toko (`store_couriers`) dan
  /// **urut termurah** — jadi opsi pertama bisa langsung dipakai sebagai
  /// "ongkir mulai dari".
  ///
  /// **Butuh login**, berbeda dari `GET /products/{id}` yang publik, karena
  /// `address_id` milik pembeli. [variantId] opsional — server memakai varian
  /// pertama kalau tidak dikirim.
  ///
  /// Kode error yang dibedakan server dengan rapi (semuanya diuji):
  /// `422 VALIDATION_ERROR` tanpa `address_id`, `404 ADDRESS_NOT_FOUND` untuk
  /// alamat milik orang lain, `404 VARIANT_NOT_FOUND`, `401 UNAUTHENTICATED`
  /// tanpa token, dan `409 STOCK_INSUFFICIENT` bila varian tidak ada stok di
  /// gudang mana pun.
  Future<ApiEnvelope<List<ShippingOptionModel>>> fetchShippingEstimate(
    int productId, {
    required int addressId,
    int? variantId,
  }) async {
    final context = 'GET /products/$productId/shipping-estimate';
    try {
      final response = await _dio.get<dynamic>(
        '/products/$productId/shipping-estimate',
        queryParameters: {
          'address_id': addressId,
          if (variantId != null) 'variant_id': variantId,
        },
      );
      return parseEnvelopeList(response, ShippingOptionModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
