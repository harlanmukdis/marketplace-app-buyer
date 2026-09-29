import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/catalog_home_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/product_card.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Hasil pencarian (`hasil_pencarian_iphone_17`).
///
/// **Tanpa filter, tanpa urutan, tanpa tab Produk/Toko** — design_buyer.md
/// §5 no. 1–2: peringkat sepenuhnya milik server (`sort=recommended`), dan
/// hanya ada satu kolom cari. Pencarian memakai `GET /products?q=` lewat
/// [CatalogHomeCubit], bukan `/search/products` yang mati tanpa
/// Elasticsearch.
///
/// Tidak ada bottom nav dan tidak ada ikon keranjang di layar ini, sesuai
/// app bar varian E. Ikon mikrofon dari desain tidak dibuat — tidak ada
/// pencarian suara.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = CatalogHomeCubit();
        if (query.trim().isNotEmpty) cubit.search(query.trim());
        return cubit;
      },
      child: _SearchBody(initialQuery: query.trim()),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody({required this.initialQuery});

  final String initialQuery;

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery);
  final _scroll = ScrollController();
  final _focus = FocusNode(debugLabel: 'search-field');

  /// Kata kunci yang hasilnya sedang tampil — bisa berbeda dari isi kolom
  /// selagi user mengetik ulang.
  late String _submitted = widget.initialQuery;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      CatalogHomeCubit.get(context).loadMore();
    }
  }

  /// Mencari ulang **di tempat**, tanpa mendorong halaman baru — supaya
  /// tombol kembali tidak melewati tiap kata kunci satu per satu. URL-nya
  /// sengaja tidak di-`replace`: go_router membuat halaman (dan cubit) baru
  /// untuk itu, sehingga pencariannya ditembak dua kali.
  void _submit(String raw) {
    final text = raw.trim();
    FocusScope.of(context).unfocus();
    if (text.isEmpty || text == _submitted) return;
    setState(() => _submitted = text);
    CatalogHomeCubit.get(context).search(text);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogHomeCubit, CatalogHomeState>(
      listener: (context, state) {
        if (state is CatalogLoaded) {
          context.read<StoreDirectoryCubit>().ensure(state.products.map((p) => p.storeId));
        }
      },
      child: Scaffold(
        backgroundColor: XpColors.canvas,
        appBar: _SearchAppBar(
          controller: _controller,
          focusNode: _focus,
          autofocus: widget.initialQuery.isEmpty,
          onSubmit: _submit,
        ),
        body: _submitted.isEmpty
            ? const XpEmptyState(
                icon: Icons.search,
                title: 'Cari produk di Xpedia',
                message: 'Ketik nama produk atau merek, lalu tekan cari.',
              )
            : BlocBuilder<CatalogHomeCubit, CatalogHomeState>(
                builder: (context, state) => RefreshIndicator(
                  onRefresh: () => CatalogHomeCubit.get(context).retry(),
                  child: CustomScrollView(
                    controller: _scroll,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: _slivers(context, state),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _slivers(BuildContext context, CatalogHomeState state) {
    switch (state) {
      case CatalogInitial() || CatalogLoading():
        return const [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ];
      case CatalogError(:final error):
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: XpEmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'Hasil pencarian belum bisa dimuat',
              message: errorMessageFor(context, error),
              actionLabel: 'Coba Lagi',
              onAction: () => CatalogHomeCubit.get(context).retry(),
            ),
          ),
        ];
      case CatalogEmpty():
        return [
          SliverToBoxAdapter(child: _Header(query: _submitted, countLabel: '0 produk')),
          SliverFillRemaining(
            hasScrollBody: false,
            child: XpEmptyState(
              icon: Icons.search_off_rounded,
              title: 'Produk tidak ditemukan',
              message: 'Coba kata kunci lain yang lebih umum, atau periksa ejaannya.',
              actionLabel: 'Ubah Kata Kunci',
              onAction: () {
                _controller.selection =
                    TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
                _focus.requestFocus();
              },
            ),
          ),
        ];
      case CatalogLoaded(
          :final products,
          :final hasMore,
          :final total,
          :final isLoadingMore,
          :final loadMoreError,
        ):
        // `meta.total` dari server; kalau absen, jumlah pasti baru diketahui
        // setelah halaman terakhir termuat — sebelum itu "N+".
        final countLabel = total != null
            ? '${formatNumber(total)} produk'
            : hasMore
                ? '${formatNumber(products.length)}+ produk'
                : '${formatNumber(products.length)} produk';
        return [
          SliverToBoxAdapter(child: _Header(query: _submitted, countLabel: countLabel)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) => SliverGrid(
                gridDelegate: productGridDelegate(constraints.crossAxisExtent),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
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
                  child: Text('${errorMessageFor(context, loadMoreError)} — coba lagi'),
                ),
              ),
            ),
          if (!hasMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: _TrustCard(),
              ),
            ),
        ];
    }
  }
}

