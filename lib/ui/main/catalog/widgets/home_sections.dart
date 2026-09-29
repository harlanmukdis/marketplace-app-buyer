import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/product_card.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Perender section home CMS (`GET /home/layout`, docs/16).
///
/// Satu widget per `section_type`. Aturan yang berlaku untuk semuanya:
///
/// * Section tanpa isi sudah disaring `HomeLayoutCubit` — di sini tidak ada
///   judul yang digambar tanpa konten.
/// * `companion_banner` digambar **di atas** kontennya apa pun
///   `placement`-nya: `side_left`/`side_right` dirancang untuk desktop, dan
///   di layar 390dp tidak ada ruang untuk banner samping.
/// * Banner aksi `URL` dan `CAMPAIGN` **tidak bisa diketuk**: aplikasi belum
///   punya pembuka tautan (`url_launcher` tidak terpasang) maupun layar
///   kampanye. Banner tetap tampil sebagai gambar.
class HomeCmsSection extends StatelessWidget {
  const HomeCmsSection({super.key, required this.section, required this.onCategory});

  final HomeSectionModel section;

  /// Menyaring beranda ke satu kategori (aksi banner `CATEGORY` dan
  /// `category_bar`).
  final ValueChanged<int> onCategory;

  @override
  Widget build(BuildContext context) {
    final companion = section.companionBanner;
    final title = section.title.trim();
    final Widget body = switch (section.type) {
      HomeSectionType.heroBanner => HomeHeroCarousel(banners: section.banners, onCategory: onCategory),
      HomeSectionType.promoGrid => _PromoGrid(banners: section.banners, onCategory: onCategory),
      HomeSectionType.categoryBar =>
        _CategoryBar(categories: section.categories, onCategory: onCategory),
      HomeSectionType.flashSaleWidget => _FlashSales(flashSales: section.flashSales),
      HomeSectionType.productRecommendation => _ProductRail(section: section),
      HomeSectionType.unknown => const SizedBox.shrink(),
    };
    // Banner hero tidak berjudul di desain; section lain memakai judul admin.
    final showTitle = title.isNotEmpty &&
        section.type != HomeSectionType.heroBanner &&
        section.type != HomeSectionType.flashSaleWidget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTitle) XpSectionHeader(title: title),
        if (!showTitle) const SizedBox(height: 16),
        if (companion != null && companion.banners.isNotEmpty) ...[
          _BannerStrip(banners: companion.banners, onCategory: onCategory),
          const SizedBox(height: 12),
        ],
        body,
        if (section.campaign != null && section.campaign!.products.isNotEmpty) ...[
          XpSectionHeader(title: section.campaign!.name.trim().isEmpty
              ? 'Kampanye'
              : section.campaign!.name.trim()),
          _PromoRail(products: section.campaign!.products),
        ],
      ],
    );
  }
}

void _openBanner(BuildContext context, HomeBannerModel banner, ValueChanged<int> onCategory) {
  final target = banner.targetId;
  if (target == null) return;
  switch (banner.action) {
    case HomeBannerAction.category:
      onCategory(target);
    case HomeBannerAction.product:
      context.push(AppRoutes.productDetailPath(target));
    case HomeBannerAction.url:
    case HomeBannerAction.campaign:
    case HomeBannerAction.none:
      break;
  }
}

bool _bannerTappable(HomeBannerModel banner) =>
    banner.targetId != null &&
    (banner.action == HomeBannerAction.category || banner.action == HomeBannerAction.product);

/// Hero carousel 16:9, r12, overlay gradasi + pil judul + chip "Lihat", dan
/// titik penanda (inventaris §3.1 no. 2).
///
/// Tanpa putar-otomatis: timer yang terus menjadwalkan animasi menguras
/// baterai di tab yang tidak dilihat, dan menggeser banner di bawah jari user.
class HomeHeroCarousel extends StatefulWidget {
  const HomeHeroCarousel({super.key, required this.banners, required this.onCategory});

  final List<HomeBannerModel> banners;
  final ValueChanged<int> onCategory;

  @override
  State<HomeHeroCarousel> createState() => _HomeHeroCarouselState();
}

class _HomeHeroCarouselState extends State<HomeHeroCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(XpRadius.l),
              child: PageView.builder(
                controller: _controller,
                itemCount: banners.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _HeroSlide(
                  banner: banners[i],
                  onTap: _bannerTappable(banners[i])
                      ? () => _openBanner(context, banners[i], widget.onCategory)
                      : null,
                ),
              ),
            ),
          ),
          if (banners.length > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < banners.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? XpColors.primary
                          : XpColors.textPlaceholder.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(XpRadius.full),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  const _HeroSlide({required this.banner, this.onTap});

  final HomeBannerModel banner;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = banner.title?.trim() ?? '';
    return Semantics(
      button: onTap != null,
      label: title.isEmpty ? 'Banner promo' : title,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _BannerImage(url: banner.imageUrl),
            if (title.isNotEmpty || onTap != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x99000000)],
                    ),
                  ),
                  child: Row(
                    children: [
                      if (title.isNotEmpty)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(XpRadius.full),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.local_fire_department,
                                    size: 13, color: XpColors.signatureGold),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: XpText.labelS(context).copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (onTap != null)
                        Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(XpRadius.full),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Lihat',
                                style: XpText.labelS(context).copyWith(
                                  color: const Color(0xff0056FE),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(Icons.arrow_forward, size: 13, color: Color(0xff0056FE)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: XpColors.sunken,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: XpColors.textPlaceholder),
    );
    if (url.trim().isEmpty) return placeholder;
    return Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => placeholder);
  }
}

