import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/catalog_home_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/home_layout_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/home_sections.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/product_card.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/live_sessions_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/widgets/live_widgets.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Beranda Xpedia (`beranda_xpedia_buyer`).
///
/// Yang dibangun dari desain: app bar varian A + strip "Kirim ke", kartu
/// Xpedia Wallet, section home CMS (hero carousel, promo grid, baris
/// kategori, flash sale, rel rekomendasi — dari `GET /home/layout`), baris
/// kategori, strip "LIVE NOW", grid "Rekomendasi Spesial", dan banner
/// kepercayaan.
///
/// * **Home CMS** memakai endpoint sungguhan yang di dev masih `[]` (tabel
///   CMS belum di-seed) — beranda tampil persis seperti sebelumnya sampai
///   admin mengisi section. Tidak di-mock.
/// * 🔶 **Strip Live** membaca endpoint usulan `GET /live-sessions` (mock di
///   debug, berlencana "Simulasi"); tanpa mock ia tidak tampil.
/// * **Grid layanan** (XpediaFood/Ride/Mart/Tagihan) sengaja tidak dibangun —
///   layanan itu tidak ada di API ini.
///
/// Pencarian **tidak** diketik di sini: kolom cari membuka layar pencarian
/// tersendiri, seperti desainnya.
class CatalogHomeScreen extends StatelessWidget {
  const CatalogHomeScreen({super.key, this.onLogoTap});

  /// Logo Xpedia adalah kontrol Beranda (design_buyer.md §5 no. 3) — di tab
  /// Beranda sendiri ia menggulir ke atas.
  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CatalogHomeCubit()..load()),
        BlocProvider(create: (_) => AddressCubit()..load()),
        BlocProvider(create: (_) => WalletCubit()..load()),
        BlocProvider(create: (_) => HomeLayoutCubit()..load()),
        BlocProvider(create: (_) => LiveSessionsCubit.liveNow()..load()),
      ],
      child: const _CatalogHomeBody(),
    );
  }
}

class _CatalogHomeBody extends StatefulWidget {
  const _CatalogHomeBody();

  @override
  State<_CatalogHomeBody> createState() => _CatalogHomeBodyState();
}

