import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';

/// Pesan untuk `VALIDATION_ERROR` dari `POST /me/bank-accounts`.
///
/// Server memakai satu kode untuk field kosong, rekening keempat, dan nama
/// pemilik yang tidak cocok. Dua yang pertama sudah dicegat `WalletCubit`,
/// jadi yang sampai ke sini praktis berarti nama pemiliknya berbeda.
const _holderMismatch =
    'Rekening ditolak. Nama pemilik harus sama persis dengan nama lengkap '
    'di akun Xpedia-mu.';

/// Rekening tujuan penarikan: maksimal 3, atas nama sendiri.
class BankAccountsScreen extends StatelessWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletCubit()..load(),
      child: const _BankAccountsBody(),
    );
  }
}

class _BankAccountsBody extends StatelessWidget {
  const _BankAccountsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Rekening Bank'),
      body: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (previous, current) =>
            current is WalletReady && current.actionError != null,
        listener: (context, state) {
          final error = (state as WalletReady).actionError!;
          // Selagi lembar tambah rekening terbuka, lembar itu sendiri yang
          // menampilkan pesannya — snackbar di sini akan tertutup lembarnya.
          if (ModalRoute.of(context)?.isCurrent ?? true) {
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(accountErrorText(context, error,
                  overrides: {ApiErrorCode.validationError: _holderMismatch})),
            ));
          }
          WalletCubit.get(context).clearActionError();
        },
        builder: (context, state) => switch (state) {
          WalletLoading() => const Center(child: CircularProgressIndicator()),
          WalletError(:final error) => XpEmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Rekening belum bisa dimuat',
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
    final cubit = WalletCubit.get(context);
    final accounts = state.bankAccounts;
    final full = accounts.length >= BankAccountModel.maxAccounts;

    if (state.bankAccountsError != null) {
      return XpEmptyState(
        icon: Icons.cloud_off_rounded,
        title: 'Rekening belum bisa dimuat',
        message: accountErrorText(context, state.bankAccountsError!),
        actionLabel: 'Coba lagi',
        onAction: state.isSubmitting ? null : cubit.reloadBankAccounts,
      );
    }

    return Column(
      children: [
        Expanded(
          child: accounts.isEmpty
              ? XpEmptyState(
                  icon: Icons.account_balance_outlined,
                  title: 'Belum ada rekening',
                  message: 'Tambahkan rekening atas namamu sendiri untuk '
                      'menarik saldo Xpedia Wallet.',
                  actionLabel: 'Tambah Rekening',
                  onAction: state.isSubmitting ? null : () => _AddAccountSheet.show(context),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Rekening Tersimpan', style: XpText.titleL(context)),
                        ),
                        Text(
                          '${accounts.length} / ${BankAccountModel.maxAccounts}',
                          style: XpText.labelL(context)
                              .copyWith(color: XpColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    for (final account in accounts)
                      _AccountTile(account: account, busy: state.isSubmitting),
                    const SizedBox(height: 8),
                    const XpBanner(
                      icon: Icons.info_outline,
                      title: 'Hanya rekening atas nama sendiri',
                      message: 'Nama pemilik rekening harus sama persis dengan '
                          'nama lengkap di akun Xpedia-mu.',
                    ),
                  ],
                ),
        ),
        if (accounts.isNotEmpty)
          XpBottomBar(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: full || state.isSubmitting
                    ? null
                    : () => _AddAccountSheet.show(context),
                icon: const Icon(Icons.add),
                label: Text(full ? 'Maksimal 3 rekening tersimpan' : 'Tambah Rekening'),
              ),
            ),
          ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.account, required this.busy});

  final BankAccountModel account;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: XpColors.primarySubtle,
              borderRadius: BorderRadius.circular(XpRadius.m),
            ),
            child: Icon(Icons.account_balance, size: 20, color: XpColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.bankName, style: XpText.titleM(context)),
                Text(
                  '${account.maskedNumber} · ${account.accountHolderName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hapus rekening',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: busy ? null : () => _confirmDelete(context),
            icon: Icon(Icons.delete_outline, color: XpColors.danger),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = WalletCubit.get(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus rekening?'),
        content: Text(
          '${account.bankName} ${account.maskedNumber} tidak bisa lagi dipilih '
          'sebagai tujuan penarikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: XpColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) await cubit.deleteBankAccount(account.id);
  }
}

/// Formulir tambah rekening.
class _AddAccountSheet extends StatefulWidget {
  const _AddAccountSheet();

  static Future<void> show(BuildContext context) {
    final cubit = WalletCubit.get(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: XpColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(XpRadius.xl)),
      ),
      builder: (_) => BlocProvider.value(value: cubit, child: const _AddAccountSheet()),
    );
  }

  @override
  State<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends State<_AddAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bank = TextEditingController();
  final _number = TextEditingController();
  final _holder = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _bank.dispose();
    _number.dispose();
    _holder.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    final cubit = WalletCubit.get(context);
    final before = (cubit.state as WalletReady).bankAccounts.length;
    await cubit.addBankAccount(
      bankName: _bank.text.trim(),
      accountNumber: _number.text.trim(),
      accountHolderName: _holder.text.trim(),
    );
    if (!mounted) return;
    // Ditutup hanya kalau daftarnya benar-benar bertambah. Kalau ditolak,
    // isian tetap ada supaya user cukup membetulkan nama pemiliknya.
    final after = cubit.state;
    if (after is WalletReady && after.bankAccounts.length > before) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listenWhen: (previous, current) =>
          current is WalletReady && current.actionError != null,
      listener: (context, state) => setState(() {
        _error = accountErrorText(context, (state as WalletReady).actionError!,
            overrides: {ApiErrorCode.validationError: _holderMismatch});
      }),
      child: _form(context),
    );
  }

  Widget _form(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Tambah Rekening', style: XpText.headingM(context)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bank,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Nama bank',
                    hintText: 'Mis. BCA, Mandiri, BRI',
                  ),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Nama bank wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _number,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Nomor rekening'),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Nomor rekening wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _holder,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama pemilik rekening',
                    helperText: 'Harus sama persis dengan nama lengkap di akun '
                        'Xpedia-mu.',
                    helperMaxLines: 2,
                  ),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Nama pemilik wajib diisi' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: XpText.bodyS(context).copyWith(color: XpColors.danger)),
                ],
                const SizedBox(height: 20),
                BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    final busy = state is WalletReady && state.isSubmitting;
                    return SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: busy ? null : _submit,
                        child: Text(busy ? 'Menyimpan…' : 'Simpan Rekening'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
