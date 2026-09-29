import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/services/order_payment_link_store.dart';
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
    @StringJson()
    @JsonKey(name: 'order_number')
    @Default('')
    String orderNumber,
    @StringOrNullJson()
    @JsonKey(name: 'checkout_session_id')
    String? checkoutSessionId,
    @IntJson() @JsonKey(name: 'store_id') @Default(0) int storeId,

    /// Kode status mentah. Pakai [status] untuk logika.
    @StringJson() @JsonKey(name: 'status') @Default('') String statusCode,
    @DoubleJson() @Default(0) double subtotal,
    @DoubleJson()
    @JsonKey(name: 'shipping_cost')
    @Default(0)
    double shippingCost,
    @DoubleJson()
    @JsonKey(name: 'discount_total')
    @Default(0)
    double discountTotal,
    @DoubleJson()
    @JsonKey(name: 'cashback_total')
    @Default(0)
    double cashbackTotal,
    @DoubleJson() @JsonKey(name: 'grand_total') @Default(0) double grandTotal,
    @StringOrNullJson() @JsonKey(name: 'courier_code') String? courierCode,
    @StringOrNullJson()
    @JsonKey(name: 'courier_service')
    String? courierService,
    @StringOrNullJson()
    @JsonKey(name: 'tracking_number')
    String? trackingNumber,

    /// ⚠️ **Hanya berisi `{"address_id": "59"}`**, bukan alamat lengkap —
    /// dan dikirim sebagai string berisi JSON.
    ///
    /// Sejak backend v1.x (blueprint Seller Ch.7) field ini **hanya ada di
    /// `GET /orders` (daftar)**. `GET /orders/{id}` menggantinya dengan
    /// [shippingAddress] yang sudah terselesaikan.
    @JsonMapJson()
    @JsonKey(name: 'shipping_address_snapshot')
    Map<String, dynamic>? shippingAddressSnapshot,

    /// Alamat tujuan lengkap, **hanya di `GET /orders/{id}`**.
    ///
    /// ⚠️ Bukan snapshot: server menggabungkannya secara live ke
    /// `user_addresses`, jadi mengubah alamat itu sesudahnya ikut mengubah
    /// pesanan lama, dan menghapusnya membuat field ini `null`.
    @JsonKey(name: 'shipping_address') OrderShippingAddress? shippingAddress,

    /// **Belum dikirim server** — kontrak yang diusulkan (lihat
    /// `OrderPaymentLinkStore`). Selama `null`, pakai [payableTransactionId].
    @IntOrNullJson()
    @JsonKey(name: 'payment_transaction_id')
    int? paymentTransactionId,

    /// Pihak yang menyebabkan pembatalan: `buyer`, `seller`, `system`.
    @StringOrNullJson()
    @JsonKey(name: 'cancellation_fault')
    String? cancellationFault,

    /// Custom order yang menunggu konfirmasi penjual. Statusnya tetap `paid`
    /// — **tidak ada status "Menunggu Konfirmasi" di server** — jadi
    /// [awaitsSellerConfirmation] yang menyimpulkannya.
    @BoolJson()
    @JsonKey(name: 'requires_custom_confirmation')
    @Default(false)
    bool requiresCustomConfirmation,
    @ServerDateTimeJson()
    @JsonKey(name: 'custom_confirmed_at')
    DateTime? customConfirmedAt,
    @IntOrNullJson()
    @JsonKey(name: 'estimated_lead_time_days')
    int? estimatedLeadTimeDays,

    /// Penjual mengusulkan kirim sebagian karena sebagian barang tidak
    /// tersedia. Statusnya tetap `paid`; pembeli menjawab lewat
    /// `POST /orders/{id}/partial-fulfillment/respond`.
    @ServerDateTimeJson()
    @JsonKey(name: 'partial_fulfillment_proposed_at')
    DateTime? partialFulfillmentProposedAt,

    /// `continue_partial` / `cancel_whole`, `null` selama belum dijawab.
    @StringOrNullJson()
    @JsonKey(name: 'partial_fulfillment_decision')
    String? partialFulfillmentDecision,

    /// Tenggat pembayaran, 1 jam sesudah [createdAt].
    ///
    /// Dulu dikirim dalam UTC sementara [createdAt] dalam WIB; sejak backend
    /// menyeragamkan zona waktunya (commit `93c6a14`) keduanya WIB. Lihat
    /// catatan di kepala `checkout_models.dart`.
    @ServerDateTimeJson()
    @JsonKey(name: 'payment_deadline')
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

  /// Id alamat tujuan, satu-satunya isi `shipping_address_snapshot`
  /// (hanya ada di daftar pesanan).
  int? get shippingAddressId =>
      asIntOrNull(shippingAddressSnapshot?['address_id']);

  /// Custom order yang belum dikonfirmasi penjual (maks 48 jam, lalu batal
  /// otomatis dengan refund penuh).
  bool get awaitsSellerConfirmation =>
      requiresCustomConfirmation &&
      customConfirmedAt == null &&
      status == OrderStatus.paid;

  /// Ada usulan kirim sebagian yang menunggu jawaban pembeli.
  bool get awaitsPartialDecision =>
      partialFulfillmentProposedAt != null &&
      partialFulfillmentDecision == null;

  bool get isPending => status == OrderStatus.pending;

  /// Transaksi untuk membayar pesanan ini: field server kalau ada, selain
  /// itu tautan yang diingat perangkat sejak checkout.
  int? get payableTransactionId =>
      paymentTransactionId ?? OrderPaymentLinkStore.transactionFor(id);
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

  /// Pembeli boleh membatalkan langsung selama penjual belum mengemas —
  /// server menerima `pending` **dan** `paid` (`Order_model::cancel()`).
  ///
  /// Ini tahap pertama dari tiga tahap pembatalan di blueprint ("Batalkan
  /// Pesanan", sebelum resi). Tahap kedua ada di [canRequestCancellation].
  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.paid;

  /// Tahap kedua pembatalan: **"Ajukan Pembatalan"** sesudah penjual
  /// mengemas/membuat resi, yang harus disetujui penjual (docs/22 #3).
  ///
  /// ⚠️ Endpoint-nya (`POST /orders/{id}/cancellation-request`) **belum ada di
  /// backend** — kontrak yang diusulkan dan mock-nya ada di
  /// `assets/mock/pending_api/README.md`. Batas statusnya sengaja sama dengan
  /// yang ditegakkan mock (`packed` | `shipped`), supaya tombolnya tidak
  /// pernah muncul untuk permintaan yang pasti ditolak.
  bool get canRequestCancellation =>
      status == OrderStatus.packed || status == OrderStatus.shipped;

  /// Xpedia Secure+ hanya masuk akal **sebelum penjual mengirim**: gerbangnya
  /// (bukti foto+video pra-serah-terima dan kode segel) ditegakkan di
  /// `Order_model::ship()`. `POST /orders/{id}/insurance/opt-in` sendiri
  /// tidak memeriksa status apa pun, jadi batasnya dijaga di sini.
  bool get canOptInSecurePlus =>
      status == OrderStatus.pending || status == OrderStatus.paid;

  /// Konfirmasi terima hanya sah dari `shipped` → `delivered`.
  ///
  /// Dipatok di sisi aplikasi karena `POST /orders/{id}/complete` **membalas
  /// HTML dengan status 200** kalau transisinya tidak sah — lihat
  /// `OrderService.complete`.
  bool get canConfirmDelivery => status == OrderStatus.shipped;

  /// Selesai hanya sah dari `delivered` → `completed`.
  bool get canComplete => status == OrderStatus.delivered;

  /// Final Invoice hanya ada untuk pesanan `completed` (blueprint Buyer Ch.10);
  /// batal dan refund penuh tidak pernah mendapat invoice.
  bool get hasInvoice => isCompleted;

  /// Komplain & refund dibuka sesudah barang **diterima** (tahap ketiga
  /// pembatalan di blueprint).
  ///
  /// ⚠️ `POST /orders/{id}/refund-request` sendiri **tidak punya gerbang
  /// status** — ia memindahkan status apa pun ke `refund_requested` — jadi
  /// penjagaannya di sini. Endpointnya juga belum menerima bukti foto/video
  /// (docs/22 #5).
  bool get canRequestRefund =>
      (status == OrderStatus.delivered || status == OrderStatus.completed) &&
      refund == null;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}

