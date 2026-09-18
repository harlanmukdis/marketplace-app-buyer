import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'payment_models.freezed.dart';
part 'payment_models.g.dart';

/// Metode pembayaran dari `GET /payment-methods` (publik).
///
/// ⚠️ **Metode dipilih saat `POST /checkout/sessions/{id}/confirm`, bukan saat
/// membayar.** Sudah diuji: field `payment_method` di body
/// `POST /payments/{txId}/pay` **diabaikan** — mengirim `qris` pada transaksi
/// yang dibuat dengan `virtual_account` tetap membalas instruksi VA. Jadi
/// pemilihan metode harus ada di layar checkout.
@freezed
abstract class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    @StringJson() @Default('') String code,
    @StringJson() @Default('') String name,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);
}

/// Transaksi pembayaran dari `GET /payments/{txId}`.
///
/// ⚠️ **`order_id` selalu `null`.** Transaksi menempel pada
/// [checkoutSessionId], bukan pada satu order — satu pembayaran menutup
/// **semua** order yang lahir dari sesi checkout itu. Jangan memakainya untuk
/// mencari order.
@freezed
abstract class PaymentModel with _$PaymentModel {
  const PaymentModel._();

  const factory PaymentModel({
    @IntJson() required int id,
    @StringOrNullJson() @JsonKey(name: 'checkout_session_id')
    String? checkoutSessionId,
    @StringJson() @JsonKey(name: 'payment_method') @Default('')
    String paymentMethod,
    @StringOrNullJson() String? provider,
    @StringOrNullJson() @JsonKey(name: 'provider_reference')
    String? providerReference,
    @DoubleJson() @Default(0) double amount,

    /// `pending` / `paid` / `expired` / `failed`.
    @StringJson() @Default('') String status,

    @ServerDateTimeJson() @JsonKey(name: 'paid_at') DateTime? paidAt,

    /// Tenggat bayar, 1 jam sesudah [createdAt]. Dulu UTC sementara
    /// [createdAt] WIB; backend sudah menyeragamkannya (commit `93c6a14`).
    @ServerDateTimeJson() @JsonKey(name: 'expired_at') DateTime? expiredAt,

    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';

  /// Sisa waktu membayar; `Duration.zero` kalau tenggatnya lewat.
  Duration? get timeLeft {
    final deadline = expiredAt;
    if (deadline == null) return null;
    final left = deadline.difference(DateTime.now().toUtc());
    return left.isNegative ? Duration.zero : left;
  }

  bool get isExpired => !isPaid && timeLeft == Duration.zero;
}

/// Instruksi membayar dari `POST /payments/{txId}/pay`.
///
/// ⚠️ **Bentuknya berbeda per metode**, dan tidak ada field penanda jenisnya:
///
/// * `qris` → `{qr_string, expires_at}`
/// * `virtual_account` dan lainnya → `{va_number, bank, expires_at}`
///
/// Karena itu seluruh field dibuat opsional dan jenisnya disimpulkan lewat
/// [kind] dari field mana yang terisi — bukan dari `payment_method`, yang
/// tidak ikut dikirim di balasan ini.
@freezed
abstract class PaymentInstructionModel with _$PaymentInstructionModel {
  const PaymentInstructionModel._();

  const factory PaymentInstructionModel({
    @StringOrNullJson() @JsonKey(name: 'qr_string') String? qrString,
    @StringOrNullJson() @JsonKey(name: 'va_number') String? vaNumber,
    @StringOrNullJson() String? bank,

    @ServerDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _PaymentInstructionModel;

  factory PaymentInstructionModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInstructionModelFromJson(json);

  PaymentInstructionKind get kind {
    if ((qrString ?? '').isNotEmpty) return PaymentInstructionKind.qris;
    if ((vaNumber ?? '').isNotEmpty) {
      return PaymentInstructionKind.virtualAccount;
    }
    return PaymentInstructionKind.unknown;
  }

  Duration? get timeLeft {
    final deadline = expiresAt;
    if (deadline == null) return null;
    final left = deadline.difference(DateTime.now().toUtc());
    return left.isNegative ? Duration.zero : left;
  }
}

/// Jenis instruksi bayar yang bisa dirender layar.
///
/// [unknown] bukan kegagalan: kalau backend menambah metode dengan bentuk
/// baru, layar menampilkan pesan "ikuti instruksi dari penyedia" daripada
/// kosong atau crash.
enum PaymentInstructionKind { qris, virtualAccount, unknown }
