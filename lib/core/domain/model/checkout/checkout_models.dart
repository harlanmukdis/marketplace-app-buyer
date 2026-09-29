import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/format_helper.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'checkout_models.freezed.dart';
part 'checkout_models.g.dart';

// ---------------------------------------------------------------------------
// ✅ `ServerUtcDateTimeJson` SUDAH DIHAPUS (19 September 2026)
//
// Dulu ada converter khusus di sini karena satu respons checkout memakai DUA
// zona waktu sekaligus: `created_at` waktu dinding WIB, sedangkan `expires_at`
// UTC — selisihnya tepat 15 menit hanya kalau `expires_at` digeser +7 jam.
// Penyebabnya PHP `date()` memakai `php.ini date.timezone` (UTC) sementara
// kolom lain diisi `CURRENT_TIMESTAMP` MySQL (WIB).
//
// Backend memperbaikinya di commit `93c6a14` ("Set PHP timezone to match
// MySQL, fixing systemic date()/NOW() drift") dengan memanggil
// `date_default_timezone_set('Asia/Jakarta')` di `application/config/config.php`
// — bukan di `php.ini`, justru supaya tidak bergantung konfigurasi PHP di luar
// aplikasi. Jadi seluruh timestamp kini WIB tanpa kecuali, dan
// `ServerDateTimeJson` benar di mana-mana.
//
// Test integrasi yang memaku selisih 15 menit / 1 jam itulah yang lebih dulu
// merah dan menunjukkan perubahannya — persis fungsinya dibuat.
// ---------------------------------------------------------------------------

/// Hasil `POST /checkout/sessions`.
///
/// Perhatikan: [id] adalah **UUID string**, bukan integer — itu sebabnya
/// rutenya `(:any)`. Nilai uangnya di sini datang sebagai **angka**, padahal
/// `GET /checkout/sessions/{id}` mengirim `grand_total` sebagai string
/// berdesimal. Converter menyerap keduanya.
@freezed
abstract class CheckoutSessionCreated with _$CheckoutSessionCreated {
  const CheckoutSessionCreated._();

