import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/product_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/shipping_estimate_section.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/variant_sheet.dart';
import 'package:marketplace_app_member/ui/main/chat/widgets/chat_with_store_button.dart';
import 'package:marketplace_app_member/ui/main/review/widgets/product_reviews_section.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/store_products_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/store_profile_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/widgets/store_widgets.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Halaman detail produk (`detail_produk_jbl_tune_770nc` + tambahan b08).
///
/// Isi produknya berasal dari satu `GET /products/{id}` — tidak ada
/// panggilan susulan untuk gambar, varian, stok, maupun kurir. Yang ditembak
/// terpisah hanyalah hal di luar produk: profil + kinerja toko (publik),
/// estimasi ongkir, ulasan, dan produk lain dari toko yang sama.
///
/// Sengaja **tidak** dibangun dari desain karena API tidak punya datanya:
/// grid keunggulan produk (ANC, baterai, …), tab Spesifikasi/Panduan Garansi
/// dan daftar "Dalam Kemasan", kartu "Jaminan Belanja Xpedia Guarantee"
/// (merek di luar daftar design_buyer.md §6), Tanya Jawab, unduh dokumen,
/// kota toko, serta tombol bagikan. Status "Online" toko tampil di kartu toko
/// dari kontrak usulan `online_status` (🔶 mock di debug, berlencana
/// "Simulasi").
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailCubit(productId)..load(),
      child: _ProductDetailBody(productId: productId),
    );
  }
}

class _ProductDetailBody extends StatefulWidget {
  const _ProductDetailBody({required this.productId});

  final int productId;

  @override
  State<_ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<_ProductDetailBody> {
  @override
  void initState() {
    super.initState();
    // Hati di app bar butuh wishlist penuh — tidak ada endpoint "cek satu
    // produk". Cubitnya tingkat-app; cukup dimuat kalau belum pernah siap.
    final wishlist = context.read<WishlistCubit>();
    if (wishlist.state is! WishlistReady) wishlist.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: XpStackAppBar(
        title: 'Detail Produk',
        actions: [
          _WishlistAction(productId: widget.productId),
          const CartActionButton(),
        ],
      ),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        buildWhen: (a, b) => a.runtimeType != b.runtimeType || b is ProductDetailLoaded,
        builder: (context, state) {
          return switch (state) {
            ProductDetailLoading() => const Center(child: CircularProgressIndicator()),
            ProductDetailError(:final error) => XpEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Produk belum bisa dimuat',
                message: errorMessageFor(context, error),
                actionLabel: 'Coba Lagi',
                onAction: () => ProductDetailCubit.get(context).load(forceRefresh: true),
              ),
            ProductDetailLoaded() => _StoreScope(
                storeId: state.product.storeId,
                child: _Loaded(state: state),
              ),
          };
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is! ProductDetailLoaded) return const SizedBox.shrink();
          return _BuyBar(state: state);
        },
      ),
    );
  }
}

/// Menyediakan profil toko dan produk lain dari toko itu, sekali per toko.
///
/// Dipisah dari [_Loaded] supaya pembaruan produk (ganti varian, baca ulang
/// stok) tidak membuat ulang kedua cubit — dan menembak ulang tokonya.
class _StoreScope extends StatelessWidget {
  const _StoreScope({required this.storeId, required this.child});

