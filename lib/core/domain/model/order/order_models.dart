import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'order_models.freezed.dart';
part 'order_models.g.dart';

/// Status order, sesuai `ENUM` kolom `orders.status` di skema backend.
///
/// Dijadikan enum supaya perbandingan status tidak ditulis sebagai string
/// bertaburan di layar — dan supaya status baru dari backend tidak diam-diam
/// lolos sebagai "tidak dikenal" tanpa ketahuan.
enum OrderStatus {
  pending('pending', 'Menunggu pembayaran'),
  paid('paid', 'Sudah dibayar'),
  processed('processed', 'Diproses penjual'),
  packed('packed', 'Sedang dikemas'),
  shipped('shipped', 'Dikirim'),
  delivered('delivered', 'Sampai tujuan'),
  completed('completed', 'Selesai'),
  cancelled('cancelled', 'Dibatalkan'),
  refundRequested('refund_requested', 'Pengajuan refund'),
  refundApproved('refund_approved', 'Refund disetujui'),
  refundRejected('refund_rejected', 'Refund ditolak'),

  /// Status yang belum dikenal aplikasi. Bukan error — backend boleh
  /// menambah status baru, dan layar cukup menampilkan kodenya apa adanya
  /// daripada gagal memuat pesanan.
  unknown('', 'Status lain');

  const OrderStatus(this.code, this.label);

  final String code;
  final String label;

  static OrderStatus fromCode(String? raw) {
    for (final status in values) {
      if (status.code == raw) return status;
    }
    return unknown;
  }
}

/// Satu pesanan.
///
/// **Order di API ini satu lapis**: order → `items[]`. Tidak ada `sub_orders`
/// maupun `shipments` seperti backend lama — keranjang multi-toko pecah jadi
/// **beberapa order**, satu per toko, yang berbagi satu transaksi pembayaran.
///
/// `GET /orders` (daftar) mengembalikan kolom yang sama **tanpa** [items],
/// [statusHistory], dan [refund]. Ketiganya hanya ada di `GET /orders/{id}`.
@freezed
abstract class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    @IntJson() required int id,
    @StringJson() @JsonKey(name: 'order_number') @Default('') String orderNumber,
    @StringOrNullJson() @JsonKey(name: 'checkout_session_id')
    String? checkoutSessionId,
    @IntJson() @JsonKey(name: 'store_id') @Default(0) int storeId,

    /// Kode status mentah. Pakai [status] untuk logika.
    @StringJson() @JsonKey(name: 'status') @Default('') String statusCode,

    @DoubleJson() @Default(0) double subtotal,
    @DoubleJson() @JsonKey(name: 'shipping_cost') @Default(0)
    double shippingCost,
    @DoubleJson() @JsonKey(name: 'discount_total') @Default(0)
    double discountTotal,
    @DoubleJson() @JsonKey(name: 'cashback_total') @Default(0)
    double cashbackTotal,
    @DoubleJson() @JsonKey(name: 'grand_total') @Default(0) double grandTotal,

    @StringOrNullJson() @JsonKey(name: 'courier_code') String? courierCode,
    @StringOrNullJson() @JsonKey(name: 'courier_service')
    String? courierService,
    @StringOrNullJson() @JsonKey(name: 'tracking_number')
    String? trackingNumber,

    /// ⚠️ **Hanya berisi `{"address_id": "59"}`**, bukan alamat lengkap —
    /// dan dikirim sebagai string berisi JSON. Untuk menampilkan alamat
    /// tujuan, ambil dari `GET /me/addresses` memakai id ini.
    @JsonMapJson() @JsonKey(name: 'shipping_address_snapshot')
    Map<String, dynamic>? shippingAddressSnapshot,

    /// Tenggat pembayaran, 1 jam sesudah [createdAt].
    ///
    /// Dulu dikirim dalam UTC sementara [createdAt] dalam WIB; sejak backend
    /// menyeragamkan zona waktunya (commit `93c6a14`) keduanya WIB. Lihat
    /// catatan di kepala `checkout_models.dart`.
    @ServerDateTimeJson() @JsonKey(name: 'payment_deadline')
    DateTime? paymentDeadline,

    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
    @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,

    @Default(<OrderItemModel>[]) List<OrderItemModel> items,
    @Default(<OrderStatusHistoryModel>[])
    @JsonKey(name: 'status_history')
    List<OrderStatusHistoryModel> statusHistory,
    OrderRefundModel? refund,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  OrderStatus get status => OrderStatus.fromCode(statusCode);

  /// Label status yang layak ditampilkan; status tak dikenal jatuh ke kodenya
  /// sendiri daripada tulisan "Status lain" yang tidak menjelaskan apa pun.
  String get statusLabel =>
      status == OrderStatus.unknown ? statusCode : status.label;

  /// Id alamat tujuan, satu-satunya isi `shipping_address_snapshot`.
  int? get shippingAddressId =>
      asIntOrNull(shippingAddressSnapshot?['address_id']);

  bool get isPending => status == OrderStatus.pending;
  bool get isCancelled => status == OrderStatus.cancelled;
  bool get isCompleted => status == OrderStatus.completed;

  /// Masih menunggu pembayaran dan tenggatnya belum lewat.
  bool get awaitsPayment {
    if (!isPending) return false;
    final deadline = paymentDeadline;
    return deadline == null || deadline.isAfter(DateTime.now().toUtc());
  }

  /// Sisa waktu membayar; `Duration.zero` kalau sudah lewat.
  Duration? get paymentTimeLeft {
    final deadline = paymentDeadline;
    if (deadline == null) return null;
    final left = deadline.difference(DateTime.now().toUtc());
    return left.isNegative ? Duration.zero : left;
  }

  /// Pembeli boleh membatalkan selama penjual belum memproses.
  bool get canCancel => status == OrderStatus.pending;

  /// Konfirmasi terima hanya sah dari `shipped` → `delivered`.
  ///
  /// Dipatok di sisi aplikasi karena `POST /orders/{id}/complete` **membalas
  /// HTML dengan status 200** kalau transisinya tidak sah — lihat
  /// `OrderService.complete`.
  bool get canConfirmDelivery => status == OrderStatus.shipped;

  /// Selesai hanya sah dari `delivered` → `completed`.
  bool get canComplete => status == OrderStatus.delivered;

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);
}

