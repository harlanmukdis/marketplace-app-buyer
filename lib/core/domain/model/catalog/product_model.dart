import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Produk dari `GET /products` (listing) maupun `GET /products/{id}` (detail).
///
/// **Satu model untuk dua bentuk, dan bedanya penting.** Listing hanya
/// mengembalikan kolom tabel `products` **plus [listingImageUrl]**;
/// [variants], [images], dan [couriers] datang kosong di sana, dan [stock]
/// datang `null`. Semuanya baru terisi di detail.
///
/// Karena itu [stock] sengaja **nullable**, bukan `0` sebagai default:
/// `null` berarti "belum diketahui" (item listing), sedangkan `0` berarti
/// "benar-benar habis". Kartu produk yang memakai `stock == 0` sebagai
/// penanda habis akan menandai seluruh listing sebagai habis. Pakai
/// [isOutOfStock] yang membedakan keduanya.
///
/// Halaman detail bisa dirender **sepenuhnya dari satu `GET /products/{id}`** —
/// tidak ada panggilan tambahan untuk stok, varian, gambar, atau kurir.
/// Jangan menembak detail per kartu di listing (N+1).
@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'store_id') @Default(0) int storeId,
    @StringJson() @Default('') String name,
    @StringJson() @Default('') String slug,
    @StringOrNullJson() String? description,

    /// `physical` / `digital` / `service`.
    @StringJson() @JsonKey(name: 'product_type') @Default('physical')
    String productType,

    @DoubleJson() @JsonKey(name: 'base_price') @Default(0) double basePrice,

    /// Harga coret, **independen dari flash sale**. `null` = tidak ada diskon.
    @DoubleOrNullJson() @JsonKey(name: 'compare_at_price')
    double? compareAtPrice,

    @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
    @StringJson() @Default('active') String status,
    @IntJson() @JsonKey(name: 'sold_count') @Default(0) int soldCount,
    @IntJson() @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @DoubleJson() @JsonKey(name: 'rating_avg') @Default(0) double ratingAvg,
    @IntJson() @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,

    /// Total `quantity_available` (on_hand − reserved) lintas gudang.
    ///
    /// Datang sebagai **integer asli**, bukan string — berbeda dari mayoritas
    /// field lain. Hanya ada di detail; `null` di listing.
    @IntOrNullJson() int? stock,

    /// Hanya ada kalau produk sedang ikut flash sale aktif.
    ///
    /// Di JSON key-nya **absen sama sekali**, bukan `null`. Untuk Dart keduanya
    /// sama-sama jadi `null`, jadi cukup periksa null — tapi jangan menulis
    /// kode yang mengandalkan key-nya selalu ada.
    @JsonKey(name: 'flash_sale') FlashSaleModel? flashSale,

    /// Gambar utama **versi listing**, satu URL datar.
    ///
    /// Ditambahkan backend pada commit `db8a626` ("Add image_url to GET
    /// /products listing (was always missing)"). Sebelumnya `GET /products`
    /// tidak membawa gambar sama sekali, sehingga setiap kartu produk terpaksa
    /// memakai placeholder — satu-satunya alternatifnya menembak detail per
    /// kartu (N+1).
    ///
    /// ⚠️ Hanya ada di **listing**; `GET /products/{id}` tidak mengirimkannya
    /// dan memakai [images] sebagai gantinya. Pakai [primaryImageUrl] yang
    /// menyerap keduanya, jangan field ini langsung.
    @StringOrNullJson() @JsonKey(name: 'image_url') String? listingImageUrl,

    @Default(<ProductVariantModel>[]) List<ProductVariantModel> variants,
    @Default(<ProductImageModel>[]) List<ProductImageModel> images,
    @Default(<CourierModel>[]) List<CourierModel> couriers,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Gambar utama, dari bentuk mana pun respons datangnya.
  ///
  /// Detail mengirim [images] bersusun; listing mengirim satu
  /// [listingImageUrl] datar. `null` hanya kalau produknya memang belum punya
  /// gambar.
  String? get primaryImageUrl {
    if (images.isNotEmpty) {
      final sorted = [...images]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return sorted.first.imageUrl;
    }
    final flat = listingImageUrl?.trim();
    return (flat == null || flat.isEmpty) ? null : flat;
  }

  /// Harga yang benar-benar dibayar: flash sale menang atas harga dasar.
  double get effectivePrice => flashSale?.flashPrice ?? basePrice;

  /// Harga yang dicoret di UI, `null` kalau tidak ada yang perlu dicoret.
  ///
  /// Saat flash sale aktif, yang dicoret adalah harga dasar. Di luar itu,
  /// `compare_at_price` — dan hanya kalau nilainya memang lebih tinggi, supaya
  /// data yang salah tidak menampilkan "diskon" negatif.
  double? get strikethroughPrice {
    if (flashSale != null) return basePrice;
    final compare = compareAtPrice;
    if (compare != null && compare > basePrice) return compare;
    return null;
  }

  bool get isDiscounted => strikethroughPrice != null;

  /// Persen diskon dibulatkan, `null` kalau tidak sedang diskon.
  int? get discountPercent {
    final before = strikethroughPrice;
    if (before == null || before <= 0) return null;
    return (((before - effectivePrice) / before) * 100).round();
  }

  /// Stok diketahui **dan** nol. `false` untuk item listing, yang stoknya
  /// memang tidak dikirim server.
  bool get isOutOfStock => stock != null && stock! <= 0;

  /// Stok diketahui dan menipis — untuk label "tersisa N".
  bool get isLowStock {
    final value = stock;
    return value != null && value > 0 && value <= 5;
  }

  bool get hasRating => ratingCount > 0;
}

