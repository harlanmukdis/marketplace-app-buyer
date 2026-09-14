import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/catalog_home_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/product_card.dart';
import 'package:marketplace_app_member/util/error_message.dart';

/// Home katalog: pencarian, baris kategori, dan grid produk berpaginasi.
///
/// Cubit dibuat lokal lewat `BlocProvider` mengikuti pola yang berlaku di
/// repo ini — tidak ada provider global.
class CatalogHomeScreen extends StatelessWidget {
  const CatalogHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogHomeCubit()..load(),
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
  final _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  /// Memuat halaman berikutnya sebelum user benar-benar menyentuh dasar,
  /// supaya gulirannya tidak tersendat. `loadMore` sendiri sudah menolak
  /// panggilan ganda, jadi listener ini boleh berisik.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      CatalogHomeCubit.get(context).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      body: SafeArea(
        child: BlocBuilder<CatalogHomeCubit, CatalogHomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => CatalogHomeCubit.get(context).retry(),
              child: CustomScrollView(
                controller: _scrollController,
                // Selalu bisa digulir supaya pull-to-refresh tetap bekerja
                // di layar kosong maupun layar error.
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _searchField(context)),
                  ..._categoryRow(state),
                  ..._content(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => CatalogHomeCubit.get(context).search(value),
        style: AppStyles.styleRegular14(context).copyWith(
          color: dark ? kDarkSecondColor : kLightSecondColor,
        ),
        decoration: InputDecoration(
          hintText: 'Cari produk',
          hintStyle: AppStyles.styleRegular14(context).copyWith(
            color: dark ? kDarkThirdColor : kLightThirdColor,
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    CatalogHomeCubit.get(context).search('');
                  },
                ),
          filled: true,
          fillColor: dark ? kLightSecondColor : kBorderColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  List<Widget> _categoryRow(CatalogHomeState state) {
    final categories = switch (state) {
      CatalogLoaded(:final categories) => categories,
      CatalogEmpty(:final categories) => categories,
      _ => const <CategoryModel>[],
    };
    if (categories.isEmpty) return const [];

    final selected = switch (state) {
      CatalogLoaded(:final query) => query?.categoryId,
      CatalogEmpty(:final query) => query?.categoryId,
      _ => null,
    };

    return [
      SliverToBoxAdapter(
        child: SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => 8.sbw,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _CategoryChip(
                  label: 'Semua',
                  selected: selected == null,
                  onTap: () => CatalogHomeCubit.get(context).selectCategory(null),
                );
              }
              final category = categories[index - 1];
              return _CategoryChip(
                label: category.name,
                selected: selected == category.id,
                onTap: () =>
                    CatalogHomeCubit.get(context).selectCategory(category.id),
              );
            },
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
    ];
  }

  List<Widget> _content(BuildContext context, CatalogHomeState state) {
    return switch (state) {
      CatalogInitial() || CatalogLoading() => [
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      CatalogError(:final error) => [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _Message(
              icon: Icons.cloud_off_rounded,
              title: errorMessageFor(context, error),
              actionLabel: 'Coba lagi',
              onAction: () => CatalogHomeCubit.get(context).retry(),
            ),
          ),
        ],
      CatalogEmpty(:final query) => [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _Message(
              icon: Icons.search_off_rounded,
              title: query?.isSearching ?? false
                  ? 'Tidak ada produk yang cocok dengan pencarian itu'
                  : 'Belum ada produk di sini',
              // Saat ada filter aktif, jalan keluarnya "hapus filter", bukan
              // "coba lagi" — mengulang permintaan yang sama akan kosong lagi.
              actionLabel: (query?.hasFilter ?? false) ? 'Hapus filter' : null,
              onAction: () => CatalogHomeCubit.get(context).clearFilters(),
            ),
          ),
        ],
      CatalogLoaded() => _grid(context, state),
    };
  }

  List<Widget> _grid(BuildContext context, CatalogLoaded state) {
    return [
      SliverPadding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final product = state.products[index];
              return ProductCard(
                product: product,
                onTap: () => context.push(
                  AppRoutes.productDetailPath(product.id),
                ),
              );
            },
            childCount: state.products.length,
          ),
        ),
      ),
      SliverToBoxAdapter(child: _footer(context, state)),
    ];
  }

  Widget _footer(BuildContext context, CatalogLoaded state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final error = state.loadMoreError;
    if (error != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
        child: Center(
          child: TextButton.icon(
            onPressed: () => CatalogHomeCubit.get(context).loadMore(),
            icon: const Icon(Icons.refresh),
            label: Text(errorMessageFor(context, error)),
          ),
        ),
      );
    }

    return const SizedBox(height: 24);
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final primary = dark ? kDarkPrimaryColor : kLightPrimaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? primary : (dark ? kLightSecondColor : kBorderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppStyles.styleMedium14(context).copyWith(
            color: selected
                ? kWhiteColor
                : (dark ? kDarkSecondColor : kLightSecondColor),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
          16.sbh,
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.styleMedium16(context).copyWith(
              color: dark ? kDarkSecondColor : kLightSecondColor,
            ),
          ),
          if (actionLabel != null) ...[
            16.sbh,
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
