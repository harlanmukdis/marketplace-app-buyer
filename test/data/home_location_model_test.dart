/// Model home CMS, master lokasi, dan sesi live.
///
/// Home CMS **belum pernah teramati berisi** di dev (`GET /home/layout` →
/// `[]`), jadi potongan JSON di sini dirakit dari kode backend
/// (`Home::assemble_layout()`, `Home_model`, `Promotion_model`,
/// `Recommendation_model`) — bukan karangan bebas. Kalau backend mengubah
/// bentuknya, test ini yang harus diperbarui lebih dulu.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';
import 'package:marketplace_app_member/core/domain/model/location/location_models.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';

/// Satu layout lengkap, bentuk per `section_type` seperti dirakit server.
const _layout = [
  {
    'section_id': 4,
    'type': 'product_recommendation',
    'title': 'Trending Products',
    'companion_banner': {
      'placement': 'top_strip',
      'banners': [
        {
          'id': '1',
          'section_id': '1',
          'image_url': 'https://cdn.x/b1.jpg',
          'title': 'Promo Merdeka',
          'action_type': 'CATEGORY',
          'action_value': '2',
          'sort_order': '0',
          'is_enabled': '1',
        },
      ],
    },
    // `SELECT *` dari `products` — tanpa image_url.
    'products': [
      {'id': '7', 'store_id': '3', 'name': 'Kopi', 'base_price': '25000.00', 'status': 'active'},
    ],
  },
  {
    'section_id': 2,
    'type': 'category_bar',
    'title': 'Kategori Pilihan',
    'mode': 'AUTO_FAVORITE',
    // favorite_categories(): cold-start membawa total_sold, bukan score.
    'categories': [
      {'category_id': '2', 'name': 'Handphone', 'slug': 'handphone', 'total_sold': '12'},
    ],
  },
  {
    'section_id': 5,
    'type': 'category_bar',
    'title': 'Pilihan Admin',
    'mode': 'MANUAL_PINNED',
    // pinned_categories(): baris `categories` utuh.
    'categories': [
      {'id': '9', 'parent_id': null, 'name': 'Cat', 'slug': 'cat', 'icon_url': 'https://cdn.x/c.png'},
    ],
  },
  {
    'section_id': 3,
    'type': 'flash_sale_widget',
    'title': 'Flash Sale Hari Ini',
    'flash_sales': [
      {
        'id': 1,
        'name': 'Kilat',
        'start_at': '2026-09-29 10:00:00',
        'end_at': '2026-09-29 14:00:00',
        'products': [
          {
            'id': '5',
            'flash_sale_id': '1',
            'product_variant_id': '11',
            'flash_price': '9000.00',
            'stock_quota': '10',
            'sold_count': '4',
            'sku': 'K-1',
            'original_price': '15000.00',
            'product_id': '7',
            'product_name': 'Kopi',
            'image_url': null,
          },
        ],
      },
    ],
  },
  {
    'section_id': 6,
    'type': 'hero_banner',
    'title': 'Hero',
    'campaign': {
      'id': 3,
      'name': 'Promo Merdeka',
      'type': 'thematic',
      // campaign_buyer_products() non-flash-sale: tanpa product_id.
      'products': [
        {'id': '1', 'special_price': '20000.00', 'product_variant_id': '11', 'sku': 'K-1', 'price': '25000.00', 'product_name': 'Kopi'},
      ],
    },
    'banners': [
      {'id': '2', 'image_url': 'https://cdn.x/h.jpg', 'title': null, 'action_type': 'url', 'action_value': 'https://x.id'},
    ],
  },
  {'section_id': 8, 'type': 'jenis_baru', 'title': 'Belum dikenal'},
];

