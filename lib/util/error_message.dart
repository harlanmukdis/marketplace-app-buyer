import 'package:flutter/widgets.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/generated/l10n.dart';

/// Menerjemahkan [DataError] jadi pesan yang layak dibaca user.
///
/// `error.message` dari backend **tidak dipakai langsung**: isinya teks teknis
/// berbahasa Inggris yang ditujukan untuk developer (`"Missing required
/// fields"`). Yang dipetakan adalah `error.code`, yang stabil dan bisa
/// dilokalisasi.
///
/// Kode yang belum dipetakan jatuh ke pesan generik — **bukan** ke
/// `error.message` — supaya tidak ada teks internal yang bocor ke layar.
/// Setiap domain fitur menambahkan kodenya sendiri di sini saat diintegrasikan
/// (mis. `BELOW_MIN_ORDER`, `STOCK_RESERVATION_FAILED`, `RETURN_WINDOW_EXPIRED`).
String errorMessageFor(BuildContext context, DataError error) {
  final l = S.of(context);

  switch (error.code) {
    // --- transport ---
    case ClientErrorCode.network:
      return l.noInternetConnection;
    case ClientErrorCode.timeout:
      return l.requestTimedOut;

    // --- auth ---
    case ApiErrorCode.invalidCredentials:
      return l.invalidCredentialsMessage;
    case ApiErrorCode.accountSuspended:
      return l.accountSuspendedMessage;

    // Ditangani bersama FORBIDDEN: bagi user, "role tidak berhak" dan
    // "izin grup tidak mengizinkan" adalah hal yang sama.
    case ApiErrorCode.forbidden:
    case ApiErrorCode.permissionDenied:
      return l.notAvailable;
    case ApiErrorCode.unauthenticated:
    case ApiErrorCode.invalidRefreshToken:
    case ApiErrorCode.refreshRevoked:
      return l.sessionExpired;

    case ApiErrorCode.phoneTaken:
      return l.phoneAlreadyRegistered;
    case ApiErrorCode.emailTaken:
      return l.emailAlreadyRegistered;
  }

  // --- belanja ---
  //
  // Ditulis langsung dalam bahasa Indonesia, bukan lewat `S.of(context)`,
  // karena kunci l10n untuk kode-kode ini belum ada dan seluruh layar yang
  // menampilkannya (katalog, keranjang, checkout) memang berbahasa Indonesia.
  // Pindahkan ke `.arb` begitu layar-layar itu ikut dilokalisasi — jangan
  // menambah kunci baru hanya untuk file ini.
  //
  // Yang tidak boleh dilakukan tetap sama: **jangan** menampilkan
  // `error.message` dari server, yang isinya teks untuk developer.
  final shopping = _shoppingMessage(error.code);
  if (shopping != null) return shopping;

  return l.somethingWentWrong;
}

String? _shoppingMessage(String code) {
  switch (code) {
    case ApiErrorCode.variantNotFound:
      return 'Varian produk ini sudah tidak tersedia.';
    case ApiErrorCode.stockInsufficient:
      return 'Stok tidak mencukupi. Kurangi jumlahnya lalu coba lagi.';
    case ApiErrorCode.voucherInvalid:
      return 'Kode voucher tidak berlaku.';
    case ApiErrorCode.sessionNotFound:
      return 'Sesi checkout sudah tidak berlaku. Ulangi dari keranjang.';

    // Penyebab tersering: tenggat reservasi 15 menit terlewat, atau sesi
    // sudah dikonfirmasi sebelumnya. Keduanya berujung pada tindakan yang
    // sama, jadi pesannya digabung.
    case ApiErrorCode.checkoutConfirmFailed:
      return 'Checkout tidak bisa dilanjutkan — sesinya mungkin sudah '
          'kedaluwarsa atau sudah diproses. Ulangi dari keranjang.';

    case ApiErrorCode.orderNotFound:
      return 'Pesanan tidak ditemukan.';
    case ApiErrorCode.paymentNotFound:
      return 'Transaksi pembayaran tidak ditemukan.';
    case ApiErrorCode.searchUnavailable:
      return 'Pencarian sedang tidak tersedia. Coba jelajahi lewat kategori.';
    case ApiErrorCode.insufficientBalance:
      return 'Saldo tidak mencukupi.';
  }
  return null;
}

/// Detail teknis untuk log dan laporan bug — **jangan** ditampilkan ke user.
///
/// Menyertakan `details.missing` kalau ada, karena itu yang paling cepat
/// menunjukkan field mana yang belum dikirim saat `422 VALIDATION_ERROR`.
String debugDetailFor(DataError error) {
  final missing = error.missingFields;
  return [
    error.code,
    if (error.statusCode != null) 'HTTP ${error.statusCode}',
    error.message,
    if (missing.isNotEmpty) 'missing: ${missing.join(', ')}',
  ].join(' | ');
}
