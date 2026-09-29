part of 'order_list_cubit.dart';

/// Tab status di "Pesanan Saya".
///
/// ⚠️ **Disaring di aplikasi, bukan di server**: `GET /orders` mengabaikan
/// `?status=` (lihat `OrderService`). Lihat [OrderListCubit] untuk cara
/// cubit menambal kelemahan penyaringan sisi klien.
///
/// Status refund (`refund_requested/approved/rejected`) sengaja **hanya
/// muncul di "Semua"**: tidak satu pun tab desain mewakilinya dengan jujur —
/// refund yang ditolak bukan "Dibatalkan", yang diajukan belum "Selesai".
enum OrderListFilter {
  all('Semua'),
  awaitingPayment('Menunggu Pembayaran'),
  processing('Diproses'),
  shipped('Dikirim'),
  delivered('Diterima'),
  completed('Selesai'),
  cancelled('Dibatalkan');

  const OrderListFilter(this.label);

  final String label;

  bool matches(OrderModel order) => switch (this) {
        OrderListFilter.all => true,
        OrderListFilter.awaitingPayment => order.status == OrderStatus.pending,
        // `paid` termasuk custom order yang menunggu konfirmasi penjual dan
        // usulan kirim sebagian — keduanya masih "di tangan penjual".
        OrderListFilter.processing => order.status == OrderStatus.paid ||
            order.status == OrderStatus.processed ||
            order.status == OrderStatus.packed,
        OrderListFilter.shipped => order.status == OrderStatus.shipped,
        OrderListFilter.delivered => order.status == OrderStatus.delivered,
        OrderListFilter.completed => order.status == OrderStatus.completed,
        OrderListFilter.cancelled => order.status == OrderStatus.cancelled,
      };
}

/// Status daftar pesanan.
@freezed
sealed class OrderListState with _$OrderListState {
  const OrderListState._();

  const factory OrderListState.loading() = OrderListLoading;

  const factory OrderListState.loaded({
    /// **Seluruh** pesanan yang sudah dimuat, belum disaring.
    required List<OrderModel> orders,
    @Default(1) int page,

    /// **Disimpulkan, bukan dibaca.** `GET /orders` tidak mengirim `meta`
    /// sama sekali — tidak ada `total` — jadi satu-satunya petunjuk adanya
    /// halaman berikutnya adalah halaman terakhir terisi penuh.
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    DataError? loadMoreError,
    @Default(OrderListFilter.all) OrderListFilter filter,
  }) = OrderListLoaded;

  const factory OrderListState.empty() = OrderListEmpty;

  const factory OrderListState.error(DataError error) = OrderListError;
}

extension OrderListLoadedX on OrderListLoaded {
  /// Pesanan yang lolos tab aktif, dari halaman yang **sudah dimuat** saja.
  List<OrderModel> get visibleOrders =>
      filter == OrderListFilter.all ? orders : orders.where(filter.matches).toList();
}