/// Baris pesanan. Seluruh datanya **snapshot saat order dibuat**, jadi
/// perubahan harga atau nama produk sesudahnya tidak mengubah pesanan lama.
@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    @IntJson() required int id,
    @IntJson()
    @JsonKey(name: 'product_variant_id')
    @Default(0)
    int productVariantId,
    @StringJson()
    @JsonKey(name: 'product_name_snapshot')
    @Default('')
    String productName,

    /// String berisi JSON, seperti `variant_options` di katalog.
    @JsonMapJson()
    @JsonKey(name: 'variant_options_snapshot')
    Map<String, dynamic>? variantOptions,
    @DoubleJson() @JsonKey(name: 'price_snapshot') @Default(0) double price,
    @IntJson() @Default(0) int quantity,
    @DoubleJson() @Default(0) double subtotal,

    /// `false` untuk barang yang ditandai penjual tidak tersedia dalam usulan
    /// kirim sebagian.
    @BoolJson() @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
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

  String get label => status == OrderStatus.unknown ? toStatus : status.label;
}

/// Alamat tujuan terselesaikan di `GET /orders/{id}`.
@freezed
abstract class OrderShippingAddress with _$OrderShippingAddress {
  const OrderShippingAddress._();

  const factory OrderShippingAddress({
    @StringOrNullJson() @JsonKey(name: 'recipient_name') String? recipientName,
    @StringOrNullJson() String? phone,
    @StringOrNullJson() @JsonKey(name: 'full_address') String? fullAddress,
    @StringOrNullJson() String? city,
    @StringOrNullJson() String? province,
    @StringOrNullJson() @JsonKey(name: 'postal_code') String? postalCode,
  }) = _OrderShippingAddress;

