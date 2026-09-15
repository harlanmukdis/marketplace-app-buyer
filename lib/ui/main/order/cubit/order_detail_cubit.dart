import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'order_detail_cubit.freezed.dart';
part 'order_detail_state.dart';

/// Detail satu pesanan beserta aksi status yang boleh dilakukan pembeli.
///
/// ⚠️ **Setiap aksi diperiksa terhadap status order lebih dulu**, bukan
/// diserahkan ke server. Alasannya bukan kerapian: `POST /orders/{id}/complete`
/// membalas **halaman HTML berstatus 200** kalau transisinya tidak sah, yang
/// sampai ke aplikasi sebagai `CLIENT_BAD_RESPONSE` — pesan yang tidak bisa
/// dijelaskan ke user. Memeriksa lebih dulu membuat kasus itu tidak pernah
/// terjadi lewat tombol.
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this.orderId)
      : _repository = injector<OrderRepository>(),
        super(const OrderDetailState.loading());

  static OrderDetailCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final int orderId;
  final OrderRepository _repository;

  Future<void> load() async {
    emit(const OrderDetailState.loading());
    final result = await _repository.fetchOrder(orderId);
    if (isClosed) return;
    _apply(result);
  }

  /// Membatalkan pesanan yang belum diproses penjual.
  Future<void> cancel({String? reason}) => _act(
        allowed: (order) => order.canCancel,
        action: () => _repository.cancel(orderId, reason: reason),
      );

  /// Menandai barang sudah diterima (`shipped` → `delivered`).
  Future<void> confirmDelivery() => _act(
        allowed: (order) => order.canConfirmDelivery,
        action: () => _repository.confirmDelivery(orderId),
      );

  /// Menyelesaikan pesanan (`delivered` → `completed`).
  Future<void> complete() => _act(
        allowed: (order) => order.canComplete,
        action: () => _repository.complete(orderId),
      );

  void clearActionError() {
    final current = state;
    if (current is! OrderDetailLoaded || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  Future<void> _act({
    required bool Function(OrderModel order) allowed,
    required Future<DataState<OrderModel>> Function() action,
  }) async {
    final current = state;
    if (current is! OrderDetailLoaded || current.isSubmitting) return;

    if (!allowed(current.order)) {
      emit(current.copyWith(
        actionError: const DataError(
          code: ApiErrorCode.invalidTransition,
          message: 'Status pesanan tidak memungkinkan aksi ini',
          kind: DataErrorKind.api,
        ),
      ));
      return;
    }

    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result = await action();
    if (isClosed) return;
    _apply(result, previous: current);
  }

  void _apply(
    DataState<OrderModel> result, {
    OrderDetailLoaded? previous,
  }) {
    switch (result) {
      case DataSuccess(:final data):
        emit(OrderDetailState.loaded(order: data));
      case DataFailed(:final error):
        if (previous != null) {
          // Aksi gagal tidak boleh membuang pesanan yang sudah tampil.
          emit(previous.copyWith(isSubmitting: false, actionError: error));
        } else {
          emit(OrderDetailState.error(error));
        }
      case DataEmpty():
      case DataLoading():
        break;
    }
  }
}
