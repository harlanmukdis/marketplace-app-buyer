import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/identity_verification_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/identity_status_pill.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Tab My Xpedia (inventaris desain §3.20): identitas akun, Xpedia Wallet,
/// menu akun, Xpedia 911, dan keluar.
///
/// Yang **sengaja tidak** ditampilkan dari desain, karena tidak ada datanya:
/// pil tingkat member di kartu identitas (butuh lima permintaan reward hanya
/// untuk satu label — tingkatnya ada di layar Poin & Reward), grid jumlah
/// pesanan per status (`GET /orders` mengabaikan `?status=` dan tidak
/// mengirim total), jumlah wishlist/ulasan/voucher di subjudul menu, pil
/// "Online" Xpedia 911, "Biometrik" di kartu dompet, dan nomor versi app.
/// Menulis angka contoh desain di tempat-tempat itu berarti berbohong ke user.
///
/// ⚠️ Layar ini **tidak boleh memakai `SvgPicture`**: test app sungguhan
/// (`integration_test/member_journey_test.dart`) memastikan lencana
/// terverifikasi tidak tampil untuk akun `pending_verification` dengan
/// mencari `SvgPicture` di tab ini — lencana SVG lama tampil tanpa syarat.
class MyXpediaScreen extends StatelessWidget {
  const MyXpediaScreen({super.key, this.onLogoTap});

  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    // `AuthCubit` disediakan per layar di repo ini. Profilnya dibaca dari
    // `restoreSession` (satu `GET /me`), bukan ditulis di kode — kepala
    // profil UI kit dulu menampilkan identitas orang lain.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..restoreSession()),
        BlocProvider(create: (_) => WalletCubit()..load()),
        // Pil status KTP (kontrak usulan, mock di debug). Endpoint yang belum
        // ada → `unavailable` → pilnya tidak digambar sama sekali.
        BlocProvider(create: (_) => IdentityVerificationCubit()..load()),
      ],
      child: _MyXpediaBody(onLogoTap: onLogoTap),
    );
  }
}

class _MyXpediaBody extends StatelessWidget {
  const _MyXpediaBody({this.onLogoTap});

  final VoidCallback? onLogoTap;

  /// Membuka layar lain lalu memuat ulang profil + dompet saat kembali.
  ///
  /// Tab ini hidup terus di `IndexedStack` cangkang, dan layar tujuannya
  /// punya cubit sendiri — perubahan di sana (nama baru, top up, rekening
  /// baru) tidak otomatis sampai ke instance milik tab ini.
  Future<void> _open(BuildContext context, String location,
      {bool reloadProfile = false, bool reloadWallet = false}) async {
    final auth = AuthCubit.get(context);
    final wallet = WalletCubit.get(context);
    final identity = IdentityVerificationCubit.get(context);
    await context.push(location);
    if (reloadProfile) await Future.wait([auth.restoreSession(), identity.load()]);
    if (reloadWallet) await wallet.load();
  }