  factory OrderShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$OrderShippingAddressFromJson(json);

  /// "Jl. Melati 10, Bandung, Jawa Barat 40111".
  String get singleLine => [
        fullAddress,
        city,
        [province, postalCode]
            .whereType<String>()
            .where((v) => v.isNotEmpty)
            .join(' '),
      ].whereType<String>().where((v) => v.trim().isNotEmpty).join(', ');
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

/// Pengiriman dari `GET /orders/{id}/tracking` — baris `order_shipments`
/// mentah. `null` selama penjual belum membuat resi.
///
/// ⚠️ **Riwayat perjalanan kurir belum ditulis server.** Kolom
/// `tracking_history` ada di skema (`JSON NULL`), tapi tidak satu pun kode
/// backend menulisnya. Bentuk yang diusulkan ada di [trackingHistory]; di
/// build debug mock `GET /orders/{id}/tracking` menyisipkannya (ditandai
/// `meta.mock_fields`), sehingga layar Lacak Paket bisa dibangun persis
/// seolah datanya sudah ada.
@freezed
abstract class OrderTrackingModel with _$OrderTrackingModel {
  const OrderTrackingModel._();

  const factory OrderTrackingModel({
    @StringJson()
    @JsonKey(name: 'courier_code')
    @Default('')
    String courierCode,
    @StringJson()
    @JsonKey(name: 'service_type')
    @Default('')
    String serviceType,
    @StringOrNullJson() @JsonKey(name: 'awb_number') String? awbNumber,

    /// `drop_off` (diantar penjual) atau `pickup` (dijemput kurir).
    @StringOrNullJson()
    @JsonKey(name: 'handover_method')
    String? handoverMethod,

    /// `pending`, `picked_up`, `in_transit`, `delivered`, `returned`, `lost`.
    @StringJson() @Default('pending') String status,
    @ServerDateTimeJson() @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @ServerDateTimeJson() @JsonKey(name: 'delivered_at') DateTime? deliveredAt,

    /// Peristiwa perjalanan dari kurir, **terbaru dulu**. Kosong selama server
    /// belum menulisnya (lihat catatan kelas).
    ///
    /// Kolomnya bertipe `JSON`, dan driver MySQL PHP meneruskan kolom JSON
    /// sebagai **string** — pola yang sama dengan `selected_couriers` di sesi
    /// checkout — jadi [TrackingHistoryJson] menerima array maupun string.
    @TrackingHistoryJson()
    @JsonKey(name: 'tracking_history')
    @Default(<TrackingEventModel>[])
    List<TrackingEventModel> trackingHistory,
  }) = _OrderTrackingModel;

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingModelFromJson(json);

  String get statusLabel => switch (status) {
        'pending' => 'Menunggu dijemput kurir',
        'picked_up' => 'Paket sudah diambil kurir',
        'in_transit' => 'Dalam perjalanan',
        'delivered' => 'Paket sudah sampai',
        'returned' => 'Paket dikembalikan',
        'lost' => 'Paket hilang',
        _ => status,
      };
}

/// Satu peristiwa perjalanan paket (kontrak yang diusulkan untuk
/// `order_shipments.tracking_history`, lihat `assets/mock/pending_api/README.md`).
@freezed
abstract class TrackingEventModel with _$TrackingEventModel {
  const TrackingEventModel._();

  const factory TrackingEventModel({
    /// Status pengiriman **saat peristiwa itu**, memakai ENUM yang sama
    /// dengan `order_shipments.status` (`picked_up`, `in_transit`,
    /// `delivered`, `returned`, `lost`) supaya tidak ada kosakata kedua.
    @StringJson() @Default('in_transit') String status,
    @StringJson() @Default('') String description,
    @StringOrNullJson() String? location,
    @ServerDateTimeJson() @JsonKey(name: 'occurred_at') DateTime? occurredAt,
  }) = _TrackingEventModel;

