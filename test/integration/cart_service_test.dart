/// Kontrak `/cart*` terhadap marketplace-api yang **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration/
/// ```
///
/// Butuh backend hidup dan database ter-seed. Test ini **mendaftarkan akun
/// baru** setiap dijalankan supaya keranjangnya bersih dan tidak bertabrakan
/// dengan sesi lain.
///
/// Sebagian besar yang dipatok di sini adalah **kelonggaran server**, bukan
/// fiturnya: kuantitas yang tidak divalidasi, mutasi ke baris asing yang tetap
/// dibalas 200, dan `data: null` pada PATCH. Kalau suatu saat backend
/// memperketatnya, test ini yang akan merah lebih dulu — dan itu kabar baik
/// yang perlu diketahui sebelum pembatasan di `CartCubit` dilonggarkan.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';

import 'support/seeded_product.dart';

void main() {
  late Dio dio;
  late CartService cart;
  late CatalogService catalog;

  /// Varian yang dipakai seluruh test; dicari yang masih berstok.
  late int variantId;

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    final auth = AuthService(dio);
    catalog = CatalogService(dio);
    cart = CartService(dio);

    final stamp = DateTime.now().microsecondsSinceEpoch;
    final email = 'uji.cart.$stamp@marketplace.local';
    final phone =
        '08${stamp.toString().substring(stamp.toString().length - 10)}';
    const password = 'RahasiaAman123';

    await auth.register(
      email: email,
      password: password,
      fullName: 'Uji Keranjang',
      phone: phone,
    );
    await loginAs(dio, email: email, password: password);

    // Bukan produk pertama: test ini mengonsumsi stok setiap kali dijalankan,
    // jadi harus mencari varian yang masih tersedia.
    variantId = (await findVariantWithStock(catalog)).variantId;
  });

  tearDown(() => dio.close(force: true));

  test('keranjang akun baru kosong', () async {
    final result = await cart.fetchCart();
    expect(result.data, isEmpty);

    final summary = await cart.fetchSummary();
    expect(summary.data.itemCount, 0);
    expect(summary.data.subtotal, 0);
  });

  test('menambah item mengelompokkannya per toko, dan grup tanpa store_id',
      () async {
    await cart.addItem(productVariantId: variantId, quantity: 2);
    final result = await cart.fetchCart();

    expect(result.data, hasLength(1));
    final group = result.data.first;
    expect(group.storeName, isNotEmpty);
    // Id toko hanya ada di item — model menurunkannya dari sana.
    expect(group.storeId, isNotNull);
    expect(group.items.single.quantity, 2);
    expect(group.items.single.productName, isNotEmpty);
  });

  test('varian yang sama DIGABUNG ke baris lama, bukan jadi baris baru',
      () async {
    await cart.addItem(productVariantId: variantId, quantity: 2);
    await cart.addItem(productVariantId: variantId, quantity: 3);

    final result = await cart.fetchCart();
    final items = result.data.expand((g) => g.items).toList();

    expect(items, hasLength(1), reason: 'bukan dua baris terpisah');
    expect(items.single.quantity, 5);
  });

  test('ringkasan hanya menghitung baris TERCENTANG', () async {
    await cart.addItem(productVariantId: variantId, quantity: 2);
    final items = (await cart.fetchCart()).data.expand((g) => g.items).toList();
    final itemId = items.single.id;

    final before = await cart.fetchSummary();
    expect(before.data.itemCount, 1);
    expect(before.data.subtotal, greaterThan(0));

    await cart.updateItem(itemId, isSelected: false);

    final after = await cart.fetchSummary();
    expect(after.data.itemCount, 0);
    expect(after.data.subtotal, 0);
  });

  test('PATCH membalas data null — hasilnya harus dibaca ulang', () async {
    await cart.addItem(productVariantId: variantId, quantity: 1);
    final itemId =
        (await cart.fetchCart()).data.expand((g) => g.items).single.id;

    final patch = await cart.updateItem(itemId, quantity: 4);
    expect(patch.data, isNull, reason: 'tidak ada keranjang di balasan PATCH');

    // Satu-satunya cara tahu perubahannya berhasil.
    final reread =
        (await cart.fetchCart()).data.expand((g) => g.items).single;
    expect(reread.quantity, 4);
  });

  test('🔴 server TIDAK memvalidasi kuantitas terhadap stok', () async {
    // Ini alasan CartCubit membatasi sendiri. Kalau suatu saat backend
    // memperketatnya, test ini merah dan pembatasan di aplikasi bisa
    // ditinjau ulang.
    await cart.addItem(productVariantId: variantId, quantity: 1);
    final itemId =
        (await cart.fetchCart()).data.expand((g) => g.items).single.id;

    await cart.updateItem(itemId, quantity: 999999);

    final reread =
        (await cart.fetchCart()).data.expand((g) => g.items).single;
    expect(reread.quantity, 999999,
        reason: 'stok produk jauh di bawah ini, tapi server menerimanya');
  });

  test('mutasi ke baris yang TIDAK ADA tetap dibalas 200', () async {
    // Karena itu status sukses bukan bukti sesuatu berubah.
    final patch = await cart.updateItem(99999999, quantity: 1);
    expect(patch.statusCode, 200);

    final delete = await cart.removeItem(99999999);
    expect(delete.statusCode, 200);
  });

  test('varian yang tidak ada dibalas VARIANT_NOT_FOUND', () async {
    // Satu-satunya validasi yang benar-benar dilakukan endpoint ini.
    await expectLater(
      cart.addItem(productVariantId: 99999999, quantity: 1),
      throwsA(anything),
    );
  });

  test('menghapus baris mengosongkan keranjang', () async {
    await cart.addItem(productVariantId: variantId, quantity: 1);
    final itemId =
        (await cart.fetchCart()).data.expand((g) => g.items).single.id;

    await cart.removeItem(itemId);

    expect((await cart.fetchCart()).data, isEmpty);
    expect((await cart.fetchSummary()).data.itemCount, 0);
  });

  test('voucher yang tidak berlaku dibalas VOUCHER_INVALID', () async {
    await cart.addItem(productVariantId: variantId, quantity: 1);
    await expectLater(
      cart.applyVoucher('KODE-TIDAK-ADA'),
      throwsA(anything),
    );
  });

  test('✅ melepas voucher SUDAH punya endpoint', () async {
    // `DELETE /cart/vouchers/{code}` baru ada sejak commit backend `90751bf`
    // bersama penumpukan voucher. Sebelumnya voucher yang terpasang tidak bisa
    // dilepas sama sekali, jadi aplikasi sengaja tidak menyediakan tombolnya.
    //
    // ⚠️ Jalur suksesnya **tidak bisa diuji di dev**: tidak ada voucher yang
    // di-seed (`GET /me/vouchers` mengembalikan `[]`), jadi memasang voucher
    // yang benar-benar berlaku mustahil. Yang dipatok di sini hanya bahwa
    // rutenya ada dan tidak melempar.
    await cart.addItem(productVariantId: variantId, quantity: 1);

    final result = await cart.removeVoucher('KODE-TIDAK-ADA');
    expect(result.statusCode, 200,
        reason: 'melepas kode yang tak pernah terpasang pun dibalas 200');
  });

  test('🔴 GET /cart/recommended-vouchers membalas 500 saat keranjang KOSONG',
      () async {
    // Bukan "endpointnya rusak" — syaratnya yang tidak terdokumentasi di
    // responsnya. `list_eligible_vouchers` menyusun `store_id IN ()` yang
    // bukan SQL sah saat tidak ada toko di keranjang. Karena itu layar
    // voucher nanti tidak boleh memanggilnya sebelum ada isi.
    await expectLater(
      dio.get<dynamic>('/cart/recommended-vouchers'),
      throwsA(anything),
    );
  });

  test('GET /cart/recommended-vouchers berhasil begitu keranjang terisi',
      () async {
    await cart.addItem(productVariantId: variantId, quantity: 1);

    final response = await dio.get<dynamic>('/cart/recommended-vouchers');
    expect(response.statusCode, 200);
    // `[]` selama belum ada voucher yang di-seed.
    expect(response.data['data'], isA<List<dynamic>>());
  });

  group('ringkasan membawa voucher terpasang', () {
    test('✅ summary kini punya `vouchers` dan `discount_amount`', () async {
      // Ditambahkan backend bersama penumpukan voucher (commit `90751bf`).
      // Catatan lama yang bilang summary "hanya berisi subtotal dan
      // item_count" sudah tidak berlaku.
      await cart.addItem(productVariantId: variantId, quantity: 2);

      final summary = await cart.fetchSummary();
      expect(summary.data.itemCount, 1);
      expect(summary.data.subtotal, greaterThan(0));
      expect(summary.data.vouchers, isEmpty,
          reason: 'belum ada voucher yang di-seed di dev');
      expect(summary.data.discountAmount, 0);
      expect(summary.data.payableSubtotal, summary.data.subtotal);
    });

    test('keranjang kosong pun membawa kedua field itu', () async {
      final summary = await cart.fetchSummary();
      expect(summary.data.isEmpty, isTrue);
      expect(summary.data.hasVouchers, isFalse);
      expect(summary.data.discountAmount, 0);
    });
  });
}
