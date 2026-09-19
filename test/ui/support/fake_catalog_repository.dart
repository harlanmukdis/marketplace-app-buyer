/// Repository katalog palsu yang hanya melayani estimasi ongkir.
///
/// Dipisahkan ke berkas sendiri karena `CatalogRepository` punya enam method
/// sementara test estimasi ongkir hanya peduli satu — menyalin lima stub ke
/// dalam berkas testnya akan menenggelamkan yang sedang diuji.
library;

import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';

/// Satu panggilan estimasi yang tercatat.
typedef EstimateCall = ({int productId, int addressId, int? variantId});

class FakeCatalogRepository implements CatalogRepository {
  DataState<List<ShippingOptionModel>> estimateResult = const DataEmpty();

  final List<EstimateCall> estimateCalls = [];

  @override
  Future<DataState<List<ShippingOptionModel>>> fetchShippingEstimate(
    int productId, {
    required int addressId,
    int? variantId,
  }) async {
    estimateCalls.add(
      (productId: productId, addressId: addressId, variantId: variantId),
    );
    return estimateResult;
  }

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
    ProductSort sort = ProductSort.latest,
    int page = 1,
    int perPage = 20,
  }) async =>
      const DataEmpty();

  @override
  Future<DataState<ProductModel>> fetchProduct(int id,
          {bool forceRefresh = false}) async =>
      const DataEmpty();

  @override
  Future<DataState<List<CategoryModel>>> fetchCategories() async =>
      const DataEmpty();

  @override
  Future<DataState<List<CourierModel>>> fetchCouriers() async =>
      const DataEmpty();
}
