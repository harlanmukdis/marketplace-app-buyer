/// Pembantu bersama untuk test integrasi yang **mengonsumsi stok**.
///
/// Test checkout dan order benar-benar membuat pesanan, jadi setiap kali suite
/// dijalankan stok produk berkurang. Versi awal test ini selalu memakai
/// `products[0]`, sehingga suite perlahan menghabiskan stok produk itu lalu
/// gagal sendiri dengan `409 STOCK_INSUFFICIENT` — persis yang terjadi setelah
/// beberapa hari dipakai.
///
/// [findVariantWithStock] mencari produk pertama yang variannya masih punya
/// stok cukup, jadi suite tetap hijau selama **ada** produk berstok, bukan
/// selama produk tertentu berstok.
library;

import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';

/// Produk + varian yang siap dibeli dalam test.
typedef SeededVariant = ({int productId, int variantId, int stock});

/// Mencari varian yang stoknya minimal [minimumStock].
///
/// Melempar [StateError] kalau seluruh katalog habis — itu berarti databasenya
/// perlu di-seed ulang, dan pesan itu jauh lebih berguna daripada
/// `STOCK_INSUFFICIENT` yang muncul jauh kemudian di tengah alur checkout.
Future<SeededVariant> findVariantWithStock(
  CatalogService catalog, {
  int minimumStock = 1,
}) async {
  final listing = await catalog.fetchProducts(perPage: 100);

  for (final product in listing.data) {
    final detail = await catalog.fetchProduct(product.id);
    for (final variant in detail.data.variants) {
      final stock = variant.stock ?? 0;
      if (variant.isActive && stock >= minimumStock) {
        return (
          productId: product.id,
          variantId: variant.id,
          stock: stock,
        );
      }
    }
  }

  throw StateError(
    'Tidak ada varian berstok >= $minimumStock di seluruh katalog. '
    'Test integrasi ikut menghabiskan stok setiap kali dijalankan — '
    'seed ulang database sebelum melanjutkan.',
  );
}
