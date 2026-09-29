/// Hasil satu operasi repository.
///
/// Kontraknya (Part 2 CLAUDE.md): **repository tidak pernah throw**. Semua
/// kegagalan — jaringan, timeout, maupun `error` dari amplop API — dibungkus
/// jadi [DataFailed], sehingga cubit memakai pattern matching, bukan try/catch,
/// untuk alur kontrol.
///
/// [DataSuccess.meta] sengaja ada karena backend Markas menaruh **keputusan
/// bisnis** di `meta`, bukan hanya statistik: `meta.forced_bank_transfer`
/// menentukan metode bayar mana yang boleh dirender, `meta.note` menjelaskan
/// kenapa retur ditolak otomatis. Kalau repository hanya meneruskan `data`,
/// informasi itu hilang dan UI jadi salah.
sealed class DataState<T> {
  const DataState();

  /// Data kalau sukses, `null` untuk state lain. Untuk percabangan yang
  /// sesungguhnya pakai `switch` pada instance-nya, bukan getter ini.
  T? get valueOrNull => switch (this) {
        DataSuccess<T>(:final data) => data,
        _ => null,
      };

  bool get isSuccess => this is DataSuccess<T>;
}

/// Berhasil dan ada isinya.
class DataSuccess<T> extends DataState<T> {
  const DataSuccess(this.data, {this.meta = const {}, this.statusCode});

  final T data;

  /// Blok `meta` dari amplop respons; `{}` kalau endpoint tidak mengirimnya.
  final Map<String, dynamic> meta;

  /// Status HTTP asli. Dibutuhkan karena beberapa endpoint memakai **200 vs
  /// 201** untuk membedakan "mengembalikan yang sudah ada" dari "membuat baru"
  /// — `POST /payments/initiate` dan `POST /chat/threads`.
  final int? statusCode;

  /// `true` kalau server mengembalikan resource yang sudah ada (200), bukan
  /// membuat yang baru (201). Dipakai supaya app tidak membuat pembayaran atau
  /// thread chat duplikat.
  bool get isExisting => statusCode == 200;
}

/// Berhasil tapi kosong — mis. `GET /finance/tax_invoices` yang mengembalikan
/// array kosong karena toko bukan PKP. Dipisah dari [DataSuccess] supaya UI
/// bisa membedakan "belum ada data" dari "gagal memuat".
class DataEmpty<T> extends DataState<T> {
  const DataEmpty({this.meta = const {}});

  final Map<String, dynamic> meta;
}

/// Gagal. [error] selalu ada, jadi UI tidak perlu memeriksa null.
class DataFailed<T> extends DataState<T> {
  const DataFailed(this.error);

  final DataError error;
}

/// Sedang berjalan.
class DataLoading<T> extends DataState<T> {
  const DataLoading();
}

/// Asal kegagalan. Membedakan masalah transport dari penolakan yang memang
/// disengaja backend — keduanya butuh pesan dan tombol aksi yang berbeda.
enum DataErrorKind {
  /// Tidak ada koneksi / host tidak terjangkau / sertifikat bermasalah.
  network,

  /// Connect, send, atau receive timeout.
  timeout,

  /// Server membalas dengan amplop `success: false`.
  api,

  /// 5xx atau body yang tidak bisa di-parse.
  server,

  /// Request dibatalkan (mis. user pindah halaman).
  cancelled,

  unknown,
}

/// Kegagalan yang sudah dinormalisasi, apa pun sumbernya.
class DataError {
  const DataError({
    required this.code,
    required this.message,
    this.details,
    this.statusCode,
    this.kind = DataErrorKind.unknown,
  });

  /// `error.code` dari backend (mis. `BELOW_MIN_ORDER`), atau salah satu
  /// [ClientErrorCode] kalau kegagalannya terjadi di sisi app.
  final String code;

  /// Pesan dari backend. Belum tentu layak ditampilkan apa adanya ke user —
  /// petakan [code] ke string terlokalisasi untuk pesan yang user lihat.
  final String message;

  /// `error.details`. Hanya muncul di sebagian error: validasi
  /// (`details.missing`), gate, dan jendela retur (`delivered_at`,
  /// `window_hours`).
  final Map<String, dynamic>? details;

