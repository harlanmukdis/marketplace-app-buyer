import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';

/// Antarmuka katalog yang dikonsumsi cubit.
///
/// Seluruh method mengembalikan [DataState] dan **tidak pernah melempar** —
/// cubit mencocokkan state, bukan membungkus panggilan dengan try/catch.
///
/// `meta` ikut dibawa `DataSuccess`/`DataEmpty` dan **tidak boleh dibuang**:
/// di `GET /products` ia berisi `page`/`per_page`/`total` untuk paginasi
/// sekaligus `facets` untuk sidebar filter. Pakai `ProductFacets.fromMeta`
/// untuk membacanya.
abstract class CatalogRepository {
  /// Listing sekaligus pencarian produk.
  ///
  /// Isi [query] untuk mencari — ini juga pengganti `/search/products`, yang
  /// mati tanpa Elasticsearch. Hasilnya **tanpa gambar dan stok**; keduanya
  /// hanya ada di [fetchProduct].
  ///
  /// List kosong dikembalikan sebagai `DataEmpty` (bukan `DataSuccess` berisi
  /// list kosong) supaya layar bisa membedakan "tidak ada hasil" dari "gagal
  /// memuat" tanpa memeriksa panjang list.
  Future<DataState<List<ProductModel>>> fetchProducts({
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
    ProductSort sort,
    int page,
    int perPage,
  });

  /// Detail satu produk — cukup untuk seluruh halaman detail.
  ///
  /// [forceRefresh] melewati cache service; pakai setelah aksi yang mengubah
  /// stok.
  Future<DataState<ProductModel>> fetchProduct(int id,
      {bool forceRefresh = false});

  /// Pohon kategori lengkap.
  Future<DataState<List<CategoryModel>>> fetchCategories();

  /// Daftar kurir aktif se-platform.
  Future<DataState<List<CourierModel>>> fetchCouriers();

  /// Ongkir ke satu alamat, **tanpa membuat sesi checkout** — jadi tanpa
  /// mereservasi stok.
  ///
  /// Hasilnya urut termurah, jadi elemen pertama bisa langsung dipakai sebagai
  /// "ongkir mulai dari". Butuh login.
  Future<DataState<List<ShippingOptionModel>>> fetchShippingEstimate(
    int productId, {
    required int addressId,
    int? variantId,
  });
}
