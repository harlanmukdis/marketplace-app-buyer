import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

part 'wallet_cubit.freezed.dart';
part 'wallet_state.dart';

/// Dompet pembeli: saldo, riwayat mutasi, topup, dan penarikan.
///
/// ⚠️ **Penarikan divalidasi di sini sebelum menyentuh jaringan** —
/// minimum, rekening, format PIN, dan kecukupan saldo. Alasannya bukan
/// kecepatan: server menolak kelimanya dengan **kode yang sama**
/// (`WITHDRAWAL_REJECTED`), sementara panduan FE melarang mencocokkan
/// `error.message`. Dan setiap percobaan yang sampai ke server **ikut
/// menghabiskan kuota PIN** (5 per 15 menit, benar atau salah), jadi
/// kesalahan yang bisa ditangkap di sini tidak boleh dibiarkan lolos.
/// Yang tersisa dari server praktis hanya "PIN salah / belum disetel".
class WalletCubit extends Cubit<WalletState> {
  WalletCubit()
      : _repository = injector<WalletRepository>(),
        super(const WalletState.loading());

  static WalletCubit get(BuildContext context) => BlocProvider.of(context);

  final WalletRepository _repository;

  /// Minimum topup dari blueprint (docs/22 #12). ⚠️ Server **belum**
  /// menegakkannya, jadi di sini satu-satunya penjaga.
  static const double minimumTopup = 10000;

  Future<void> load() async {
    emit(const WalletState.loading());
    final results = await Future.wait([
      _repository.fetchWallet(),
      _repository.fetchBankAccounts(),
    ]);
    if (isClosed) return;
    final wallet = results[0] as DataState<WalletModel>;
    final accounts = results[1] as DataState<List<BankAccountModel>>;
    _apply(
      wallet,
      accounts: _accountsOf(accounts),
      accountsError: accounts is DataFailed<List<BankAccountModel>> ? accounts.error : null,
    );
  }

  List<BankAccountModel> _accountsOf(DataState<List<BankAccountModel>> result) =>
      result is DataSuccess<List<BankAccountModel>> ? result.data : const [];