  final int? statusCode;
  final DataErrorKind kind;

  /// Token tidak ada / kedaluwarsa / invalid. Interceptor sudah mencoba
  /// refresh sebelum error ini sampai ke repository, jadi kalau masih muncul
  /// artinya sesi benar-benar habis → paksa login ulang.
  bool get isUnauthenticated =>
      code == ApiErrorCode.unauthenticated || statusCode == 401;

  /// **URL-nya salah**, bukan datanya tidak ada.
  ///
  /// Backend memakai routing bawaan CodeIgniter 3, jadi beberapa path tidak
  /// lazim (`/returns/{id}/detail`, `/cart/view`). Keduanya membalas 404, tapi
  /// `"Endpoint not found"` berarti bug di sisi app dan **tidak boleh**
  /// ditampilkan sebagai "data tidak ditemukan".
  bool get isRouteNotFound =>
      statusCode == 404 &&
      (message.toLowerCase().contains('endpoint not found') ||
          // marketplace-api membalas URL tak dikenal dengan **halaman HTML
          // 404** dari CodeIgniter, bukan amplop JSON. Body seperti itu
          // sampai ke sini sebagai `badResponse`, dan itu justru bukti kuat
          // bahwa request-nya tidak pernah mencapai handler API — salah URL,
          // bukan data kosong.
          code == ClientErrorCode.badResponse);

  /// Tidak berhak — entah karena role atau karena sistem izin. Digabung
  /// karena bagi user keduanya sama artinya: menu itu harus disembunyikan.
  bool get isForbidden =>
      statusCode == 403 ||
      code == ApiErrorCode.forbidden ||
      code == ApiErrorCode.permissionDenied;

  /// 404 yang benar-benar berarti data tidak ada **atau bukan milik user**.
  /// Backend sengaja tidak membedakan keduanya, dan UI juga tidak boleh.
  bool get isDataNotFound => statusCode == 404 && !isRouteNotFound;

  /// Transisi status tidak sah. **Jangan pernah dianggap sukses**, dan jangan
  /// retry buta — muat ulang datanya dulu, karena status di server sudah
  /// berubah dari yang app kira.
  bool get isConflict => statusCode == 409;

  /// Aman diulang sekali. Kegagalan transport bisa diulang; `DB_ERROR`
  /// eksplisit disebut boleh retry sekali. Sisanya tidak.
  bool get isRetryable =>
      kind == DataErrorKind.network ||
      kind == DataErrorKind.timeout ||
      code == ApiErrorCode.dbError;

  /// Kurang saldo. `details` pada `INSUFFICIENT_BALANCE` membawa `balance`
  /// dan `required` dalam rupiah penuh; [walletShortfall] adalah selisih yang
  /// harus di-top-up. Null kalau error-nya bukan itu, sehingga UI tidak perlu
  /// menebak.
  int? get walletBalance => _detailInt('balance');
  int? get walletRequired => _detailInt('required');
  int? get walletShortfall {
    final b = walletBalance;
    final r = walletRequired;
    if (b == null || r == null) return null;
    final diff = r - b;
    return diff > 0 ? diff : 0;
  }

  int? _detailInt(String key) {
    final raw = details?[key];
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw) ?? double.tryParse(raw)?.toInt();
    return null;
  }

  /// Field wajib yang kosong, dari `details.missing` pada `VALIDATION_ERROR`.
  List<String> get missingFields {
    final raw = details?['missing'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return const [];
  }

  @override
  String toString() =>
      'DataError($code${statusCode != null ? ' / HTTP $statusCode' : ''}: $message)';
}

/// `error.code` yang dikirim backend.
///
/// Dipakai sebagai konstanta, bukan enum, karena backend boleh menambah kode
/// baru kapan saja — kode yang tidak dikenal tetap lolos sebagai string biasa
/// dan tidak membuat parsing gagal.
abstract final class ApiErrorCode {
  static const malformedJson = 'MALFORMED_JSON';
  static const unauthenticated = 'UNAUTHENTICATED';
  static const invalidCredentials = 'INVALID_CREDENTIALS';
  static const invalidRefreshToken = 'INVALID_REFRESH_TOKEN';
  static const refreshRevoked = 'REFRESH_REVOKED';
  static const forbidden = 'FORBIDDEN';

