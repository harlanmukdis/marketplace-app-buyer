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
    // Pesan validasi lokal ditulis aplikasi sendiri untuk user — satu-satunya
    // `message` yang aman ditampilkan (lihat `ClientErrorCode.localValidation`).
    case ClientErrorCode.localValidation:
      return error.message;

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
    case ApiErrorCode.identityTaken:
      return 'NIK ini sudah terdaftar di akun Xpedia lain.';

    // Sengaja TIDAK memakai `l.somethingWentWrong` maupun pesan kredensial:
    // panduan FE §2 menuntut 429 dibedakan, karena user yang membacanya
    // sebagai "password salah" akan terus mencoba dan memperpanjang kuncian.
    // Lama kuncinya tidak dikirim server (tidak ada `Retry-After` maupun
    // `details`), jadi pesannya tidak boleh menjanjikan angka menit.
    case ApiErrorCode.tooManyRequests:
      return 'Terlalu banyak percobaan. Tunggu beberapa menit sebelum '
          'mencoba lagi.';
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
    case ApiErrorCode.productNotFound:
      return 'Produk tidak ditemukan.';

    // Server memakai kode yang sama untuk "order item tidak ada" dan "pesanan
    // belum selesai". Penyebab yang jauh lebih sering adalah yang kedua, jadi
    // itu yang disebut — menulis "tidak ditemukan" saja akan membuat user
    // mengira pesanannya hilang.
    case ApiErrorCode.orderItemNotFound:
      return 'Ulasan hanya bisa dikirim untuk pesanan yang sudah selesai.';
    case ApiErrorCode.paymentNotFound:
      return 'Transaksi pembayaran tidak ditemukan.';
    case ApiErrorCode.searchUnavailable:
      return 'Pencarian sedang tidak tersedia. Coba jelajahi lewat kategori.';
    case ApiErrorCode.insufficientBalance:
      return 'Saldo tidak mencukupi.';

    case ApiErrorCode.chatContentBlocked:
      return 'Pesan tidak terkirim. Demi keamanan, jangan bagikan nomor HP, '
          'email, tautan, atau akun di platform lain.';
    case ApiErrorCode.shippingCoverageUnavailable:
      return 'Ada produk yang tidak bisa dikirim ke alamat ini. Coba alamat '
          'lain atau hapus produknya dari keranjang.';
    case ApiErrorCode.invalidSealCode:
      return 'Kode segel tidak cocok. Periksa kode di notifikasi pengiriman.';
    case ApiErrorCode.invoiceNotAvailable:
      return 'Invoice baru terbit setelah pesanan selesai.';

    // Minimum, rekening, dan saldo sudah disaring `WalletCubit` sebelum
    // request dikirim, jadi yang sampai ke sini praktis hanya urusan PIN.
    case ApiErrorCode.withdrawalRejected:
      return 'Penarikan ditolak. Periksa PIN kamu — kalau belum pernah '
          'membuatnya, buat PIN penarikan dulu.';
    case ApiErrorCode.ticketNotFound:
      return 'Tiket Xpedia 911 tidak ditemukan.';
    case ApiErrorCode.notParticipant:
      return 'Percakapan ini tidak bisa dibuka.';

    case ApiErrorCode.invalidPin:
      return 'PIN salah. Periksa lagi PIN Xpedia Wallet kamu.';
    case ApiErrorCode.pinNotSet:
      return 'Buat PIN Xpedia Wallet dulu untuk melanjutkan.';
    case ApiErrorCode.voucherQuotaExceeded:
      return 'Kuota voucher ini sudah habis.';
    case ApiErrorCode.voucherAlreadyUsed:
      return 'Voucher ini sudah pernah kamu pakai.';
    case ApiErrorCode.voucherMinSpendNotMet:
      return 'Belanjaanmu belum memenuhi minimum untuk voucher ini.';
    case ApiErrorCode.voucherAlreadyClaimed:
      return 'Voucher ini sudah ada di akunmu.';
    case ApiErrorCode.cancellationNotAllowed:
      return 'Pesanan ini sudah tidak bisa diajukan pembatalan.';
    case ApiErrorCode.cancellationRequestExists:
      return 'Permohonan pembatalan untuk pesanan ini sudah diajukan.';
    case ApiErrorCode.reviewEditWindowClosed:
      return 'Ulasan hanya bisa diubah sampai 30 hari sejak dikirim.';
    case ApiErrorCode.reviewNotFound:
      return 'Ulasan tidak ditemukan.';
    case ApiErrorCode.uploadFailed:
      return 'Berkas gagal diunggah. Periksa jenis dan ukurannya lalu coba lagi.';
    case ApiErrorCode.idCardAlreadyUsed:
      return 'NIK ini sudah dipakai akun Xpedia lain.';
    case ApiErrorCode.identityLocked:
      return 'Nama lengkap terkunci karena identitasmu sudah diverifikasi.';
    case ApiErrorCode.invalidOtp:
      return 'Kode OTP salah.';
    case ApiErrorCode.otpExpired:
      return 'Kode OTP sudah kedaluwarsa. Minta kode baru.';
    case ApiErrorCode.contactChangeNotFound:
      return 'Permintaan penggantian sudah tidak berlaku. Mulai lagi dari awal.';
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
