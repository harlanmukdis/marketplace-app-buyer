import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/payment/cubit/payment_cubit.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Layar pembayaran: instruksi bayar dan status transaksi.
///
/// Satu transaksi menutup **semua** order dari satu sesi checkout, jadi layar
/// ini tidak terikat ke satu pesanan.
///
/// Belum ada desain Stitch khusus untuk layar ini (desainnya menganggap
/// pembayaran lewat Xpedia Wallet + PIN, yang belum ada di backend), jadi
/// ia disusun dari komponen Xpedia: banner hitung mundur, kartu total, dan
/// blok salin.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.transactionId});

  final int transactionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(transactionId)..load(),
      child: const _PaymentBody(),
    );
  }
}

class _PaymentBody extends StatelessWidget {
  const _PaymentBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(
        title: 'Pembayaran',
        actions: [SupportActionButton()],
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listenWhen: (previous, current) =>
            current is PaymentReady && current.actionError != null,
        listener: (context, state) {
          final error = (state as PaymentReady).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessageFor(context, error))),
            );
          PaymentCubit.get(context).clearActionError();
        },
        builder: (context, state) {
          return switch (state) {
            PaymentLoading() =>
              const Center(child: CircularProgressIndicator()),
            PaymentError(:final error) => XpEmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Pembayaran belum bisa dimuat',
                message: errorMessageFor(context, error),
                actionLabel: 'Coba lagi',
                onAction: () => PaymentCubit.get(context).load(),
              ),
            PaymentReady() => _Ready(state: state),
          };
        },
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final PaymentReady state;

  @override
  Widget build(BuildContext context) {
    final payment = state.snapshot.payment;

    if (payment.isPaid) {
      return XpEmptyState(
        icon: Icons.check_circle,
        iconColor: XpColors.success,
        title: 'Pembayaran diterima',
        message: 'Pesanan kamu akan segera diproses penjual.',
        actionLabel: 'Lihat pesanan saya',
        onAction: () => context.go(AppRoutes.orders),
      );
    }

    if (payment.isExpired) {
      return XpEmptyState(
        icon: Icons.timer_off_outlined,
        iconColor: XpColors.danger,
        title: 'Batas waktu pembayaran sudah lewat',
        message: 'Pesanan dibatalkan otomatis. Silakan pesan ulang.',
        actionLabel: 'Kembali ke Beranda',
        onAction: () => context.go(AppRoutes.homeLayout),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _PaymentCountdown(expiredAt: payment.expiredAt),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Tagihan',
                  style: XpText.bodyS(context)
                      .copyWith(color: XpColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                formatRupiah(payment.amount),
                style: XpText.stat(context).copyWith(color: XpColors.primary),
              ),
              if (payment.expiredAt != null) ...[
                const SizedBox(height: 8),
                Divider(height: 1, color: XpColors.borderSubtle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Bayar sebelum',
                        style: XpText.bodyS(context)
                            .copyWith(color: XpColors.textSecondary)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        formatServerDateTime(payment.expiredAt),
                        textAlign: TextAlign.end,
                        style: XpText.labelL(context),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Instruction(instruction: state.snapshot.instruction),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            // Tidak ada polling: status baru datang lewat webhook penyedia,
            // yang bisa telat. Menembak terus hanya membebani server.
            onPressed: state.isChecking
                ? null
                : () => PaymentCubit.get(context).checkStatus(),
            icon: const Icon(Icons.refresh),
            label: Text(
              state.isChecking ? 'Memeriksa…' : 'Saya sudah bayar, cek status',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => context.go(AppRoutes.orders),
            child: const Text('Lihat pesanan saya'),
          ),
        ),
      ],
    );
  }
}

/// Hitung mundur tenggat bayar.
class _PaymentCountdown extends StatefulWidget {
  const _PaymentCountdown({required this.expiredAt});

  final DateTime? expiredAt;

  @override
  State<_PaymentCountdown> createState() => _PaymentCountdownState();
}

class _PaymentCountdownState extends State<_PaymentCountdown> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = remainingUntil(widget.expiredAt);
    if (left == null) return const SizedBox.shrink();
    final expired = left.isNegative;

    return XpBanner(
      icon: expired ? Icons.timer_off_outlined : Icons.timer_outlined,
      tone: expired ? XpBannerTone.danger : XpBannerTone.warning,
      title: expired
          ? 'Batas waktu pembayaran sudah lewat'
          : 'Bayar dalam ${formatCountdown(left)}',
      message: expired
          ? null
          : 'Pesanan dibatalkan otomatis kalau belum dibayar sampai batas '
              'waktu.',
    );
  }
}

class _Instruction extends StatelessWidget {
  const _Instruction({required this.instruction});

  final PaymentInstructionModel? instruction;

  @override
  Widget build(BuildContext context) {
    final data = instruction;

    if (data == null) {
      return const XpBanner(
        icon: Icons.warning_amber_rounded,
        tone: XpBannerTone.warning,
        title: 'Instruksi pembayaran belum bisa dimuat',
        message: 'Coba muat ulang halaman ini.',
      );
    }

    return switch (data.kind) {
      PaymentInstructionKind.qris => _CopyBlock(
          icon: Icons.qr_code_2,
          title: 'Kode QRIS',
          // QR-nya tidak dirender jadi gambar: aplikasi belum punya
          // pustaka QR, dan menampilkan string mentah lebih jujur daripada
          // kotak kosong. Penyedia menerima string ini apa adanya.
          value: data.qrString ?? '',
          hint: 'Salin lalu tempel di aplikasi pembayaran kamu.',
        ),
      PaymentInstructionKind.virtualAccount => _CopyBlock(
          icon: Icons.account_balance_outlined,
          title: (data.bank ?? '').isNotEmpty
              ? 'Virtual Account ${data.bank}'
              : 'Nomor Virtual Account',
          value: data.vaNumber ?? '',
          hint: 'Transfer tepat sejumlah tagihan ke nomor ini.',
          large: true,
        ),
      PaymentInstructionKind.unknown => const XpBanner(
          icon: Icons.info_outline,
          title: 'Ikuti instruksi pembayaran dari penyedia.',
        ),
    };
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock({
    required this.icon,
    required this.title,
    required this.value,
    required this.hint,
    this.large = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final String hint;

  /// Nomor VA pendek dan dibaca/diketik ulang — ditampilkan besar. String
  /// QRIS panjang, jadi tetap ukuran badan.
  final bool large;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: XpColors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: XpText.titleM(context))),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
            decoration: BoxDecoration(
              color: XpColors.sunken,
              borderRadius: BorderRadius.circular(XpRadius.m),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    value,
                    style: large
                        ? XpText.headingM(context).copyWith(letterSpacing: 1)
                        : XpText.bodyM(context),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: value));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text('Disalin')),
                      );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Salin'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style:
                XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
