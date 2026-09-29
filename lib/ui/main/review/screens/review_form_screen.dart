import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/review_form_cubit.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Beri Ulasan (desain §3.24 `beri_ulasan_uniqlo_hoodie`) — juga dipakai
/// untuk **Ubah Ulasan** dalam 30 hari kalau [ReviewFormScreen.existing]
/// diisi (`PATCH /reviews/{id}`, diusulkan — docs/22 #8, di-mock di debug).
///
/// Dihilangkan dari desain karena tidak ada di backend:
/// - **foto & video bukti** — lihat [ReviewFormCubit];
/// - **"+500 Koin"** — tidak ada reward untuk ulasan di reward engine;
/// - **chip "Karakteristik Produk"** — `POST /order-items/{id}/review` hanya
///   menerima `rating`, `comment`, `is_anonymous`, dan `media`;
/// - baris "divalidasi dengan invoice resmi".
class ReviewFormScreen extends StatelessWidget {
  const ReviewFormScreen({
    super.key,
    required this.orderId,
    required this.orderItemId,
    this.existing,
  });

  final int orderId;
  final int orderItemId;

  /// Ulasan yang diubah. Dibuka dari "Ulasan Saya" lewat `Navigator.push`
  /// (rute `orderReviewPath` hanya membawa id), dan `pop` mengembalikan
  /// [MyReviewModel] hasil perubahan.
  final MyReviewModel? existing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReviewFormCubit(orderId: orderId, orderItemId: orderItemId, existing: existing)..load(),
      child: const _ReviewFormBody(),
    );
  }
}

/// Label sentimen per bintang, dari desain.
const _sentiments = [
  'Sangat Mengecewakan',
  'Kurang Puas',
  'Cukup Standar',
  'Puas & Berfungsi Baik',
  'Sangat Puas!',
];

/// "Bantu tulis": hanya menyisipkan teks ke kolom ulasan, tidak dikirim
/// sebagai data terpisah. Dipilih yang berlaku umum untuk produk apa pun —
/// yang menilai kurir atau toko sengaja tidak disertakan.
const _suggestions = ['Sesuai deskripsi', 'Kualitasnya bagus', 'Pengemasan rapi'];

class _ReviewFormBody extends StatefulWidget {
  const _ReviewFormBody();

  @override
  State<_ReviewFormBody> createState() => _ReviewFormBodyState();
}

class _ReviewFormBodyState extends State<_ReviewFormBody> {
  final _comment = TextEditingController();

