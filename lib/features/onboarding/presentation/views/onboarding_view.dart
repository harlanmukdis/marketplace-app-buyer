import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/utils/app_routes.dart';

/// Tiga halaman perkenalan sebelum masuk/daftar.
///
/// Gambar UI kit (`AppImages.onboarding*`) hanya placeholder abu-abu, jadi
/// diganti ikon dalam lingkaran berwarna merek. Salinannya sengaja **hanya
/// menyebut fitur yang benar-benar ada** di aplikasi ini (chip stok, status
/// penjual, PIN penarikan, lacak paket, chat, Xpedia 911) — tanpa angka
/// jumlah toko/pengguna, karena tidak ada sumber datanya.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _Page {
  const _Page(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

const _pages = [
  _Page(
    Icons.storefront_outlined,
    'Semua kebutuhan, satu aplikasi',
    'Temukan produk dari beragam toko, lengkap dengan status stok dan status '
        'penjual yang jelas sebelum kamu membeli.',
  ),
  _Page(
    Icons.verified_user_outlined,
    'Transaksi yang aman',
    'Bayar dengan tenang lewat Xpedia. Penarikan saldo Xpedia Wallet selalu '
        'dilindungi PIN 6 digit.',
  ),
  _Page(
    Icons.local_shipping_outlined,
    'Pesanan terpantau',
    'Lacak paket, chat langsung dengan penjual, dan hubungi Xpedia 911 kapan '
        'pun kamu butuh bantuan.',
  ),
];

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  bool get _isLast => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      router.go(AppRoutes.welcome);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const XpLogo(),
                  const Spacer(),
                  if (!_isLast)
                    TextButton(
                      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                      onPressed: () => router.go(AppRoutes.welcome),
                      child: Text('Lewati',
                          style: XpText.labelL(context).copyWith(color: XpColors.textSecondary)),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _OnboardingPage(page: _pages[index]),
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: _currentPage,
              count: _pages.length,
              onDotClicked: (index) => _controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              ),
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
                spacing: 6,
                activeDotColor: XpColors.primary,
                dotColor: XpColors.borderDefault,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: _next,
                child: Text(_isLast ? 'Mulai Belanja' : 'Lanjut'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page});

  final _Page page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          SizedBox(height: context.screenHeight * .06),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(color: XpColors.primarySubtle, shape: BoxShape.circle),
            child: Icon(page.icon, size: 72, color: XpColors.primary),
          ),
          const SizedBox(height: 40),
          Text(page.title, textAlign: TextAlign.center, style: XpText.headingXl(context)),
          const SizedBox(height: 12),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: XpText.bodyL(context).copyWith(color: XpColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
