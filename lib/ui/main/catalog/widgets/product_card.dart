import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';

/// Kartu produk grid 2 kolom (design_buyer.md §4, `beranda_xpedia_buyer`).
///
/// Urutan isinya mengikuti layar Beranda Stitch: chip stok, nama (maks 2
/// baris), harga, rating, lalu toko. Hati wishlist di pojok kanan atas gambar
/// membaca [WishlistCubit] tingkat-app, jadi keadaannya sama di semua layar.
///
/// Nama toko **tidak** dikirim `GET /products`; [StoreLine] mengambilnya dari
/// `StoreDirectoryCubit`. Pemilik daftar produk wajib memanggil
/// `StoreDirectoryCubit.ensure` untuk id-id tokonya.
///
/// Stok: listing tidak membawa angka stok, tapi server kini **membuang produk
/// ready-stock yang habis dari listing** — jadi chip "Ready Stok" di sini
/// benar, bukan tebakan. Lihat [ProductModel.stockMode].
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      padding: const EdgeInsets.all(8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              XpProductImage(url: product.primaryImageUrl),
              PositionedDirectional(
                top: 6,
                end: 6,
                child: WishlistHeart(productId: product.id),
              ),
              if (product.flashSale != null)
                PositionedDirectional(
                  top: 6,
                  start: 6,
                  child: XpPill(
                    label: 'Flash Sale',
                    icon: Icons.bolt,
                    tone: XpTone(XpColors.danger, Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Satu baris tetap, bukan `Wrap`: chip yang turun baris akan
          // mendorong kartu melewati tinggi sel grid yang sudah dipatok.
          SizedBox(
            height: 22,
            child: Row(
              children: [
                Flexible(
                  child: StockChip(
                    mode: product.stockMode,
                    leadTimeDays: product.fulfillmentLeadTimeDays,
                  ),
                ),
                for (final label in product.badgeLabels.where((l) => l != 'Diskon').take(1)) ...[
                  const SizedBox(width: 4),
                  Flexible(
                    child: XpPill(
                        label: label,
                        tone: const XpTone(Color(0xffEFF1F4), Color(0xff4B5563))),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: XpText.titleM(context),
            ),
          ),
          const SizedBox(height: 4),
          PriceBlock(product: product),
          const SizedBox(height: 4),
          RatingLine(
            rating: product.ratingAvg,
            ratingCount: product.ratingCount,
            soldCount: product.soldCount,
          ),
          const SizedBox(height: 4),
          StoreLine(storeId: product.storeId),
        ],
      ),
    );
  }
}

/// Tombol hati wishlist berbentuk lingkaran putih di atas gambar.
///
/// Area sentuh 48dp, visual 28dp — desain memakai 28 dan menyarankan
/// memperbesar area sentuhnya.
class WishlistHeart extends StatelessWidget {
  const WishlistHeart({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    final saved = context.select<WishlistCubit, bool>((c) => c.state.contains(productId));
    return Semantics(
      button: true,
      label: saved ? 'Hapus dari wishlist' : 'Simpan ke wishlist',
      child: InkResponse(
        radius: 24,
        onTap: () => context.read<WishlistCubit>().toggle(productId),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: saved ? XpColors.danger : const Color(0xff4B5563),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid 2 kolom bersama untuk [ProductCard].
///
/// Tinggi tiap sel dihitung dari lebar yang tersedia — gambar persegi ikut
/// melebar di layar besar — ditambah tinggi tetap bagian teks. Tinggi tetap
/// membuat baris rata walau satu produk punya harga coret dan yang lain
/// tidak. Pakai di dalam `SliverLayoutBuilder`/`LayoutBuilder` dengan
/// `crossAxisExtent` sesudah padding.
SliverGridDelegate productGridDelegate(double availableWidth) {
  const gap = 12.0;
  final cellWidth = (availableWidth - gap) / 2;
  final imageSide = cellWidth - 16; // padding kartu 8 kiri-kanan
  // chip 22 + nama 40 + harga ≤48 (baris coret 18 + harga 22, plus pil
  // diskon 22 yang lebih tinggi dari teks coret) + rating 18 + toko 16 +
  // jarak & padding. Sisa 16dp untuk skala font ±20% `getResponsiveFontSize`.
  const textBlock = 8 + 22 + 6 + 40 + 4 + 48 + 4 + 18 + 4 + 16 + 16 + 16;
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: gap,
    crossAxisSpacing: gap,
    mainAxisExtent: imageSide + textBlock,
  );
}