  bool _seeded = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _append(String text) {
    final current = _comment.text.trim();
    final next = current.isEmpty ? text : '$current. $text';
    if (next.length > ReviewFormCubit.maxCommentLength) return;
    _comment.text = next;
    _comment.selection = TextSelection.collapsed(offset: next.length);
    ReviewFormCubit.get(context).setComment(next);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewFormCubit, ReviewFormState>(
      listener: (context, state) {
        if (state is! ReviewFormReady) return;
        if (!_seeded) {
          // Mode ubah: kolom teks diisi ulasan lama sekali saja.
          _seeded = true;
          _comment.text = state.comment;
        }
        if (state.storeId > 0) context.read<StoreDirectoryCubit>().ensure([state.storeId]);
        final error = state.submitError;
        if (error != null) {
          showOrderSnack(context, orderErrorMessage(context, error));
          ReviewFormCubit.get(context).clearSubmitError();
        }
        if (state.submitted) {
          if (state.editing != null) {
            showOrderSnack(context, 'Ulasan diperbarui.');
            Navigator.of(context).pop(state.updated ?? true);
          } else {
            showOrderSnack(context, 'Ulasan terkirim. Terima kasih!');
            context.pop(true);
          }
        }
      },
      builder: (context, state) {
        final ready = state is ReviewFormReady ? state : null;
        return Scaffold(
          backgroundColor: XpColors.canvas,
          appBar: XpStackAppBar(
            title: ready?.editing != null ? 'Ubah Ulasan' : 'Beri Ulasan',
            actions: const [SupportActionButton()],
          ),
          body: switch (state) {
            ReviewFormLoading() => const Center(child: CircularProgressIndicator()),
            ReviewFormError(:final error) => XpEmptyState(
                icon: Icons.rate_review_outlined,
                title: 'Ulasan belum bisa dikirim',
                message: orderErrorMessage(context, error),
                actionLabel: 'Kembali',
                onAction: () => Navigator.of(context).maybePop(),
              ),
            ReviewFormReady() => _form(context, state),
          },
          bottomNavigationBar: ready == null
              ? null
              : XpBottomBar(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    onPressed: ready.isSubmitting || ready.submitted
                        ? null
                        : () => ReviewFormCubit.get(context).submit(),
                    icon: ready.isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.rate_review_outlined, size: 20),
                    label: Text(ready.isSubmitting
                        ? 'Mengirimkan Ulasan...'
                        : ready.editing != null
                            ? 'Simpan Perubahan'
                            : 'Kirim Ulasan'),
                  ),
                ),
        );
      },
    );
  }

  Widget _form(BuildContext context, ReviewFormReady state) {
    final cubit = ReviewFormCubit.get(context);
    final editing = state.editing;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        XpCard(
          color: XpColors.primarySubtle,
          borderColor: Colors.transparent,
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info, size: 20, color: XpColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kebijakan Ulasan Transparan', style: XpText.titleM(context)),
                    const SizedBox(height: 2),
                    Text(
                      editing?.editableUntil != null
                          ? 'Ulasan ini masih bisa diperbarui sampai '
                              '${formatServerDateTime(editing!.editableUntil)}.'
                          : 'Ulasan khusus untuk produk asli. Kamu dapat memperbarui '
                              'penilaian ini dalam 30 hari setelah dikirimkan.',
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Perubahan ulasan memakai endpoint yang masih diusulkan.
              if (editing != null) const SimulatedBadge(meta: null, force: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.storeId > 0) OrderStoreName(storeId: state.storeId),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const XpProductImage(url: null, size: 64),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: XpText.titleM(context)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final option in state.optionLabel.split(' · '))
                              if (option.isNotEmpty)
                                XpPill(
                                  label: option,
                                  tone: XpTone(XpColors.sunken, XpColors.textSecondary),
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            children: [
              Text('Bagaimana kepuasan Anda?', style: XpText.titleL(context)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var star = 1; star <= 5; star++)
                    IconButton(
                      tooltip: '$star bintang',
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      onPressed: () => cubit.setRating(star),
                      icon: Icon(
                        star <= state.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 36,
                        color: star <= state.rating ? XpColors.star : XpColors.textPlaceholder,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: XpColors.warningSubtle,
                  borderRadius: BorderRadius.circular(XpRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.rating >= 4
                          ? Icons.sentiment_very_satisfied
                          : state.rating == 3
                              ? Icons.sentiment_neutral
                              : Icons.sentiment_dissatisfied,
                      size: 18,
                      color: const Color(0xff8C5002),
                    ),
                    const SizedBox(width: 6),
                    Text(_sentiments[state.rating - 1],
                        style: XpText.labelM(context).copyWith(color: const Color(0xff8C5002))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tulis Ulasan Lengkap', style: XpText.titleL(context)),
              const SizedBox(height: 8),
              TextField(
                controller: _comment,
                enabled: !state.isSubmitting,
                maxLines: 5,
                maxLength: ReviewFormCubit.maxCommentLength,
                onChanged: cubit.setComment,
                decoration: const InputDecoration(
                  hintText: 'Ceritakan kualitas, kesesuaian, dan pengalamanmu memakai produk ini...',
                ),
              ),
              Text('Bantu tulis:',
                  style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in _suggestions)
                    ActionChip(label: Text('+ $s'), onPressed: () => _append(s)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: XpColors.sunken, shape: BoxShape.circle),
                child: Icon(Icons.visibility_off_outlined, color: XpColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ulas Secara Anonim', style: XpText.titleM(context)),
                    Text('Namamu tidak dikaitkan dengan ulasan ini.',
                        style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
                  ],
                ),
              ),
              Switch(
                value: state.isAnonymous,
                onChanged: state.isSubmitting ? null : cubit.setAnonymous,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Satu barang hanya bisa diulas sekali. Ulasan bisa diubah dari "Ulasan Saya" '
          'dalam 30 hari setelah dikirim.',
          textAlign: TextAlign.center,
          style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
        ),
      ],
    );
  }
}
