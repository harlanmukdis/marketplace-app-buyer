import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Log HTTP untuk debug, dengan penyuntingan kredensial.
///
/// Hanya aktif saat `kDebugMode`. Nilai sensitif **wajib** disunting: log Dio
/// yang apa adanya akan mencetak `Authorization: Bearer ...` dan body login
/// berisi password ke konsol — yang lalu ikut masuk laporan bug, rekaman
/// layar, dan (di web) DevTools siapa pun yang membuka halaman itu.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  static const _redacted = '***';
  static const _sensitiveHeaders = {'authorization', 'cookie', 'set-cookie'};
  static const _sensitiveFields = {
    'password',
    'access_token',
    'refresh_token',
    'token',
    'npwp',
    // PIN Xpedia Wallet (tarik saldo, bayar, ganti PIN) dan kode sekali
    // pakai. Log debug bisa ikut tersalin ke laporan bug.
    'pin',
    'current_pin',
    'otp',
    'seal_code',
    'id_card_number',
  };

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      developer.log(
        '→ ${options.method} ${options.uri}\n'
        '  headers: ${_scrubHeaders(options.headers)}\n'
        '  body: ${_scrubBody(options.data)}',
        name: 'api',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      developer.log(
        '← ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri}\n'
        '  body: ${_scrubBody(response.data)}',
        name: 'api',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '✗ ${err.response?.statusCode ?? err.type.name} '
        '${err.requestOptions.method} ${err.requestOptions.uri}\n'
        '  body: ${_scrubBody(err.response?.data)}',
        name: 'api',
      );
    }
    handler.next(err);
  }

  Map<String, dynamic> _scrubHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) => MapEntry(
          key,
          _sensitiveHeaders.contains(key.toLowerCase()) ? _redacted : value,
        ));
  }

  Object? _scrubBody(Object? body) {
    if (body is Map) {
      return body.map((key, value) => MapEntry(
            key,
            _sensitiveFields.contains(key.toString().toLowerCase())
                ? _redacted
                : _scrubBody(value),
          ));
    }
    if (body is List) return body.map(_scrubBody).toList();
    return body;
  }
}
