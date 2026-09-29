/// Kontrak `/me/addresses` dan `/checkout/sessions*` terhadap marketplace-api
/// yang **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration/
/// ```
///
/// Test ini menjalankan **alur beli sungguhan sampai order terbentuk**, jadi ia
/// meninggalkan data di database dev: user, alamat, dan beberapa order. Itu
/// disengaja — satu-satunya cara memastikan bentuk respons konfirmasi benar
/// adalah benar-benar mengonfirmasinya.
///
/// Sejak backend `d9ecb33` checkout **wallet-only**, jadi akun pembelinya
/// disiapkan lewat `support/dev_db.dart` (PIN, saldo, kuota PIN) — tanpa itu
/// tidak ada pesanan yang bisa dibuat di dev.
///
/// 🔴 **Dua akun, bukan satu.** Batas 3 alamat (backend `c12228b`) ditambah
/// foreign key `RESTRICT` dari `checkout_sessions` membuat alamat yang pernah
/// dipakai checkout **tidak bisa dihapus** (500 HTML "Database Error"). Jadi
/// grup "alamat" — yang memang harus membuat alamat baru — memakai akun
/// `alamat` yang tidak pernah checkout dan dikosongkan tiap test, sementara
/// grup checkout memakai ulang alamat akun `belanja`.
///
/// Beberapa test di sini mematok **bug server**, bukan fitur. Kalau backend
/// memperbaikinya, test-test itu merah lebih dulu — dan jalan memutar di
/// aplikasi bisa dilepas.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';

import 'support/dev_db.dart';
import 'support/seeded_product.dart';