  Future<void> _refresh(BuildContext context) async {
    final auth = AuthCubit.get(context);
    final wallet = WalletCubit.get(context);
    final identity = IdentityVerificationCubit.get(context);
    await Future.wait([auth.restoreSession(), wallet.load(), identity.load()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: XpTabAppBar(
        title: 'My Xpedia',
        onLogoTap: onLogoTap,
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => context.push(AppRoutes.notifications),
            icon: Icon(Icons.notifications_none, size: 24, color: XpColors.textPrimary),
          ),
          const CartActionButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _IdentityCard(
              onEdit: () => _open(context, AppRoutes.editProfile, reloadProfile: true),
            ),
            const SizedBox(height: 16),
            _WalletCard(
              onOpenWallet: () => _open(context, AppRoutes.wallet, reloadWallet: true),
            ),
            const _GroupHeader('Pesanan & Belanja'),
            _MenuGroup(rows: [
              _MenuRow(
                icon: Icons.location_on_outlined,
                title: 'Alamat Tersimpan',
                subtitle: 'Maks. 3 alamat pengiriman',
                tinted: true,
                onTap: () => context.push(AppRoutes.addresses),
              ),
              _MenuRow(
                icon: Icons.storefront_outlined,
                title: 'Toko Diikuti',
                subtitle: 'Toko yang kamu ikuti',
                tinted: true,
                onTap: () => context.push(AppRoutes.followedStores),
              ),
              _MenuRow(
                icon: Icons.stars_outlined,
                title: 'Poin & Reward',
                subtitle: 'Poin, koin, dan tingkat member',
                tinted: true,
                onTap: () => context.push(AppRoutes.reward),
              ),
              // Subjudul tanpa angka: tidak ada endpoint jumlah ulasan/voucher,
              // dan desain "5 ulasan produk diberikan" hanya contoh.
              _MenuRow(
                icon: Icons.star_outline,
                title: 'Ulasan Saya',
                subtitle: 'Ulasan untuk pesanan yang selesai',
                tinted: true,
                onTap: () => context.push(AppRoutes.myReviews),
              ),
              _MenuRow(
                icon: Icons.confirmation_number_outlined,
                title: 'Voucher Saya',
                subtitle: 'Voucher yang sudah kamu klaim',
                tinted: true,
                onTap: () => context.push(AppRoutes.vouchers),
              ),
            ]),
            const _GroupHeader('Akun & Keamanan'),
            BlocBuilder<WalletCubit, WalletState>(
              builder: (context, walletState) => _MenuGroup(rows: [
                _MenuRow(
                  icon: Icons.manage_accounts_outlined,
                  title: 'Ubah Profil',
                  subtitle: 'Nama tampilan akun',
                  onTap: () => _open(context, AppRoutes.editProfile, reloadProfile: true),
                ),
                _MenuRow(
                  icon: Icons.security,
                  title: 'Keamanan Akun',
                  subtitle: 'Perangkat aktif, verifikasi KTP, kata sandi',
                  onTap: () => _open(context, AppRoutes.accountSecurity, reloadProfile: true),
                ),
                _MenuRow(
                  icon: Icons.pin_outlined,
                  title: 'PIN Xpedia Wallet',
                  // Server tidak bisa ditanya apakah PIN sudah ada, jadi
                  // subjudulnya tidak mengklaim "PIN aktif".
                  subtitle: 'PIN untuk pembayaran dan penarikan',
                  onTap: () => context.push(AppRoutes.withdrawalPin),
                ),
                _MenuRow(
                  icon: Icons.account_balance_outlined,
                  title: 'Rekening Bank',
                  subtitle: switch (walletState) {
                    WalletReady(:final bankAccounts, bankAccountsError: null) =>
                      '${bankAccounts.length} dari ${BankAccountModel.maxAccounts} '
                          'rekening tersimpan',
                    _ => 'Rekening tujuan penarikan saldo',
                  },
                  onTap: () => _open(context, AppRoutes.bankAccounts, reloadWallet: true),
                ),
                _MenuRow(
                  icon: Icons.settings_outlined,
                  title: 'Pengaturan',
                  subtitle: 'Bahasa dan tema tampilan',
                  onTap: () => context.push(AppRoutes.settings),
                ),
              ]),
            ),
            const SizedBox(height: 24),
            const _SupportCard(),
            const SizedBox(height: 24),
            const _LogoutButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Kartu identitas: avatar, nama, email, status verifikasi.
class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return XpCard(
          child: switch (state) {
            AuthAuthenticated(:final user) => _identity(context, user),
            AuthUnauthenticated() => _signedOut(context),
            _ => const SizedBox(
                height: 64, child: Center(child: CircularProgressIndicator())),
          },
        );
      },
    );
  }

  Widget _signedOut(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Sesi berakhir. Masuk lagi untuk melihat akunmu.',
              style: XpText.bodyM(context)),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () => router.go(AppRoutes.login),
          child: const Text('Masuk'),
        ),
      ],
    );
  }

  /// [user] `null` berarti sesi sah tapi `GET /me` gagal — ditampilkan
  /// netral, tanpa nama contoh dan tanpa lencana.
  Widget _identity(BuildContext context, UserModel? user) {
    final name = (user?.fullName ?? '').trim();
    // ⚠️ `isVerified` membaca `status`, BUKAN `email_verified` — kolom itu
    // tidak pernah berubah jadi `1` di backend ini.
    final verified = user?.isVerified ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            XpInitialAvatar(
              name: name.isEmpty ? (user?.email ?? '') : name,
              imageUrl: user?.avatarUrl?.trim(),
              size: 56,
            ),
            if (verified)
              PositionedDirectional(
                end: -2,
                bottom: -2,
                child: Container(
                  decoration: BoxDecoration(color: XpColors.surface, shape: BoxShape.circle),
                  child: Icon(Icons.verified, size: 20, color: XpColors.primary),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Tanpa nama, "Pembeli" jauh lebih jujur daripada menebak.
                name.isEmpty ? 'Pembeli' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: XpText.titleL(context).copyWith(fontWeight: FontWeight.w700),
              ),
              if (user?.email != null)
                Text(
                  user!.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                ),
              if (user?.createdAt != null)
                Text(
                  'Member sejak ${formatServerDate(user!.createdAt)}',
                  style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                ),
              const SizedBox(height: 6),
              // Diperkecil alih-alih meluap di layar sempit / teks besar.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: verified
                    ? XpPill(
                        label: 'Terverifikasi',
                        icon: Icons.verified,
                        tone: XpTone(XpColors.primarySubtle, XpColors.primary),
                      )
                    : (user?.needsEmailVerification ?? false)
                        ? const XpPill(
                            label: 'Email belum diverifikasi',
                            icon: Icons.mark_email_unread_outlined,
                            tone: XpStockTones.low,
                          )
                        : const SizedBox.shrink(),
              ),
              const _IdentityPill(),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: XpColors.sunken,
              foregroundColor: XpColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(48, 48),
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            onPressed: user == null ? null : onEdit,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Ubah'),
          ),
        ),
      ],
    );
  }
}

