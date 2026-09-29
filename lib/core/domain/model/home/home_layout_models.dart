import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/util/json_converters.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Susunan beranda dari `GET /home/layout` (home CMS, docs/16).
///
/// Endpoint-nya **sungguhan** dan publik, tapi di dev selalu `[]`: tabel
/// `home_layout_sections` belum punya seed. Karena itu model ini diturunkan
/// dari **kode backend** (`Home::assemble_layout()` + `Home_model`), bukan
/// dari respons yang teramati — dan beranda wajib tetap utuh tanpa satu pun
/// section.
///
/// Kenapa ditulis tangan, bukan freezed: satu entri section berbentuk
/// berbeda menurut `type` (`banners` / `categories` / `flash_sales` /
/// `products`), dan isi `products` pun berbeda menurut asalnya — baris
/// `products` mentah dari rekomendasi, baris `flash_sale_products` dari flash
/// sale, atau baris `campaign_products`. Parser toleran di sini lebih jujur
/// daripada tiga model generik yang separuh fieldnya selalu kosong.
class HomeSectionModel {
  const HomeSectionModel({
    required this.sectionId,
    required this.type,
    required this.typeCode,
    this.title = '',
    this.banners = const [],
    this.categories = const [],
    this.flashSales = const [],
    this.products = const [],
    this.companionBanner,
    this.campaign,
    this.categoryMode,
  });

  final int sectionId;
  final HomeSectionType type;

  /// Kode mentah; `section_type` adalah ENUM, tapi admin bisa menambah jenis
  /// baru lebih cepat daripada aplikasi diperbarui.
  final String typeCode;
  final String title;

  /// `hero_banner` / `promo_grid`.
  final List<HomeBannerModel> banners;

  /// `category_bar`.
  final List<HomeCategoryModel> categories;

  /// `flash_sale_widget`.
  final List<HomeFlashSaleModel> flashSales;

  /// `product_recommendation` — baris `products` mentah (tanpa `image_url`,
  /// karena `Recommendation_model` memakai `SELECT *` dari tabel `products`).
  final List<ProductModel> products;

  /// Banner "wadah" yang ditempel admin ke section ini (docs/16 §2.1).
  final HomeCompanionBanner? companionBanner;

  /// Kampanye yang ditempel ke section ini (`linked_campaign_id`).
  final HomeCampaignModel? campaign;

  /// `MANUAL_PINNED` / `AUTO_FAVORITE` untuk `category_bar`.
  final String? categoryMode;

  /// Section tanpa isi apa pun tidak digambar — admin bisa mengaktifkan
  /// section flash sale saat tidak ada flash sale yang berjalan, dan judul
  /// tanpa isi di beranda hanya membingungkan.
  bool get hasContent =>
      banners.isNotEmpty ||
      categories.isNotEmpty ||
      flashSales.any((f) => f.products.isNotEmpty) ||
      products.isNotEmpty ||
      (companionBanner?.banners.isNotEmpty ?? false) ||
      (campaign?.products.isNotEmpty ?? false);

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> rows(Object? raw) => raw is List
        ? raw.whereType<Map>().map((m) => Map<String, dynamic>.from(m)).toList()
        : const [];
    final code = asString(json['type']);
    final companion = json['companion_banner'];
    final campaign = json['campaign'];
    return HomeSectionModel(
      sectionId: asInt(json['section_id']),
      type: HomeSectionType.fromCode(code),
      typeCode: code,
      title: asString(json['title']),
      banners: rows(json['banners']).map(HomeBannerModel.fromJson).toList(),
      categories: rows(json['categories'])
          .map(HomeCategoryModel.fromJson)
          .where((c) => c.id > 0)
          .toList(),
      flashSales:
          rows(json['flash_sales']).map(HomeFlashSaleModel.fromJson).toList(),
      products: rows(json['products']).map(ProductModel.fromJson).toList(),
      companionBanner: companion is Map
          ? HomeCompanionBanner.fromJson(Map<String, dynamic>.from(companion))
          : null,
      campaign: campaign is Map
          ? HomeCampaignModel.fromJson(Map<String, dynamic>.from(campaign))
          : null,
      categoryMode: asStringOrNull(json['mode']),
    );
  }
}

