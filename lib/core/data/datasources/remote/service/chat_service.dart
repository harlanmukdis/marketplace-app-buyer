import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

/// Panggilan HTTP untuk `/chat/*` sisi pembeli.
///
/// ## 🔴 `GET /chat/conversations/{id}/poll` SENGAJA TIDAK DIBUATKAN METHOD
///
/// Endpoint itu adalah long-polling: ia **menahan request sampai 25 detik**
/// menunggu pesan baru. Di atas server produksi multi-proses itu wajar. Di
/// sini tidak: API dijalankan dengan `php -S`, yang **single-threaded**.
///
/// Diukur ke server, dua kali (sebelum dan sesudah pembaruan backend):
/// pollnya menggantung **25 detik**, dan `GET /products` yang dikirim 4 detik
/// sesudahnya baru dijawab **21 detik kemudian** — tertahan sampai pollnya
/// selesai. Artinya **satu layar chat yang terbuka membekukan seluruh
/// aplikasi**: katalog, keranjang, checkout, semuanya berhenti.
///
/// Karena itu layar chat menyegarkan diri dengan **membaca ulang halaman
/// pertama secara berkala** lewat [fetchMessages]. Lebih boros satu
/// permintaan kecil, tapi tidak pernah menahan koneksi.
///
/// Hidupkan poll hanya setelah backend berjalan di php-fpm/nginx — dan ukur
/// ulang sebelum mempercayainya.
class ChatService {
  ChatService(this._dio);

  final Dio _dio;

  /// Ukuran halaman yang **dipatok server**.
  ///
  /// Controllernya memanggil `list_messages($id, $page)` — dua parameter —
  /// sehingga `$perPage` selalu memakai default modelnya dan `?per_page=`
  /// yang dikirim aplikasi diabaikan diam-diam.
  static const int serverPageSize = 30;

  /// `GET /chat/conversations` — percakapan milik pembeli, beserta
  /// `store_name` hasil join.
  Future<ApiEnvelope<List<ChatConversationModel>>> fetchConversations() async {
    const context = 'GET /chat/conversations';
    try {
      final response = await _dio.get<dynamic>('/chat/conversations');
      return parseEnvelopeList(response, ChatConversationModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /chat/conversations` — membuka percakapan dengan satu toko.
  ///
  /// **Get-or-create**: memanggilnya dua kali untuk toko yang sama
  /// mengembalikan id yang sama, bukan membuat baris kedua — tabelnya punya
  /// `UNIQUE (buyer_id, store_id)`.
  ///
  /// ⚠️ Idnya **kadang number, kadang string**: pembuatan pertama membalas
  /// `{"id": 5}` dari `insert_id()`, panggilan berikutnya `{"id": "5"}` dari
  /// baris database. Dibaca lewat [asInt], bukan cast.
  ///
  /// ⚠️ `store_id` yang tidak ada membuat server membalas **500 halaman
  /// HTML** — foreign key ditolak tanpa validasi lebih dulu.
  Future<ApiEnvelope<int>> openConversation({required int storeId}) async {
    const context = 'POST /chat/conversations';
    try {
      final response = await _dio.post<dynamic>(
        '/chat/conversations',
        data: {'store_id': storeId},
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /chat/conversations/{id}/messages` — satu halaman pesan.
  ///
  /// 🔴 **Urutannya tidak bisa dipakai apa adanya.** Modelnya mengurutkan
  /// `ORDER BY created_at DESC` tanpa pemecah seri, sementara `created_at`
  /// bertipe `DATETIME` beresolusi satu detik. Hasil nyata dari server:
  ///
  /// ```
  /// 12  16:55:37   "Pesan ke-4"
  ///  9  16:55:35   "Pesan ke-1"
  /// 10  16:55:35   "Pesan ke-2"
  /// 11  16:55:35   "Pesan ke-3"
  /// ```
  ///
  /// Blok detik menurun, tapi isi tiap detik menaik. Membalik daftarnya
  /// menghasilkan `11, 10, 9, 12` — percakapan yang kacau. `ChatRoomCubit`
  /// mengurutkannya ulang menurut `(createdAt, id)`.
  ///
  /// ⚠️ Percakapan yang **tidak ada** dan percakapan **milik orang lain**
  /// sama-sama dibalas `403 NOT_PARTICIPANT`, jadi keduanya tidak bisa
  /// dibedakan.
  Future<ApiEnvelope<List<ChatMessageModel>>> fetchMessages(
    int conversationId, {
    int page = 1,
  }) async {
    final context = 'GET /chat/conversations/$conversationId/messages';
    try {
      final response = await _dio.get<dynamic>(
        '/chat/conversations/$conversationId/messages',
        queryParameters: {'page': page},
      );
      return parseEnvelopeList(response, ChatMessageModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /chat/conversations/{id}/messages` → id pesan baru.
  ///
  /// ⚠️ Body tanpa `content` tetap dibalas `201` dengan isi `null` —
  /// aplikasi yang menolak teks kosong. `message_type` di luar
  /// `text|image|product_share|order_share` sejak backend v1.x ditolak
  /// `422 VALIDATION_ERROR`. Pesan bagikan (`product_share`/`order_share`)
  /// dikirim **tanpa** `content`, sehingga moderasi konten tidak menyentuhnya.
  Future<ApiEnvelope<int>> sendMessage(
    int conversationId, {
    String? content,
    ChatMessageType type = ChatMessageType.text,
    int? sharedProductId,
    int? sharedOrderId,
  }) async {
    final context = 'POST /chat/conversations/$conversationId/messages';
    try {
      final response = await _dio.post<dynamic>(
        '/chat/conversations/$conversationId/messages',
        // `shared_product_id` / `shared_order_id` diteruskan apa adanya ke
        // INSERT oleh `Chat_model::send_message` — server tidak memeriksa
        // kepemilikan pesanan maupun keberadaan produk, jadi aplikasi hanya
        // menawarkan pesanan milik pembeli sendiri.
        data: {
          'message_type': type.code,
          if (content != null) 'content': content,
          if (sharedProductId != null) 'shared_product_id': sharedProductId,
          if (sharedOrderId != null) 'shared_order_id': sharedOrderId,
        },
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /chat/conversations/{id}/read` — menandai pesan **lawan bicara**
  /// sebagai terbaca.
  ///
  /// Hanya pesan yang pengirimnya bukan pemanggil yang tersentuh, jadi ini
  /// tidak pernah menandai pesan sendiri. Balasannya `data: null`.
  Future<ApiEnvelope<void>> markRead(int conversationId) async {
    final context = 'POST /chat/conversations/$conversationId/read';
    try {
      final response =
          await _dio.post<dynamic>('/chat/conversations/$conversationId/read');
      return parseEnvelope(response, (_) {}, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
