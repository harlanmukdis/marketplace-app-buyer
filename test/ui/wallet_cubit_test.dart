/// Perilaku [WalletCubit] terhadap repository palsu.
///
/// Fokusnya pada penyaringan yang **terpaksa** dilakukan aplikasi: server
/// menolak setiap penarikan yang salah dengan kode yang sama
/// (`WITHDRAWAL_REJECTED`), dan setiap percobaan yang sampai ke server
/// menghabiskan kuota PIN (5 per 15 menit, PIN benar pun dihitung). Jadi
/// yang bisa dicegat lebih dulu wajib dicegat tanpa menyentuh jaringan.
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

BankAccountModel _account(int id) => BankAccountModel(
      id: id,
      bankName: 'BCA',
      accountNumber: '12345678$id',
      accountHolderName: 'Uji Wallet',
    );

const _validDraft = WithdrawalDraft(amount: 100000, bankAccountId: 1, pin: '123456');

class _FakeWalletRepository implements WalletRepository {
  DataState<WalletModel> walletResult = DataSuccess(_wallet());
  DataState<WalletTopupResult> topupResult = const DataSuccess(
    WalletTopupResult(paymentTransactionId: 137, amount: 100000),
  );
  DataState<void> pinResult = const DataSuccess(null);
  List<BankAccountModel> accounts = [_account(1)];
  DataError? accountsError;
  DataError? addError;

