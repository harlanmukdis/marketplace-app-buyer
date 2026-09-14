import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';

/// Isi keranjang beserta ringkasannya.
///
/// Digabung jadi satu hasil karena layar keranjang **selalu** butuh keduanya:
/// daftar barang dan total yang boleh dipercaya. Menyerahkan penggabungan itu
/// ke cubit akan mengundang keduanya tampil tidak sinkron — daftar sudah
/// diperbarui, total belum.
class CartSnapshot {
  const CartSnapshot({required this.groups, required this.summary});

  final List<CartStoreGroup> groups;
  final CartSummaryModel summary;

  static const empty = CartSnapshot(
    groups: [],
    summary: CartSummaryModel(),
  );

  bool get isEmpty => groups.isEmpty;

  /// Semua baris dari seluruh toko, diratakan.
  List<CartItemModel> get allItems => [
        for (final group in groups) ...group.items,
      ];

  int get totalLines => allItems.length;

  bool get hasSelection => allItems.any((i) => i.isSelected);
}

/// Antarmuka keranjang yang dikonsumsi cubit.
///
/// **Setiap method yang mengubah keranjang mengembalikan [CartSnapshot] hasil
/// baca ulang**, bukan sekadar `void`. Itu bukan kemewahan: `PATCH` dan
/// `DELETE` di API ini membalas `data: null`, dan bahkan sukses untuk baris
/// yang tidak ada — jadi satu-satunya cara mengetahui keadaan keranjang yang
/// sebenarnya adalah membacanya lagi. Repository yang menanggung itu supaya
/// tidak ada layar yang lupa.
abstract class CartRepository {
  Future<DataState<CartSnapshot>> fetchCart();

  /// Menambah varian ke keranjang.
  ///
  /// Varian yang sudah ada **digabung** server ke baris lama, bukan jadi baris
  /// baru — jadi hasilnya bisa berupa keranjang dengan jumlah baris yang sama.
  Future<DataState<CartSnapshot>> addItem({
    required int productVariantId,
    required int quantity,
  });

  /// Mengubah kuantitas satu baris.
  ///
  /// ⚠️ Server menerima nilai apa pun, termasuk melebihi stok dan nol.
  /// Pemanggil wajib membatasi lebih dulu.
  Future<DataState<CartSnapshot>> updateQuantity(int itemId, int quantity);

  /// Mencentang / membatalkan centang satu baris. Hanya baris tercentang yang
  /// dihitung ringkasan dan ikut ke checkout.
  Future<DataState<CartSnapshot>> setSelected(int itemId, bool isSelected);

  Future<DataState<CartSnapshot>> removeItem(int itemId);

  /// Pratinjau diskon voucher terhadap keranjang.
  ///
  /// Tidak ada pasangan "lepas voucher" — rutenya tidak ada di API.
  Future<DataState<CartSnapshot>> applyVoucher(String code);
}
