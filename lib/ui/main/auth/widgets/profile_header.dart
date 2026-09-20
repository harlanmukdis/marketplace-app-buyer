import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_images.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';

/// Kepala layar profil: foto, nama, email, dan lencana terverifikasi.
///
/// Dulu ketiganya **ditulis langsung di kode** — nama `Mahmodul Hasan`, email
/// `info.mamodul@gmail.com`, dan lencana terverifikasi yang tampil tanpa
/// syarat. Artinya siapa pun yang masuk melihat identitas orang lain, lengkap
/// dengan centang yang tidak ada hubungannya dengan status akunnya.
///
/// Datanya diambil dari `AuthCubit`, bukan dari panggilan baru: `GET /me`
/// sudah ditembak saat sesi dipulihkan dan hasilnya tersimpan di
/// [AuthAuthenticated]. Menembaknya lagi di sini hanya akan menduplikasi
/// permintaan untuk data yang sudah ada.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.onEdit});

  /// Dipanggil saat ikon pensil ditekan.
  ///
  /// Diserahkan ke pemanggil alih-alih menavigasi sendiri, supaya layar
  /// pemanggil bisa **membaca ulang profil saat kembali** — layar ubah profil
  /// punya `AuthCubit` sendiri, jadi perubahannya tidak otomatis sampai ke
  /// instance milik layar ini.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return _Header(user: user, onEdit: onEdit);
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user, this.onEdit});

  final VoidCallback? onEdit;

  /// `null` selagi profil belum termuat **atau** saat `GET /me` gagal — sesi
  /// tetap sah dalam kedua kasus itu.
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Column(
      children: [
        16.sbh,
        SafeArea(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _Avatar(url: user?.avatarUrl),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onEdit,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF6F8FA),
                        shape: OvalBorder(),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        20.sbh,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                // Tanpa nama, lebih baik diam daripada menebak: "Pembeli"
                // jauh lebih jujur daripada nama contoh milik orang lain.
                (user?.fullName ?? '').trim().isEmpty
                    ? 'Pembeli'
                    : user!.fullName!.trim(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.styleSemiBold18(context).copyWith(
                  color: dark ? kDarkSecondColor : const Color(0xff2b2b2b),
                ),
              ),
            ),
            // ⚠️ Lencana hanya muncul kalau akunnya memang terverifikasi.
            // `UserModel.isVerified` membaca `status`, BUKAN `email_verified`
            // — kolom itu tidak pernah berubah jadi `1` di backend ini, jadi
            // memakainya membuat lencana tidak pernah tampil sama sekali.
            if (user?.isVerified ?? false) ...[
              8.sbw,
              SvgPicture.asset(AppImages.verified),
            ],
          ],
        ),
        6.sbh,
        Text(
          user?.email ?? '—',
          style: AppStyles.styleRegular14(context).copyWith(
            color: dark ? const Color(0xffD0D0D0) : const Color(0xff999999),
          ),
        ),
        24.sbh,
      ],
    );
  }
}

/// Foto profil, dengan aset bawaan sebagai jaring pengaman.
///
/// `avatar_url` `null` untuk akun yang baru mendaftar, dan akun seed
/// menunjuk ke host luar yang bisa saja tidak terjangkau. Keduanya tidak boleh
/// meninggalkan lubang di layar — `errorBuilder` menangkap kegagalan muat yang
/// tidak bisa dicegah dengan memeriksa `null` saja.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  static const double _size = 120;

  @override
  Widget build(BuildContext context) {
    final trimmed = url?.trim() ?? '';

    return ClipOval(
      child: trimmed.isEmpty
          ? _fallback()
          : Image.network(
              trimmed,
              fit: BoxFit.cover,
              width: _size,
              height: _size,
              errorBuilder: (_, __, ___) => _fallback(),
            ),
    );
  }

  Widget _fallback() => Image.asset(
        AppImages.profileImg,
        fit: BoxFit.cover,
        width: _size,
        height: _size,
      );
}
