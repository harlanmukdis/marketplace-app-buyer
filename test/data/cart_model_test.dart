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
}
