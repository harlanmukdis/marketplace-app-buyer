import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/features/shared/models/language_model.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';

/// Pengaturan: tema, bahasa, dan tautan ke Keamanan Akun & Xpedia 911.
///
/// Tema dan bahasa memakai `toggleAppTheme` / `changeAppLanguage` yang sama
/// dengan layar lama — keduanya **memulai ulang app** (`Phoenix.rebirth`),
/// karena seluruh warna dan teks dibaca sinkron dari preferensi saat build.
///
/// Nomor versi app sengaja tidak ditampilkan: tanpa `package_info_plus`
/// angkanya harus ditulis tangan, dan angka yang tertinggal dari `pubspec`
/// lebih menyesatkan daripada tidak ada.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLang = (CachedHelper.getData(kAppLanguage) as String?) ??
        supportedLanguages.firstWhere((l) => l.isDefault, orElse: () => supportedLanguages.first).langCode;
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Pengaturan'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Header('Tampilan'),
          XpCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              secondary: Icon(dark ? Icons.dark_mode : Icons.dark_mode_outlined,
                  color: XpColors.textSecondary),
              title: Text('Mode gelap', style: XpText.titleM(context)),
              subtitle: Text('Aplikasi dimuat ulang saat tema diganti.',
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              value: dark,
              onChanged: (_) => toggleAppTheme(context),
            ),
          ),
          const _Header('Bahasa'),
          XpCard(
            padding: EdgeInsets.zero,
            child: RadioGroup<String>(
              groupValue: currentLang,
              onChanged: (code) {
                if (code != null && code != currentLang) changeAppLanguage(context, code);
              },
              child: Column(children: [
                for (var i = 0; i < supportedLanguages.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: XpColors.borderSubtle),
                  RadioListTile<String>(
                    value: supportedLanguages[i].langCode,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(supportedLanguages[i].langName, style: XpText.bodyM(context)),
                  ),
                ],
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            // Jujur soal cakupannya: bahasa ini hanya mengganti teks bawaan
            // yang diterjemahkan (en/ar); teks layar Xpedia ditulis dalam
            // bahasa Indonesia.
            child: Text(
              'Mengganti teks menu bawaan. Sebagian besar teks Xpedia tetap '
              'berbahasa Indonesia.',
              style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
            ),
          ),
          const _Header('Akun'),
          XpCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              _LinkTile(
                icon: Icons.security,
                title: 'Keamanan Akun',
                subtitle: 'Perangkat, verifikasi KTP, kata sandi',
                onTap: () => context.push(AppRoutes.accountSecurity),
              ),
              Divider(height: 1, color: XpColors.borderSubtle),
              _LinkTile(
                icon: Icons.support_agent,
                title: 'Xpedia 911',
                subtitle: 'Layanan resmi siap 24 jam',
                onTap: () => context.push(AppRoutes.support),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(title.toUpperCase(),
          style: XpText.labelM(context).copyWith(color: XpColors.textSecondary, letterSpacing: 0.8)),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Icon(icon, size: 22, color: XpColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: XpText.titleM(context)),
              Text(subtitle, style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
            ]),
          ),
          const Icon(Icons.chevron_right, size: 20, color: XpColors.textPlaceholder),
        ]),
      ),
    );
  }
}
