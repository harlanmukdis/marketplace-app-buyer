import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/services/auth_events.dart';
import '../../core/services/token_store.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'mock/pending_api_mock.dart';
import 'token_refresher.dart';

/// Pabrik `Dio` untuk API Markas.
///
/// Satu instance `Dio` **bernama** didaftarkan di `get_it` dengan nama [api].
/// Kalau nanti ada domain fitur yang memanggil API lain (base URL berbeda,
/// header berbeda), daftarkan instance bernama lain di sini — jangan menumpang
/// pada instance `"api"` lalu menimpa `baseUrl` per request, karena
/// interceptor auth-nya akan ikut mengirim token kita ke host pihak ketiga.
abstract final class DioClient {
  /// Nama instance untuk `injector<Dio>(instanceName: DioClient.api)`.
  static const String api = 'api';

  static BaseOptions _options(String baseUrl) => BaseOptions(
        baseUrl: baseUrl,

        // Backend **hanya** membaca `php://input` sebagai JSON. `form-data`
        // dan `x-www-form-urlencoded` tidak dibaca sama sekali — field akan
        // terlihat kosong dan balasannya `422 VALIDATION_ERROR` yang
        // membingungkan. Menetapkan default di sini mencegah satu service
        // salah kirim tanpa sadar.
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        // Sengaja BUKAN const: map const bersifat immutable, sehingga
        // `dio.options.headers['X'] = ...` melempar saat runtime dan header
        // tambahan diam-diam tidak pernah terkirim.
        headers: {'Accept': 'application/json'},

        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),

        // `sendTimeout` tidak didukung adapter browser dan bisa melempar di
        // Flutter web, jadi hanya dipasang di platform native. `connectTimeout`
        // sendiri diabaikan di web (XHR tidak mengekspos fase connect) — aman
        // dibiarkan, cuma tidak berefek.
        sendTimeout: kIsWeb ? null : const Duration(seconds: 30),

        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      );

  /// `Dio` polos tanpa interceptor. Dipakai untuk mengulang request dan untuk
  /// endpoint refresh, supaya tidak ada rekursi interceptor.
  static Dio createBare(String baseUrl) => Dio(_options(baseUrl));

  /// Client utama: auth + logging.
  ///
  /// Urutan interceptor penting. [AuthInterceptor] didaftarkan lebih dulu agar
  /// header `Authorization` sudah menempel sebelum [LoggingInterceptor]
  /// mencetak request — sehingga log memperlihatkan header yang benar-benar
  /// dikirim (dalam bentuk tersunting).
  static Dio create({
    required String baseUrl,
    required TokenStore tokens,
    required TokenRefresher refresher,
    required AuthEvents authEvents,
  }) {
    final dio = Dio(_options(baseUrl));

    dio.interceptors.add(
      AuthInterceptor(
        tokens: tokens,
        refresher: refresher,
        authEvents: authEvents,
        retryClient: createBare(baseUrl),
      ),
    );

    // Sesudah auth, sebelum logging: request yang dijawab mock tetap tercatat
    // di log (dengan penanda `x-mock`), dan respons sungguhan yang diperkaya
    // mock sudah membawa field tambahannya saat dicetak.
    if (PendingApiMock.enabled) {
      dio.interceptors.add(PendingApiMockInterceptor(PendingApiMock.routes));
    }

    if (kDebugMode) {
      dio.interceptors.add(const LoggingInterceptor());
    }

    return dio;
  }
}
