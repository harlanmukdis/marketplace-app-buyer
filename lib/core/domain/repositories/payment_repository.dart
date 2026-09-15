import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';

/// Transaksi pembayaran beserta instruksi bayarnya.
///
/// Digabung jadi satu hasil karena layar pembayaran selalu butuh keduanya:
/// status transaksi (sudah dibayar atau belum, sisa waktu) dan instruksinya
/// (QR atau nomor VA).
class PaymentSnapshot {
  const PaymentSnapshot({required this.payment, this.instruction});

  final PaymentModel payment;

  /// `null` kalau instruksi belum diminta atau gagal diambil. Status transaksi
  /// tetap berguna tanpa itu — mis. untuk menampilkan "sudah dibayar".
  final PaymentInstructionModel? instruction;

  bool get isPaid => payment.isPaid;
}

abstract class PaymentRepository {
  /// Daftar metode pembayaran aktif.
  ///
  /// Dipakai layar **checkout**, bukan layar pembayaran: metode dipilih saat
  /// konfirmasi checkout, dan `POST /payments/{txId}/pay` mengabaikan pilihan
  /// yang dikirim belakangan.
  Future<DataState<List<PaymentMethodModel>>> fetchMethods();

  /// Memuat transaksi sekaligus meminta instruksi bayarnya.
  Future<DataState<PaymentSnapshot>> load(int txId);

  /// Membaca ulang status transaksi saja — untuk tombol "cek status" setelah
  /// user membayar di aplikasi lain.
  Future<DataState<PaymentSnapshot>> refreshStatus(int txId);
}
