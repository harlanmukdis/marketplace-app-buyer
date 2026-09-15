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

  group('WithdrawalDraft', () {
    const bank = (
      name: 'BCA',
      number: '1234567890',
      holder: 'Uji Wallet',
    );

    WithdrawalDraft draft(double amount) => WithdrawalDraft(
          amount: amount,
          bankName: bank.name,
          bankAccountNumber: bank.number,
          bankAccountName: bank.holder,
        );

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

    test('field bank yang kosong terdeteksi', () {
      const incomplete = WithdrawalDraft(amount: 100000, bankName: 'BCA');
      expect(incomplete.missingFields,
          {'bank_account_number', 'bank_account_name'});
      expect(incomplete.isValid, isFalse);
    });

    test('body memakai nama field yang diminta server', () {
      final json = draft(75000).toJson();
      expect(json.keys.toSet(), {
        'amount',
        'bank_name',
        'bank_account_number',
        'bank_account_name',
      });
      expect(json['amount'], 75000);
    });
  });
}
