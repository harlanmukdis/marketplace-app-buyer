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
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';

import 'support/seeded_product.dart';

void main() {
  late Dio dio;
  late AddressService addresses;
  late CartService cart;
  late CatalogService catalog;
  late CheckoutService checkout;

  late int variantId;

  // Akun bersama, bukan akun baru per test — lihat `support/test_account.dart`
  // untuk alasannya (plafon 20 login per IP per 15 menit).
  //
  // Keranjangnya dikosongkan tiap test karena sesi checkout dibangun dari isi
  // keranjang. Sesi dan order yang tertinggal tidak perlu dibersihkan: tiap
  // test memakai id sesi yang baru dibuatnya sendiri.
  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    addresses = AddressService(dio);
    cart = CartService(dio);
    catalog = CatalogService(dio);
    checkout = CheckoutService(dio);

    await sharedAccount(dio, purpose: 'belanja');

    for (final group in (await cart.fetchCart()).data) {
      for (final item in group.items) {
        await cart.removeItem(item.id);
      }
    }

    // Bukan produk pertama: test ini mengonsumsi stok setiap kali dijalankan,
    // jadi harus mencari varian yang masih tersedia.
    variantId = (await findVariantWithStock(catalog)).variantId;
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

    test('✅ expires_at dan created_at kini SEZONA — selisihnya 15 menit',
        () async {
      // Dulu selisihnya 7 jam 15 menit: `created_at` waktu dinding WIB dari
      // MySQL, `expires_at` UTC dari PHP `date()`. Backend menyeragamkannya di
      // commit `93c6a14` dengan `date_default_timezone_set('Asia/Jakarta')`,
      // dan test inilah yang lebih dulu merah menunjukkannya — persis
      // fungsinya dibuat.
      //
      // Kalau suatu saat merah lagi dengan selisih 7:15:00, artinya driftnya
      // kembali dan converter khusus perlu dihidupkan lagi.
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

    test('✅ PATCH .../address mengganti alamat TANPA melepas reservasi stok',
        () async {
      // Dulu endpoint ini selalu 500 (controllernya membaca body PATCH dengan
      // `post()`), jadi aplikasi mengganti alamat dengan membatalkan sesi lalu
      // membuat yang baru. Diperbaiki backend di commit `8235c33`.
      final addressId = await createAddress();
      final otherId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      final patch = await checkout.changeAddress(
        created.data.id,
        addressId: otherId,
      );
      expect(patch.statusCode, 200);

      final session = await checkout.fetchSession(created.data.id);
      expect(session.data.shippingAddressId, otherId);
      // Yang paling berharga: reservasinya bertahan.
      expect(session.data.status, 'stock_reserved');

      await checkout.cancel(created.data.id);
    });

    test('🔴 alamat orang lain dan address_id yang hilang memakai KODE dan '
        'PESAN yang sama', () async {
      // Keduanya `422 VALIDATION_ERROR` dengan pesan "Alamat tidak ditemukan /
      // bukan milik akun ini". Tidak berdampak besar karena aplikasi hanya
      // menawarkan alamat milik user sendiri — tapi berarti kode itu di
      // praktiknya berarti "alamatnya baru saja terhapus".
      final addressId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      await expectLater(
        checkout.changeAddress(created.data.id, addressId: 1),
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

    test('checkout menghapus baris TERCENTANG saja dari keranjang', () async {
      // Baris yang tidak dicentang tidak ikut ke sesi checkout, jadi ia harus
      // tetap ada sesudahnya. Inilah alasan layar keranjang membaca ulang saat
      // kembali dari checkout, bukan sekadar menghapus semuanya sendiri.
      final addressId = await createAddress();
      await cart.addItem(productVariantId: variantId, quantity: 1);

      // Tambahkan satu baris lagi lalu lepas centangnya.
      //
      // Variannya harus benar-benar BERBEDA dari `variantId`: `POST
      // /cart/items` untuk varian yang sama menggabungkan kuantitas ke baris
      // lama alih-alih membuat baris baru, sehingga melepas centangnya akan
      // mengosongkan seluruh pilihan dan `createSession` dibalas "cart
      // kosong". Dulu ini kebetulan tidak pernah terjadi karena
      // `findVariantWithStock` selalu menunjuk produk lain — tapi ia bergeser
      // seiring stok terpakai, jadi kesamaannya harus dicegah eksplisit.
      int? otherVariantId;
      final listing = await catalog.fetchProducts(perPage: 20);
      for (final product in listing.data.reversed) {
        final detail = await catalog.fetchProduct(product.id);
        final candidate = detail.data.variants
            .where((v) => v.id != variantId && (v.stock ?? 0) > 0)
            .firstOrNull;
        if (candidate != null) {
          otherVariantId = candidate.id;
          break;
        }
      }
      expect(otherVariantId, isNotNull,
          reason: 'butuh dua varian berstok yang berbeda — seed ulang '
              'databasenya kalau katalognya sudah habis');
      await cart.addItem(productVariantId: otherVariantId!, quantity: 1);

      final before = (await cart.fetchCart()).data.expand((g) => g.items);
      final unselected =
          before.firstWhere((i) => i.productVariantId == otherVariantId);
      await cart.updateItem(unselected.id, isSelected: false);

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

      final remaining =
          (await cart.fetchCart()).data.expand((g) => g.items).toList();
      expect(remaining.map((i) => i.id), [unselected.id],
          reason: 'hanya baris tak tercentang yang boleh tersisa');
    });
  });
}
