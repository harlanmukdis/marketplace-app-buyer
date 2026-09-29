import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_error_banner.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_field_label.dart';

/// Layar login.
///
/// Menggantikan `login_view.dart` dari UI kit, yang meminta **nama + email**
/// tanpa controller dan tombolnya langsung `router.go(homeLayout)` tanpa
/// memanggil apa pun. marketplace-api masuk dengan **email + kata sandi**,
/// jadi fieldnya memang harus berubah, bukan sekadar disambungkan.
///
/// Tombol login sosial dari kit sengaja tidak dibawa: backend tidak punya
/// endpoint OAuth, dan tombol yang tidak melakukan apa-apa lebih buruk
/// daripada tidak ada tombol.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    AuthCubit.get(context).login(
      email: _email.text.trim(),
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          router.go(AppRoutes.homeLayout);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final error = state is AuthUnauthenticated ? state.error : null;

        // Tombol "Butuh bantuan?" milik kit sengaja tidak dibawa: aksinya
        // `onPressed: () {}`, dan satu-satunya kanal bantuan (Xpedia 911)
        // menuntut user sudah masuk.
        return Scaffold(
          backgroundColor: XpColors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.screenHeight * .08),
                    const Center(child: AuthBrandMark()),
                    const SizedBox(height: 32),
                    Text(
                      l.welcomeBack,
                      textAlign: TextAlign.center,
                      style: XpText.headingXl(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: XpText.bodyM(context)
                          .copyWith(color: XpColors.textSecondary),
                    ),
                    const SizedBox(height: 32),

                    if (error != null) ...[
                      AuthErrorBanner(error: error, onRetry: _submit),
                      const SizedBox(height: 16),
                    ],

                    // API ini masuk lewat **email**, bukan nomor HP. Nomor HP
                    // tetap wajib diisi saat mendaftar, tapi tidak bisa dipakai
                    // login — jadi kolomnya diganti, bukan ditambah.
                    AuthFieldLabel(l.email, isRequired: true),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _email,
                      readOnly: isLoading,
                      hintText: l.enterYourEmail,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline,
                      // Selalu LTR: alamat email tidak boleh terbalik
                      // urutannya saat locale-nya Arab.
                      textDirection: TextDirection.ltr,
                      // Kunci l10n untuk dua pesan ini belum ada, dan
                      // regenerasinya butuh `intl_utils` yang bukan
                      // dev_dependency. Ditulis langsung supaya validasinya
                      // tetap ada — bukan dibiarkan lolos.
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'Email wajib diisi';
                        if (!value.contains('@')) {
                          return 'Format email belum benar';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    AuthFieldLabel(l.password, isRequired: true),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _password,
                      readOnly: isLoading,
                      hintText: l.password,
                      obscureText: _obscure,
                      prefixIcon: Icons.lock_outline,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => isLoading ? null : _submit(),
                      suffix: AuthObscureToggle(
                        obscured: _obscure,
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? l.passwordRequired
                          : null,
                    ),

                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(48, 48),
                        ),
                        onPressed: () => router.push(AppRoutes.forgotPassword),
                        child: Text(
                          l.forgetPassword,
                          style: XpText.labelL(context)
                              .copyWith(color: XpColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    AuthSubmitButton(
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                      label: l.continuee,
                    ),
                    const SizedBox(height: 24),

                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          l.dontHaveAccount,
                          style: XpText.bodyM(context)
                              .copyWith(color: XpColors.textSecondary),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 48),
                          ),
                          onPressed: isLoading
                              ? null
                              : () => router.push(AppRoutes.register),
                          child: Text(
                            l.register,
                            style: XpText.titleM(context)
                                .copyWith(color: XpColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
