import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';
import 'package:marketplace_app_member/ui/main/wallet/widgets/pin_pad.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Pesan untuk `WITHDRAWAL_REJECTED`.
///
/// Server memakai kode itu untuk lima penolakan berbeda. Minimum, rekening,
/// dan saldo sudah diperiksa `WalletCubit` sebelum dikirim, jadi yang tersisa
/// praktis PIN salah atau PIN yang belum pernah dibuat.
const _withdrawalRejected =
    'Penarikan ditolak. PIN salah, atau kamu belum membuat PIN Xpedia Wallet.';

/// Lembar penarikan dua langkah: nominal + rekening tujuan, lalu PIN.
///
/// Nominal dan rekening diperiksa **sebelum** papan PIN muncul. Alasannya
/// kuota PIN: setiap pengiriman ke server menghabiskan satu dari 5 percobaan
/// per 15 menit — PIN yang benar pun dihitung — jadi penolakan yang bisa
/// diketahui lebih dulu tidak boleh sampai memakan kuota itu.
class WithdrawSheet extends StatefulWidget {
  const WithdrawSheet({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = WalletCubit.get(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: XpColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(XpRadius.xl)),
      ),
      builder: (_) => BlocProvider.value(value: cubit, child: const WithdrawSheet()),
    );
  }

  @override
  State<WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<WithdrawSheet> {
  final _amount = TextEditingController();
  int? _accountId;
  bool _askingPin = false;
  String? _error;
  int _pinGeneration = 0;

  @override
  void initState() {
    super.initState();
    final state = WalletCubit.get(context).state;
    if (state is WalletReady && state.bankAccounts.length == 1) {
      _accountId = state.bankAccounts.first.id;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  double get _amountValue => double.tryParse(_amount.text.trim()) ?? 0;

  void _continueToPin(WalletReady state) {
    final amount = _amountValue;
    final problem = switch (amount) {
      _ when amount < WithdrawalDraft.minimumAmount =>
        'Minimum penarikan ${formatRupiah(WithdrawalDraft.minimumAmount)}',
      _ when amount > state.wallet.availableBalance => 'Saldo tidak mencukupi',
      _ when _accountId == null => 'Pilih rekening tujuan',
      _ => null,
    };
    setState(() {
      _error = problem;
      if (problem == null) _askingPin = true;
    });
  }

  void _submit(String pin) {
    WalletCubit.get(context).withdraw(WithdrawalDraft(
      amount: _amountValue,
      bankAccountId: _accountId,
      pin: pin,
    ));
  }

  Future<void> _addAccount() async {
    final cubit = WalletCubit.get(context);
    await context.push(AppRoutes.bankAccounts);
    if (!mounted) return;
    await cubit.reloadBankAccounts();
    final state = cubit.state;
    if (mounted && state is WalletReady && state.bankAccounts.length == 1) {
      setState(() => _accountId = state.bankAccounts.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listenWhen: (previous, current) =>
          current is WalletReady &&
          (current.actionError != null || current.withdrawalSubmitted),
      listener: (context, state) {
        final ready = state as WalletReady;
        if (ready.withdrawalSubmitted) {
          // Snackbar dan `acknowledgeWithdrawal` ditangani layar dompet.
          Navigator.of(context).pop();
          return;
        }
        setState(() {
          _error = accountErrorText(context, ready.actionError!,
              overrides: {ApiErrorCode.withdrawalRejected: _withdrawalRejected});
          _pinGeneration++;
        });
      },
      builder: (context, state) {
        if (state is! WalletReady) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: _askingPin ? _pinStep(context, state) : _formStep(context, state),
            ),
          ),
        );
      },
    );
  }

  Widget _formStep(BuildContext context, WalletReady state) {
    final accounts = state.bankAccounts;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Tarik Saldo', style: XpText.headingM(context)),
        const SizedBox(height: 4),
        Text(
          'Tersedia ${formatRupiah(state.wallet.availableBalance)} · minimum '
          '${formatRupiah(WithdrawalDraft.minimumAmount)}',
          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _amount,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          decoration: const InputDecoration(labelText: 'Nominal', prefixText: 'Rp '),
        ),
        const SizedBox(height: 20),
        Text('Rekening Tujuan', style: XpText.titleM(context)),
        const SizedBox(height: 8),
        if (state.bankAccountsError != null)
          XpBanner(
            icon: Icons.cloud_off_rounded,
            tone: XpBannerTone.warning,
            title: 'Rekening belum bisa dimuat',
            message: accountErrorText(context, state.bankAccountsError!),
            onTap: state.isSubmitting ? null : WalletCubit.get(context).reloadBankAccounts,
            trailing: const Icon(Icons.refresh, size: 20),
          )
        else if (accounts.isEmpty)
          XpBanner(
            icon: Icons.account_balance_outlined,
            title: 'Belum ada rekening tersimpan',
            message: 'Tambahkan rekening atas namamu sendiri dulu.',
            onTap: _addAccount,
            trailing: Text('Tambah rekening',
                style: XpText.labelL(context).copyWith(color: XpColors.primary)),
          )
        else
          for (final account in accounts)
            _AccountOption(
              account: account,
              selected: account.id == _accountId,
              onTap: () => setState(() {
                _accountId = account.id;
                _error = null;
              }),
            ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: XpText.bodyS(context).copyWith(color: XpColors.danger)),
        ],
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: state.isSubmitting ? null : () => _continueToPin(state),
            child: const Text('Lanjut'),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          // Penting supaya user tidak bingung melihat saldo langsung
          // berkurang sebelum dana masuk rekening.
          'Saldo langsung berkurang saat pengajuan dibuat, lalu dana dikirim '
          'setelah diproses admin.',
          style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
        ),
      ],
    );
  }

  Widget _pinStep(BuildContext context, WalletReady state) {
    final account = state.bankAccounts.where((a) => a.id == _accountId).firstOrNull;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Kembali',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: state.isSubmitting
                  ? null
                  : () => setState(() {
                        _askingPin = false;
                        _error = null;
                      }),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text('Masukkan PIN 6-Digit',
                  textAlign: TextAlign.center, style: XpText.headingM(context)),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'Tarik saldo sebesar '),
            TextSpan(
              text: formatRupiah(_amountValue),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (account != null) ...[
              const TextSpan(text: ' ke '),
              TextSpan(
                text: '${account.bankName} ${account.maskedNumber}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ]),
          textAlign: TextAlign.center,
          style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 24),
        PinEntry(
          key: ValueKey(_pinGeneration),
          enabled: !state.isSubmitting,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onCompleted: _submit,
        ),
        SizedBox(
          height: 44,
          child: Center(
            child: state.isSubmitting
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : _error == null
                    ? null
                    : Text(_error!,
                        textAlign: TextAlign.center,
                        style: XpText.bodyS(context).copyWith(color: XpColors.danger)),
          ),
        ),
        const XpBanner(
          icon: Icons.warning_amber_rounded,
          tone: XpBannerTone.warning,
          title: 'Percobaan PIN terbatas',
          message: 'Maksimal 5 kali per 15 menit — PIN yang benar pun ikut '
              'dihitung. Lewat dari itu, tunggu beberapa menit.',
        ),
        TextButton(
          onPressed: state.isSubmitting
              ? null
              : () async {
                  final navigator = Navigator.of(context);
                  await context.push(AppRoutes.withdrawalPin);
                  if (navigator.mounted) setState(() => _pinGeneration++);
                },
          child: const Text('Belum punya PIN? Buat di sini'),
        ),
      ],
    );
  }
}

class _AccountOption extends StatelessWidget {
  const _AccountOption({
    required this.account,
    required this.selected,
    required this.onTap,
  });

  final BankAccountModel account;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: selected ? XpColors.primarySubtle : null,
      borderColor: selected ? XpColors.primary : null,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            size: 20,
            color: selected ? XpColors.primary : XpColors.textTertiary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${account.bankName} ${account.maskedNumber}',
                    style: XpText.titleM(context)),
                Text(account.accountHolderName,
                    style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