void main() {
  late Dio dio;
  late AddressService addresses;
  late CartService cart;
  late CatalogService catalog;
  late CheckoutService checkout;

  late int variantId;
  late int buyerId;

  setUp(() {
    dio = DioClient.createBare(Env.apiBaseUrl);
    addresses = AddressService(dio);
    cart = CartService(dio);
    catalog = CatalogService(dio);
    checkout = CheckoutService(dio);
  });

  tearDown(() => dio.close(force: true));

  /// Membuat alamat lengkap di akun yang sedang aktif dan mengembalikan id-nya.
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

  /// [count] alamat lengkap milik pembeli — **dipakai ulang**, dibuat hanya
  /// kalau kurang. Alamat yang pernah masuk sesi checkout tidak bisa dihapus,
  /// jadi membuat baru tiap test akan membentur batas 3 alamat.
  Future<List<int>> buyerAddresses(int count) async {
    final ids = (await addresses.list())
        .data
        .where((a) => a.isComplete)
        .map((a) => a.id)
        .toList();
    while (ids.length < count) {
      ids.add(await createAddress());
    }
    return ids.take(count).toList();
  }

  /// Akun pembeli bersama, keranjang kosong, Wallet siap bayar.
  Future<void> useBuyer() async {
    // Akun bersama, bukan akun baru per test — lihat `support/test_account.dart`
    // untuk alasannya (plafon 20 login per IP per 15 menit).
    await sharedAccount(dio, purpose: 'belanja');

    // Sesi checkout dibangun dari isi keranjang, jadi dikosongkan tiap test.
    for (final group in (await cart.fetchCart()).data) {
      for (final item in group.items) {
        await cart.removeItem(item.id);
      }
    }

    // Bukan produk pertama: test ini mengonsumsi stok setiap kali dijalankan,
    // jadi harus mencari varian yang masih tersedia.
    variantId = (await findVariantWithStock(catalog)).variantId;
    buyerId = await prepareWalletCheckout(dio);
  }

  /// Sesi berisi satu barang dengan kurir termurah terpilih — siap `confirm`.
  Future<String> readySession() async {
    final addressId = (await buyerAddresses(1)).single;
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
    return sessionId;
  }

  Future<DataError> confirmError(String sessionId, String pin) async {
    try {
      await checkout.confirm(sessionId, pin: pin);
    } on ApiException catch (e) {
      return e.error;
    }
    fail('confirm seharusnya ditolak');
  }

  group('alamat', () {
    // Akun terpisah yang tidak pernah checkout, jadi seluruh alamatnya selalu
    // bisa dihapus — batas 3 alamat tidak pernah terbentur.
    setUp(() async {
      await sharedAccount(dio, purpose: 'alamat');
      for (final address in (await addresses.list()).data) {
        await addresses.delete(address.id);
      }
    });

    test('🔴 maksimal 3 alamat per akun kini ditegakkan server', () async {
      // Backend `c12228b` (docs/22 #9). Kodenya VALIDATION_ERROR generik,
      // jadi AddressCubit.maxAddresses tetap menjaganya lebih dulu.
      for (var i = 0; i < 3; i++) {
        await createAddress();
      }
      try {
        await createAddress();
        fail('alamat keempat seharusnya ditolak');
      } on ApiException catch (e) {
        expect(e.error.code, ApiErrorCode.validationError);
        expect(e.error.statusCode, 422);
      }
    });

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
    setUp(useBuyer);

    test('id sesi berupa UUID, bukan integer', () async {
      final addressId = (await buyerAddresses(1)).single;
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
      final addressId = (await buyerAddresses(1)).single;
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      final session = await checkout.fetchSession(created.data.id);
      final gap =
          session.data.expiresAt!.difference(session.data.createdAt!);
      expect(gap, const Duration(minutes: 15));

      await checkout.cancel(created.data.id);
    });

    test('shipping-options berupa MAP berkunci store_id', () async {
      final addressId = (await buyerAddresses(1)).single;
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
      final [addressId, otherId] = await buyerAddresses(2);
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
      //
      // Alamat "orang lain" diambil dari akun `alamat` — dulu test ini
      // menebak id 1, yang di DB baru justru milik akun ini sendiri.
      final other = DioClient.createBare(Env.apiBaseUrl);
      int foreignId;
      try {
        await sharedAccount(other, purpose: 'alamat');
        final otherAddresses = AddressService(other);
        final owned = (await otherAddresses.list()).data;
        foreignId = owned.isNotEmpty
            ? owned.first.id
            : (await otherAddresses.create(
                label: 'Lain',
                recipientName: 'Orang Lain',
                phone: '081200000009',
                fullAddress: 'Jl. Lain No. 9',
                city: 'Bandung',
                province: 'Jawa Barat',
                postalCode: '40111',
              ))
                .data;
      } finally {
        other.close(force: true);
      }

      final addressId = (await buyerAddresses(1)).single;
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      for (final bad in [foreignId, 999999999]) {
        try {
          await checkout.changeAddress(created.data.id, addressId: bad);
          fail('alamat $bad seharusnya ditolak');
        } on ApiException catch (e) {
          expect(e.error.code, ApiErrorCode.validationError, reason: '$bad');
        }
      }

      await checkout.cancel(created.data.id);
    });

    test('membatalkan sesi membuatnya berstatus expired, bukan cancelled',
        () async {
      final addressId = (await buyerAddresses(1)).single;
      await cart.addItem(productVariantId: variantId, quantity: 1);
      final created = await checkout.createSession(addressId: addressId);

      await checkout.cancel(created.data.id);

      final session = await checkout.fetchSession(created.data.id);
      expect(session.data.status, 'expired');
      expect(session.data.isExpired, isTrue);
    });
  });

  group('alur lengkap sampai order', () {
    setUp(useBuyer);

    test('pilih kurir lalu konfirmasi dengan PIN menghasilkan order_ids',
        () async {
      final addressId = (await buyerAddresses(1)).single;
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

      final confirmed = await checkout.confirm(sessionId, pin: testWalletPin);
      expect(confirmed.data.orderIds, isNotEmpty);
      expect(confirmed.data.paymentTransactionId, isNotNull);
      // Balasannya hanya dua field itu — `paid`/`balance_after` yang dulu
      // diusulkan tidak dikirim; CheckoutRepositoryImpl yang melengkapinya.
      expect(confirmed.data.paid, isFalse);
      expect(confirmed.data.balanceAfter, isNull);

      // Dulu `awaiting_payment` (menunggu QRIS/VA); kini lunas saat itu juga.
      final after = await checkout.fetchSession(sessionId);
      expect(after.data.status, 'completed');
    });

    test('✅ saldo Wallet terdebit sebesar grand_total sesi', () async {
      final sessionId = await readySession();
      final total = (await checkout.fetchSession(sessionId)).data.grandTotal;
      final wallets = WalletService(dio);
      final before = (await wallets.fetchWallet()).data.balance;

      await checkout.confirm(sessionId, pin: testWalletPin);

      final after = (await wallets.fetchWallet()).data;
      expect(before - after.balance, total);
      final debit = after.transactions.first;
      expect(debit.typeCode, 'order_payment');
      expect(debit.type, WalletTxType.orderPayment,
          reason: 'jenis tak dikenal dianggap kredit — belanja jadi pemasukan');
      expect(debit.type.credit, isFalse);
    });

    test('🔴 PIN salah → CHECKOUT_CONFIRM_FAILED, sesi TETAP stock_reserved',
        () async {
      // Kode yang sama dengan sesi kedaluwarsa & sudah dikonfirmasi. Bedanya
      // hanya status sesi sesudahnya — itu yang dipakai
      // CheckoutRepositoryImpl untuk menerjemahkannya jadi INVALID_PIN.
      final sessionId = await readySession();

      final error = await confirmError(sessionId, '000000');

      expect(error.code, ApiErrorCode.checkoutConfirmFailed);
      expect(error.statusCode, 422);
      final session = (await checkout.fetchSession(sessionId)).data;
      expect(session.status, 'stock_reserved');
      await checkout.cancel(sessionId);
    });

    test('🔴 PIN BELUM DIBUAT dibalas kode yang sama dengan PIN salah',
        () async {
      // Tidak ada endpoint untuk menanyakan apakah PIN sudah ada, dan
      // penolakannya pun tak bisa dibedakan — pesan app menyebut keduanya.
      final sessionId = await readySession();
      await clearWalletPin(buyerId);

      final error = await confirmError(sessionId, testWalletPin);

      expect(error.code, ApiErrorCode.checkoutConfirmFailed);
      await checkout.cancel(sessionId);
    });

    test('saldo kurang → 422 INSUFFICIENT_BALANCE, details null', () async {
      final sessionId = await readySession();
      await setWalletBalance(buyerId, 0);

      final error = await confirmError(sessionId, testWalletPin);

      expect(error.code, ApiErrorCode.insufficientBalance);
      expect(error.statusCode, 422);
      // Selisihnya hanya tertulis di `message`, jadi layar menghitung sendiri
      // dari ringkasan saldo.
      expect(error.details, isNull);
      await checkout.cancel(sessionId);
    });

    test('konfirmasi kedua pada sesi yang sama ditolak', () async {
      final sessionId = await readySession();
      await checkout.confirm(sessionId, pin: testWalletPin);

      // Tidak ada Idempotency-Key di backend, jadi perlindungan satu-satunya
      // adalah pemeriksaan status ini — dan saldo tidak terdebit dua kali.
      final error = await confirmError(sessionId, testWalletPin);
      expect(error.code, ApiErrorCode.checkoutConfirmFailed);
    });

    test('checkout menghapus baris TERCENTANG saja dari keranjang', () async {
      // Baris yang tidak dicentang tidak ikut ke sesi checkout, jadi ia harus
      // tetap ada sesudahnya. Inilah alasan layar keranjang membaca ulang saat
      // kembali dari checkout, bukan sekadar menghapus semuanya sendiri.
      final addressId = (await buyerAddresses(1)).single;
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
      await checkout.confirm(sessionId, pin: testWalletPin);

      final remaining =
          (await cart.fetchCart()).data.expand((g) => g.items).toList();
      expect(remaining.map((i) => i.id), [unselected.id],
          reason: 'hanya baris tak tercentang yang boleh tersisa');
    });
  });
}
