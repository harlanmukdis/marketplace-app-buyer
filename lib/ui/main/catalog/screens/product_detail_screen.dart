import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/cart/cubit/cart_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/product_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/shipping_estimate_section.dart';
import 'package:marketplace_app_member/ui/main/chat/widgets/chat_with_store_button.dart';
import 'package:marketplace_app_member/ui/main/review/widgets/product_reviews_section.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Halaman detail produk.
///
/// Seluruh isinya berasal dari satu `GET /products/{id}` — tidak ada
/// panggilan susulan untuk gambar, varian, stok, maupun kurir.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    // Dua cubit: satu untuk isi halaman, satu lagi khusus aksi "tambah ke
    // keranjang". Memakai CartCubit di sini — alih-alih menaruh logika
    // keranjang di ProductDetailCubit — membuat pembatasan kuantitas dan
    // aturan baca-ulang keranjang hanya ada di satu tempat.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductDetailCubit(productId)..load()),
        BlocProvider(create: (_) => CartCubit()),
        // Wishlist dimuat penuh supaya tombol hati tahu produk ini sudah
        // tersimpan atau belum — tidak ada endpoint "cek satu produk".
        BlocProvider(create: (_) => WishlistCubit()..load()),
      ],
      child: _ProductDetailBody(productId: productId),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(
        context,
        'Detail Produk',
        action: _WishlistButton(productId: productId),
      ),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          return switch (state) {
            ProductDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            ProductDetailError(:final error) => _ErrorView(
                message: errorMessageFor(context, error),
                onRetry: () =>
                    ProductDetailCubit.get(context).load(forceRefresh: true),
              ),
            ProductDetailLoaded() => _Loaded(state: state),
          };
        },
      ),
      bottomNavigationBar:
          BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is! ProductDetailLoaded) return const SizedBox.shrink();
          return _BuyBar(state: state);
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final product = state.product;

    return RefreshIndicator(
      onRefresh: () => ProductDetailCubit.get(context).load(forceRefresh: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _Gallery(images: product.images),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PriceBlock(state: state),
                12.sbh,
                Text(
                  product.name,
                  style: AppStyles.styleSemiBold18(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
                if (product.badgeLabels.isNotEmpty) ...[
                  8.sbh,
                  _BadgeRow(labels: product.badgeLabels),
                ],
                8.sbh,
                _StatsRow(product: product),
                if (product.flashSale != null) ...[
                  16.sbh,
                  _FlashSaleBlock(flashSale: product.flashSale!),
                ],
                if (product.variants.length > 1) ...[
                  20.sbh,
                  _VariantPicker(state: state),
                ],
                if ((product.description ?? '').trim().isNotEmpty) ...[
                  24.sbh,
                  Text(
                    'Deskripsi',
                    style: AppStyles.styleSemiBold16(context).copyWith(
                      color: dark ? kDarkSecondColor : kLightSecondColor,
                    ),
                  ),
                  8.sbh,
                  Text(
                    product.description!,
                    style: AppStyles.styleRegular14(context).copyWith(
                      color: dark ? kDarkThirdColor : kLightThirdColor,
                    ),
                  ),
                ],
                if (product.couriers.isNotEmpty ||
                    (state.selectedVariant?.shippingOrigin ?? '')
                        .isNotEmpty) ...[
                  24.sbh,
                  Text(
                    'Pengiriman',
                    style: AppStyles.styleSemiBold16(context).copyWith(
                      color: dark ? kDarkSecondColor : kLightSecondColor,
                    ),
                  ),
                  8.sbh,
                  if ((state.selectedVariant?.shippingOrigin ?? '')
                      .isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: 16,
                            color: dark ? kDarkThirdColor : kLightThirdColor),
                        6.sbw,
                        Expanded(
                          child: Text(
                            // Lokasi gudang datang langsung di detail produk,
                            // jadi tidak perlu memanggil endpoint estimasi.
                            'Dikirim dari ${state.selectedVariant!.shippingOrigin}',
                            style: AppStyles.styleRegular12(context).copyWith(
                              color: dark ? kDarkThirdColor : kLightThirdColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.sbh,
                  ],
                  ShippingEstimateSection(
                    productId: product.id,
                    variantId: state.selectedVariant?.id,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final courier in product.couriers)
                        Chip(label: Text(courier.name)),
                    ],
                  ),
                ],
                20.sbh,
                // Di LUAR blok "Pengiriman" dengan sengaja: bertanya ke
                // penjual harus selalu mungkin, termasuk untuk produk yang
                // belum punya kurir maupun lokasi gudang.
                //
                // Halaman inilah satu-satunya yang tahu `store_id` — daftar
                // percakapan tidak punya cara memulai percakapan baru, karena
                // tidak ada pencarian toko di app member.
                ChatWithStoreButton(storeId: product.storeId),
                24.sbh,
                ProductReviewsSection(productId: product.id),
                32.sbh,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.images});

  final List<ProductImageModel> images;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    if (images.isEmpty) {
      return Container(
        height: 280,
        color: dark ? kLightSecondColor : kBorderColor,
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: dark ? kDarkThirdColor : kLightThirdColor,
        ),
      );
    }

    final sorted = [...images]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return SizedBox(
      height: 280,
      child: PageView.builder(
        itemCount: sorted.length,
        itemBuilder: (context, index) => Image.network(
          sorted[index].imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: dark ? kLightSecondColor : kBorderColor,
            child: Icon(
              Icons.broken_image_outlined,
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final product = state.product;
    final strike = product.strikethroughPrice;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatRupiah(state.displayPrice),
          style: AppStyles.styleSemiBold24(context).copyWith(
            color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
          ),
        ),
        if (strike != null) ...[
          8.sbw,
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 3),
            child: Text(
              formatRupiah(strike),
              style: AppStyles.styleRegular14(context).copyWith(
                color: dark ? kDarkThirdColor : kLightThirdColor,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Label "Terlaris" / "Populer" / "Baru" / "Diskon" dari `badges` server.
///
/// Berbeda dari kartu listing, di sini **`sale` ikut ditampilkan**: halaman
/// detail punya ruang, dan angka diskonnya sendiri sudah tampil di blok harga
/// di atas — jadi labelnya melengkapi, bukan mengulang di tempat yang sama.
class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final label in labels)
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: (dark ? kDarkPrimaryColor : kLightPrimaryColor)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: AppStyles.styleSemiBold12(context).copyWith(
                color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;
    final style = AppStyles.styleRegular12(context).copyWith(color: muted);

    return Row(
      children: [
        if (product.hasRating) ...[
          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
          2.sbw,
          Text(
            '${product.ratingAvg.toStringAsFixed(1)} (${product.ratingCount})',
            style: style,
          ),
          12.sbw,
        ] else ...[
          Text('Belum ada ulasan', style: style),
          12.sbw,
        ],
        Text('${product.soldCount} terjual', style: style),
      ],
    );
  }
}

class _FlashSaleBlock extends StatelessWidget {
  const _FlashSaleBlock({required this.flashSale});

  final FlashSaleModel flashSale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: kDeleteColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: kDeleteColor, size: 18),
              4.sbw,
              Text(
                'Flash Sale',
                style: AppStyles.styleSemiBold14(context)
                    .copyWith(color: kDeleteColor),
              ),
              const Spacer(),
              Text(
                formatServerDeadline(flashSale.endsAt, prefix: 'Berakhir'),
                style: AppStyles.styleRegular12(context)
                    .copyWith(color: kDeleteColor),
              ),
            ],
          ),
          8.sbh,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: flashSale.soldRatio,
              minHeight: 6,
              backgroundColor: kWhiteColor,
              valueColor: const AlwaysStoppedAnimation(kDeleteColor),
            ),
          ),
          6.sbh,
          Text(
            flashSale.isSoldOut
                ? 'Kuota flash sale habis'
                : 'Tersisa ${flashSale.remainingQuota} dari ${flashSale.stockQuota}',
            style:
                AppStyles.styleRegular12(context).copyWith(color: kDeleteColor),
          ),
        ],
      ),
    );
  }
}

