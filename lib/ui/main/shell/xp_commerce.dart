import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Widget dagang bersama: chip stok, status penjual, rating, harga, dan status
/// pesanan — satu bentuk untuk semua layar (inventaris desain §2.4).

/// Chip mode stok. **Selalu tampil** di kartu produk dan baris keranjang.
class StockChip extends StatelessWidget {
  const StockChip({super.key, required this.mode, this.leadTimeDays});

  final StockMode mode;

  /// Untuk Pre-Order/Custom Order: "Pre-Order · 7 hari".
  final int? leadTimeDays;

  @override
  Widget build(BuildContext context) {
    final tone = switch (mode) {
      StockMode.ready || StockMode.infinite => XpStockTones.ready,
      StockMode.low => XpStockTones.low,
      StockMode.preOrder => XpStockTones.preOrder,
      StockMode.customOrder => XpStockTones.customOrder,
      StockMode.outOfStock || StockMode.discontinued => XpStockTones.unavailable,
    };
    final days = leadTimeDays;
    final withDays = (mode == StockMode.preOrder || mode == StockMode.customOrder) &&
        days != null &&
        days > 0;
    return XpPill(label: withDays ? '${mode.label} · $days hari' : mode.label, tone: tone);
  }
}

/// Lencana Primary Seller Status. Tidak menggambar apa pun untuk toko yang
/// belum terverifikasi.
class SellerStatusBadge extends StatelessWidget {
  const SellerStatusBadge({super.key, required this.status, this.compact = false});

  final SellerStatus status;

  /// `true` untuk keranjang: "OS" / "Verified" pendek.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = status.label;
    if (label == null) return const SizedBox.shrink();
    if (status.isOfficial) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: XpColors.navy,
          borderRadius: BorderRadius.circular(XpRadius.xs),
        ),
        child: Text(
          compact ? 'OS' : label,
          style: XpText.labelS(context).copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: XpColors.primarySubtle,
        borderRadius: BorderRadius.circular(XpRadius.xs),
      ),
      child: Text(label, style: XpText.labelS(context).copyWith(color: XpColors.primary)),
    );
  }
}

/// Lencana Xpedia Signature: hitam-emas, kecil, "never loud".
class SignatureBadge extends StatelessWidget {
  const SignatureBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Xpedia Signature — Lencana eksklusif untuk penjual berkinerja '
          'tinggi dengan layanan, produk, dan pengalaman pelanggan terbaik di Xpedia.',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: XpColors.signatureBlack,
          borderRadius: BorderRadius.circular(XpRadius.xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, size: 12, color: XpColors.signatureGold),
            const SizedBox(width: 4),
            Text('Xpedia Signature',
                style: XpText.labelS(context).copyWith(
                    color: XpColors.signatureGold,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
          ],
        ),
      ),
    );
  }
}

/// Satu bintang + nilai + jumlah terjual. **Tidak menggambar apa pun kalau
/// belum ada ulasan** — tidak pernah "0,0" atau bintang kosong.
class RatingLine extends StatelessWidget {
  const RatingLine({
    super.key,
    required this.rating,
    required this.ratingCount,
    this.soldCount = 0,
  });

  final double rating;
  final int ratingCount;
  final int soldCount;