  final int storeId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey(storeId),
      providers: [
        BlocProvider(create: (_) => StoreProfileCubit(storeId)..load()),
        BlocProvider(create: (_) => StoreProductsCubit(storeId, pageSize: 10)..load()),
      ],
      child: BlocListener<StoreProfileCubit, StoreProfileState>(
        // Toko yang sudah dimuat di sini dipakai ulang kartu produk di layar
        // lain — satu request lebih sedikit untuk StoreDirectoryCubit.
        listener: (context, state) {
          if (state is StoreProfileLoaded) {
            context.read<StoreDirectoryCubit>().put(state.store);
          }
        },
        child: child,
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    final variant = state.selectedVariant;
    const gap = SizedBox(height: 12);

    return RefreshIndicator(
      onRefresh: () async {
        await ProductDetailCubit.get(context).refresh();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _Gallery(product: product),
          _InfoBlock(state: state),
          if (product.flashSale != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _FlashSaleBlock(flashSale: product.flashSale!),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShippingEstimateSection(
                  productId: product.id,
                  variantId: variant?.id,
                  origin: variant?.shippingOrigin ?? '',
                  courierNames: [
                    for (final c in product.couriers)
                      if (c.isActive && c.name.trim().isNotEmpty) c.name,
                  ],
                ),
                if (_showVariantRow(product, variant)) ...[
                  gap,
                  _VariantRow(state: state),
                ],
                gap,
                _StoreCard(storeId: product.storeId, productId: product.id),
                if ((product.description ?? '').trim().isNotEmpty) ...[
                  gap,
                  _DescriptionCard(text: product.description!.trim()),
                ],
                gap,
                ProductReviewsSection(productId: product.id),
              ],
            ),
          ),
          _RelatedProducts(currentProductId: product.id),
        ],
      ),
    );
  }

  static bool _showVariantRow(ProductModel product, ProductVariantModel? variant) =>
      product.variants.where((v) => v.isActive).length > 1 ||
      (variant?.optionLabel.isNotEmpty ?? false);
}

/// Produk bisa dimasukkan keranjang sama sekali: modenya bisa dibeli **dan**
/// masih ada varian berstok. Mode stok saja tidak cukup — checkout tetap
/// mereservasi stok gudang untuk Pre-Order sekalipun (lihat
/// [purchasableStockOf]).
bool _isPurchasable(ProductModel product) =>
    product.stockMode.isPurchasable &&
    product.variants.any((v) => purchasableStockOf(v) > 0);

class _Gallery extends StatefulWidget {
  const _Gallery({required this.product});

