/// Parsing model alamat dan checkout terhadap bentuk JSON yang **benar-benar
/// dikirim** server (15 September 2026).
///
/// Fixture zona waktunya **diperbarui 19 September 2026**. Dulu satu respons
/// checkout memakai dua zona sekaligus (`created_at` WIB, `expires_at` UTC);
/// backend menyeragamkannya di commit `93c6a14`, jadi stempel waktu di sini
/// disalin ulang dari respons yang sekarang.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';

/// Respons `GET /checkout/sessions/{id}` apa adanya.
const _sessionJson = <String, dynamic>{
  'id': '1b5cd5f3-0d6d-440b-8cb1-cf574a396520',
  'user_id': '93',
  'status': 'stock_reserved',
  'cart_snapshot':
      '[{"id":"25","cart_id":"29","store_id":"1","product_variant_id":"1","quantity":"2"},'
          '{"id":"26","cart_id":"29","store_id":"2","product_variant_id":"5","quantity":"1"}]',
  'shipping_address_id': '1',
  'selected_couriers': null,
  'applied_vouchers': null,
  'grand_total': '3049000.00',
  // Keduanya waktu dinding server (WIB) sejak commit backend `93c6a14`.
  'expires_at': '2026-09-15 08:07:59',
  'created_at': '2026-09-15 07:52:59',
};

