part of 'product_detail_cubit.dart';

/// Status halaman detail produk.
///
/// [ProductDetailLoaded] membawa varian terpilih di samping produknya, karena
/// harga dan stok yang ditampilkan bergantung pada varian — bukan pada produk.
@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const ProductDetailState._();

  const factory ProductDetailState.loading() = ProductDetailLoading;

  const factory ProductDetailState.loaded({
    required ProductModel product,

    /// Varian yang sedang dipilih.
    ///
    /// Selalu terisi untuk produk yang punya varian — dan setiap produk punya
    /// minimal satu, bahkan yang tanpa pilihan warna/ukuran. `null` hanya
    /// terjadi kalau server mengirim produk tanpa varian sama sekali, yang
    /// seharusnya mustahil tapi tidak boleh membuat layar crash.
    ProductVariantModel? selectedVariant,
  }) = ProductDetailLoaded;

  const factory ProductDetailState.error(DataError error) = ProductDetailError;

  /// Harga yang ditampilkan besar di layar: harga varian terpilih kalau ada,
  /// jatuh kembali ke harga efektif produk.
  ///
  /// Flash sale berlaku di tingkat produk, jadi ia menang atas harga varian.
  double? get displayPrice => switch (this) {
        ProductDetailLoaded(:final product, :final selectedVariant) =>
          product.flashSale != null
              ? product.effectivePrice
              : (selectedVariant?.price ?? product.effectivePrice),
        _ => null,
      };

  /// Stok yang relevan untuk tombol beli: stok varian terpilih, bukan total
  /// produk — produk bisa punya stok sementara varian yang dipilih habis.
  int? get displayStock => switch (this) {
        ProductDetailLoaded(:final product, :final selectedVariant) =>
          selectedVariant?.stock ?? product.stock,
        _ => null,
      };

  bool get canAddToCart {
    final stock = displayStock;
    return stock != null && stock > 0;
  }
}