/// Jenis section (`home_layout_sections.section_type`).
enum HomeSectionType {
  heroBanner('hero_banner'),
  promoGrid('promo_grid'),
  categoryBar('category_bar'),
  flashSaleWidget('flash_sale_widget'),
  productRecommendation('product_recommendation'),

  /// Jenis yang belum dikenal aplikasi — dilewati, bukan ditebak.
  unknown('');

  const HomeSectionType(this.code);

  final String code;

  static HomeSectionType fromCode(String? raw) {
    for (final t in values) {
      if (t.code == raw && t != unknown) return t;
    }
    return unknown;
  }
}

/// Satu baris `home_banners` (dikirim `SELECT *`).
class HomeBannerModel {
  const HomeBannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    required this.action,
    this.actionValue = '',
  });

  final int id;
  final String imageUrl;
  final String? title;
  final HomeBannerAction action;

  /// `category_id` / `product_id` / URL / `campaign_id` — **bukan** foreign
  /// key (docs/16 §2), jadi targetnya bisa saja sudah tidak ada.
  final String actionValue;

  /// Id numerik target untuk aksi CATEGORY/PRODUCT/CAMPAIGN.
  int? get targetId => asIntOrNull(actionValue);

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) =>
      HomeBannerModel(
        id: asInt(json['id']),
        imageUrl: asString(json['image_url']),
        title: asStringOrNull(json['title']),
        action: HomeBannerAction.fromCode(asStringOrNull(json['action_type'])),
        actionValue: asString(json['action_value']),
      );
}

/// `home_banners.action_type` — huruf besar, beda dari mayoritas ENUM API.
enum HomeBannerAction {
  category('CATEGORY'),
  product('PRODUCT'),
  url('URL'),
  campaign('CAMPAIGN'),
  none('');

  const HomeBannerAction(this.code);

  final String code;

  static HomeBannerAction fromCode(String? raw) {
    final upper = raw?.toUpperCase();
    for (final a in values) {
      if (a.code == upper && a != none) return a;
    }
    return none;
  }
}

/// `companion_banner`: `{placement, banners}`.
class HomeCompanionBanner {
  const HomeCompanionBanner({required this.placement, this.banners = const []});

  /// `top_strip` / `side_left` / `side_right`. Di layar 390dp ketiganya
  /// digambar di atas konten — tidak ada ruang untuk banner samping.
  final String placement;
  final List<HomeBannerModel> banners;

  factory HomeCompanionBanner.fromJson(Map<String, dynamic> json) {
    final raw = json['banners'];
    return HomeCompanionBanner(
      placement: asString(json['placement'], fallback: 'top_strip'),
      banners: raw is List
          ? raw
              .whereType<Map>()
              .map(
                  (m) => HomeBannerModel.fromJson(Map<String, dynamic>.from(m)))
              .toList()
          : const [],
    );
  }
}

/// Kategori di `category_bar`.
///
/// ⚠️ **Dua bentuk dari dua sumber.** Mode `MANUAL_PINNED` mengirim baris
/// `categories` utuh (`id`, `name`, `slug`, `icon_url`, …), sedangkan
/// `AUTO_FAVORITE` mengirim hasil `favorite_categories()` —
/// `{category_id, name, slug, score}` atau, saat cold-start,
/// `{category_id, name, slug, total_sold}`. Id-nya dibaca dari `category_id`
/// lalu jatuh ke `id`.
class HomeCategoryModel {
  const HomeCategoryModel(
      {required this.id, required this.name, this.slug = '', this.iconUrl});

  final int id;
  final String name;
  final String slug;
  final String? iconUrl;

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) =>
      HomeCategoryModel(
        id: asIntOrNull(json['category_id']) ?? asInt(json['id']),
        name: asString(json['name']),
        slug: asString(json['slug']),
        iconUrl: asStringOrNull(json['icon_url']),
      );
}

