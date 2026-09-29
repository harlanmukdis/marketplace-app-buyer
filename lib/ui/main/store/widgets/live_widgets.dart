import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/store/cubit/live_sessions_cubit.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Potongan UI live commerce: strip "LIVE NOW" beranda dan kartu sesi di tab
/// Live storefront.
///
/// 🔶 **Belum ada pemutar live.** Backend belum punya endpoint daftar sesi
/// (mock di debug) maupun `playback_url` yang bisa diputar pembeli, jadi
/// mengetuk kartu membuka **storefront** tokonya — bukan layar tayangan
/// palsu.

/// Pil merah "LIVE" dengan titik putih.
class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key, this.label = 'LIVE'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: XpColors.danger,
        borderRadius: BorderRadius.circular(XpRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: XpText.labelS(context)
                .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Strip "LIVE NOW · Xpedia Live Interaktif" di beranda (inventaris §3.1
/// no. 4). Tidak menggambar apa pun selama tidak ada sesi yang tayang atau
/// endpoint-nya belum tersedia — strip kosong lebih buruk daripada tidak ada.
class HomeLiveStrip extends StatelessWidget {
  const HomeLiveStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveSessionsCubit, LiveSessionsState>(
      listener: (context, state) {
        if (state is LiveSessionsLoaded) {
          context.read<StoreDirectoryCubit>().ensure(state.sessions.map((s) => s.storeId));
        }
      },
      builder: (context, state) {
        final live = state.live;
        if (state is! LiveSessionsLoaded || live.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  const LiveBadge(label: 'LIVE NOW'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Xpedia Live Interaktif',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XpText.titleL(context).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SimulatedBadge(meta: state.meta),
                ],
              ),
            ),
            SizedBox(
              height: LiveSessionCard.height,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: live.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => LiveSessionCard(session: live[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Kartu sesi live w144 (inventaris §3.1 no. 4).
class LiveSessionCard extends StatelessWidget {
  const LiveSessionCard({super.key, required this.session, this.onTap});

  final LiveSessionModel session;

  /// Bawaan: membuka storefront tokonya (belum ada pemutar live).
  final VoidCallback? onTap;

  static const double width = 144;
  static const double imageHeight = 160;
  static const double height = imageHeight + 52;

  @override
  Widget build(BuildContext context) {
    // Nama dari StoreDirectoryCubit (GET /stores/{id}) lebih dipercaya
    // daripada `store_name` usulan, yang hari ini datang dari fixture mock.
    final store = context.select<StoreDirectoryCubit, StoreModel?>((c) => c.state[session.storeId]);
    final storeName = store?.name ?? session.storeName;
    final verified = store != null && store.sellerStatus != SellerStatus.unverified;
    final promo = session.promoLabel?.trim() ?? '';

    return SizedBox(
      width: width,
      child: XpCard(
        padding: EdgeInsets.zero,
        onTap: onTap ?? () => context.push(AppRoutes.storePath(session.storeId)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _Thumbnail(url: session.thumbnailUrl),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)],
                        stops: [0.45, 1],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(XpRadius.xs),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fiber_manual_record, size: 10, color: XpColors.danger),
                          const SizedBox(width: 3),
                          Text(
                            formatCompact(session.viewerCount),
                            style: XpText.caption(context).copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 8,
                    end: 8,
                    bottom: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: XpText.labelS(context)
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                storeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: XpText.caption(context).copyWith(color: Colors.white),
                              ),
                            ),
                            if (verified) ...[
                              const SizedBox(width: 2),
                              const Icon(Icons.verified, size: 12, color: Color(0xff60A5FA)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo.isEmpty ? 'Sedang live' : promo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: XpText.labelS(context)
                        .copyWith(color: XpColors.danger, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    session.soldCount > 0 ? '${formatCompact(session.soldCount)} terjual' : ' ',
                    style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const fallback = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [XpColors.navy, Color(0xff465BA0)],
        ),
      ),
      child: Center(child: Icon(Icons.live_tv_rounded, size: 40, color: Colors.white54)),
    );
    final link = url?.trim();
    if (link == null || link.isEmpty) return fallback;
    return Image.network(link, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback);
  }
}

/// Isi tab **Live** storefront (b12, dipangkas ke yang ada datanya): sesi yang
/// sedang tayang dan "Jadwal Live Berikutnya".
///
/// Tidak dibangun dari b12 karena tidak ada datanya: pemutar & obrolan live,
/// "Produk yang Dibahas" (`GET /live-sessions/{id}/products` butuh id sesi
/// dari daftar yang belum ada), tombol "Ingatkan Saya", dan statistik live 30
/// hari.
class StoreLiveTab extends StatelessWidget {
  const StoreLiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveSessionsCubit, LiveSessionsState>(
      builder: (context, state) {
        switch (state) {
          case LiveSessionsLoading():
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            );
          case LiveSessionsUnavailable():
            return const XpEmptyState(
              icon: Icons.live_tv_outlined,
              title: 'Live belum tersedia',
              message: 'Fitur live toko belum bisa dibuka saat ini.',
            );
          case LiveSessionsEmpty():
            return const XpEmptyState(
              icon: Icons.live_tv_outlined,
              title: 'Belum ada live',
              message: 'Toko ini sedang tidak live dan belum punya jadwal live.',
            );
          case LiveSessionsLoaded(:final meta):
            final live = state.live;
            final scheduled = state.scheduled;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        live.isEmpty ? 'Tidak sedang live' : 'Live Sekarang',
                        style: XpText.titleL(context),
                      ),
                    ),
                    SimulatedBadge(meta: meta),
                  ],
                ),
                const SizedBox(height: 12),
                for (final session in live) ...[
                  _LiveRow(session: session),
                  const SizedBox(height: 12),
                ],
                if (live.isNotEmpty)
                  Text(
                    'Pemutar live belum tersedia di aplikasi.',
                    style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                  ),
                if (scheduled.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('Jadwal Live Berikutnya', style: XpText.titleL(context)),
                  const SizedBox(height: 8),
                  for (final session in scheduled)
                    XpCard(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.event_outlined, color: XpColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(session.title, style: XpText.titleM(context)),
                                const SizedBox(height: 2),
                                Text(
                                  formatServerDateTime(session.scheduledAt),
                                  style: XpText.bodyS(context)
                                      .copyWith(color: XpColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            );
        }
      },
    );
  }
}

class _LiveRow extends StatelessWidget {
  const _LiveRow({required this.session});

  final LiveSessionModel session;

  @override
  Widget build(BuildContext context) {
    final promo = session.promoLabel?.trim() ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(XpRadius.l),
        gradient: const LinearGradient(colors: [XpColors.navy, Color(0xff465BA0)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LiveBadge(),
              const SizedBox(width: 8),
              const Icon(Icons.visibility_outlined, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                '${formatCompact(session.viewerCount)} menonton',
                style: XpText.caption(context).copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            session.title,
            style: XpText.titleL(context).copyWith(color: Colors.white),
          ),
          if (promo.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              promo,
              style: XpText.labelM(context)
                  .copyWith(color: XpColors.signatureGold, fontWeight: FontWeight.w700),
            ),
          ],
          if (session.startedAt != null) ...[
            const SizedBox(height: 4),
            Text(
              'Mulai ${formatServerDateTime(session.startedAt)}',
              style: XpText.caption(context).copyWith(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }
}
