/// Parsing model pesanan dan pembayaran terhadap bentuk JSON yang
/// **benar-benar dikirim** server (15 September 2026).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';

/// Respons `GET /orders/{id}` apa adanya.
const _orderJson = <String, dynamic>{
  'id': '15',
  'order_number': 'ORD-UW6RM272MR',
  'checkout_session_id': '456da069-c1c6-430a-9a84-c0e8267bbf4d',
  'buyer_id': '186',
  'store_id': '1',
  'warehouse_id': '1',
  'status': 'pending',
  'subtotal': '150000.00',
  'shipping_cost': '17000.00',
  'discount_total': '0.00',
  'cashback_total': '0.00',
  'grand_total': '167000.00',
  'courier_code': 'jnt',
  'courier_service': 'ez',
  'tracking_number': null,
  'shipping_address_snapshot': '{"address_id":"59"}',
  // Keduanya WIB sejak commit backend `93c6a14`; sebelumnya
  // `payment_deadline` UTC sehingga tampak 6 jam SEBELUM `created_at`.
  'payment_deadline': '2026-09-15 22:24:01',
  'created_at': '2026-09-15 21:24:01',
  'updated_at': '2026-09-15 21:24:01',
  'items': [
    {
      'id': '15',
      'order_id': '15',
      'product_variant_id': '1',
      'product_name_snapshot': 'Kopi Arabika Gayo 250g',
      'variant_options_snapshot': null,
      'price_snapshot': '75000.00',
      'quantity': '2',
      'subtotal': '150000.00',
    },
  ],
  'status_history': [
    {
      'id': '15',
      'order_id': '15',
      'from_status': null,
      'to_status': 'pending',
      'changed_by': null,
      'notes': null,
      'created_at': '2026-09-15 21:24:01',
    },
  ],
  'refund': null,
};

