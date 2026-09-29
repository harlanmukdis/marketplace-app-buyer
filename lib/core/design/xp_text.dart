import 'package:flutter/material.dart';

import '../function/get_responsive_font_size.dart';
import 'xp_colors.dart';

/// Skala tipe Inter dari design_buyer.md §2.
///
/// Seperti [AppStyles], setiap gaya menerima `context` karena ukurannya
/// diskalakan terhadap lebar 375pt — tapi tidak pernah di bawah 11px, batas
/// yang ditetapkan design system. Warna bawaannya `textPrimary`; timpa dengan
/// `.copyWith(color: …)`.
abstract final class XpText {
  static TextStyle _style(
    BuildContext context, {
    required double size,
    required double height,
    required FontWeight weight,
    double? letterSpacing,
  }) {
    final scaled = getResponsiveFontSize(context, fontSize: size);
    final fontSize = scaled < 11 ? 11.0 : scaled;
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: fontSize,
      height: height / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      color: XpColors.textPrimary,
    );
  }

  static TextStyle headingXl(BuildContext c) =>
      _style(c, size: 24, height: 32, weight: FontWeight.w700);
  static TextStyle headingL(BuildContext c) =>
      _style(c, size: 20, height: 28, weight: FontWeight.w600);
  static TextStyle headingM(BuildContext c) =>
      _style(c, size: 18, height: 26, weight: FontWeight.w600);
  static TextStyle titleL(BuildContext c) =>
      _style(c, size: 16, height: 24, weight: FontWeight.w600);
  static TextStyle titleM(BuildContext c) =>
      _style(c, size: 14, height: 20, weight: FontWeight.w600);
  static TextStyle bodyL(BuildContext c) =>
      _style(c, size: 16, height: 24, weight: FontWeight.w400);
  static TextStyle bodyM(BuildContext c) =>
      _style(c, size: 14, height: 20, weight: FontWeight.w400);
  static TextStyle bodyS(BuildContext c) =>
      _style(c, size: 12, height: 18, weight: FontWeight.w400);
  static TextStyle labelL(BuildContext c) =>
      _style(c, size: 14, height: 20, weight: FontWeight.w500);
  static TextStyle labelM(BuildContext c) =>
      _style(c, size: 12, height: 16, weight: FontWeight.w500);
  static TextStyle labelS(BuildContext c) =>
      _style(c, size: 11, height: 14, weight: FontWeight.w500);
  static TextStyle caption(BuildContext c) =>
      _style(c, size: 11, height: 14, weight: FontWeight.w400);
  static TextStyle overline(BuildContext c) => _style(c,
      size: 10, height: 14, weight: FontWeight.w600, letterSpacing: 0.6);
  static TextStyle priceL(BuildContext c) =>
      _style(c, size: 18, height: 24, weight: FontWeight.w700);
  static TextStyle priceM(BuildContext c) =>
      _style(c, size: 16, height: 22, weight: FontWeight.w700);
  static TextStyle priceS(BuildContext c) =>
      _style(c, size: 14, height: 20, weight: FontWeight.w600);
  static TextStyle stat(BuildContext c) =>
      _style(c, size: 22, height: 28, weight: FontWeight.w700);
}

/// Radius (design_buyer.md §3). 8 adalah bawaan.
abstract final class XpRadius {
  static const double xs = 4;
  static const double s = 6;
  static const double m = 8;
  static const double l = 12;
  static const double xl = 16;
  static const double xxl = 24;
  static const double full = 999;
}