/// Varian produk. **Selalu ada minimal satu**, bahkan untuk produk tanpa
/// pilihan warna/ukuran.
///
/// `cart_items` dan `order_items` merujuk `product_variant_id`, **tidak pernah**
/// `product_id` — jadi menambahkan ke keranjang selalu butuh varian, bukan
/// produk.
@freezed
abstract class ProductVariantModel with _$ProductVariantModel {
  const ProductVariantModel._();

  const factory ProductVariantModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'product_id') @Default(0) int productId,
    @StringOrNullJson() String? sku,

    /// Opsi varian, mis. `{"warna": "Hitam"}`.
    ///
    /// Server mengirimnya sebagai **string berisi JSON** (`'{"warna":"Hitam"}'`),
    /// bukan objek — karena itu [JsonMapJson], bukan Map biasa.
    @JsonMapJson() @JsonKey(name: 'variant_options')
    Map<String, dynamic>? variantOptions,

    @DoubleJson() @Default(0) double price,
    @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
    @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
    @BoolJson() @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// Stok varian ini lintas gudang — **integer asli**, seperti
    /// `ProductModel.stock`.
    @IntOrNullJson() int? stock,

    /// Lokasi gudang yang akan mengirim varian ini — ditambahkan backend pada
    /// 15 September 2026 bersama endpoint `shipping-estimate`.
    ///
    /// Dipakai menampilkan "Dikirim dari …" di halaman detail tanpa memanggil
    /// endpoint apa pun. `null` untuk varian yang tidak punya stok di gudang
    /// mana pun.
    ///
    /// ⚠️ Belum terdokumentasi di `docs/18-frontend-integration-guide.md` §8
    /// walau servernya sudah mengirimkannya.
    @StringOrNullJson() @JsonKey(name: 'warehouse_city') String? warehouseCity,
    @StringOrNullJson() @JsonKey(name: 'warehouse_province')
    String? warehouseProvince,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);

  bool get isOutOfStock => stock != null && stock! <= 0;

  /// "Banda Aceh, Aceh" — kosong kalau server tidak mengirim lokasinya.
  String get shippingOrigin {
    final parts = [warehouseCity, warehouseProvince]
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty);
    return parts.join(', ');
  }

  /// Label opsi yang layak ditampilkan, mis. "Hitam" atau "Hitam · L".
  ///
  /// Kosong untuk produk tanpa varian sungguhan — pemanggil yang memutuskan
  /// apakah menampilkan pemilih varian sama sekali.
  String get optionLabel {
    final options = variantOptions;
    if (options == null || options.isEmpty) return '';
    return options.values.map((v) => v?.toString() ?? '').where((v) => v.isNotEmpty).join(' · ');
  }
}

/// Gambar produk. Hanya ada di `GET /products/{id}`.
@freezed
abstract class ProductImageModel with _$ProductImageModel {
  const factory ProductImageModel({
    @IntJson() required int id,
    @StringJson() @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @IntJson() @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _ProductImageModel;

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);
}

/// Kurir yang dilayani toko pemilik produk, dari `GET /products/{id}` atau
/// `GET /couriers`.
@freezed
abstract class CourierModel with _$CourierModel {
  const factory CourierModel({
    @StringJson() @Default('') String code,
    @StringJson() @Default('') String name,
    @BoolJson() @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _CourierModel;

  factory CourierModel.fromJson(Map<String, dynamic> json) =>
      _$CourierModelFromJson(json);
}

/// Flash sale yang sedang berjalan untuk sebuah produk.
///
/// Nilainya dikirim sebagai angka asli, berbeda dari harga produk yang berupa
/// string — jadi jangan menyalin anotasi dari [ProductModel] begitu saja.
@freezed
abstract class FlashSaleModel with _$FlashSaleModel {
  const FlashSaleModel._();

  const factory FlashSaleModel({
    @DoubleJson() @JsonKey(name: 'flash_price') @Default(0) double flashPrice,
    @IntJson() @JsonKey(name: 'sold_count') @Default(0) int soldCount,
    @IntJson() @JsonKey(name: 'stock_quota') @Default(0) int stockQuota,
    @ServerDateTimeJson() @JsonKey(name: 'ends_at') DateTime? endsAt,
  }) = _FlashSaleModel;

  factory FlashSaleModel.fromJson(Map<String, dynamic> json) =>
      _$FlashSaleModelFromJson(json);

  /// Progres terjual 0..1, untuk bar "terjual N dari kuota".
  double get soldRatio {
    if (stockQuota <= 0) return 0;
    return (soldCount / stockQuota).clamp(0, 1).toDouble();
  }

  int get remainingQuota {
    final left = stockQuota - soldCount;
    return left < 0 ? 0 : left;
  }

  bool get isSoldOut => remainingQuota == 0 && stockQuota > 0;
}
