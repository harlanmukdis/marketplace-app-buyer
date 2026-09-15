/// Perilaku [WalletCubit] terhadap repository palsu.
///
/// Fokusnya pada penyaringan yang **terpaksa** dilakukan aplikasi: server
/// menolak "di bawah minimum" dan "saldo tidak cukup" dengan kode error yang
/// sama, jadi kasus pertama harus dicegat sebelum menyentuh jaringan.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';

WalletModel _wallet({double balance = 200000, double held = 0}) =>
    WalletModel(id: 1, balance: balance, heldBalance: held);

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

const _validDraft = WithdrawalDraft(
  amount: 100000,
  bankName: 'BCA',
  bankAccountNumber: '1234567890',
  bankAccountName: 'Uji Wallet',
);

class _FakeWalletRepository implements WalletRepository {
  DataState<WalletModel> walletResult = DataSuccess(_wallet());
  DataState<WalletTopupResult> topupResult = const DataSuccess(
    WalletTopupResult(paymentTransactionId: 137, amount: 100000),
  );

  final List<String> calls = [];
  double? lastTopupAmount;

  @override
  Future<DataState<WalletModel>> fetchWallet() async {
    calls.add('fetch');
    return walletResult;
  }

  @override
  Future<DataState<WalletTopupResult>> topup({
    required double amount,
    String paymentMethod = 'qris',
  }) async {
    calls.add('topup:$amount');
    lastTopupAmount = amount;
    return topupResult;
  }

  @override
  Future<DataState<WalletModel>> withdraw(WithdrawalDraft draft) async {
    calls.add('withdraw:${draft.amount}');
    return walletResult;
  }
}

void main() {
  late _FakeWalletRepository repository;

  setUp(() {
    repository = _FakeWalletRepository();
    injector.registerSingleton<WalletRepository>(repository);
  });

  tearDown(() async {
    await injector.reset();
  });

  test('load membawa saldo dan riwayat', () async {
    final cubit = WalletCubit();
    await cubit.load();

    final state = cubit.state as WalletReady;
    expect(state.wallet.balance, 200000);
    await cubit.close();
  });

  group('penarikan', () {
    test('di bawah minimum TIDAK menyentuh jaringan', () async {
      // Server menolaknya dengan WITHDRAWAL_REJECTED — kode yang sama dengan
      // saldo kurang — jadi pesannya akan salah kalau dibiarkan lewat.
      final cubit = WalletCubit();
      await cubit.load();
      repository.calls.clear();

      await cubit.withdraw(const WithdrawalDraft(
        amount: 10000,
        bankName: 'BCA',
        bankAccountNumber: '1',
        bankAccountName: 'A',
      ));

      expect(repository.calls, isEmpty);
      final state = cubit.state as WalletReady;
      expect(state.actionError?.code, ApiErrorCode.validationError);
      expect(state.actionError?.message, contains('Minimum'));
      await cubit.close();
    });

    test('field bank kosong juga dicegat sebelum dikirim', () async {
      final cubit = WalletCubit();
      await cubit.load();
      repository.calls.clear();

      await cubit.withdraw(const WithdrawalDraft(amount: 100000));

      expect(repository.calls, isEmpty);
      expect((cubit.state as WalletReady).actionError?.message,
          contains('bank_name'));
      await cubit.close();
    });

    test('draft yang sah diteruskan ke repository', () async {
      final cubit = WalletCubit();
      await cubit.load();
      repository.calls.clear();

      await cubit.withdraw(_validDraft);

      expect(repository.calls, contains('withdraw:100000.0'));
      await cubit.close();
    });

    test('penolakan server mempertahankan saldo yang sudah tampil', () async {
      final cubit = WalletCubit();
      await cubit.load();
      repository.walletResult = DataFailed(_error('WITHDRAWAL_REJECTED'));

      await cubit.withdraw(_validDraft);

      final state = cubit.state as WalletReady;
      expect(state.wallet.balance, 200000);
      expect(state.actionError?.code, 'WITHDRAWAL_REJECTED');
      expect(state.isSubmitting, isFalse);
      await cubit.close();
    });
  });

  group('topup', () {
    test('nominal nol atau negatif ditolak tanpa request', () async {
      final cubit = WalletCubit();
      await cubit.load();
      repository.calls.clear();

      await cubit.topup(amount: 0);

      expect(repository.calls, isEmpty);
      expect((cubit.state as WalletReady).actionError?.code,
          ApiErrorCode.validationError);
      await cubit.close();
    });

    test('sukses menyimpan transaksi yang menunggu dibayar', () async {
      // Saldo BELUM bertambah; yang dipegang hanya id transaksi untuk
      // diarahkan ke layar pembayaran.
      final cubit = WalletCubit();
      await cubit.load();

      await cubit.topup(amount: 100000);

      final state = cubit.state as WalletReady;
      expect(state.pendingTopup?.paymentTransactionId, 137);
      expect(state.wallet.balance, 200000, reason: 'saldo belum berubah');
      await cubit.close();
    });

    test('clearPendingTopup mencegah pengarahan berulang', () async {
      final cubit = WalletCubit();
      await cubit.load();
      await cubit.topup(amount: 100000);

      cubit.clearPendingTopup();

      expect((cubit.state as WalletReady).pendingTopup, isNull);
      await cubit.close();
    });

    test('topup kedua diabaikan selagi yang pertama berjalan', () async {
      final cubit = WalletCubit();
      await cubit.load();
      repository.calls.clear();

      final first = cubit.topup(amount: 50000);
      final second = cubit.topup(amount: 90000);
      await Future.wait([first, second]);

      expect(repository.calls.where((c) => c.startsWith('topup:')).length, 1);
      await cubit.close();
    });
  });
}
