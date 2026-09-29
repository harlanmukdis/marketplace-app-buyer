import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';

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

  /// `shipped` → `delivered`. Pesanan Secure+ menuntut [sealCode].
  Future<DataState<OrderModel>> confirmDelivery(int id, {String? sealCode});

  /// `delivered` → `completed`.
  ///
  /// ⚠️ Pemanggil wajib memeriksa `OrderModel.canComplete` lebih dulu:
  /// endpoint ini membalas halaman HTML berstatus 200 kalau transisinya tidak
  /// sah, bukan error yang rapi.
  Future<DataState<OrderModel>> complete(int id);

  /// Resi & status pengiriman; `DataSuccess(null)` selama belum dikirim.
  Future<DataState<OrderTrackingModel?>> fetchTracking(int id);

  Future<DataState<List<ShipmentEvidenceModel>>> fetchShipmentEvidence(int id);

  Future<DataState<OrderInvoiceModel>> fetchInvoice(int id);

  Future<DataState<OrderModel>> respondPartialFulfillment(
      int id, PartialFulfillmentDecision decision);

  /// Komplain & refund. [evidenceUrls] dikirim sebagai field yang diusulkan
  /// (`evidence_urls`) — server hari ini mengabaikannya (docs/22 #5).
  Future<DataState<OrderModel>> requestRefund(
    int id, {
    required String reason,
    List<String> evidenceUrls,
  });

  /// Permohonan pembatalan terakhir (`DataSuccess(null)` kalau belum ada).
  /// **Diusulkan** (docs/22 #3); tanpa mock, rutenya 404 HTML.
  Future<DataState<CancellationRequestModel?>> fetchCancellationRequest(int id);

  /// "Ajukan Pembatalan" sesudah resi. **Diusulkan** (docs/22 #3).
  Future<DataState<CancellationRequestModel>> requestCancellation(
    int id, {
    required CancellationReason reason,
    String? note,
  });

  /// Polis Secure+ (`DataSuccess(null)` kalau belum ada). **Diusulkan.**
  Future<DataState<InsurancePolicyModel?>> fetchInsurance(int id);

  /// Mengaktifkan Xpedia Secure+ — endpoint **sungguhan**.
  Future<DataState<InsurancePolicyModel>> optInSecurePlus(int id);
}
