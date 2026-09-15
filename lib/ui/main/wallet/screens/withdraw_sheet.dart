import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Formulir pengajuan penarikan dana.
///
/// Memvalidasi batas minimum **sebelum** mengirim, karena server menolak
/// "di bawah minimum" dan "saldo tidak cukup" dengan kode error yang sama —
/// lihat `WalletCubit`.
class WithdrawSheet extends StatefulWidget {
  const WithdrawSheet({super.key, required this.wallet});

  final WalletModel wallet;

  static Future<void> show(BuildContext context, {required WalletModel wallet}) {
    final cubit = WalletCubit.get(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: WithdrawSheet(wallet: wallet),
      ),
    );
  }

  @override
  State<WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<WithdrawSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _bankName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _accountName = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _bankName.dispose();
    _accountNumber.dispose();
    _accountName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final draft = WithdrawalDraft(
      amount: double.tryParse(_amount.text.trim()) ?? 0,
      bankName: _bankName.text.trim(),
      bankAccountNumber: _accountNumber.text.trim(),
      bankAccountName: _accountName.text.trim(),
    );

    final cubit = WalletCubit.get(context);
    await cubit.withdraw(draft);

    if (!mounted) return;
    // Hanya tutup kalau tidak ada error — kalau gagal, user tetap melihat
    // isian yang sudah diketik dan pesannya muncul di layar dompet.
    final state = cubit.state;
    if (state is WalletReady && state.actionError == null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final available = widget.wallet.availableBalance;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tarik Saldo',
                style: AppStyles.styleSemiBold18(context).copyWith(
                  color: dark ? kDarkSecondColor : kLightSecondColor,
                ),
              ),
              4.sbh,
              Text(
                'Tersedia ${formatRupiah(available)} · minimum '
                '${formatRupiah(WithdrawalDraft.minimumAmount)}',
                style: AppStyles.styleRegular12(context).copyWith(
                  color: dark ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
              16.sbh,
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final parsed = double.tryParse((value ?? '').trim());
                  if (parsed == null) return 'Isi nominal penarikan';
                  if (parsed < WithdrawalDraft.minimumAmount) {
                    return 'Minimum ${formatRupiah(WithdrawalDraft.minimumAmount)}';
                  }
                  // Server juga menolaknya, tapi dengan kode yang sama seperti
                  // "di bawah minimum" — jadi dicegah di sini supaya pesannya
                  // tepat.
                  if (parsed > available) {
                    return 'Melebihi saldo tersedia';
                  }
                  return null;
                },
              ),
              12.sbh,
              _field(_bankName, 'Nama bank'),
              12.sbh,
              _field(_accountNumber, 'Nomor rekening',
                  keyboard: TextInputType.number),
              12.sbh,
              _field(_accountName, 'Nama pemilik rekening'),
              16.sbh,
              BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
                  final busy = state is WalletReady && state.isSubmitting;
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: busy ? null : _submit,
                      child: Text(busy ? 'Mengirim…' : 'Ajukan penarikan'),
                    ),
                  );
                },
              ),
              8.sbh,
              Text(
                // Penting supaya user tidak bingung melihat saldo langsung
                // berkurang sebelum dana masuk rekening.
                'Saldo langsung berkurang saat pengajuan dibuat, lalu dana '
                'dikirim setelah diproses admin.',
                style: AppStyles.styleRegular11(context).copyWith(
                  color: dark ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
              8.sbh,
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          (value ?? '').trim().isEmpty ? '$label wajib diisi' : null,
    );
  }
}
