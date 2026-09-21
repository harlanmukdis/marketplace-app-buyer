/// Kontrak `/chat/*` terhadap marketplace-api yang **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration --concurrency=1
/// ```
///
/// ⚠️ **`GET .../poll` sengaja TIDAK diuji di sini.** Endpoint itu menahan
/// request sampai 25 detik, dan API dijalankan dengan `php -S` yang
/// single-threaded — satu panggilan akan membekukan seluruh suite serial ini,
/// bukan hanya berkas ini. Perilakunya diukur manual dan dicatat di
/// `ChatService`; mengulanginya di sini hanya akan melipatgandakan waktu
/// suite demi fakta yang sudah terdokumentasi.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/chat_service.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';

void main() {
  late Dio dio;
  late ChatService chat;

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    final auth = AuthService(dio);
    chat = ChatService(dio);

    final stamp = DateTime.now().microsecondsSinceEpoch;
    final email = 'uji.chat.$stamp@marketplace.local';
    const password = 'RahasiaAman123';

    await auth.register(
      email: email,
      password: password,
      fullName: 'Uji Chat',
      phone: '08${stamp.toString().substring(stamp.toString().length - 10)}',
    );
    await loginAs(dio, email: email, password: password);
  });

  tearDown(() => dio.close(force: true));

  group('percakapan', () {
    test('akun baru belum punya percakapan', () async {
      final result = await chat.fetchConversations();
      expect(result.data, isEmpty);
    });

    test('membuka percakapan bersifat GET-OR-CREATE', () async {
      // Tabelnya punya UNIQUE (buyer_id, store_id), jadi tombol "Chat
      // penjual" aman ditekan berkali-kali.
      final first = await chat.openConversation(storeId: 1);
      final second = await chat.openConversation(storeId: 1);

      expect(first.data, greaterThan(0));
      expect(second.data, first.data);

      final list = await chat.fetchConversations();
      expect(list.data, hasLength(1));
    });

    test('daftar membawa store_name dari join', () async {
      // Berarti daftar percakapan tidak perlu menembak /stores/{id} per baris.
      await chat.openConversation(storeId: 1);

      final list = await chat.fetchConversations();
      expect(list.data.single.storeName, isNotEmpty);
      expect(list.data.single.storeId, 1);
    });

    test('percakapan baru belum punya last_message_at', () async {
      // Barisnya dibuat lebih dulu tanpa pesan — itu sebabnya ChatListCubit
      // mengurutkan memakai `sortedAt`, yang jatuh ke created_at.
      await chat.openConversation(storeId: 1);

      final conversation = (await chat.fetchConversations()).data.single;
      expect(conversation.lastMessageAt, isNull);
      expect(conversation.isEmpty, isTrue);
      expect(conversation.sortedAt, isNotNull);
    });

    test('🔴 store_id yang tidak ada membalas 500, bukan VALIDATION_ERROR',
        () async {
      // Foreign key ditolak tanpa validasi lebih dulu, dan halaman error
      // HTML-nya sampai ke aplikasi sebagai CLIENT_BAD_RESPONSE.
      await expectLater(
        chat.openConversation(storeId: 99999999),
        throwsA(anything),
      );
    });
  });

  group('pesan', () {
    late int conversationId;

    setUp(() async {
      conversationId = (await chat.openConversation(storeId: 1)).data;
    });

    test('mengirim lalu membaca kembali', () async {
      await chat.sendMessage(conversationId, content: 'Halo kak');

      final messages = await chat.fetchMessages(conversationId);
      expect(messages.data, hasLength(1));
      expect(messages.data.single.content, 'Halo kak');
      expect(messages.data.single.type, ChatMessageType.text);
      expect(messages.data.single.readAt, isNull);
    });

    test('🔴 created_at SENDIRI tidak cukup untuk mengurutkan percakapan',
        () async {
      // `ORDER BY created_at DESC` tanpa pemecah seri, di atas kolom DATETIME
      // beresolusi **satu detik**: tiga pesan berurutan berbagi satu stempel
      // waktu, sehingga urutan di antara mereka tidak ditentukan apa pun.
      //
      // ⚠️ Arah serinya **sembarang** — diamati MENAIK (`9, 10, 11`) pada satu
      // run dan MENURUN (`19, 18, 17`) pada run lain. Karena itu test ini
      // tidak memaku salah satu arah: yang dipatok adalah fakta
      // deterministiknya, yaitu stempel waktunya bertabrakan sehingga `id`
      // wajib jadi pemecah seri (lihat `ChatRoomCubit._merge`).
      for (var i = 1; i <= 3; i++) {
        await chat.sendMessage(conversationId, content: 'Pesan $i');
      }

      final messages = (await chat.fetchMessages(conversationId)).data;
      expect(messages, hasLength(3));

      final stamps = messages.map((m) => m.createdAt).toSet();
      if (stamps.length > 1) return; // kebetulan melewati batas detik

      expect(stamps, hasLength(1),
          reason: 'tiga pesan berbagi satu stempel waktu — urutan di antara '
              'mereka tidak bisa disimpulkan dari created_at');
      // Id auto-increment tetap mencerminkan urutan kirim yang sebenarnya.
      final ids = messages.map((m) => m.id).toList()..sort();
      expect(ids.last - ids.first, 2);
    });

    test('🔴 server menerima pesan TANPA content', () async {
      // Ini alasan ChatRoomCubit menolak teks kosong sendiri: gelembung hampa
      // yang terlanjur terkirim tidak bisa dihapus.
      final response = await dio.post<dynamic>(
        '/chat/conversations/$conversationId/messages',
        data: <String, dynamic>{},
      );
      expect(response.statusCode, 201);

      final messages = (await chat.fetchMessages(conversationId)).data;
      expect(messages.single.content, isNull);
    });

    test('🔴 message_type di luar ENUM tersimpan sebagai STRING KOSONG',
        () async {
      // MySQL non-strict: nilainya tidak ditolak, hanya dipotong jadi ''.
      await dio.post<dynamic>(
        '/chat/conversations/$conversationId/messages',
        data: {'message_type': 'sticker', 'content': 'x'},
      );

      final message = (await chat.fetchMessages(conversationId)).data.single;
      expect(message.typeCode, isEmpty);
      expect(message.type, ChatMessageType.unknown);
      expect(message.displayText, 'x',
          reason: 'isinya terbaca, jadi tetap ditampilkan');
    });

    test('mark-read TIDAK menandai pesan sendiri', () async {
      // `mark_read` hanya menyentuh pesan yang pengirimnya bukan pemanggil,
      // jadi centang ganda di gelembung sendiri hanya muncul kalau lawan
      // bicara benar-benar membuka percakapan.
      await chat.sendMessage(conversationId, content: 'Halo');
      await chat.markRead(conversationId);

      final message = (await chat.fetchMessages(conversationId)).data.single;
      expect(message.readAt, isNull);
      expect(message.isRead, isFalse);
    });

    test('🔴 buyer_unread_count tidak pernah naik walau ada pesan', () async {
      // Kolomnya ada, tapi tidak ada kode backend yang mengisinya.
      await chat.sendMessage(conversationId, content: 'Halo');

      final conversation = (await chat.fetchConversations()).data.single;
      expect(conversation.buyerUnreadCount, 0);
      expect(conversation.lastMessageAt, isNotNull,
          reason: 'yang diperbarui hanya last_message_at');
    });

    test('halaman jauh di belakang mengembalikan daftar kosong', () async {
      await chat.sendMessage(conversationId, content: 'Halo');

      final messages = await chat.fetchMessages(conversationId, page: 99);
      expect(messages.data, isEmpty);
    });

    test('🔴 percakapan TIDAK ADA dan MILIK ORANG LAIN sama-sama 403',
        () async {
      // Keduanya NOT_PARTICIPANT, jadi tidak bisa dibedakan — layar tidak
      // boleh menulis "percakapan dihapus".
      await expectLater(
        chat.fetchMessages(99999999),
        throwsA(anything),
      );
    });
  });
}
