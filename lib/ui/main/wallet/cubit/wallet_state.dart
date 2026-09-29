part of 'wallet_cubit.dart';

/// Status layar dompet.
@freezed
sealed class WalletState with _$WalletState {
  const WalletState._();

  const factory WalletState.loading() = WalletLoading;

  const factory WalletState.ready({
    required WalletModel wallet,

    /// Rekening tersimpan. Kegagalan memuatnya **tidak** menggagalkan layar
    /// — saldo tetap tampil, hanya penarikan yang belum bisa dipakai.
    @Default(<BankAccountModel>[]) List<BankAccountModel> bankAccounts,

    /// Kegagalan memuat [bankAccounts]. Dipisah supaya layar rekening tidak
    /// menampilkan "belum ada rekening" padahal daftarnya hanya gagal dimuat
    /// — user akan menambah rekening yang sebenarnya sudah ada.
    DataError? bankAccountsError,

    /// Penarikan terakhir berhasil diajukan — dipakai layar untuk menutup
    /// lembar penarikan dan menampilkan konfirmasi.
    @Default(false) bool withdrawalSubmitted,

    /// PIN baru saja berhasil disetel.
    @Default(false) bool pinSaved,

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
