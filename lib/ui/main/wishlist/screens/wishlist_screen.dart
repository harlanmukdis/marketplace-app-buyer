import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Wishlist pembeli (`wishlist_xpedia_buyer`), root tab kedua.
///
/// Memakai [WishlistCubit] **tingkat-app** — bukan instance baru — supaya hati
/// di kartu beranda, pencarian, dan detail produk ikut berubah saat produk
/// dibuang dari sini.
///
/// 🔶 **Lonceng pantau harga & stok per produk + lencana "Pantau"** (b15,
/// docs/22 #13) memakai kontrak usulan `PATCH /wishlist/items/{product_id}`
/// dan field `alert_enabled` di `GET /wishlist` — mock di debug, berlencana
/// "Simulasi". Tanpa mock baris wishlist tidak membawa `alert_enabled`, dan
/// loncengnya **tidak digambar** (bukan sakelar yang tidak menyimpan apa-apa).
///
/// Tidak dibangun: sakelar notifikasi global (tidak ada preferensi global di
/// kontrak — pantau diatur per produk), chip kategori (baris wishlist tidak
/// membawa kategori), serta banner "Jaminan Harga Termurah" (janji yang tidak
/// terverifikasi). Tombol "+ Keranjang" diganti "Lihat Produk": baris
/// wishlist hanya membawa `product_id`, sedangkan keranjang butuh
/// `product_variant_id` — varian harus dipilih di halaman produk.
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key, this.onLogoTap});

  /// Diisi saat layar ini jadi tab di `HomeLayout`: app bar memakai logo
  /// sebagai tombol Beranda dan tanpa tombol kembali.
  final VoidCallback? onLogoTap;

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = widget.onLogoTap != null
        ? XpTabAppBar(title: 'Wishlist', onLogoTap: widget.onLogoTap)
        : const XpStackAppBar(title: 'Wishlist', actions: [CartActionButton()]);

    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: appBar,
      body: BlocConsumer<WishlistCubit, WishlistState>(
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
          return RefreshIndicator(
            onRefresh: () => context.read<WishlistCubit>().load(),
            child: switch (state) {
              WishlistLoading() => const Center(child: CircularProgressIndicator()),
              WishlistError(:final error) => _Scrollable(
                  child: XpEmptyState(
                    icon: Icons.wifi_off_rounded,
                    title: 'Wishlist belum bisa dimuat',
                    message: errorMessageFor(context, error),
                    actionLabel: 'Coba Lagi',
                    onAction: () => context.read<WishlistCubit>().load(),
                  ),
                ),
              WishlistReady(:final items) when items.isEmpty => _Scrollable(
                  child: XpEmptyState(
                    icon: Icons.favorite_border,
                    title: 'Wishlist Belum Ada',
                    message: 'Simpan barang idamanmu agar tidak terlewat promo dan '
                        'diskon spesial dari Xpedia.',
                    actionLabel: 'Mulai Cari Produk',
                    onAction: () => context.push(AppRoutes.search),
                  ),
                ),
              WishlistReady() => _Grid(state: state),
            },
          );
        },
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.state});

  final WishlistReady state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: XpColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: XpText.headingL(context),
                    children: [
                      const TextSpan(text: 'Wishlist Saya '),
                      TextSpan(
                        text: '(${formatNumber(state.items.length)} produk)',
                        style: XpText.bodyM(context).copyWith(color: XpColors.textTertiary),
                      ),
                    ],
                  ),
                ),
                if (state.items.any((i) => i.supportsAlert)) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        state.watchedCount > 0
                            ? Icons.notifications_active
                            : Icons.notifications_none,
                        size: 16,
                        color: XpColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          state.watchedCount > 0
                              ? '${formatNumber(state.watchedCount)} produk dipantau — '
                                  'kami kabari saat harga turun atau stok kembali.'
                              : 'Ketuk lonceng untuk dikabari saat harga turun atau stok kembali.',
                          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                        ),
                      ),
                      SimulatedBadge(meta: state.meta),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) => SliverGrid(
              gridDelegate: _gridDelegate(constraints.crossAxisExtent),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = state.items[index];
                  return _WishlistCard(
                    item: item,
                    isMutating: state.mutatingProductIds.contains(item.productId),
                    isAlertMutating: state.alertMutatingIds.contains(item.productId),
                  );
                },
                childCount: state.items.length,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Grid 2 kolom berjarak 8 (desain wishlist lebih rapat daripada beranda).
  /// Tinggi sel tetap supaya baris rata walau satu produk punya catatan
  /// "tidak tersedia" dan yang lain tidak.
  static SliverGridDelegate _gridDelegate(double width) {
    const gap = 8.0;
    final cell = (width - gap) / 2;
    final image = cell - 16;
    const text = 8 + 40 + 4 + 22 + 4 + 22 + 8 + 36 + 16;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: gap,
      crossAxisSpacing: gap,
      mainAxisExtent: image + text,
    );
  }
}