class _VariantPicker extends StatelessWidget {
  const _VariantPicker({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final primary = dark ? kDarkPrimaryColor : kLightPrimaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilihan',
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: dark ? kDarkSecondColor : kLightSecondColor,
          ),
        ),
        8.sbh,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final variant in state.product.variants)
              _VariantChip(
                variant: variant,
                selected: variant.id == state.selectedVariant?.id,
                primary: primary,
              ),
          ],
        ),
      ],
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({
    required this.variant,
    required this.selected,
    required this.primary,
  });

  final ProductVariantModel variant;
  final bool selected;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final soldOut = variant.isOutOfStock;
    final label =
        variant.optionLabel.isEmpty ? (variant.sku ?? '-') : variant.optionLabel;

    return InkWell(
      // Varian habis tetap ditampilkan tapi tidak bisa dipilih — menyembunyikannya
      // membuat user mengira ukuran itu tidak pernah ada.
      onTap: soldOut
          ? null
          : () => ProductDetailCubit.get(context).selectVariant(variant),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.transparent,
          border: Border.all(
            color: selected
                ? primary
                : (dark ? kDarkThirdColor : kLightThirdColor),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          soldOut ? '$label (habis)' : label,
          style: AppStyles.styleMedium14(context).copyWith(
            color: selected
                ? kWhiteColor
                : (soldOut
                    ? (dark ? kDarkThirdColor : kLightThirdColor)
                    : (dark ? kDarkSecondColor : kLightSecondColor)),
            decoration: soldOut ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}

class _BuyBar extends StatelessWidget {
  const _BuyBar({required this.state});

  final ProductDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final stock = state.displayStock;
    final canBuy = state.canAddToCart;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                switch (stock) {
                  null => 'Stok tidak diketahui',
                  <= 0 => 'Stok habis',
                  <= 5 => 'Tersisa $stock',
                  _ => 'Stok tersedia',
                },
                style: AppStyles.styleRegular12(context).copyWith(
                  color: canBuy
                      ? (dark ? kDarkThirdColor : kLightThirdColor)
                      : kErrorColor,
                ),
              ),
            ),
            _AddToCartButton(state: state),
          ],
        ),
      ),
    );
  }
}

