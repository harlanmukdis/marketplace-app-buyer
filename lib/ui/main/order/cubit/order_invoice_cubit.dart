import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'order_invoice_cubit.freezed.dart';

/// Status layar invoice.
@freezed
sealed class OrderInvoiceState with _$OrderInvoiceState {
  const factory OrderInvoiceState.loading() = OrderInvoiceLoading;
  const factory OrderInvoiceState.loaded(OrderInvoiceModel invoice) = OrderInvoiceLoaded;

  /// `422 INVOICE_NOT_AVAILABLE`: pesanan belum `completed` (atau batal /
  /// refund penuh, yang memang tidak pernah mendapat invoice). Dipisah dari
  /// [OrderInvoiceState.error] karena ini keadaan normal, bukan kegagalan.
  const factory OrderInvoiceState.unavailable() = OrderInvoiceUnavailable;
  const factory OrderInvoiceState.error(DataError error) = OrderInvoiceError;
}

/// Final Invoice dari `GET /orders/{id}/invoice`. Nomornya idempoten di
/// server, jadi memuat ulang tidak menerbitkan invoice baru.
class OrderInvoiceCubit extends Cubit<OrderInvoiceState> {
  OrderInvoiceCubit(this.orderId)
      : _repository = injector<OrderRepository>(),
        super(const OrderInvoiceState.loading());

  final int orderId;
  final OrderRepository _repository;

  Future<void> load() async {
    emit(const OrderInvoiceState.loading());
    final result = await _repository.fetchInvoice(orderId);
    if (isClosed) return;
    switch (result) {
      case DataSuccess(:final data):
        emit(OrderInvoiceState.loaded(data));
      case DataFailed(:final error) when error.code == ApiErrorCode.invoiceNotAvailable:
        emit(const OrderInvoiceState.unavailable());
      case DataFailed(:final error):
        emit(OrderInvoiceState.error(error));
      case DataEmpty():
        emit(const OrderInvoiceState.unavailable());
      case DataLoading():
        break;
    }
  }
}