class _WishlistCard extends StatelessWidget {
  const _WishlistCard({
    required this.item,
    required this.isMutating,
    required this.isAlertMutating,
  });

  final WishlistItemModel item;
  final bool isMutating;
  final bool isAlertMutating;

  Future<void> _toggleAlert(BuildContext context) async {
    final cubit = context.read<WishlistCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final watched = await cubit.setAlert(item.productId, enabled: !item.isWatched);
    if (watched == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(watched
            ? 'Notifikasi perubahan harga aktif'
            : 'Notifikasi promo wishlist dinonaktifkan'),
      ));
  }

  Future<void> _remove(BuildContext context) async {
    final cubit = context.read<WishlistCubit>();
    final messenger = ScaffoldMessenger.of(context);
    // Parameternya id PRODUK, bukan wishlist_item_id — endpoint hapus
    // membalas 200 untuk id yang salah, jadi kesalahannya tidak terlihat.
    await cubit.remove(item.productId);
    final state = cubit.state;
    if (state is WishlistReady && state.actionError == null && !state.contains(item.productId)) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Dihapus dari Wishlist')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final available = item.isAvailable;
    void open() => context.push(AppRoutes.productDetailPath(item.productId));

    return Opacity(
      opacity: isMutating ? 0.5 : 1,
      child: XpCard(
        padding: const EdgeInsets.all(8),
        onTap: available ? open : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Berbeda dari listing katalog, wishlist MEMBAWA image_url.
                Opacity(
                  opacity: available ? 1 : 0.5,
                  child: XpProductImage(url: item.imageUrl),
                ),
                if (item.supportsAlert)
                  PositionedDirectional(
                    top: 2,
                    start: 2,
                    child: Semantics(
                      button: true,
                      toggled: item.isWatched,
                      label: item.isWatched ? 'Berhenti pantau harga' : 'Pantau harga',
                      child: InkResponse(
                        radius: 24,
                        onTap: isAlertMutating ? null : () => _toggleAlert(context),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: item.isWatched
                                    ? XpColors.primarySubtle
                                    : Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: isAlertMutating
                                  ? const Padding(
                                      padding: EdgeInsets.all(7),
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Icon(
                                      item.isWatched
                                          ? Icons.notifications_active
                                          : Icons.notifications_none,
                                      size: 17,
                                      color: item.isWatched
                                          ? XpColors.primary
                                          : XpColors.textSecondary,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                PositionedDirectional(
                  top: 2,
                  end: 2,
                  child: Semantics(
                    button: true,
                    label: 'Hapus dari wishlist',
                    child: InkResponse(
                      radius: 24,
                      onTap: isMutating ? null : () => _remove(context),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.favorite, size: 18, color: XpColors.danger),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: XpText.titleM(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(item.minPrice),
              style: XpText.priceM(context).copyWith(color: XpColors.primary),
            ),
            const SizedBox(height: 4),
            if (!available)
              // Produk yang diarsipkan penjual tetap tersimpan di wishlist.
              // Ditandai, bukan disembunyikan — user perlu tahu kenapa
              // barangnya tidak ada lagi di katalog.
              const XpPill(
                label: 'Tidak tersedia',
                tone: XpStockTones.unavailable,
              )
            else if (item.isWatched)
              const XpPill(
                label: 'Pantau',
                icon: Icons.notifications_active,
                tone: XpOrderTones.shipping,
              )
            else
              const SizedBox(height: 22),
            const Spacer(),
            SizedBox(
              height: 36,
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: XpColors.primarySubtle,
                  foregroundColor: XpColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 36),
                  textStyle: XpText.labelM(context).copyWith(fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(XpRadius.m)),
                ),
                onPressed: available ? open : null,
                child: const Text('Lihat Produk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: constraints.maxHeight, child: child),
      ),
    );
  }
}
