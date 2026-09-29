import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'live_session_model.freezed.dart';
part 'live_session_model.g.dart';

/// Satu sesi live commerce di daftar **sisi pembeli**.
///
/// 🔶 **Kontrak usulan — endpoint daftarnya belum ada.** Backend punya modul
/// `live_commerce` (tabel `live_sessions`, `GET /live-sessions/{id}` publik,
/// dan rute penjual untuk membuat/memulai sesi), tapi **tidak ada rute untuk
/// menampilkan sesi yang sedang tayang**. Aplikasi memanggil
/// `GET /live-sessions?status=&store_id=&page=` (lihat
/// `assets/mock/pending_api/README.md`, bagian Discovery), dan di debug
/// dijawab mock.
///
/// Nama kolom mengikuti tabel `live_sessions` yang sudah ada
/// (`thumbnail_url`, `viewer_count`, `started_at`, `scheduled_at`, `status`)
/// supaya backend cukup menambah join ke `stores` dan dua kolom agregat:
/// [storeName], [promoLabel], [soldCount].
@freezed
abstract class LiveSessionModel with _$LiveSessionModel {
  const LiveSessionModel._();

  const factory LiveSessionModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'store_id') @Default(0) int storeId,
    @StringJson() @JsonKey(name: 'store_name') @Default('') String storeName,
    @StringJson() @Default('') String title,
    @StringOrNullJson() @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,

    /// `scheduled` / `live` / `ended` / `cancelled` (ENUM `live_sessions.status`).
    @StringJson() @Default('live') String status,
    @IntJson() @JsonKey(name: 'viewer_count') @Default(0) int viewerCount,
    @ServerDateTimeJson() @JsonKey(name: 'started_at') DateTime? startedAt,
    @ServerDateTimeJson() @JsonKey(name: 'scheduled_at') DateTime? scheduledAt,

    /// Label promo singkat dari penjual ("Diskon 50%"). Usulan kolom baru.
    @StringOrNullJson() @JsonKey(name: 'promo_label') String? promoLabel,

    /// Unit terjual selama sesi. ⚠️ Atribusi order ke sesi live **belum
    /// dilacak** backend (`Live_model::update_session_metrics`), jadi angka ini
    /// butuh pekerjaan backend tersendiri.
    @IntJson() @JsonKey(name: 'sold_count') @Default(0) int soldCount,
  }) = _LiveSessionModel;

  factory LiveSessionModel.fromJson(Map<String, dynamic> json) =>
      _$LiveSessionModelFromJson(json);

  bool get isLive => status == 'live';

  bool get isScheduled => status == 'scheduled';
}
