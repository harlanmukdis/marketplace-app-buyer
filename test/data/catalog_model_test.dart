/// Parsing model katalog terhadap bentuk JSON yang **benar-benar dikirim**
/// marketplace-api.
///
/// Potongan JSON di bawah disalin apa adanya dari respons server (14 September
/// 2026), bukan dikarang dari dokumen — termasuk kejanggalannya: angka sebagai
/// string, `variant_options` sebagai string berisi JSON, `stock` sebagai
/// integer asli, dan `flash_sale` yang key-nya absen saat tidak promo.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_facets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';

/// Item `GET /products` — tanpa gambar, tanpa stok, tanpa varian.
const _listItemJson = <String, dynamic>{
  'id': '1',
  'store_id': '1',
  'name': 'Kopi Arabika Gayo 250g',
  'slug': 'kopi-arabika-gayo-250g',
  'product_type': 'physical',
  'description': 'Kopi arabika single origin dari dataran tinggi Gayo.',
  'base_price': '75000.00',
  'compare_at_price': null,
  'weight_grams': '300',
  'status': 'active',
  'sold_count': '0',
  'view_count': '0',
  'rating_avg': '0.00',
  'rating_count': '0',
  'created_at': '2026-09-14 20:17:14',
};

/// Respons `GET /products/{id}` — lengkap.
const _detailJson = <String, dynamic>{
  ..._listItemJson,
  'stock': 150,
  'variants': [
    {
      'id': '1',
      'product_id': '1',
      'sku': 'KOPI-GAYO-250',
      'variant_options': null,
      'price': '75000.00',
      'weight_grams': '300',
      'image_url': null,
      'is_active': '1',
      'stock': 150,
    },
  ],
  'images': [
    {
      'id': '1',
      'product_id': '1',
      'image_url': 'https://picsum.photos/seed/kopi-1/600/600',
      'sort_order': '0',
    },
  ],
  'couriers': [],
};

