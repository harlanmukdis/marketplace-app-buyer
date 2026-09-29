import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/ui/main/catalog/screens/catalog_home_screen.dart';
import 'package:marketplace_app_member/ui/main/chat/screens/chat_list_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/my_xpedia_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_list_screen.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';
import 'package:marketplace_app_member/ui/main/wishlist/screens/wishlist_screen.dart';

/// Cangkang navigasi bawah Xpedia.
///
/// **Tepat lima tab**: Beranda, Wishlist, Pesanan Saya, Chat, My Xpedia
/// (design_buyer.md §4). Keranjang **bukan** tab — ia ikon berlencana di app
/// bar. Tab "Trending" milik UI kit dibuang: isinya produk hardcoded.
///
/// Tab dibangun **malas**: baru dibuat saat pertama dibuka, lalu dipertahankan
/// di [IndexedStack] supaya posisi gulir dan data tidak hilang saat berpindah.
/// Membangun kelimanya sekaligus berarti lima layar menembak API bersamaan di
/// setiap pembukaan app.
///
/// Nama kelas dan rute `homeLayout` dipertahankan supaya splash, login, dan
/// test yang menuju ke sini tidak ikut berubah.
class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _index = 0;
  final Set<int> _visited = {0};

  static const _tabs = <({IconData icon, IconData active, String label})>[
    (icon: Icons.home_outlined, active: Icons.home, label: 'Beranda'),
    (icon: Icons.favorite_border, active: Icons.favorite, label: 'Wishlist'),
    (icon: Icons.inventory_2_outlined, active: Icons.inventory_2, label: 'Pesanan Saya'),
    (icon: Icons.chat_bubble_outline, active: Icons.chat_bubble, label: 'Chat'),
    (icon: Icons.person_outline, active: Icons.person, label: 'My Xpedia'),
  ];

  @override
  void initState() {
    super.initState();
    // Cubit tingkat-app hidup lebih lama dari sesi login; setiap kali cangkang
    // dibuka (sesudah login) datanya dimuat ulang untuk akun yang aktif.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WishlistCubit>().load();
      context.read<CartBadgeCubit>().refresh();
    });
  }

  void _select(int index) {
    setState(() {
      _index = index;
      _visited.add(index);
    });
    if (index == 0) context.read<CartBadgeCubit>().refresh();
  }

  void _goHome() => _select(0);

  Widget _buildTab(int index) => switch (index) {
        0 => CatalogHomeScreen(onLogoTap: _goHome),
        1 => WishlistScreen(onLogoTap: _goHome),
        2 => OrderListScreen(onLogoTap: _goHome),
        3 => ChatListScreen(onLogoTap: _goHome),
        _ => MyXpediaScreen(onLogoTap: _goHome),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            _visited.contains(i) ? _buildTab(i) : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: _XpBottomNav(
        index: _index,
        tabs: _tabs,
        onSelect: _select,
      ),
    );
  }
}

class _XpBottomNav extends StatelessWidget {
  const _XpBottomNav({required this.index, required this.tabs, required this.onSelect});

  final int index;
  final List<({IconData icon, IconData active, String label})> tabs;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: XpColors.surface,
        border: Border(top: BorderSide(color: XpColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: _NavItem(
                    tab: tabs[i],
                    selected: i == index,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.tab, required this.selected, required this.onTap});

  final ({IconData icon, IconData active, String label}) tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? XpColors.primary : XpColors.textTertiary;
    return Semantics(
      selected: selected,
      button: true,
      label: tab.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? tab.active : tab.icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              tab.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: XpText.labelS(context).copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