void main() {
  group('HomeSectionModel', () {
    final sections = [for (final s in _layout) HomeSectionModel.fromJson(s)];

    test('rekomendasi: produk mentah + banner pendamping', () {
      final rec = sections[0];
      expect(rec.type, HomeSectionType.productRecommendation);
      expect(rec.products.single.id, 7);
      expect(rec.products.single.primaryImageUrl, isNull);
      expect(rec.companionBanner!.placement, 'top_strip');
      final banner = rec.companionBanner!.banners.single;
      expect(banner.action, HomeBannerAction.category);
      expect(banner.targetId, 2);
    });

    test('category_bar: id dari category_id (AUTO) maupun id (PINNED)', () {
      expect(sections[1].categories.single.id, 2);
      expect(sections[1].categoryMode, 'AUTO_FAVORITE');
      expect(sections[2].categories.single.id, 9);
      expect(sections[2].categories.single.iconUrl, 'https://cdn.x/c.png');
    });

    test('flash sale: harga flash, harga coret, rasio terjual', () {
      final sale = sections[3].flashSales.single;
      expect(sale.endAt, DateTime.utc(2026, 9, 29, 7));
      final p = sale.products.single;
      expect(p.productId, 7);
      expect(p.price, 9000);
      expect(p.originalPrice, 15000);
      expect(p.soldRatio, closeTo(0.4, 1e-9));
      expect(p.canOpen, isTrue);
    });

    test('kampanye biasa tanpa product_id tidak bisa dibuka', () {
      final hero = sections[4];
      final p = hero.campaign!.products.single;
      expect(p.price, 20000);
      expect(p.originalPrice, 25000);
      expect(p.canOpen, isFalse);
      // action_type huruf kecil tetap dikenali.
      expect(hero.banners.single.action, HomeBannerAction.url);
    });

    test('jenis tak dikenal jadi unknown dan tanpa isi', () {
      expect(sections[5].type, HomeSectionType.unknown);
      expect(sections[5].hasContent, isFalse);
      expect(sections.take(5).every((s) => s.hasContent), isTrue);
    });
  });

  test('master lokasi memakai province_name/city_name/active', () {
    final province = ProvinceModel.fromJson(const {
      'id': '3', 'province_name': 'Jawa Barat', 'active': '1', 'created_date': '2026-09-01 10:00:00',
    });
    final city = CityModel.fromJson(const {
      'id': '12', 'city_name': 'Bandung', 'province_id': '3', 'active': '1',
    });
    expect(province.name, 'Jawa Barat');
    expect(province.active, isTrue);
    expect(city.name, 'Bandung');
    expect(city.provinceId, 3);
  });

  test('alamat membaca city_id opsional', () {
    expect(AddressModel.fromJson(const {'id': '1', 'city_id': '12'}).cityId, 12);
    expect(AddressModel.fromJson(const {'id': '1', 'city_id': null}).cityId, isNull);
  });

  test('sesi live (usulan) mengikuti kolom live_sessions', () {
    final s = LiveSessionModel.fromJson(const {
      'id': '9001', 'store_id': '1', 'title': 'T', 'status': 'live', 'viewer_count': '1240',
      'started_at': '2026-09-29 09:00:00', 'promo_label': 'Diskon', 'sold_count': '86',
    });
    expect(s.isLive, isTrue);
    expect(s.viewerCount, 1240);
    expect(s.startedAt, DateTime.utc(2026, 9, 29, 2));
  });

  test('performance: online_status + last_active_at (usulan), null tetap null', () {
    final perf = StorePerformanceModel.fromJson(const {
      'service_performance': {
        'response_rate_percent': 80,
        'avg_reply_minutes': 4.5,
        'online_status': 'offline',
        'last_active_at': '2026-09-29 13:55:00',
      },
    });
    expect(perf.hasOnlineStatus, isTrue);
    expect(perf.isOnline, isFalse);
    expect(perf.lastActiveAt, DateTime.utc(2026, 9, 29, 6, 55));
    expect(perf.avgReplyMinutes, 5);

    final real = StorePerformanceModel.fromJson(const {
      'service_performance': {'online_status': null},
    });
    expect(real.hasOnlineStatus, isFalse);
  });
}
