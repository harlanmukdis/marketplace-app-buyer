import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

/// Satu baris keranjang dari `GET /cart`.
///
/// Server sudah menyertakan data produk yang didenormalkan (`product_name`,
/// `sku`, `price`, `variant_options`, `store_name`), jadi layar keranjang
/// **tidak perlu menembak `/products/{id}` per baris**.
///
/// Yang **tidak** dikirim: gambar produk dan stok. Keduanya hanya ada di
/// `GET /products/{id}`. Karena itu keranjang tidak bisa memutuskan sendiri
/// apakah sebuah baris melebihi stok — lihat catatan di [quantity].
@freezed
abstract class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'cart_id') @Default(0) int cartId,
    @IntJson() @JsonKey(name: 'store_id') @Default(0) int storeId,

    /// Baris keranjang selalu merujuk **varian**, bukan produk.
    @IntJson()
    @JsonKey(name: 'product_variant_id')
    @Default(0)
    int productVariantId,
    @IntOrNullJson() @JsonKey(name: 'warehouse_id') int? warehouseId,

    /// ⚠️ **Server tidak memvalidasi nilai ini sama sekali.** Sudah diuji:
    /// `PATCH` dengan `quantity: 99999` pada varian berstok 150 dibalas `200`
    /// dan benar-benar tersimpan; `0` juga diterima. Pembatasan terhadap stok
    /// **harus dilakukan aplikasi** sebelum mengirim, kalau tidak user baru
    /// tahu keranjangnya mustahil saat checkout gagal.
    @IntJson() @Default(1) int quantity,

    /// Hanya baris ber-`is_selected` yang dihitung `GET /cart/summary` dan
    /// yang ikut ke checkout.
    @BoolJson() @JsonKey(name: 'is_selected') @Default(true) bool isSelected,
    @StringOrNullJson() String? sku,

    /// Harga satuan saat baris dibuat, string berdesimal (`"75000.00"`).
    @DoubleJson() @Default(0) double price,

    /// Dikirim sebagai string berisi JSON, sama seperti di varian produk.
    @JsonMapJson()
    @JsonKey(name: 'variant_options')
    Map<String, dynamic>? variantOptions,
    @StringJson()
    @JsonKey(name: 'product_name')
    @Default('')
    String productName,
    @StringJson() @JsonKey(name: 'store_name') @Default('') String storeName,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  /// Subtotal baris ini. Dihitung di sisi aplikasi karena server tidak
  /// mengirimkannya per baris.
  double get lineTotal => price * quantity;

  /// Label opsi varian, mis. "Hitam · L". Kosong untuk produk tanpa varian
  /// sungguhan.
  String get optionLabel {
    final options = variantOptions;
    if (options == null || options.isEmpty) return '';
    return options.values
        .map((v) => v?.toString() ?? '')
        .where((v) => v.isNotEmpty)
        .join(' · ');
  }
}

/// Keranjang yang dikelompokkan per toko, seperti dikirim `GET /cart`.
///
/// ⚠️ **Grupnya hanya membawa `store_name`, tanpa `store_id`.** Id tokonya ada
/// di setiap item, jadi [storeId] menurunkannya dari item pertama — dibutuhkan
/// checkout, yang memilih kurir per toko dengan id sebagai kunci.
@freezed
abstract class CartStoreGroup with _$CartStoreGroup {
  const CartStoreGroup._();

  const factory CartStoreGroup({
    @StringJson() @JsonKey(name: 'store_name') @Default('') String storeName,
    @Default(<CartItemModel>[]) List<CartItemModel> items,
  }) = _CartStoreGroup;

  factory CartStoreGroup.fromJson(Map<String, dynamic> json) =>
      _$CartStoreGroupFromJson(json);

  /// Id toko, diturunkan dari item karena grupnya tidak membawanya.
  /// `null` hanya kalau grup kosong, yang seharusnya tidak dikirim server.
  int? get storeId => items.isEmpty ? null : items.first.storeId;

  /// Subtotal baris **terpilih** di toko ini — sejalan dengan cara
  /// `GET /cart/summary` menghitung.
  double get selectedSubtotal =>
      items.where((i) => i.isSelected).fold(0, (sum, i) => sum + i.lineTotal);

  int get selectedCount => items.where((i) => i.isSelected).length;

  bool get allSelected => items.isNotEmpty && items.every((i) => i.isSelected);
  bool get noneSelected => items.every((i) => !i.isSelected);
}

/// Satu voucher yang **sedang terpasang** di keranjang, dari
/// `GET /cart/summary`.
///
/// ⚠️ **Bentuknya diturunkan dari sumber backend** (`Cart_model::
/// validate_voucher()`), bukan dari respons yang teramati: tidak ada voucher
/// yang di-seed, jadi `vouchers` selalu `[]` di dev. Sumbernya lebih kuat
/// daripada dokumen, tapi tetap bukan pengamatan — periksa ulang begitu ada
/// voucher sungguhan.
///
/// 🔴 **[discountAmount] TIDAK selalu berarti potongan harga.** Backend
/// sengaja mengisinya:
///
/// * `null` untuk voucher **ongkir** — nilainya baru ketahuan saat checkout,
///   karena ongkir belum dihitung di keranjang;
/// * `0` untuk voucher **cashback** — cashback tidak mengurangi yang dibayar
///   sama sekali, melainkan jadi coins setelah pesanan selesai.
///
/// Menampilkan voucher cashback sebagai potongan membuat total yang dilihat
/// pembeli tidak cocok dengan yang ditagih. Pakai [isCashback] dan
/// [isShipping] untuk memilih kalimatnya.
@freezed
abstract class AppliedVoucherModel with _$AppliedVoucherModel {
  const AppliedVoucherModel._();