  final ProductModel product;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.product.images]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final urls = sorted.map((i) => i.imageUrl).where((u) => u.trim().isNotEmpty).toList();
    if (urls.isEmpty && widget.product.primaryImageUrl != null) {
      urls.add(widget.product.primaryImageUrl!);
    }

    Widget placeholder() => Container(
          color: XpColors.sunken,
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, size: 48, color: XpColors.textPlaceholder),
        );

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: XpColors.surface,
        child: urls.isEmpty
            ? placeholder()
            : Stack(
                children: [
                  PageView.builder(
                    itemCount: urls.length,
                    onPageChanged: (index) => setState(() => _page = index),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Image.network(
                        urls[index],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => placeholder(),
                      ),
                    ),
                  ),
                  if (urls.length > 1)
                    PositionedDirectional(
                      end: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: XpColors.signatureBlack.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(XpRadius.full),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.photo_library_outlined, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('${_page + 1}/${urls.length}',
                                style: XpText.labelS(context).copyWith(color: Colors.white)),
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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    final store = context.select<StoreDirectoryCubit, StoreModel?>(
      (c) => c.state[product.storeId],
    );
    final strike = product.strikethroughPrice;
    final price = state.displayPrice ?? product.effectivePrice;
    final percent = product.discountPercent;
    final muted = XpText.bodyS(context).copyWith(color: XpColors.textTertiary);

    return Container(
      width: double.infinity,
      color: XpColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StockChip(
                mode: product.stockMode,
                leadTimeDays: product.fulfillmentLeadTimeDays,
              ),
              if (store != null) SellerStatusBadge(status: store.sellerStatus),
              // Di sini `Diskon` ikut tampil: halaman detail punya ruang,
              // dan labelnya melengkapi angka persen di blok harga.
              for (final label in product.badgeLabels)
                XpPill(
                  label: label,
                  tone: XpTone(XpColors.sunken, XpColors.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(formatRupiah(price), style: XpText.headingXl(context)),
          if (strike != null && strike > price)
            Row(
              children: [
                Text(
                  formatRupiah(strike),
                  style: muted.copyWith(decoration: TextDecoration.lineThrough),
                ),
                if (percent != null && percent > 0) ...[
                  const SizedBox(width: 6),
                  XpPill(
                    label: '-$percent%',
                    tone: XpTone(XpColors.dangerSubtle, XpColors.danger),
                  ),
                ],
              ],
            ),
          const SizedBox(height: 8),
          Text(product.name,
              style: XpText.bodyL(context).copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          _RatingSummary(product: product),
        ],
      ),
    );
  }
}

/// Bintang + ulasan + terjual. Tanpa ulasan, bintangnya tidak digambar sama
/// sekali (design_buyer.md §5) — hanya jumlah terjual, dan itu pun hanya
/// kalau lebih dari nol.
class _RatingSummary extends StatelessWidget {
  const _RatingSummary({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final muted = XpText.bodyS(context).copyWith(color: XpColors.textSecondary);
    final parts = <Widget>[];
    if (product.hasRating) {
      parts.addAll([
        const Icon(Icons.star_rounded, size: 18, color: XpColors.star),
        const SizedBox(width: 2),
        Text(formatRating(product.ratingAvg),
            style: XpText.titleM(context).copyWith(fontWeight: FontWeight.w700)),
        Text('  •  ${formatNumber(product.ratingCount)} Ulasan', style: muted),
      ]);
    }
    if (product.soldCount > 0) {
      parts.add(Text(
        '${parts.isEmpty ? '' : '  •  '}${formatCompact(product.soldCount)} Terjual',
        style: muted,
      ));
    }
    if (parts.isEmpty) return const SizedBox.shrink();
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: parts);
  }
}

class _FlashSaleBlock extends StatelessWidget {
  const _FlashSaleBlock({required this.flashSale});

  final FlashSaleModel flashSale;

  @override
  Widget build(BuildContext context) {
    final fg = XpColors.danger;
    final style = XpText.bodyS(context).copyWith(color: fg);
    return XpCard(
      color: XpColors.dangerSubtle,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, color: fg, size: 20),
              const SizedBox(width: 4),
              Text('Flash Sale', style: XpText.titleM(context).copyWith(color: fg)),
              const Spacer(),
              Text(formatServerDeadline(flashSale.endsAt, prefix: 'Berakhir'), style: style),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(XpRadius.full),
            child: LinearProgressIndicator(
              value: flashSale.soldRatio,
              minHeight: 6,
              backgroundColor: XpColors.surface,
              valueColor: AlwaysStoppedAnimation(fg),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            flashSale.isSoldOut
                ? 'Kuota flash sale habis'
                : 'Tersisa ${formatNumber(flashSale.remainingQuota)} dari '
                    '${formatNumber(flashSale.stockQuota)}',
            style: style,
          ),
        ],
      ),
    );
  }
}

/// Ringkasan varian terpilih. **Membuka bottom sheet** — pemilih varian
/// tidak pernah digambar sebagai chip di halaman (design_buyer.md §5).
class _VariantRow extends StatelessWidget {
  const _VariantRow({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final variant = state.selectedVariant;
    final label = variant?.optionLabel ?? '';
    final count = state.product.variants.where((v) => v.isActive).length;
    final stock = variant == null ? null : purchasableStockOf(variant);

    return XpCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      onTap: () => _openSheet(context, state, VariantSheetIntent.addToCart),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pilih Varian', style: XpText.titleM(context)),
                const SizedBox(height: 2),
                Text(
                  label.isEmpty ? '$count pilihan tersedia' : label,
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                ),
                if (stock != null)
                  Text(
                    stock > 0 ? 'Stok ${formatNumber(stock)}' : 'Varian ini habis',
                    style: XpText.caption(context).copyWith(
                      color: stock > 0 ? XpColors.textTertiary : XpColors.danger,
                    ),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: XpColors.textTertiary),
        ],
      ),
    );
  }
}

