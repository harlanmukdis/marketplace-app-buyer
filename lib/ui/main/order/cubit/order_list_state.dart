part of 'order_list_cubit.dart';

/// Status daftar pesanan.
///
/// Tidak ada filter status di sini: `GET /orders` mengabaikan `?status=`
/// (lihat `OrderService`), jadi menyediakan filter hanya akan terlihat bekerja
/// tanpa benar-benar menyaring apa pun.
@freezed
sealed class OrderListState with _$OrderListState {
  const OrderListState._();

  const factory OrderListState.loading() = OrderListLoading;

  const factory OrderListState.loaded({
    required List<OrderModel> orders,
    @Default(1) int page,

    /// **Disimpulkan, bukan dibaca.** `GET /orders` tidak mengirim `meta`
    /// sama sekali — tidak ada `total` — jadi satu-satunya petunjuk adanya
    /// halaman berikutnya adalah halaman terakhir terisi penuh.
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    DataError? loadMoreError,
  }) = OrderListLoaded;

  const factory OrderListState.empty() = OrderListEmpty;

  const factory OrderListState.error(DataError error) = OrderListError;
}
