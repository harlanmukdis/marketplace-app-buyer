import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/followed_stores_cubit.dart';
import 'package:marketplace_app_member/ui/main/store/widgets/store_widgets.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Toko yang Saya Ikuti (`b16_toko_diikuti_mobile`, ponsel 2).
///
/// Dari papan b16 yang **tidak** dibuat, karena backend tidak punya
/// datanya: kolom cari dan urutan (tidak ada parameter di `/me/following`),
/// chip "Sedang Live" dan lencana LIVE (tidak ada live commerce), lencana
/// status penjual dan baris kategori (barisnya tidak membawa
/// `primary_status` maupun kategori), serta "Pengaturan Notifikasi Toko"
/// (tidak ada preferensi notifikasi per toko).
class FollowedStoresScreen extends StatelessWidget {
  const FollowedStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FollowedStoresCubit()..load(),
      child: const _FollowedBody(),
    );
  }
}

class _FollowedBody extends StatefulWidget {
  const _FollowedBody();

  @override
  State<_FollowedBody> createState() => _FollowedBodyState();
}

class _FollowedBodyState extends State<_FollowedBody> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      final position = _scroll.position;
      if (position.pixels >= position.maxScrollExtent - 300) {
        context.read<FollowedStoresCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Toko yang Saya Ikuti'),
      body: BlocConsumer<FollowedStoresCubit, FollowedStoresState>(
        listenWhen: (_, current) =>
            current is FollowedStoresLoaded && current.actionError != null,
        listener: (context, state) {
          final error = (state as FollowedStoresLoaded).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(errorMessageFor(context, error))));
          context.read<FollowedStoresCubit>().clearActionError();
        },
        builder: (context, state) {
          return switch (state) {
            FollowedStoresLoading() => const Center(child: CircularProgressIndicator()),
            FollowedStoresError(:final error) => XpEmptyState(
                icon: Icons.wifi_off_rounded,
                title: 'Daftar toko belum bisa dimuat',
                message: errorMessageFor(context, error),
                actionLabel: 'Coba Lagi',
                onAction: () => context.read<FollowedStoresCubit>().load(),
              ),
            FollowedStoresLoaded(:final stores) when stores.isEmpty => XpEmptyState(
                icon: Icons.storefront_outlined,
                title: 'Belum Ada Toko yang Diikuti',
                message: 'Ikuti toko favoritmu dari halaman toko agar mudah ditemukan lagi.',
                actionLabel: 'Mulai Cari Produk',
                onAction: () => context.push(AppRoutes.search),
              ),
            FollowedStoresLoaded() => RefreshIndicator(
                onRefresh: () => context.read<FollowedStoresCubit>().load(),
                child: ListView.separated(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.stores.length + (state.isLoadingMore || state.loadMoreError != null ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index >= state.stores.length) {
                      return state.isLoadingMore
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                              child: TextButton(
                                onPressed: () => context.read<FollowedStoresCubit>().loadMore(),
                                child: const Text('Gagal memuat — coba lagi'),
                              ),
                            );
                    }
                    final store = state.stores[index];
                    return _StoreRow(
                      store: store,
                      busy: state.mutatingIds.contains(store.id),
                    );
                  },
                ),
              ),
          };
        },
      ),
    );
  }
}

class _StoreRow extends StatelessWidget {
  const _StoreRow({required this.store, required this.busy});

  final FollowedStoreModel store;
  final bool busy;

  Future<void> _visit(BuildContext context) async {
    final cubit = context.read<FollowedStoresCubit>();
    await context.push(AppRoutes.storePath(store.id));
    // Bisa saja berhenti mengikuti dari storefront; daftar dibaca ulang
    // supaya baris itu tidak tertinggal.
    if (!cubit.isClosed) cubit.load();
  }

  Future<void> _unfollow(BuildContext context) async {
    final cubit = context.read<FollowedStoresCubit>();
    final directory = context.read<StoreDirectoryCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final updated = await cubit.unfollow(store.id);
    if (updated == null) return;
    directory.put(updated);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Berhenti mengikuti ${store.name}')));
  }

  @override
  Widget build(BuildContext context) {
    final muted = XpText.caption(context).copyWith(color: XpColors.textTertiary);
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(XpRadius.m));
    return Opacity(
      opacity: busy ? 0.6 : 1,
      child: XpCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                StoreLogo(name: store.name, logoUrl: store.logoUrl, size: 56),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: XpText.titleL(context)),
                      const SizedBox(height: 2),
                      // Tanpa ulasan, bintangnya tidak digambar sama sekali.
                      if (store.ratingCount > 0)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: XpColors.star),
                            const SizedBox(width: 2),
                            Text(formatRating(store.ratingAvg),
                                style: XpText.caption(context)
                                    .copyWith(fontWeight: FontWeight.w600)),
                            Text(' (${formatCompact(store.ratingCount)} penilaian)', style: muted),
                          ],
                        ),
                      if (store.followedAt != null)
                        Text('Diikuti sejak ${formatServerDate(store.followedAt)}', style: muted),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: XpColors.primarySubtle,
                        foregroundColor: XpColors.primary,
                        shape: shape,
                        textStyle: XpText.labelL(context),
                      ),
                      onPressed: () => _visit(context),
                      child: const Text('Kunjungi Toko'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: XpColors.textSecondary,
                        side: BorderSide(color: XpColors.borderDefault),
                        shape: shape,
                        textStyle: XpText.labelL(context),
                      ),
                      onPressed: busy ? null : () => _unfollow(context),
                      child: const Text('Berhenti Mengikuti'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
