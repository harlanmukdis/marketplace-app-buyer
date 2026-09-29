import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'store_products_cubit.freezed.dart';
part 'store_products_state.dart';

/// Produk satu toko: `GET /products?store_id=`, berhalaman.
///
/// Dipakai tab Produk di storefront dan baris "Produk Lain dari Toko Ini" di
/// halaman produk. Tidak memakai `CatalogHomeCubit` karena cubit itu juga
/// memuat kategori di setiap `load()` — permintaan yang tidak dibutuhkan
/// di sini.
///
/// Urutannya `recommended` (bawaan server): blueprint melarang kontrol urutan
/// di sisi pembeli.
class StoreProductsCubit extends Cubit<StoreProductsState> {
  StoreProductsCubit(this.storeId, {this.pageSize = 20})
      : _repository = injector<CatalogRepository>(),
        super(const StoreProductsState.loading());

  static StoreProductsCubit get(BuildContext context) => BlocProvider.of(context);

  final int storeId;
  final int pageSize;
  final CatalogRepository _repository;

  Future<void> load() async {
    emit(const StoreProductsState.loading());
    final result = await _fetch(1);
    if (isClosed) return;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        emit(StoreProductsState.loaded(
          products: data,
          total: _total(meta),
          hasMore: _hasMore(meta, data.length),
        ));
      case DataEmpty():
        emit(const StoreProductsState.empty());
      case DataFailed(:final error):
        emit(StoreProductsState.error(error));
      case DataLoading():
        break;
    }
  }

  /// Aman dipanggil berulang dari listener gulir.
  Future<void> loadMore() async {
    final current = state;
    if (current is! StoreProductsLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));
    final next = current.page + 1;
    final result = await _fetch(next);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data, :final meta):
        final merged = [...current.products, ...data];
        emit(current.copyWith(
          products: merged,
          page: next,
          hasMore: _hasMore(meta, merged.length),
          isLoadingMore: false,
        ));
      case DataEmpty():
        emit(current.copyWith(hasMore: false, isLoadingMore: false));
      case DataFailed(:final error):
        emit(current.copyWith(isLoadingMore: false, loadMoreError: error));
      case DataLoading():
        break;
    }
  }

  Future<DataState<List<ProductModel>>> _fetch(int page) => _repository.fetchProducts(
        storeId: storeId,
        sort: ProductSort.recommended,
        page: page,
        perPage: pageSize,
      );

  static int? _total(Map<String, dynamic> meta) {
    final total = asInt(meta['total'], fallback: -1);
    return total < 0 ? null : total;
  }

  /// Tanpa `meta.total` dianggap habis — lebih baik kehilangan satu halaman
  /// daripada menembak tanpa akhir.
  static bool _hasMore(Map<String, dynamic> meta, int loaded) {
    final total = _total(meta);
    return total != null && loaded < total;
  }
}
