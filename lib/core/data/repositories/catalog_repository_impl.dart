import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';

/// Implementasi [CatalogRepository] di atas [CatalogService].
///
/// Tipis dengan sengaja: seluruh pembungkusan `DataState` diserahkan ke
/// [RepositoryGuard], dan tidak ada logika bisnis di sini. Aturan tampilan
/// (harga mana yang dicoret, kapan produk disebut habis) tinggal di model,
/// bukan di lapisan ini — supaya satu jawaban berlaku sama di listing, detail,
/// dan keranjang.
class CatalogRepositoryImpl with RepositoryGuard implements CatalogRepository {
  CatalogRepositoryImpl(this._service);

  final CatalogService _service;

  @override
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
    ProductSort sort = ProductSort.latest,
    int page = 1,
    int perPage = 20,
  }) {
    return guardList(() => _service.fetchProducts(
          query: query,
          categoryId: categoryId,
          storeId: storeId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
          city: city,
          province: province,
          courier: courier,
          destCity: destCity,
          destProvince: destProvince,
          sort: sort,
          page: page,
          perPage: perPage,
        ));
  }

  @override
  Future<DataState<ProductModel>> fetchProduct(int id,
          {bool forceRefresh = false}) =>
      guard(() => _service.fetchProduct(id, forceRefresh: forceRefresh));

  @override
  Future<DataState<List<CategoryModel>>> fetchCategories() =>
      guardList(_service.fetchCategories);

  @override
  Future<DataState<List<CourierModel>>> fetchCouriers() =>
      guardList(_service.fetchCouriers);

  /// Memakai `guardList`, jadi **nol opsi kurir jadi [DataEmpty]**, bukan
  /// sukses berisi list kosong.
  ///
  /// Bedanya nyata di sini: sejak backend menyaring kurir menurut
  /// `store_couriers`, toko yang tidak melayani satu pun kurir ke alamat itu
  /// benar-benar mengembalikan daftar kosong — dan layar perlu mengatakan
  /// "tidak ada kurir ke alamat ini", bukan diam.
  @override
  Future<DataState<List<ShippingOptionModel>>> fetchShippingEstimate(
    int productId, {
    required int addressId,
    int? variantId,
  }) {
    return guardList(() => _service.fetchShippingEstimate(
          productId,
          addressId: addressId,
          variantId: variantId,
        ));
  }
}
