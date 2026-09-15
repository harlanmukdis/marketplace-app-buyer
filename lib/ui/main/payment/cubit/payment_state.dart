part of 'payment_cubit.dart';

/// Status layar pembayaran.
@freezed
sealed class PaymentState with _$PaymentState {
  const PaymentState._();

  const factory PaymentState.loading() = PaymentLoading;

  const factory PaymentState.ready({
    required PaymentSnapshot snapshot,

    /// Sedang memeriksa ulang status ke server.
    @Default(false) bool isChecking,
    DataError? actionError,
  }) = PaymentReady;

  const factory PaymentState.error(DataError error) = PaymentError;

  bool get isPaid => switch (this) {
        PaymentReady(:final snapshot) => snapshot.isPaid,
        _ => false,
      };
}