void main() {
  group('AddressModel', () {
    test('field memakai full_address dan is_primary, bukan nama lama', () {
      final address = AddressModel.fromJson(const {
        'id': '1',
        'user_id': '93',
        'label': 'Rumah',
        'recipient_name': 'Probe',
        'phone': '081200000000',
        'full_address': 'Jl. Probe No. 1',
        'city': 'Jakarta Selatan',
        'province': 'DKI Jakarta',
        'postal_code': '12810',
        'latitude': null,
        'longitude': null,
        'is_primary': '1',
        'created_at': '2026-09-15 07:51:58',
      });

      expect(address.fullAddress, 'Jl. Probe No. 1');
      expect(address.isPrimary, isTrue);
      expect(address.isComplete, isTrue);
      expect(address.summary,
          'Jl. Probe No. 1, Jakarta Selatan, DKI Jakarta, 12810');
    });

    test(
        'alamat yang diterima server dengan field kosong ditandai tidak lengkap',
        () {
      // Server membalas 201 untuk ini. Aplikasi yang harus menolaknya.
      final address = AddressModel.fromJson(const {
        'id': '2',
        'label': 'Rumah',
        'recipient_name': 'Tanpa Label',
        'phone': '',
        'full_address': '',
        'city': '',
        'province': '',
        'postal_code': '',
        'is_primary': '0',
      });

      expect(address.isComplete, isFalse);
      expect(address.summary, isEmpty);
    });
  });

  group('primaryAddressOf', () {
    const lengkap = AddressModel(
      id: 1,
      recipientName: 'A',
      phone: '08',
      fullAddress: 'Jl',
      city: 'Kota',
      province: 'Prov',
      postalCode: '123',
      isPrimary: true,
    );
    const primaryTapiKosong = AddressModel(id: 2, isPrimary: true);
    const biasaLengkap = AddressModel(
      id: 3,
      recipientName: 'B',
      phone: '08',
      fullAddress: 'Jl',
      city: 'Kota',
      province: 'Prov',
      postalCode: '123',
    );

    test('memilih alamat primary yang LENGKAP walau ada primary lain', () {
      // Server membolehkan beberapa alamat bertanda primary sekaligus —
      // sudah diuji: menyetel is_primary pada alamat kedua tidak melepas
      // tanda pada yang pertama.
      expect(primaryAddressOf([primaryTapiKosong, lengkap])?.id, 1);
    });

    test('jatuh ke alamat lengkap kalau tidak ada primary yang lengkap', () {
      expect(primaryAddressOf([primaryTapiKosong, biasaLengkap])?.id, 2,
          reason: 'primary tetap menang atas kelengkapan pada langkah kedua');
    });

    test('daftar kosong menghasilkan null', () {
      expect(primaryAddressOf(const []), isNull);
    });
  });

  group('CheckoutSessionModel — zona waktu', () {
    test('expires_at dan created_at dibaca dengan zona yang SAMA', () {
      // Dulu tidak begitu: `expires_at` UTC sementara `created_at` WIB, dan
      // membacanya sezona menghasilkan selisih -6:45 sehingga hitung mundur
      // reservasi langsung menunjukkan sesi kedaluwarsa. Backend
      // menyeragamkannya di commit `93c6a14`.
      final session = CheckoutSessionModel.fromJson(_sessionJson);

      final gap = session.expiresAt!.difference(session.createdAt!);
      expect(gap, const Duration(minutes: 15));
    });

    test('waktu server dibaca sebagai instan yang benar, bukan angka mentah',
        () {
      // WIB = UTC+7, jadi 08:07:59 WIB adalah 01:07:59 UTC. Ini yang membuat
      // hitung mundur tetap benar di perangkat berzona waktu mana pun.
      final session = CheckoutSessionModel.fromJson(_sessionJson);
      expect(session.expiresAt!.toUtc(), DateTime.utc(2026, 9, 15, 1, 7, 59));
    });
  });

  group('CheckoutSessionModel — isi', () {
    test('cart_snapshot berupa string JSON dibaca jadi daftar item', () {
      final session = CheckoutSessionModel.fromJson(_sessionJson);
      expect(session.snapshotItems, hasLength(2));
      expect(session.snapshotItems.first['product_variant_id'], '1');
    });

    test('snapshot rusak tidak menggagalkan halaman', () {
      final session = CheckoutSessionModel.fromJson(
          {..._sessionJson, 'cart_snapshot': '{bukan json'});
      expect(session.snapshotItems, isEmpty);
      // Totalnya tetap sahih karena datang dari field terpisah.
      expect(session.grandTotal, 3049000);
    });

    test('grand_total string berdesimal terbaca sebagai angka', () {
      final session = CheckoutSessionModel.fromJson(_sessionJson);
      expect(session.grandTotal, 3049000);
    });

    test('toko diambil dari snapshot, dan semuanya belum punya kurir', () {
      final session = CheckoutSessionModel.fromJson(_sessionJson);
      expect(session.storeIds, {'1', '2'});
      expect(session.storesWithoutCourier, {'1', '2'});
      expect(session.canConfirm, isFalse);
    });

    test('siap dikonfirmasi setelah semua toko punya kurir', () {
      final session = CheckoutSessionModel.fromJson({
        ..._sessionJson,
        'expires_at': '2099-01-01 00:00:00',
        'selected_couriers': {
          '1': {'courier_code': 'jnt', 'service_code': 'ez'},
          '2': {'courier_code': 'jne', 'service_code': 'reg'},
        },
      });

      expect(session.storesWithoutCourier, isEmpty);
      expect(session.canConfirm, isTrue);
    });

    test(
      '🔴 selected_couriers yang dikirim sebagai STRING JSON tetap terbaca',
      () {
        // Bentuk asli sesudah kurir dipilih. Menyesatkan karena balasan
        // PATCH .../shipping mengirim field bernama sama sebagai objek
        // sungguhan — yang tersimpan di sesi justru string. Tanpa converter,
        // GET sesi melempar CastError persis di tengah alur checkout.
        final session = CheckoutSessionModel.fromJson({
          ..._sessionJson,
          'expires_at': '2099-01-01 00:00:00',
          'selected_couriers':
              '{"1":{"courier_code":"jnt","service_code":"ez"},'
                  '"2":{"courier_code":"jne","service_code":"reg"}}',
        });

        expect(session.selectedCouriers, isA<Map<String, dynamic>>());
        expect(session.storesWithoutCourier, isEmpty);
        expect(session.canConfirm, isTrue);
      },
    );

    test('sesi yang tenggatnya lewat tidak bisa dikonfirmasi', () {
      final session = CheckoutSessionModel.fromJson({
        ..._sessionJson,
        'expires_at': '2020-01-01 00:00:00',
        'selected_couriers': {
          '1': {'courier_code': 'jnt', 'service_code': 'ez'},
          '2': {'courier_code': 'jne', 'service_code': 'reg'},
        },
      });

      expect(session.timeLeft, Duration.zero);
      expect(session.canConfirm, isFalse);
    });

    test('sesi yang dibatalkan berstatus expired, bukan cancelled', () {
      final session =
          CheckoutSessionModel.fromJson({..._sessionJson, 'status': 'expired'});
      expect(session.isExpired, isTrue);
      expect(session.isStockReserved, isFalse);
    });
  });

  group('ShippingOptionModel', () {
    test('angka datang sebagai integer asli', () {
      final option = ShippingOptionModel.fromJson(const {
        'courier_code': 'jnt',
        'service_code': 'ez',
        'service_name': 'J&T EZ',
        'zone': 'cross_province',
        'weight_kg': 1,
        'cost': 17000,
        'etd_min_days': 3,
        'etd_max_days': 7,
      });

      expect(option.cost, 17000);
      expect(option.key, 'jnt/ez');
      expect(option.etdLabel, '3–7 hari');
    });

    test('estimasi satu angka kalau min dan max sama', () {
      final option = ShippingOptionModel.fromJson(
          const {'etd_min_days': 2, 'etd_max_days': 2});
      expect(option.etdLabel, '2 hari');
    });
  });

  group('CheckoutConfirmResult', () {
    test(
        'order_ids berupa array — keranjang multi-toko pecah jadi banyak order',
        () {
      final result = CheckoutConfirmResult.fromJson(const {
        'order_ids': [1, 2],
        'payment_transaction_id': 1
      });

      expect(result.orderIds, [1, 2]);
      expect(result.isMultiStore, isTrue);
      expect(result.paymentTransactionId, 1);
    });

    test('satu toko tetap berupa array berisi satu', () {
      final result = CheckoutConfirmResult.fromJson(const {
        'order_ids': [7],
        'payment_transaction_id': 3
      });
      expect(result.isMultiStore, isFalse);
    });
  });

  group('CheckoutSessionCreated', () {
    test('nilai uang datang sebagai angka di endpoint pembuatan', () {
      final created = CheckoutSessionCreated.fromJson(const {
        'id': '7bb7199a-02a2-43aa-9b0c-2204f375abf8',
        'subtotal': 3049000,
        'discount': 0,
        'grand_total': 3049000,
        'expires_at': '2099-01-01 00:00:00',
      });

      // Id-nya UUID, bukan integer.
      expect(created.id, '7bb7199a-02a2-43aa-9b0c-2204f375abf8');
      expect(created.grandTotal, 3049000);
      expect(created.timeLeft!.inDays, greaterThan(0));
    });
  });

  // Kontrak yang DIUSULKAN (belum dikirim server) — fixture-nya adalah spec
  // untuk backend, jadi model harus bisa membacanya apa adanya.
  group('kontrak Wallet (fixture pending_api/checkout)', () {
    Map<String, dynamic> fixture(String name) => Map<String, dynamic>.from(
        jsonDecode(File('assets/mock/pending_api/checkout/$name')
            .readAsStringSync()) as Map);

    test('wallet_summary.json', () {
      final model = WalletSummaryModel.fromJson(fixture('wallet_summary.json'));
      expect(model.walletBalance, 2500000);
      expect(model.grandTotal, 2543000);
      expect(model.shortfall, 43000);
      expect(model.canPay, isFalse);
      expect(model.minTopup, 10000);
      expect(model.pinSet, isTrue);
      expect(model.isInsufficient, isTrue);
      expect(model.suggestedTopup, 43000);
    });

    test('wallet_confirm.json', () {
      final result =
          CheckoutConfirmResult.fromJson(fixture('wallet_confirm.json'));
      expect(result.orderIds, [101, 102]);
      expect(result.paymentTransactionId, 55);
      expect(result.paid, isTrue);
      expect(result.walletTransactionId, 9001);
      expect(result.balanceAfter, 1457000);
    });

    test('confirm alur lama (tanpa field Wallet) berarti BELUM dibayar', () {
      final result = CheckoutConfirmResult.fromJson(const {
        'order_ids': [1],
        'payment_transaction_id': 1,
      });
      expect(result.paid, isFalse);
      expect(result.balanceAfter, isNull);
    });

    test('tinyint & string ikut terbaca', () {
      final model = WalletSummaryModel.fromJson(const {
        'wallet_balance': '750000.00',
        'can_pay': '0',
        'pin_set': '1',
      });
      expect(model.walletBalance, 750000);
      expect(model.canPay, isFalse);
      expect(model.pinSet, isTrue);
    });
  });
}
