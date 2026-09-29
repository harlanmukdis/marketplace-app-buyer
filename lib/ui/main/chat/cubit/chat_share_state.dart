part of 'chat_share_cubit.dart';

enum ChatPickerStatus { idle, loading, ready, error }

@freezed
abstract class ChatShareState with _$ChatShareState {
  const ChatShareState._();

  const factory ChatShareState({
    /// Toko lawan bicara. Dari konteks pembuka, atau diselesaikan lewat
    /// daftar percakapan saat laci lampiran pertama dibuka.
    int? storeId,

    /// Produk yang sedang ditanyakan (ruang dibuka dari halaman produk).
    int? pinnedProductId,
    @Default(false) bool pinnedDismissed,
    @Default(<int, ProductModel>{}) Map<int, ProductModel> products,
    @Default(<int, OrderModel>{}) Map<int, OrderModel> orders,
    @Default(<int>{}) Set<int> failedProductIds,
    @Default(<int>{}) Set<int> failedOrderIds,
    @Default(ChatPickerStatus.idle) ChatPickerStatus pickerStatus,
    @Default(<OrderModel>[]) List<OrderModel> pickerOrders,
    DataError? pickerError,
  }) = _ChatShareState;

  /// Produk yang disematkan dan sudah termuat, selama belum ditutup.
  ProductModel? get pinnedProduct {
    final id = pinnedProductId;
    if (id == null || pinnedDismissed) return null;
    return products[id];
  }
}
