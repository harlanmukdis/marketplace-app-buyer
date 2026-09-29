/// [CheckoutRepositoryImpl] terhadap service palsu yang meniru server
/// **wallet-only** (backend `d9ecb33`): `confirm` hanya membalas
/// `{order_ids, payment_transaction_id}`, dan PIN salah, PIN belum dibuat,
/// serta sesi kedaluwarsa sama-sama `422 CHECKOUT_CONFIRM_FAILED`.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/data/repositories/checkout_repository_impl.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';

const _confirmFailed = ApiException(DataError(
  code: ApiErrorCode.checkoutConfirmFailed,
  message: 'PIN salah',
  statusCode: 422,
  kind: DataErrorKind.api,
));

class _FakeCheckoutService extends CheckoutService {
  _FakeCheckoutService() : super(Dio());

  ApiException? confirmError;
  CheckoutSessionModel session = CheckoutSessionModel(
    id: 's1',
    status: 'stock_reserved',
    grandTotal: 159000,
    expiresAt: DateTime.now().add(const Duration(minutes: 10)),
  );
  String? sentPin;

  @override
  Future<ApiEnvelope<CheckoutConfirmResult>> confirm(
    String id, {
    required String pin,
  }) async {
    sentPin = pin;
    if (confirmError != null) throw confirmError!;
    return const ApiEnvelope(
      data: CheckoutConfirmResult(orderIds: [7], paymentTransactionId: 9),
    );
  }

  @override
  Future<ApiEnvelope<CheckoutSessionModel>> fetchSession(String id) async =>
      ApiEnvelope(data: session);
}

class _FakeWalletService extends WalletService {
  _FakeWalletService() : super(Dio());

  WalletModel wallet = const WalletModel(balance: 200000, heldBalance: 50000);
  ApiException? error;

  @override
  Future<ApiEnvelope<WalletModel>> fetchWallet() async {
    if (error != null) throw error!;
    return ApiEnvelope(data: wallet);
  }
}

void main() {
  late _FakeCheckoutService checkout;
  late _FakeWalletService wallet;
  late CheckoutRepositoryImpl repository;

  setUp(() {
    checkout = _FakeCheckoutService();
    wallet = _FakeWalletService();
    repository = CheckoutRepositoryImpl(checkout, wallet);
  });

  group('confirm', () {
    test('sukses selalu paid, dengan sisa saldo dari GET /wallet', () async {
      final result = await repository.confirm('s1', pin: '123456');

      expect(checkout.sentPin, '123456');
      final data = (result as DataSuccess<CheckoutConfirmResult>).data;
      expect(data.paid, isTrue,
          reason: 'server wallet-only tidak mengirim `paid`');
      expect(data.orderIds, [7]);
      expect(data.balanceAfter, 150000, reason: 'balance − held_balance');
    });

    test('GET /wallet gagal tidak menggagalkan konfirmasi yang sudah jadi',
        () async {
      wallet.error = const ApiException(DataError(
          code: ClientErrorCode.network, message: 'x', kind: DataErrorKind.network));

      final result = await repository.confirm('s1', pin: '123456');

      final data = (result as DataSuccess<CheckoutConfirmResult>).data;
      expect(data.paid, isTrue);
      expect(data.balanceAfter, isNull);
    });

    test('CHECKOUT_CONFIRM_FAILED + sesi masih terbuka → masalah PIN',
        () async {
      checkout.confirmError = _confirmFailed;

      final result = await repository.confirm('s1', pin: '111111');

      final error = (result as DataFailed).error;
      expect(error.code, WalletPayErrorCode.invalidPin);
      expect(error.details?['pin_maybe_not_set'], isTrue);
    });

    test('CHECKOUT_CONFIRM_FAILED + sesi kedaluwarsa → kode asli', () async {
      checkout
        ..confirmError = _confirmFailed
        ..session = CheckoutSessionModel(
          id: 's1',
          status: 'stock_reserved',
          expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        );

      final result = await repository.confirm('s1', pin: '123456');

      expect((result as DataFailed).error.code,
          ApiErrorCode.checkoutConfirmFailed);
    });

    test('CHECKOUT_CONFIRM_FAILED + sesi sudah jadi order → kode asli',
        () async {
      checkout
        ..confirmError = _confirmFailed
        ..session = const CheckoutSessionModel(id: 's1', status: 'completed');

      final result = await repository.confirm('s1', pin: '123456');

      expect((result as DataFailed).error.code,
          ApiErrorCode.checkoutConfirmFailed);
    });

    test('INSUFFICIENT_BALANCE diteruskan apa adanya', () async {
      checkout.confirmError = const ApiException(DataError(
        code: ApiErrorCode.insufficientBalance,
        message: 'saldo kurang',
        statusCode: 422,
        kind: DataErrorKind.api,
      ));

      final result = await repository.confirm('s1', pin: '123456');

      expect((result as DataFailed).error.code,
          ApiErrorCode.insufficientBalance);
    });
  });

  group('fetchWalletSummary — dirakit dari GET /wallet + grand_total', () {
    test('saldo tersedia dikurangi saldo tertahan', () async {
      wallet.wallet = const WalletModel(balance: 200000, heldBalance: 50000);

      final result = await repository.fetchWalletSummary('s1');

      final summary = (result as DataSuccess<WalletSummaryModel>).data;
      expect(summary.walletBalance, 150000);
      expect(summary.grandTotal, 159000);
      expect(summary.shortfall, 9000);
      expect(summary.canPay, isFalse);
      expect(summary.pinSet, isTrue,
          reason: 'tidak bisa diketahui dari server mana pun');
    });

    test('saldo cukup → canPay tanpa selisih', () async {
      wallet.wallet = const WalletModel(balance: 500000);

      final result = await repository.fetchWalletSummary('s1');

      final summary = (result as DataSuccess<WalletSummaryModel>).data;
      expect(summary.canPay, isTrue);
      expect(summary.shortfall, 0);
    });

    test('GET /wallet gagal → DataFailed, tidak dilempar', () async {
      wallet.error = const ApiException(DataError(
          code: ClientErrorCode.network, message: 'x', kind: DataErrorKind.network));

      final result = await repository.fetchWalletSummary('s1');

      expect((result as DataFailed).error.code, ClientErrorCode.network);
    });
  });
}
