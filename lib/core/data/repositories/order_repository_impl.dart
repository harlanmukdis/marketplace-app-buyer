import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
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
  Future<DataState<OrderModel>> confirmDelivery(int id, {String? sealCode}) =>
      _mutateThenRead(
          id, () => _service.confirmDelivery(id, sealCode: sealCode));

  @override
  Future<DataState<OrderModel>> complete(int id) =>
      _mutateThenRead(id, () => _service.complete(id));

  @override
  Future<DataState<OrderTrackingModel?>> fetchTracking(int id) =>
      guard(() => _service.fetchTracking(id));

  @override
  Future<DataState<List<ShipmentEvidenceModel>>> fetchShipmentEvidence(
          int id) =>
      guardList(() => _service.fetchShipmentEvidence(id));

  @override
  Future<DataState<OrderInvoiceModel>> fetchInvoice(int id) =>
      guard(() => _service.fetchInvoice(id));

  @override
  Future<DataState<OrderModel>> respondPartialFulfillment(
          int id, PartialFulfillmentDecision decision) =>
      _mutateThenRead(
          id, () => _service.respondPartialFulfillment(id, decision));

  @override
  Future<DataState<OrderModel>> requestRefund(
    int id, {
    required String reason,
    List<String> evidenceUrls = const [],
  }) =>
      _mutateThenRead(
          id,
          () => _service.requestRefund(id,
              reason: reason, evidenceUrls: evidenceUrls));

  @override
  Future<DataState<CancellationRequestModel?>> fetchCancellationRequest(
          int id) =>
      guard(() => _service.fetchCancellationRequest(id));

  @override
  Future<DataState<CancellationRequestModel>> requestCancellation(
    int id, {
    required CancellationReason reason,
    String? note,
  }) =>
      guard(() => _service.requestCancellation(id, reason: reason, note: note));

  @override
  Future<DataState<InsurancePolicyModel?>> fetchInsurance(int id) =>
      guard(() => _service.fetchInsurance(id));

  @override
  Future<DataState<InsurancePolicyModel>> optInSecurePlus(int id) =>
      guard(() => _service.optInSecurePlus(id));

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
