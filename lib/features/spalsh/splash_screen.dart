import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';

import '../../core/utils/app_routes.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // `restoreSession()` dipanggil di sini, bukan setelah animasi selesai,
    // supaya validasi token berjalan bersamaan dengan 2 detik splash —
    // keduanya tidak dijumlahkan.
    return BlocProvider(
      create: (_) => AuthCubit()..restoreSession(),
      child: const _SplashBody(),
    );
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody>
    with SingleTickerProviderStateMixin {
  Timer? _minimumDisplay;
  bool _minimumDisplayElapsed = false;
  bool _navigated = false;

  late final AnimationController _intro;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Satu controller cukup: wordmark muncul memudar sambil sedikit
    // membesar, lalu diam. Versi UI kit memakai tiga controller dan dua SVG
    // placeholder (logo kit "Shopapay"), yang bukan merek Xpedia.
    _intro = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _fade = CurvedAnimation(parent: _intro, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _intro, curve: Curves.easeOutBack),
    );

    // Navigate to onboarding screen after a delay
    _minimumDisplay = Timer(const Duration(seconds: 2), () {
      _minimumDisplayElapsed = true;
      _navigateIfReady();
    });
  }

  /// Berpindah hanya kalau animasi sudah selesai **dan** status sesi sudah
  /// pasti. Dipanggil dari dua arah (timer dan listener); mana pun yang
  /// selesai terakhir yang benar-benar menavigasi, dan [_navigated] menjaga
  /// agar tidak terjadi dua kali.
  void _navigateIfReady() {
    if (_navigated || !mounted || !_minimumDisplayElapsed) return;

    // State dibaca langsung dari cubit, BUKAN dari salinan yang diisi
    // listener.
    //
    // `BlocListener` hanya bereaksi pada perubahan SETELAH ia berlangganan,
    // dan tidak memutar ulang state yang sudah ada. `restoreSession()` pada
    // kasus "belum pernah login" memanggil `emit(unauthenticated)` secara
    // sinkron di dalam `BlocProvider.create` — jadi emit itu terjadi sebelum
    // listener terpasang, listener tidak pernah menerimanya, dan splash macet
    // selamanya di `initial()`. Membaca state hidup membuat urutan pemasangan
    // listener tidak lagi berpengaruh.
    final destination = switch (context.read<AuthCubit>().state) {
      AuthAuthenticated() => AppRoutes.homeLayout,

      // Sesi berakhir atau dicabut: langsung ke login, bukan mengulang
      // onboarding — user ini sudah pernah punya akun.
      AuthUnauthenticated(:final error) when error != null => AppRoutes.login,

      AuthUnauthenticated() => AppRoutes.onboarding,

      // Masih initial/loading — tunggu emit berikutnya.
      _ => null,
    };

    if (destination == null) return;

    _navigated = true;
    router.go(destination);
  }

  @override
  void dispose() {
    _minimumDisplay?.cancel();
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      // Listener hanya dipakai sebagai pemicu ulang; tujuannya dihitung dari
      // state hidup di `_navigateIfReady()`.
      listener: (context, state) => _navigateIfReady(),
      child: _buildSplash(context),
    );
  }

  Widget _buildSplash(BuildContext context) {
    // Latar biru merek dengan wordmark putih — sama di mode gelap, karena
    // splash adalah momen merek, bukan permukaan konten.
    return Scaffold(
      backgroundColor: XpColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  children: [
                    Text(
                      'Xpedia',
                      style: XpText.headingXl(context).copyWith(
                        fontSize: 44,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belanja aman, cepat, dan terpercaya',
                      style: XpText.bodyM(context).copyWith(color: const Color(0xffE1E8FD)),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
