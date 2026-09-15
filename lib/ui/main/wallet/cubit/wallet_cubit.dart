import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'wallet_cubit.freezed.dart';
part 'wallet_state.dart';

/// Dompet pembeli: saldo, riwayat mutasi, topup, dan penarikan.
///
/// ⚠️ **Batas minimum penarikan diperiksa di sini**, bukan diserahkan ke
/// server. Alasannya bukan kecepatan: server menolak "di bawah minimum" dan
/// "saldo tidak cukup" dengan **kode error yang sama**
/// (`WITHDRAWAL_REJECTED`), sementara panduan FE melarang mencocokkan
/// `error.message`. Dengan menyaring kasus pertama lebih dulu, kode yang
/// benar-benar sampai ke user praktis hanya berarti saldo kurang — sehingga
/// pesannya bisa tepat alih-alih menebak.
class WalletCubit extends Cubit<WalletState> {
  WalletCubit()
      : _repository = injector<WalletRepository>(),
        super(const WalletState.loading());

  static WalletCubit get(BuildContext context) => BlocProvider.of(context);

  final WalletRepository _repository;

  Future<void> load() async {
    emit(const WalletState.loading());
    final result = await _repository.fetchWallet();
    if (isClosed) return;
    _apply(result);
  }

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

    if (amount <= 0) {
      emit(current.copyWith(
        actionError: const DataError(
          code: ApiErrorCode.validationError,
          message: 'Nominal topup harus lebih dari nol',
          kind: DataErrorKind.api,
        ),
      ));
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
  /// Draft yang belum lengkap atau di bawah minimum ditolak **tanpa menyentuh
  /// jaringan**, dengan pesan yang menyebut sebabnya.
  Future<void> withdraw(WithdrawalDraft draft) async {
    final current = state;
    if (current is! WalletReady || current.isSubmitting) return;

    if (!draft.meetsMinimum) {
      emit(current.copyWith(
        actionError: DataError(
          code: ApiErrorCode.validationError,
          message: 'Minimum penarikan '
              'Rp${WithdrawalDraft.minimumAmount.toStringAsFixed(0)}',
          kind: DataErrorKind.api,
        ),
      ));
      return;
    }
    if (draft.missingFields.isNotEmpty) {
      emit(current.copyWith(
        actionError: DataError(
          code: ApiErrorCode.validationError,
          message: 'Lengkapi dulu: ${draft.missingFields.join(', ')}',
          kind: DataErrorKind.api,
        ),
      ));
      return;
    }

    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result = await _repository.withdraw(draft);
    if (isClosed) return;
    _apply(result, previous: current);
  }

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

  void _apply(DataState<WalletModel> result, {WalletReady? previous}) {
    switch (result) {
      case DataSuccess(:final data):
        emit(WalletState.ready(wallet: data));
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