  /// Ditolak sistem izin berbasis grup+menu (backend v2.2). Secara praktis
  /// setara [forbidden] bagi user: keduanya berarti "tidak berhak".
  static const permissionDenied = 'PERMISSION_DENIED';
  static const accountSuspended = 'ACCOUNT_SUSPENDED';

  /// Rate limit endpoint auth terlampaui (backend v1.2.0, `429`).
  ///
  /// 🔴 **Jangan pernah di-retry otomatis** dan jangan ditampilkan sebagai
  /// "email/password salah" — batas per-email 5×/15 menit berarti user yang
  /// benar-benar lupa sandinya akan terkunci justru saat ia paling mungkin
  /// mencoba lagi, dan menyebutnya kredensial salah membuatnya terus mencoba.
  static const tooManyRequests = 'TOO_MANY_REQUESTS';
  static const notFound = 'NOT_FOUND';
  static const conflict = 'CONFLICT';
  static const invalidState = 'INVALID_STATE';
  static const invalidTransition = 'INVALID_TRANSITION';
  static const validationError = 'VALIDATION_ERROR';

  /// Saldo dompet kurang. `details` membawa `balance` dan `required`;
  /// selisihnya wajib ditampilkan, bukan cuma "saldo kurang".
  static const insufficientBalance = 'INSUFFICIENT_BALANCE';
  static const dbError = 'DB_ERROR';

  // --- Kode yang benar-benar diterima dari marketplace-api ---
  //
  // Seluruh kode di bawah sudah dilihat langsung di respons server, bukan
  // disalin dari dokumen. Kode khas backend Markas (SAMPLE_QTY_EXCEEDED,
  // FLEET_*, ALREADY_ATTACHED, EMPTY_CART, SELLER_NOT_IN_CART) sudah dihapus
  // bersama lapisan matinya — endpointnya tidak ada lagi.

  /// Registrasi: email atau nomor sudah dipakai. Dibedakan supaya formulir
  /// bisa menyorot field yang tepat.
  static const emailTaken = 'EMAIL_TAKEN';
  static const phoneTaken = 'PHONE_TAKEN';

  /// Token verifikasi email sudah terpakai atau tidak sah.
  static const invalidToken = 'INVALID_TOKEN';

  /// Varian produk tidak ada — satu-satunya validasi `POST /cart/items`.
  static const variantNotFound = 'VARIANT_NOT_FOUND';

  /// Voucher tidak berlaku, dari `/vouchers/validate`, `/vouchers/claim`,
  /// maupun `/cart/apply-voucher`.
  static const voucherInvalid = 'VOUCHER_INVALID';

  /// Sesi checkout tidak ada atau bukan milik user ini.
  static const sessionNotFound = 'SESSION_NOT_FOUND';

  /// Sesi checkout tidak dalam keadaan yang bisa dikonfirmasi — mis. sudah
  /// dikonfirmasi sebelumnya, dibatalkan, atau lewat tenggat reservasi.
  static const checkoutConfirmFailed = 'CHECKOUT_CONFIRM_FAILED';

  /// Stok tidak mencukupi saat reservasi checkout.
  static const stockInsufficient = 'STOCK_INSUFFICIENT';

  static const orderNotFound = 'ORDER_NOT_FOUND';
  static const paymentNotFound = 'PAYMENT_NOT_FOUND';
  static const categoryNotFound = 'CATEGORY_NOT_FOUND';
  static const productNotFound = 'PRODUCT_NOT_FOUND';

  /// Dibalas `POST /order-items/{id}/review` saat pesanannya **belum
  /// `completed`** — bukan hanya saat order item-nya benar-benar tidak ada.
  /// Server tidak membedakan keduanya, jadi pesannya harus menyebut syarat
  /// itu; "tidak ditemukan" akan terbaca user sebagai pesanannya hilang.
  static const orderItemNotFound = 'ORDER_ITEM_NOT_FOUND';

