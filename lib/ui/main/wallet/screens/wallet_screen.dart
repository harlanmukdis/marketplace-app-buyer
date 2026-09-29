import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/withdraw_sheet.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Xpedia Wallet: saldo, riwayat mutasi, top up, dan penarikan.
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

  void _toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Xpedia Wallet'),
      body: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (previous, current) =>
            current is WalletReady &&
            (current.actionError != null ||
                current.pendingTopup != null ||
                current.withdrawalSubmitted),
        listener: (context, state) async {
          final ready = state as WalletReady;
          final cubit = WalletCubit.get(context);

          if (ready.withdrawalSubmitted) {
            cubit.acknowledgeWithdrawal();
            _toast(context, 'Penarikan diajukan. Dana dikirim setelah diproses admin.');
            return;
          }

          final error = ready.actionError;
          if (error != null) {
            // Selagi lembar penarikan terbuka, lembar itu yang menampilkan
            // pesannya — snackbar di sini akan tertutup olehnya.
            if (ModalRoute.of(context)?.isCurrent ?? true) {
              _toast(context, accountErrorText(context, error));
            }
            cubit.clearActionError();
            return;
          }

          final topup = ready.pendingTopup;
          if (topup != null) {
            cubit.clearPendingTopup();
            // Topup memakai ulang layar pembayaran yang sama dengan checkout —
            // saldo baru bertambah setelah transaksinya dibayar.
            await context.push(AppRoutes.paymentPath(topup.paymentTransactionId));
            if (context.mounted) cubit.load();
          }
        },
        builder: (context, state) => switch (state) {
          WalletLoading() => const Center(child: CircularProgressIndicator()),
          WalletError(:final error) => XpEmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Saldo belum bisa dimuat',
              message: accountErrorText(context, error),
              actionLabel: 'Coba lagi',
              onAction: () => WalletCubit.get(context).load(),
            ),
          WalletReady() => _Ready(state: state),
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
    final cubit = WalletCubit.get(context);

    return RefreshIndicator(
      onRefresh: cubit.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _BalanceCard(wallet: wallet, enabled: state.canAct),
          const SizedBox(height: 16),
          XpCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _LinkRow(
                  icon: Icons.account_balance_outlined,
                  title: 'Rekening Bank',
                  subtitle: state.bankAccountsError != null
                      ? 'Belum bisa dimuat'
                      : '${state.bankAccounts.length} dari '
                          '${BankAccountModel.maxAccounts} rekening tersimpan',
                  onTap: () async {
                    await context.push(AppRoutes.bankAccounts);
                    await cubit.reloadBankAccounts();
                  },
                ),
                Divider(height: 1, color: XpColors.borderSubtle),
                _LinkRow(
                  icon: Icons.pin_outlined,
                  title: 'PIN Xpedia Wallet',
                  subtitle: 'PIN untuk pembayaran dan penarikan',
                  onTap: () => context.push(AppRoutes.withdrawalPin),
                ),
              ],
            ),
          ),
          XpSectionHeader(
            title: 'Riwayat Transaksi',
            // Server memotong di 50 dan tidak menyediakan paginasi, jadi
            // dikatakan apa adanya alih-alih menawarkan "muat lebih banyak"
            // yang tidak ada endpointnya.
            subtitle: wallet.transactions.length >= 50
                ? 'Menampilkan 50 mutasi terakhir'
                : null,
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
          ),
          if (wallet.transactions.isEmpty)
            XpCard(
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined, size: 32, color: XpColors.textTertiary),
                  const SizedBox(height: 8),
                  Text('Belum ada mutasi saldo', style: XpText.titleM(context)),
                  const SizedBox(height: 2),
                  Text(
                    'Top up, pembayaran, dan penarikan akan tercatat di sini.',
                    textAlign: TextAlign.center,
                    style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                  ),
                ],
              ),
            )
          else
            XpCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < wallet.transactions.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: XpColors.borderSubtle),
                    _TransactionRow(tx: wallet.transactions[i]),
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

/// Kartu saldo navy (inventaris desain §2.4 "Wallet card, navy").
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.wallet, required this.enabled});

  final WalletModel wallet;
  final bool enabled;

  static const _onNavyMuted = Color(0xffE1E8FD);

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.account_balance_wallet_outlined,
                  size: 18, color: _onNavyMuted),
              const SizedBox(width: 6),
              Text('SALDO TERSEDIA',
                  style: XpText.labelM(context)
                      .copyWith(color: _onNavyMuted, letterSpacing: 0.8)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatRupiah(wallet.availableBalance),
            style: XpText.headingXl(context).copyWith(color: Colors.white),
          ),
          if (wallet.heldBalance > 0) ...[
            const SizedBox(height: 4),
            Text(
              // Saldo tertahan biasanya penarikan yang sedang diproses. Tanpa
              // baris ini, user melihat total berkurang tanpa penjelasan.
              '${formatRupiah(wallet.heldBalance)} sedang ditahan',
              style: XpText.bodyS(context).copyWith(color: XpColors.warning),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: XpColors.navy,
                    ),
                    onPressed: enabled ? () => _askTopupAmount(context) : null,
                    icon: Icon(Icons.add_circle, size: 18, color: XpColors.primary),
                    label: const Text('Top Up'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    onPressed: enabled ? () => WithdrawSheet.show(context) : null,
                    icon: const Icon(Icons.arrow_outward, size: 18),
                    label: const Text('Tarik Saldo'),
                  ),
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
        title: const Text('Top Up Saldo'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nominal',
            prefixText: 'Rp ',
            // Minimum dari blueprint; server belum menegakkannya, jadi
            // `WalletCubit` yang menolak di bawahnya.
            helperText: 'Minimum ${formatRupiah(WalletCubit.minimumTopup)}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext)
                .pop(double.tryParse(controller.text.trim()) ?? 0),
            child: const Text('Lanjut Bayar'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (amount == null) return;
    await cubit.topup(amount: amount);
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: XpColors.sunken,
                borderRadius: BorderRadius.circular(XpRadius.m),
              ),
              child: Icon(icon, size: 20, color: XpColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: XpText.titleM(context)),
                  Text(subtitle,
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: XpColors.textPlaceholder),
          ],
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});

  final WalletTransactionModel tx;

  @override
  Widget build(BuildContext context) {
    final color = tx.isCredit ? XpColors.success : XpColors.danger;
    final tint = tx.isCredit ? XpColors.successSubtle : XpColors.dangerSubtle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            child: Icon(
              tx.isCredit ? Icons.south_west : Icons.north_east,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.label, style: XpText.titleM(context)),
                Text(
                  formatServerDateTime(tx.createdAt),
                  style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                // Arah dari `type`, bukan tanda `amount` — kolomnya selalu
                // positif di database.
                '${tx.isCredit ? '+' : '−'}${formatRupiah(tx.amount)}',
                style: XpText.priceS(context).copyWith(color: color),
              ),
              Text(
                'Saldo ${formatRupiah(tx.balanceAfter)}',
                style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
