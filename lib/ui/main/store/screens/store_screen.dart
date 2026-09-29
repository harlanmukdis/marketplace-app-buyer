import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/product_card.dart';
import 'package:marketplace_app_member/ui/main/chat/widgets/chat_with_store_button.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/live_sessions_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/store_products_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/store_profile_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/widgets/live_widgets.dart';
import 'package:marketplace_app_member/ui/main/store/widgets/store_widgets.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Storefront (`profil_toko_jotun_paint_center` + b10/b13).
///
/// Tab: Beranda Toko, Produk, Live, Ulasan, Tentang Toko.
///
/// 🔶 **Tab Live dan pita "Live" di header** membaca endpoint usulan
/// `GET /live-sessions?store_id=` (mock di debug, berlencana "Simulasi").
/// Tanpa mock tab-nya menampilkan "Live belum tersedia". Belum ada pemutar:
/// backend tidak menyediakan `playback_url` untuk pembeli.
///
/// 🔶 **Metrik "Online / Aktif sekarang"** dari kontrak usulan
/// `service_performance.online_status` (disisipkan mock ke
/// `partners-performance`).
///
/// Tidak dibangun karena tidak ada datanya: hero promo toko dan kapsul
/// voucher toko (voucher belum di-seed dan tidak ada endpoint voucher per
/// toko), tile keunggulan toko, kategori toko, dan kota toko. Judul app bar
/// memakai nama toko, bukan "Detail Produk" seperti di desain (inventaris
/// §3.5 menyebutnya bug).
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.storeId});

  final int storeId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StoreProfileCubit(storeId)..load()),
        BlocProvider(create: (_) => StoreProductsCubit(storeId)..load()),
        BlocProvider(create: (_) => LiveSessionsCubit.forStore(storeId)..load()),
      ],
      child: _StoreBody(storeId: storeId),
    );
  }
}

enum _StoreTab { home, products, live, reviews, about }

class _StoreBody extends StatefulWidget {
  const _StoreBody({required this.storeId});

  final int storeId;

  @override
  State<_StoreBody> createState() => _StoreBodyState();
}

