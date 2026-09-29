import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_error_banner.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_field_label.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';

/// Layar pendaftaran.
///
/// Lima field, semuanya wajib: nama, **nomor HP** (tanpa itu server membalas
/// `422 VALIDATION_ERROR` dengan `details: null` — tidak menyebut field mana),
/// **NIK KTP** (wajib sejak backend `3e8906d`, docs/22 #4 "1 KTP = 1 akun"),
/// email (identitas login), dan kata sandi. `POST /auth/register` tidak
/// mengembalikan token, jadi `AuthCubit.register` merangkainya dengan login.
///
/// Urutan field dipatok e2e test (`find.byType(TextFormField)` indeks 0–4:
/// nama, telepon, NIK, email, kata sandi) — ubah
/// `integration_test/member_journey_test.dart` kalau urutannya diubah.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatefulWidget {
  const _RegisterBody();

  @override
  State<_RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<_RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _idCard = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _idCard.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// NIK sering diketik berkelompok ("3171 0101 …"); server menuntut tepat
  /// 16 digit tanpa pemisah.
  String get _normalizedIdCard => _idCard.text.replaceAll(RegExp(r'[\s.-]'), '');

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    AuthCubit.get(context).register(
      email: _email.text.trim(),
      password: _password.text,
      fullName: _fullName.text.trim(),
      phone: _phone.text.trim(),
      idCardNumber: _normalizedIdCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          router.go(AppRoutes.homeLayout);
          return;
        }
        if (state is AuthRegisteredNeedsLogin) {
          // Akun sudah terbentuk, hanya login otomatisnya gagal. Mengarahkan
          // ke login — kalau user disuruh mendaftar lagi, dia akan kena
          // 409 PHONE_TAKEN dan menyangka pendaftarannya gagal.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.somethingWentWrong),
              backgroundColor: kWarningColor,
            ),
          );
          router.go(AppRoutes.login);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final error = state is AuthUnauthenticated ? state.error : null;

        return Scaffold(
          backgroundColor: XpColors.surface,
          appBar: XpStackAppBar(
            title: l.register,
            // Bawaan XpStackAppBar jatuh ke Beranda saat tidak bisa pop —
            // tujuan yang salah bagi user yang belum masuk.
            onBack: () => router.canPop()
                ? router.pop()
                : router.go(AppRoutes.login),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: AuthBrandMark(),
                    ),
                    const SizedBox(height: 16),
                    Text(l.registerTitle, style: XpText.headingXl(context)),
                    const SizedBox(height: 4),
                    Text(
                      l.registerSubtitle,
                      style: XpText.bodyM(context)
                          .copyWith(color: XpColors.textSecondary),
                    ),
                    const SizedBox(height: 24),

                    if (error != null) ...[
                      AuthErrorBanner(error: error, onRetry: _submit),
                      const SizedBox(height: 16),
                    ],

                    AuthFieldLabel(l.name, isRequired: true),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _fullName,
                      readOnly: isLoading,
                      hintText: l.enterYourName,
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.nameRequired
                          : null,
                    ),
                    const SizedBox(height: 16),

                    AuthFieldLabel(l.phoneNumber, isRequired: true),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _phone,
                      readOnly: isLoading,
                      hintText: l.enterYourPhoneNumber,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.phoneRequired
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Server tidak membalas NIK yang salah format dengan kode
                    // tersendiri (hanya VALIDATION_ERROR), jadi formatnya
                    // dijaga di sini supaya pesannya bisa tepat.
                    const AuthFieldLabel('NIK (Nomor KTP)', isRequired: true),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _idCard,
                      readOnly: isLoading,
                      hintText: '16 digit sesuai KTP',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.badge_outlined,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.next,
                      validator: (_) {
                        final nik = _normalizedIdCard;
                        if (nik.isEmpty) return 'NIK wajib diisi';
                        if (!RegExp(r'^\d{16}$').hasMatch(nik)) {
                          return 'NIK harus 16 digit angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Satu NIK hanya untuk satu akun Xpedia.',
                      style: XpText.bodyS(context)
                          .copyWith(color: XpColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // Email kini **identitas login**, bukan pelengkap: API ini
                    // masuk lewat email, bukan nomor HP.
                    AuthFieldLabel(l.email, isRequired: true),
                    const SizedBox(height: 8),
                    AuthTextField(
                      controller: _email,
                      readOnly: isLoading,
                      hintText: l.enterYourEmail,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.next,
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
                      validator: (v) {
                        if (v == null || v.isEmpty) return l.passwordRequired;
                        if (v.length < 6) return l.passwordTooShort;
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),
                    AuthSubmitButton(
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                      label: l.createAccount,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(48, 48),
                        ),
                        onPressed: isLoading
                            ? null
                            : () => router.go(AppRoutes.login),
                        child: Text(
                          l.alreadyHaveAccount,
                          style: XpText.labelL(context)
                              .copyWith(color: XpColors.primary),
                        ),
                      ),
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