/// App bar varian E: kembali 48, kolom cari 44 yang bisa diedit.
class _SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _SearchAppBar({
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final ValueChanged<String> onSubmit;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<_SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<_SearchAppBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onText);
    super.dispose();
  }

  void _onText() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: XpColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      shape: Border(bottom: BorderSide(color: XpColors.borderSubtle)),
      leading: IconButton(
        tooltip: 'Kembali',
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.homeLayout),
        icon: Icon(Icons.arrow_back, size: 24, color: XpColors.textPrimary),
      ),
      title: Padding(
        padding: const EdgeInsetsDirectional.only(end: 16),
        child: SizedBox(
          height: 44,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            textInputAction: TextInputAction.search,
            onSubmitted: widget.onSubmit,
            style: XpText.bodyM(context),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: XpColors.sunken,
              hintText: 'Cari di Xpedia...',
              hintStyle: XpText.bodyM(context).copyWith(color: XpColors.textPlaceholder),
              prefixIcon: const Icon(Icons.search, size: 20, color: XpColors.textPlaceholder),
              suffixIcon: widget.controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Hapus',
                      icon: const Icon(Icons.close, size: 18, color: XpColors.textPlaceholder),
                      onPressed: () {
                        widget.controller.clear();
                        widget.focusNode.requestFocus();
                      },
                    ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(XpRadius.m),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(XpRadius.m),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(XpRadius.m),
                borderSide: BorderSide(color: XpColors.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.query, required this.countLabel});

  final String query;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
                children: [
                  const TextSpan(text: 'Hasil pencarian untuk '),
                  TextSpan(text: '"$query"', style: XpText.titleM(context)),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          XpPill(
            label: countLabel,
            tone: XpTone(XpColors.primarySubtle, XpColors.primary),
          ),
        ],
      ),
    );
  }
}

/// Kartu kepercayaan di kaki hasil pencarian.
///
/// Salinan desain "…kurir terpercaya dan berasuransi" diganti: kata
/// "asuransi" dilarang design_buyer.md §6, dan tidak ada data asuransi
/// pengiriman di API ini.
class _TrustCard extends StatelessWidget {
  const _TrustCard();

  @override
  Widget build(BuildContext context) {
    return XpCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _TrustRow(
            icon: Icons.verified_user_outlined,
            tone: XpTone(XpColors.primarySubtle, XpColors.primary),
            title: 'Transaksi Aman 100% Terlindungi',
            message: 'Garansi uang kembali & perlindungan pembeli Xpedia',
          ),
          Divider(height: 20, color: XpColors.sunken),
          _TrustRow(
            icon: Icons.local_shipping_outlined,
            tone: XpTone(XpColors.successSubtle, XpColors.success),
            title: 'Pengiriman Cepat di Seluruh Indonesia',
            message: 'Bekerja sama dengan kurir terpercaya dan resi yang bisa dilacak',
          ),
        ],
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow({
    required this.icon,
    required this.tone,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final XpTone tone;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: tone.background, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: tone.foreground),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: XpText.labelM(context).copyWith(fontWeight: FontWeight.w600)),
              Text(message,
                  style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
            ],
          ),
        ),
      ],
    );
  }
}
