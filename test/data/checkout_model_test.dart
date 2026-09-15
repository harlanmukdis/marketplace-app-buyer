/// Parsing model alamat dan checkout terhadap bentuk JSON yang **benar-benar
/// dikirim** server (15 September 2026).
///
/// Yang paling penting di sini adalah test zona waktu: satu respons checkout
/// memakai dua zona sekaligus, dan salah membacanya membuat hitung mundur
/// reservasi langsung tampak habis.
library;

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
  // UTC.
  'expires_at': '2026-09-15 01:07:59',
  // Waktu dinding server (WIB) — 7 jam lebih awal dari expires_at kalau
  // keduanya keliru dianggap sezona.
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

    test('alamat yang diterima server dengan field kosong ditandai tidak lengkap',
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
    test(
      '🔴 expires_at dibaca sebagai UTC, created_at sebagai WIB',
      () {
        final session = CheckoutSessionModel.fromJson(_sessionJson);

        // Kalau keduanya diperlakukan sama, selisihnya jadi -6:45 dan hitung
        // mundur langsung menunjukkan sesi kedaluwarsa.
        final gap = session.expiresAt!.difference(session.createdAt!);
        expect(gap, const Duration(minutes: 15));
      },
    );

    test('expires_at tidak digeser oleh zona waktu perangkat', () {
      final session = CheckoutSessionModel.fromJson(_sessionJson);
      expect(session.expiresAt!.toUtc(),
          DateTime.utc(2026, 9, 15, 1, 7, 59));
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
    test('order_ids berupa array — keranjang multi-toko pecah jadi banyak order',
        () {
      final result = CheckoutConfirmResult.fromJson(
          const {'order_ids': [1, 2], 'payment_transaction_id': 1});

      expect(result.orderIds, [1, 2]);
      expect(result.isMultiStore, isTrue);
      expect(result.paymentTransactionId, 1);
    });

    test('satu toko tetap berupa array berisi satu', () {
      final result = CheckoutConfirmResult.fromJson(
          const {'order_ids': [7], 'payment_transaction_id': 3});
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
}