  factory TrackingEventModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingEventModelFromJson(json);

  bool get isDelivered => status == 'delivered';
}

/// `List<TrackingEventModel>` dari array JSON **atau string berisi JSON**.
///
/// Isi yang rusak menghasilkan daftar kosong, bukan lemparan: riwayat kurir
/// adalah pelengkap, dan tidak boleh menggagalkan layar yang tetap bisa
/// menampilkan resi.
class TrackingHistoryJson
    extends JsonConverter<List<TrackingEventModel>, Object?> {
  const TrackingHistoryJson();

  @override
  List<TrackingEventModel> fromJson(Object? json) {
    Object? raw = json;
    if (raw is String) {
      final text = raw.trim();
      if (text.isEmpty) return const [];
      try {
        raw = jsonDecode(text);
      } on FormatException {
        return const [];
      }
    }
    if (raw is! List) return const [];
    return [
      for (final e in raw)
        if (e is Map) TrackingEventModel.fromJson(Map<String, dynamic>.from(e)),
    ];
  }

  @override
  Object? toJson(List<TrackingEventModel> object) =>
      [for (final e in object) e.toJson()];
}

/// Bukti foto/video Secure+ sebelum serah terima ke kurir, dari
/// `GET /orders/{id}/shipment-evidence`. Kosong untuk pesanan non-Secure+.
@freezed
abstract class ShipmentEvidenceModel with _$ShipmentEvidenceModel {
  const ShipmentEvidenceModel._();

  const factory ShipmentEvidenceModel({
    @IntJson() required int id,

    /// `photo` / `video`.
    @StringJson()
    @JsonKey(name: 'media_type')
    @Default('photo')
    String mediaType,
    @StringJson() @Default('') String url,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ShipmentEvidenceModel;

  factory ShipmentEvidenceModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentEvidenceModelFromJson(json);

  bool get isVideo => mediaType == 'video';
}

/// Final Invoice dari `GET /orders/{id}/invoice`.
///
/// Hanya terbit untuk pesanan `completed`; selainnya dibalas
/// `422 INVOICE_NOT_AVAILABLE`. Nomornya idempoten — panggilan berikutnya
/// mengembalikan invoice yang sama. ⚠️ **JSON saja, tidak ada PDF**; dan
/// alamatnya tidak disensor (docs/22 #6 belum dikerjakan).
@freezed
abstract class OrderInvoiceModel with _$OrderInvoiceModel {
  const factory OrderInvoiceModel({
    @StringJson()
    @JsonKey(name: 'invoice_number')
    @Default('')
    String invoiceNumber,
    @ServerDateTimeJson() @JsonKey(name: 'generated_at') DateTime? generatedAt,
    @StringJson()
    @JsonKey(name: 'order_number')
    @Default('')
    String orderNumber,
    @ServerDateTimeJson() @JsonKey(name: 'order_date') DateTime? orderDate,
    @JsonKey(name: 'store') InvoiceStoreModel? store,
    @JsonKey(name: 'shipping_address') OrderShippingAddress? shippingAddress,
    @Default(<OrderItemModel>[]) List<OrderItemModel> items,
    @DoubleJson() @Default(0) double subtotal,
    @DoubleJson()
    @JsonKey(name: 'shipping_cost')
    @Default(0)
    double shippingCost,
    @DoubleJson()
    @JsonKey(name: 'discount_total')
    @Default(0)
    double discountTotal,
    @DoubleJson() @JsonKey(name: 'grand_total') @Default(0) double grandTotal,
  }) = _OrderInvoiceModel;

  factory OrderInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$OrderInvoiceModelFromJson(json);
}

@freezed
abstract class InvoiceStoreModel with _$InvoiceStoreModel {
  const factory InvoiceStoreModel({
    @IntJson() @Default(0) int id,
    @StringJson() @Default('') String name,
  }) = _InvoiceStoreModel;

  factory InvoiceStoreModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceStoreModelFromJson(json);
}

/// Jawaban pembeli atas usulan kirim sebagian.
enum PartialFulfillmentDecision {
  /// Terima kiriman sebagian; subtotal barang yang tidak tersedia dikembalikan
  /// ke dompet (ongkir tidak).
  continuePartial('continue_partial'),

  /// Batalkan seluruh pesanan dengan refund penuh.
  cancelWhole('cancel_whole');

  const PartialFulfillmentDecision(this.code);

  final String code;
}
