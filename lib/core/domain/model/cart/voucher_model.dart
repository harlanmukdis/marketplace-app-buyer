import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'voucher_model.freezed.dart';
part 'voucher_model.g.dart';

/// Voucher yang sudah **diklaim** pembeli, dari `GET /me/vouchers`.
///
/// Servernya `SELECT v.*, uvc.claimed_at` — jadi field = kolom tabel
/// `vouchers` (`database/schema/09_promotion_engine.sql`) ditambah
/// `claimed_at`. Seperti kolom MySQL lain, angka dan desimalnya datang
/// sebagai **string**.
///
/// ⚠️ Belum pernah teramati berisi: tidak ada voucher yang di-seed, jadi
/// `GET /me/vouchers` selalu `[]` di dev. Bentuknya diturunkan dari query
/// backend (`Promotion_model::list_claimed_vouchers`), bukan dari respons.
///
/// Klaim **tidak** memasang voucher ke keranjang: klaim menyimpan ke
/// `user_voucher_claims`, memasang menulis ke `cart_applied_vouchers`
/// (`POST /cart/apply-voucher`). Dua langkah itu terpisah di server, dan
/// layar voucher memperlakukannya terpisah juga.
@freezed
abstract class VoucherModel with _$VoucherModel {
  const VoucherModel._();

  const factory VoucherModel({
    @IntJson() @Default(0) int id,

    /// `null` = voucher platform (berlaku lintas toko).
    @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
    @StringJson() @Default('') String code,
    @StringJson() @Default('') String name,

    /// `percentage` / `fixed` / `free_shipping` / `cashback`.
    @StringJson()
    @JsonKey(name: 'discount_type')
    @Default('')
    String discountType,
    @DoubleJson()
    @JsonKey(name: 'discount_value')
    @Default(0)
    double discountValue,
    @DoubleOrNullJson() @JsonKey(name: 'max_discount') double? maxDiscount,
    @DoubleJson() @JsonKey(name: 'min_spend') @Default(0) double minSpend,
    @ServerDateTimeJson() @JsonKey(name: 'valid_until') DateTime? validUntil,

    /// `active` / `inactive` / `expired`.
    @StringJson() @Default('active') String status,
    @ServerDateTimeJson() @JsonKey(name: 'claimed_at') DateTime? claimedAt,
  }) = _VoucherModel;

  factory VoucherModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherModelFromJson(json);

  bool get isShipping => discountType == 'free_shipping';
  bool get isCashback => discountType == 'cashback';
  bool get isPercentage => discountType == 'percentage';

  /// Voucher yang sudah lewat masa atau dinonaktifkan tetap ikut di
  /// `GET /me/vouchers` (query-nya tidak menyaring status) — tombol "Pakai"
  /// untuknya hanya akan dibalas `VOUCHER_INVALID`.
  bool get isUsable =>
      status == 'active' &&
      (validUntil == null || validUntil!.isAfter(DateTime.now()));
}

/// Kode error voucher yang dikirim server tapi belum ada di `ApiErrorCode`
/// (semuanya dari `Cart_model::validate_voucher` dan
/// `Promotion_model::claim_voucher`). Pindahkan ke sana — dan pesannya ke
/// `errorMessageFor` — kalau domain lain ikut membutuhkannya.
abstract final class VoucherErrorCode {
  static const quotaExceeded = 'VOUCHER_QUOTA_EXCEEDED';
  static const alreadyUsed = 'VOUCHER_ALREADY_USED';
  static const minSpendNotMet = 'VOUCHER_MIN_SPEND_NOT_MET';

  /// `POST /vouchers/claim` untuk voucher yang sudah diklaim — **409**, satu-
  /// satunya penolakan voucher yang bukan 422.
  static const alreadyClaimed = 'VOUCHER_ALREADY_CLAIMED';
}