/// Kartu toko: logo, nama, status penjual, Signature, metrik dari
/// `partners-performance`, dan dua tombol.
///
/// Rating toko diambil dari **performance** (rata-rata ulasan produk toko,
/// sesuai blueprint), bukan `stores.rating_avg`.
class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.storeId, required this.productId});

  final int storeId;

  /// Dioper ke "Chat Penjual" supaya ruang chat menawarkan kartu
  /// "Tanyakan produk ini" (`product_share`).
  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreProfileCubit, StoreProfileState>(
      builder: (context, state) {
        final loaded = state is StoreProfileLoaded ? state : null;
        final store = loaded?.store;
        return XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state is StoreProfileLoading)
                const SizedBox(
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (store != null) ...[
                Row(
                  children: [
                    StoreLogo(name: store.name, logoUrl: store.logoUrl, size: 48),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StoreNameLine(store: store),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              SellerStatusBadge(status: store.sellerStatus),
                              if (store.hasSignatureBadge) const SignatureBadge(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Empat kolom paling banyak: rating, transaksi sukses, chat
                // (dengan waktu balas), dan status online (🔶 simulasi).
                if (storeMetricsOf(loaded!.performance).isNotEmpty) ...[
                  const SizedBox(height: 12),
                  StoreMetricsBox(
                    metrics: storeMetricsOf(loaded.performance, meta: loaded.performanceMeta),
                  ),
                ],
              ],
              if (state is! StoreProfileLoading) ...[
                if (store != null) const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ChatWithStoreButton(
                        storeId: storeId,
                        storeName: store?.name,
                        productId: productId,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: XpColors.textSecondary,
                            side: BorderSide(color: XpColors.borderDefault),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(XpRadius.m),
                            ),
                            textStyle: XpText.labelL(context),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: storeId > 0
                              ? () => context.push(AppRoutes.storePath(storeId))
                              : null,
                          icon: const Icon(Icons.storefront_outlined, size: 18),
                          label: const Text('Kunjungi Toko'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DescriptionCard extends StatefulWidget {
  const _DescriptionCard({required this.text});

  final String text;

  @override
  State<_DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<_DescriptionCard> {
  bool _expanded = false;

  static const _collapsedLines = 6;

  @override
  Widget build(BuildContext context) {
    final style = XpText.bodyM(context).copyWith(color: XpColors.textSecondary);
    final long = widget.text.length > 280 || '\n'.allMatches(widget.text).length >= _collapsedLines;
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deskripsi', style: XpText.titleL(context)),
          const SizedBox(height: 8),
          Text(
            widget.text,
            style: style,
            maxLines: _expanded || !long ? null : _collapsedLines,
            overflow: _expanded || !long ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (long)
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(48, 40)),
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Tampilkan Lebih Sedikit' : 'Lihat Selengkapnya'),
            ),
        ],
      ),
    );
  }
}

/// "Produk Lain dari Toko Ini" — `GET /products?store_id=`. Disembunyikan
/// selama memuat, kalau gagal, atau kalau produk ini satu-satunya.
class _RelatedProducts extends StatelessWidget {
  const _RelatedProducts({required this.currentProductId});

  final int currentProductId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreProductsCubit, StoreProductsState>(
      builder: (context, state) {
        if (state is! StoreProductsLoaded) return const SizedBox.shrink();
        final others = state.products.where((p) => p.id != currentProductId).toList();
        if (others.isEmpty) return const SizedBox.shrink();
        final storeId = context.read<StoreProductsCubit>().storeId;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XpSectionHeader(
              title: 'Produk Lain dari Toko Ini',
              actionLabel: 'Lihat Semua',
              onAction: () => context.push(AppRoutes.storePath(storeId)),
            ),
            SizedBox(
              height: 232,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: others.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _MiniProductCard(product: others[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MiniProductCard extends StatelessWidget {
  const _MiniProductCard({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      child: XpCard(
        padding: const EdgeInsets.all(8),
        onTap: () => context.push(AppRoutes.productDetailPath(product.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XpProductImage(url: product.primaryImageUrl, size: 128),
            const SizedBox(height: 6),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: XpText.labelM(context),
            ),
            const Spacer(),
            Text(formatRupiah(product.effectivePrice), style: XpText.priceS(context)),
          ],
        ),
      ),
    );
  }
}

/// Bilah bawah: ikon tambah-ke-keranjang + "Beli Sekarang". Keduanya
/// membuka pemilih varian lebih dulu.
///
/// "Beli Sekarang" **juga memasukkan ke keranjang** lalu membuka keranjang:
/// API ini tidak punya endpoint beli-langsung, dan sesi checkout selalu
/// dibangun dari baris keranjang yang tercentang.
class _BuyBar extends StatelessWidget {
  const _BuyBar({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    if (!_isPurchasable(product)) {
      final label = product.stockMode.isPurchasable ? 'Stok Habis' : product.stockMode.label;
      return XpBottomBar(
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: FilledButton(onPressed: null, child: Text(label)),
        ),
      );
    }
    return XpBottomBar(
      child: Row(
        children: [
          Tooltip(
            message: 'Tambah ke Keranjang',
            child: Material(
              color: XpColors.primarySubtle,
              borderRadius: BorderRadius.circular(XpRadius.m),
              child: InkWell(
                borderRadius: BorderRadius.circular(XpRadius.m),
                onTap: () => _openSheet(context, state, VariantSheetIntent.addToCart),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(Icons.add_shopping_cart, size: 22, color: XpColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: () => _openSheet(context, state, VariantSheetIntent.buyNow),
                child: const Text('Beli Sekarang'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Membuka sheet varian lalu menindaklanjuti hasilnya.
///
/// Varian yang dipilih di sheet dibawa pulang ke halaman walau user menutup
/// sheet tanpa menambah — supaya harga, stok, dan ongkir di halaman ikut
/// varian yang terakhir ia lihat.
Future<void> _openSheet(
  BuildContext context,
  ProductDetailLoaded state,
  VariantSheetIntent intent,
) async {
  final cubit = ProductDetailCubit.get(context);
  final badge = context.read<CartBadgeCubit>();
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);

  final result = await showVariantSheet(
    context,
    product: state.product,
    initialVariant: state.selectedVariant,
    intent: intent,
  );

  final variant = result.variant;
  if (variant != null && variant.id != state.selectedVariant?.id) {
    cubit.selectVariant(variant);
  }
  if (!result.added) return;

  badge.refresh();
  // Stok berubah setelah barang masuk keranjang; baca ulang tanpa
  // mengosongkan halaman supaya "Sisa N" tidak basi.
  cubit.refresh();

  if (intent == VariantSheetIntent.buyNow) {
    await router.push(AppRoutes.cart);
    badge.refresh();
    return;
  }
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: const Text('Ditambahkan ke keranjang'),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () => router.push(AppRoutes.cart),
        ),
      ),
    );
}

/// Tombol simpan ke wishlist di app bar.
///
/// Tidak ada endpoint "apakah produk ini di wishlist", jadi statusnya dibaca
/// dari daftar penuh di [WishlistCubit] tingkat-app. Selama daftar itu belum
/// siap, tombolnya non-aktif alih-alih menebak.
class _WishlistAction extends StatelessWidget {
  const _WishlistAction({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistCubit, WishlistState>(
      listenWhen: (previous, current) =>
          current is WishlistReady && current.actionError != null,
      listener: (context, state) {
        final error = (state as WishlistReady).actionError!;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(errorMessageFor(context, error))));
        context.read<WishlistCubit>().clearActionError();
      },
      builder: (context, state) {
        final ready = state is WishlistReady;
        final saved = state.contains(productId);
        final busy = ready && state.mutatingProductIds.contains(productId);
        return IconButton(
          tooltip: saved ? 'Hapus dari wishlist' : 'Simpan ke wishlist',
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: !ready || busy ? null : () => context.read<WishlistCubit>().toggle(productId),
          icon: Icon(
            saved ? Icons.favorite : Icons.favorite_border,
            size: 24,
            color: saved ? XpColors.danger : XpColors.textPrimary,
          ),
        );
      },
    );
  }
}
