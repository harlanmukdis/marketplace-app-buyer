import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';

import '../../../../core/function/components.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../ui/main/auth/widgets/profile_header.dart';
import '../../../../generated/l10n.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // `AuthCubit` di repo ini disediakan **per layar**, bukan global (lihat
    // splash/login/register). Providernya ditaruh di sini, bukan di dalam
    // `ProfileHeader`, supaya kepala profil dan tombol "ubah profil" berbagi
    // satu instance — kalau tidak, profil yang baru disimpan tidak akan
    // terlihat sampai tab ini dibuka ulang.
    return BlocProvider(
      create: (_) => AuthCubit()..restoreSession(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 24.psh,
      child: Column(
        children: [
          // Nama, email, foto, dan lencana dulu ditulis langsung di sini —
          // `Mahmodul Hasan` / `info.mamodul@gmail.com` dari UI kit. Sekarang
          // dibaca dari sesi; lihat `ProfileHeader`.
          ProfileHeader(onEdit: () => _openEditProfile(context)),
          const GeneralWidgets(),
        ],
      ),
    );
  }
}

/// Membuka layar ubah profil, lalu **membaca ulang** profilnya saat kembali.
///
/// Layar itu punya `AuthCubit` sendiri (tiap rute begitu di repo ini), jadi
/// perubahan yang tersimpan di sana tidak otomatis sampai ke instance milik
/// layar ini.
Future<void> _openEditProfile(BuildContext context) async {
  final cubit = AuthCubit.get(context);
  await context.push(AppRoutes.editProfile);
  if (context.mounted) await cubit.restoreSession();
}

class GeneralWidgets extends StatelessWidget {
  const GeneralWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.general, style: AppStyles.styleMedium16(context)),
        10.sbh,
        // Judulnya ditulis langsung karena kunci l10n-nya belum ada — dan
        // seluruh layar tujuannya memang berbahasa Indonesia.
        _customListTile(
          context,
          title: 'Pesanan Saya',
          icon: Icons.receipt_long_outlined,
          onTap: () => router.push(AppRoutes.orders),
        ),
        _customListTile(
          context,
          title: 'Saldo Saya',
          icon: Icons.account_balance_wallet_outlined,
          onTap: () => router.push(AppRoutes.wallet),
        ),
        _customListTile(
          context,
          title: 'Poin & Reward',
          icon: Icons.stars_outlined,
          onTap: () => router.push(AppRoutes.reward),
        ),
        _customListTile(
          context,
          title: l.profileInformation,
          icon: Icons.person_outline,
          onTap: () => _openEditProfile(context),
        ),
        _customListTile(
          context,
          title: 'Chat',
          icon: Icons.chat_bubble_outline,
          onTap: () => router.push(AppRoutes.chatList),
        ),
        _customListTile(
          context,
          title: l.notifications,
          icon: Icons.notifications_none_outlined,
          onTap: () => router.push(AppRoutes.notifications),
        ),
        // _customListTile(context,
        //     title: l.myFavorites, icon: Icons.favorite_border_outlined),
        _customListTile(
          context,
          title: l.forgetPassword,
          icon: Icons.key_outlined,
          onTap: () => router.push(AppRoutes.forgotPassword),
        ),
        _customListTile(
          context,
          title: l.paymentMethods,
          icon: Icons.payment_outlined,
          onTap: () => router.push(AppRoutes.paymentMethods),
        ),
        _customListTile(
          context,
          title: l.settings,
          icon: Icons.settings_outlined,
          onTap: () => router.push(AppRoutes.settings),
        ),
        _customListTile(
          context,
          title: l.aboutShopapay,
          icon: Icons.info_outline,
          onTap: () => router.push(AppRoutes.aboutApp),
        ),
        16.sbh,
        Text(
          l.homeSearch,
          style: AppStyles.styleMedium16(context).copyWith(
              color: isAppDarkMode() ? kDarkSecondColor : kLightSecondColor),
        ),
        8.sbh,
        _customListTile(context,
            title: l.rateUs, icon: Icons.star_border_outlined),
        _customListTile(
          context,
          title: l.helpCenter,
          icon: Icons.help_outline,
          onTap: () => router.push(AppRoutes.helpCenter),
        ),
        _customListTile(
          context,
          title: l.logOut,
          icon: Icons.logout_outlined,
          // Cubit-nya diambil dari context INI, bukan dari context dialog:
          // dialog hidup di route terpisah, sehingga bukan keturunan
          // `BlocProvider` milik layar ini dan `AuthCubit.get` di dalamnya
          // akan melempar `ProviderNotFoundException`.
          onTap: () => _confirmLogout(context, AuthCubit.get(context), l),
        ),
        8.sbh,
      ],
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    AuthCubit auth,
    S l,
  ) {
    return showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              contentPadding: 32.pa,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l.areYouSureYouWantToLogOut,
                    textAlign: TextAlign.center,
                    style: AppStyles.styleSemiBold18(context),
                  ),
                  30.sbh,
                  CustomButton(
                    child: Text(
                      l.cancel,
                      style: AppStyles.styleMedium14(context)
                          .copyWith(color: kWhiteColor),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  16.sbh,
                  TextButton(
                    child: Text(
                      l.logOut,
                      style: AppStyles.styleSemiBold14(context)
                          .copyWith(color: const Color(0xffD32F2F)),
                    ),
                    onPressed: () async {
                      // 🔴 Dulu hanya `router.go(login)` — tokennya **tidak
                      // pernah dihapus**, jadi sesinya tetap hidup dan app
                      // memulihkannya lagi saat dibuka berikutnya. Di
                      // perangkat bersama itu berarti "keluar" tidak
                      // mengeluarkan siapa pun.
                      Navigator.of(context).pop();
                      await auth.logout();
                      router.go(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _customListTile(BuildContext context,
      {required String title, required IconData icon, void Function()? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      onTap: onTap ?? () {},
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffDAE8FF),
        ),
        child: Icon(
          icon,
          color: isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppStyles.styleMedium14(context).copyWith(
            color: isAppDarkMode() ? kDarkThirdColor : const Color(0xff555555)),
      ),
      trailing: Icon(
        isLanguageRTL()
            ? Icons.keyboard_arrow_left_outlined
            : Icons.keyboard_arrow_right_outlined,
        color: isAppDarkMode() ? kDarkSecondColor : kLightThirdColor,
      ),
    );
  }
}
