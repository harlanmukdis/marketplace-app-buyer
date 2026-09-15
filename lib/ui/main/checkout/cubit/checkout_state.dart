part of 'checkout_cubit.dart';

// `PaymentMethodModel` dipakai di state ini; impornya ada di checkout_cubit.dart.

/// Status alur checkout.
@freezed
sealed class CheckoutState with _$CheckoutState {
  const CheckoutState._();

  /// Sebelum sesi dibuat, atau saat sesi sedang dibuat ulang karena alamat
  /// diganti.
  const factory CheckoutState.preparing() = CheckoutPreparing;

  const factory CheckoutState.ready({
    required CheckoutSnapshot snapshot,

    /// Metode pembayaran yang tersedia, dari `GET /payment-methods`.
    ///
    /// Ada di layar checkout — **bukan** di layar pembayaran — karena metode
    /// terikat pada transaksi saat konfirmasi; `POST /payments/{txId}/pay`
    /// mengabaikan metode yang dikirim belakangan.
    @Default(<PaymentMethodModel>[]) List<PaymentMethodModel> paymentMethods,

    /// Kode metode terpilih. Kosong berarti belum memilih.
    @Default('') String selectedPaymentMethod,

    /// Sedang mengirim pilihan kurir atau konfirmasi.
    @Default(false) bool isSubmitting,
    DataError? actionError,
  }) = CheckoutReady;

  /// Order sudah terbentuk. Layar berpindah ke pembayaran dari sini.
  const factory CheckoutState.confirmed(CheckoutConfirmResult result) =
      CheckoutConfirmed;

  const factory CheckoutState.error(DataError error) = CheckoutError;

  /// Sesi masih bisa dilanjutkan pembeli.
  bool get canInteract => switch (this) {
        CheckoutReady(:final snapshot, :final isSubmitting) =>
          !isSubmitting && snapshot.session.isStockReserved,
        _ => false,
      };

  /// Semua syarat konfirmasi terpenuhi: sesi siap **dan** metode bayar dipilih.
  bool get canPay => switch (this) {
        CheckoutReady(:final snapshot, :final selectedPaymentMethod) =>
          canInteract &&
              snapshot.session.canConfirm &&
              selectedPaymentMethod.isNotEmpty,
        _ => false,
      };
}
