import 'package:flutter/foundation.dart';

import '../pending_api_mock.dart';

/// Rute mock domain checkout: **pembayaran via Xpedia Wallet + PIN**
/// (docs/22 #1, #2, #12). Lihat `PendingApiMock` untuk aturannya dan
/// `assets/mock/pending_api/README.md` bagian "Checkout & Wallet" untuk
/// kontrak yang diusulkan.
///
/// Yang disimulasikan:
///
/// * `GET /checkout/sessions/{id}/wallet-summary` — **dijawab penuh** mock.
///   `grand_total` diambil dari `GET /checkout/sessions/{id}` sungguhan yang
///   selalu dimuat aplikasi lebih dulu (lihat rute pengamat di bawah); saldo
///   dari saldo simulasi ([CheckoutMock.balance]), **bukan** `GET /wallet` —
///   saldo sungguhan di dev selalu 0 karena callback topup tidak bisa
///   dipicu, sehingga jalur "saldo cukup" tidak akan pernah bisa dilihat.
/// * `POST /checkout/sessions/{id}/confirm` dengan `payment_method: "wallet"`
///   — PIN dan saldo diperiksa mock, lalu request **diteruskan ke server
///   sungguhan** dengan `payment_method` diganti [CheckoutMock.passThroughMethod]
///   supaya order sungguhan terbentuk. Balasannya diperkaya
///   `paid`/`wallet_transaction_id`/`balance_after`.
///
/// 🔴 Konsekuensinya: dalam simulasi, **order di server tetap `pending`**
/// (menunggu pembayaran QRIS yang tidak pernah terjadi). Layar sukses
/// menyebutnya terang-terangan.
///
/// Kendali debug:
///
/// * PIN simulasi yang benar: [CheckoutMock.correctPin] (`123456`).
/// * `--dart-define=MOCK_WALLET_BALANCE=0` — memaksa keadaan saldo kurang.
///   Tanpa itu saldonya dari fixture (Rp 2.500.000), jadi total di atasnya
///   pun menampilkan keadaan kurang secara alami.
/// * `--dart-define=MOCK_WALLET_PIN_SET=false` — memaksa keadaan "PIN belum
///   dibuat". Membuat PIN lewat `POST /me/withdrawal-pin` sungguhan
///   menyalakannya lagi (rute pengamat di bawah).
///
/// Top up **tidak** menambah saldo simulasi: `POST /wallet/topup` sungguhan
/// hanya membuat transaksi pending, dan di dev tidak ada yang bisa
/// membayarnya.
List<MockRoute> get checkoutMockRoutes => [
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/checkout/sessions/([^/]+)/wallet-summary$'),
        onRequest: (options, match) async {
          final id = match.group(1)!;
          final total = CheckoutMock._grandTotals[id];
          // Aplikasi selalu memuat sesinya lebih dulu, jadi total yang belum
          // tercatat berarti sesinya memang tidak dikenal.
          if (total == null) {
            return MockReply.error(
              'SESSION_NOT_FOUND',
              'Sesi checkout tidak ditemukan',
              statusCode: 404,
            );
          }
          // `mock_pin` hanya untuk petunjuk di lembar PIN — bukan bagian
          // kontrak; backend tidak boleh mengirim PIN ke mana pun.
          return MockReply.ok(
            await CheckoutMock.summaryFor(total),
            meta: {'mock_pin': CheckoutMock.correctPin},
          );
        },
      ),

      // Pengamat: mencatat `grand_total` setiap kali sesi sungguhan dibaca.
      // Respons tidak diubah sama sekali.
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/checkout/sessions/([^/]+)$'),
        onResponse: (response, match) async {
          final body = response.data;
          if (body is! Map || body['data'] is! Map) return;
          final total =
              double.tryParse('${(body['data'] as Map)['grand_total']}');
          if (total != null) CheckoutMock._grandTotals[match.group(1)!] = total;
        },
      ),

      MockRoute(
        method: 'POST',
        path: RegExp(r'^/checkout/sessions/([^/]+)/confirm$'),
        onRequest: (options, match) async {
          final body = options.data is Map
              ? Map<String, dynamic>.from(options.data as Map)
              : <String, dynamic>{};
          // Alur lama (qris/VA/…) diteruskan apa adanya.
          if (body['payment_method'] != 'wallet') return null;

          final reject = await CheckoutMock.verifyPayment(
            sessionId: match.group(1)!,
            pin: body['pin']?.toString() ?? '',
          );
          if (reject != null) return reject;

          body
            ..remove('pin')
            ..['payment_method'] = CheckoutMock.passThroughMethod;
          options.data = body;
          options.extra[CheckoutMock._walletPayFlag] = true;
          return null;
        },
        onResponse: (response, match) async {
          // Catatan: kalau request ini sempat 401 lalu diulang
          // `AuthInterceptor` lewat klien polos, balasannya tidak lewat sini —
          // order tetap terbentuk, tapi tampil sebagai alur lama (`paid`
          // false). Hanya terjadi di debug, saat token habis tepat di detik
          // itu.
          if (response.requestOptions.extra[CheckoutMock._walletPayFlag] !=
              true) {
            return;
          }
          final body = response.data;
          if (body is! Map || body['data'] is! Map) return;
          final data = body['data'] as Map;
          final paid = CheckoutMock.debit(match.group(1)!);
          data
            ..['paid'] = true
            ..['wallet_transaction_id'] = paid.walletTransactionId
            ..['balance_after'] = paid.balanceAfter.toStringAsFixed(2)
            ..['paid_at'] = paid.paidAt;
          markMockFields(
            response,
            ['paid', 'wallet_transaction_id', 'balance_after', 'paid_at'],
          );
        },
      ),

      // Pengamat: membuat PIN sungguhan (`POST /me/withdrawal-pin`) berarti
      // PIN Wallet sudah ada. Respons tidak diubah.
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/me/withdrawal-pin$'),
        onResponse: (response, match) async {
          final code = response.statusCode ?? 0;
          if (code >= 200 && code < 300) CheckoutMock.pinSet = true;
        },
      ),
    ];

