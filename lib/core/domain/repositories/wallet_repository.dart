import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';

/// Dompet pembeli.
///
/// Tidak ada method transfer: endpointnya menuntut id internal penerima yang
/// tidak bisa ditemukan app member — lihat `WalletService`.
abstract class WalletRepository {
  Future<DataState<WalletModel>> fetchWallet();

  /// Memulai topup. Saldo **belum** bertambah; hasilnya adalah transaksi
  /// pembayaran yang harus dibayar lebih dulu.
  Future<DataState<WalletTopupResult>> topup({
    required double amount,
    String paymentMethod,
  });

  /// Mengajukan penarikan, lalu mengembalikan dompet hasil **baca ulang** —
  /// saldo langsung berkurang saat pengajuan dibuat, jadi layar harus
  /// menampilkan angka yang baru.
  Future<DataState<WalletModel>> withdraw(WithdrawalDraft draft);
}
