import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';

/// Wishlist pembeli.
///
/// Mutasi mengembalikan daftar hasil **baca ulang**: `POST` membalas
/// `data: null` dan `DELETE` untuk produk yang tidak ada tetap `200`, jadi
/// tidak ada cara lain mengetahui isi sesudahnya.
abstract class WishlistRepository {
  Future<DataState<List<WishlistItemModel>>> fetch();

  /// Menambah produk. Aman dipanggil untuk produk yang sudah ada — server
  /// tidak menggandakannya.
  Future<DataState<List<WishlistItemModel>>> add(int productId);

  /// Menghapus produk. Parameternya **id produk**, bukan `wishlist_item_id`.
  Future<DataState<List<WishlistItemModel>>> remove(int productId);

  /// Menyalakan/mematikan pantau harga & stok satu produk, lalu membaca ulang
  /// (kontrak usulan — lihat `WishlistService.setAlert`).
  Future<DataState<List<WishlistItemModel>>> setAlert(int productId,
      {required bool enabled});
}
