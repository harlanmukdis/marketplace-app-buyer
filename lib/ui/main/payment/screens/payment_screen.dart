import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/payment/cubit/payment_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Layar pembayaran: instruksi bayar dan status transaksi.
///
/// Satu transaksi menutup **semua** order dari satu sesi checkout, jadi layar
/// ini tidak terikat ke satu pesanan.
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
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, 'Pembayaran'),
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
            PaymentError(:final error) => _Message(
                icon: Icons.cloud_off_rounded,
                title: errorMessageFor(context, error),
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
    final dark = isAppDarkMode();
    final payment = state.snapshot.payment;

    if (payment.isPaid) {
      return const _Message(
        icon: Icons.check_circle_outline,
        iconColor: kSuccessColor,
        title: 'Pembayaran diterima.',
        subtitle: 'Pesanan kamu akan segera diproses penjual.',
      );
    }

    if (payment.isExpired) {
      return const _Message(
        icon: Icons.timer_off_outlined,
        iconColor: kErrorColor,
        title: 'Batas waktu pembayaran sudah lewat.',
        subtitle: 'Pesanan dibatalkan otomatis. Silakan pesan ulang.',
      );
    }

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        _PaymentCountdown(expiredAt: payment.expiredAt),
        16.sbh,
        Text(
          'Total tagihan',
          style: AppStyles.styleRegular12(context).copyWith(
            color: dark ? kDarkThirdColor : kLightThirdColor,
          ),
        ),
        Text(
          formatRupiah(payment.amount),
          style: AppStyles.styleSemiBold24(context).copyWith(
            color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
          ),
        ),
        24.sbh,
        _Instruction(instruction: state.snapshot.instruction),
        24.sbh,
        SizedBox(
          width: double.infinity,
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
      ],
    );
  }
}

/// Hitung mundur tenggat bayar.
///
/// Memakai `expired_at` yang dikirim server dalam **UTC**, berbeda dari
/// `created_at` di respons yang sama yang memakai WIB.
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
    final deadline = widget.expiredAt;
    if (deadline == null) return const SizedBox.shrink();

    final left = deadline.difference(DateTime.now().toUtc());
    final expired = left.isNegative;

    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: (expired ? kErrorColor : kWarningColor).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined,
              size: 18, color: expired ? kErrorColor : kWarningColor),
          8.sbw,
          Expanded(
            child: Text(
              expired
                  ? 'Batas waktu pembayaran sudah lewat'
                  : 'Bayar dalam ${formatCountdown(left)}',
              style: AppStyles.styleMedium14(context).copyWith(
                color: expired ? kErrorColor : kWarningColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Instruction extends StatelessWidget {
  const _Instruction({required this.instruction});

  final PaymentInstructionModel? instruction;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final data = instruction;

    if (data == null) {
      return Text(
        'Instruksi pembayaran belum bisa dimuat. Coba muat ulang halaman ini.',
        style:
            AppStyles.styleRegular14(context).copyWith(color: kWarningColor),
      );
    }

    return switch (data.kind) {
      PaymentInstructionKind.qris => _CopyBlock(
          title: 'Kode QRIS',
          // QR-nya tidak dirender jadi gambar: aplikasi belum punya
          // pustaka QR, dan menampilkan string mentah lebih jujur daripada
          // kotak kosong. Penyedia menerima string ini apa adanya.
          value: data.qrString ?? '',
          hint: 'Salin lalu tempel di aplikasi pembayaran kamu.',
        ),
      PaymentInstructionKind.virtualAccount => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((data.bank ?? '').isNotEmpty)
              Text(
                'Bank ${data.bank}',
                style: AppStyles.styleMedium14(context).copyWith(
                  color: dark ? kDarkSecondColor : kLightSecondColor,
                ),
              ),
            8.sbh,
            _CopyBlock(
              title: 'Nomor Virtual Account',
              value: data.vaNumber ?? '',
              hint: 'Transfer tepat sejumlah tagihan ke nomor ini.',
            ),
          ],
        ),
      PaymentInstructionKind.unknown => Text(
          'Ikuti instruksi pembayaran dari penyedia.',
          style: AppStyles.styleRegular14(context).copyWith(
            color: dark ? kDarkThirdColor : kLightThirdColor,
          ),
        ),
    };
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock({
    required this.title,
    required this.value,
    required this.hint,
  });

  final String title;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: dark ? kDarkSecondColor : kLightSecondColor,
          ),
        ),
        8.sbh,
        Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.all(12),
          decoration: BoxDecoration(
            color: dark ? kLightSecondColor : kBorderColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                value,
                style: AppStyles.styleMedium14(context).copyWith(
                  color: dark ? kDarkSecondColor : kLightSecondColor,
                ),
              ),
              8.sbh,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
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
              ),
            ],
          ),
        ),
        6.sbh,
        Text(
          hint,
          style: AppStyles.styleRegular12(context).copyWith(
            color: dark ? kDarkThirdColor : kLightThirdColor,
          ),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 56,
                color: iconColor ??
                    (dark ? kDarkThirdColor : kLightThirdColor)),
            16.sbh,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            if (subtitle != null) ...[
              8.sbh,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppStyles.styleRegular12(context).copyWith(
                  color: dark ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
            ],
            if (actionLabel != null) ...[
              16.sbh,
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
