import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constant.dart';

// Tema mengikuti design system Xpedia (design_buyer.md). Widget di app ini
// hampir tidak pernah membaca `Theme.of(context)`, jadi yang dikerjakan tema
// di sini terutama tema KOMPONEN: `FilledButton`, `OutlinedButton`, input,
// chip, dan bottom sheet yang sudah dipakai layar-layar ber-API langsung
// mendapat bentuk desainnya tanpa disentuh satu per satu.
//
// Warna ditulis literal (bukan lewat XpColors) karena kedua tema dibangun
// sebagai variabel top-level — keduanya harus tetap benar walau preferensi
// tema berubah sesudahnya.

/// Light Theme
final ThemeData lightTheme = _buildTheme(
  brightness: Brightness.light,
  primary: const Color(0xff0056FE),
  canvas: const Color(0xffF7F8FA),
  surface: kWhiteColor,
  textPrimary: const Color(0xff111827),
  textSecondary: const Color(0xff4B5563),
  border: const Color(0xffE5E7EB),
  borderDefault: const Color(0xffD1D5DB),
  danger: const Color(0xffFB132D),
);

/// Dark Theme
final ThemeData darkTheme = _buildTheme(
  brightness: Brightness.dark,
  primary: const Color(0xff4682FF),
  canvas: const Color(0xff0B1220),
  surface: const Color(0xff111827),
  textPrimary: const Color(0xffF7F8FA),
  textSecondary: const Color(0xff9CA3AF),
  border: const Color(0xff1F2937),
  borderDefault: const Color(0xff374151),
  danger: const Color(0xffFD4258),
);

ThemeData _buildTheme({
  required Brightness brightness,
  required Color primary,
  required Color canvas,
  required Color surface,
  required Color textPrimary,
  required Color textSecondary,
  required Color border,
  required Color borderDefault,
  required Color danger,
}) {
  final isDark = brightness == Brightness.dark;
  const radius8 = BorderRadius.all(Radius.circular(8));
  const buttonText = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  return ThemeData(
    useMaterial3: false,
    brightness: brightness,
    fontFamily: kFontFamily,
    primaryColor: primary,
    primarySwatch: primary.toMaterialColorFrom(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      onPrimary: kWhiteColor,
      surface: surface,
      onSurface: textPrimary,
      error: danger,
    ),
    scaffoldBackgroundColor: canvas,
    canvasColor: surface,
    cardColor: surface,
    dividerColor: border,
    dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 56,
      titleTextStyle: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: IconThemeData(color: textPrimary),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: kWhiteColor,
        disabledBackgroundColor: isDark ? const Color(0xff1F2937) : const Color(0xffEFF1F4),
        disabledForegroundColor: const Color(0xff9CA3AF),
        minimumSize: const Size(48, 44),
        shape: const RoundedRectangleBorder(borderRadius: radius8),
        textStyle: buttonText,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size(48, 44),
        side: BorderSide(color: primary),
        shape: const RoundedRectangleBorder(borderRadius: radius8),
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size(48, 40),
        textStyle: buttonText,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: kWhiteColor,
        elevation: 0,
        minimumSize: const Size(48, 44),
        shape: const RoundedRectangleBorder(borderRadius: radius8),
        textStyle: buttonText,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      hintStyle: const TextStyle(color: Color(0xff9CA3AF), fontSize: 14),
      labelStyle: TextStyle(color: textSecondary, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: radius8,
        borderSide: BorderSide(color: borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius8,
        borderSide: BorderSide(color: borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius8,
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius8,
        borderSide: BorderSide(color: danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius8,
        borderSide: BorderSide(color: danger, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: isDark ? const Color(0xff13234A) : const Color(0xffEBF2FF),
      side: BorderSide(color: borderDefault),
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      showCheckmark: false,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? primary : null,
      ),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? primary : borderDefault,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      showDragHandle: true,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: textSecondary,
      indicatorColor: primary,
      labelStyle: const TextStyle(
          fontFamily: kFontFamily, fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
          fontFamily: kFontFamily, fontSize: 14, fontWeight: FontWeight.w500),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? const Color(0xffF7F8FA) : const Color(0xff111827),
      shape: const RoundedRectangleBorder(borderRadius: radius8),
      contentTextStyle: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 14,
        color: isDark ? const Color(0xff111827) : kWhiteColor,
      ),
    ),
  );
}

extension on Color {
  MaterialColor toMaterialColorFrom() {
    final strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    final swatch = <int, Color>{};
    final r = (this.r * 255).round(), g = (this.g * 255).round(), b = (this.b * 255).round();
    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(toARGB32(), swatch);
  }
}
