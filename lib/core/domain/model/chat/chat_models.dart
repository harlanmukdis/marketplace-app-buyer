import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

/// Satu percakapan pembeli↔toko, dari `GET /chat/conversations`.
///
/// Responsnya `SELECT cc.*` di-join ke `stores` untuk [storeName], jadi daftar
/// percakapan **tidak perlu** menembak `/stores/{id}` per baris.
@freezed
abstract class ChatConversationModel with _$ChatConversationModel {
  const ChatConversationModel._();

  const factory ChatConversationModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'store_id') @Default(0) int storeId,
    @StringJson() @JsonKey(name: 'store_name') @Default('') String storeName,

    /// `null` untuk percakapan yang belum berisi pesan apa pun — dan itu
    /// mungkin terjadi, karena `POST /chat/conversations` membuat barisnya
    /// lebih dulu tanpa pesan.
    @ServerDateTimeJson()
    @JsonKey(name: 'last_message_at')
    DateTime? lastMessageAt,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,

    /// 🔴 **Selalu `0`, dan jangan dipercaya.**
    ///
    /// Kolomnya ada di skema, tapi **tidak ada satu pun kode di backend yang
    /// pernah menaikkan atau mengosongkannya** — `send_message` hanya
    /// memperbarui `last_message_at`, dan `mark_read` hanya menyentuh
    /// `chat_messages.read_at`. Menampilkannya sebagai lencana "belum dibaca"
    /// berarti memasang angka yang permanen nol.
    ///
    /// Dimodelkan supaya keberadaannya terdokumentasi — bukan untuk dipakai.
    /// Lihat [hasReliableUnreadCount].
    @IntJson()
    @JsonKey(name: 'buyer_unread_count')
    @Default(0)
    int buyerUnreadCount,
  }) = _ChatConversationModel;

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationModelFromJson(json);

  /// Percakapan yang belum berisi pesan sama sekali.
  bool get isEmpty => lastMessageAt == null;

  /// Selalu `false` di backend ini — penanda eksplisit supaya tidak ada yang
  /// tergoda memakai [buyerUnreadCount] sebagai lencana.
  static const bool hasReliableUnreadCount = false;

  /// Waktu untuk mengurutkan dan menampilkan; jatuh ke [createdAt] untuk
  /// percakapan yang belum berisi pesan.
  DateTime? get sortedAt => lastMessageAt ?? createdAt;
}

/// Jenis pesan, sesuai `ENUM` kolom `chat_messages.message_type`.
///
/// Sejak backend v1.x `send_message()` **menolak** jenis di luar
/// `text|image|product_share|order_share` dengan `422 VALIDATION_ERROR`, dan
/// `video` dihapus dari ENUM (blueprint: tidak ada video/dokumen/audio di
/// chat). Dulu nilai asing tersimpan sebagai string kosong — pesan lama
/// semacam itu masih bisa ada di database, jadi [unknown] dan [video] tetap
/// dipertahankan **untuk membaca**, tidak pernah untuk mengirim.
enum ChatMessageType {
  text('text'),
  image('image'),

  /// Hanya untuk membaca pesan lama; server kini menolaknya.
  video('video'),
  productShare('product_share'),
  orderShare('order_share'),

  /// Jenis kosong atau tak dikenal. Dirender sebagai teks biasa kalau
  /// [ChatMessageModel.content] terisi — lebih baik menampilkan isinya
  /// daripada menyembunyikan pesan yang sebenarnya terbaca.
  unknown('');

  const ChatMessageType(this.code);

  final String code;

  static ChatMessageType fromCode(String? raw) {
    for (final type in values) {
      if (type.code == raw && type != unknown) return type;
    }
    return unknown;
  }
}

/// Satu pesan, dari `GET /chat/conversations/{id}/messages`.
@freezed
abstract class ChatMessageModel with _$ChatMessageModel {
  const ChatMessageModel._();

  const factory ChatMessageModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'sender_user_id') @Default(0) int senderUserId,

    /// Kode jenis mentah; pakai [type] untuk logika.
    @StringJson() @JsonKey(name: 'message_type') @Default('') String typeCode,

    /// **Boleh `null`.** Server menerima `POST` tanpa `content` dan
    /// membalasnya `201` — tidak ada validasi sama sekali.
    @StringOrNullJson() String? content,
    @IntOrNullJson() @JsonKey(name: 'shared_product_id') int? sharedProductId,
    @IntOrNullJson() @JsonKey(name: 'shared_order_id') int? sharedOrderId,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,

    /// Terisi saat **lawan bicara** membuka percakapan.
    ///
    /// `mark_read` hanya menyentuh pesan yang `sender_user_id`-nya **bukan**
    /// pemanggil, jadi pesan sendiri tidak pernah ditandai terbaca oleh diri
    /// sendiri — diverifikasi ke server.
    @ServerDateTimeJson() @JsonKey(name: 'read_at') DateTime? readAt,

    /// Terisi saat lawan bicara **mengambil** pesan (`/messages` atau poll) —
    /// ditambahkan backend v1.x. Artinya membuka ruang chat kini menulis ke
    /// database.
    @ServerDateTimeJson() @JsonKey(name: 'delivered_at') DateTime? deliveredAt,

    /// `sent` / `delivered` / `read`, dihitung server.
    @StringOrNullJson() @JsonKey(name: 'status') String? deliveryStatus,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  ChatMessageType get type => ChatMessageType.fromCode(typeCode);

  bool get isRead => readAt != null || deliveryStatus == 'read';

  /// Empat keadaan centang dari blueprint (design_buyer.md §5 no. 10):
  /// menunggu, 1 abu, 2 abu, 2 biru. "Menunggu" hanya ada di sisi aplikasi
  /// (pesan yang sedang dikirim), jadi dari server paling rendah `sent`.
  MessageDelivery get delivery {
    if (isRead) return MessageDelivery.read;
    if (deliveredAt != null || deliveryStatus == 'delivered') {
      return MessageDelivery.delivered;
    }
    return MessageDelivery.sent;
  }

  /// `true` kalau pesan ini dikirim oleh [userId].
  ///
  /// Dipakai layar untuk menentukan sisi gelembung. Tidak ada field "dari
  /// saya" di respons — satu-satunya penanda adalah membandingkan
  /// [senderUserId] dengan id user yang sedang masuk.
  bool isMine(int? userId) => userId != null && senderUserId == userId;

  /// Teks yang layak ditampilkan, termasuk untuk jenis yang belum didukung.
  String get displayText {
    final text = content?.trim() ?? '';
    if (text.isNotEmpty) return text;
    return switch (type) {
      ChatMessageType.image => '📷 Foto',
      ChatMessageType.video => '🎥 Video',
      ChatMessageType.productShare => '🛍️ Produk dibagikan',
      ChatMessageType.orderShare => '🧾 Pesanan dibagikan',
      _ => '(pesan kosong)',
    };
  }
}

/// Keadaan kirim sebuah pesan milik sendiri.
enum MessageDelivery { pending, sent, delivered, read }
