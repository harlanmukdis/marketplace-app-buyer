import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/auth/widgets/auth_field_label.dart';

import '../../../../core/utils/app_routes.dart';

/// Gerbang sesudah onboarding: Masuk atau Daftar.
///
/// Tiga tombol login sosial UI kit (Google/Facebook/Apple) **dibuang**:
/// backend tidak punya OAuth sama sekali, dan tombol yang tidak melakukan
/// apa-apa lebih buruk daripada tidak ada tombol — keputusan yang sama
/// dengan layar login.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.screenHeight * .85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: context.screenHeight * .12),
                const Center(child: AuthBrandMark()),
                const SizedBox(height: 32),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration:
                        BoxDecoration(color: XpColors.primarySubtle, shape: BoxShape.circle),
                    child: Icon(Icons.shopping_bag_outlined, size: 56, color: XpColors.primary),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Selamat datang di Xpedia',
                    textAlign: TextAlign.center, style: XpText.headingXl(context)),
                const SizedBox(height: 8),
                Text(
                  'Masuk untuk melanjutkan belanja, atau buat akun baru dalam '
                  'beberapa langkah.',
                  textAlign: TextAlign.center,
                  style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
                ),
                const SizedBox(height: 40),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => router.push(AppRoutes.login),
                  child: const Text('Masuk'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => router.push(AppRoutes.register),
                  child: const Text('Daftar Akun Baru'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 14, color: XpColors.textTertiary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Data akunmu dijaga Xpedia',
                        style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
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
  }
}