  @override
  Widget build(BuildContext context) {
    final muted = XpText.caption(context).copyWith(color: XpColors.textTertiary);
    final hasRating = ratingCount > 0;
    if (!hasRating && soldCount <= 0) return const SizedBox.shrink();
    return Row(
      children: [
        if (hasRating) ...[
          const Icon(Icons.star_rounded, size: 14, color: XpColors.star),
          const SizedBox(width: 2),
          Text(formatRating(rating),
              style: XpText.caption(context).copyWith(fontWeight: FontWeight.w600)),
        ],
        if (soldCount > 0)
          Flexible(
            child: Text(
              hasRating ? ' (${formatCompact(soldCount)} terjual)' : '${formatCompact(soldCount)} terjual',
              style: muted,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}

/// Harga: harga coret di atas (Body/S tertiary) + persen diskon, lalu harga
/// yang dibayar. Aturannya tinggal di [ProductModel], bukan di sini.
class PriceBlock extends StatelessWidget {
  const PriceBlock({super.key, required this.product, this.large = false});

  final ProductModel product;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final strike = product.strikethroughPrice;
    final percent = product.discountPercent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (strike != null)
          Row(
            children: [
              Flexible(
                child: Text(
                  formatRupiah(strike),
                  maxLines: 1,
                  style: XpText.bodyS(context).copyWith(
                    color: XpColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              if (percent != null && percent > 0) ...[
                const SizedBox(width: 4),
                XpPill(
                  label: '-$percent%',
                  tone: XpTone(XpColors.dangerSubtle, XpColors.danger),
                ),
              ],
            ],
          ),
        Text(
          formatRupiah(product.effectivePrice),
          style: (large ? XpText.priceL(context) : XpText.priceM(context)),
        ),
      ],
    );
  }
}

/// Baris toko di kartu: status penjual + nama. Kosong selama toko belum
/// dimuat [StoreDirectoryCubit].
class StoreLine extends StatelessWidget {
  const StoreLine({super.key, required this.storeId});

  final int storeId;

  @override
  Widget build(BuildContext context) {
    final store = context.select<StoreDirectoryCubit, StoreModel?>((c) => c.state[storeId]);
    if (store == null) return const SizedBox(height: 16);
    final status = store.sellerStatus;
    return Row(
      children: [
        if (status != SellerStatus.unverified) ...[
          Icon(Icons.verified, size: 14, color: XpColors.primary),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            store.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: XpText.caption(context).copyWith(color: XpColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

/// Status pesanan dalam bahasa desain Xpedia.
///
/// Server tidak punya status "Menunggu Konfirmasi" — custom order tetap
/// `paid` sampai penjual mengonfirmasi, jadi [OrderModel.awaitsSellerConfirmation]
/// yang menentukannya. `processed` tidak pernah lagi ditulis server (rute
/// `accept` dihapus) tapi tetap dipetakan untuk pesanan lama.
({String label, XpTone tone}) orderStatusPresentation(OrderModel order) {
  if (order.awaitsSellerConfirmation) {
    return (label: 'Menunggu Konfirmasi', tone: XpOrderTones.awaitingConfirmation);
  }
  return switch (order.status) {
    OrderStatus.pending => (
        label: 'Menunggu Pembayaran',
        tone: const XpTone(Color(0xffFFF6E5), Color(0xff8C5002))
      ),
    OrderStatus.paid => (label: 'Pembayaran Berhasil', tone: XpOrderTones.paid),
    OrderStatus.processed ||
    OrderStatus.packed =>
      (label: 'Diproses', tone: XpOrderTones.processing),
    OrderStatus.shipped => (label: 'Dalam Pengiriman', tone: XpOrderTones.shipping),
    OrderStatus.delivered => (label: 'Diterima', tone: XpOrderTones.delivered),
    OrderStatus.completed => (label: 'Selesai', tone: XpOrderTones.completed),
    OrderStatus.cancelled => (label: 'Dibatalkan', tone: XpOrderTones.cancelled),
    OrderStatus.refundRequested => (label: 'Komplain Diajukan', tone: XpOrderTones.awaitingConfirmation),
    OrderStatus.refundApproved => (label: 'Refund Disetujui', tone: XpOrderTones.completed),
    OrderStatus.refundRejected => (label: 'Refund Ditolak', tone: XpOrderTones.cancelled),
    OrderStatus.unknown => (label: order.statusCode, tone: XpOrderTones.cancelled),
  };
}

class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final p = orderStatusPresentation(order);
    return XpPill(label: p.label, tone: p.tone, large: true);
  }
}

/// Gambar persegi dengan latar sunken dan placeholder ikon.
class XpProductImage extends StatelessWidget {
  const XpProductImage({super.key, required this.url, this.size, this.radius = XpRadius.m});

  final String? url;
  final double? size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: XpColors.sunken,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: XpColors.textPlaceholder),
    );
    final link = url;
    final image = (link == null || link.isEmpty)
        ? placeholder
        : Image.network(
            link,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => placeholder,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : placeholder,
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: size == null ? AspectRatio(aspectRatio: 1, child: image) : image,
      ),
    );
  }
}
