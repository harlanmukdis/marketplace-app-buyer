/// Parsing model keranjang terhadap bentuk JSON yang **benar-benar dikirim**
/// `GET /cart` dan `GET /cart/summary`.
///
/// Potongan di bawah disalin apa adanya dari server (14 September 2026).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';

/// Satu grup toko persis seperti dikirim `GET /cart`.
const _groupJson = <String, dynamic>{
  'store_name': 'Kedai Kopi Nusantara',
  'items': [
    {
      'id': '1',
      'cart_id': '1',
      'store_id': '1',
      'product_variant_id': '1',
      'warehouse_id': null,
      'quantity': '2',
      'is_selected': '1',
      'created_at': '2026-09-14 22:44:25',
      'sku': 'KOPI-GAYO-250',
      'price': '75000.00',
      'variant_options': null,
      'product_name': 'Kopi Arabika Gayo 250g',
      'store_name': 'Kedai Kopi Nusantara',
    },
  ],
};

void main() {
  group('CartItemModel', () {
    test('angka yang dikirim sebagai string terbaca sebagai angka', () {
      final item = CartItemModel.fromJson(
          Map<String, dynamic>.from(_groupJson['items'][0] as Map));

      expect(item.id, 1);
      expect(item.quantity, 2);
      expect(item.price, 75000);
      expect(item.productVariantId, 1);
    });

    test('is_selected "1"/"0" jadi bool, bukan string truthy', () {
      // "0" adalah string tidak kosong — kalau diperiksa sembarangan ia
      // truthy, dan baris yang tidak dicentang akan terlihat tercentang.
      final selected = CartItemModel.fromJson(const {'id': 1, 'is_selected': '1'});
      final unselected =
          CartItemModel.fromJson(const {'id': 2, 'is_selected': '0'});

      expect(selected.isSelected, isTrue);
      expect(unselected.isSelected, isFalse);
    });

    test('subtotal baris dihitung aplikasi, karena server tidak mengirimnya',
        () {
      final item = CartItemModel.fromJson(
          Map<String, dynamic>.from(_groupJson['items'][0] as Map));
      expect(item.lineTotal, 150000);
    });

    test('variant_options berupa string JSON terbaca jadi label', () {
      final item = CartItemModel.fromJson(const {
        'id': 3,
        'variant_options': '{"warna":"Hitam","ukuran":"L"}',
      });
      expect(item.optionLabel, 'Hitam · L');
    });

    test('tanpa opsi varian, labelnya kosong — bukan "null"', () {
      final item = CartItemModel.fromJson(
          Map<String, dynamic>.from(_groupJson['items'][0] as Map));
      expect(item.optionLabel, isEmpty);
    });
  });

  group('CartStoreGroup', () {
    test('store_id diturunkan dari item, karena grup tidak membawanya', () {
      // `GET /cart` hanya mengirim store_name di tingkat grup. Checkout butuh
      // id-nya sebagai kunci pemilihan kurir per toko.
      final group = CartStoreGroup.fromJson(_groupJson);

      expect(_groupJson.containsKey('store_id'), isFalse);
      expect(group.storeId, 1);
      expect(group.storeName, 'Kedai Kopi Nusantara');
    });

    test('grup kosong tidak melempar saat store_id dibaca', () {
      const group = CartStoreGroup(storeName: 'Toko');
      expect(group.storeId, isNull);
    });

    test('subtotal grup hanya menjumlahkan baris terpilih', () {
      final group = CartStoreGroup.fromJson(const {
        'store_name': 'Toko',
        'items': [
          {'id': 1, 'price': '1000.00', 'quantity': '2', 'is_selected': '1'},
          {'id': 2, 'price': '5000.00', 'quantity': '1', 'is_selected': '0'},
        ],
      });

      expect(group.selectedSubtotal, 2000);
      expect(group.selectedCount, 1);
      expect(group.allSelected, isFalse);
      expect(group.noneSelected, isFalse);
    });
  });

  group('CartSummaryModel', () {
    test('subtotal dan item_count datang sebagai ANGKA, bukan string', () {
      final summary = CartSummaryModel.fromJson(
          const {'subtotal': 3049000, 'item_count': 2});

      expect(summary.subtotal, 3049000);
      expect(summary.itemCount, 2);
      expect(summary.isEmpty, isFalse);
    });

    test('item_count menghitung BARIS, bukan unit', () {
      // Diverifikasi ke server: dua baris berisi 5 dan 1 unit tetap
      // menghasilkan item_count 2.
      final summary =
          CartSummaryModel.fromJson(const {'subtotal': 0, 'item_count': 2});
      expect(summary.itemCount, 2);
    });

    test('data null dari server jadi ringkasan kosong', () {
      expect(const CartSummaryModel().isEmpty, isTrue);
    });
  });

  group('AppliedVoucherModel', () {
    // ⚠️ Fixture ini **diturunkan dari sumber backend**
    // (`Cart_model::validate_voucher()`), bukan dari respons yang teramati:
    // tidak ada voucher yang di-seed, jadi `vouchers` selalu `[]` di dev.
    // Periksa ulang begitu ada voucher sungguhan.
    Map<String, dynamic> voucher({
      String category = 'store',
      String type = 'percentage',
      Object? amount = 15000,
    }) =>
        {
          'code': 'DISKON10',
          'category': category,
          'store_id': category == 'platform' ? null : '1',
          'discount_type': type,
          'discount_value': '10.00',
          'max_discount': '20000.00',
          'discount_amount': amount,
        };

    test('voucher toko yang benar-benar memotong harga', () {
      final v = AppliedVoucherModel.fromJson(voucher());
      expect(v.storeId, 1);
      expect(v.discountAmount, 15000);
      expect(v.reducesPayment, isTrue);
    });

    test('🔴 voucher ONGKIR membawa discount_amount null, bukan nol', () {
      // Nilainya baru ketahuan saat checkout karena ongkir belum dihitung di
      // keranjang. Menampilkan `null` sebagai `Rp0` akan membuat voucher
      // terlihat tidak berguna.
      final v = AppliedVoucherModel.fromJson(
          voucher(category: 'shipping', type: 'free_shipping', amount: null));

      expect(v.discountAmount, isNull);
      expect(v.isShipping, isTrue);
      expect(v.reducesPayment, isFalse);
    });

    test('🔴 voucher CASHBACK tidak memotong pembayaran sama sekali', () {
      // Nilainya jadi coins setelah pesanan selesai. Menampilkannya sebagai
      // potongan membuat total yang dilihat pembeli tidak cocok dengan yang
      // ditagih.
      final v = AppliedVoucherModel.fromJson(
          voucher(category: 'platform', type: 'cashback', amount: 0));

      expect(v.discountAmount, 0);
      expect(v.isCashback, isTrue);
      expect(v.reducesPayment, isFalse);
      expect(v.storeId, isNull, reason: 'voucher platform tanpa toko');
    });

    test('ringkasan menjumlahkan potongan, dan ongkir/cashback menyumbang nol',
        () {
      final summary = CartSummaryModel.fromJson({
        'subtotal': 100000,
        'item_count': 2,
        'vouchers': [
          voucher(),
          voucher(category: 'shipping', type: 'free_shipping', amount: null),
        ],
        // Dijumlah server, bukan aplikasi — dan ongkir tidak ikut.
        'discount_amount': 15000,
      });

      expect(summary.vouchers, hasLength(2));
      expect(summary.hasVouchers, isTrue);
      expect(summary.discountAmount, 15000);
      expect(summary.payableSubtotal, 85000);
    });

    test('potongan melebihi subtotal tidak menghasilkan angka negatif', () {
      final summary = CartSummaryModel.fromJson(
          const {'subtotal': 10000, 'item_count': 1, 'discount_amount': 50000});
      expect(summary.payableSubtotal, 0);
    });
  });
}
