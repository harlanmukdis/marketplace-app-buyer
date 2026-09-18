import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/reward/cubit/reward_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Poin, koin, tingkat loyalitas, dan riwayat cashback.
///
/// ⚠️ **Tidak ada tombol "tukar poin"**, dan itu keputusan sadar: endpointnya
/// tidak memberi imbalan apa pun, sementara nominal negatif justru mencetak
/// poin di server. Lihat `RewardService`.
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
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, 'Poin & Reward'),
      body: BlocBuilder<RewardCubit, RewardState>(
        builder: (context, state) {
          return switch (state) {
            RewardLoading() => const Center(child: CircularProgressIndicator()),
            RewardError(:final error) => _Message(
                title: errorMessageFor(context, error),
                onRetry: () => RewardCubit.get(context).refresh(),
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
        padding: const EdgeInsetsDirectional.all(16),
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
              12.sbw,
              Expanded(
                child: _BalanceCard(
                  label: 'Koin',
                  value: overview.coins.balance,
                  icon: Icons.monetization_on_outlined,
                ),
              ),
            ],
          ),
          20.sbh,
          if (overview.loyalty != null)
            _LoyaltyCard(
              membership: overview.loyalty!,
              nextTier: overview.nextTier,
            ),
          24.sbh,
          const _SectionTitle(title: 'Cashback'),
          8.sbh,
          if (!overview.hasCashback)
            const _EmptyNote(
              'Belum ada cashback. Cashback terbit setelah pesanan selesai.',
            )
          else
            for (final row in overview.cashback) _CashbackRow(row: row),
          24.sbh,
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
    final dark = isAppDarkMode();
    final primary = dark ? kDarkPrimaryColor : kLightPrimaryColor;

    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: primary),
          8.sbh,
          Text(
            label,
            style: AppStyles.styleRegular12(context).copyWith(
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
          4.sbh,
          Text(
            formatNumber(value),
            style: AppStyles.styleSemiBold24(context).copyWith(color: primary),
          ),
        ],
      ),
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  const _LoyaltyCard({required this.membership, required this.nextTier});

  final LoyaltyMembershipModel membership;
  final LoyaltyTierModel? nextTier;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final primary = dark ? kDarkPrimaryColor : kLightPrimaryColor;
    final muted = dark ? kDarkThirdColor : kLightThirdColor;
    final target = nextTier;

    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: dark ? kDarkThirdColor : kBorderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_outlined, size: 20, color: primary),
              8.sbw,
              Expanded(
                child: Text(
                  membership.tierName,
                  style: AppStyles.styleSemiBold16(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
              ),
              Text(
                '${formatNumber(membership.tierPoints)} poin tingkat',
                style: AppStyles.styleRegular11(context).copyWith(color: muted),
              ),
            ],
          ),
          if (target != null) ...[
            12.sbh,
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: membership.progressToward(target),
                minHeight: 8,
                backgroundColor: primary.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(primary),
              ),
            ),
            8.sbh,
            Text(
              '${formatNumber(membership.pointsUntil(target))} poin lagi '
              'menuju ${target.name}',
              style: AppStyles.styleRegular12(context).copyWith(color: muted),
            ),
          ] else ...[
            12.sbh,
            Text(
              'Sudah di tingkat tertinggi.',
              style: AppStyles.styleRegular12(context).copyWith(color: muted),
            ),
          ],
          if (membership.validUntil != null) ...[
            8.sbh,
            Text(
              'Berlaku sampai ${formatServerDate(membership.validUntil)}',
              style: AppStyles.styleRegular11(context).copyWith(color: muted),
            ),
          ],
          8.sbh,
          Text(
            // Dua angka poin yang berbeda di satu layar pasti membingungkan
            // kalau tidak dijelaskan: menukar poin tidak menurunkan tingkat.
            'Poin tingkat dihitung terpisah dari saldo poin, dan tidak '
            'berkurang saat poin dipakai.',
            style: AppStyles.styleRegular11(context).copyWith(color: muted),
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
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
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
                  style: AppStyles.styleMedium14(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
                Text(
                  formatServerDateTime(row.createdAt),
                  style:
                      AppStyles.styleRegular11(context).copyWith(color: muted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatRupiah(row.amount),
                style: AppStyles.styleMedium14(context).copyWith(
                  color: row.isCredited ? kSuccessColor : muted,
                ),
              ),
              Text(
                row.statusLabel,
                style: AppStyles.styleRegular11(context).copyWith(color: muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Text(
      title,
      style: AppStyles.styleSemiBold16(context).copyWith(
        color: dark ? kDarkSecondColor : kLightSecondColor,
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Text(
        text,
        style: AppStyles.styleRegular14(context).copyWith(
          color: dark ? kDarkThirdColor : kLightThirdColor,
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.onRetry});

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
            16.sbh,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            16.sbh,
            FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}