/// Baris pesanan. Seluruh datanya **snapshot saat order dibuat**, jadi
/// perubahan harga atau nama produk sesudahnya tidak mengubah pesanan lama.
@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'product_variant_id') @Default(0)
    int productVariantId,
    @StringJson() @JsonKey(name: 'product_name_snapshot') @Default('')
    String productName,

    /// String berisi JSON, seperti `variant_options` di katalog.
    @JsonMapJson() @JsonKey(name: 'variant_options_snapshot')
    Map<String, dynamic>? variantOptions,

    @DoubleJson() @JsonKey(name: 'price_snapshot') @Default(0) double price,
    @IntJson() @Default(0) int quantity,
    @DoubleJson() @Default(0) double subtotal,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  String get optionLabel {
    final options = variantOptions;
    if (options == null || options.isEmpty) return '';
    return options.values
        .map((v) => v?.toString() ?? '')
        .where((v) => v.isNotEmpty)
        .join(' · ');
  }
}

/// Satu langkah perpindahan status, untuk menampilkan riwayat pesanan.
@freezed
abstract class OrderStatusHistoryModel with _$OrderStatusHistoryModel {
  const OrderStatusHistoryModel._();

  const factory OrderStatusHistoryModel({
    @IntJson() required int id,
    @StringOrNullJson() @JsonKey(name: 'from_status') String? fromStatus,
    @StringJson() @JsonKey(name: 'to_status') @Default('') String toStatus,
    @StringOrNullJson() String? notes,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OrderStatusHistoryModel;

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryModelFromJson(json);

  OrderStatus get status => OrderStatus.fromCode(toStatus);

  String get label =>
      status == OrderStatus.unknown ? toStatus : status.label;
}

/// Pengajuan refund yang menempel pada order. `null` kalau tidak ada.
@freezed
abstract class OrderRefundModel with _$OrderRefundModel {
  const factory OrderRefundModel({
    @IntJson() required int id,
    @StringJson() @Default('') String status,
    @StringOrNullJson() String? reason,
    @DoubleJson() @Default(0) double amount,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OrderRefundModel;

  factory OrderRefundModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRefundModelFromJson(json);
}
