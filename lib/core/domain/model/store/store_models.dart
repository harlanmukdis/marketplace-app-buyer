import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/format_helper.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'store_models.freezed.dart';
part 'store_models.g.dart';

/// Profil publik toko dari `GET /stores/{id}`.
///
/// ⚠️ **[ratingAvg] bukan rating yang benar menurut blueprint.** Kolom itu
/// diisi dari form rating toko terpisah (`POST /orders/{id}/rating`),
/// sedangkan blueprint menuntut rata-rata **seluruh ulasan produk terverifikasi**
/// toko itu (docs/22 #7). Angka yang benar ada di
/// [StorePerformanceModel.ratingAverage] — pakai itu di storefront.
@freezed
abstract class StoreModel with _$StoreModel {
  const StoreModel._();

  const factory StoreModel({
    @IntJson() required int id,
    @StringJson() @Default('') String name,
    @StringJson() @Default('') String slug,
    @StringOrNullJson() String? description,
    @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
    @StringOrNullJson() @JsonKey(name: 'banner_url') String? bannerUrl,
    @DoubleJson() @JsonKey(name: 'rating_avg') @Default(0) double ratingAvg,
    @IntJson() @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @IntJson() @JsonKey(name: 'follower_count') @Default(0) int followerCount,
    @ServerDateTimeJson() @JsonKey(name: 'opened_at') DateTime? openedAt,

    /// `unverified`, `verified_individual`, `verified_company`,
    /// `official_store`, `managed_by_xpedia` (blueprint Seller Ch.2).
    @StringJson()
    @JsonKey(name: 'primary_status')
    @Default('unverified')
    String primaryStatus,

    /// Xpedia Signature — lencana yang **diberikan**, tidak pernah dibeli.
    @BoolJson()
    @JsonKey(name: 'has_signature_badge')
    @Default(false)
    bool hasSignatureBadge,
    @BoolJson() @JsonKey(name: 'is_following') @Default(false) bool isFollowing,
  }) = _StoreModel;

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  SellerStatus get sellerStatus => SellerStatus.parse(primaryStatus);
}

/// Primary Seller Status (blueprint Seller Ch.2), ditampilkan di samping nama
/// toko di kartu produk, keranjang, dan storefront.
enum SellerStatus {
  unverified(null),
  verifiedIndividual('Verified'),
  verifiedCompany('Verified'),
  officialStore('Official Store'),
  managedByXpedia('Dikelola Xpedia');

  const SellerStatus(this.label);

  /// `null` untuk toko belum terverifikasi — tidak ada lencana.
  final String? label;

  bool get isOfficial => this == officialStore || this == managedByXpedia;

  static SellerStatus parse(String? raw) => switch (raw) {
        'verified_individual' => verifiedIndividual,
        'verified_company' => verifiedCompany,
        'official_store' => officialStore,
        'managed_by_xpedia' => managedByXpedia,
        _ => unverified,
      };
}

/// Transparansi toko dari `GET /stores/{id}/partners-performance` (publik).
///
/// Berbeda dari mayoritas API, **seluruh angkanya dikirim sebagai number
/// asli**. `checkout_from_live` selalu `null` di server — belum ada yang
/// mengisinya — jadi tidak dimodelkan.
///
/// 🔶 `service_performance.online_status` juga selalu `null` (komentar
/// backend: "codebase ini gak punya field online/last-active sama sekali").
/// Aplikasi membaca kontrak usulan — `online_status` (`online`/`offline`) +
/// `last_active_at` — yang di debug disisipkan mock ke respons sungguhan
/// (`meta.mock_fields`). Begitu backend mengisinya, mock berhenti menimpa.
class StorePerformanceModel {
  const StorePerformanceModel({
    required this.ratingAverage,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.totalOrders,
    required this.successRatePercent,
    required this.cancellationRatePercent,
    required this.responseRatePercent,
    this.avgReplyMinutes,
    this.onlineStatus,
    this.lastActiveAt,
  });

  /// Rata-rata ulasan produk toko — **rating toko menurut blueprint**.
  final double ratingAverage;
  final int totalReviews;

  /// Bintang → jumlah ulasan.
  final Map<int, int> ratingDistribution;
  final int totalOrders;
  final double successRatePercent;
  final double cancellationRatePercent;
  final double responseRatePercent;
  final int? avgReplyMinutes;

  /// `online` / `offline`; `null` = server belum punya datanya (keadaan
  /// sungguhan hari ini) — metrik "Online" disembunyikan, bukan ditebak.
  final String? onlineStatus;

  /// Terakhir aktif, untuk toko yang sedang offline.
  final DateTime? lastActiveAt;

  bool get isOnline => onlineStatus == 'online';

  bool get hasOnlineStatus =>
      onlineStatus == 'online' || onlineStatus == 'offline';

  /// Toko tanpa ulasan tidak menampilkan bintang sama sekali — bukan "0,0"
  /// (design_buyer.md §5 no. 9).
  bool get hasRating => totalReviews > 0;

  factory StorePerformanceModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> section(String key) => json[key] is Map
        ? Map<String, dynamic>.from(json[key] as Map)
        : const {};
    final rating = section('rating');
    final order = section('order_performance');
    final service = section('service_performance');
    final distribution = <int, int>{};
    final raw = rating['distribution'];
    if (raw is List) {
      for (final row in raw.whereType<Map>()) {
        final star = asIntOrNull(row['rating']);
        if (star != null) distribution[star] = asInt(row['count']);
      }
    }
    return StorePerformanceModel(
      ratingAverage: asDouble(rating['average']),
      totalReviews: asInt(rating['total_reviews']),
      ratingDistribution: distribution,
      totalOrders: asInt(order['total_orders']),
      successRatePercent: asDouble(order['success_rate_percent']),
      cancellationRatePercent: asDouble(order['cancellation_rate_percent']),
      responseRatePercent: asDouble(service['response_rate_percent']),
      avgReplyMinutes: asDoubleOrNull(service['avg_reply_minutes'])?.round(),
      onlineStatus: asStringOrNull(service['online_status']),
      lastActiveAt:
          parseServerInstant(asStringOrNull(service['last_active_at'])),
    );
  }
}

/// Satu toko di `GET /me/following`.
///
/// Barisnya **tidak membawa** `primary_status` maupun jumlah produk — hanya
/// kolom ringkas. Lencana status baru muncul di storefront.
@freezed
abstract class FollowedStoreModel with _$FollowedStoreModel {
  const factory FollowedStoreModel({
    @IntJson() required int id,
    @StringJson() @Default('') String name,
    @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
    @DoubleJson() @JsonKey(name: 'rating_avg') @Default(0) double ratingAvg,
    @IntJson() @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @ServerDateTimeJson() @JsonKey(name: 'followed_at') DateTime? followedAt,
  }) = _FollowedStoreModel;

  factory FollowedStoreModel.fromJson(Map<String, dynamic> json) =>
      _$FollowedStoreModelFromJson(json);
}
