import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/widgets/custom_buttons.dart';

/// Bagian-bagian formulir masuk/daftar bergaya Xpedia.
///
/// Dikumpulkan di satu berkas karena hanya dua layar auth yang memakainya,
/// dan keduanya harus tampak sama persis.

/// Label di atas field (Label/L), dengan tanda wajib merah.
class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel(this.text, {super.key, this.isRequired = false});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: XpText.labelL(context),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: XpText.labelL(context).copyWith(color: XpColors.danger),
            ),
        ],
      ),
    );
  }
}

/// Field teks formulir auth: tinggi 48, radius 8, border 1dp, fokus biru.
///
/// Sengaja tetap [TextFormField] — test integrasi mengisi formulir daftar
/// lewat `find.byType(TextFormField)` dengan urutan nama, telepon, email,
/// kata sandi.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.textDirection,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(XpRadius.m),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textDirection: textDirection,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: XpText.bodyL(context),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            XpText.bodyM(context).copyWith(color: XpColors.textPlaceholder),
        filled: true,
        fillColor: readOnly ? XpColors.sunken : XpColors.surface,
        isDense: false,
        constraints: const BoxConstraints(minHeight: 48),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 20, color: XpColors.textTertiary),
        suffixIcon: suffix,
        border: border(XpColors.borderDefault),
        enabledBorder: border(XpColors.borderDefault),
        focusedBorder: border(XpColors.primary, 1.5),
        errorBorder: border(XpColors.danger),
        focusedErrorBorder: border(XpColors.danger, 1.5),
        errorStyle: XpText.bodyS(context).copyWith(color: XpColors.danger),
      ),
    );
  }
}

/// Tombol lihat/sembunyikan kata sandi, area sentuh 48.
class AuthObscureToggle extends StatelessWidget {
  const AuthObscureToggle({
    super.key,
    required this.obscured,
    required this.onPressed,
  });

  final bool obscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: obscured ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: Icon(
        obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
        color: XpColors.textTertiary,
      ),
      onPressed: onPressed,
    );
  }
}

/// Tombol utama formulir: tinggi 52, radius 8, biru Xpedia.
///
/// Tetap [CustomButton] — sebuah `MaterialButton` — karena test integrasi
/// menekannya lewat `find.widgetWithText(MaterialButton, 'Create Account')`.
/// Labelnya harus [Text] biasa selama tidak sedang memuat.
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      height: 52,
      elevation: 0,
      backColor: XpColors.primary,
      borderRadius: BorderRadius.circular(XpRadius.m),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: XpColors.textOnBrand,
              ),
            )
          : Text(
              label,
              style: XpText.titleL(context)
                  .copyWith(color: XpColors.textOnBrand),
            ),
    );
  }
}

/// Wordmark Xpedia di kepala layar auth — tanpa aksi, karena belum ada
/// Beranda yang bisa dituju sebelum masuk.
class AuthBrandMark extends StatelessWidget {
  const AuthBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    // Ukuran lebih besar daripada [XpLogo] di app bar (Heading/L); bobot
    // 800 mengikuti wordmark di desain Stitch.
    return Semantics(
      header: true,
      child: Text(
        'Xpedia',
        style: XpText.headingXl(context).copyWith(
          fontSize: 34,
          height: 1.2,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: XpColors.primary,
        ),
      ),
    );
  }
}