/// Keadaan simulasi Wallet — hidup selama proses app berjalan.
abstract final class CheckoutMock {
  /// PIN simulasi yang diterima. PIN lain dibalas `INVALID_PIN`.
  static const String correctPin = '123456';

  /// Metode sungguhan yang dipakai saat meneruskan konfirmasi ke server:
  /// `wallet` belum ada di ENUM `payment_transactions.payment_method`.
  static const String passThroughMethod = 'qris';

  /// Batas percobaan PIN **salah** per 15 menit sebelum `429`.
  ///
  /// Sengaja hanya menghitung yang salah — kontrak yang diusulkan meminta
  /// hal yang sama ke backend. Batas login dan PIN penarikan yang ada hari
  /// ini ikut menghitung percobaan **benar**, sehingga pembeli yang tidak
  /// pernah salah pun bisa terkunci (CLAUDE.md, "Rate limit auth").
  static const int maxFailedAttempts = 5;
  static const Duration attemptWindow = Duration(minutes: 15);

  static const _walletPayFlag = 'mockWalletPay';

  static double? _balance;
  static bool? _pinSet;
  static double _minTopup = 10000;
  static final Map<String, double> _grandTotals = {};
  static final List<DateTime> _failedAttempts = [];
  static int _walletTxSeq = 0;

  /// Saldo simulasi, dimuat sekali dari fixture (atau
  /// `--dart-define=MOCK_WALLET_BALANCE`).
  static Future<double> balance() async {
    await _ensureLoaded();
    return _balance!;
  }

  static bool get _pinSetValue => _pinSet ?? true;
  static set pinSet(bool value) => _pinSet = value;

