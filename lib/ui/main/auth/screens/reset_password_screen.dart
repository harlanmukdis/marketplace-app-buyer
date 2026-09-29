import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/password_reset_cubit.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_error_banner.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_field_label.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';

/// Atur ulang kata sandi — `POST /auth/reset-password {token, new_password}`
/// (sungguhan).
///
/// [token] terisi dari rute (`?token=`, tombol dev di layar Lupa Kata
/// Sandi); kalau kosong, user menempelkan kode dari email. [email] hanya
/// untuk ditampilkan — endpoint-nya tidak memintanya, tokennya sudah
/// menunjuk akun.
///
/// Sesudah berhasil, server mencabut **semua** sesi akun itu, jadi layar ini
/// selalu berakhir di layar masuk.
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, this.email, this.token});

  final String? email;
  final String? token;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordResetCubit(),
      child: _ResetPasswordBody(email: email, token: token),
    );
  }
}

class _ResetPasswordBody extends StatefulWidget {
  const _ResetPasswordBody({this.email, this.token});

  final String? email;
  final String? token;

  @override
  State<_ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<_ResetPasswordBody> {
  late final _token = TextEditingController(text: widget.token ?? '');
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _token.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    PasswordResetCubit.get(context).resetPassword(
      token: _token.text,
      password: _password.text,
      confirmation: _confirm.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasEmail = (widget.email ?? '').trim().isNotEmpty;
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listenWhen: (a, b) => !a.resetDone && b.resetDone,
      listener: (context, state) {
        // SnackBar dipasang di ScaffoldMessenger milik MaterialApp, jadi
        // tetap tampil di layar masuk sesudah rute diganti.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Kata sandi baru tersimpan. Silakan masuk kembali.'),
        ));
        router.go(AppRoutes.login);
      },
      builder: (context, state) {
        final busy = state.isSubmitting || state.resetDone;
        return Scaffold(
          backgroundColor: XpColors.surface,
          appBar: const XpStackAppBar(title: 'Atur Ulang Kata Sandi'),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Buat kata sandi baru', style: XpText.headingL(context)),
                  const SizedBox(height: 8),
                  Text(
                    hasEmail
                        ? 'Untuk akun ${widget.email!.trim()}. Setelah tersimpan, '
                            'kamu keluar dari semua perangkat demi keamanan.'
                        : 'Setelah tersimpan, kamu keluar dari semua perangkat '
                            'demi keamanan.',
                    style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  if (state.error != null) ...[
                    AuthErrorBanner(error: state.error!, onRetry: _submit),
                    const SizedBox(height: 16),
                  ],
                  const AuthFieldLabel('Kode reset', isRequired: true),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _token,
                    readOnly: busy,
                    hintText: 'Tempel kode dari email',
                    prefixIcon: Icons.key_outlined,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 16),
                  const AuthFieldLabel('Kata sandi baru', isRequired: true),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _password,
                    readOnly: busy,
                    hintText: 'Minimal ${PasswordResetCubit.minPasswordLength} karakter',
                    obscureText: _obscure,
                    prefixIcon: Icons.lock_outline,
                    textDirection: TextDirection.ltr,
                    suffix: AuthObscureToggle(
                      obscured: _obscure,
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const AuthFieldLabel('Ulangi kata sandi baru', isRequired: true),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _confirm,
                    readOnly: busy,
                    hintText: 'Ketik ulang kata sandi baru',
                    obscureText: _obscure,
                    prefixIcon: Icons.lock_outline,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => busy ? null : _submit(),
                  ),
                  const SizedBox(height: 24),
                  AuthSubmitButton(
                    onPressed: busy ? null : _submit,
                    isLoading: busy,
                    label: 'Simpan Kata Sandi',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
