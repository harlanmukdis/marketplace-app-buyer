import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/my_reviews_cubit.dart';
import 'package:marketplace_app_member/ui/main/review/screens/review_form_screen.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Ulasan Saya — daftar ulasan milik pembeli dengan tombol **Ubah** selama
/// 30 hari sesudah dikirim, lalu **Terkunci** (kebijakan di desain §3.24).
///
/// ⚠️ `GET /me/reviews` dan `PATCH /reviews/{id}` **diusulkan** (docs/22 #8)
/// dan dijawab mock di build debug (ditandai "Simulasi"). Kalau rutenya tidak
/// ada — mock dimatikan — layar mengatakannya, bukan menampilkan daftar
/// kosong yang menyesatkan.
///
/// Tidak ada desain mobile khusus untuk layar ini; kartunya mengikuti pola
/// kartu pesanan (§3.12) dan formulir ulasan (§3.24).
class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyReviewsCubit()..load(),
      child: const _MyReviewsBody(),
    );
  }
}

class _MyReviewsBody extends StatefulWidget {
  const _MyReviewsBody();

  @override
  State<_MyReviewsBody> createState() => _MyReviewsBodyState();
}

class _MyReviewsBodyState extends State<_MyReviewsBody> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      final p = _scroll.position;
      if (p.pixels >= p.maxScrollExtent - 300) context.read<MyReviewsCubit>().loadMore();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _edit(MyReviewModel review) async {
    final cubit = context.read<MyReviewsCubit>();
    // `Navigator.push`, bukan rute: `orderReviewPath` hanya membawa id, dan
    // mode ubah butuh ulasannya sendiri (terutama `editable_until`).
    final result = await Navigator.of(context).push<Object?>(MaterialPageRoute(
      builder: (_) => ReviewFormScreen(
        orderId: review.orderId,
        orderItemId: review.orderItemId,
        existing: review,
      ),
    ));
    if (result is MyReviewModel) {
      cubit.replace(result);
    } else if (result == true) {
      await cubit.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Ulasan Saya', actions: [SupportActionButton()]),
      body: BlocConsumer<MyReviewsCubit, MyReviewsState>(
        listenWhen: (_, current) => current is MyReviewsLoaded,
        listener: (context, state) => context.read<StoreDirectoryCubit>().ensure(
            (state as MyReviewsLoaded).reviews.map((r) => r.storeId).where((id) => id > 0)),
        builder: (context, state) {
          final cubit = context.read<MyReviewsCubit>();
          return switch (state) {
            MyReviewsLoading() => const Center(child: CircularProgressIndicator()),
            MyReviewsError(:final error) => XpEmptyState(
                icon: Icons.cloud_off_outlined,
                title: 'Gagal memuat ulasan',
                message: orderErrorMessage(context, error),
                actionLabel: 'Coba Lagi',
                onAction: cubit.load,
              ),
            MyReviewsUnsupported() => const XpEmptyState(
                icon: Icons.rate_review_outlined,
                title: 'Ulasan Saya belum tersedia',
                message: 'Daftar ulasanmu akan muncul di sini setelah fitur ini aktif.',
              ),
            MyReviewsEmpty() => XpEmptyState(
                icon: Icons.rate_review_outlined,
                title: 'Belum ada ulasan',
                message: 'Ulasan untuk pesanan yang sudah selesai akan muncul di sini.',
                actionLabel: 'Mulai Belanja',
                onAction: () => context.go(AppRoutes.homeLayout),
              ),
            MyReviewsLoaded() => RefreshIndicator(
                onRefresh: cubit.load,
                child: ListView.separated(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: state.reviews.length + 2,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) return _Header(state: state);
                    if (index == state.reviews.length + 1) return _Footer(state: state);
                    final review = state.reviews[index - 1];
                    return _ReviewCard(review: review, onEdit: () => _edit(review));
                  },
                ),
              ),
          };
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final MyReviewsLoaded state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Ulasan bisa diubah dalam 30 hari setelah dikirim.',
            style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
          ),
        ),
        SimulatedBadge(meta: state.meta),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final MyReviewsLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final error = state.loadMoreError;
    if (error != null) {
      return Center(
        child: TextButton.icon(
          onPressed: context.read<MyReviewsCubit>().loadMore,
          icon: const Icon(Icons.refresh),
          label: Text(orderErrorMessage(context, error)),
        ),
      );
    }
    return const SizedBox(height: 8);
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.onEdit});

  final MyReviewModel review;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final editable = review.canEdit();
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (review.storeId > 0) OrderStoreName(storeId: review.storeId),
          Text(review.productName ?? 'Produk dari pesananmu',
              maxLines: 2, overflow: TextOverflow.ellipsis, style: XpText.titleM(context)),
          if (review.optionLabel.isNotEmpty)
            Text(review.optionLabel,
                style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
          const SizedBox(height: 8),
          Row(
            children: [
              Semantics(
                label: '${review.rating} dari 5 bintang',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var star = 1; star <= 5; star++)
                      Icon(
                        star <= review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 20,
                        color: star <= review.rating ? XpColors.star : XpColors.textPlaceholder,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (review.isAnonymous)
                XpPill(
                  label: 'Anonim',
                  icon: Icons.visibility_off_outlined,
                  tone: XpTone(XpColors.sunken, XpColors.textSecondary),
                ),
            ],
          ),
          if (review.hasComment) ...[
            const SizedBox(height: 6),
            Text(review.comment!, style: XpText.bodyM(context)),
          ],
          const SizedBox(height: 6),
          Text(
            [
              'Dikirim ${formatServerDate(review.createdAt)}',
              if (review.wasEdited) 'diubah ${formatServerDate(review.updatedAt)}',
            ].join(' · '),
            style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
          ),
          const Divider(height: 20),
          if (editable)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Bisa diubah sampai ${formatServerDate(review.editableUntil)}',
                    style: XpText.caption(context).copyWith(color: XpColors.textSecondary),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Ubah Ulasan'),
                ),
              ],
            )
          else
            Row(
              children: [
                XpPill(
                  label: 'Terkunci',
                  icon: Icons.lock_outline,
                  tone: XpTone(XpColors.sunken, XpColors.textSecondary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lewat 30 hari, ulasan tidak bisa diubah lagi.',
                    style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
