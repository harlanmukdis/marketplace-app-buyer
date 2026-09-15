/// Kontrak `/me/addresses` dan `/checkout/sessions*` terhadap marketplace-api
/// yang **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration/
/// ```
///
/// Test ini menjalankan **alur beli sungguhan sampai order terbentuk**, jadi ia
/// meninggalkan data di database dev: satu user, satu alamat, dan beberapa
/// order. Itu disengaja — satu-satunya cara memastikan bentuk respons
/// konfirmasi benar adalah benar-benar mengonfirmasinya.
///
/// Beberapa test di sini mematok **bug server**, bukan fitur: alamat tanpa
/// validasi, dan `PATCH .../address` yang selalu 500. Kalau backend
/// memperbaikinya, test-test itu merah lebih dulu — dan jalan memutar di
/// aplikasi bisa dilepas.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';

void main() {
  late Dio dio;
  late AddressService addresses;
  late CartService cart;
  late CatalogService catalog;
  late CheckoutService checkout;

  late int variantId;

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    final auth = AuthService(dio);
    addresses = AddressService(dio);
    cart = CartService(dio);
    catalog = CatalogService(dio);
    checkout = CheckoutService(dio);

    final stamp = DateTime.now().microsecondsSinceEpoch;
    final email = 'uji.checkout.$stamp@marketplace.local';
    final phone =
        '08${stamp.toString().substring(stamp.toString().length - 10)}';
    const password = 'RahasiaAman123';

    await auth.register(
      email: email,
      password: password,
      fullName: 'Uji Checkout',
      phone: phone,
    );
    final session = await auth.login(email: email, password: password);
    dio.options.headers['Authorization'] =
        'Bearer ${session.data.accessToken}';

    final listing = await catalog.fetchProducts(perPage: 1);
    final detail = await catalog.fetchProduct(listing.data.first.id);
    variantId = detail.data.variants.first.id;
  });

  tearDown(() => dio.close(force: true));

  /// Membuat alamat lengkap dan mengembalikan id-nya.
  Future<int> createAddress() async {
    final created = await addresses.create(
      label: 'Rumah',
      recipientName: 'Uji Checkout',
      phone: '081200000000',
      fullAddress: 'Jl. Uji No. 1',
      city: 'Jakarta Selatan',
      province: 'DKI Jakarta',
      postalCode: '12810',
      isPrimary: true,
    );
    return created.data;
  }

  group('alamat', () {
    test('membuat dan membaca alamat', () async {
      final id = await createAddress();
      expect(id, greaterThan(0));

      final list = await addresses.list();
      final address = list.data.singleWhere((a) => a.id == id);
      expect(address.fullAddress, 'Jl. Uji No. 1');
      expect(address.isComplete, isTrue);
      expect(address.isPrimary, isTrue);
    });

    test('🔴 server MENERIMA alamat tanpa field wajib', () async {
      // Ini alasan AddressCubit memvalidasi sendiri sebelum mengirim.
      final created = await addresses.create(
        label: '',
        recipientName: 'Tanpa Apa-apa',
        phone: '',
        fullAddress: '',
        city: '',
        province: '',
        postalCode: '',
      );

      final list = await addresses.list();
      final address = list.data.singleWhere((a) => a.id == created.data);
      expect(address.isComplete, isFalse,
          reason: 'alamat ini tersimpan padahal tidak bisa dikirimi paket');
    });

    test('🔴 menandai alamat kedua sebagai utama TIDAK melepas yang pertama',
        () async {
      // Karena itu ada `primaryAddressOf`, dan AddressRepositoryImpl.setPrimary
      // melepas tanda lama satu per satu.
      final first = await createAddress();
      final second = await createAddress();

      final list = await addresses.list();
      final primaries =
          list.data.where((a) => a.isPrimary).map((a) => a.id).toSet();
      expect(primaries, containsAll([first, second]));
    });

    test('PATCH membalas data null dan bersifat parsial', () async {
      final id = await createAddress();
      final patch = await addresses.update(id, label: 'Kantor');
      expect(patch.data, isNull);

      final list = await addresses.list();
      final address = list.data.singleWhere((a) => a.id == id);
      expect(address.label, 'Kantor');
      // Field lain tidak ikut terhapus.
      expect(address.city, 'Jakarta Selatan');
    });
  });

  group('sesi checkout', () {
    test('id sesi berupa UUID, bukan integer', () async {
      final addressId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);

      final created = await checkout.createSession(addressId: addressId);
      expect(created.data.id, hasLength(36));
      expect(int.tryParse(created.data.id), isNull);

      await checkout.cancel(created.data.id);
    });

    test('🔴 expires_at UTC dan created_at WIB berselisih tepat 15 menit',
        () async {
      // Kalau backend menyeragamkan zona waktunya, test ini merah — dan
      // ServerUtcDateTimeJson harus ditinjau ulang.
      final addressId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      final session = await checkout.fetchSession(created.data.id);
      final gap =
          session.data.expiresAt!.difference(session.data.createdAt!);
      expect(gap, const Duration(minutes: 15));

      await checkout.cancel(created.data.id);
    });

    test('shipping-options berupa MAP berkunci store_id', () async {
      final addressId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      final options = await checkout.fetchShippingOptions(created.data.id);
      expect(options.data, isA<Map<String, List<dynamic>>>());
      expect(options.data.keys, isNotEmpty);
      expect(options.data.values.first, isNotEmpty);
      expect(options.data.values.first.first.cost, greaterThan(0));

      await checkout.cancel(created.data.id);
    });

    test('🔴 PATCH .../address SELALU gagal — itu sebabnya ganti alamat '
        'dilakukan dengan membuat sesi baru', () async {
      final addressId = await createAddress();
      final otherId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      // Controllernya membaca body PATCH dengan `post()`, sehingga
      // shipping_address_id disetel NULL dan ditolak foreign key.
      await expectLater(
        dio.patch<dynamic>(
          '/checkout/sessions/${created.data.id}/address',
          data: {'address_id': otherId},
        ),
        throwsA(anything),
      );

      await checkout.cancel(created.data.id);
    });

    test('membatalkan sesi membuatnya berstatus expired, bukan cancelled',
        () async {
      final addressId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      await checkout.cancel(created.data.id);

      final session = await checkout.fetchSession(created.data.id);
      expect(session.data.status, 'expired');
      expect(session.data.isExpired, isTrue);
    });
  });

  group('alur lengkap sampai order', () {
    test('pilih kurir lalu konfirmasi menghasilkan order_ids', () async {
      final addressId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);
      final sessionId = created.data.id;

      final options = await checkout.fetchShippingOptions(sessionId);
      final selection = <String, CourierChoice>{
        for (final entry in options.data.entries)
          if (entry.value.isNotEmpty)
            entry.key: (
              courierCode: entry.value.first.courierCode,
              serviceCode: entry.value.first.serviceCode,
            ),
      };

      final shipping = await checkout.setShipping(sessionId, selection);
      expect(shipping.data.shippingTotal, greaterThan(0));
      // Total sudah termasuk ongkir.
      expect(shipping.data.grandTotal,
          greaterThanOrEqualTo(shipping.data.shippingTotal));

      final confirmed =
          await checkout.confirm(sessionId, paymentMethod: 'qris');
      expect(confirmed.data.orderIds, isNotEmpty);
      expect(confirmed.data.paymentTransactionId, isNotNull);

      final after = await checkout.fetchSession(sessionId);
      expect(after.data.status, 'awaiting_payment');
    });

    test('konfirmasi kedua pada sesi yang sama ditolak', () async {
      final addressId = await createAddress();
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
      await checkout.confirm(sessionId, paymentMethod: 'qris');

      // Tidak ada Idempotency-Key di backend, jadi perlindungan satu-satunya
      // adalah pemeriksaan status ini.
      await expectLater(
        checkout.confirm(sessionId, paymentMethod: 'qris'),
        throwsA(anything),
      );
    });

    test('🔴 keranjang TIDAK dikosongkan setelah checkout', () async {
      // Layar keranjang membaca ulang saat kembali dari checkout; kalau
      // backend mulai mengosongkannya, test ini merah dan perilaku itu bisa
      // disederhanakan.
      final addressId = await createAddress();
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
      await checkout.confirm(sessionId, paymentMethod: 'qris');

      final remaining = await cart.fetchCart();
      expect(remaining.data, isNotEmpty,
          reason: 'barang yang sudah dipesan masih tertinggal di keranjang');
    });
  });
}
