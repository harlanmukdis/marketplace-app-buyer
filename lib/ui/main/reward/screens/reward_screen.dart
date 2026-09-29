import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';
import 'package:marketplace_app_member/ui/main/reward/cubit/reward_cubit.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Poin, koin, tingkat loyalitas, dan riwayat cashback.
///
/// ⚠️ **Tidak ada tombol "tukar poin"**, dan itu keputusan sadar: endpointnya
/// tidak memberi imbalan apa pun, sementara nominal negatif justru mencetak
/// poin di server. Lihat `RewardService`. Riwayat poin dan koin juga tidak
/// ditampilkan — tidak ada rute yang membaca `point_transactions` maupun
/// `coin_transactions`.
class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardCubit()..load(),
      child: const _RewardBody(),
    );
  }
}

class _RewardBody extends StatelessWidget {
  const _RewardBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Poin & Reward'),
      body: BlocBuilder<RewardCubit, RewardState>(
        builder: (context, state) {
          return switch (state) {
            RewardLoading() => const Center(child: CircularProgressIndicator()),
            RewardError(:final error) => XpEmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Reward gagal dimuat',
                message: errorMessageFor(context, error),
                actionLabel: 'Coba Lagi',
                onAction: () => RewardCubit.get(context).refresh(),
              ),
            RewardReady(:final overview) => _Ready(overview: overview),
          };
        },
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.overview});

  final RewardOverview overview;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => RewardCubit.get(context).refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _BalanceCard(
                  label: 'Poin',
                  value: overview.points.balance,
                  icon: Icons.stars_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BalanceCard(
                  label: 'Koin',
                  value: overview.coins.balance,
                  icon: Icons.monetization_on_outlined,
                ),
              ),
            ],
          ),
          if (overview.loyalty != null) ...[
            const SizedBox(height: 16),
            _LoyaltyCard(
              membership: overview.loyalty!,
              nextTier: overview.nextTier,
              // Tanpa daftar tier, "tingkat berikutnya" tidak bisa dihitung —
              // dan itu bukan berarti sudah di puncak.
              tiersKnown: overview.tiers.isNotEmpty,
            ),
          ],
          const XpSectionHeader(
            title: 'Cashback',
            subtitle: 'Cashback terbit setelah pesanan selesai.',
            padding: EdgeInsets.fromLTRB(0, 24, 0, 12),
          ),
          if (!overview.hasCashback)
            XpCard(
              child: Row(
                children: [
                  Icon(Icons.savings_outlined,
                      size: 20, color: XpColors.textTertiary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Belum ada cashback.',
                      style: XpText.bodyM(context)
                          .copyWith(color: XpColors.textSecondary),
                    ),
                  ),
                ],
              ),
            )
          else
            XpCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < overview.cashback.length; i++) ...[
                    if (i > 0)
                      Divider(height: 1, color: XpColors.borderSubtle),
                    _CashbackRow(row: overview.cashback[i]),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: XpColors.primarySubtle,
              borderRadius: BorderRadius.circular(XpRadius.m),
            ),
            child: Icon(icon, size: 20, color: XpColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: XpText.labelM(context)
                .copyWith(color: XpColors.textSecondary),
          ),
          const SizedBox(height: 2),
          // Bukan formatRupiah: poin dan koin tidak setara rupiah, dan
          // awalan "Rp" akan membuatnya terbaca sebagai uang.
          Text(formatNumber(value), style: XpText.stat(context)),
        ],
      ),
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  const _LoyaltyCard({
    required this.membership,
    required this.nextTier,
    required this.tiersKnown,
  });

  final LoyaltyMembershipModel membership;
  final LoyaltyTierModel? nextTier;
  final bool tiersKnown;

  @override
  Widget build(BuildContext context) {
    final target = nextTier;
    final onNavySoft = XpColors.textOnBrand.withValues(alpha: 0.75);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XpColors.navy,
        borderRadius: BorderRadius.circular(XpRadius.l),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium,
                  size: 20, color: XpColors.signatureGold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  membership.tierName,
                  style: XpText.titleL(context)
                      .copyWith(color: XpColors.textOnBrand),
                ),
              ),
              Text(
                '${formatNumber(membership.tierPoints)} poin tingkat',
                style: XpText.labelM(context).copyWith(color: onNavySoft),
              ),
            ],
          ),
          if (target != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(XpRadius.full),
              child: LinearProgressIndicator(
                value: membership.progressToward(target),
                minHeight: 8,
                backgroundColor: XpColors.textOnBrand.withValues(alpha: 0.2),
                valueColor:
                    const AlwaysStoppedAnimation(XpColors.textOnBrand),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${formatNumber(membership.pointsUntil(target))} poin lagi '
              'menuju ${target.name}',
              style: XpText.bodyS(context).copyWith(color: onNavySoft),
            ),
          ] else if (tiersKnown) ...[
            const SizedBox(height: 12),
            Text(
              'Sudah di tingkat tertinggi.',
              style: XpText.bodyS(context).copyWith(color: onNavySoft),
            ),
          ],
          if (membership.validUntil != null) ...[
            const SizedBox(height: 8),
            Text(
              'Berlaku sampai ${formatServerDate(membership.validUntil)}',
              style: XpText.caption(context).copyWith(color: onNavySoft),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            // Dua angka poin yang berbeda di satu layar pasti membingungkan
            // kalau tidak dijelaskan: menukar poin tidak menurunkan tingkat.
            'Poin tingkat dihitung terpisah dari saldo poin, dan tidak '
            'berkurang saat poin dipakai.',
            style: XpText.caption(context).copyWith(color: onNavySoft),
          ),
        ],
      ),
    );
  }
}

class _CashbackRow extends StatelessWidget {
  const _CashbackRow({required this.row});

  final CashbackTransactionModel row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.orderId == null
                      ? 'Cashback'
                      : 'Cashback pesanan #${row.orderId}',
                  style: XpText.titleM(context),
                ),
                const SizedBox(height: 2),
                Text(
                  formatServerDateTime(row.createdAt),
                  style: XpText.caption(context)
                      .copyWith(color: XpColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatRupiah(row.amount),
                style: XpText.priceS(context).copyWith(
                  color: row.isCredited
                      ? XpColors.success
                      : XpColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                row.statusLabel,
                style: XpText.caption(context)
                    .copyWith(color: XpColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
