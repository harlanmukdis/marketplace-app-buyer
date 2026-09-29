import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/product_reviews_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Bagian "Ulasan Pembeli" di halaman detail produk
/// (`detail_produk_jbl_tune_770nc` §8 + batang sebaran dari b13).
///
/// Dibuat sebagai bagian, bukan layar sendiri, karena ulasan hampir selalu
/// dibaca sambil melihat produknya. Produk tanpa ulasan **tidak menampilkan
/// bintang maupun "0,0"** (design_buyer.md §5) — hanya satu kalimat.
///
/// Tidak ditampilkan karena API tidak mengirimnya: nama pengulas (selalu
/// "Pembeli"), varian yang diulas, foto/video, dan jumlah "Membantu".
class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductReviewsCubit(productId)..load(),
      child: const _ReviewsBody(),
    );
  }
}

class _ReviewsBody extends StatelessWidget {
  const _ReviewsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductReviewsCubit, ProductReviewsState>(
      builder: (context, state) {
        final histogram = state.histogram;
        return XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(child: Text('Ulasan Pembeli', style: XpText.titleL(context))),
                  if (!histogram.isEmpty) ...[
                    const SizedBox(width: 8),
                    XpPill(
                      label: '${formatRating(histogram.average)} / 5',
                      icon: Icons.star_rounded,
                      tone: XpTone(XpColors.warningSubtle, const Color(0xff8C5002)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              switch (state) {
                ProductReviewsLoading() => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ProductReviewsError(:final error) => Text(
                    errorMessageFor(context, error),
                    style: XpText.bodyS(context).copyWith(color: XpColors.danger),
                  ),
                _ => _Content(state: state),
              },
            ],
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});

  final ProductReviewsState state;

  @override
  Widget build(BuildContext context) {
    final histogram = state.histogram;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!histogram.isEmpty) ...[
          _Histogram(histogram: histogram, active: state.activeRating),
          const SizedBox(height: 16),
        ],
        if (state is ProductReviewsEmpty)
          _EmptyNote(hasFilter: state.activeRating != null)
        else if (state is ProductReviewsLoaded)
          _ReviewList(state: state as ProductReviewsLoaded),
      ],
    );
  }
}

/// Sebaran bintang, sekaligus filter.
///
/// Angkanya dari `meta.rating_histogram` — menghitung **ulasan per bintang
/// persis**, berbeda dari `meta.facets.rating` di listing produk yang
/// menghitung produk per ambang dan bersifat kumulatif.
class _Histogram extends StatelessWidget {
  const _Histogram({required this.histogram, required this.active});

  final RatingHistogram histogram;
  final int? active;

  @override
  Widget build(BuildContext context) {
    final muted = XpText.caption(context).copyWith(color: XpColors.textTertiary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 24, color: XpColors.star),
                  const SizedBox(width: 2),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(formatRating(histogram.average),
                          style: XpText.headingXl(context)),
                    ),
                  ),
                ],
              ),
              Text('${formatCompact(histogram.total)} ulasan', style: muted),
              if (active != null)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 40),
                  ),
                  onPressed: () => ProductReviewsCubit.get(context).filterByRating(null),
                  child: const Text('Semua'),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              for (final bucket in histogram.breakdown)
                InkWell(
                  // Filter bintang benar-benar bekerja di endpoint ini — tidak
                  // seperti ?status= di /orders yang diabaikan server.
                  onTap: bucket.count == 0
                      ? null
                      : () => ProductReviewsCubit.get(context).filterByRating(bucket.rating),
                  borderRadius: BorderRadius.circular(XpRadius.xs),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22,
                          child: Text('${bucket.rating}',
                              style: muted.copyWith(
                                fontWeight:
                                    bucket.rating == active ? FontWeight.w700 : null,
                                color: bucket.rating == active ? XpColors.primary : null,
                              )),
                        ),
                        const Icon(Icons.star_rounded, size: 12, color: XpColors.star),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(XpRadius.full),
                            child: LinearProgressIndicator(
                              value: bucket.ratio,
                              minHeight: 6,
                              backgroundColor: XpColors.sunken,
                              valueColor: AlwaysStoppedAnimation(
                                bucket.rating == active ? XpColors.primary : XpColors.star,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 36,
                          child: Text(formatCompact(bucket.count),
                              textAlign: TextAlign.end, style: muted),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewList extends StatelessWidget {
  const _ReviewList({required this.state});

  final ProductReviewsLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final review in state.page.reviews) _ReviewTile(review: review),
        if (state.hasMore)
          Center(
            child: state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () => ProductReviewsCubit.get(context).loadMore(),
                    child: const Text('Lihat Ulasan Lainnya'),
                  ),
          ),
        if (state.loadMoreError != null)
          Center(
            child: TextButton.icon(
              onPressed: () => ProductReviewsCubit.get(context).loadMore(),
              icon: const Icon(Icons.refresh),
              label: Text(errorMessageFor(context, state.loadMoreError!)),
            ),
          ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final muted = XpText.caption(context).copyWith(color: XpColors.textTertiary);
    final reply = review.reply;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: XpColors.canvas,
        borderRadius: BorderRadius.circular(XpRadius.m),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Server tidak mengirim nama pengulas sama sekali — hanya
              // user_id — jadi avatar dan labelnya selalu generik.
              XpInitialAvatar(name: review.displayName, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.displayName, style: XpText.labelM(context)),
                    Text(formatServerDate(review.createdAt), style: muted),
                  ],
                ),
              ),
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 16,
                  color: XpColors.star,
                ),
            ],
          ),
          if (review.hasComment) ...[
            const SizedBox(height: 8),
            Text(review.comment!,
                style: XpText.bodyS(context).copyWith(color: XpColors.textPrimary)),
          ],
          if (review.hasReply) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: XpColors.surface,
                borderRadius: BorderRadius.circular(XpRadius.m),
                border: Border(left: BorderSide(color: XpColors.primary, width: 2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Tanpa nama toko: `reply` hanya membawa teks dan
                      // tanggal (lihat ReviewReplyModel).
                      XpPill(
                        label: 'Balasan Penjual',
                        tone: XpTone(XpColors.primarySubtle, XpColors.primary),
                      ),
                      const Spacer(),
                      if (reply?.createdAt != null)
                        Text(formatServerDate(reply!.createdAt), style: muted),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(reply!.replyText!.trim(),
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
                ],
              ),
            ),
          ],
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 40)),
              onPressed: () => _report(context, review.id),
              child: Text('Laporkan', style: muted),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _report(BuildContext context, int reviewId) async {
    final cubit = ProductReviewsCubit.get(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Laporkan ulasan?'),
        content: const Text(
          'Ulasan akan ditinjau moderator. Ia tetap tampil sampai ditindak.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Laporkan'),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;

    final ok = await cubit.report(reviewId, reason: 'Dilaporkan dari aplikasi');
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(ok ? 'Laporan terkirim' : 'Laporan gagal dikirim'),
        ),
      );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.hasFilter});

  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        hasFilter
            ? 'Tidak ada ulasan dengan bintang itu.'
            : 'Belum ada ulasan untuk produk ini.',
        style: XpText.bodyM(context).copyWith(color: XpColors.textTertiary),
      ),
    );
  }
}
