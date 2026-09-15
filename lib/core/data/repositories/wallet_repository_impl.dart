import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl with RepositoryGuard implements WalletRepository {
  WalletRepositoryImpl(this._service);

  final WalletService _service;

  @override
  Future<DataState<WalletModel>> fetchWallet() =>
      guard(_service.fetchWallet);

  @override
  Future<DataState<WalletTopupResult>> topup({
    required double amount,
    String paymentMethod = 'qris',
  }) {
    return guard(() => _service.topup(
          amount: amount,
          paymentMethod: paymentMethod,
        ));
  }

  @override
  Future<DataState<WalletModel>> withdraw(WithdrawalDraft draft) async {
    try {
      await _service.withdraw(draft);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    // Saldo didebit saat pengajuan dibuat, jadi dompet lama sudah basi begitu
    // panggilan ini sukses.
    return guard(_service.fetchWallet);
  }
}
