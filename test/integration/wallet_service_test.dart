/// Kontrak `/wallet*` terhadap marketplace-api yang **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration --concurrency=1
/// ```
///
/// ⚠️ **Mutasi saldo tidak bisa dihasilkan di sini.** Satu-satunya jalan
/// menambah saldo adalah callback penyedia pembayaran, yang menuntut HMAC
/// dengan `WEBHOOK_SIGNING_SECRET` yang tidak ada di repo. Jadi test ini
/// memastikan dompet kosong, bentuk hasil topup, dan **penolakan** penarikan —
/// bukan perjalanan uangnya. Bentuk baris mutasi diturunkan dari skema
/// (`SELECT *` pada `wallet_transactions`) dan diuji di `test/data/`.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/payment_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';

void main() {
  late Dio dio;
  late WalletService wallet;
  late PaymentService payments;

  // Satu akun bersama untuk seluruh berkas ini, dipakai ulang lintas putaran.
  //
  // Aman dipakai bersama karena **saldo tidak bisa tumbuh di dev**: satu-satunya
  // jalan mengkredit dompet adalah callback penyedia pembayaran, yang menuntut
  // HMAC dengan WEBHOOK_SIGNING_SECRET yang tidak ada di repo. Jadi saldonya
  // tetap 0 berapa kali pun suite dijalankan, dan topup hanya menumpuk baris
  // payment_transactions berstatus pending yang tidak dilihat test mana pun.
  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    wallet = WalletService(dio);
    payments = PaymentService(dio);

    await sharedAccount(dio, purpose: 'ringan');
  });

  tearDown(() => dio.close(force: true));

  group('GET /wallet', () {
    test('dompet dibuat otomatis saat pertama dibaca — bukan 404', () async {
      final result = await wallet.fetchWallet();

      expect(result.statusCode, 200);
      expect(result.data.balance, 0);
      expect(result.data.isActive, isTrue);
      expect(result.data.transactions, isEmpty);
    });

    test('membaca dua kali tidak menggandakan dompet', () async {
      final first = await wallet.fetchWallet();
      final second = await wallet.fetchWallet();
      expect(second.data.id, first.data.id);
    });
  });

  group('POST /wallet/topup', () {
    test('membuat transaksi pembayaran, TIDAK menambah saldo', () async {
      final topup = await wallet.topup(amount: 250000);

      expect(topup.data.paymentTransactionId, greaterThan(0));
      expect(topup.data.amount, 250000);
      expect(topup.data.reference, isNotEmpty);

      // Ini inti perilakunya: saldo tetap nol sampai topupnya dibayar.
      final after = await wallet.fetchWallet();
      expect(after.data.balance, 0);
    });

    test('transaksi topup bisa dibuka layar pembayaran yang sudah ada',
        () async {
      // Topup memakai ulang alur checkout: /payments/{txId} dan /pay.
      final topup = await wallet.topup(amount: 150000);
      final payment =
          await payments.fetchPayment(topup.data.paymentTransactionId);

      expect(payment.data.isPending, isTrue);
      expect(payment.data.amount, 150000);
      // Bedanya dari pembayaran order: tidak terikat sesi checkout.
      expect(payment.data.checkoutSessionId, anyOf(isNull, isEmpty));

      final instruction =
          await payments.pay(topup.data.paymentTransactionId);
      expect(instruction.data.expiresAt, isNotNull);
    });
  });

  // Sejak backend v1.x (blueprint Wallet) penarikan menuntut PIN 6 digit dan
  // rekening tersimpan. Setiap percobaan menghabiskan kuota PIN — 5 per 15
  // menit per user, **benar atau salah** — jadi berkas ini sengaja hanya
  // menembak `/wallet/withdraw` DUA kali per putaran, supaya dua putaran
  // beruntun tetap muat.
  group('rekening & PIN penarikan', () {
    const pin = '246810';

    test('nama pemilik rekening harus sama dengan nama akun', () async {
      await expectLater(
        wallet.addBankAccount(
          bankName: 'BCA',
          accountNumber: '1234567890',
          accountHolderName: 'Orang Lain',
        ),
        throwsA(predicate((e) => e.toString().contains('VALIDATION_ERROR'))),
      );
    });

    test('rekening atas nama sendiri tersimpan, lalu bisa dihapus', () async {
      // `sharedAccount(purpose: 'ringan')` mendaftar dengan full_name 'ringan';
      // server membandingkannya tanpa memandang huruf besar-kecil.
      final id = (await wallet.addBankAccount(
        bankName: 'BCA',
        accountNumber: '9876543210',
        accountHolderName: 'RINGAN',
      ))
          .data;
      expect(id, greaterThan(0));

      final listed = (await wallet.fetchBankAccounts()).data;
      final account = listed.firstWhere((a) => a.id == id);
      expect(account.maskedNumber, '•••• 3210');

      await wallet.deleteBankAccount(id);
      final after = (await wallet.fetchBankAccounts()).data;
      expect(after.any((a) => a.id == id), isFalse);
    });

    test('PIN bukan 6 digit ditolak VALIDATION_ERROR', () async {
      await expectLater(
        wallet.setWithdrawalPin(pin: '12ab'),
        throwsA(predicate((e) => e.toString().contains('VALIDATION_ERROR'))),
      );
    });

    test('PIN bisa disetel; mengganti menuntut PIN lama', () async {
      // Akun bersama dipakai lintas putaran, jadi PIN-nya mungkin sudah ada
      // dari putaran sebelumnya — server tidak punya cara menanyakannya.
      // Satu panggilan menutup kedua kasus: `current_pin` diabaikan saat PIN
      // belum ada, dan diverifikasi saat sudah ada (`set_withdrawal_pin`).
      //
      // ⚠️ Jalur GANTI PIN punya kuota sendiri (5 per 15 menit, benar atau
      // salah). Test ini memakai dua per putaran, jadi dua putaran beruntun
      // tetap muat.
      await wallet.setWithdrawalPin(pin: pin, currentPin: pin);

      await expectLater(
        wallet.setWithdrawalPin(pin: '135790', currentPin: '000000'),
        throwsA(predicate((e) => e.toString().contains('VALIDATION_ERROR'))),
        reason: 'PIN lama salah',
      );
    });

    test(
      '🔴 semua penolakan penarikan memakai KODE YANG SAMA',
      () async {
        // Inilah alasan WalletCubit memvalidasi minimum, saldo, rekening, dan
        // format PIN sendiri: sebab-sebab yang tindakannya berbeda tidak bisa
        // dibedakan dari `error.code`.
        Object? belowMinimum;
        Object? noAccount;
        try {
          await wallet.withdraw(const WithdrawalDraft(amount: 10000, pin: pin));
        } catch (e) {
          belowMinimum = e;
        }
        try {
          await wallet.withdraw(const WithdrawalDraft(
            amount: WithdrawalDraft.minimumAmount,
            pin: pin,
          ));
        } catch (e) {
          noAccount = e;
        }

        expect(belowMinimum.toString(), contains('WITHDRAWAL_REJECTED'));
        expect(noAccount.toString(), contains('WITHDRAWAL_REJECTED'));

        // Penolakan tidak boleh meninggalkan saldo negatif.
        final after = await wallet.fetchWallet();
        expect(after.data.balance, 0);
      },
    );
  });
}
