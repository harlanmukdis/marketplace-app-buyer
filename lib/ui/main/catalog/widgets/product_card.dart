import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Kartu produk untuk listing.
///
/// **Sengaja tidak menampilkan stok.** `GET /products` tidak mengirim stok
/// sama sekali, jadi kartu di sini tidak punya dasar untuk menulis "habis"
/// atau "tersisa N" — `product.stock` selalu `null` di listing. Label stok
/// hanya muncul di halaman detail.
///
/// Gambar juga tidak dikirim listing. Placeholder di bawah adalah keadaan
/// normal, bukan tanda gagal memuat, jadi jangan menggantinya dengan ikon
/// error.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final discount = product.discountPercent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _Thumbnail(product: product, discount: discount)),
          8.sbh,
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.styleMedium14(context).copyWith(
              color: dark ? kDarkSecondColor : kLightSecondColor,
            ),
          ),
          4.sbh,
          Text(
            formatRupiah(product.effectivePrice),
            style: AppStyles.styleSemiBold16(context).copyWith(
              color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
            ),
          ),
          if (product.strikethroughPrice != null)
            Text(
              formatRupiah(product.strikethroughPrice),
              style: AppStyles.styleRegular12(context).copyWith(
                color: dark ? kDarkThirdColor : kLightThirdColor,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          4.sbh,
          _RatingRow(product: product),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.product, required this.discount});

  final ProductModel product;
  final int? discount;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final url = product.primaryImageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url == null)
            Container(
              color: dark ? kDarkColor : kBorderColor,
              child: Icon(
                Icons.image_outlined,
                color: dark ? kDarkThirdColor : kLightThirdColor,
              ),
            )
          else
            Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: dark ? kDarkColor : kBorderColor,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: dark ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
            ),
          if (product.flashSale != null)
            const PositionedDirectional(
              top: 6,
              start: 6,
              child: _Badge(
                label: 'Flash Sale',
                color: kDeleteColor,
              ),
            )
          else if (discount != null && discount! > 0)
            PositionedDirectional(
              top: 6,
              start: 6,
              child: _Badge(label: '-$discount%', color: kWarningColor),
            ),
          if (_serverBadges.isNotEmpty)
            PositionedDirectional(
              top: 6,
              end: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final code in _serverBadges) ...[
                    _Badge(
                      label: ProductModel.badgeLabel(code)!,
                      color: _badgeColor(code),
                    ),
                    4.sbh,
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Badge dari server, dipangkas supaya tidak menumpuk di atas gambar.
  ///
  /// `sale` **selalu dibuang di kartu**: sudut kiri sudah menampilkan angka
  /// diskonnya persis (`-30%`), yang lebih berguna daripada label "Diskon"
  /// generik dari ambang 20% milik server. Dua badge sekaligus sudah cukup —
  /// lebih dari itu menutupi produknya sendiri.
  List<String> get _serverBadges =>
      product.knownBadges.where((c) => c != 'sale').take(2).toList();

  Color _badgeColor(String code) => switch (code) {
        'best_seller' => kSuccessColor,
        'hot' => kDeleteColor,
        _ => kLightPrimaryColor,
      };
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppStyles.styleSemiBold12(context).copyWith(color: kWhiteColor),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    // Produk baru berating 0 dari 0 ulasan. Menampilkan "0.0 ★" membuatnya
    // terlihat buruk padahal belum pernah dinilai — jadi ditulis apa adanya.
    if (!product.hasRating) {
      return Text(
        'Belum ada ulasan',
        style: AppStyles.styleRegular11(context).copyWith(color: muted),
      );
    }

    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
        2.sbw,
        Text(
          product.ratingAvg.toStringAsFixed(1),
          style: AppStyles.styleRegular11(context).copyWith(color: muted),
        ),
        4.sbw,
        Expanded(
          child: Text(
            '${product.soldCount} terjual',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.styleRegular11(context).copyWith(color: muted),
          ),
        ),
      ],
    );
  }
}