class _StoreBodyState extends State<_StoreBody> {
  final _scroll = ScrollController();
  _StoreTab _tab = _StoreTab.home;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_tab != _StoreTab.products || !_scroll.hasClients) return;
    final position = _scroll.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      context.read<StoreProductsCubit>().loadMore();
    }
  }

  void _select(_StoreTab tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreProfileCubit, StoreProfileState>(
      listenWhen: (previous, current) => current is StoreProfileLoaded,
      listener: (context, state) {
        final loaded = state as StoreProfileLoaded;
        context.read<StoreDirectoryCubit>().put(loaded.store);
        final error = loaded.actionError;
        if (error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(errorMessageFor(context, error))));
          context.read<StoreProfileCubit>().clearActionError();
        }
      },
      builder: (context, state) {
        final store = state is StoreProfileLoaded ? state.store : null;
        return Scaffold(
          backgroundColor: XpColors.canvas,
          appBar: XpStackAppBar(
            title: store?.name ?? 'Toko',
            actions: const [SupportActionButton(), CartActionButton()],
          ),
          body: switch (state) {
            StoreProfileLoading() => const Center(child: CircularProgressIndicator()),
            StoreProfileError(:final error) => XpEmptyState(
                icon: Icons.storefront_outlined,
                title: 'Toko belum bisa dimuat',
                message: errorMessageFor(context, error),
                actionLabel: 'Coba Lagi',
                onAction: () => context.read<StoreProfileCubit>().load(),
              ),
            StoreProfileLoaded() => RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    context.read<StoreProfileCubit>().load(),
                    context.read<StoreProductsCubit>().load(),
                    context.read<LiveSessionsCubit>().load(),
                  ]);
                },
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _Header(state: state)),
                    SliverToBoxAdapter(
                      child: _LiveRibbon(onWatch: () => _select(_StoreTab.live)),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _TabsDelegate(
                        selected: _tab,
                        performance: state.performance,
                        onSelect: _select,
                      ),
                    ),
                    ..._tabSlivers(context, state),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
          },
        );
      },
    );
  }

  List<Widget> _tabSlivers(BuildContext context, StoreProfileLoaded state) {
    return switch (_tab) {
      _StoreTab.home => [
          if ((state.store.description ?? '').trim().isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _DescriptionCard(
                  text: state.store.description!.trim(),
                  maxLines: 3,
                  onMore: () => _select(_StoreTab.about),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: XpSectionHeader(
              title: 'Produk Unggulan Toko',
              actionLabel: 'Lihat Semua',
              onAction: () => _select(_StoreTab.products),
            ),
          ),
          const _ProductsSliver(limit: 6),
        ],
      _StoreTab.products => [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const _ProductsSliver(),
        ],
      _StoreTab.live => const [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: StoreLiveTab()),
          ),
        ],
      _StoreTab.reviews => [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: _ReviewsTab(performance: state.performance)),
          ),
        ],
      _StoreTab.about => [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: _AboutTab(state: state)),
          ),
        ],
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final StoreProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final store = state.store;
    final metrics = storeMetricsOf(state.performance, meta: state.performanceMeta);
    final productTotal = context.select<StoreProductsCubit, int?>((c) => switch (c.state) {
          StoreProductsLoaded(:final total, :final products, :final hasMore) =>
            total ?? (hasMore ? null : products.length),
          StoreProductsEmpty() => 0,
          _ => null,
        });
    final meta = [
      '${formatCompact(store.followerCount)} Pengikut',
      if (productTotal != null) '${formatNumber(productTotal)} Produk',
    ].join('  •  ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Banner(url: store.bannerUrl),
        Container(
          color: XpColors.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      StoreLogo(name: store.name, logoUrl: store.logoUrl, size: 64, rounded: true),
                      if (store.sellerStatus != SellerStatus.unverified)
                        PositionedDirectional(
                          end: -4,
                          bottom: -4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: XpColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.verified, size: 20, color: XpColors.primary),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(store.name,
                            style: XpText.titleL(context).copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            SellerStatusBadge(status: store.sellerStatus),
                            if (store.hasSignatureBadge) const SignatureBadge(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(meta,
                            style: XpText.caption(context)
                                .copyWith(color: XpColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _FollowButton(state: state)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChatWithStoreButton(storeId: store.id, storeName: store.name),
                  ),
                ],
              ),
              if (metrics.isNotEmpty) ...[
                const SizedBox(height: 12),
                StoreMetricsBox(metrics: metrics),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Pita "Live" di bawah header (inventaris §3.5): hanya saat toko sedang
/// tayang. "Tonton" membuka tab Live — belum ada pemutar.
class _LiveRibbon extends StatelessWidget {
  const _LiveRibbon({required this.onWatch});

  final VoidCallback onWatch;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LiveSessionsCubit>().state;
    final live = state.live;
    if (live.isEmpty) return const SizedBox.shrink();
    final session = live.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [XpColors.navy, Color(0xff465BA0)]),
      ),
      child: Row(
        children: [
          const LiveBadge(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  session.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: XpText.labelM(context).copyWith(color: Colors.white),
                ),
                if (state is LiveSessionsLoaded && isMockMeta(state.meta)) ...[
                  const SizedBox(height: 4),
                  SimulatedBadge(meta: state.meta),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 36,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: XpColors.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(48, 36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(XpRadius.full)),
              ),
              onPressed: onWatch,
              child: const Text('Lihat Live'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      height: 72,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [XpColors.navy, Color(0xff0056FE)]),
      ),
    );
    final link = url?.trim();
    if (link == null || link.isEmpty) return fallback;
    return AspectRatio(
      aspectRatio: 3,
      child: Image.network(link, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback),
    );
  }
}

/// "Ikuti Toko" ↔ "Mengikuti". Arahnya selalu dari `is_following` hasil baca
/// server terakhir — `POST /follow` tidak idempoten (422 kalau sudah).
class _FollowButton extends StatelessWidget {
  const _FollowButton({required this.state});

  final StoreProfileLoaded state;

  Future<void> _toggle(BuildContext context) async {
    final cubit = context.read<StoreProfileCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final wasFollowing = state.store.isFollowing;
    await cubit.toggleFollow();
    final next = cubit.state;
    if (next is StoreProfileLoaded &&
        next.actionError == null &&
        next.store.isFollowing != wasFollowing) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(next.store.isFollowing
              ? 'Berhasil mengikuti ${next.store.name}'
              : 'Berhenti mengikuti toko'),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final following = state.store.isFollowing;
    final busy = state.isFollowBusy;
    final icon = busy
        ? const SizedBox(
            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
        : Icon(following ? Icons.done : Icons.add, size: 18);
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(XpRadius.m));
    return SizedBox(
      height: 44,
      child: following
          ? FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: XpColors.sunken,
                foregroundColor: XpColors.textPrimary,
                shape: shape,
                textStyle: XpText.labelL(context),
              ),
              onPressed: busy ? null : () => _toggle(context),
              icon: icon,
              label: const Text('Mengikuti'),
            )
          : FilledButton.icon(
              style: FilledButton.styleFrom(shape: shape, textStyle: XpText.labelL(context)),
              onPressed: busy ? null : () => _toggle(context),
              icon: icon,
              label: const Text('Ikuti Toko'),
            ),
    );
  }
}

