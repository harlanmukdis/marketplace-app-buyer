import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/password_reset_cubit.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_error_banner.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_field_label.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';

/// Lupa kata sandi — `POST /auth/forgot-password` (sungguhan).
///
/// Tiga hal dari backend yang membentuk layar ini:
///
/// * Server menjawab **sama** untuk email terdaftar maupun tidak (sengaja,
///   supaya tidak membocorkan siapa yang punya akun). Jadi layar sukses
///   menulis "kalau terdaftar", bukan "email terkirim".
/// * Tautan di email mengarah ke `base_url/reset-password?token=…` — halaman
///   web, bukan deep link aplikasi. Karena itu ada jalan "Masukkan kode
///   reset" untuk menempel token dari email secara manual.
/// * Backend development menyertakan `dev_reset_token` di respons (hanya
///   untuk email terdaftar). Di build debug, tombol "Buka tautan reset (dev)"
///   memakainya supaya alurnya bisa diuji tanpa kotak surat.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordResetCubit(),
      child: const _ForgotPasswordBody(),
    );
  }
}

class _ForgotPasswordBody extends StatefulWidget {
  const _ForgotPasswordBody();

  @override
  State<_ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<_ForgotPasswordBody> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    PasswordResetCubit.get(context).requestReset(_email.text);
  }

  void _openReset({String? token}) {
    final uri = Uri(path: AppRoutes.resetPassword, queryParameters: {
      if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
      if (token != null) 'token': token,
    });
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.surface,
      appBar: const XpStackAppBar(title: 'Lupa Kata Sandi'),
      body: BlocBuilder<PasswordResetCubit, PasswordResetState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: state.sentToEmail == null ? _form(state) : _sent(state),
            ),
          );
        },
      ),
    );
  }

  Widget _form(PasswordResetState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _HeaderIcon(icon: Icons.lock_reset),
        const SizedBox(height: 16),
        Text('Atur ulang kata sandi',
            textAlign: TextAlign.center, style: XpText.headingL(context)),
        const SizedBox(height: 8),
        Text(
          'Masukkan email akun Xpedia-mu. Kami kirim tautan untuk membuat kata '
          'sandi baru, berlaku 60 menit.',
          textAlign: TextAlign.center,
          style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 24),
        if (state.error != null) ...[
          AuthErrorBanner(error: state.error!, onRetry: _submit),
          const SizedBox(height: 16),
        ],
        const AuthFieldLabel('Email', isRequired: true),
        const SizedBox(height: 8),
        AuthTextField(
          controller: _email,
          readOnly: state.isSubmitting,
          hintText: 'nama@email.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline,
          textDirection: TextDirection.ltr,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 24),
        AuthSubmitButton(
          onPressed: state.isSubmitting ? null : _submit,
          isLoading: state.isSubmitting,
          label: 'Kirim Tautan Reset',
        ),
        const SizedBox(height: 12),
        TextButton(
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: state.isSubmitting ? null : () => _openReset(),
          child: Text('Sudah punya kode reset?',
              style: XpText.labelL(context).copyWith(color: XpColors.primary)),
        ),
      ],
    );
  }

  Widget _sent(PasswordResetState state) {
    final devToken = state.devResetToken;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderIcon(
          icon: Icons.mark_email_read_outlined,
          color: XpColors.success,
          background: XpColors.successSubtle,
        ),
        const SizedBox(height: 16),
        Text('Cek email kamu', textAlign: TextAlign.center, style: XpText.headingL(context)),
        const SizedBox(height: 8),
        Text(
          'Kalau ${state.sentToEmail} terdaftar di Xpedia, tautan reset sudah '
          'kami kirim. Buka tautannya, atau salin kode reset di dalamnya ke '
          'langkah berikutnya.',
          textAlign: TextAlign.center,
          style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 24),
        if (kDebugMode && devToken != null) ...[
          const XpBanner(
            icon: Icons.developer_mode,
            tone: XpBannerTone.warning,
            title: 'Mode pengembangan',
            message: 'Server dev mengirim kode reset langsung di respons. '
                'Tombol ini tidak ada di build rilis.',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: () => _openReset(token: devToken),
            icon: const Icon(Icons.link),
            label: const Text('Buka tautan reset (dev)'),
          ),
          const SizedBox(height: 12),
        ],
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: () => _openReset(),
          child: const Text('Masukkan Kode Reset'),
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: PasswordResetCubit.get(context).editEmail,
          child: Text('Ganti email',
              style: XpText.labelL(context).copyWith(color: XpColors.primary)),
        ),
        const SizedBox(height: 8),
        // Batas 3× per email per jam, dan email tak terdaftar pun ikut
        // dihitung — lebih baik diberi tahu daripada tiba-tiba ditolak.
        Text(
          'Belum masuk? Periksa folder spam. Permintaan dibatasi 3 kali per '
          'jam untuk setiap email.',
          textAlign: TextAlign.center,
          style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, this.color, this.background});

  final IconData icon;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: background ?? XpColors.primarySubtle,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 32, color: color ?? XpColors.primary),
      ),
    );
  }
}