/// Tombol simpan ke wishlist.
///
/// Tidak ada endpoint "apakah produk ini di wishlist", jadi statusnya dibaca
/// dari daftar penuh yang dimuat saat halaman dibuka. Selama daftar itu belum
/// siap, tombolnya ditampilkan non-aktif alih-alih menebak.
class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.productId});

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
          ..showSnackBar(
            SnackBar(content: Text(errorMessageFor(context, error))),
          );
        WishlistCubit.get(context).clearActionError();
      },
      builder: (context, state) {
        final ready = state is WishlistReady;
        final saved = state.contains(productId);
        final busy =
            ready && state.mutatingProductIds.contains(productId);

        return IconButton(
          tooltip: saved ? 'Hapus dari wishlist' : 'Simpan ke wishlist',
          onPressed: !ready || busy
              ? null
              : () => WishlistCubit.get(context).toggle(productId),
          icon: Icon(
            saved ? Icons.favorite : Icons.favorite_border,
            color: saved ? kDeleteColor : null,
          ),
        );
      },
    );
  }
}

/// Tombol tambah ke keranjang.
///
/// Kuantitasnya selalu 1 per ketukan, dan varian yang dikirim adalah varian
/// terpilih — bukan produknya: `cart_items` di API ini merujuk
/// `product_variant_id`.
///
/// Stok dicek di sini karena **halaman inilah yang tahu stok**; `GET /cart`
/// tidak mengirimnya, dan server tidak memvalidasi kuantitas sama sekali.
/// 🔴 **Sibuk dilacak di sini, bukan disimpulkan dari `CartLoading`.**
///
/// Versi sebelumnya memakai `busy = cartState is CartLoading`, dan itu membuat
/// tombolnya **mati selamanya di setiap halaman produk**: `ProductDetailScreen`
/// membuat `CartCubit()` tanpa `..load()`, sedangkan keadaan awal cubit itu
/// `CartState.loading()`. Tidak ada yang pernah memindahkannya dari `loading`,
/// karena satu-satunya jalan keluar adalah `addItem` — yang butuh tombolnya
/// hidup. Kebuntuan yang sempurna.
///
/// Tidak ada test lama yang bisa menangkapnya: servicenya benar,
/// `CartCubit.addItem` benar, dan test cubit memanggil methodnya langsung
/// tanpa melewati tombol. Yang salah hanya **perkawinannya**, dan itu baru
/// terlihat saat app sungguhan ditekan tombolnya —
/// `integration_test/member_journey_test.dart`.
///
/// Memuat keranjang di sini (`CartCubit()..load()`) juga akan menghidupkan
/// tombolnya, tapi dengan ongkos satu `GET /cart` tiap halaman produk dibuka
/// **dan** satu bug baru: transisi `loading → ready` dari pemuatan itu akan
/// memicu snackbar "Ditambahkan ke keranjang" sebelum user menekan apa pun.
class _AddToCartButton extends StatefulWidget {
  const _AddToCartButton({required this.state});

  final ProductDetailLoaded state;

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
  /// `true` selagi penambahan **dari tombol ini** sedang berjalan.
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final variantId = widget.state.selectedVariant?.id;
    final canBuy = widget.state.canAddToCart && variantId != null;

    return BlocConsumer<CartCubit, CartState>(
      // Hanya perubahan yang disebabkan ketukan tombol ini yang diberitakan.
      // Tanpa penjaga ini, setiap `CartReady` yang lewat — termasuk dari
      // pemuatan biasa — akan mengaku sebagai "berhasil ditambahkan".
      listenWhen: (_, __) => _submitting,
      listener: (context, cartState) {
        final message = switch (cartState) {
          CartReady(:final actionError?) => errorMessageFor(context, actionError),
          CartReady() => 'Ditambahkan ke keranjang',
          _ => null,
        };
        if (message == null) return;

        setState(() => _submitting = false);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        CartCubit.get(context).clearActionError();

        // Stok berubah setelah barang masuk keranjang; muat ulang detail
        // supaya label "tersisa N" tidak basi.
        ProductDetailCubit.get(context).load(forceRefresh: true);
      },
      builder: (context, cartState) {
        return FilledButton.icon(
          onPressed: canBuy && !_submitting
              ? () {
                  setState(() => _submitting = true);
                  CartCubit.get(context).addItem(
                    productVariantId: variantId,
                    quantity: 1,
                  );
                }
              : null,
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('Tambah ke Keranjang'),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
            16.sbh,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            16.sbh,
            FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}
