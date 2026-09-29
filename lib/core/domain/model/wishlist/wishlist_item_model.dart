import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'wishlist_item_model.freezed.dart';
part 'wishlist_item_model.g.dart';

/// Satu produk di wishlist, dari `GET /wishlist`.
///
/// Bentuknya **bukan** `ProductModel`: server mengirim gabungan ringkas
/// (`wishlist_item_id` + beberapa kolom produk) yang tidak sama dengan
/// listing katalog. Yang menarik, wishlist justru **membawa `image_url`**,
/// sedangkan `GET /products` tidak membawa gambar sama sekali.
///
/// ⚠️ **Dua id di satu baris, dan yang dipakai menghapus adalah
/// [productId].** `DELETE /wishlist/items/{id}` menerima **id produk**, bukan
/// [wishlistItemId] — sudah diuji dengan keduanya sengaja dibuat berbeda.
/// Mengirim [wishlistItemId] akan menghapus produk lain, atau tidak menghapus
/// apa pun sambil tetap membalas `200`.
@freezed
abstract class WishlistItemModel with _$WishlistItemModel {
  const WishlistItemModel._();

  const factory WishlistItemModel({
    @IntJson()
    @JsonKey(name: 'wishlist_item_id')
    @Default(0)
    int wishlistItemId,

    /// Id produk — **ini** yang dipakai untuk menghapus dan membuka detail.
    @IntJson() @JsonKey(name: 'product_id') required int productId,
    @StringJson() @Default('') String name,
    @StringJson() @Default('') String slug,

    /// Harga terendah di antara varian produk.
    @DoubleJson() @JsonKey(name: 'min_price') @Default(0) double minPrice,
    @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,

    /// Status produknya, bukan status baris wishlist. Produk yang sudah tidak
    /// `active` tetap tampil di wishlist — layar yang menandainya.
    @StringJson()
    @JsonKey(name: 'product_status')
    @Default('active')
    String productStatus,
    @ServerDateTimeJson() @JsonKey(name: 'added_at') DateTime? addedAt,

    /// 🔶 Pantau harga & stok (docs/22 #13) — **kontrak usulan**, belum
    /// dikirim server. Di debug disisipkan mock ke `GET /wishlist`.
    ///
    /// Sengaja nullable: `null` berarti **server tidak mendukung fitur ini**
    /// (key-nya tidak ada sama sekali), sehingga lonceng disembunyikan alih-alih
    /// tampil sebagai sakelar yang tidak menyimpan apa-apa. Begitu backend
    /// mengirim `alert_enabled`, loncengnya muncul sendiri.
    @_BoolOrNullJson() @JsonKey(name: 'alert_enabled') bool? alertEnabled,
  }) = _WishlistItemModel;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);

  /// Produk masih bisa dibeli. Produk yang diarsipkan penjual tetap ada di
  /// wishlist, jadi tombol belinya harus dimatikan, bukan barisnya disembunyikan
  /// — user perlu tahu kenapa barang yang ia simpan hilang dari katalog.
  bool get isAvailable => productStatus == 'active';

  /// Server (atau mock) mendukung pantau harga untuk baris ini.
  bool get supportsAlert => alertEnabled != null;

  bool get isWatched => alertEnabled == true;
}

class _BoolOrNullJson extends JsonConverter<bool?, Object?> {
  const _BoolOrNullJson();
  @override
  bool? fromJson(Object? json) => asBoolOrNull(json);
  @override
  Object? toJson(bool? object) => object;
}