void main() {
  group('OrderModel', () {
    test('angka string terbaca, dan status jadi enum', () {
      final order = OrderModel.fromJson(_orderJson);

      expect(order.id, 15);
      expect(order.grandTotal, 167000);
      expect(order.shippingCost, 17000);
      expect(order.status, OrderStatus.pending);
      expect(order.statusLabel, 'Menunggu pembayaran');
    });

    test('status yang belum dikenal tidak menggagalkan parsing', () {
      // Backend boleh menambah status baru; layar cukup menampilkan kodenya.
      final order =
          OrderModel.fromJson({..._orderJson, 'status': 'status_baru'});
      expect(order.status, OrderStatus.unknown);
      expect(order.statusLabel, 'status_baru');
    });

    test('payment_deadline dan created_at dibaca dengan zona yang SAMA', () {
      // Dulu `payment_deadline` UTC sementara `created_at` WIB, sehingga
      // selisihnya -6 jam dan hitung mundur pembayaran langsung tampak habis.
      // Diseragamkan backend di commit `93c6a14`.
      final order = OrderModel.fromJson(_orderJson);
      final gap = order.paymentDeadline!.difference(order.createdAt!);
      expect(gap, const Duration(hours: 1));
    });

    test('shipping_address_snapshot hanya berisi address_id', () {
      // Bukan alamat lengkap — untuk menampilkannya perlu GET /me/addresses.
      final order = OrderModel.fromJson(_orderJson);
      expect(order.shippingAddressId, 59);
      expect(order.shippingAddressSnapshot!.keys, ['address_id']);
    });

    test('item memakai snapshot nama dan harga saat order dibuat', () {
      final order = OrderModel.fromJson(_orderJson);
      final item = order.items.single;

      expect(item.productName, 'Kopi Arabika Gayo 250g');
      expect(item.price, 75000);
      expect(item.quantity, 2);
      expect(order.totalQuantity, 2);
    });

    test('variant_options_snapshot berupa string JSON tetap terbaca', () {
      final order = OrderModel.fromJson({
        ..._orderJson,
        'items': [
          {
            'id': 1,
            'variant_options_snapshot': '{"warna":"Hitam"}',
            'quantity': 1,
          },
        ],
      });
      expect(order.items.single.optionLabel, 'Hitam');
    });

    test('daftar pesanan tanpa items tidak melempar', () {
      // GET /orders memang tidak mengirim items/status_history/refund.
      final json = Map<String, dynamic>.from(_orderJson)
        ..remove('items')
        ..remove('status_history')
        ..remove('refund');
      final order = OrderModel.fromJson(json);

      expect(order.items, isEmpty);
      expect(order.statusHistory, isEmpty);
      expect(order.totalQuantity, 0);
    });
  });

  group('OrderModel — aksi yang diizinkan', () {
    OrderModel withStatus(String status) =>
        OrderModel.fromJson({..._orderJson, 'status': status});

    test('pending boleh dibatalkan, tidak boleh diselesaikan', () {
      final order = withStatus('pending');
      expect(order.canCancel, isTrue);
      expect(order.canConfirmDelivery, isFalse);
      // Penjaga terpenting: /complete membalas HTML 200 kalau transisinya
      // tidak sah, jadi tombolnya tidak boleh muncul di status ini.
      expect(order.canComplete, isFalse);
    });

    test('shipped boleh dikonfirmasi diterima', () {
      final order = withStatus('shipped');
      expect(order.canConfirmDelivery, isTrue);
      expect(order.canComplete, isFalse);
      expect(order.canCancel, isFalse);
    });

    test('delivered boleh diselesaikan', () {
      final order = withStatus('delivered');
      expect(order.canComplete, isTrue);
      expect(order.canConfirmDelivery, isFalse);
    });

    test('cancelled tidak mengizinkan aksi apa pun', () {
      final order = withStatus('cancelled');
      expect(order.canCancel, isFalse);
      expect(order.canConfirmDelivery, isFalse);
      expect(order.canComplete, isFalse);
    });
  });

  group('OrderModel — tenggat bayar', () {
    test('pending dengan tenggat lewat tidak lagi menunggu pembayaran', () {
      final order = OrderModel.fromJson(
          {..._orderJson, 'payment_deadline': '2020-01-01 00:00:00'});
      expect(order.awaitsPayment, isFalse);
      expect(order.paymentTimeLeft, Duration.zero);
    });

    test('pending dengan tenggat di depan masih menunggu pembayaran', () {
      final order = OrderModel.fromJson(
          {..._orderJson, 'payment_deadline': '2099-01-01 00:00:00'});
      expect(order.awaitsPayment, isTrue);
      expect(order.paymentTimeLeft!.inDays, greaterThan(0));
    });
  });

  group('PaymentModel', () {
    const paymentJson = <String, dynamic>{
      'id': '14',
      'checkout_session_id': '456da069-c1c6-430a-9a84-c0e8267bbf4d',
      'order_id': null,
      'user_id': '186',
      'payment_method': 'qris',
      'provider': 'midtrans',
      'provider_reference': 'c8e0edd8-99e0-448e-aee9-96812f46b639',
      'amount': '3075000.00',
      'status': 'pending',
      'paid_at': null,
      'expired_at': '2099-01-01 00:00:00',
      'created_at': '2026-09-15 21:24:01',
    };

    test('transaksi terikat sesi checkout, bukan satu order', () {
      // order_id memang selalu null: satu pembayaran menutup semua order dari
      // satu sesi.
      final payment = PaymentModel.fromJson(paymentJson);
      expect(payment.checkoutSessionId, isNotEmpty);
      expect(payment.amount, 3075000);
      expect(payment.isPending, isTrue);
      expect(payment.isPaid, isFalse);
    });

    test('transaksi yang tenggatnya lewat ditandai expired', () {
      final payment = PaymentModel.fromJson(
          {...paymentJson, 'expired_at': '2020-01-01 00:00:00'});
      expect(payment.isExpired, isTrue);
    });

    test('transaksi lunas tidak dianggap expired walau tenggatnya lewat', () {
      final payment = PaymentModel.fromJson({
        ...paymentJson,
        'status': 'paid',
        'expired_at': '2020-01-01 00:00:00',
      });
      expect(payment.isPaid, isTrue);
      expect(payment.isExpired, isFalse);
    });
  });

  group('PaymentInstructionModel', () {
    test('QRIS dikenali dari qr_string', () {
      final instruction = PaymentInstructionModel.fromJson(const {
        'qr_string': '00020101021226350021ID.CO.MARKETPLACE.SIM',
        'expires_at': '2099-01-01 00:00:00',
      });
      expect(instruction.kind, PaymentInstructionKind.qris);
    });

    test('virtual account dikenali dari va_number', () {
      // Bentuknya berbeda dari QRIS, dan tidak ada field penanda jenis —
      // jadi jenisnya disimpulkan dari field mana yang terisi.
      final instruction = PaymentInstructionModel.fromJson(const {
        'va_number': '8808000000000015',
        'bank': 'BCA',
        'expires_at': '2099-01-01 00:00:00',
      });
      expect(instruction.kind, PaymentInstructionKind.virtualAccount);
      expect(instruction.bank, 'BCA');
    });

    test('bentuk yang belum dikenal jadi unknown, bukan melempar', () {
      final instruction =
          PaymentInstructionModel.fromJson(const {'redirect_url': 'https://x'});
      expect(instruction.kind, PaymentInstructionKind.unknown);
    });
  });
}
