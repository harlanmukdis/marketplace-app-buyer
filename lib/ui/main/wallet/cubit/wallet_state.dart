part of 'wallet_cubit.dart';

/// Status layar dompet.
@freezed
sealed class WalletState with _$WalletState {
  const WalletState._();

  const factory WalletState.loading() = WalletLoading;

  const factory WalletState.ready({
    required WalletModel wallet,

    /// Sedang mengirim topup atau penarikan.
    @Default(false) bool isSubmitting,
    DataError? actionError,

    /// Topup yang baru dibuat dan menunggu dibayar. Layar memakainya untuk
    /// mengarahkan ke halaman pembayaran.
    WalletTopupResult? pendingTopup,
  }) = WalletReady;

  const factory WalletState.error(DataError error) = WalletError;

  bool get canAct => switch (this) {
        WalletReady(:final isSubmitting) => !isSubmitting,
        _ => false,
      };
}
