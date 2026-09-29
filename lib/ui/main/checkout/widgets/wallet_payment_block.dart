import 'package:flutter/material.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/ui/main/checkout/widgets/checkout_error_text.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Blok "Xpedia Wallet" di dalam kartu Ringkasan Pesanan (desain
/// `checkout_xpedia_wallet_2` §3.9 dan `checkout_saldo_wallet_kurang` §3.10).
///
/// Ditaruh di **kartu yang sama** dengan total tagihan — aturan
/// non-negotiable design_buyer.md §5: saldo dan total harus terbaca
/// berdampingan, supaya pembeli tahu cukup-tidaknya tanpa menghitung.
///
/// Saldo kurang: tombol Bayar mati (di bilah bawah), selisihnya ditulis,
/// dan satu-satunya aksi utama adalah top up (minimal Rp 10.000).
class WalletPaymentBlock extends StatelessWidget {
  const WalletPaymentBlock({
    super.key,
    required this.wallet,
    required this.meta,
    required this.loading,
    required this.error,
    required this.toppingUp,
    required this.onTopup,
    required this.onRetry,
    required this.onCreatePin,
  });

  final WalletSummaryModel? wallet;
  final Map<String, dynamic>? meta;
  final bool loading;
  final DataError? error;
  final bool toppingUp;
  final VoidCallback onTopup;
  final VoidCallback onRetry;
  final VoidCallback onCreatePin;

  @override
  Widget build(BuildContext context) {
    final data = wallet;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XpColors.primarySubtle.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(XpRadius.l),
        border: Border.all(color: XpColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: XpColors.primary,
                  borderRadius: BorderRadius.circular(XpRadius.m),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    size: 22, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Metode Pembayaran Resmi',
                        style: XpText.caption(context)
                            .copyWith(color: XpColors.textSecondary)),
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('Xpedia Wallet', style: XpText.titleM(context)),
                        SimulatedBadge(meta: meta),
                      ],
                    ),
                  ],
                ),
              ),
              if (data != null && !data.isInsufficient)
                OutlinedButton.icon(
                  onPressed: toppingUp ? null : onTopup,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Top Up'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: XpColors.primary.withValues(alpha: 0.15)),
          const SizedBox(height: 12),
          if (data == null)
            _pending(context)
          else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text('Saldo Tersedia:',
                      style: XpText.bodyS(context)
                          .copyWith(color: XpColors.textSecondary)),
                ),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 4),
                    child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                Text(formatRupiah(data.walletBalance),
                    style: XpText.headingM(context)),
              ],
            ),
            const SizedBox(height: 10),
            if (data.isInsufficient)
              _Shortfall(
                wallet: data,
                busy: toppingUp,
                onTopup: onTopup,
              )
            else
              XpPill(
                label: 'Saldo kamu mencukupi untuk pembayaran ini',
                icon: Icons.check_circle,
                tone: XpTone(XpColors.successSubtle, XpColors.success),
              ),
            if (!data.pinSet) ...[
              const SizedBox(height: 10),
              XpBanner(
                icon: Icons.pin_outlined,
                tone: XpBannerTone.warning,
                title: 'Buat PIN Wallet dulu',
                message: 'Setiap pembayaran memerlukan PIN 6 digit.',
                trailing: TextButton(
                  onPressed: onCreatePin,
                  child: const Text('Buat PIN'),
                ),
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 8),
              _ErrorLine(error: error!, onRetry: onRetry),
            ],
          ],
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_user_outlined,
                  size: 14, color: XpColors.textTertiary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Pembayaran hanya lewat Xpedia Wallet. Dana dikembalikan '
                  'ke Wallet kalau pesanan dibatalkan.',
                  style: XpText.caption(context)
                      .copyWith(color: XpColors.textTertiary),
                ),
              ),
            ],
          ),
          if (isMockMeta(meta)) ...[
            const SizedBox(height: 6),
            Text(
              'Simulasi: saldo di atas bukan saldo sungguhan, dan pesanan di '
              'server tetap berstatus Menunggu Pembayaran karena pembayaran '
              'Wallet belum tersedia di backend.',
              style: XpText.caption(context)
                  .copyWith(color: const Color(0xff8C5002)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _pending(BuildContext context) {
    if (error != null) return _ErrorLine(error: error!, onRetry: onRetry);
    return Row(
      children: [
        const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2)),
        const SizedBox(width: 10),
        Flexible(
          child: Text('Memeriksa saldo Wallet…',
              style: XpText.bodyS(context)
                  .copyWith(color: XpColors.textSecondary)),
        ),
      ],
    );
  }
}

class _Shortfall extends StatelessWidget {
  const _Shortfall({
    required this.wallet,
    required this.busy,
    required this.onTopup,
  });

  final WalletSummaryModel wallet;
  final bool busy;
  final VoidCallback onTopup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: XpColors.dangerSubtle,
            borderRadius: BorderRadius.circular(XpRadius.m),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error, size: 22, color: XpColors.danger),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo Kurang ${formatRupiah(wallet.shortfall)}',
                      style: XpText.titleM(context)
                          .copyWith(color: XpColors.danger),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Saldo Xpedia Wallet kamu belum mencukupi untuk '
                      'menyelesaikan pesanan ini.',
                      style: XpText.bodyS(context)
                          .copyWith(color: XpColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 14, color: XpColors.textTertiary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Minimal Top Up ${formatRupiah(wallet.minTopup)}',
                            style: XpText.caption(context)
                                .copyWith(color: XpColors.textTertiary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: busy ? null : onTopup,
            icon: busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.add_circle, size: 20),
            label: Text(
                busy ? 'Membuka Halaman Top Up…' : 'Top Up Saldo Sekarang'),
          ),
        ),
      ],
    );
  }
}

class _ErrorLine extends StatelessWidget {
  const _ErrorLine({required this.error, required this.onRetry});

  final DataError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.cloud_off_rounded, size: 18, color: XpColors.danger),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Saldo Wallet belum bisa dimuat. ${checkoutErrorText(context, error)}',
            style: XpText.bodyS(context).copyWith(color: XpColors.danger),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
      ],
    );
  }
}