/// Kartu Xpedia Wallet navy (inventaris desain §2.4).
class _WalletCard extends StatelessWidget {
  const _WalletCard({required this.onOpenWallet});

  final VoidCallback onOpenWallet;

  static const _onNavyMuted = Color(0xffE1E8FD);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: XpColors.navy,
        borderRadius: BorderRadius.circular(XpRadius.l),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          final balance = switch (state) {
            WalletReady(:final wallet) => Text(
                formatRupiah(wallet.availableBalance),
                style: XpText.headingXl(context).copyWith(color: Colors.white),
              ),
            WalletLoading() => Text('Memuat saldo…',
                style: XpText.bodyM(context).copyWith(color: _onNavyMuted)),
            WalletError() => InkWell(
                onTap: () => WalletCubit.get(context).load(),
                child: Text('Saldo belum bisa dimuat · Coba lagi',
                    style: XpText.bodyM(context).copyWith(color: _onNavyMuted)),
              ),
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_balance_wallet_outlined,
                                size: 18, color: _onNavyMuted),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text('XPEDIA WALLET',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: XpText.labelM(context)
                                      .copyWith(color: _onNavyMuted, letterSpacing: 0.8)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        balance,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: XpColors.navy,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      onPressed: onOpenWallet,
                      icon: Icon(Icons.add_circle, size: 18, color: XpColors.primary),
                      label: const Text('Top Up'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.white12),
              InkWell(
                onTap: onOpenWallet,
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      const Icon(Icons.lock, size: 14, color: Color(0xff34D399)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text('Pembayaran & penarikan dilindungi PIN 6-digit',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: XpText.caption(context).copyWith(color: _onNavyMuted)),
                      ),
                      Text('Riwayat Transaksi',
                          style: XpText.labelM(context).copyWith(color: Colors.white)),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: XpText.labelM(context)
            .copyWith(color: XpColors.textSecondary, letterSpacing: 0.8),
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: XpColors.borderSubtle),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.tinted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// Ubin ikon biru (grup belanja) vs abu-abu (grup akun), seperti desain.
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tinted ? XpColors.primarySubtle : XpColors.sunken,
                borderRadius: BorderRadius.circular(XpRadius.m),
              ),
              child: Icon(icon,
                  size: 20, color: tinted ? XpColors.primary : XpColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: XpText.titleM(context)),
                  Text(subtitle,
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: XpColors.textPlaceholder),
          ],
        ),
      ),
    );
  }
}

/// Kartu Xpedia 911 — satu-satunya merek layanan pelanggan. Subjudul desain
/// ("Pusat Bantuan Resmi…") memakai kata terlarang design_buyer.md §5, jadi
/// ditulis ulang.
class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [XpColors.primarySubtle, XpColors.surface]),
        borderRadius: BorderRadius.circular(XpRadius.l),
        border: Border.all(color: XpColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: XpColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.support_agent, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xpedia 911',
                  style: XpText.headingM(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: isAppDarkMode() ? XpColors.textPrimary : XpColors.navy,
                  ),
                ),
                Text('Layanan resmi siap 24 jam',
                    style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: FilledButton(
              onPressed: () => context.push(AppRoutes.support),
              child: const Text('Hubungi'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: XpColors.dangerSubtle,
          foregroundColor: XpColors.danger,
        ),
        // Cubit-nya diambil dari context INI, bukan dari context dialog:
        // dialog hidup di route terpisah, di luar `BlocProvider` layar ini.
        onPressed: () => _confirmLogout(context, AuthCubit.get(context)),
        icon: const Icon(Icons.logout),
        label: const Text('Keluar dari Akun'),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthCubit auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu masuk lagi untuk berbelanja.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: XpColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    // 🔴 Token WAJIB dihapus lebih dulu. Versi UI kit hanya `router.go(login)`
    // — sesinya tetap hidup dan app memulihkannya saat dibuka berikutnya,
    // jadi "keluar" tidak mengeluarkan siapa pun.
    await auth.logout();
    router.go(AppRoutes.login);
  }
}

/// Pil status KTP di kartu identitas, dari kontrak usulan
/// `GET /me/identity-verification`. Tidak menggambar apa pun selama memuat,
/// saat endpoint-nya belum ada, atau saat gagal — pil sampingan tidak layak
/// jadi pesan error di kartu identitas.
class _IdentityPill extends StatelessWidget {
  const _IdentityPill();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
      builder: (context, state) {
        if (state is! IdentityVerificationReady) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              IdentityStatusPill(status: state.verification.statusValue),
              SimulatedBadge(meta: state.meta),
            ],
          ),
        );
      },
    );
  }
}
