import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/identity_verification_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/contact_change_sheet.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';

/// Ubah profil — `PATCH /me` (sungguhan) lewat `AuthCubit.updateProfile`.
///
/// Menggantikan `EditProfileView` UI kit. Yang bisa diubah hanya **nama
/// lengkap**: `PATCH /me` menerima `full_name` + `avatar_url` saja, dan foto
/// belum bisa diunggah dengan benar (`POST /media/upload` merakit URL dari
/// `base_url` backend yang masih salah). Email dan nomor HP tampil sebagai
/// teks dengan tombol "Ubah" yang membuka alur OTP (kontrak usulan, docs/22
/// #10).
///
/// docs/22 #11: sesudah KTP terverifikasi (atau selama ditinjau), nama
/// lengkap **dikunci**. Status itu dari kontrak usulan
/// `GET /me/identity-verification`; tanpa endpoint itu nama tetap bisa
/// diubah seperti sekarang di server.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..restoreSession()),
        BlocProvider(create: (_) => IdentityVerificationCubit()..load()),
      ],
      child: const _EditProfileBody(),
    );
  }
}

class _EditProfileBody extends StatefulWidget {
  const _EditProfileBody();

  @override
  State<_EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<_EditProfileBody> {
  final _name = TextEditingController();
  bool _prefilled = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    // `BlocListener` tidak memutar ulang state yang sudah ada — kalau profil
    // sudah tiba sebelum listener terpasang, isi dari sini.
    _prefill(context.read<AuthCubit>().state);
  }

  void _prefill(AuthState state) {
    if (!_prefilled && state is AuthAuthenticated && state.user != null) {
      _prefilled = true;
      _name.text = state.user!.fullName ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save(UserModel user) async {
    final name = _name.text.trim();
    if (name.length < 2) {
      setState(() => _localError = 'Nama lengkap minimal 2 huruf.');
      return;
    }
    setState(() => _localError = null);
    FocusManager.instance.primaryFocus?.unfocus();
    if (name == (user.fullName ?? '').trim()) {
      Navigator.of(context).maybePop();
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final ok = await AuthCubit.get(context).updateProfile(fullName: name);
    if (!ok || !mounted) return;
    messenger.showSnackBar(const SnackBar(content: Text('Profil tersimpan.')));
    navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      // Nama diisi sekali saja, saat profil pertama kali tiba — mengisi ulang
      // di setiap emit akan menimpa ketikan user.
      listener: (context, state) => _prefill(state),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: XpColors.canvas,
          appBar: const XpStackAppBar(title: 'Ubah Profil'),
          body: switch (state) {
            AuthAuthenticated(:final user?) => _form(context, state, user),
            AuthAuthenticated() || AuthUnauthenticated() => XpEmptyState(
                icon: Icons.person_off_outlined,
                title: 'Profil belum bisa dimuat',
                message: 'Periksa koneksimu lalu coba lagi.',
                actionLabel: 'Coba Lagi',
                onAction: AuthCubit.get(context).restoreSession,
              ),
            _ => const Center(child: CircularProgressIndicator()),
          },
          bottomNavigationBar: state is AuthAuthenticated && state.user != null
              ? BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
                  builder: (context, identity) {
                    final locked = _locked(identity);
                    return XpBottomBar(
                      child: FilledButton(
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        onPressed: state.isSaving || locked ? null : () => _save(state.user!),
                        child: state.isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Simpan'),
                      ),
                    );
                  },
                )
              : null,
        );
      },
    );
  }

  static bool _locked(IdentityVerificationState s) =>
      s is IdentityVerificationReady && s.verification.locksFullName;

  Widget _form(BuildContext context, AuthAuthenticated state, UserModel user) {
    final error = _localError != null ? localValidationError(_localError!) : state.actionError;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: XpInitialAvatar(
            name: user.displayName,
            imageUrl: user.avatarUrl?.trim(),
            size: 72,
          ),
        ),
        const SizedBox(height: 24),
        BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
          builder: (context, identity) {
            final locked = _locked(identity);
            final verification =
                identity is IdentityVerificationReady ? identity.verification : null;
            return XpCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    Expanded(child: Text('Nama lengkap', style: XpText.titleM(context))),
                    if (identity is IdentityVerificationReady && locked)
                      SimulatedBadge(meta: identity.meta),
                  ]),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    readOnly: locked || state.isSaving,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Nama yang tampil di akunmu',
                      prefixIcon: const Icon(Icons.person_outline),
                      suffixIcon: locked ? const Icon(Icons.lock_outline) : null,
                    ),
                    onChanged: (_) {
                      if (state.actionError != null) AuthCubit.get(context).clearActionError();
                    },
                  ),
                  if (locked) ...[
                    const SizedBox(height: 8),
                    Text(
                      verification?.statusValue == IdentityStatus.pending
                          ? 'Nama dikunci selama verifikasi KTP ditinjau, supaya yang '
                              'disetujui sama dengan yang tampil.'
                          : 'Nama dikunci karena identitasmu sudah terverifikasi dengan '
                              'KTP. Hubungi Xpedia 911 bila ada yang keliru.',
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(accountErrorText(context, error),
                        style: XpText.bodyS(context).copyWith(color: XpColors.danger)),
                  ],
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        XpCard(
          padding: EdgeInsets.zero,
          child: Column(children: [
            ContactRow(
              icon: Icons.mail_outline,
              type: ContactType.email,
              value: user.email,
              user: user,
            ),
            Divider(height: 1, color: XpColors.borderSubtle),
            ContactRow(
              icon: Icons.phone_outlined,
              type: ContactType.phone,
              value: user.phone,
              user: user,
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Text(
          'Email dan nomor HP diganti lewat verifikasi kode ke kontak lama dan baru.',
          style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
        ),
      ],
    );
  }
}