/// Baris banner pendamping (`companion_banner`), maksimal dua berdampingan.
class _BannerStrip extends StatelessWidget {
  const _BannerStrip({required this.banners, required this.onCategory});

  final List<HomeBannerModel> banners;
  final ValueChanged<int> onCategory;

  @override
  Widget build(BuildContext context) {
    final shown = banners.take(2).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (var i = 0; i < shown.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _BannerTile(banner: shown[i], onCategory: onCategory, aspect: 2.4)),
          ],
        ],
      ),
    );
  }
}

class _BannerTile extends StatelessWidget {
  const _BannerTile({required this.banner, required this.onCategory, this.aspect = 1.6});

  final HomeBannerModel banner;
  final ValueChanged<int> onCategory;
  final double aspect;

  @override
  Widget build(BuildContext context) {
    final tappable = _bannerTappable(banner);
    return Semantics(
      button: tappable,
      label: banner.title ?? 'Banner promo',
      child: GestureDetector(
        onTap: tappable ? () => _openBanner(context, banner, onCategory) : null,
        child: AspectRatio(
          aspectRatio: aspect,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(XpRadius.l),
            child: _BannerImage(url: banner.imageUrl),
          ),
        ),
      ),
    );
  }
}

/// `promo_grid`: banner 2 kolom.
class _PromoGrid extends StatelessWidget {
  const _PromoGrid({required this.banners, required this.onCategory});

  final List<HomeBannerModel> banners;
  final ValueChanged<int> onCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          for (final banner in banners) _BannerTile(banner: banner, onCategory: onCategory),
        ],
      ),
    );
  }
}

/// `category_bar`: lingkaran kategori bergulir. Ikon dari `icon_url` kalau
/// ada (hanya mode `MANUAL_PINNED` yang membawanya), inisial kalau tidak.
class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.categories, required this.onCategory});

  final List<HomeCategoryModel> categories;
  final ValueChanged<int> onCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final category = categories[i];
          final icon = category.iconUrl?.trim() ?? '';
          return InkWell(
            borderRadius: BorderRadius.circular(XpRadius.l),
            onTap: () => onCategory(category.id),
            child: SizedBox(
              width: 68,
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(color: XpColors.primarySubtle, shape: BoxShape.circle),
                    child: icon.isEmpty
                        ? Text(
                            category.name.isEmpty ? '?' : category.name[0].toUpperCase(),
                            style: XpText.titleL(context).copyWith(color: XpColors.primary),
                          )
                        : Image.network(icon,
                            width: 28,
                            height: 28,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.category_outlined, color: XpColors.primary)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: XpText.caption(context).copyWith(color: XpColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// `flash_sale_widget`: satu rel per flash sale aktif, dengan tenggatnya.
class _FlashSales extends StatelessWidget {
  const _FlashSales({required this.flashSales});

  final List<HomeFlashSaleModel> flashSales;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final sale in flashSales.where((f) => f.products.isNotEmpty)) ...[
          XpSectionHeader(
            leading: Icon(Icons.bolt_rounded, color: XpColors.danger),
            title: sale.name.trim().isEmpty ? 'Flash Sale' : sale.name.trim(),
            subtitle: sale.endAt == null ? null : 'Berakhir ${formatServerDateTime(sale.endAt)}',
          ),
          _PromoRail(products: sale.products),
        ],
      ],
    );
  }
}

/// Rel produk promo (flash sale / kampanye).
class _PromoRail extends StatelessWidget {
  const _PromoRail({required this.products});

  final List<HomePromoProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => _PromoCard(product: products[i]),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.product});

  final HomePromoProductModel product;

  @override
  Widget build(BuildContext context) {
    final ratio = product.soldRatio;
    return SizedBox(
      width: 132,
      child: XpCard(
        padding: const EdgeInsets.all(8),
        onTap: product.canOpen
            ? () => context.push(AppRoutes.productDetailPath(product.productId))
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XpProductImage(url: product.imageUrl, size: 116),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: XpText.labelM(context),
            ),
            const Spacer(),
            Text(
              formatRupiah(product.price),
              style: XpText.priceS(context).copyWith(color: XpColors.danger),
            ),
            if (product.originalPrice != null)
              Text(
                formatRupiah(product.originalPrice!),
                style: XpText.caption(context).copyWith(
                  color: XpColors.textTertiary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            if (ratio != null) ...[
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(XpRadius.full),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 4,
                  backgroundColor: XpColors.dangerSubtle,
                  valueColor: AlwaysStoppedAnimation(XpColors.danger),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// `product_recommendation`: rel horizontal memakai [ProductCard] yang sama
/// dengan grid, supaya harga dan lencana tidak pernah berbeda.
///
/// ⚠️ Barisnya `SELECT *` dari `products` — **tanpa** `image_url`, jadi
/// kartunya bergambar placeholder sampai backend menyisipkannya seperti di
/// `GET /products`.
class _ProductRail extends StatelessWidget {
  const _ProductRail({required this.section});

  final HomeSectionModel section;

  static const double _cardWidth = 156;

  @override
  Widget build(BuildContext context) {
    // Tinggi sel dihitung dengan rumus grid yang sama (lebar dua kolom +
    // jarak 12), supaya isi kartu tidak terpotong.
    final delegate =
        productGridDelegate(_cardWidth * 2 + 12) as SliverGridDelegateWithFixedCrossAxisCount;
    final height = delegate.mainAxisExtent ?? 360;
    final products = section.products;
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => SizedBox(
          width: _cardWidth,
          child: ProductCard(
            product: products[i],
            onTap: () => context.push(AppRoutes.productDetailPath(products[i].id)),
          ),
        ),
      ),
    );
  }
}
