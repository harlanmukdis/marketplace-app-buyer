import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';

class OrderRepositoryImpl with RepositoryGuard implements OrderRepository {
  OrderRepositoryImpl(this._service);

  final OrderService _service;

  @override
  Future<DataState<List<OrderModel>>> fetchOrders({int page = 1}) =>
      guardList(() => _service.fetchOrders(page: page));

  @override
  Future<DataState<OrderModel>> fetchOrder(int id) =>
      guard(() => _service.fetchOrder(id));

  @override
  Future<DataState<OrderModel>> cancel(int id, {String? reason}) =>
      _mutateThenRead(id, () => _service.cancel(id, reason: reason));

  @override
  Future<DataState<OrderModel>> confirmDelivery(int id) =>
      _mutateThenRead(id, () => _service.confirmDelivery(id));

  @override
  Future<DataState<OrderModel>> complete(int id) =>
      _mutateThenRead(id, () => _service.complete(id));

  /// Menjalankan aksi lalu membaca ulang ordernya.
  ///
  /// Aksi status membalas `data: null`, jadi tanpa baca ulang layar tidak tahu
  /// status barunya — dan status itulah yang menentukan tombol mana yang boleh
  /// muncul berikutnya.
  Future<DataState<OrderModel>> _mutateThenRead(
    int id,
    Future<Object?> Function() action,
  ) async {
    try {
      await action();
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return guard(() => _service.fetchOrder(id));
  }
}