class _TabsDelegate extends SliverPersistentHeaderDelegate {
  _TabsDelegate({required this.selected, required this.performance, required this.onSelect});

  final _StoreTab selected;
  final StorePerformanceModel? performance;
  final ValueChanged<_StoreTab> onSelect;

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  bool shouldRebuild(_TabsDelegate oldDelegate) =>
      oldDelegate.selected != selected || oldDelegate.performance != performance;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final reviews = performance?.hasRating == true
        ? 'Ulasan (${formatCompact(performance!.totalReviews)})'
        : 'Ulasan';
    final labels = {
      _StoreTab.home: 'Beranda Toko',
      _StoreTab.products: 'Produk',
      _StoreTab.live: 'Live',
      _StoreTab.reviews: reviews,
      _StoreTab.about: 'Tentang Toko',
    };
    return Container(
      decoration: BoxDecoration(
        color: XpColors.surface,
        border: Border(bottom: BorderSide(color: XpColors.borderSubtle)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          for (final entry in labels.entries)
            _TabItem(
              label: entry.value,
              active: entry.key == selected,
              onTap: () => onSelect(entry.key),
            ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: active,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? XpColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: active
                ? XpText.titleM(context).copyWith(color: XpColors.primary)
                : XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

/// Grid produk toko. [limit] untuk tab Beranda (cuplikan); tanpa [limit]
/// berhalaman penuh untuk tab Produk.
class _ProductsSliver extends StatelessWidget {
  const _ProductsSliver({this.limit});

  final int? limit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreProductsCubit, StoreProductsState>(
      builder: (context, state) {
        switch (state) {
          case StoreProductsLoading():
            return const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          case StoreProductsError(:final error):
            return SliverToBoxAdapter(
              child: XpEmptyState(
                icon: Icons.wifi_off_rounded,
                title: 'Produk belum bisa dimuat',
                message: errorMessageFor(context, error),
                actionLabel: 'Coba Lagi',
                onAction: () => context.read<StoreProductsCubit>().load(),
              ),
            );
          case StoreProductsEmpty():
            return const SliverToBoxAdapter(
              child: XpEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Belum ada produk',
                message: 'Toko ini belum menjual produk yang bisa dibeli saat ini.',
              ),
            );
          case StoreProductsLoaded(
              :final products,
              :final isLoadingMore,
              :final loadMoreError,
            ):
            final shown = limit == null ? products : products.take(limit!).toList();
            return SliverMainAxisGroup(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) => SliverGrid(
                      gridDelegate: productGridDelegate(constraints.crossAxisExtent),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final ProductModel product = shown[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push(AppRoutes.productDetailPath(product.id)),
                          );
                        },
                        childCount: shown.length,
                      ),
                    ),
                  ),
                ),
                if (limit == null && isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (limit == null && loadMoreError != null)
                  SliverToBoxAdapter(
                    child: Center(
                      child: TextButton(
                        onPressed: () => context.read<StoreProductsCubit>().loadMore(),
                        child: const Text('Gagal memuat — coba lagi'),
                      ),
                    ),
                  ),
              ],
            );
        }
      },
    );
  }
}

