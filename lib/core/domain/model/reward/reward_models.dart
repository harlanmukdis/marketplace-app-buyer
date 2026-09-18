import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'reward_models.freezed.dart';
part 'reward_models.g.dart';

/// Saldo poin **atau** koin, dari `GET /me/points` dan `GET /me/coins`.
///
/// Satu model untuk dua endpoint karena bentuknya benar-benar identik
/// (`get_or_create('user_points' | 'user_coins', …)` di server) — bukan dua
/// hal berbeda yang kebetulan mirip.
///
/// Barisnya **dibuat otomatis saat pertama dibaca**, sama seperti dompet, jadi
/// akun baru mendapat `balance: "0"`, bukan `404`.
@freezed
abstract class RewardBalanceModel with _$RewardBalanceModel {
  const RewardBalanceModel._();

  const factory RewardBalanceModel({
    @IntJson() @Default(0) int id,
    @IntJson() @Default(0) int balance,
    @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _RewardBalanceModel;

  factory RewardBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$RewardBalanceModelFromJson(json);

  bool get isEmpty => balance <= 0;
}

/// Satu tingkat loyalitas, dari `GET /loyalty/tiers` (publik) atau tersisip di
/// `GET /me/loyalty`.
@freezed
abstract class LoyaltyTierModel with _$LoyaltyTierModel {
  const LoyaltyTierModel._();

  const factory LoyaltyTierModel({
    @IntJson() @Default(0) int id,

    /// `bronze` / `silver` / `gold` / `platinum`.
    @StringJson() @Default('') String code,

    @StringJson() @Default('') String name,
    @IntJson() @JsonKey(name: 'min_points') @Default(0) int minPoints,

    /// Kolom `JSON` di database.
    ///
    /// ⚠️ **`null` untuk keempat tier yang di-seed**, jadi bentuk isinya belum
    /// pernah teramati. Dibaca lewat [JsonMapJson] supaya string berisi JSON
    /// maupun objek sungguhan sama-sama terserap — pola yang sama dengan
    /// kolom JSON lain di API ini.
    @JsonMapJson() Map<String, dynamic>? benefits,
  }) = _LoyaltyTierModel;

  factory LoyaltyTierModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyTierModelFromJson(json);

  bool get hasBenefits => benefits != null && benefits!.isNotEmpty;
}

/// Keanggotaan loyalitas pembeli, dari `GET /me/loyalty`.
///
/// Responsnya **sudah menyisipkan objek [tier]**, jadi layar status tidak
/// perlu memanggil `GET /loyalty/tiers` hanya untuk menampilkan nama tingkat.
/// Daftar tier tetap dibutuhkan untuk menghitung jarak ke tingkat berikutnya —
/// lihat [progressToward].
///
/// Barisnya juga **dibuat otomatis saat pertama dibaca**, selalu di tingkat
/// `bronze`.
@freezed
abstract class LoyaltyMembershipModel with _$LoyaltyMembershipModel {
  const LoyaltyMembershipModel._();

  const factory LoyaltyMembershipModel({
    @IntJson() @Default(0) int id,
    @IntJson() @JsonKey(name: 'loyalty_tier_id') @Default(0) int tierId,

    /// Poin yang dihitung untuk **naik tingkat**, terpisah dari saldo poin
    /// yang bisa ditukar (`user_points.balance`). Keduanya bisa berbeda karena
    /// menukar poin tidak menurunkan tingkat.
    @IntJson() @JsonKey(name: 'tier_points') @Default(0) int tierPoints,

    /// Masa berlaku tingkat, satu tahun sejak keanggotaan dibuat.
    ///
    /// Dulu field ini dikirim dalam UTC sementara [updatedAt] dalam WIB —
    /// pola yang sama dengan `expires_at` di checkout. Backend menyeragamkan
    /// zona waktunya di commit `93c6a14`, dan sudah diverifikasi ulang:
    /// selisihnya kini tepat satu tahun.
    @ServerDateTimeJson() @JsonKey(name: 'tier_valid_until')
    DateTime? validUntil,

    @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,

    /// Tingkat saat ini, sudah disisipkan server.
    LoyaltyTierModel? tier,
  }) = _LoyaltyMembershipModel;

  factory LoyaltyMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyMembershipModelFromJson(json);

  String get tierName => tier?.name ?? '—';
  String get tierCode => tier?.code ?? '';

  /// Tingkat berikutnya dari [tiers], `null` kalau sudah yang tertinggi.
  ///
  /// Dicari dari ambang terendah yang masih di atas [tierPoints] — bukan dari
  /// urutan id — supaya tetap benar kalau backend menyisipkan tingkat baru di
  /// tengah.
  LoyaltyTierModel? nextTier(List<LoyaltyTierModel> tiers) {
    final higher = tiers.where((t) => t.minPoints > tierPoints).toList()
      ..sort((a, b) => a.minPoints.compareTo(b.minPoints));
    return higher.isEmpty ? null : higher.first;
  }

  /// Sisa poin menuju [target].
  int pointsUntil(LoyaltyTierModel target) {
    final left = target.minPoints - tierPoints;
    return left < 0 ? 0 : left;
  }

  /// Kemajuan menuju [target], `0..1`.
  ///
  /// Dihitung dari ambang tingkat **sekarang**, bukan dari nol — kalau tidak,
  /// seorang Gold akan terlihat hampir kosong menuju Platinum padahal sudah
  /// menempuh sebagian besar jaraknya.
  double progressToward(LoyaltyTierModel target) {
    final floor = tier?.minPoints ?? 0;
    final span = target.minPoints - floor;
    if (span <= 0) return 1;
    final done = (tierPoints - floor) / span;
    return done.clamp(0, 1).toDouble();
  }
}

/// Status satu baris cashback.
enum CashbackStatus {
  pending('pending', 'Menunggu'),
  credited('credited', 'Masuk saldo'),
  expired('expired', 'Kedaluwarsa'),

  /// Status yang belum dikenal aplikasi — backend boleh menambah, dan barisnya
  /// tetap harus tampil.
  unknown('', 'Status lain');

  const CashbackStatus(this.code, this.label);

  final String code;
  final String label;

  static CashbackStatus fromCode(String? raw) {
    for (final status in values) {
      if (status.code == raw) return status;
    }
    return unknown;
  }
}

/// Satu baris cashback, dari `GET /me/cashback`.
///
/// ⚠️ **Bentuknya diturunkan dari skema** (`list_cashback` melakukan
/// `SELECT *` pada `cashback_transactions`, jadi kolom = field): endpointnya
/// mengembalikan `[]` di dev karena cashback baru terbit lewat alur pesanan
/// yang selesai, dan itu butuh aksi penjual.
@freezed
abstract class CashbackTransactionModel with _$CashbackTransactionModel {
  const CashbackTransactionModel._();

  const factory CashbackTransactionModel({
    @IntJson() required int id,

    /// `null` untuk cashback yang tidak berasal dari pesanan.
    @IntOrNullJson() @JsonKey(name: 'order_id') int? orderId,

    @DoubleJson() @Default(0) double amount,

    /// Kode status mentah; pakai [status] untuk logika.
    @StringJson() @JsonKey(name: 'status') @Default('') String statusCode,

    @ServerDateTimeJson() @JsonKey(name: 'credited_at') DateTime? creditedAt,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CashbackTransactionModel;

  factory CashbackTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$CashbackTransactionModelFromJson(json);

  CashbackStatus get status => CashbackStatus.fromCode(statusCode);

  /// Label yang layak tampil; status tak dikenal jatuh ke kodenya sendiri
  /// daripada tulisan "Status lain" yang tidak menjelaskan apa pun.
  String get statusLabel =>
      status == CashbackStatus.unknown && statusCode.isNotEmpty
          ? statusCode
          : status.label;

  bool get isCredited => status == CashbackStatus.credited;
}

/// Rincian estimasi koin dari `POST /checkout/calculate`.
@freezed
abstract class RewardBreakdownModel with _$RewardBreakdownModel {
  const RewardBreakdownModel._();

  const factory RewardBreakdownModel({
    @IntJson() @Default(0) int base,
    @IntJson() @JsonKey(name: 'tier_bonus') @Default(0) int tierBonus,
    @IntJson() @JsonKey(name: 'payment_method_bonus') @Default(0)
    int paymentMethodBonus,
    @IntJson() @JsonKey(name: 'voucher_cashback') @Default(0)
    int voucherCashback,
  }) = _RewardBreakdownModel;

  factory RewardBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$RewardBreakdownModelFromJson(json);

  bool get hasBonus =>
      tierBonus > 0 || paymentMethodBonus > 0 || voucherCashback > 0;
}

/// Estimasi koin dari `POST /checkout/calculate`.
///
/// Endpoint ini menghitung dari isi keranjang **tanpa membuat sesi checkout
/// dan tanpa mereservasi stok**, jadi aman dipanggil dari layar keranjang.
///
/// 🔴 **Ini estimasi, bukan saldo.** `status: "pending_release"` berarti
/// koinnya belum masuk — baru dilepas saat pesanan selesai, dan dibatalkan
/// kalau pesanan batal (tabel `order_pending_rewards`). Menampilkannya sebagai
/// saldo membuat pembeli mengira sudah punya koin yang belum tentu terbit.
@freezed
abstract class RewardPreviewModel with _$RewardPreviewModel {
  const RewardPreviewModel._();

  const factory RewardPreviewModel({
    @DoubleJson() @Default(0) double subtotal,
    @IntJson() @JsonKey(name: 'estimated_cashback_coins') @Default(0)
    int estimatedCoins,
    RewardBreakdownModel? breakdown,

    /// Kode tingkat loyalitas yang dipakai menghitung, mis. `bronze`.
    @StringJson() @Default('') String tier,

    /// `pending_release` / `released` / `cancelled`.
    @StringJson() @Default('') String status,
  }) = _RewardPreviewModel;

  /// Merakit dari respons `POST /checkout/calculate`, yang menaruh angka
  /// rewardnya **bersarang di dalam `rewards`** sementara `subtotal` ada di
  /// tingkat teratas.
  factory RewardPreviewModel.fromResponse(Map<String, dynamic> json) {
    final rewards = json['rewards'];
    final map = rewards is Map
        ? Map<String, dynamic>.from(rewards)
        : <String, dynamic>{};
    return RewardPreviewModel.fromJson({...map, 'subtotal': json['subtotal']});
  }

  factory RewardPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$RewardPreviewModelFromJson(json);

  bool get hasReward => estimatedCoins > 0;

  /// `true` selama koinnya belum benar-benar masuk saldo.
  bool get isPending => status == 'pending_release';
}
