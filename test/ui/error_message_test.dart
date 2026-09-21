/// Pemetaan [DataError] → teks yang dibaca user.
///
/// Aturan yang dijaga di sini cuma satu, tapi mudah dilanggar tanpa sadar:
/// **`error.message` dari server tidak pernah sampai ke layar.** Isinya teks
/// untuk developer, kadang bahasa Inggris, kadang menyebut nama permission.
///
/// Test ini widget test, bukan test murni, karena `errorMessageFor` menerima
/// `BuildContext` untuk membaca `S.of(context)`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/util/error_message.dart';

/// Merender pesan untuk [code] lalu mengembalikannya sebagai teks.
Future<String> messageFor(
  WidgetTester tester,
  String code, {
  String serverMessage = 'Some developer-facing text',
  int? statusCode,
}) async {
  late String rendered;

  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Builder(builder: (context) {
      rendered = errorMessageFor(
        context,
        DataError(
          code: code,
          message: serverMessage,
          kind: DataErrorKind.api,
          statusCode: statusCode,
        ),
      );
      return const SizedBox.shrink();
    }),
  ));
  await tester.pumpAndSettle();

  return rendered;
}

void main() {
  group('TOO_MANY_REQUESTS', () {
    testWidgets('punya pesannya sendiri, bukan pesan generik', (tester) async {
      // Sebelum backend v1.2.0 kode ini tidak pernah terbit, jadi ia jatuh ke
      // "something went wrong" — yang tidak memberi tahu user bahwa menunggu
      // adalah satu-satunya jalan keluar.
      final rateLimited =
          await messageFor(tester, ApiErrorCode.tooManyRequests, statusCode: 429);
      final generic = await messageFor(tester, 'KODE_YANG_TIDAK_DIPETAKAN');

      expect(rateLimited, isNot(generic));
      expect(rateLimited, contains('Tunggu'));
    });

    testWidgets('🔴 TIDAK boleh terbaca seperti "password salah"',
        (tester) async {
      // Batas per-email 5×/15 menit berarti user yang lupa sandinya terkunci
      // justru saat ia paling mungkin mencoba lagi. Menyebutnya kredensial
      // salah membuatnya terus mencoba dan memperpanjang kuncian.
      final rateLimited =
          await messageFor(tester, ApiErrorCode.tooManyRequests, statusCode: 429);
      final wrongPassword =
          await messageFor(tester, ApiErrorCode.invalidCredentials);

      expect(rateLimited, isNot(wrongPassword));
      expect(rateLimited.toLowerCase(), isNot(contains('password')));
      expect(rateLimited.toLowerCase(), isNot(contains('sandi')));
    });

    testWidgets('tidak menjanjikan angka menit yang tidak dikirim server',
        (tester) async {
      // Server tidak mengirim `Retry-After` maupun `details` berisi sisa
      // waktu — diperiksa ke seluruh kode API. Menulis "coba lagi dalam 15
      // menit" berarti mengarang angka yang tidak diketahui aplikasi.
      final rateLimited =
          await messageFor(tester, ApiErrorCode.tooManyRequests, statusCode: 429);
      expect(rateLimited, isNot(matches(RegExp(r'\d'))));
    });
  });

  group('kebocoran pesan server', () {
    testWidgets('pesan developer tidak pernah ikut ke layar', (tester) async {
      for (final code in [
        ApiErrorCode.tooManyRequests,
        ApiErrorCode.invalidCredentials,
        ApiErrorCode.permissionDenied,
        'KODE_YANG_TIDAK_DIPETAKAN',
      ]) {
        final rendered = await messageFor(
          tester,
          code,
          serverMessage: 'Missing permission: admin.user.view',
        );
        expect(rendered, isNot(contains('admin.user.view')),
            reason: '$code membocorkan error.message ke layar');
      }
    });
  });
}