  /// `/search/*` mati karena Elasticsearch tidak jalan. Keadaan normal di
  /// dev — layar seharusnya beralih ke `GET /products?q=`.
  static const searchUnavailable = 'SEARCH_UNAVAILABLE';

  // --- backend v1.6–v1.28 (blueprint Xpedia) ---

  /// Chat berisi nomor HP, email, URL, atau nama platform lain. Pesannya
  /// **tidak tersimpan**; tiga pelanggaran dalam 24 jam memicu fraud flag
  /// diam-diam.
  static const chatContentBlocked = 'CHAT_CONTENT_BLOCKED';

  /// Toko tidak mengirim ke alamat tujuan (`POST /checkout/sessions`).
  /// `details` null — produk mana yang gagal hanya tertulis di `message`.
  static const shippingCoverageUnavailable = 'SHIPPING_COVERAGE_UNAVAILABLE';

  /// Kode segel Secure+ salah/kosong di `confirm-delivery`.
  static const invalidSealCode = 'INVALID_SEAL_CODE';

  /// Invoice diminta untuk pesanan yang belum `completed`.
  static const invoiceNotAvailable = 'INVOICE_NOT_AVAILABLE';

  /// Semua penolakan penarikan (minimum, PIN, rekening, saldo) — lihat
  /// `WalletService.withdraw`.
  static const withdrawalRejected = 'WITHDRAWAL_REJECTED';

  static const ticketNotFound = 'TICKET_NOT_FOUND';

  // --- API yang diusulkan (di-mock; lihat assets/mock/pending_api/README.md) ---
  // Didaftarkan di sini supaya layar mana pun yang menerimanya menampilkan
  // pesan yang benar — bukan hanya layar yang menulis pemetaan lokalnya.
  static const invalidPin = 'INVALID_PIN';
  static const pinNotSet = 'PIN_NOT_SET';
  static const voucherQuotaExceeded = 'VOUCHER_QUOTA_EXCEEDED';
  static const voucherAlreadyUsed = 'VOUCHER_ALREADY_USED';
  static const voucherMinSpendNotMet = 'VOUCHER_MIN_SPEND_NOT_MET';
  static const voucherAlreadyClaimed = 'VOUCHER_ALREADY_CLAIMED';
  static const cancellationNotAllowed = 'CANCELLATION_NOT_ALLOWED';
  static const cancellationRequestExists = 'CANCELLATION_REQUEST_EXISTS';
  static const reviewEditWindowClosed = 'REVIEW_EDIT_WINDOW_CLOSED';
  static const reviewNotFound = 'REVIEW_NOT_FOUND';
  static const uploadFailed = 'UPLOAD_FAILED';
  static const idCardAlreadyUsed = 'ID_CARD_ALREADY_USED';
  static const identityLocked = 'IDENTITY_LOCKED';
  static const invalidOtp = 'INVALID_OTP';
  static const otpExpired = 'OTP_EXPIRED';
  static const contactChangeNotFound = 'CONTACT_CHANGE_NOT_FOUND';
  static const notParticipant = 'NOT_PARTICIPANT';
}

/// Kode yang dibuat app sendiri, untuk kegagalan yang tidak pernah datang dari
/// backend. Diberi awalan supaya tidak mungkin bentrok dengan [ApiErrorCode].
abstract final class ClientErrorCode {
  static const network = 'CLIENT_NETWORK';
  static const timeout = 'CLIENT_TIMEOUT';
  static const cancelled = 'CLIENT_CANCELLED';
  static const badResponse = 'CLIENT_BAD_RESPONSE';

  /// Validasi yang dilakukan **aplikasi sendiri** sebelum menyentuh jaringan.
  /// Berbeda dari kode server, `message`-nya ditulis aplikasi dalam bahasa
  /// Indonesia untuk user — jadi satu-satunya kode yang pesannya boleh
  /// ditampilkan apa adanya oleh `errorMessageFor`.
  static const localValidation = 'CLIENT_LOCAL_VALIDATION';
  static const unknown = 'CLIENT_UNKNOWN';
}
