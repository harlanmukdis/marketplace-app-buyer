import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'support_models.freezed.dart';
part 'support_models.g.dart';

/// Kategori tiket Xpedia 911 — `ENUM` tertutup di server; nilai lain dibalas
/// `422 VALIDATION_ERROR`.
enum SupportCategory {
  orderTransaction('order_transaction', 'Pesanan & Transaksi'),
  accountSecurity('account_security', 'Akun & Keamanan'),
  paymentWallet('payment_wallet', 'Pembayaran & Wallet'),
  reportViolation('report_violation', 'Laporkan Pelanggaran');

  const SupportCategory(this.code, this.label);

  final String code;
  final String label;

  static SupportCategory? parse(String? raw) {
    for (final c in values) {
      if (c.code == raw) return c;
    }
    return null;
  }
}

/// Tiket Xpedia 911, dari `GET /support-tickets` dan `GET /support-tickets/{id}`.
///
/// Xpedia 911 adalah **satu-satunya** merek layanan pelanggan di aplikasi —
/// tidak ada "Help Center" terpisah (design_buyer.md §5 no. 11).
@freezed
abstract class SupportTicketModel with _$SupportTicketModel {
  const SupportTicketModel._();

  const factory SupportTicketModel({
    @IntJson() required int id,
    @StringJson()
    @JsonKey(name: 'ticket_number')
    @Default('')
    String ticketNumber,
    @StringJson() @Default('') String category,
    @StringJson() @Default('') String subject,
    @StringOrNullJson() String? description,
    @IntOrNullJson() @JsonKey(name: 'related_order_id') int? relatedOrderId,

    /// `open`, `in_progress`, `resolved`, `closed`.
    @StringJson() @Default('open') String status,
    @ServerDateTimeJson() @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _SupportTicketModel;

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketModelFromJson(json);

  SupportCategory? get categoryValue => SupportCategory.parse(category);

  /// Tiket selesai/ditutup tidak menerima pesan baru — server menolaknya
  /// dan menyuruh membuat tiket baru.
  bool get acceptsMessages => status == 'open' || status == 'in_progress';

  String get statusLabel => switch (status) {
        'open' => 'Terbuka',
        'in_progress' => 'Diproses',
        'resolved' => 'Selesai',
        'closed' => 'Ditutup',
        _ => status,
      };
}

/// Satu pesan dalam tiket. ⚠️ `description` tiket **tidak** ikut tersimpan
/// sebagai pesan pertama — layar menampilkannya terpisah di atas percakapan.
@freezed
abstract class SupportMessageModel with _$SupportMessageModel {
  const factory SupportMessageModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'sender_user_id') @Default(0) int senderUserId,
    @BoolJson()
    @JsonKey(name: 'is_admin_reply')
    @Default(false)
    bool isAdminReply,
    @StringJson() @Default('') String message,
    @StringOrNullJson() @JsonKey(name: 'attachment_url') String? attachmentUrl,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _SupportMessageModel;

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SupportMessageModelFromJson(json);
}