/// Tab Ulasan: ringkasan dan sebaran bintang **seluruh ulasan produk toko**
/// dari `partners-performance`.
///
/// Daftar ulasan per butir (b13) tidak dibuat: tidak ada endpoint ulasan
/// tingkat toko — ulasan hanya bisa dibaca per produk.
class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.performance});

  final StorePerformanceModel? performance;

  @override
  Widget build(BuildContext context) {
    final perf = performance;
    if (perf == null || !perf.hasRating) {
      return const XpEmptyState(
        icon: Icons.reviews_outlined,
        title: 'Belum ada ulasan',
        message: 'Ulasan pembeli untuk produk toko ini akan tampil di sini.',
      );
    }
    final muted = XpText.caption(context).copyWith(color: XpColors.textTertiary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        XpCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 28, color: XpColors.star),
                        Text(formatRating(perf.ratingAverage), style: XpText.headingXl(context)),
                      ],
                    ),
                    Text('dari 5', style: muted),
                    const SizedBox(height: 4),
                    Text('${formatCompact(perf.totalReviews)} ulasan', style: muted),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    for (var star = 5; star >= 1; star--)
                      _DistributionBar(
                        star: star,
                        count: perf.ratingDistribution[star] ?? 0,
                        total: perf.totalReviews,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Ulasan lengkap beserta balasan penjual bisa dibaca di halaman tiap produk.',
          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
        ),
      ],
    );
  }
}

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({required this.star, required this.count, required this.total});

  final int star;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total <= 0 ? 0.0 : (count / total).clamp(0, 1).toDouble();
    final muted = XpText.caption(context).copyWith(color: XpColors.textTertiary);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 14, child: Text('$star', style: muted)),
          const Icon(Icons.star_rounded, size: 12, color: XpColors.star),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(XpRadius.full),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: XpColors.sunken,
                valueColor: const AlwaysStoppedAnimation(XpColors.star),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(formatPercent(ratio * 100), textAlign: TextAlign.end, style: muted),
          ),
        ],
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.state});

  final StoreProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final store = state.store;
    final perf = state.performance;
    final description = (store.description ?? '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (description.isNotEmpty) ...[
          _DescriptionCard(text: description),
          const SizedBox(height: 12),
        ],
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Info Toko', style: XpText.titleL(context)),
              const SizedBox(height: 8),
              if (store.openedAt != null)
                XpKeyValueRow(label: 'Berjualan sejak', value: formatServerDate(store.openedAt)),
              XpKeyValueRow(label: 'Pengikut', value: formatNumber(store.followerCount)),
              if (store.sellerStatus.label != null)
                XpKeyValueRow(label: 'Status penjual', value: store.sellerStatus.label!),
              if (perf != null && perf.totalOrders > 0) ...[
                XpKeyValueRow(
                    label: 'Transaksi sukses', value: formatPercent(perf.successRatePercent)),
                XpKeyValueRow(
                    label: 'Tingkat pembatalan',
                    value: formatPercent(perf.cancellationRatePercent)),
              ],
              if (perf != null && (perf.responseRatePercent > 0 || perf.avgReplyMinutes != null))
                XpKeyValueRow(label: 'Chat dibalas', value: formatPercent(perf.responseRatePercent)),
              if (perf?.avgReplyMinutes != null && perf!.avgReplyMinutes! > 0)
                XpKeyValueRow(label: 'Rata-rata waktu balas', value: '± ${perf.avgReplyMinutes} menit'),
            ],
          ),
        ),
        if (description.isEmpty && store.openedAt == null) ...[
          const SizedBox(height: 12),
          Text('Penjual belum menulis deskripsi toko.',
              style: XpText.bodyS(context).copyWith(color: XpColors.textTertiary)),
        ],
      ],
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.text, this.maxLines, this.onMore});

  final String text;
  final int? maxLines;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tentang Toko', style: XpText.titleL(context)),
          const SizedBox(height: 8),
          Text(
            text,
            maxLines: maxLines,
            overflow: maxLines == null ? null : TextOverflow.ellipsis,
            style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
          ),
          if (onMore != null)
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(48, 40)),
              onPressed: onMore,
              child: const Text('Lihat Selengkapnya'),
            ),
        ],
      ),
    );
  }
}
