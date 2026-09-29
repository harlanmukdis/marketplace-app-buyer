import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/voucher_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/voucher_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/voucher_repository.dart';

/// Memakai [guard], bukan `guardList`: daftar kosong adalah keadaan normal
/// voucher di dev, dan layar menampilkannya per bagian — `DataEmpty` hanya
/// menambah satu cabang tanpa informasi baru.
class VoucherRepositoryImpl with RepositoryGuard implements VoucherRepository {
  VoucherRepositoryImpl(this._service);

  final VoucherService _service;

  @override
  Future<DataState<List<VoucherModel>>> fetchMyVouchers() =>
      guard(_service.fetchMyVouchers);

  @override
  Future<DataState<List<VoucherModel>>> claim(String code) async {
    try {
      await _service.claim(code);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return fetchMyVouchers();
  }

  @override
  Future<DataState<List<AppliedVoucherModel>>> fetchRecommended() =>
      guard(_service.fetchRecommended);

  @override
  Future<DataState<List<AppliedVoucherModel>>> autoApply() =>
      guard(_service.autoApply);
}
