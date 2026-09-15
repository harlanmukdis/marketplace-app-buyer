part of 'checkout_cubit.dart';

/// Status alur checkout.
@freezed
sealed class CheckoutState with _$CheckoutState {
  const CheckoutState._();

  /// Sebelum sesi dibuat, atau saat sesi sedang dibuat ulang karena alamat
  /// diganti.
  const factory CheckoutState.preparing() = CheckoutPreparing;

  const factory CheckoutState.ready({
    required CheckoutSnapshot snapshot,

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
}
