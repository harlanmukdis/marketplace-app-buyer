import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/ui/main/checkout/cubit/checkout_cubit.dart';
import 'package:marketplace_app_member/ui/main/checkout/widgets/checkout_error_text.dart';
import 'package:marketplace_app_member/ui/main/wallet/widgets/pin_pad.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Hasil lembar PIN.
enum WalletPinOutcome { paid, closed, forgotPin }

/// Lembar "Masukkan PIN 6-Digit" (desain
/// `autentikasi_pin_6_digit_xpedia_wallet`, inventaris §3.11).
///
/// Setiap pembayaran Wallet **wajib** lewat lembar ini — tidak ada bayar
/// satu ketukan (design_buyer.md §5 aturan 5). PIN dikirim otomatis begitu
/// digit keenam masuk, sama seperti desain; tidak ada tombol konfirmasi.
///
/// Yang sengaja tidak dibangun dari desain:
///
/// * pil **"Gunakan Sidik Jari / Face ID"** dan tombol wajah di papan angka —
///   aplikasi belum punya autentikasi biometrik, dan tombol mati lebih buruk
///   daripada tidak ada (sama dengan `PinPad`);
/// * **"Lupa PIN Wallet? Reset di sini"** — tidak ada endpoint reset PIN;
///   yang ditawarkan adalah menghubungi Xpedia 911;
/// * klaim "enkripsi 256-bit Xpedia Secure+" — Secure+ adalah proteksi
///   pengiriman, bukan enkripsi, dan klaimnya tidak bisa diverifikasi.
///
/// Lembar ini membaca [CheckoutCubit] yang sama dengan layar di belakangnya
/// (`BlocProvider.value`): penolakan PIN tampil di sini, penolakan lain
/// menutup lembar dan tampil sebagai snackbar di layar checkout.
Future<WalletPinOutcome> showWalletPinSheet(
  BuildContext context, {
  required double amount,
  required String payee,
  String? simulatedPin,
}) async {
  final cubit = CheckoutCubit.get(context);
  cubit.clearPinError();
  final outcome = await showModalBottomSheet<WalletPinOutcome>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    backgroundColor: XpColors.surface,
    barrierColor: const Color(0x8C101014),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: WalletPinSheet(
        amount: amount,
        payee: payee,
        simulatedPin: simulatedPin,
      ),
    ),
  );
  return outcome ?? WalletPinOutcome.closed;
}

class WalletPinSheet extends StatefulWidget {
  const WalletPinSheet({
    super.key,
    required this.amount,
    required this.payee,
    this.simulatedPin,
  });

  final double amount;
  final String payee;

  /// PIN yang diterima mock (`meta.mock_pin` dari `wallet-summary`), supaya
  /// simulasinya bisa dicoba. Server sungguhan tidak pernah mengirimnya,
  /// jadi petunjuk ini hilang sendiri begitu endpointnya dibangun.
  final String? simulatedPin;

  @override
  State<WalletPinSheet> createState() => _WalletPinSheetState();
}

class _WalletPinSheetState extends State<WalletPinSheet> {
  /// Diganti setiap PIN ditolak supaya [PinEntry] mulai dari kosong.
  int _attempt = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        final navigator = Navigator.of(context);
        if (state is CheckoutConfirmed) {
          navigator.pop(WalletPinOutcome.paid);
          return;
        }
        if (state is CheckoutReady &&
            !state.isSubmitting &&
            state.actionError != null) {
          navigator.pop(WalletPinOutcome.closed);
          return;
        }
        if (state is CheckoutReady && state.pinError != null) {
          setState(() => _attempt++);
        }
      },
      listenWhen: (previous, current) =>
          current is CheckoutConfirmed ||
          (current is CheckoutReady &&
              (current.actionError != null ||
                  (current.pinError != null &&
                      (previous is! CheckoutReady ||
                          previous.pinError != current.pinError)))),
      builder: (context, state) {
        final ready = state is CheckoutReady ? state : null;
        final submitting = ready?.isSubmitting ?? true;
        final pinError = ready?.pinError;
        final locked = pinError?.code == ApiErrorCode.tooManyRequests;

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TopBar(
                onClose: submitting
                    ? null
                    : () => Navigator.of(context).pop(WalletPinOutcome.closed),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: XpColors.primarySubtle,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: XpColors.primary.withValues(alpha: 0.25),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Icon(Icons.shield,
                            size: 32, color: XpColors.primary),
                      ),
                      const SizedBox(height: 16),
                      Text('Masukkan PIN 6-Digit',
                          style: XpText.headingL(context)),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          style: XpText.bodyM(context)
                              .copyWith(color: XpColors.textSecondary),
                          children: [
                            const TextSpan(
                                text: 'Konfirmasi pembayaran belanja sebesar '),
                            TextSpan(
                              text: formatRupiah(widget.amount),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: XpColors.textPrimary),
                            ),
                            const TextSpan(text: ' ke '),
                            TextSpan(
                              text: widget.payee,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: XpColors.textPrimary),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      PinEntry(
                        key: ValueKey(_attempt),
                        enabled: !submitting && !locked,
                        hasError: pinError != null,
                        onChanged: (_) {
                          if (pinError != null && !locked) {
                            CheckoutCubit.get(context).clearPinError();
                          }
                        },
                        onCompleted: (pin) =>
                            CheckoutCubit.get(context).payWithWallet(pin),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: submitting
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('Memproses pembayaran…',
                                        style: XpText.bodyS(context)),
                                  ],
                                )
                              : pinError != null
                                  ? Text(
                                      checkoutErrorText(context, pinError),
                                      textAlign: TextAlign.center,
                                      style: XpText.bodyS(context)
                                          .copyWith(color: XpColors.danger),
                                    )
                                  : const SizedBox.shrink(),
                        ),
                      ),
                      if (widget.simulatedPin != null)
                        Text(
                          'Simulasi: PIN yang diterima '
                          '${widget.simulatedPin}',
                          style: XpText.caption(context)
                              .copyWith(color: const Color(0xff8C5002)),
                        ),
                      TextButton(
                        onPressed: submitting
                            ? null
                            : () => Navigator.of(context)
                                .pop(WalletPinOutcome.forgotPin),
                        child: const Text('Lupa PIN? Hubungi Xpedia 911'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XpColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Tutup',
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(XpRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user,
                        size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text('Keamanan Dompet',
                        style: XpText.labelM(context)
                            .copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          // Penyeimbang lebar tombol tutup, supaya pil tepat di tengah.
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
