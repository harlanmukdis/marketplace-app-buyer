part of 'checkout_cubit.dart';

/// Kesiapan pembayaran checkout ini.
///
/// Checkout wallet-only sejak backend `d9ecb33`; yang tersisa hanya apakah
/// ringkasan saldo sudah pernah termuat.
enum CheckoutPaymentMode {
  /// Ringkasan Wallet belum pernah termuat. Tombol bayar mati.
  detecting,

  /// Bayar langsung dari saldo Wallet, dengan PIN 6 digit.
  wallet,
}

/// Status alur checkout.
@freezed
sealed class CheckoutState with _$CheckoutState {
  const CheckoutState._();

  /// Sebelum sesi dibuat, atau saat sesi sedang dibuat ulang karena alamat
  /// diganti.
  const factory CheckoutState.preparing() = CheckoutPreparing;

  const factory CheckoutState.ready({
    required CheckoutSnapshot snapshot,

    @Default(CheckoutPaymentMode.detecting) CheckoutPaymentMode paymentMode,

    /// Saldo vs tagihan (`GET /wallet` + `grand_total` sesi). Dipertahankan selama dimuat
    /// ulang supaya bloknya tidak berkedip setiap kurir diganti.
    WalletSummaryModel? wallet,

    /// `meta` ringkasan Wallet — untuk lencana "Simulasi" (kini selalu kosong).
    Map<String, dynamic>? walletMeta,

    /// Ringkasan Wallet sedang dimuat (ulang). Tombol bayar mati selama itu:
    /// ringkasan lama bisa menyatakan "cukup" untuk total yang sudah berubah.
    @Default(false) bool walletLoading,

    /// Gagal memuat ringkasan Wallet.
    DataError? walletError,

    /// Sedang mengirim pilihan kurir atau konfirmasi.
    @Default(false) bool isSubmitting,
    DataError? actionError,

    /// Penolakan PIN (`INVALID_PIN` terjemahan repository, `TOO_MANY_REQUESTS`) — ditampilkan di
    /// dalam lembar PIN, bukan sebagai snackbar di belakangnya.
    DataError? pinError,

    /// Sedang membuat transaksi top up.
    @Default(false) bool isToppingUp,

    /// Transaksi top up yang baru dibuat dan belum dibuka layar
    /// pembayarannya. Layar membukanya lalu memanggil `topupHandled`.
    int? pendingTopupTxId,
  }) = CheckoutReady;

  /// Order sudah terbentuk **dan sudah dibayar** dari saldo Wallet.
  const factory CheckoutState.confirmed(
    CheckoutConfirmResult result, {
    Map<String, dynamic>? meta,
  }) = CheckoutConfirmed;

  const factory CheckoutState.error(DataError error) = CheckoutError;

  /// Sesi masih bisa dilanjutkan pembeli.
  bool get canInteract => switch (this) {
        CheckoutReady(:final snapshot, :final isSubmitting) =>
          !isSubmitting && snapshot.session.isStockReserved,
        _ => false,
      };

  /// Semua syarat membayar terpenuhi.
  ///
  /// Sesi siap, ringkasan saldo segar, saldo cukup, PIN (dianggap) ada.
  bool get canPay => switch (this) {
        CheckoutReady(
          :final snapshot,
          :final paymentMode,
          :final wallet,
          :final walletLoading,
        ) =>
          canInteract &&
              snapshot.session.canConfirm &&
              switch (paymentMode) {
                CheckoutPaymentMode.detecting => false,
                CheckoutPaymentMode.wallet => !walletLoading &&
                    wallet != null &&
                    wallet.canPay &&
                    wallet.pinSet,
              },
        _ => false,
      };
}
