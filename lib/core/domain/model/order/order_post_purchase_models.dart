import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'order_post_purchase_models.freezed.dart';
part 'order_post_purchase_models.g.dart';

/// Alasan "Ajukan Pembatalan" (desain §3.15), dikirim sebagai **kode**, bukan
/// label.
///
/// Kode dipilih supaya backend bisa melaporkan dan menyaring alasan tanpa
/// mencocokkan teks bebas — berbeda dari `POST /orders/{id}/cancel` yang
/// menyimpan `reason` apa adanya.
enum CancellationReason {
  wrongAddress('wrong_address', 'Alamat salah'),
  wrongVariant('wrong_variant', 'Salah pilih varian'),
  changeOrder('change_order', 'Ingin ubah pesanan'),
  etaTooLong('eta_too_long', 'Estimasi terlalu lama'),
  changedMind('changed_mind', 'Tidak jadi membeli'),
  other('other', 'Lainnya');

  const CancellationReason(this.code, this.label);

  final String code;
  final String label;

  static CancellationReason? fromCode(String? raw) {
    for (final r in values) {
      if (r.code == raw) return r;
    }
    return null;
  }
}

/// Status permohonan pembatalan.
enum CancellationRequestStatus {
  /// Menunggu keputusan penjual (maks. 1x24 jam, [CancellationRequestModel.sellerResponseDeadline]).
  pending('pending'),

  /// Disetujui: pesanan dibatalkan dan dana kembali ke Xpedia Wallet.
  approved('approved'),

  /// Ditolak: pesanan tetap diproses dan dikirim.
  rejected('rejected'),

  unknown('');

  const CancellationRequestStatus(this.code);

  final String code;

  static CancellationRequestStatus fromCode(String? raw) {
    for (final s in values) {
      if (s.code == raw) return s;
    }
    return unknown;
  }
}

/// Permohonan pembatalan sesudah resi (docs/22 #3) —
/// `GET`/`POST /orders/{id}/cancellation-request`.
///
/// ⚠️ **Kontrak yang diusulkan, belum ada di backend.** Di build debug
/// dijawab `order_mock_routes.dart`; lihat `assets/mock/pending_api/README.md`.
@freezed
abstract class CancellationRequestModel with _$CancellationRequestModel {
  const CancellationRequestModel._();

  const factory CancellationRequestModel({
    @IntJson() required int id,
    @StringJson()
    @JsonKey(name: 'status')
    @Default('pending')
    String statusCode,

    /// Kode [CancellationReason].
    @StringJson() @Default('') String reason,
    @StringOrNullJson() String? note,

    /// Diisi penjual saat menolak.
    @StringOrNullJson()
    @JsonKey(name: 'rejection_reason')
    String? rejectionReason,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,

    /// Batas waktu penjual menjawab (desain: "1x24 jam").
    @ServerDateTimeJson()
    @JsonKey(name: 'seller_response_deadline')
    DateTime? sellerResponseDeadline,
    @ServerDateTimeJson() @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
  }) = _CancellationRequestModel;

  factory CancellationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CancellationRequestModelFromJson(json);

  CancellationRequestStatus get status =>
      CancellationRequestStatus.fromCode(statusCode);

  bool get isPending => status == CancellationRequestStatus.pending;

  /// Label alasan; kode tak dikenal ditampilkan apa adanya.
  String get reasonLabel =>
      CancellationReason.fromCode(reason)?.label ?? reason;
}

/// Polis Xpedia Secure+ milik satu pesanan.
///
/// Dua sumber:
/// * `POST /orders/{id}/insurance/opt-in` — **ada di backend**, membalas
///   `{id, premium_amount, tier}`;
/// * `GET /orders/{id}/insurance` — **belum ada** (diusulkan, di-mock), karena
///   tanpa itu aplikasi tidak bisa tahu apakah perlindungannya sudah aktif.
///
/// Nama kelasnya mengikuti tabel backend (`shipping_insurance_policies`);
/// **teks untuk pengguna tidak pernah memakai kata "asuransi"** (design §5) —
/// selalu "perlindungan".
@freezed
abstract class InsurancePolicyModel with _$InsurancePolicyModel {
  const InsurancePolicyModel._();

  const factory InsurancePolicyModel({
    @IntJson() @Default(0) int id,

    /// `basic` atau `secure_plus`.
    @StringJson() @Default('basic') String tier,
    @DoubleJson()
    @JsonKey(name: 'premium_amount')
    @Default(0)
    double premiumAmount,
    @DoubleOrNullJson()
    @JsonKey(name: 'coverage_amount')
    double? coverageAmount,

    /// `active`, `claimed`, `expired`. Balasan opt-in tidak membawanya —
    /// polis yang baru dibuat selalu `active` (default kolom).
    @StringJson() @Default('active') String status,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _InsurancePolicyModel;

  factory InsurancePolicyModel.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyModelFromJson(json);

  bool get isSecurePlus => tier == 'secure_plus';
  bool get isActive => status == 'active';
}

/// Hasil `POST /media/upload` (**ada di backend**).
///
/// ⚠️ [url] dirakit server dari `$config['base_url']` yang di repo masih
/// `http://localhost:8080/marketplace-api/` — jadi URL-nya **salah host**
/// sampai backend menyetelnya. Aplikasi meneruskannya apa adanya (URL itu
/// milik server, bukan untuk ditambal klien); pratinjau di layar memakai
/// berkas lokal, bukan URL ini.
@freezed
abstract class MediaUploadModel with _$MediaUploadModel {
  const MediaUploadModel._();

  const factory MediaUploadModel({
    @StringJson() @Default('') String url,
    @StringJson() @JsonKey(name: 'file_name') @Default('') String fileName,
    @DoubleJson() @JsonKey(name: 'file_size_kb') @Default(0) double fileSizeKb,
    @StringJson() @JsonKey(name: 'mime_type') @Default('') String mimeType,
  }) = _MediaUploadModel;

  factory MediaUploadModel.fromJson(Map<String, dynamic> json) =>
      _$MediaUploadModelFromJson(json);

  bool get isVideo => mimeType.startsWith('video/');
}
