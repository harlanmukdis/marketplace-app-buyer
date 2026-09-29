import 'package:flutter/material.dart';

import '../function/components.dart';

/// Token warna design system Xpedia.
///
/// Sumbernya `assets/stitch_xpedia_buyer_project/design_buyer.md` §1 — jangan
/// menambah warna di luar daftar itu. Getter-nya membaca [isAppDarkMode] di
/// tiap panggilan, sama dengan pola `isAppDarkMode() ? kDark… : kLight…` di
/// seluruh aplikasi: tema dibaca sinkron dari preferensi dan ganti tema
/// memulai ulang app, jadi tidak perlu `Theme.of(context)`.
abstract final class XpColors {
  static bool get _dark => isAppDarkMode();

  // Brand
  static const Color navy = Color(0xff0F286C);
  static Color get primary => _dark ? const Color(0xff4682FF) : const Color(0xff0056FE);
  static const Color primaryPressed = Color(0xff0047D1);
  static Color get primarySubtle =>
      _dark ? const Color(0xff13234A) : const Color(0xffEBF2FF);

  // Surface & text
  static Color get canvas => _dark ? const Color(0xff0B1220) : const Color(0xffF7F8FA);
  static Color get surface => _dark ? const Color(0xff111827) : const Color(0xffFFFFFF);
  static Color get sunken => _dark ? const Color(0xff1F2937) : const Color(0xffEFF1F4);
  static Color get textPrimary =>
      _dark ? const Color(0xffF7F8FA) : const Color(0xff111827);
  static Color get textSecondary =>
      _dark ? const Color(0xff9CA3AF) : const Color(0xff4B5563);
  static Color get textTertiary =>
      _dark ? const Color(0xff9CA3AF) : const Color(0xff6B7280);
  static const Color textPlaceholder = Color(0xff9CA3AF);
  static const Color textOnBrand = Color(0xffFFFFFF);
  static Color get borderSubtle =>
      _dark ? const Color(0xff1F2937) : const Color(0xffE5E7EB);
  static Color get borderDefault =>
      _dark ? const Color(0xff374151) : const Color(0xffD1D5DB);
  static const Color borderStrong = Color(0xff9CA3AF);

  // Feedback
  static Color get danger => _dark ? const Color(0xffFD4258) : const Color(0xffFB132D);
  static Color get dangerSubtle =>
      _dark ? const Color(0xff3A1218) : const Color(0xffFFECEE);
  static Color get success => _dark ? const Color(0xff22B268) : const Color(0xff109553);
  static Color get successSubtle =>
      _dark ? const Color(0xff0E2E1E) : const Color(0xffE8F8EF);
  static const Color warning = Color(0xffF59E0B);
  static Color get warningSubtle =>
      _dark ? const Color(0xff3A2A0A) : const Color(0xffFFF6E5);

  // Xpedia Signature — lencana yang diberikan, tidak pernah dibeli.
  static const Color signatureBlack = Color(0xff101014);
  static const Color signatureGold = Color(0xffC9A227);

  /// Bintang rating. Tidak tercantum di design_buyer.md, tapi seluruh layar
  /// Stitch memakai amber ini untuk ikon bintang.
  static const Color star = Color(0xffF59E0B);
}

/// Pasangan latar/teks untuk pil status dan chip.
@immutable
class XpTone {
  const XpTone(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

/// Warna pil status pesanan (design_buyer.md §1 "Order status").
abstract final class XpOrderTones {
  static const paid = XpTone(Color(0xffE8F8EF), Color(0xff0C7A44));
  static const processing = XpTone(Color(0xffFFF6E5), Color(0xff8C5002));
  static const awaitingConfirmation = XpTone(Color(0xffE0D9FD), Color(0xff4E34AB));
  static const shipping = XpTone(Color(0xffEBF2FF), Color(0xff0047D1));
  static const delivered = XpTone(Color(0xffE6F7FA), Color(0xff08677B));
  static const completed = XpTone(Color(0xffE8F8EF), Color(0xff0C7A44));
  static const cancelled = XpTone(Color(0xffEFF1F4), Color(0xff4B5563));
}

/// Warna chip mode stok (design_buyer.md §1 "Stock mode chips").
abstract final class XpStockTones {
  static const ready = XpTone(Color(0xffE8F8EF), Color(0xff0C7A44));
  static const low = XpTone(Color(0xffFFF6E5), Color(0xff8C5002));
  static const preOrder = XpTone(Color(0xffF1EEFE), Color(0xff6344D6));
  static const customOrder = XpTone(Color(0xffE0D9FD), Color(0xff4E34AB));
  static const unavailable = XpTone(Color(0xffEFF1F4), Color(0xff4B5563));
}
