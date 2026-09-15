part of 'order_detail_cubit.dart';

/// Status halaman detail pesanan.
@freezed
sealed class OrderDetailState with _$OrderDetailState {
  const OrderDetailState._();

  const factory OrderDetailState.loading() = OrderDetailLoading;

  const factory OrderDetailState.loaded({
    required OrderModel order,

    /// Sedang mengirim aksi status (batal / konfirmasi terima / selesai).
    @Default(false) bool isSubmitting,
    DataError? actionError,
  }) = OrderDetailLoaded;

  const factory OrderDetailState.error(DataError error) = OrderDetailError;

  bool get canAct => switch (this) {
        OrderDetailLoaded(:final isSubmitting) => !isSubmitting,
        _ => false,
      };
}