  const factory AppliedVoucherModel({
    @StringJson() @Default('') String code,

    /// `shipping` / `platform` / `store` — slot penumpukan, diturunkan server
    /// dari `discount_type` dan `store_id`, bukan kolom tersendiri.
    @StringJson() @Default('') String category,

    /// `null` untuk voucher platform.
    @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,

    /// `percentage` / `fixed` / `free_shipping` / `cashback`.
    @StringJson()
    @JsonKey(name: 'discount_type')
    @Default('')
    String discountType,
    @DoubleJson()
    @JsonKey(name: 'discount_value')
    @Default(0)
    double discountValue,
    @DoubleOrNullJson() @JsonKey(name: 'max_discount') double? maxDiscount,

    /// Potongan rupiah yang benar-benar berlaku. `null` untuk ongkir, `0`
    /// untuk cashback — lihat catatan kelas.
    @DoubleOrNullJson()
    @JsonKey(name: 'discount_amount')
    double? discountAmount,

    /// Hanya di `GET /cart/recommended-vouchers`: id voucher dan **perkiraan**
    /// nilai rupiahnya (`estimate_voucher_value`). Untuk voucher ongkir
    /// nilainya `discount_value` — potensi, bukan potongan pasti — jadi
    /// jangan ditulis sebagai "hemat" di kartu rekomendasi ongkir.
    @IntOrNullJson() @JsonKey(name: 'voucher_id') int? voucherId,
    @DoubleOrNullJson() @JsonKey(name: 'value') double? estimatedValue,
  }) = _AppliedVoucherModel;

  factory AppliedVoucherModel.fromJson(Map<String, dynamic> json) =>
      _$AppliedVoucherModelFromJson(json);

  bool get isShipping => category == 'shipping';
  bool get isCashback => discountType == 'cashback';

  /// `true` kalau voucher ini benar-benar mengurangi yang dibayar sekarang.
  bool get reducesPayment => !isShipping && !isCashback;
}

/// Ringkasan dari `GET /cart/summary`.
///
/// Catatan yang membedakannya dari dugaan wajar:
///
/// * Nilainya datang sebagai **angka asli**, bukan string seperti mayoritas
///   field lain.
/// * Hanya menghitung baris **terpilih**. Membatalkan centang satu baris
///   langsung menurunkan [subtotal] dan [itemCount].
/// * [itemCount] menghitung **jumlah baris**, bukan jumlah unit — dua baris
///   berisi 5 dan 1 unit tetap menghasilkan `2`.
///
/// ✅ [vouchers] dan [discountAmount] **ditambahkan backend bersama
/// penumpukan voucher** (commit `90751bf`). Catatan lama di sini yang bilang
/// endpoint ini "hanya berisi `subtotal` dan `item_count`" sudah tidak
/// berlaku. Ongkir tetap tidak ada di sini — baru muncul di
/// `checkout/sessions/{id}/shipping-options`.
@freezed
abstract class CartSummaryModel with _$CartSummaryModel {
  const CartSummaryModel._();

  const factory CartSummaryModel({
    @DoubleJson() @Default(0) double subtotal,
    @IntJson() @JsonKey(name: 'item_count') @Default(0) int itemCount,

    /// Voucher yang sedang terpasang; `[]` selama belum ada yang dipasang.
    ///
    /// Server **membuang sendiri voucher yang sudah tidak valid** terhadap isi
    /// keranjang saat ini (`list_applied_vouchers` menghapusnya dari
    /// `cart_applied_vouchers`), jadi daftar ini selalu voucher yang benar-benar
    /// masih berlaku — tidak perlu divalidasi ulang di aplikasi.
    @Default(<AppliedVoucherModel>[]) List<AppliedVoucherModel> vouchers,

    /// Total potongan rupiah dari [vouchers].
    ///
    /// ⚠️ **Voucher ongkir dan cashback tidak ikut dijumlah** — keduanya
    /// menyumbang nol di sini. Jadi `discount_amount` nol tidak berarti tidak
    /// ada voucher terpasang.
    @DoubleJson()
    @JsonKey(name: 'discount_amount')
    @Default(0)
    double discountAmount,
  }) = _CartSummaryModel;

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryModelFromJson(json);

  bool get isEmpty => itemCount == 0;

  bool get hasVouchers => vouchers.isNotEmpty;

  /// Total setelah potongan yang benar-benar berlaku sekarang.
  double get payableSubtotal {
    final left = subtotal - discountAmount;
    return left < 0 ? 0 : left;
  }
}