class _CatalogHomeBodyState extends State<_CatalogHomeBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Memuat halaman berikutnya sebelum user benar-benar menyentuh dasar.
  /// `loadMore` sendiri menolak panggilan ganda, jadi listener ini boleh
  /// berisik.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      CatalogHomeCubit.get(context).loadMore();
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Alamat utama menentukan tujuan kirim: server membuang produk yang
        // tidak bisa dikirim ke sana.
        BlocListener<AddressCubit, AddressState>(
          listener: (context, state) {
            final primary = state.primary;
            if (primary == null) return;
            CatalogHomeCubit.get(context)
                .setDestination(city: primary.city, province: primary.province);
          },
        ),
        BlocListener<CatalogHomeCubit, CatalogHomeState>(
          listener: (context, state) {
            if (state is CatalogLoaded) {
              context.read<StoreDirectoryCubit>().ensure(state.products.map((p) => p.storeId));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: XpColors.canvas,
        appBar: XpHomeAppBar(
          onLogoTap: _scrollToTop,
          bottom: const _DeliveryStrip(),
        ),
        body: BlocBuilder<CatalogHomeCubit, CatalogHomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  CatalogHomeCubit.get(context).retry(),
                  context.read<WalletCubit>().load(),
                  context.read<HomeLayoutCubit>().load(),
                  context.read<LiveSessionsCubit>().load(),
                ]);
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(child: _WalletCard()),
                  ),
                  const _CmsSections(),
                  ..._categories(context, state),
                  const SliverToBoxAdapter(child: HomeLiveStrip()),
                  const SliverToBoxAdapter(
                    child: XpSectionHeader(
                      title: 'Rekomendasi Spesial',
                      subtitle: 'Pilihan terbaik dikurasi khusus untukmu',
                    ),
                  ),
                  ..._products(context, state),
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                    sliver: SliverToBoxAdapter(child: _TrustBanner()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _categories(BuildContext context, CatalogHomeState state) {
    final categories = switch (state) {
      CatalogLoaded(:final categories) => categories,
      CatalogEmpty(:final categories) => categories,
      _ => const <CategoryModel>[],
    };
    if (categories.isEmpty) return const [];
    final selected = switch (state) {
      CatalogLoaded(:final query) || CatalogEmpty(:final query) => query?.categoryId,
      _ => null,
    };
    final roots = categories.where((c) => c.parentId == null).toList();
    final shown = roots.isEmpty ? categories : roots;
    return [
      SliverToBoxAdapter(
        child: SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            children: [
              _CategoryChip(
                label: 'Semua',
                selected: selected == null,
                onTap: () => CatalogHomeCubit.get(context).selectCategory(null),
              ),
              for (final category in shown)
                _CategoryChip(
                  label: category.name,
                  selected: selected == category.id,
                  onTap: () => CatalogHomeCubit.get(context).selectCategory(category.id),
                ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _products(BuildContext context, CatalogHomeState state) {
    switch (state) {
      case CatalogInitial():
      case CatalogLoading():
        return const [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ];
      case CatalogError(:final error):
        return [
          SliverToBoxAdapter(
            child: XpEmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'Produk belum bisa dimuat',
              message: errorMessageFor(context, error),
              actionLabel: 'Coba Lagi',
              onAction: () => CatalogHomeCubit.get(context).retry(),
            ),
          ),
        ];
      case CatalogEmpty(:final query):
        return [
          SliverToBoxAdapter(
            child: XpEmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Belum ada produk di sini',
              message: 'Coba kategori lain atau cari produk yang kamu butuhkan.',
              actionLabel: query?.hasFilter == true ? 'Lihat Semua Produk' : null,
              onAction: () => CatalogHomeCubit.get(context).clearFilters(),
            ),
          ),
        ];
      case CatalogLoaded(:final products, :final isLoadingMore, :final loadMoreError):
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) => SliverGrid(
                gridDelegate: productGridDelegate(constraints.crossAxisExtent),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ProductModel product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.push(AppRoutes.productDetailPath(product.id)),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
          ),
          if (isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          if (loadMoreError != null)
            SliverToBoxAdapter(
              child: Center(
                child: TextButton(
                  onPressed: () => CatalogHomeCubit.get(context).loadMore(),
                  child: const Text('Gagal memuat — coba lagi'),
                ),
              ),
            ),
        ];
    }
  }
}

/// Section home CMS, terurut `sort_order`. Tidak menggambar apa pun selama
/// layout kosong atau gagal dimuat.
class _CmsSections extends StatelessWidget {
  const _CmsSections();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeLayoutCubit, HomeLayoutState>(
      builder: (context, state) {
        if (state is! HomeLayoutLoaded) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverList.list(
          children: [
            for (final section in state.sections)
              HomeCmsSection(
                section: section,
                onCategory: (id) => CatalogHomeCubit.get(context).selectCategory(id),
              ),
          ],
        );
      },
    );
  }
}

/// Strip "Kirim ke …" di bawah app bar.
class _DeliveryStrip extends StatelessWidget implements PreferredSizeWidget {
  const _DeliveryStrip();

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final primary = context.watch<AddressCubit>().state.primary;
    final label = primary == null
        ? 'Atur alamat pengiriman'
        : [primary.label, primary.city].where((v) => v.trim().isNotEmpty).join(', ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Material(
        color: XpColors.sunken,
        borderRadius: BorderRadius.circular(XpRadius.s),
        child: InkWell(
          borderRadius: BorderRadius.circular(XpRadius.s),
          onTap: () async {
            await context.push(AppRoutes.addresses);
            if (context.mounted) context.read<AddressCubit>().load();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: XpColors.primary),
                const SizedBox(width: 6),
                Text('Kirim ke ',
                    style: XpText.bodyS(context).copyWith(color: XpColors.textTertiary)),
                Expanded(
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XpText.labelM(context)),
                ),
                Text('Ubah',
                    style: XpText.labelM(context)
                        .copyWith(color: XpColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartu Xpedia Wallet navy dengan saldo dan Top Up.
class _WalletCard extends StatelessWidget {
  const _WalletCard();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WalletCubit>().state;
    final balance = switch (state) {
      WalletReady(:final wallet) => formatRupiah(wallet.availableBalance),
      WalletLoading() => '…',
      WalletError() => 'Rp -',
    };
    return Semantics(
      button: true,
      label: 'Xpedia Wallet, saldo $balance',
      child: InkWell(
        borderRadius: BorderRadius.circular(XpRadius.l),
        onTap: () => context.push(AppRoutes.wallet),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(XpRadius.l),
            gradient: const LinearGradient(
              colors: [Color(0xff0F286C), Color(0xff112D7C), Color(0xff0056FE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(XpRadius.m),
                ),
                child: const Icon(Icons.account_balance_wallet_outlined,
                    color: XpColors.signatureGold, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Xpedia Wallet',
                        style: XpText.labelS(context)
                            .copyWith(color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 2),
                    Text(balance,
                        style: XpText.titleL(context)
                            .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                onPressed: () => context.push(AppRoutes.wallet),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Top Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: XpText.labelM(context).copyWith(
          color: selected ? XpColors.primary : XpColors.textSecondary,
        ),
        side: BorderSide(color: selected ? XpColors.primary : XpColors.borderDefault),
      ),
    );
  }
}

/// Banner kepercayaan. Desain menulis "Xpedia Care" — merek yang dilarang
/// design_buyer.md §5 no. 11; satu-satunya merek layanan adalah Xpedia 911.
class _TrustBanner extends StatelessWidget {
  const _TrustBanner();

  @override
  Widget build(BuildContext context) {
    return XpBanner(
      icon: Icons.verified_user_outlined,
      title: 'Transaksi 100% Aman & Terlindungi',
      message: 'Butuh bantuan? Xpedia 911 siap membantu kapan saja.',
      onTap: () => context.push(AppRoutes.support),
      trailing: Icon(Icons.chevron_right, color: XpColors.primary),
    );
  }
}