  const factory CheckoutSessionCreated({
    @StringJson() @Default('') String id,
    @DoubleJson() @Default(0) double subtotal,
    @DoubleJson() @Default(0) double discount,
    @DoubleJson() @JsonKey(name: 'grand_total') @Default(0) double grandTotal,
    @ServerDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _CheckoutSessionCreated;

  factory CheckoutSessionCreated.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionCreatedFromJson(json);

  Duration? get timeLeft {
    final deadline = expiresAt;
    if (deadline == null) return null;
    final left = deadline.difference(DateTime.now().toUtc());
    return left.isNegative ? Duration.zero : left;
  }
}

/// Detail sesi dari `GET /checkout/sessions/{id}`.
@freezed
abstract class CheckoutSessionModel with _$CheckoutSessionModel {
  const CheckoutSessionModel._();

  const factory CheckoutSessionModel({
    @StringJson() @Default('') String id,

    /// `stock_reserved` → `awaiting_payment` sesudah konfirmasi.
    /// Sesi yang dibatalkan berstatus **`expired`**, bukan `cancelled`.
    @StringJson() @Default('') String status,

    /// ⚠️ Dikirim sebagai **string berisi JSON**, bukan array bersarang.
    /// Dipakai [snapshotItems] untuk membacanya.
    @StringOrNullJson() @JsonKey(name: 'cart_snapshot') String? cartSnapshot,
    @IntOrNullJson()
    @JsonKey(name: 'shipping_address_id')
    int? shippingAddressId,

    /// `null` sebelum kurir dipilih; sesudahnya map berkunci `store_id`.
    ///
    /// ⚠️ **Dikirim sebagai string berisi JSON**, bukan objek — sama seperti
    /// [cartSnapshot]. Ini menyesatkan karena balasan
    /// `PATCH /checkout/sessions/{id}/shipping` mengirim field bernama sama
    /// sebagai objek sungguhan; yang *tersimpan di sesi* berupa string.
    /// Tanpa [JsonMapJson], `GET /checkout/sessions/{id}` melempar
    /// `type 'String' is not a subtype of type 'Map<String, dynamic>?'`
    /// begitu kurir dipilih — persis di tengah alur checkout.
    @JsonMapJson()
    @JsonKey(name: 'selected_couriers')
    Map<String, dynamic>? selectedCouriers,

    /// Sama seperti [selectedCouriers]: string berisi JSON, bukan objek.
    @JsonMapJson()
    @JsonKey(name: 'applied_vouchers')
    Map<String, dynamic>? appliedVouchers,

    /// String berdesimal di endpoint ini (`"3049000.00"`), angka di
    /// `POST /checkout/sessions`.
    @DoubleJson() @JsonKey(name: 'grand_total') @Default(0) double grandTotal,

    /// Tenggat reservasi stok, 15 menit sesudah [createdAt].
    ///
    /// Dulu field ini butuh converter tersendiri karena dikirim dalam UTC
    /// sementara [createdAt] dalam WIB; backend sudah menyeragamkannya — lihat
    /// catatan di kepala berkas ini.
    @ServerDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CheckoutSessionModel;

  factory CheckoutSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionModelFromJson(json);

  bool get isAwaitingPayment => status == 'awaiting_payment';
  bool get isStockReserved => status == 'stock_reserved';

  /// Sesi yang dibatalkan **maupun** yang lewat tenggat sama-sama `expired`.
  bool get isExpired => status == 'expired';

  /// Sisa waktu reservasi stok. `Duration.zero` kalau sudah lewat.
  Duration? get timeLeft {
    final deadline = expiresAt;
    if (deadline == null) return null;
    final left = deadline.difference(DateTime.now().toUtc());
    return left.isNegative ? Duration.zero : left;
  }

  bool get hasSelectedCouriers =>
      selectedCouriers != null && selectedCouriers!.isNotEmpty;

  /// Isi `cart_snapshot`, hasil `jsonDecode` dari string.
  ///
  /// Mengembalikan list kosong kalau formatnya rusak — snapshot yang tidak
  /// terbaca tidak boleh menggagalkan seluruh halaman checkout, karena
  /// totalnya tetap sahih dan datang dari field terpisah.
  List<Map<String, dynamic>> get snapshotItems {
    final raw = cartSnapshot;
    if (raw == null || raw.trim().isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<Map>().map(Map<String, dynamic>.from).toList();
    } on FormatException {
      return const [];
    }
  }

  /// Id toko yang terlibat, diambil dari snapshot — dipakai untuk memastikan
  /// setiap toko sudah punya pilihan kurir sebelum konfirmasi.
  Set<String> get storeIds => {
        for (final item in snapshotItems)
          if (item['store_id'] != null) item['store_id'].toString(),
      };

  /// Toko yang belum dipilihkan kurir.
  Set<String> get storesWithoutCourier {
    final chosen = selectedCouriers?.keys.toSet() ?? const <String>{};
    return storeIds.difference(chosen);
  }

  /// Siap dikonfirmasi: masih dalam masa reservasi dan tiap toko sudah punya
  /// kurir.
  bool get canConfirm =>
      isStockReserved &&
      storesWithoutCourier.isEmpty &&
      (timeLeft == null || timeLeft! > Duration.zero);
}

/// Satu opsi pengiriman dari `GET /checkout/sessions/{id}/shipping-options`.
///
/// Seluruh angkanya datang sebagai **integer asli**, berbeda dari harga produk
/// yang berupa string.
@freezed
abstract class ShippingOptionModel with _$ShippingOptionModel {
  const ShippingOptionModel._();

  const factory ShippingOptionModel({
    @StringJson()
    @JsonKey(name: 'courier_code')
    @Default('')
    String courierCode,
    @StringJson()
    @JsonKey(name: 'service_code')
    @Default('')
    String serviceCode,
    @StringJson()
    @JsonKey(name: 'service_name')
    @Default('')
    String serviceName,
    @StringOrNullJson() String? zone,
    @DoubleJson() @JsonKey(name: 'weight_kg') @Default(0) double weightKg,
    @DoubleJson() @Default(0) double cost,
    @IntJson() @JsonKey(name: 'etd_min_days') @Default(0) int etdMinDays,
    @IntJson() @JsonKey(name: 'etd_max_days') @Default(0) int etdMaxDays,
  }) = _ShippingOptionModel;

  factory ShippingOptionModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingOptionModelFromJson(json);

  /// Kunci unik satu opsi dalam satu toko.
  String get key => '$courierCode/$serviceCode';

  /// Estimasi tiba, mis. "3–7 hari". Satu angka kalau min dan max sama.
  String get etdLabel {
    if (etdMinDays == etdMaxDays) return '$etdMinDays hari';
    return '$etdMinDays–$etdMaxDays hari';
  }
}

/// Hasil `PATCH /checkout/sessions/{id}/shipping`.
///
/// Membawa total terbaru supaya layar tidak perlu menghitung ongkir sendiri.
@freezed
abstract class ShippingSelectionResult with _$ShippingSelectionResult {
  const factory ShippingSelectionResult({
    @JsonKey(name: 'selected_couriers') Map<String, dynamic>? selectedCouriers,
    @DoubleJson()
    @JsonKey(name: 'shipping_total')
    @Default(0)
    double shippingTotal,
    @DoubleJson() @JsonKey(name: 'grand_total') @Default(0) double grandTotal,
  }) = _ShippingSelectionResult;

  factory ShippingSelectionResult.fromJson(Map<String, dynamic> json) =>
      _$ShippingSelectionResultFromJson(json);
}

/// Hasil `POST /checkout/sessions/{id}/confirm`.
///
/// ⚠️ [orderIds] adalah **array**: keranjang multi-toko pecah jadi satu order
/// per toko, tapi tetap satu [paymentTransactionId]. Jangan memodelkannya
/// sebagai satu order.
@freezed
abstract class CheckoutConfirmResult with _$CheckoutConfirmResult {
  const CheckoutConfirmResult._();

  const factory CheckoutConfirmResult({
    @JsonKey(name: 'order_ids') @Default(<int>[]) List<int> orderIds,
    @IntOrNullJson()
    @JsonKey(name: 'payment_transaction_id')
    int? paymentTransactionId,

    // --- kontrak YANG DIUSULKAN untuk bayar via Xpedia Wallet (docs/22 #1–#2)
    //
    // Belum dikirim server; di debug disisipkan mock
    // (`checkout_mock_routes.dart`). Pada alur lama ketiganya tidak ada, jadi
    // default-nya harus berarti "belum dibayar".

    /// `true` kalau konfirmasi **sekaligus membayar** dari saldo Wallet.
    /// `false` di alur lama: order masih harus dibayar di layar pembayaran.
    @BoolJson() @Default(false) bool paid,

    /// Baris `wallet_transactions` hasil pendebitan.
    @IntOrNullJson()
    @JsonKey(name: 'wallet_transaction_id')
    int? walletTransactionId,

    /// Saldo sesudah dipotong — ditampilkan di layar sukses supaya pembeli
    /// tidak perlu membuka dompet untuk memastikannya.
    @DoubleOrNullJson() @JsonKey(name: 'balance_after') double? balanceAfter,
  }) = _CheckoutConfirmResult;

  factory CheckoutConfirmResult.fromJson(Map<String, dynamic> json) =>
      _$CheckoutConfirmResultFromJson(json);

  bool get isMultiStore => orderIds.length > 1;
}

/// Ringkasan pembayaran Xpedia Wallet untuk satu sesi checkout —
/// **kontrak yang diusulkan**, `GET /checkout/sessions/{id}/wallet-summary`.
///
/// 🔴 Endpoint ini **belum ada** di marketplace-api (docs/22 #1: checkout
/// wajib Wallet). Di debug dijawab mock; di build yang mock-nya mati, rute
/// tak dikenal dibalas 404 HTML (`DataError.isRouteNotFound`) dan checkout
/// kembali ke pemilih metode pembayaran lama. Jadi begitu backend
/// membangunnya dengan bentuk ini, alur Wallet menyala sendiri.
///
/// Kenapa dihitung server, bukan dirakit aplikasi dari `GET /wallet` +
/// `grand_total`: saldo yang **boleh dipakai** (dikurangi saldo tertahan),
/// total final (ongkir + voucher), dan apakah PIN sudah dibuat hanya diketahui
/// server — dan `GET /wallet` sama sekali tidak memberi tahu soal PIN
/// (CLAUDE.md, "Dompet"). Menghitungnya di dua tempat mengundang layar yang
/// bilang "saldo cukup" lalu server menolak.
@freezed
abstract class WalletSummaryModel with _$WalletSummaryModel {
  const WalletSummaryModel._();

  const factory WalletSummaryModel({
    /// Saldo yang bisa dipakai membayar (sudah dikurangi saldo tertahan).
    @DoubleJson()
    @JsonKey(name: 'wallet_balance')
    @Default(0)
    double walletBalance,

    /// Sama dengan `grand_total` sesi — sudah termasuk ongkir dan voucher.
    @DoubleJson() @JsonKey(name: 'grand_total') @Default(0) double grandTotal,

    /// `max(0, grand_total − wallet_balance)`.
    @DoubleJson() @Default(0) double shortfall,
    @BoolJson() @JsonKey(name: 'can_pay') @Default(false) bool canPay,

    /// Minimum top up (blueprint: Rp 10.000). Dikirim server supaya tidak
    /// hardcoded di dua tempat seperti minimum penarikan.
    @DoubleJson() @JsonKey(name: 'min_topup') @Default(10000) double minTopup,

    /// Sudahkah PIN Wallet dibuat. Tanpa field ini aplikasi tidak punya cara
    /// mengetahuinya sebelum pembayaran ditolak.
    @BoolJson() @JsonKey(name: 'pin_set') @Default(false) bool pinSet,
  }) = _WalletSummaryModel;

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$WalletSummaryModelFromJson(json);

  bool get isInsufficient => !canPay && shortfall > 0;

  /// Nominal top up yang disarankan: selisihnya, dibulatkan ke atas ke
  /// ribuan, dan tidak pernah di bawah minimum.
  double get suggestedTopup {
    final rounded = (shortfall / 1000).ceil() * 1000.0;
    return rounded < minTopup ? minTopup : rounded;
  }
}

/// Kode error **yang diusulkan** untuk bayar via Wallet. Belum ada di
/// `ApiErrorCode` karena backend belum mengirimnya — pindahkan ke sana (dan
/// ke `errorMessageFor`) begitu endpointnya dibangun.
abstract final class WalletPayErrorCode {
  /// PIN salah. `details.attempts_left` = sisa percobaan sebelum 429.
  static const invalidPin = 'INVALID_PIN';

  /// Pembeli belum pernah membuat PIN Wallet.
  static const pinNotSet = 'PIN_NOT_SET';
}

/// Format sisa waktu reservasi untuk hitung mundur di layar.
String formatReservationLeft(Duration? left) => formatCountdown(left);
