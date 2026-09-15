import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/payment_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl with RepositoryGuard implements PaymentRepository {
  PaymentRepositoryImpl(this._service);

  final PaymentService _service;

  @override
  Future<DataState<List<PaymentMethodModel>>> fetchMethods() =>
      guardList(_service.fetchMethods);

  @override
  Future<DataState<PaymentSnapshot>> load(int txId) async {
    final PaymentModel payment;
    try {
      payment = (await _service.fetchPayment(txId)).data;
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }

    // Transaksi yang sudah dibayar atau kedaluwarsa tidak perlu instruksi —
    // memintanya hanya menambah satu request yang bisa gagal tanpa guna.
    if (payment.isPaid || payment.isExpired) {
      return DataSuccess(PaymentSnapshot(payment: payment));
    }

    PaymentInstructionModel? instruction;
    try {
      instruction = (await _service.pay(txId)).data;
    } on ApiException catch (_) {
      // Gagal mengambil instruksi tidak menggagalkan layar: status transaksi
      // tetap bisa ditampilkan, dan user bisa mencoba lagi.
    }

    return DataSuccess(
      PaymentSnapshot(payment: payment, instruction: instruction),
    );
  }

  @override
  Future<DataState<PaymentSnapshot>> refreshStatus(int txId) async {
    try {
      final payment = (await _service.fetchPayment(txId)).data;
      return DataSuccess(PaymentSnapshot(payment: payment));
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }
}