/// Satu flash sale aktif di `flash_sale_widget`.
class HomeFlashSaleModel {
  const HomeFlashSaleModel({
    required this.id,
    this.name = '',
    this.startAt,
    this.endAt,
    this.products = const [],
  });

  final int id;
  final String name;
  final DateTime? startAt;
  final DateTime? endAt;
  final List<HomePromoProductModel> products;

  factory HomeFlashSaleModel.fromJson(Map<String, dynamic> json) {
    final raw = json['products'];
    return HomeFlashSaleModel(
      id: asInt(json['id']),
      name: asString(json['name']),
      startAt: parseServerInstant(asStringOrNull(json['start_at'])),
      endAt: parseServerInstant(asStringOrNull(json['end_at'])),
      products: raw is List
          ? raw
              .whereType<Map>()
              .map((m) =>
                  HomePromoProductModel.fromJson(Map<String, dynamic>.from(m)))
              .where((p) => p.productId > 0)
              .toList()
          : const [],
    );
  }
}

/// Kampanye yang ditempel ke section.
class HomeCampaignModel {
  const HomeCampaignModel(
      {required this.id,
      this.name = '',
      this.type = '',
      this.products = const []});

  final int id;
  final String name;
  final String type;
  final List<HomePromoProductModel> products;

  factory HomeCampaignModel.fromJson(Map<String, dynamic> json) {
    final raw = json['products'];
    return HomeCampaignModel(
      id: asInt(json['id']),
      name: asString(json['name']),
      type: asString(json['type']),
      products: raw is List
          ? raw
              .whereType<Map>()
              .map((m) =>
                  HomePromoProductModel.fromJson(Map<String, dynamic>.from(m)))
              .toList()
          : const [],
    );
  }
}

/// Produk promo di flash sale atau kampanye.
///
/// Bentuk flash sale (`list_flash_sale_products`): `fsp.*` + `sku`,
/// `original_price`, `product_id`, `product_name`, `image_url`.
/// Bentuk kampanye non-flash-sale (`campaign_buyer_products`): `id`,
/// `special_price`, `product_variant_id`, `sku`, `price`, `product_name` —
/// ⚠️ **tanpa `product_id` maupun gambar**, jadi kartunya tidak bisa membuka
/// halaman produk ([canOpen] `false`).
class HomePromoProductModel {
  const HomePromoProductModel({
    required this.productId,
    required this.name,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.soldCount = 0,
    this.stockQuota,
  });

  /// `0` kalau baris tidak membawa `product_id` (kampanye biasa).
  final int productId;
  final String name;

  /// Harga yang dibayar: `flash_price` atau `special_price`, jatuh ke harga
  /// varian.
  final double price;

  /// Harga coret; `null` kalau tidak lebih mahal dari [price].
  final double? originalPrice;
  final String? imageUrl;
  final int soldCount;

  /// Kuota flash sale. `null` untuk kampanye.
  final int? stockQuota;

  bool get canOpen => productId > 0;

  /// Rasio terjual terhadap kuota, untuk bar "Terjual".
  double? get soldRatio {
    final quota = stockQuota;
    if (quota == null || quota <= 0) return null;
    return (soldCount / quota).clamp(0, 1).toDouble();
  }

  factory HomePromoProductModel.fromJson(Map<String, dynamic> json) {
    final base =
        asDoubleOrNull(json['original_price']) ?? asDoubleOrNull(json['price']);
    final promo = asDoubleOrNull(json['flash_price']) ??
        asDoubleOrNull(json['special_price']);
    final price = promo ?? base ?? 0;
    return HomePromoProductModel(
      productId: asInt(json['product_id']),
      name: asString(json['product_name'], fallback: asString(json['name'])),
      price: price,
      originalPrice: base != null && base > price ? base : null,
      imageUrl: asStringOrNull(json['image_url']),
      soldCount: asInt(json['sold_count']),
      stockQuota: asIntOrNull(json['stock_quota']),
    );
  }
}
