import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';

import '../../../../core/function/components.dart';
import '../../../../core/function/custom_app_bar.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../generated/l10n.dart';

/// Ubah profil, tersambung ke `PATCH /me`.
///
/// 🔴 **Sebelumnya tombol Simpan-nya `onPressed: () {}`** — formulirnya juga
/// tidak punya controller sama sekali, jadi layar ini memungut ketikan user
/// lalu membuangnya tanpa jejak. Ia terlihat berfungsi penuh.
///
/// Formulirnya juga dipangkas dari empat field jadi satu, karena tiga sisanya
/// tidak punya endpoint:
///
/// * **Email** — identitas login, dan `PATCH /me` hanya menerima `full_name`
///   dan `avatar_url`. Ditampilkan sebagai teks, bukan kolom isian, supaya
///   tidak menjanjikan sesuatu yang tidak bisa terjadi.
/// * **Alamat** — milik `/me/addresses`, yang punya layarnya sendiri dengan
///   tujuh field dan aturan "alamat utama". Satu kolom teks di sini akan jadi
///   jalan kedua yang tidak setara.
/// * **Kata sandi** — **tidak ada endpoint ganti sandi** di backend ini. Yang
///   ada hanya `forgot-password` → `reset-password` lewat token email. Jadi
///   diganti tautan ke alur itu.
///
/// Foto profil belum bisa diubah: `POST /media/upload` ada, tapi `base_url`
/// backend masih `http://localhost:8080/marketplace-api/` sehingga URL hasil
/// unggahnya salah — dan repo ini belum punya pemilih berkas. Tombol kameranya
/// dihapus daripada dibiarkan mati.
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit()..restoreSession(),
      child: const _EditProfileBody(),
    );
  }
}

class _EditProfileBody extends StatefulWidget {
  const _EditProfileBody();

  @override
  State<_EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<_EditProfileBody> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();

  /// Nama yang sudah dipakai mengisi formulir, supaya pembacaan profil
  /// berikutnya tidak menimpa ketikan user yang belum disimpan.
  String? _prefilled;

  @override
  void dispose() {
    _fullName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final saved = await AuthCubit.get(context)
        .updateProfile(fullName: _fullName.text.trim());
    if (!mounted || !saved) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Profil tersimpan')));
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final dark = isAppDarkMode();
    final labelColor = dark ? kDarkSecondColor : const Color(0xff555555);

    return Scaffold(
      appBar: customAppBar(context, l.editProfile),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthAuthenticated && current.actionError != null,
        listener: (context, state) {
          final error = (state as AuthAuthenticated).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessageFor(context, error))),
            );
          AuthCubit.get(context).clearActionError();
        },
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          final saving = state is AuthAuthenticated && state.isSaving;

          // Diisi sekali saat profil pertama datang. Mengisinya di setiap
          // build akan menghapus ketikan user tiap kali state berubah.
          final name = user?.fullName ?? '';
          if (_prefilled == null && user != null) {
            _prefilled = name;
            _fullName.text = name;
          }

          return SingleChildScrollView(
            padding: 24.psh,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.sbh,
                  Center(
                    child: ClipOval(
                      child: _avatar(user?.avatarUrl),
                    ),
                  ),
                  28.sbh,

                  Text(
                    l.name,
                    style: AppStyles.styleMedium14(context)
                        .copyWith(color: labelColor),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    filled: true,
                    controller: _fullName,
                    readOnly: saving,
                    hintText: l.enterYourName,
                    keyboardType: TextInputType.name,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l.nameRequired
                        : null,
                  ),
                  16.sbh,

                  Text(
                    l.email,
                    style: AppStyles.styleMedium14(context)
                        .copyWith(color: labelColor),
                  ),
                  8.sbh,
                  // Teks, bukan kolom isian: email adalah identitas login dan
                  // `PATCH /me` tidak menerimanya. Kolom yang bisa diketik
                  // tapi tidak pernah tersimpan lebih buruk daripada tidak ada.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsetsDirectional.all(14),
                    decoration: BoxDecoration(
                      color: dark ? kBlackColor : const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user?.email ?? '—',
                      style: AppStyles.styleRegular14(context).copyWith(
                        color: dark ? kDarkThirdColor : kLightThirdColor,
                      ),
                    ),
                  ),
                  6.sbh,
                  Text(
                    'Email tidak bisa diubah.',
                    style: AppStyles.styleRegular11(context).copyWith(
                      color: dark ? kDarkThirdColor : kLightThirdColor,
                    ),
                  ),
                  24.sbh,

                  // Alamat dan kata sandi tidak dikelola di sini; keduanya
                  // dialihkan ke tempat yang memang punya endpointnya.
                  TextButton.icon(
                    onPressed: () => router.push(AppRoutes.forgotPassword),
                    icon: const Icon(Icons.key_outlined, size: 18),
                    label: Text(l.forgetPassword),
                  ),

                  32.sbh,
                  CustomButton(
                    onPressed: saving ? null : _submit,
                    child: saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l.save,
                            style: AppStyles.styleMedium16(context)
                                .copyWith(color: Colors.white),
                          ),
                  ),
                  8.sbh,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _avatar(String? url) {
    const size = 120.0;
    final trimmed = url?.trim() ?? '';
    Widget fallback() => Image.asset(
          AppImages.profileImg,
          fit: BoxFit.cover,
          width: size,
          height: size,
        );

    if (trimmed.isEmpty) return fallback();
    return Image.network(
      trimmed,
      fit: BoxFit.cover,
      width: size,
      height: size,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }
}
