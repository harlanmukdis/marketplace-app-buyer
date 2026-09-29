part of 'checkout_cubit.dart';

// `PaymentMethodModel` dipakai di state ini; impornya ada di checkout_cubit.dart.

/// Cara checkout ini akan dibayar.
///
/// Ditentukan **dengan mendeteksi kemampuan server**, bukan dengan flag
/// build: `GET /checkout/sessions/{id}/wallet-summary` yang menjawab berarti
/// pembayaran Xpedia Wallet tersedia (docs/22 #1); rute yang tidak dikenal
/// (404 HTML → `DataError.isRouteNotFound`) berarti backend masih memakai
/// alur lama — pemilih metode + layar pembayaran terpisah. Begitu backend
/// membangun endpointnya, build release beralih sendiri tanpa rilis ulang.
enum CheckoutPaymentMode {
  /// `wallet-summary` belum dijawab. Tombol bayar mati.
  detecting,

  /// Bayar langsung dari saldo Wallet, dengan PIN 6 digit.
  wallet,

  /// Alur lama: pilih metode, konfirmasi, lalu bayar di `PaymentScreen`.
  legacy,
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

    /// Metode pembayaran yang tersedia, dari `GET /payment-methods`.
    ///
    /// Ada di layar checkout — **bukan** di layar pembayaran — karena metode
    /// terikat pada transaksi saat konfirmasi; `POST /payments/{txId}/pay`
    /// mengabaikan metode yang dikirim belakangan. Hanya dipakai pada
    /// [CheckoutPaymentMode.legacy].
    @Default(<PaymentMethodModel>[]) List<PaymentMethodModel> paymentMethods,

    /// Kode metode terpilih. Kosong berarti belum memilih.
    @Default('') String selectedPaymentMethod,
    @Default(CheckoutPaymentMode.detecting) CheckoutPaymentMode paymentMode,

    /// Saldo vs tagihan, dari `wallet-summary`. Dipertahankan selama dimuat
    /// ulang supaya bloknya tidak berkedip setiap kurir diganti.
    WalletSummaryModel? wallet,

    /// `meta` balasan `wallet-summary` — untuk lencana "Simulasi".
    Map<String, dynamic>? walletMeta,

    /// `wallet-summary` sedang dimuat (ulang). Tombol bayar mati selama itu:
    /// ringkasan lama bisa menyatakan "cukup" untuk total yang sudah berubah.
    @Default(false) bool walletLoading,

    /// Gagal memuat `wallet-summary` karena sebab **selain** rute tak dikenal.
    DataError? walletError,

    /// Sedang mengirim pilihan kurir atau konfirmasi.
    @Default(false) bool isSubmitting,
    DataError? actionError,

    /// Penolakan PIN (`INVALID_PIN`, `TOO_MANY_REQUESTS`) — ditampilkan di
    /// dalam lembar PIN, bukan sebagai snackbar di belakangnya.
    DataError? pinError,

    /// Sedang membuat transaksi top up.
    @Default(false) bool isToppingUp,

    /// Transaksi top up yang baru dibuat dan belum dibuka layar
    /// pembayarannya. Layar membukanya lalu memanggil `topupHandled`.
    int? pendingTopupTxId,
  }) = CheckoutReady;

  /// Order sudah terbentuk. Pada alur Wallet sekaligus **sudah dibayar**
  /// (`result.paid`); pada alur lama layar berpindah ke pembayaran dari sini.
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
  /// * Wallet: sesi siap, ringkasan saldo segar, saldo cukup, PIN sudah ada.
  /// * Lama: sesi siap **dan** metode bayar dipilih.
  bool get canPay => switch (this) {
        CheckoutReady(
          :final snapshot,
          :final selectedPaymentMethod,
          :final paymentMode,
          :final wallet,
          :final walletLoading,
        ) =>
          canInteract &&
              snapshot.session.canConfirm &&
              switch (paymentMode) {
                CheckoutPaymentMode.detecting => false,
                CheckoutPaymentMode.legacy => selectedPaymentMethod.isNotEmpty,
                CheckoutPaymentMode.wallet => !walletLoading &&
                    wallet != null &&
                    wallet.canPay &&
                    wallet.pinSet,
              },
        _ => false,
      };
}