  /// Memulai topup.
  ///
  /// Saldo **tidak** langsung bertambah — hasilnya transaksi pembayaran yang
  /// harus dibayar dulu. Layar mengarahkan ke halaman pembayaran memakai
  /// [WalletReady.pendingTopup].
  Future<void> topup({
    required double amount,
    String paymentMethod = 'qris',
  }) async {
    final current = state;
    if (current is! WalletReady || current.isSubmitting) return;

    if (amount < minimumTopup) {
      emit(current.copyWith(actionError: _validation('Minimum top up Rp 10.000')));
      return;
    }

    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result =
        await _repository.topup(amount: amount, paymentMethod: paymentMethod);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(current.copyWith(isSubmitting: false, pendingTopup: data));
      case DataFailed(:final error):
        emit(current.copyWith(isSubmitting: false, actionError: error));
      case DataEmpty():
      case DataLoading():
        emit(current.copyWith(isSubmitting: false));
    }
  }

  /// Mengajukan penarikan dana.
  ///
  /// Draft yang tidak lolos validasi ditolak **tanpa menyentuh jaringan** —
  /// lihat catatan kelas soal kuota PIN.
  Future<void> withdraw(WithdrawalDraft draft) async {
    final current = state;
    if (current is! WalletReady || current.isSubmitting) return;

    final problem = switch (draft) {
      _ when !draft.meetsMinimum => 'Minimum penarikan Rp 50.000',
      // Saldo **tersedia**, bukan saldo total: bagian yang ditahan (mis.
      // penarikan sebelumnya yang masih diproses) tidak bisa ditarik lagi.
      _ when draft.amount > current.wallet.availableBalance =>
        'Saldo tidak mencukupi',
      _ when draft.bankAccountId == null => 'Pilih rekening tujuan',
      _ when !draft.hasValidPin => 'PIN harus 6 digit angka',
      _ => null,
    };
    if (problem != null) {
      emit(current.copyWith(actionError: _validation(problem)));
      return;
    }

    emit(current.copyWith(
        isSubmitting: true, actionError: null, withdrawalSubmitted: false));
    final result = await _repository.withdraw(draft);
    if (isClosed) return;
    _apply(result,
        previous: current,
        accounts: current.bankAccounts,
        withdrawalSubmitted: result is DataSuccess);
  }

  /// Menyetel PIN (pertama kali) atau menggantinya ([currentPin] wajib).
  Future<void> setPin({required String pin, String? currentPin}) async {
    final current = state;
    if (current is! WalletReady || current.isSubmitting) return;
    final sixDigits = RegExp(r'^\d{6}$');
    final problem = switch (currentPin) {
      _ when !sixDigits.hasMatch(pin) => 'PIN harus 6 digit angka',
      final old? when !sixDigits.hasMatch(old) => 'PIN lama harus 6 digit angka',
      final old? when old == pin => 'PIN baru harus berbeda dari PIN lama',
      _ => null,
    };
    if (problem != null) {
      emit(current.copyWith(actionError: _validation(problem)));
      return;
    }
    emit(current.copyWith(isSubmitting: true, actionError: null, pinSaved: false));
    final result = await _repository.setWithdrawalPin(pin: pin, currentPin: currentPin);
    if (isClosed) return;
    emit(switch (result) {
      DataFailed(:final error) => current.copyWith(isSubmitting: false, actionError: error),
      _ => current.copyWith(isSubmitting: false, pinSaved: true),
    });
  }

  Future<void> addBankAccount({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
  }) async {
    final current = state;
    if (current is! WalletReady || current.isSubmitting) return;
    if (current.bankAccounts.length >= BankAccountModel.maxAccounts) {
      emit(current.copyWith(actionError: _validation('Maksimal 3 rekening tersimpan')));
      return;
    }
    if ([bankName, accountNumber, accountHolderName].any((v) => v.trim().isEmpty)) {
      emit(current.copyWith(actionError: _validation('Lengkapi data rekening')));
      return;
    }
    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result = await _repository.addBankAccount(
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
    );
    if (isClosed) return;
    _applyAccounts(current, result);
  }

  /// Memuat ulang rekening saja, untuk layar rekening yang daftarnya gagal
  /// dimuat — saldo tidak perlu ikut ditembak lagi.
  Future<void> reloadBankAccounts() async {
    final current = state;
    if (current is! WalletReady || current.isSubmitting) return;
    emit(current.copyWith(isSubmitting: true));
    final result = await _repository.fetchBankAccounts();
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => current.copyWith(
          isSubmitting: false, bankAccounts: data, bankAccountsError: null),
      DataFailed(:final error) =>
        current.copyWith(isSubmitting: false, bankAccountsError: error),
      _ => current.copyWith(
          isSubmitting: false, bankAccounts: const [], bankAccountsError: null),
    });
  }

  Future<void> deleteBankAccount(int id) async {
    final current = state;
    if (current is! WalletReady || current.isSubmitting) return;
    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result = await _repository.deleteBankAccount(id);
    if (isClosed) return;
    _applyAccounts(current, result);
  }

  void _applyAccounts(WalletReady current, DataState<List<BankAccountModel>> result) {
    emit(switch (result) {
      DataSuccess(:final data) => current.copyWith(
          isSubmitting: false, bankAccounts: data, bankAccountsError: null),
      DataEmpty() => current.copyWith(
          isSubmitting: false, bankAccounts: const [], bankAccountsError: null),
      DataFailed(:final error) => current.copyWith(isSubmitting: false, actionError: error),
      DataLoading() => current.copyWith(isSubmitting: false),
    });
  }

  void acknowledgeWithdrawal() {
    final current = state;
    if (current is WalletReady && (current.withdrawalSubmitted || current.pinSaved)) {
      emit(current.copyWith(withdrawalSubmitted: false, pinSaved: false));
    }
  }

  /// Penolakan lokal memakai [kLocalValidationCode] — satu-satunya kode yang
  /// `message`-nya boleh ditampilkan, karena teksnya ditulis di sini.
  static DataError _validation(String message) => localValidationError(message);

  /// Membuang penanda topup setelah layar mengarahkan ke pembayaran, supaya
  /// tidak mengarahkan dua kali pada rebuild berikutnya.
  void clearPendingTopup() {
    final current = state;
    if (current is! WalletReady || current.pendingTopup == null) return;
    emit(current.copyWith(pendingTopup: null));
  }

  void clearActionError() {
    final current = state;
    if (current is! WalletReady || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  void _apply(
    DataState<WalletModel> result, {
    WalletReady? previous,
    List<BankAccountModel> accounts = const [],
    DataError? accountsError,
    bool withdrawalSubmitted = false,
  }) {
    switch (result) {
      case DataSuccess(:final data):
        emit(WalletState.ready(
          wallet: data,
          bankAccounts: accounts,
          bankAccountsError: accountsError ?? previous?.bankAccountsError,
          withdrawalSubmitted: withdrawalSubmitted,
        ));
      case DataFailed(:final error):
        if (previous != null) {
          // Gagal menarik tidak boleh membuang saldo yang sudah tampil.
          emit(previous.copyWith(isSubmitting: false, actionError: error));
        } else {
          emit(WalletState.error(error));
        }
      case DataEmpty():
      case DataLoading():
        break;
    }
  }
}
