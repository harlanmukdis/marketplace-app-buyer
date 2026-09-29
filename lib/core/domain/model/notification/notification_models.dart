import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// Golongan notifikasi, disimpulkan dari kolom `notifications.type`.
///
/// Kolomnya `VARCHAR(80)` bebas, bukan `ENUM`, jadi daftar ini **tidak pernah
/// lengkap** — ia hanya memilih ikon dan label yang lebih baik daripada
/// generik. Jenis yang belum dikenal tetap tampil utuh memakai `title`/`body`
/// dari server, karena keduanya memang sudah berupa kalimat siap baca.
///
/// Kode yang tercantum di `notification_templates.code` sebagai niat backend:
/// `order_paid`, `order_shipped`, `voucher_expiring`, `chat_new_message`.
/// Yang benar-benar pernah terbit sejauh ini hanya `staff_invitation`.
enum NotificationKind {
  order('order'),
  payment('payment'),
  shipment('shipment'),
  chat('chat'),
  promo('promo'),
  account('account'),
  other('other');

  const NotificationKind(this.code);

  final String code;

  /// Memetakan `type` mentah ke golongan lewat **pencocokan kata kunci**,
  /// bukan daftar tertutup.
  ///
  /// Sengaja longgar: backend menulis `type` bebas, dan jenis baru muncul tanpa
  /// aba-aba. Menuntut kecocokan persis akan membuat notifikasi baru kehilangan
  /// ikonnya, sementara pencocokan kata kunci masih menebak dengan benar untuk
  /// `order_cancelled`, `refund_approved`, dan seterusnya.
  ///
  /// **Urutannya berarti**, karena satu `type` bisa cocok beberapa kata kunci:
  /// `order_shipped` dan `order_paid` sama-sama mengandung `order`, tapi
  /// golongan yang lebih spesifik memberi ikon yang lebih informatif — jadi
  /// pengiriman dan pembayaran diperiksa **sebelum** pesanan.
  ///
  /// Perhatikan `paid` terdaftar terpisah dari `pay`: kata "paid" **tidak**
  /// mengandung "pay", jadi mengandalkan satu di antaranya saja akan meleset
  /// pada `order_paid` — persis kode yang dijanjikan `notification_templates`.
  static NotificationKind fromType(String? raw) {
    final type = (raw ?? '').toLowerCase();
    if (type.isEmpty) return other;

    // List, bukan Map, supaya urutan pemeriksaannya terbaca sebagai bagian
    // dari kontrak — bukan bergantung pada urutan iterasi sebuah koleksi.
    const keywords = <(NotificationKind, List<String>)>[
      (chat, ['chat', 'message', 'pesan']),
      (shipment, ['ship', 'deliver', 'tracking', 'resi']),
      (payment, ['paid', 'pay', 'refund', 'invoice', 'tagihan']),
      (order, ['order', 'pesanan']),
      (promo, ['voucher', 'promo', 'campaign', 'flash', 'discount', 'diskon']),
      (account, ['staff', 'invitation', 'account', 'password', 'verif']),
    ];

    for (final (kind, words) in keywords) {
      if (words.any(type.contains)) return kind;
    }
    return other;
  }
}

/// Satu notifikasi dari `GET /me/notifications`.
///
/// Respons endpoint ini adalah `SELECT *` mentah dari tabel `notifications`,
/// jadi field model ini persis kolomnya — tidak ada relasi yang ikut, dan
/// tidak ada `meta`.
@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    @IntJson() required int id,

    /// Jenis mentah; pakai [kind] untuk memilih ikon.
    @StringJson() @JsonKey(name: 'type') @Default('') String typeCode,
    @StringJson() @Default('') String title,
    @StringJson() @Default('') String body,

    /// Muatan deep-link, mis. `{"order_id": 123}`.
    ///
    /// ⚠️ **Datang sebagai string berisi JSON, bukan objek.** Kolomnya
    /// bertipe `JSON` di MySQL tapi diteruskan apa adanya oleh driver PHP —
    /// jebakan yang sama persis dengan `selected_couriers` di sesi checkout,
    /// dan alasan field ini memakai [JsonMapJson].
    @JsonMapJson() Map<String, dynamic>? data,
    @BoolJson() @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  NotificationKind get kind => NotificationKind.fromType(typeCode);

  bool get isUnread => !isRead;

  /// Id pesanan yang dituju notifikasi ini, kalau ada.
  ///
  /// Nilai di dalam `data` **ikut aturan angka-sebagai-string** seperti sisa
  /// API — terbukti pada `{"store_id":"1"}` yang dikirim undangan staf — jadi
  /// pembacaannya lewat [asIntOrNull], bukan cast langsung.
  int? get orderId => asIntOrNull(data?['order_id']);

  /// Id produk yang dituju notifikasi ini, kalau ada.
  int? get productId => asIntOrNull(data?['product_id']);

  /// `true` kalau notifikasi ini punya tujuan yang bisa dibuka aplikasi.
  ///
  /// Dipakai layar untuk memutuskan apakah barisnya bisa ditekan. Tanpa ini,
  /// setiap baris akan terlihat bisa ditekan padahal sebagian besar tidak
  /// membawa tujuan apa pun.
  bool get hasDestination => orderId != null || productId != null;
}
