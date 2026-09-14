import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'product_detail_cubit.freezed.dart';
part 'product_detail_state.dart';

/// Halaman detail produk.
///
/// Seluruh isinya datang dari **satu** `GET /products/{id}` — varian, gambar,
/// kurir, dan stok sekaligus. Tidak ada panggilan susulan, dan tidak boleh
/// ada: itu justru pola N+1 yang ingin dihindari.
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this.productId)
      : _repository = injector<CatalogRepository>(),
        super(const ProductDetailState.loading());

  static ProductDetailCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final int productId;
  final CatalogRepository _repository;

  /// Memuat produk.
  ///
  /// [forceRefresh] melewati cache service — dipakai pull-to-refresh dan
  /// setelah aksi yang mengubah stok, supaya angka "tersisa N" tidak basi.
  Future<void> load({bool forceRefresh = false}) async {
    emit(const ProductDetailState.loading());

    final result =
        await _repository.fetchProduct(productId, forceRefresh: forceRefresh);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(ProductDetailState.loaded(
          product: data,
          selectedVariant: _pickInitialVariant(data),
        ));
      case DataFailed(:final error):
        emit(ProductDetailState.error(error));
      case DataEmpty():
        // `data` kosong untuk detail berarti produk tidak ada — diperlakukan
        // sebagai not found, bukan layar kosong tanpa penjelasan.
        emit(const ProductDetailState.error(DataError(
          code: ApiErrorCode.notFound,
          message: 'Produk tidak ditemukan',
          kind: DataErrorKind.api,
        )));
      case DataLoading():
        break;
    }
  }

  /// Mengganti varian terpilih.
  void selectVariant(ProductVariantModel variant) {
    final current = state;
    if (current is! ProductDetailLoaded) return;
    emit(current.copyWith(selectedVariant: variant));
  }

  /// Varian awal: yang pertama masih punya stok, kalau ada.
  ///
  /// Memilih varian habis sebagai default membuat tombol beli mati begitu
  /// halaman dibuka, padahal varian lain masih tersedia — user harus menebak
  /// bahwa ia perlu mengganti pilihan lebih dulu.
  ProductVariantModel? _pickInitialVariant(ProductModel product) {
    if (product.variants.isEmpty) return null;
    return product.variants.firstWhere(
      (v) => v.isActive && !v.isOutOfStock,
      orElse: () => product.variants.first,
    );
  }
}
