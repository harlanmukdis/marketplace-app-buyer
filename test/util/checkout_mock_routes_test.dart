/// Perilaku mock pembayaran Xpedia Wallet (`checkout_mock_routes.dart`) —
/// kontrak yang diusulkan ke backend, jadi yang dipatok di sini adalah
/// **kontraknya**: bentuk `wallet-summary`, urutan penolakan PIN/saldo, dan
/// fakta bahwa order sungguhan tetap dibuat server lewat pass-through.
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/config/network/mock/routes/checkout_mock_routes.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';

/// "Server" palsu: sesi dengan `grand_total` tertentu, dan confirm yang
/// mencatat body yang benar-benar sampai.
class _Server implements HttpClientAdapter {
  _Server(this.grandTotal);

  final String grandTotal;
  final List<String> hits = [];
  Map<String, dynamic>? lastConfirmBody;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>>? requestStream, Future<void>? cancelFuture) async {
    hits.add('${options.method} ${options.path}');
    Object? data;
    if (options.path.endsWith('/confirm')) {
      lastConfirmBody = Map<String, dynamic>.from(options.data as Map);
      data = {
        'order_ids': [31],
        'payment_transaction_id': 8,
      };
    } else if (options.path.startsWith('/checkout/sessions/')) {
      data = {
        'id': 's1',
        'status': 'stock_reserved',
        'grand_total': grandTotal
      };
    } else if (options.path == '/me/withdrawal-pin') {
      data = null;
    } else {
      return ResponseBody.fromString('<html>404</html>', 404, headers: {
        Headers.contentTypeHeader: ['text/html'],
      });
    }
    return ResponseBody.fromString(
      jsonEncode({'success': true, 'data': data, 'error': null}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late _Server server;

  Dio build(String grandTotal) {
    server = _Server(grandTotal);
    return Dio(BaseOptions(baseUrl: 'http://x/api/v1'))
      ..httpClientAdapter = server
      ..interceptors.add(PendingApiMockInterceptor(checkoutMockRoutes));
  }

  Future<Map<String, dynamic>> summary() async {
    await dio.get<dynamic>('/checkout/sessions/s1');
    final response =
        await dio.get<dynamic>('/checkout/sessions/s1/wallet-summary');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<DioException> confirmError(String pin) async {
    try {
      await dio.post<dynamic>('/checkout/sessions/s1/confirm',
          data: {'payment_method': 'wallet', 'pin': pin});
    } on DioException catch (e) {
      return e;
    }
    fail('seharusnya ditolak');
  }

  setUp(() {
    CheckoutMock.reset(balance: 2500000, pinSet: true);
    dio = build('159000.00');
  });

  test('fixture wallet_summary memberi saldo simulasi Rp 2.500.000', () async {
    CheckoutMock.reset();
    expect(await CheckoutMock.balance(), 2500000);
  });

  group('wallet-summary', () {
    test('saldo cukup: bentuk kontrak, ditandai mock, tanpa ke server',
        () async {
      final body = await summary();

      expect(server.hits, ['GET /checkout/sessions/s1'],
          reason: 'wallet-summary dijawab mock seluruhnya');
      expect(
          isMockMeta(Map<String, dynamic>.from(body['meta'] as Map)), isTrue);
      final model = WalletSummaryModel.fromJson(
          Map<String, dynamic>.from(body['data'] as Map));
      expect(model.walletBalance, 2500000);
      expect(model.grandTotal, 159000);
      expect(model.shortfall, 0);
      expect(model.canPay, isTrue);
      expect(model.minTopup, 10000);
      expect(model.pinSet, isTrue);
    });

    test('total di atas saldo → shortfall dan can_pay false', () async {
      dio = build('2543000.00');
      final data = (await summary())['data'] as Map;
      final model =
          WalletSummaryModel.fromJson(Map<String, dynamic>.from(data));
      expect(model.canPay, isFalse);
      expect(model.shortfall, 43000);
      expect(model.isInsufficient, isTrue);
    });

    test('sesi yang belum pernah dibaca → 404 SESSION_NOT_FOUND', () async {
      await expectLater(
        dio.get<dynamic>('/checkout/sessions/lain/wallet-summary'),
        throwsA(isA<DioException>().having(
            (e) => e.response?.data['error']['code'],
            'code',
            'SESSION_NOT_FOUND')),
      );
    });

    test('membuat PIN penarikan sungguhan menyalakan pin_set', () async {
      CheckoutMock.reset(balance: 2500000, pinSet: false);
      expect(((await summary())['data'] as Map)['pin_set'], isFalse);

      await dio.post<dynamic>('/me/withdrawal-pin', data: {'pin': '654321'});
      expect(((await summary())['data'] as Map)['pin_set'], isTrue);
    });
  });

  group('confirm payment_method wallet', () {
    setUp(() async => dio.get<dynamic>('/checkout/sessions/s1'));

    test('PIN benar: diteruskan sebagai qris TANPA pin, lalu diperkaya',
        () async {
      final response = await dio.post<dynamic>('/checkout/sessions/s1/confirm',
          data: {'payment_method': 'wallet', 'pin': CheckoutMock.correctPin});

      // Order sungguhan dibuat server — dengan metode yang dikenalnya, dan
      // PIN tidak pernah dikirim ke server yang belum memverifikasinya.
      expect(server.lastConfirmBody, {'payment_method': 'qris'});
      final result = CheckoutConfirmResult.fromJson(
          Map<String, dynamic>.from(response.data['data'] as Map));
      expect(result.orderIds, [31]);
      expect(result.paymentTransactionId, 8);
      expect(result.paid, isTrue);
      expect(result.walletTransactionId, greaterThan(900000));
      expect(result.balanceAfter, 2341000);
      expect(response.data['meta']['mock_fields'],
          containsAll(['paid', 'wallet_transaction_id', 'balance_after']));

      // Saldo simulasi ikut turun untuk checkout berikutnya.
      expect(await CheckoutMock.balance(), 2341000);
    });

    test(
        'PIN salah: 422 INVALID_PIN dengan sisa percobaan, server tak disentuh',
        () async {
      server.hits.clear();
      final e = await confirmError('111111');

      expect(server.hits, isEmpty);
      expect(e.response?.statusCode, 422);
      expect(e.response?.data['error']['code'], 'INVALID_PIN');
      expect(e.response?.data['error']['details']['attempts_left'], 4);
    });

    test('5 PIN salah → 429; percobaan BENAR tidak ikut dihitung', () async {
      for (var i = 0; i < 4; i++) {
        await dio.post<dynamic>('/checkout/sessions/s1/confirm',
            data: {'payment_method': 'wallet', 'pin': CheckoutMock.correctPin});
      }
      // Empat keberhasilan tidak mengurangi jatah percobaan.
      for (var i = 0; i < 5; i++) {
        expect((await confirmError('000000')).response?.statusCode, 422);
      }
      final locked = await confirmError(CheckoutMock.correctPin);
      expect(locked.response?.statusCode, 429);
      expect(locked.response?.data['error']['code'], 'TOO_MANY_REQUESTS');
    });

    test('PIN belum dibuat → 422 PIN_NOT_SET', () async {
      CheckoutMock.pinSet = false;
      final e = await confirmError(CheckoutMock.correctPin);
      expect(e.response?.data['error']['code'], 'PIN_NOT_SET');
    });

    test(
        'saldo kurang → 422 INSUFFICIENT_BALANCE dengan balance & required, '
        'SEBELUM order dibuat', () async {
      dio = build('3000000.00');
      await dio.get<dynamic>('/checkout/sessions/s1');
      server.hits.clear();

      final e = await confirmError(CheckoutMock.correctPin);

      expect(server.hits, isEmpty, reason: 'tidak ada order yang terbentuk');
      expect(e.response?.data['error']['code'], 'INSUFFICIENT_BALANCE');
      expect(e.response?.data['error']['details'],
          {'balance': 2500000, 'required': 3000000});
    });

    test('metode lain (alur lama) diteruskan apa adanya, tanpa diperkaya',
        () async {
      final response = await dio.post<dynamic>('/checkout/sessions/s1/confirm',
          data: {'payment_method': 'virtual_account'});

      expect(server.lastConfirmBody, {'payment_method': 'virtual_account'});
      expect(response.data['data'].containsKey('paid'), isFalse);
      expect(response.data['meta'], isNull);
    });
  });
}
