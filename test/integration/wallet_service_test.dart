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
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/payment_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';

void main() {
  late Dio dio;
  late WalletService wallet;
  late PaymentService payments;

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    final auth = AuthService(dio);
    wallet = WalletService(dio);
    payments = PaymentService(dio);

    final stamp = DateTime.now().microsecondsSinceEpoch;
    final email = 'uji.wallet.$stamp@marketplace.local';
    final phone =
        '08${stamp.toString().substring(stamp.toString().length - 10)}';
    const password = 'RahasiaAman123';

    await auth.register(
      email: email,
      password: password,
      fullName: 'Uji Wallet',
      phone: phone,
    );
    final session = await auth.login(email: email, password: password);
    dio.options.headers['Authorization'] =
        'Bearer ${session.data.accessToken}';
  });

  tearDown(() => dio.close(force: true));

  group('GET /wallet', () {
    test('dompet dibuat otomatis untuk akun baru — bukan 404', () async {
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

  group('POST /wallet/withdraw', () {
    test(
      '🔴 di bawah minimum dan saldo kurang memakai KODE ERROR YANG SAMA',
      () async {
        // Inilah alasan WalletCubit memvalidasi minimum sendiri: kedua sebab
        // yang sangat berbeda ini tidak bisa dibedakan dari `error.code`,
        // sementara panduan FE melarang mencocokkan `error.message`.
        Object? belowMinimum;
        Object? insufficient;

        try {
          await wallet.withdraw(const WithdrawalDraft(
            amount: 10000,
            bankName: 'BCA',
            bankAccountNumber: '1234567890',
            bankAccountName: 'Uji Wallet',
          ));
        } catch (e) {
          belowMinimum = e;
        }

        try {
          await wallet.withdraw(const WithdrawalDraft(
            amount: 1000000,
            bankName: 'BCA',
            bankAccountNumber: '1234567890',
            bankAccountName: 'Uji Wallet',
          ));
        } catch (e) {
          insufficient = e;
        }

        expect(belowMinimum, isNotNull);
        expect(insufficient, isNotNull);
        expect(belowMinimum.toString(), contains('WITHDRAWAL_REJECTED'));
        expect(insufficient.toString(), contains('WITHDRAWAL_REJECTED'));
      },
    );

    test('saldo nol menolak penarikan berapa pun di atas minimum', () async {
      await expectLater(
        wallet.withdraw(const WithdrawalDraft(
          amount: WithdrawalDraft.minimumAmount,
          bankName: 'BCA',
          bankAccountNumber: '1234567890',
          bankAccountName: 'Uji Wallet',
        )),
        throwsA(anything),
      );

      // Penolakan tidak boleh meninggalkan saldo negatif.
      final after = await wallet.fetchWallet();
      expect(after.data.balance, 0);
    });
  });
}