void main() {
  group('ProductModel', () {
    test('item listing terbaca walau tanpa gambar, stok, dan varian', () {
      final product = ProductModel.fromJson(_listItemJson);

      expect(product.id, 1);
      expect(product.basePrice, 75000);
      expect(product.weightGrams, 300);
      expect(product.variants, isEmpty);
      expect(product.images, isEmpty);
      expect(product.primaryImageUrl, isNull);
    });

    test(
      'stok null di listing TIDAK dianggap habis',
      () {
        // Kalau ini gagal, seluruh kartu di listing akan berlabel "habis":
        // `GET /products` memang tidak pernah mengirim stok.
        final listing = ProductModel.fromJson(_listItemJson);
        expect(listing.stock, isNull);
        expect(listing.isOutOfStock, isFalse);
        expect(listing.isLowStock, isFalse);
      },
    );

    test('stok nol yang benar-benar dikirim dianggap habis', () {
      final product =
          ProductModel.fromJson({..._detailJson, 'stock': 0});
      expect(product.isOutOfStock, isTrue);
    });

    test('detail membawa stok sebagai integer asli, bukan string', () {
      final product = ProductModel.fromJson(_detailJson);
      expect(product.stock, 150);
      expect(product.variants.single.stock, 150);
    });

    test('flash_sale yang absen jadi null, bukan melempar', () {
      final product = ProductModel.fromJson(_detailJson);
      expect(_detailJson.containsKey('flash_sale'), isFalse);
      expect(product.flashSale, isNull);
      expect(product.effectivePrice, 75000);
      expect(product.strikethroughPrice, isNull);
      expect(product.isDiscounted, isFalse);
    });

    test('flash sale menang atas harga dasar dan yang dicoret harga dasar', () {
      final product = ProductModel.fromJson({
        ..._detailJson,
        'compare_at_price': '90000.00',
        'flash_sale': {
          'flash_price': 59000,
          'sold_count': 12,
          'stock_quota': 100,
          'ends_at': '2026-09-20 23:59:59',
        },
      });

      expect(product.effectivePrice, 59000);
      // Bukan compare_at_price: saat flash sale aktif, yang dicoret adalah
      // harga dasar yang sedang digantikan.
      expect(product.strikethroughPrice, 75000);
      expect(product.discountPercent, 21);
    });

    test('compare_at_price dipakai kalau tidak ada flash sale', () {
      final product = ProductModel.fromJson({
        ..._detailJson,
        'compare_at_price': '100000.00',
      });
      expect(product.strikethroughPrice, 100000);
      expect(product.discountPercent, 25);
    });

    test('compare_at_price yang lebih rendah diabaikan, bukan jadi diskon minus',
        () {
      final product = ProductModel.fromJson({
        ..._detailJson,
        'compare_at_price': '50000.00',
      });
      expect(product.strikethroughPrice, isNull);
      expect(product.discountPercent, isNull);
    });

    test('gambar utama diambil dari sort_order terkecil, bukan urutan array',
        () {
      final product = ProductModel.fromJson({
        ..._detailJson,
        'images': [
          {'id': '2', 'image_url': 'https://x/kedua.jpg', 'sort_order': '1'},
          {'id': '1', 'image_url': 'https://x/utama.jpg', 'sort_order': '0'},
        ],
      });
      expect(product.primaryImageUrl, 'https://x/utama.jpg');
    });
  });

  group('ProductVariantModel.variantOptions', () {
    test('terbaca walau dikirim sebagai STRING berisi JSON', () {
      // Bentuk asli dari server: '{"warna":"Hitam"}', bukan objek.
      final variant = ProductVariantModel.fromJson({
        'id': '3',
        'sku': 'KAOS-HITAM',
        'variant_options': '{"warna":"Hitam"}',
        'price': '89000.00',
        'is_active': '1',
        'stock': 4,
      });

      expect(variant.variantOptions, {'warna': 'Hitam'});
      expect(variant.optionLabel, 'Hitam');
    });

    test('objek JSON biasa juga diterima', () {
      final variant = ProductVariantModel.fromJson({
        'id': '4',
        'variant_options': {'ukuran': 'L'},
      });
      expect(variant.optionLabel, 'L');
    });

    test('beberapa opsi digabung jadi satu label', () {
      final variant = ProductVariantModel.fromJson({
        'id': '5',
        'variant_options': '{"warna":"Merah","ukuran":"XL"}',
      });
      expect(variant.optionLabel, 'Merah · XL');
    });

    test('JSON rusak jadi null, tidak menggagalkan seluruh produk', () {
      final variant = ProductVariantModel.fromJson({
        'id': '6',
        'variant_options': '{bukan json',
      });
      expect(variant.variantOptions, isNull);
      expect(variant.optionLabel, isEmpty);
    });
  });

  group('ProductFacets', () {
    test('rating memakai `count` integer, category memakai `cnt` string', () {
      // Dua bentuk berbeda dalam satu blok meta — ini yang bikin satu parser
      // seragam salah.
      final facets = ProductFacets.fromMeta(const {
        'facets': {
          'rating': [
            {'min_rating': 5, 'count': 0},
            {'min_rating': 4, 'count': 3},
          ],
          'category': [
            {'category_id': '48', 'cnt': '1'},
          ],
        },
      });

      expect(facets.ratings.length, 2);
      expect(facets.ratings[1].minRating, 4);
      expect(facets.ratings[1].count, 3);
      expect(facets.categories.single.categoryId, 48);
      expect(facets.categories.single.count, 1);
    });

    test('tanpa q, facet category tidak ada dan itu bukan error', () {
      final facets = ProductFacets.fromMeta(const {
        'facets': {
          'rating': [
            {'min_rating': 1, 'count': 19},
          ],
        },
      });
      expect(facets.categories, isEmpty);
      expect(facets.ratings, isNotEmpty);
    });

    test('meta tanpa facets sama sekali jadi kosong', () {
      expect(ProductFacets.fromMeta(const {'total': 19}).isEmpty, isTrue);
      expect(ProductFacets.fromMeta(const {}).isEmpty, isTrue);
    });
  });

  group('CategoryModel', () {
    test('pohon bersarang terbaca beserta anaknya', () {
      final category = CategoryModel.fromJson(const {
        'id': '1',
        'parent_id': null,
        'name': 'Elektronik & Gadget',
        'slug': 'elektronik',
        'level': '0',
        'sort_order': '1',
        'is_active': '1',
        'children': [
          {
            'id': '101',
            'parent_id': '1',
            'name': 'Handphone & Tablet',
            'slug': 'handphone-tablet',
            'level': '1',
            'is_active': '1',
          },
        ],
      });

      expect(category.id, 1);
      expect(category.parentId, isNull);
      expect(category.hasChildren, isTrue);
      expect(category.children.single.parentId, 1);
    });

    test('findById menelusuri sampai anak', () {
      final roots = [
        CategoryModel.fromJson(const {
          'id': '1',
          'name': 'Elektronik',
          'children': [
            {'id': '101', 'name': 'Handphone'},
          ],
        }),
      ];

      expect(findCategoryById(roots, 101)?.name, 'Handphone');
      expect(findCategoryById(roots, 999), isNull);
    });
  });

  group('FlashSaleModel', () {
    test('progres terjual dan sisa kuota', () {
      final sale = FlashSaleModel.fromJson(const {
        'flash_price': 59000,
        'sold_count': 25,
        'stock_quota': 100,
      });
      expect(sale.soldRatio, 0.25);
      expect(sale.remainingQuota, 75);
      expect(sale.isSoldOut, isFalse);
    });

    test('kuota nol tidak membuat pembagian dengan nol', () {
      final sale = FlashSaleModel.fromJson(const {'stock_quota': 0});
      expect(sale.soldRatio, 0);
      expect(sale.isSoldOut, isFalse);
    });

    test('terjual melebihi kuota tidak menghasilkan sisa negatif', () {
      final sale = FlashSaleModel.fromJson(
          const {'sold_count': 120, 'stock_quota': 100});
      expect(sale.remainingQuota, 0);
      expect(sale.soldRatio, 1);
      expect(sale.isSoldOut, isTrue);
    });
  });
}
