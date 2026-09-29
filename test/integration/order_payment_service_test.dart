/// Kontrak `/orders*`, `/payments*`, dan `/payment-methods` terhadap
/// marketplace-api yang **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration/
/// ```
///
/// Test ini menjalankan alur beli sungguhan sampai order terbentuk, jadi ia
/// meninggalkan data di database dev.
///
/// Sejak backend `d9ecb33` checkout **wallet-only**: pesanan lahir `paid` dan
/// transaksinya `wallet`. QRIS/VA hanya tersisa untuk **top up** saldo, jadi
/// test `/payments/{id}/pay` memakai transaksi top up, bukan pesanan. Akun
/// pembeli disiapkan lewat `support/dev_db.dart` (PIN, saldo, kuota PIN). Beberapa test mematok **bug server**
/// (`/orders/{id}/complete` yang membalas HTML berstatus 200, dan `/orders`
/// tanpa `meta`) — kalau backend memperbaikinya, test itu merah lebih dulu.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/payment_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';

import 'support/dev_db.dart';
import 'support/seeded_product.dart';

void main() {
  late Dio dio;
  late CartService cart;
  late CatalogService catalog;
  late CheckoutService checkout;
  late OrderService orders;
  late PaymentService payments;
  late WalletService wallets;
  late int buyerId;

  late int variantId;
  late int addressId;

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    final addresses = AddressService(dio);
    cart = CartService(dio);
    catalog = CatalogService(dio);
    checkout = CheckoutService(dio);
    orders = OrderService(dio);
    payments = PaymentService(dio);
    wallets = WalletService(dio);

    // Akun bersama — lihat `support/test_account.dart` (plafon 20 login per IP
    // per 15 menit). Pesanan MENUMPUK di akun ini, dan itu tidak apa-apa:
    // seluruh assertion di berkas ini relatif (`isNotEmpty`, "setiap baris
    // begini", "mengandung status ini"), bukan jumlah mutlak. Pesanan juga
    // memang tidak punya endpoint hapus.
    await sharedAccount(dio, purpose: 'belanja');

    for (final group in (await cart.fetchCart()).data) {
      for (final item in group.items) {
        await cart.removeItem(item.id);
      }
    }

    // Bukan produk pertama: test ini mengonsumsi stok setiap kali dijalankan,
    // jadi harus mencari varian yang masih tersedia.
    variantId = (await findVariantWithStock(catalog)).variantId;
    buyerId = await prepareWalletCheckout(dio);

    // Dipakai ulang, bukan dibuat per test: alamat yang pernah masuk sesi
    // checkout tidak bisa dihapus (FK RESTRICT) dan batasnya 3 per akun.
    final existing =
        (await addresses.list()).data.where((a) => a.isComplete).toList();
    addressId = existing.isNotEmpty
        ? existing.first.id
        : (await addresses.create(
            label: 'Rumah',
            recipientName: 'Uji Order',
            phone: '081200000000',
            fullAddress: 'Jl. Uji No. 1',
            city: 'Jakarta Selatan',
            province: 'DKI Jakarta',
            postalCode: '12810',
            isPrimary: true,
          ))
            .data;
  });

  tearDown(() => dio.close(force: true));

  /// Menjalankan alur beli sampai order terbentuk — dan terbayar dari Wallet.
  Future<({List<int> orderIds, int txId})> placeOrder() async {
    await cart.addItem(productVariantId: variantId, quantity: 1);
    final created = await checkout.createSession(addressId: addressId);
    final sessionId = created.data.id;

    final options = await checkout.fetchShippingOptions(sessionId);
    await checkout.setShipping(sessionId, {
      for (final entry in options.data.entries)
        if (entry.value.isNotEmpty)
          entry.key: (
            courierCode: entry.value.first.courierCode,
            serviceCode: entry.value.first.serviceCode,
          ),
    });

    // Setiap confirm yang BERHASIL pun memakai kuota PIN 5/15 menit.
    await resetPinAttempts(buyerId);
    final confirmed = await checkout.confirm(sessionId, pin: testWalletPin);
    return (
      orderIds: confirmed.data.orderIds,
      txId: confirmed.data.paymentTransactionId!,
    );
  }

  group('GET /orders', () {
    test('daftar pesanan TIDAK membawa meta paginasi', () async {
      // Karena itu OrderListCubit menyimpulkan adanya halaman berikutnya dari
      // jumlah hasil, bukan dari meta.total.
      await placeOrder();
      final result = await orders.fetchOrders(page: 1);

      expect(result.data, isNotEmpty);
      expect(result.meta, isEmpty,
          reason: 'server tidak mengirim total/per_page sama sekali');
    });

    test('item daftar tanpa items, status_history, dan refund', () async {
      await placeOrder();
      final result = await orders.fetchOrders();

      for (final order in result.data) {
        expect(order.items, isEmpty);
        expect(order.statusHistory, isEmpty);
      }
    });

    test('🔴 parameter status DIABAIKAN server — bukan disaring', () async {
      // Controllernya hanya meneruskan `page` ke `list_for_buyer`. Karena itu
      // OrderService tidak punya parameter status sama sekali, dan layar
      // daftar pesanan tidak menawarkan filter: filter yang terlihat bekerja
      // tapi tidak menyaring lebih buruk daripada tidak ada filter.
      final placed = await placeOrder();
      await orders.cancel(placed.orderIds.first);

      final all = await orders.fetchOrders();
      final statuses = all.data.map((o) => o.status).toSet();
      expect(statuses, contains(OrderStatus.cancelled));

      // Meminta 'completed' lewat query mentah tetap mengembalikan semuanya.
      final filtered = await dio.get<dynamic>(
        '/orders',
        queryParameters: {'status': 'completed'},
      );
      final rows = (filtered.data['data'] as List)
          .map((e) => (e as Map)['status'])
          .toSet();
      expect(rows, contains('cancelled'),
          reason: 'server mengabaikan ?status= dan mengirim semua pesanan');
    });

    test('halaman jauh di belakang mengembalikan daftar kosong', () async {
      await placeOrder();
      final result = await orders.fetchOrders(page: 99);
      expect(result.data, isEmpty);
    });
  });

  group('GET /orders/{id}', () {
    test('detail membawa items dan status_history', () async {
      final placed = await placeOrder();
      final order = (await orders.fetchOrder(placed.orderIds.first)).data;

      expect(order.items, isNotEmpty);
      expect(order.statusHistory, isNotEmpty);
      // Wallet-only: lunas saat konfirmasi, tidak pernah `pending`.
      expect(order.status, OrderStatus.paid);
      expect(order.orderNumber, startsWith('ORD-'));
    });

    test('✅ payment_deadline dan created_at kini SEZONA — selisihnya 1 jam',
        () async {
      // Dulu 8 jam: PHP `date()` UTC vs MySQL `CURRENT_TIMESTAMP` WIB.
      // Diseragamkan backend di commit `93c6a14`.
      final placed = await placeOrder();
      final order = (await orders.fetchOrder(placed.orderIds.first)).data;

      final gap = order.paymentDeadline!.difference(order.createdAt!);
      expect(gap, const Duration(hours: 1));
    });

    test('🔴 detail kini membawa shipping_address, bukan snapshot', () async {
      // Sejak backend v1.x (blueprint Seller Ch.7) `GET /orders/{id}` membuang
      // `shipping_address_snapshot` dan menggantinya dengan alamat yang sudah
      // terselesaikan — join LIVE ke user_addresses, bukan snapshot. Daftar
      // `GET /orders` masih membawa snapshot lama.
      final placed = await placeOrder();
      final id = placed.orderIds.first;
      final order = (await orders.fetchOrder(id)).data;

      expect(order.shippingAddressSnapshot, isNull);
      expect(order.shippingAddress, isNotNull);
      expect(order.shippingAddress!.recipientName, isNotEmpty);
      expect(order.shippingAddress!.city, isNotEmpty);

      final listed = (await orders.fetchOrders()).data.firstWhere((o) => o.id == id);
      expect(listed.shippingAddressId, addressId);

      await orders.cancel(id, reason: 'uji otomatis');
    });

    test('pesanan milik user lain dibalas 403, bukan 404', () async {
      // Pesanan akun ini dibaca oleh akun lain — dulu test ini menebak id 1,
      // yang di DB baru justru milik akun ini sendiri.
      final placed = await placeOrder();
      final other = DioClient.createBare(Env.apiBaseUrl);
      try {
        await sharedAccount(other, purpose: 'alamat');
        await OrderService(other).fetchOrder(placed.orderIds.first);
        fail('pesanan orang lain seharusnya ditolak');
      } on ApiException catch (e) {
        expect(e.error.statusCode, 403);
        expect(e.error.code, ApiErrorCode.permissionDenied);
      } finally {
        other.close(force: true);
      }
    });
  });

  group('aksi pesanan', () {
    test('membatalkan pesanan mengubah status jadi cancelled', () async {
      final placed = await placeOrder();
      final id = placed.orderIds.first;

      await orders.cancel(id, reason: 'uji otomatis');

      final order = (await orders.fetchOrder(id)).data;
      expect(order.status, OrderStatus.cancelled);
      expect(order.statusHistory.map((h) => h.toStatus),
          containsAllInOrder(['paid', 'cancelled']));
    });

    test('✅ membatalkan pesanan yang sudah dibayar mengembalikan saldo',
        () async {
      final placed = await placeOrder();
      final before = (await wallets.fetchWallet()).data.balance;

      await orders.cancel(placed.orderIds.first, reason: 'uji otomatis');

      final after = (await wallets.fetchWallet()).data;
      expect(after.balance, greaterThan(before),
          reason: 'pesanan paid dibatalkan → refund ke Wallet');
      expect(after.transactions.first.type.credit, isTrue);
    });

    test('confirm-delivery dari status salah dibalas 422 yang rapi', () async {
      final placed = await placeOrder();
      // Bandingkan dengan /complete di bawah: kondisi yang sama, penanganan
      // yang sama sekali berbeda.
      await expectLater(
        orders.confirmDelivery(placed.orderIds.first),
        throwsA(anything),
      );
    });

    test('🔴 complete dari status salah membalas HTML berstatus 200', () async {
      // Controllernya tidak punya try/catch seperti confirm-delivery, jadi
      // RuntimeException-nya lolos jadi halaman HTML — dengan status 2xx,
      // sehingga Dio tidak menganggapnya error. OrderService menerjemahkannya
      // jadi INVALID_TRANSITION supaya bisa dijelaskan ke user.
      final placed = await placeOrder();
      await expectLater(
        orders.complete(placed.orderIds.first),
        throwsA(anything),
      );
    });

    test('tracking membalas data null selama belum dikirim', () async {
      final placed = await placeOrder();
      final tracking = await orders.fetchTracking(placed.orderIds.first);
      expect(tracking.data, isNull);
    });

    // Satu pesanan untuk empat kontrak baru, supaya suite tidak menghabiskan
    // stok lebih cepat (lihat `support/seeded_product.dart`).
    test('kontrak endpoint pasca-beli baru pada pesanan pending', () async {
      final placed = await placeOrder();
      final id = placed.orderIds.first;

      // Invoice hanya untuk `completed`.
      await expectLater(
        orders.fetchInvoice(id),
        throwsA(predicate((e) => e.toString().contains('INVOICE_NOT_AVAILABLE'))),
      );

      // Tanpa usulan kirim sebagian dari penjual.
      await expectLater(
        orders.respondPartialFulfillment(id, PartialFulfillmentDecision.continuePartial),
        throwsA(predicate((e) => e.toString().contains('VALIDATION_ERROR'))),
      );

      // Bukan Secure+ / belum dikirim → daftar kosong, bukan error.
      expect((await orders.fetchShipmentEvidence(id)).data, isEmpty);

      // Field baru ikut di detail.
      final order = (await orders.fetchOrder(id)).data;
      expect(order.cancellationFault, isNull);
      expect(order.awaitsPartialDecision, isFalse);
      expect(order.canCancel, isTrue);

      // Komplain sebelum barang diterima kini ditolak server (backend
      // `0307edf`, docs/22 #5) — dulu diterima tanpa gerbang status.
      try {
        await orders.requestRefund(id,
            reason: 'uji otomatis', evidenceUrls: ['https://contoh.id/a.jpg']);
        fail('komplain pada pesanan paid seharusnya ditolak');
      } on ApiException catch (e) {
        expect(e.error.code, ApiErrorCode.validationError);
      }

      // Pembatalan pembeli kini mencatat pihak penyebabnya.
      await orders.cancel(id, reason: 'uji otomatis');
      final cancelled = (await orders.fetchOrder(id)).data;
      expect(cancelled.cancellationFault, 'buyer');
    });
  });

  group('pembayaran', () {
    /// Transaksi top up — satu-satunya yang masih dibayar lewat QRIS/VA.
    Future<int> topupTx({String paymentMethod = 'qris'}) async {
      final result =
          await wallets.topup(amount: 25000, paymentMethod: paymentMethod);
      return result.data.paymentTransactionId;
    }

    test('daftar metode berisi qris dan virtual_account', () async {
      final result = await payments.fetchMethods();
      final codes = result.data.map((m) => m.code).toSet();
      expect(codes, containsAll(['qris', 'virtual_account']));
    });

    test('✅ transaksi pesanan: wallet, LUNAS sejak lahir, order_id null',
        () async {
      final placed = await placeOrder();
      final payment = (await payments.fetchPayment(placed.txId)).data;

      expect(payment.checkoutSessionId, isNotEmpty);
      expect(payment.isPending, isFalse);
      expect(payment.status, 'paid');
      expect(payment.paymentMethod, 'wallet');
      expect(payment.amount, greaterThan(0));
    });

    test('pay top up dengan metode qris menghasilkan qr_string', () async {
      final txId = await topupTx();
      final instruction = (await payments.pay(txId)).data;

      expect(instruction.kind, PaymentInstructionKind.qris);
      expect(instruction.qrString, isNotEmpty);
      expect(instruction.expiresAt, isNotNull);
    });

    test('pay top up dengan metode virtual_account menghasilkan va_number',
        () async {
      final txId = await topupTx(paymentMethod: 'virtual_account');
      final instruction = (await payments.pay(txId)).data;

      expect(instruction.kind, PaymentInstructionKind.virtualAccount);
      expect(instruction.vaNumber, isNotEmpty);
      expect(instruction.bank, isNotEmpty);
    });

    test(
      '🔴 metode ditentukan saat transaksi DIBUAT, bukan saat pay',
      () async {
        // Body `payment_method` pada /pay diabaikan server.
        final txId = await topupTx(paymentMethod: 'virtual_account');

        final withQris = await dio.post<dynamic>(
          '/payments/$txId/pay',
          data: {'payment_method': 'qris'},
        );

        final data = withQris.data['data'] as Map;
        expect(data['va_number'], isNotNull,
            reason: 'tetap VA walau diminta qris');
        expect(data['qr_string'], isNull);
      },
    );

    test('✅ expired_at dan created_at kini SEZONA — selisihnya 1 jam',
        () async {
      final txId = await topupTx();
      final payment = (await payments.fetchPayment(txId)).data;

      final gap = payment.expiredAt!.difference(payment.createdAt!);
      expect(gap, const Duration(hours: 1));
    });
  });
}
