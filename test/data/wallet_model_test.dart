/// Parsing model dompet terhadap bentuk JSON dari server.
///
/// ⚠️ **Bentuk `transactions` diturunkan dari skema, bukan dari respons yang
/// diamati.** `get_user_wallet` melakukan `SELECT *` pada tabel
/// `wallet_transactions`, jadi kolomnya = field responsnya — tapi menghasilkan
/// satu baris mutasi di dev **tidak mungkin**: satu-satunya jalan adalah
/// callback penyedia pembayaran, yang menuntut HMAC dengan
/// `WEBHOOK_SIGNING_SECRET` yang tidak ada di repo. Test integrasi karena itu
/// hanya memastikan dompet kosong dan penolakan penarikan.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';

void main() {
  group('WalletModel', () {
    /// Respons `GET /wallet` untuk akun baru, apa adanya.
    const json = <String, dynamic>{
      'id': '1',
      'user_id': '409',
      'balance': '0.00',
      'held_balance': '0.00',
      'status': 'active',
      'updated_at': '2026-09-15 22:46:50',
      'transactions': [],
    };

    test('dompet akun baru terbaca sebagai saldo nol, bukan error', () {
      // Dompet dibuat otomatis saat pertama dibaca — tidak pernah 404.
      final wallet = WalletModel.fromJson(json);
      expect(wallet.balance, 0);
      expect(wallet.isActive, isTrue);
      expect(wallet.hasHistory, isFalse);
    });

    test('saldo tersedia dikurangi saldo yang ditahan', () {
      final wallet = WalletModel.fromJson(
          {...json, 'balance': '250000.00', 'held_balance': '50000.00'});
      expect(wallet.availableBalance, 200000);
    });

    test('saldo tertahan melebihi saldo tidak menghasilkan angka negatif', () {
      final wallet = WalletModel.fromJson(
          {...json, 'balance': '10000.00', 'held_balance': '50000.00'});
      expect(wallet.availableBalance, 0);
    });
  });

  group('WalletTransactionModel — arah mutasi', () {
    WalletTransactionModel tx(String type) =>
        WalletTransactionModel.fromJson({
          'id': '1',
          'type': type,
          // Kolomnya SELALU positif di database; arah ditentukan `type`.
          'amount': '75000.00',
          'balance_before': '100000.00',
          'balance_after': '25000.00',
          'created_at': '2026-09-15 22:50:00',
        });

    test('penarikan dan transfer keluar mengurangi saldo', () {
      // Kalau ini salah, penarikan akan tampil sebagai pemasukan.
      expect(tx('withdraw').isCredit, isFalse);
      expect(tx('transfer_out').isCredit, isFalse);
      expect(tx('fee').isCredit, isFalse);
    });

    test('pembayaran pesanan (checkout wallet-only) mengurangi saldo', () {
      // Jenis baru sejak backend d9ecb33. Sebelum dipetakan, ia jatuh ke
      // `unknown` yang dianggap kredit — setiap belanja tampil sebagai
      // pemasukan.
      expect(tx('order_payment').type, WalletTxType.orderPayment);
      expect(tx('order_payment').isCredit, isFalse);
      expect(tx('order_payment').signedAmount, -75000);
      expect(tx('order_payment').label, 'Pembayaran pesanan');
    });

    test('topup, cashback, dan refund menambah saldo', () {
      expect(tx('topup').isCredit, isTrue);
      expect(tx('cashback').isCredit, isTrue);
      expect(tx('refund').isCredit, isTrue);
      expect(tx('transfer_in').isCredit, isTrue);
    });

    test('nilai bertanda diturunkan dari jenis, bukan dari amount', () {
      expect(tx('topup').signedAmount, 75000);
      expect(tx('withdraw').signedAmount, -75000);
      // `amount` sendiri tetap positif apa pun jenisnya.
      expect(tx('withdraw').amount, 75000);
    });

    test('jenis tak dikenal dianggap kredit dan memakai kodenya sebagai label',
        () {
      // Salah tanda pada uang lebih merugikan daripada label kurang spesifik;
      // balance_after tetap menunjukkan kebenarannya.
      final unknown = tx('jenis_baru');
      expect(unknown.type, WalletTxType.unknown);
      expect(unknown.isCredit, isTrue);
      expect(unknown.label, 'jenis_baru');
    });

    test('label jenis yang dikenal dalam bahasa Indonesia', () {
      expect(tx('topup').label, 'Isi saldo');
      expect(tx('withdraw').label, 'Penarikan');
    });

    test('balance_after terbaca — itu sumber kebenaran saldo', () {
      expect(tx('withdraw').balanceAfter, 25000);
      expect(tx('withdraw').balanceBefore, 100000);
    });
  });

  group('WalletTopupResult', () {
    test('membawa id transaksi pembayaran yang dipakai layar pembayaran', () {
      // Topup memakai ulang alur /payments/{txId}/pay yang sama dengan
      // checkout; saldo belum bertambah di titik ini.
      final result = WalletTopupResult.fromJson(const {
        'payment_transaction_id': 137,
        'topup_reference': '1a38429a-293b-4df3-8482-957c6265c811',
        'amount': 100000,
      });

      expect(result.paymentTransactionId, 137);
      expect(result.amount, 100000);
      expect(result.reference, isNotEmpty);
    });
  });

  group('BankAccountModel', () {
    /// Baris `GET /me/bank-accounts` — angka sebagai string, seperti tabel
    /// lain di API ini.
    const json = <String, dynamic>{
      'id': '7',
      'user_id': '409',
      'bank_name': 'BCA',
      'account_number': '1234567890',
      'account_holder_name': 'Uji Wallet',
      'created_at': '2026-09-28 10:00:00',
    };

    test('terbaca dari bentuk server', () {
      final account = BankAccountModel.fromJson(json);
      expect(account.id, 7);
      expect(account.bankName, 'BCA');
      expect(account.accountHolderName, 'Uji Wallet');
    });

    test('nomor rekening ditampilkan tersamar, hanya 4 digit terakhir', () {
      expect(BankAccountModel.fromJson(json).maskedNumber, '•••• 7890');
    });

    test('nomor pendek tidak disamarkan jadi kosong', () {
      expect(
          BankAccountModel.fromJson({...json, 'account_number': '123'}).maskedNumber,
          '123');
    });
  });

  group('WithdrawalDraft', () {
    WithdrawalDraft draft(double amount, {int? account = 7, String pin = '123456'}) =>
        WithdrawalDraft(amount: amount, bankAccountId: account, pin: pin);

    test('di bawah minimum ditolak sebelum menyentuh jaringan', () {
      // Server menolaknya dengan kode yang SAMA seperti "saldo tidak cukup",
      // jadi kasus ini harus disaring lebih dulu supaya pesannya tepat.
      expect(draft(10000).meetsMinimum, isFalse);
      expect(draft(10000).isValid, isFalse);
    });

    test('tepat di batas minimum diterima', () {
      expect(draft(WithdrawalDraft.minimumAmount).meetsMinimum, isTrue);
      expect(draft(WithdrawalDraft.minimumAmount).isValid, isTrue);
    });

    test('tanpa rekening tersimpan tidak sah', () {
      expect(draft(100000, account: null).isValid, isFalse);
    });

    test('PIN harus tepat 6 digit angka', () {
      expect(draft(100000, pin: '12345').hasValidPin, isFalse);
      expect(draft(100000, pin: '1234567').hasValidPin, isFalse);
      expect(draft(100000, pin: '12345a').hasValidPin, isFalse);
      expect(draft(100000, pin: '000000').hasValidPin, isTrue);
    });

    test('withPin mempertahankan nominal dan rekening', () {
      final withPin = draft(80000, pin: '').withPin('654321');
      expect(withPin.amount, 80000);
      expect(withPin.bankAccountId, 7);
      expect(withPin.pin, '654321');
    });

    test('body memakai nama field yang diminta server', () {
      // Field bank mentah (bank_name, dst) kini diabaikan server — yang
      // dibaca hanya rekening tersimpan dan PIN.
      final json = draft(75000).toJson();
      expect(json, {'amount': 75000, 'bank_account_id': 7, 'pin': '123456'});
    });
  });
}
