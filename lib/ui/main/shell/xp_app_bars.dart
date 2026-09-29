import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';

/// App bar Xpedia (inventaris desain §2.2).
///
/// Avatar yang menempel di hampir setiap app bar Stitch **sengaja
/// dibuang** — rekomendasi inventaris desain sendiri: tab My Xpedia sudah
/// jadi pintu profil, dan satu target per ikon lebih jelas.

/// Ikon keranjang berlencana, dipakai di semua app bar yang memuatnya.
class CartActionButton extends StatelessWidget {
  const CartActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartBadgeCubit>().state;
    return XpBadgeIcon(
      icon: Icons.shopping_cart_outlined,
      tooltip: 'Keranjang',
      count: count,
      onTap: () async {
        await context.push(AppRoutes.cart);
        if (context.mounted) context.read<CartBadgeCubit>().refresh();
      },
    );
  }
}

/// Ikon Xpedia 911.
class SupportActionButton extends StatelessWidget {
  const SupportActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Xpedia 911',
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      onPressed: () => context.push(AppRoutes.support),
      icon: Icon(Icons.support_agent, size: 24, color: XpColors.textPrimary),
    );
  }
}

/// Varian A — root tab Beranda: logo, kolom cari (tap membuka pencarian),
/// Xpedia 911, keranjang.
class XpHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const XpHomeAppBar({super.key, this.onLogoTap, this.bottom});

  final VoidCallback? onLogoTap;

  /// Baris kedua (strip "Kirim ke …").
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(56 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: XpColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 12,
      shape: Border(bottom: BorderSide(color: XpColors.borderSubtle)),
      title: Row(
        children: [
          XpLogo(onTap: onLogoTap),
          const SizedBox(width: 8),
          Expanded(child: _SearchLauncher(onTap: () => context.push(AppRoutes.search))),
        ],
      ),
      actions: const [SupportActionButton(), CartActionButton(), SizedBox(width: 4)],
      bottom: bottom,
    );
  }
}

class _SearchLauncher extends StatelessWidget {
  const _SearchLauncher({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Cari di Xpedia',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(XpRadius.m),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: XpColors.sunken,
            borderRadius: BorderRadius.circular(XpRadius.m),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: XpColors.textPlaceholder),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Cari di Xpedia...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: XpText.bodyS(context).copyWith(color: XpColors.textPlaceholder),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Varian B/C — root tab selain Beranda: logo sebagai tombol Beranda, judul,
/// lalu aksi.
class XpTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const XpTabAppBar({
    super.key,
    required this.title,
    this.onLogoTap,
    this.actions = const [CartActionButton()],
    this.bottom,
  });

  final String title;
  final VoidCallback? onLogoTap;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(56 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: XpColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 12,
      shape: Border(bottom: BorderSide(color: XpColors.borderSubtle)),
      title: Row(
        children: [
          Semantics(
            button: true,
            label: 'Beranda',
            child: InkWell(
              onTap: onLogoTap,
              borderRadius: BorderRadius.circular(XpRadius.m),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XpColors.primary,
                  borderRadius: BorderRadius.circular(XpRadius.m),
                ),
                child: Text('X',
                    style: XpText.titleL(context)
                        .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: XpText.titleL(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      actions: [...actions, const SizedBox(width: 4)],
      bottom: bottom,
    );
  }
}

/// Varian D — layar tumpuk: tombol kembali 48, judul Title/L, aksi.
class XpStackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const XpStackAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.bottom,
    this.onBack,
  });

  final String title;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => Size.fromHeight(56 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: XpColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      shape: Border(bottom: BorderSide(color: XpColors.borderSubtle)),
      leading: IconButton(
        tooltip: 'Kembali',
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        onPressed: onBack ?? () => context.canPop() ? context.pop() : context.go(AppRoutes.homeLayout),
        icon: Icon(Icons.arrow_back, size: 24, color: XpColors.textPrimary),
      ),
      title: Text(title,
          style: XpText.titleL(context), maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [...actions, const SizedBox(width: 4)],
      bottom: bottom,
    );
  }
}
