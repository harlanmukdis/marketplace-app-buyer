import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/withdraw_sheet.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Dompet: saldo, riwayat mutasi, topup, dan penarikan.
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletCubit()..load(),
      child: const _WalletBody(),
    );
  }
}

class _WalletBody extends StatelessWidget {
  const _WalletBody();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, 'Saldo Saya'),
      body: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (previous, current) =>
            current is WalletReady &&
            (current.actionError != null || current.pendingTopup != null),
        listener: (context, state) async {
          final ready = state as WalletReady;

          final error = ready.actionError;
          if (error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(errorMessageFor(context, error))),
              );
            WalletCubit.get(context).clearActionError();
            return;
          }

          final topup = ready.pendingTopup;
          if (topup != null) {
            final cubit = WalletCubit.get(context);
            cubit.clearPendingTopup();
            // Topup memakai ulang layar pembayaran yang sama dengan checkout —
            // saldo baru bertambah setelah transaksinya dibayar.
            await context.push(
              AppRoutes.paymentPath(topup.paymentTransactionId),
            );
            if (context.mounted) cubit.load();
          }
        },
        builder: (context, state) {
          return switch (state) {
            WalletLoading() => const Center(child: CircularProgressIndicator()),
            WalletError(:final error) => _Message(
                title: errorMessageFor(context, error),
                onRetry: () => WalletCubit.get(context).load(),
              ),
            WalletReady() => _Ready(state: state),
          };
        },
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final WalletReady state;

  @override
  Widget build(BuildContext context) {
    final wallet = state.wallet;

    return RefreshIndicator(
      onRefresh: () => WalletCubit.get(context).load(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          _BalanceCard(wallet: wallet, enabled: state.canAct),
          24.sbh,
          _HistoryHeader(count: wallet.transactions.length),
          8.sbh,
          if (wallet.transactions.isEmpty)
            _EmptyHistory()
          else
            for (final tx in wallet.transactions) _TransactionRow(tx: tx),
          24.sbh,
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.wallet, required this.enabled});

  final WalletModel wallet;
  final bool enabled;

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
          Text(
            'Saldo tersedia',
            style: AppStyles.styleRegular12(context).copyWith(
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
          4.sbh,
          Text(
            formatRupiah(wallet.availableBalance),
            style: AppStyles.styleSemiBold24(context).copyWith(color: primary),
          ),
          if (wallet.heldBalance > 0) ...[
            4.sbh,
            Text(
              // Saldo tertahan biasanya penarikan yang sedang diproses. Tanpa
              // baris ini, user melihat total berkurang tanpa penjelasan.
              '${formatRupiah(wallet.heldBalance)} sedang ditahan',
              style: AppStyles.styleRegular12(context)
                  .copyWith(color: kWarningColor),
            ),
          ],
          16.sbh,
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed:
                      enabled ? () => _askTopupAmount(context) : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Isi saldo'),
                ),
              ),
              12.sbw,
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: enabled
                      ? () => WithdrawSheet.show(context, wallet: wallet)
                      : null,
                  icon: const Icon(Icons.arrow_outward),
                  label: const Text('Tarik'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _askTopupAmount(BuildContext context) async {
    final cubit = WalletCubit.get(context);
    final controller = TextEditingController();

    final amount = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Isi saldo'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nominal',
            prefixText: 'Rp ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext)
                .pop(double.tryParse(controller.text.trim())),
            child: const Text('Lanjut bayar'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (amount == null) return;
    await cubit.topup(amount: amount);
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat',
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: dark ? kDarkSecondColor : kLightSecondColor,
          ),
        ),
        if (count >= 50)
          Text(
            // Server memotong di 50 dan tidak menyediakan paginasi, jadi
            // dikatakan apa adanya alih-alih menawarkan "muat lebih banyak"
            // yang tidak ada endpointnya.
            'Menampilkan 50 mutasi terakhir.',
            style: AppStyles.styleRegular11(context).copyWith(
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});

  final WalletTransactionModel tx;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;
    final color = tx.isCredit ? kSuccessColor : kErrorColor;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            tx.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            size: 18,
            color: color,
          ),
          10.sbw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.label,
                  style: AppStyles.styleMedium14(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
                Text(
                  formatServerDateTime(tx.createdAt),
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
                // Arah dari `type`, bukan tanda `amount` — kolomnya selalu
                // positif di database.
                '${tx.isCredit ? '+' : '−'} ${formatRupiah(tx.amount)}',
                style: AppStyles.styleMedium14(context).copyWith(color: color),
              ),
              Text(
                'Saldo ${formatRupiah(tx.balanceAfter)}',
                style: AppStyles.styleRegular11(context).copyWith(color: muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Text(
        'Belum ada mutasi saldo.',
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
