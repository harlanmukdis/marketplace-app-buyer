import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/repositories/payment_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'payment_cubit.freezed.dart';
part 'payment_state.dart';

/// Layar pembayaran: menampilkan instruksi (QRIS / VA) dan status transaksi.
///
/// Tidak ada polling otomatis. Pembayaran diselesaikan di aplikasi lain, dan
/// status barunya masuk lewat webhook penyedia — yang bisa telat beberapa
/// detik sampai beberapa menit. Menembak terus-menerus hanya membebani server
/// tanpa mempercepat apa pun, jadi user yang menekan "Cek status".
class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.transactionId)
      : _repository = injector<PaymentRepository>(),
        super(const PaymentState.loading());

  static PaymentCubit get(BuildContext context) => BlocProvider.of(context);

  final int transactionId;
  final PaymentRepository _repository;

  Future<void> load() async {
    emit(const PaymentState.loading());
    final result = await _repository.load(transactionId);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(PaymentState.ready(snapshot: data));
      case DataFailed(:final error):
        emit(PaymentState.error(error));
      case DataEmpty():
      case DataLoading():
        break;
    }
  }

  /// Memeriksa ulang status transaksi.
  ///
  /// Sengaja **tidak** meminta instruksi bayar lagi: instruksinya (nomor VA,
  /// QR) tidak berubah, dan memintanya ulang hanya menambah request.
  Future<void> checkStatus() async {
    final current = state;
    if (current is! PaymentReady || current.isChecking) return;

    emit(current.copyWith(isChecking: true, actionError: null));
    final result = await _repository.refreshStatus(transactionId);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        // Instruksi lama dipertahankan — `refreshStatus` sengaja tidak
        // mengambilnya, jadi tanpa ini QR/VA akan hilang dari layar.
        emit(PaymentState.ready(
          snapshot: PaymentSnapshot(
            payment: data.payment,
            instruction: current.snapshot.instruction,
          ),
        ));
      case DataFailed(:final error):
        emit(current.copyWith(isChecking: false, actionError: error));
      case DataEmpty():
      case DataLoading():
        emit(current.copyWith(isChecking: false));
    }
  }

  void clearActionError() {
    final current = state;
    if (current is! PaymentReady || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }
}
