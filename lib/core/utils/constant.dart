import 'package:flutter/material.dart';

// Colors
//
// Nilainya mengikuti design system Xpedia
// (assets/stitch_xpedia_buyer_project/design_buyer.md §1). Nama lamanya
// dipertahankan karena dipakai ratusan kali lewat pola
// `isAppDarkMode() ? kDark… : kLight…`; token yang lebih lengkap ada di
// lib/core/design/xp_colors.dart.
const Color kLightPrimaryColor = Color(0xff0056FE); // brand-primary
const Color kDarkPrimaryColor = Color(0xff4682FF); // primary (dark)
const Color kLightSecondColor = Color(0xff111827); // text-primary
const Color kDarkSecondColor = Color(0xffF7F8FA); // text-primary (dark)
const Color kLightThirdColor = Color(0xff4B5563); // text-secondary
const Color kDarkThirdColor = Color(0xff9CA3AF); // text-secondary (dark)
const Color kBorderColor = Color(0xffE5E7EB); // border-subtle
const Color kSuccessColor = Color(0xff109553);
const Color kWarningColor = Color(0xffF59E0B);
const Color kErrorColor = Color(0xffFB132D); // danger
const Color kDeleteColor = Color(0xffFB132D);
const Color kWhiteColor = Colors.white;
const Color kBlackColor = Colors.black;
const Color kDarkColor = Color(0xff0B1220); // canvas (dark)

// Font
const String kFontFamily = 'Inter';

// General
const String kAccessToken = 'accessToken';
const String kRefreshToken = 'refreshToken';
const String kUserId = 'userId';
const String kUserRole = 'userRole';
const String kUserName = 'userName';
const String kBuyerSegment = 'buyerSegment';
const String kAccessTokenExpiry = 'accessTokenExpiry';
const String kAppLanguage = 'appLanguage';
const String kAppTheme = 'appTheme';
const String kDark = 'dark';
const String kLight = 'light';