  static Future<void> _ensureLoaded() async {
    if (_balance != null && _pinSet != null) return;
    final fixture = await MockFixtures.load<Map<String, dynamic>>(
        'checkout/wallet_summary.json');
    const override = String.fromEnvironment('MOCK_WALLET_BALANCE');
    _balance ??= double.tryParse(override) ??
        double.tryParse('${fixture['wallet_balance']}') ??
        0;
    _minTopup = double.tryParse('${fixture['min_topup']}') ?? 10000;
    const pinOverride = String.fromEnvironment('MOCK_WALLET_PIN_SET');
    _pinSet ??= pinOverride.isEmpty
        ? fixture['pin_set'] != false
        : pinOverride != 'false';
  }

  static Future<Map<String, dynamic>> summaryFor(double grandTotal) async {
    final saldo = await balance();
    final shortfall = grandTotal > saldo ? grandTotal - saldo : 0.0;
    return {
      'wallet_balance': saldo.toStringAsFixed(2),
      'grand_total': grandTotal.toStringAsFixed(2),
      'shortfall': shortfall.toStringAsFixed(2),
      'can_pay': shortfall == 0,
      'min_topup': _minTopup.toInt(),
      'pin_set': _pinSetValue,
    };
  }

  /// Urutan pemeriksaan sama dengan yang diusulkan ke backend: PIN belum
  /// dibuat → kuncian → format → PIN salah → saldo. Saldo diperiksa
  /// **terakhir** supaya pesan "saldo kurang" tidak membocorkan informasi ke
  /// orang yang tidak tahu PIN-nya.
  static Future<MockReply?> verifyPayment({
    required String sessionId,
    required String pin,
  }) async {
    await _ensureLoaded();
    if (!_pinSetValue) {
      return MockReply.error('PIN_NOT_SET', 'PIN Wallet belum dibuat');
    }

    final now = DateTime.now();
    _failedAttempts.removeWhere((t) => now.difference(t) > attemptWindow);
    if (_failedAttempts.length >= maxFailedAttempts) {
      return MockReply.error(
        'TOO_MANY_REQUESTS',
        'Terlalu banyak percobaan PIN',
        statusCode: 429,
      );
    }

    if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
      return MockReply.error('VALIDATION_ERROR', 'PIN harus 6 digit angka');
    }

    if (pin != correctPin) {
      _failedAttempts.add(now);
      final left = maxFailedAttempts - _failedAttempts.length;
      return MockReply(
        {
          'success': false,
          'data': null,
          'error': {
            'code': 'INVALID_PIN',
            'message': 'PIN salah',
            'details': {'attempts_left': left},
          },
          'meta': {'mock': true},
        },
        statusCode: 422,
      );
    }

    final total = _grandTotals[sessionId];
    final saldo = _balance!;
    if (total != null && total > saldo) {
      return MockReply(
        {
          'success': false,
          'data': null,
          'error': {
            'code': 'INSUFFICIENT_BALANCE',
            'message': 'Saldo Wallet tidak mencukupi',
            'details': {'balance': saldo.round(), 'required': total.round()},
          },
          'meta': {'mock': true},
        },
        statusCode: 422,
      );
    }
    return null;
  }

  /// Memotong saldo simulasi sesudah server sungguhan membuat order-nya.
  static ({int walletTransactionId, double balanceAfter, String paidAt}) debit(
      String sessionId) {
    final total = _grandTotals[sessionId] ?? 0;
    final after = (_balance ?? 0) - total;
    _balance = after < 0 ? 0 : after;
    _walletTxSeq++;
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return (
      // Rentang 9xxxxx supaya tidak mungkin tertukar dengan id sungguhan di
      // seed dev.
      walletTransactionId: 900000 + _walletTxSeq,
      balanceAfter: _balance!,
      paidAt: '${now.year}-${two(now.month)}-${two(now.day)} '
          '${two(now.hour)}:${two(now.minute)}:${two(now.second)}',
    );
  }

  @visibleForTesting
  static void reset({double? balance, bool? pinSet}) {
    _balance = balance;
    _pinSet = pinSet;
    _grandTotals.clear();
    _failedAttempts.clear();
    _walletTxSeq = 0;
  }

  @visibleForTesting
  static void rememberGrandTotal(String sessionId, double total) =>
      _grandTotals[sessionId] = total;
}
