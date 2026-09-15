import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/product_reviews_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Bagian ulasan di halaman detail produk.
///
/// Dibuat sebagai bagian, bukan layar sendiri, karena ulasan hampir selalu
/// dibaca sambil melihat produknya.
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
    final dark = isAppDarkMode();

    return BlocBuilder<ProductReviewsCubit, ProductReviewsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ulasan',
              style: AppStyles.styleSemiBold16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            8.sbh,
            switch (state) {
              ProductReviewsLoading() => const Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ProductReviewsError(:final error) => Text(
                  errorMessageFor(context, error),
                  style: AppStyles.styleRegular12(context)
                      .copyWith(color: kErrorColor),
                ),
              _ => _Content(state: state),
            },
          ],
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
          16.sbh,
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
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 20, color: Colors.amber),
            4.sbw,
            Text(
              histogram.average.toStringAsFixed(1),
              style: AppStyles.styleSemiBold18(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            8.sbw,
            Text(
              '${histogram.total} ulasan',
              style: AppStyles.styleRegular12(context).copyWith(color: muted),
            ),
            const Spacer(),
            if (active != null)
              TextButton(
                onPressed: () =>
                    ProductReviewsCubit.get(context).filterByRating(null),
                child: const Text('Semua'),
              ),
          ],
        ),
        8.sbh,
        for (final bucket in histogram.breakdown)
          InkWell(
            // Filter bintang benar-benar bekerja di endpoint ini — tidak
            // seperti ?status= di /orders yang diabaikan server.
            onTap: bucket.count == 0
                ? null
                : () => ProductReviewsCubit.get(context)
                    .filterByRating(bucket.rating),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${bucket.rating}★',
                      style: AppStyles.styleRegular12(context)
                          .copyWith(color: muted),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: bucket.ratio,
                        minHeight: 6,
                        backgroundColor: dark ? kLightSecondColor : kBorderColor,
                        valueColor: AlwaysStoppedAnimation(
                          bucket.rating == active ? kWarningColor : Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  8.sbw,
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${bucket.count}',
                      textAlign: TextAlign.end,
                      style: AppStyles.styleRegular12(context)
                          .copyWith(color: muted),
                    ),
                  ),
                ],
              ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final review in state.page.reviews) _ReviewTile(review: review),
        if (state.hasMore) ...[
          8.sbh,
          Center(
            child: state.isLoadingMore
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: () =>
                        ProductReviewsCubit.get(context).loadMore(),
                    child: const Text('Muat ulasan lainnya'),
                  ),
          ),
        ],
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
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= review.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 16,
                  color: Colors.amber,
                ),
              8.sbw,
              Expanded(
                child: Text(
                  // Server tidak mengirim nama pengulas sama sekali — hanya
                  // user_id — jadi labelnya selalu generik.
                  review.displayName,
                  style: AppStyles.styleMedium12(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
              ),
              Text(
                formatServerDate(review.createdAt),
                style: AppStyles.styleRegular11(context).copyWith(color: muted),
              ),
            ],
          ),
          if (review.hasComment) ...[
            4.sbh,
            Text(
              review.comment!,
              style: AppStyles.styleRegular14(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
          ],
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => _report(context, review.id),
              child: Text(
                'Laporkan',
                style:
                    AppStyles.styleRegular11(context).copyWith(color: muted),
              ),
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
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Text(
        hasFilter
            ? 'Tidak ada ulasan dengan bintang itu.'
            : 'Produk ini belum punya ulasan.',
        style: AppStyles.styleRegular14(context).copyWith(
          color: dark ? kDarkThirdColor : kLightThirdColor,
        ),
      ),
    );
  }
}
