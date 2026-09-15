import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';

/// Pesanan milik pembeli.
///
/// Aksi yang mengubah status mengembalikan **order hasil baca ulang**, bukan
/// `void`: endpointnya membalas `data: null`, jadi layar tidak punya cara lain
/// mengetahui status barunya.
abstract class OrderRepository {
  /// Daftar pesanan, terbaru dulu.
  ///
  /// **Tidak ada penyaringan status**: `GET /orders` mengabaikan `?status=`
  /// (lihat `OrderService`). Ukuran halaman juga ditentukan server, dan `meta`
  /// tidak dikirim — paginasi harus disimpulkan dari jumlah hasil.
  Future<DataState<List<OrderModel>>> fetchOrders({int page});

  Future<DataState<OrderModel>> fetchOrder(int id);

  Future<DataState<OrderModel>> cancel(int id, {String? reason});

  /// `shipped` → `delivered`.
  Future<DataState<OrderModel>> confirmDelivery(int id);

  /// `delivered` → `completed`.
  ///
  /// ⚠️ Pemanggil wajib memeriksa `OrderModel.canComplete` lebih dulu:
  /// endpoint ini membalas halaman HTML berstatus 200 kalau transisinya tidak
  /// sah, bukan error yang rapi.
  Future<DataState<OrderModel>> complete(int id);
}