  final List<String> calls = [];
  ({String pin, String? currentPin})? lastPin;

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
    return topupResult;
  }

  @override
  Future<DataState<WalletModel>> withdraw(WithdrawalDraft draft) async {
    calls.add('withdraw:${draft.amount}');
    return walletResult;
  }

  @override
  Future<DataState<void>> setWithdrawalPin({required String pin, String? currentPin}) async {
    calls.add('pin');
    lastPin = (pin: pin, currentPin: currentPin);
    return pinResult;
  }

  DataState<List<BankAccountModel>> _list() {
    if (accountsError != null) return DataFailed(accountsError!);
    return accounts.isEmpty ? const DataEmpty() : DataSuccess([...accounts]);
  }

  @override
  Future<DataState<List<BankAccountModel>>> fetchBankAccounts() async {
    calls.add('accounts');
    return _list();
  }

  @override
  Future<DataState<List<BankAccountModel>>> addBankAccount({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
  }) async {
    calls.add('add:$bankName');
    if (addError != null) return DataFailed(addError!);
    accounts = [...accounts, _account(accounts.length + 1)];
    return _list();
  }

  @override
  Future<DataState<List<BankAccountModel>>> deleteBankAccount(int id) async {
    calls.add('delete:$id');
    accounts = accounts.where((a) => a.id != id).toList();
    return _list();
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

  Future<WalletCubit> loaded() async {
    final cubit = WalletCubit();
    await cubit.load();
    repository.calls.clear();
    return cubit;
  }

  WalletReady ready(WalletCubit cubit) => cubit.state as WalletReady;

  group('load', () {
    test('membawa saldo dan rekening tersimpan sekaligus', () async {
      final cubit = WalletCubit();
      await cubit.load();

      expect(repository.calls, containsAll(['fetch', 'accounts']));
      expect(ready(cubit).wallet.balance, 200000);
      expect(ready(cubit).bankAccounts.map((a) => a.id), [1]);
      await cubit.close();
    });

    test('rekening gagal dimuat tidak menggagalkan layar, tapi ditandai', () async {
      // Tanpa tanda ini layar rekening akan berkata "belum ada rekening"
      // padahal daftarnya hanya gagal dimuat.
      repository.accountsError = _error(ClientErrorCode.network);
      final cubit = WalletCubit();
      await cubit.load();

      expect(ready(cubit).wallet.balance, 200000);
      expect(ready(cubit).bankAccounts, isEmpty);
      expect(ready(cubit).bankAccountsError?.code, ClientErrorCode.network);
      await cubit.close();
    });

    test('rekening kosong bukan error', () async {
      repository.accounts = [];
      final cubit = WalletCubit();
      await cubit.load();

      expect(ready(cubit).bankAccounts, isEmpty);
      expect(ready(cubit).bankAccountsError, isNull);
      await cubit.close();
    });

    test('reloadBankAccounts memulihkan daftar yang gagal', () async {
      repository.accountsError = _error(ClientErrorCode.network);
      final cubit = await loaded();
      repository.accountsError = null;

      await cubit.reloadBankAccounts();

      expect(repository.calls, ['accounts'], reason: 'saldo tidak ikut ditembak');
      expect(ready(cubit).bankAccounts, hasLength(1));
      expect(ready(cubit).bankAccountsError, isNull);
      await cubit.close();
    });
  });

  group('penarikan — urutan validasi lokal', () {
    Future<String?> rejection(WithdrawalDraft draft, {double balance = 200000}) async {
      repository.walletResult = DataSuccess(_wallet(balance: balance));
      final cubit = await loaded();
      await cubit.withdraw(draft);
      expect(repository.calls, isEmpty, reason: 'tidak boleh menyentuh jaringan');
      final error = ready(cubit).actionError;
      await cubit.close();
      if (error == null) return null;
      expect(error.code, ClientErrorCode.localValidation);
      return error.message;
    }

    test('minimum diperiksa pertama', () async {
      // Semua syarat lain juga salah; yang disebut harus minimumnya.
      expect(
        await rejection(const WithdrawalDraft(amount: 10000), balance: 0),
        contains('Minimum'),
      );
    });

    test('lalu kecukupan saldo', () async {
      expect(
        await rejection(const WithdrawalDraft(amount: 300000), balance: 200000),
        'Saldo tidak mencukupi',
      );
    });

    test('saldo yang ditahan tidak ikut dihitung', () async {
      repository.walletResult = DataSuccess(_wallet(balance: 200000, held: 150000));
      final cubit = await loaded();
      await cubit.withdraw(_validDraft);

      expect(repository.calls, isEmpty);
      expect(ready(cubit).actionError?.message, 'Saldo tidak mencukupi');
      await cubit.close();
    });

    test('lalu rekening tujuan', () async {
      expect(
        await rejection(const WithdrawalDraft(amount: 100000, pin: '123456')),
        'Pilih rekening tujuan',
      );
    });

    test('terakhir format PIN', () async {
      expect(
        await rejection(const WithdrawalDraft(amount: 100000, bankAccountId: 1, pin: '12')),
        contains('PIN'),
      );
    });
  });

  group('penarikan — ke server', () {
    test('draft yang sah diteruskan dan ditandai terkirim', () async {
      final cubit = await loaded();

      await cubit.withdraw(_validDraft);

      expect(repository.calls, ['withdraw:100000.0']);
      expect(ready(cubit).withdrawalSubmitted, isTrue);
      expect(ready(cubit).bankAccounts, hasLength(1),
          reason: 'rekening tidak hilang setelah saldo dibaca ulang');
      await cubit.close();
    });

    test('acknowledgeWithdrawal membuang tandanya', () async {
      final cubit = await loaded();
      await cubit.withdraw(_validDraft);

      cubit.acknowledgeWithdrawal();

      expect(ready(cubit).withdrawalSubmitted, isFalse);
      await cubit.close();
    });

    test('penolakan server mempertahankan saldo dan rekening', () async {
      final cubit = await loaded();
      repository.walletResult = DataFailed(_error(ApiErrorCode.withdrawalRejected));

      await cubit.withdraw(_validDraft);

      final state = ready(cubit);
      expect(state.wallet.balance, 200000);
      expect(state.bankAccounts, hasLength(1));
      expect(state.actionError?.code, ApiErrorCode.withdrawalRejected);
      expect(state.withdrawalSubmitted, isFalse);
      expect(state.isSubmitting, isFalse);
      await cubit.close();
    });
  });

  group('PIN', () {
    test('PIN baru dikirim tanpa PIN lama', () async {
      final cubit = await loaded();

      await cubit.setPin(pin: '482913');

      expect(repository.lastPin, (pin: '482913', currentPin: null));
      expect(ready(cubit).pinSaved, isTrue);
      await cubit.close();
    });

    test('mengganti PIN meneruskan PIN lama', () async {
      final cubit = await loaded();

      await cubit.setPin(pin: '482913', currentPin: '111111');

      expect(repository.lastPin, (pin: '482913', currentPin: '111111'));
      await cubit.close();
    });

    test('format salah ditolak tanpa request', () async {
      final cubit = await loaded();

      await cubit.setPin(pin: '12345');
      expect(ready(cubit).actionError?.code, ClientErrorCode.localValidation);
      cubit.clearActionError();

      await cubit.setPin(pin: '123456', currentPin: '12');
      expect(ready(cubit).actionError?.message, contains('PIN lama'));
      cubit.clearActionError();

      await cubit.setPin(pin: '123456', currentPin: '123456');
      expect(ready(cubit).actionError?.message, contains('berbeda'));

      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('PIN lama salah dari server tidak menandai tersimpan', () async {
      repository.pinResult = DataFailed(_error(ApiErrorCode.validationError));
      final cubit = await loaded();

      await cubit.setPin(pin: '482913', currentPin: '000000');

      expect(ready(cubit).pinSaved, isFalse);
      expect(ready(cubit).actionError?.code, ApiErrorCode.validationError);
      await cubit.close();
    });
  });

  group('rekening bank', () {
    test('menambah rekening mengganti daftar dengan hasil baca ulang', () async {
      final cubit = await loaded();

      await cubit.addBankAccount(
          bankName: 'Mandiri', accountNumber: '999', accountHolderName: 'Uji Wallet');

      expect(repository.calls, ['add:Mandiri']);
      expect(ready(cubit).bankAccounts, hasLength(2));
      await cubit.close();
    });

    test('rekening keempat ditolak tanpa request', () async {
      repository.accounts = [_account(1), _account(2), _account(3)];
      final cubit = await loaded();

      await cubit.addBankAccount(
          bankName: 'BNI', accountNumber: '1', accountHolderName: 'Uji Wallet');

      expect(repository.calls, isEmpty);
      expect(ready(cubit).actionError?.message, contains('Maksimal 3'));
      await cubit.close();
    });

    test('field kosong ditolak tanpa request', () async {
      final cubit = await loaded();

      await cubit.addBankAccount(bankName: 'BNI', accountNumber: ' ', accountHolderName: 'A');

      expect(repository.calls, isEmpty);
      expect(ready(cubit).actionError?.code, ClientErrorCode.localValidation);
      await cubit.close();
    });

    test('penolakan nama pemilik mempertahankan daftar lama', () async {
      repository.addError = _error(ApiErrorCode.validationError);
      final cubit = await loaded();

      await cubit.addBankAccount(
          bankName: 'BNI', accountNumber: '1', accountHolderName: 'Orang Lain');

      expect(ready(cubit).bankAccounts, hasLength(1));
      expect(ready(cubit).actionError?.code, ApiErrorCode.validationError);
      await cubit.close();
    });

    test('menghapus rekening terakhir menghasilkan daftar kosong', () async {
      final cubit = await loaded();

      await cubit.deleteBankAccount(1);

      expect(repository.calls, ['delete:1']);
      expect(ready(cubit).bankAccounts, isEmpty);
      expect(ready(cubit).bankAccountsError, isNull);
      await cubit.close();
    });
  });

  group('topup', () {
    test('di bawah minimum Rp 10.000 ditolak tanpa request', () async {
      // Server belum menegakkan minimum ini — cubit satu-satunya penjaga.
      final cubit = await loaded();

      await cubit.topup(amount: 9999);

      expect(repository.calls, isEmpty);
      expect(ready(cubit).actionError?.code, ClientErrorCode.localValidation);
      expect(ready(cubit).actionError?.message, contains('10.000'));
      await cubit.close();
    });

    test('tepat Rp 10.000 diteruskan', () async {
      final cubit = await loaded();

      await cubit.topup(amount: WalletCubit.minimumTopup);

      expect(repository.calls, ['topup:10000.0']);
      await cubit.close();
    });

    test('sukses menyimpan transaksi yang menunggu dibayar', () async {
      // Saldo BELUM bertambah; yang dipegang hanya id transaksi untuk
      // diarahkan ke layar pembayaran.
      final cubit = await loaded();

      await cubit.topup(amount: 100000);

      expect(ready(cubit).pendingTopup?.paymentTransactionId, 137);
      expect(ready(cubit).wallet.balance, 200000, reason: 'saldo belum berubah');
      await cubit.close();
    });

    test('clearPendingTopup mencegah pengarahan berulang', () async {
      final cubit = await loaded();
      await cubit.topup(amount: 100000);

      cubit.clearPendingTopup();

      expect(ready(cubit).pendingTopup, isNull);
      await cubit.close();
    });

    test('topup kedua diabaikan selagi yang pertama berjalan', () async {
      final cubit = await loaded();

      final first = cubit.topup(amount: 50000);
      final second = cubit.topup(amount: 90000);
      await Future.wait([first, second]);

      expect(repository.calls.where((c) => c.startsWith('topup:')).length, 1);
      await cubit.close();
    });
  });
}
