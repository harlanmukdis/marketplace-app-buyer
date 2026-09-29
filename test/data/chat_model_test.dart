/// Parsing model chat terhadap bentuk JSON yang **benar-benar dikirim**
/// server (20 September 2026).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';

/// Respons `GET /chat/conversations` apa adanya.
const _conversationJson = <String, dynamic>{
  'id': '5',
  'buyer_id': '1812',
  'store_id': '1',
  'last_message_at': '2026-09-20 16:55:37',
  'buyer_unread_count': '0',
  'store_unread_count': '0',
  'created_at': '2026-09-20 16:55:35',
  'store_name': 'Kedai Kopi Nusantara',
};

/// Respons `GET /chat/conversations/{id}/messages` apa adanya.
const _messageJson = <String, dynamic>{
  'id': '13',
  'conversation_id': '7',
  'sender_user_id': '1814',
  'message_type': 'text',
  'content': 'Halo kak',
  'shared_product_id': null,
  'shared_order_id': null,
  'created_at': '2026-09-20 16:56:33',
  'read_at': null,
};

void main() {
  group('ChatConversationModel', () {
    test('membawa nama toko dari join, tanpa panggilan tambahan', () {
      final c = ChatConversationModel.fromJson(_conversationJson);
      expect(c.id, 5);
      expect(c.storeId, 1);
      expect(c.storeName, 'Kedai Kopi Nusantara');
      expect(c.isEmpty, isFalse);
    });

    test('🔴 buyer_unread_count selalu nol dan ditandai TIDAK bisa dipercaya',
        () {
      // Kolomnya ada di skema, tapi tidak ada satu pun kode backend yang
      // pernah mengisinya: `send_message` hanya memperbarui `last_message_at`,
      // `mark_read` hanya menyentuh `chat_messages.read_at`. Memakainya
      // sebagai lencana berarti memasang angka yang permanen nol.
      final c = ChatConversationModel.fromJson(_conversationJson);
      expect(c.buyerUnreadCount, 0);
      expect(ChatConversationModel.hasReliableUnreadCount, isFalse);
    });

    test('percakapan tanpa pesan jatuh ke created_at untuk pengurutan', () {
      // `POST /chat/conversations` membuat barisnya lebih dulu tanpa pesan,
      // sehingga `last_message_at` null — dan MySQL menaruh NULL di akhir
      // pada urutan menurun, membuat percakapan baru tenggelam.
      final c = ChatConversationModel.fromJson(
          {..._conversationJson, 'last_message_at': null});

      expect(c.isEmpty, isTrue);
      expect(c.lastMessageAt, isNull);
      expect(c.sortedAt, isNotNull);
      expect(c.sortedAt, c.createdAt);
    });

    test('last_message_at sezona dengan created_at', () {
      // Dulu berselisih 7 jam (PHP `date()` vs MySQL `CURRENT_TIMESTAMP`);
      // diseragamkan backend di commit `93c6a14`.
      final c = ChatConversationModel.fromJson(_conversationJson);
      final gap = c.lastMessageAt!.difference(c.createdAt!);
      expect(gap, const Duration(seconds: 2));
    });
  });

  group('ChatMessageModel', () {
    test('membaca pesan sungguhan', () {
      final m = ChatMessageModel.fromJson(_messageJson);
      expect(m.id, 13);
      expect(m.senderUserId, 1814);
      expect(m.content, 'Halo kak');
      expect(m.type, ChatMessageType.text);
      expect(m.isRead, isFalse);
    });

    test('sisi gelembung ditentukan dengan membandingkan sender_user_id', () {
      // Tidak ada field "dari saya" di respons — satu-satunya penanda.
      final m = ChatMessageModel.fromJson(_messageJson);
      expect(m.isMine(1814), isTrue);
      expect(m.isMine(999), isFalse);
      expect(m.isMine(null), isFalse,
          reason: 'tanpa id user, tidak boleh menebak pesan itu milik sendiri');
    });

    test('🔴 message_type di luar ENUM tersimpan sebagai STRING KOSONG', () {
      // MySQL non-strict: diuji dengan "sticker", yang tersimpan jadi ''.
      // Pesannya tetap harus tampil apa adanya.
      final m = ChatMessageModel.fromJson({..._messageJson, 'message_type': ''});
      expect(m.type, ChatMessageType.unknown);
      expect(m.displayText, 'Halo kak',
          reason: 'isinya terbaca, jadi jangan disembunyikan');
    });

    test('content null tidak menghasilkan gelembung hampa tanpa keterangan',
        () {
      // Server menerima POST tanpa content dan membalas 201.
      final m = ChatMessageModel.fromJson(
          {..._messageJson, 'content': null, 'message_type': 'image'});
      expect(m.content, isNull);
      expect(m.displayText, '📷 Foto');
    });

    test('jenis tak dikenal DAN content kosong tetap punya teks', () {
      final m = ChatMessageModel.fromJson(
          {..._messageJson, 'content': null, 'message_type': ''});
      expect(m.displayText, '(pesan kosong)');
    });

    test('read_at terisi berarti sudah dibaca lawan bicara', () {
      final m = ChatMessageModel.fromJson(
          {..._messageJson, 'read_at': '2026-09-20 17:00:00'});
      expect(m.isRead, isTrue);
    });

    group('delivery — empat keadaan centang', () {
      test('tanpa delivered_at/read_at/status berarti terkirim (1 centang)',
          () {
        final m = ChatMessageModel.fromJson(_messageJson);
        expect(m.delivery, MessageDelivery.sent);
      });

      test('status "sent" dari server tetap satu centang', () {
        final m = ChatMessageModel.fromJson({
          ..._messageJson,
          'delivered_at': null,
          'status': 'sent',
        });
        expect(m.delivery, MessageDelivery.sent);
      });

      test('delivered_at terisi berarti sampai (2 centang abu)', () {
        final m = ChatMessageModel.fromJson({
          ..._messageJson,
          'delivered_at': '2026-09-20 16:57:00',
          'status': 'delivered',
        });
        expect(m.deliveredAt, isNotNull);
        expect(m.deliveryStatus, 'delivered');
        expect(m.delivery, MessageDelivery.delivered);
      });

      test('status "delivered" saja cukup walau delivered_at tidak ikut', () {
        final m =
            ChatMessageModel.fromJson({..._messageJson, 'status': 'delivered'});
        expect(m.delivery, MessageDelivery.delivered);
      });

      test('read_at mengalahkan delivered_at (2 centang biru)', () {
        final m = ChatMessageModel.fromJson({
          ..._messageJson,
          'delivered_at': '2026-09-20 16:57:00',
          'read_at': '2026-09-20 16:58:00',
          'status': 'read',
        });
        expect(m.delivery, MessageDelivery.read);
      });

      test('status "read" tanpa read_at tetap dibaca', () {
        final m = ChatMessageModel.fromJson({..._messageJson, 'status': 'read'});
        expect(m.delivery, MessageDelivery.read);
      });

      test('"pending" tidak pernah datang dari server', () {
        // Keadaan menunggu hanya milik aplikasi (pesan yang sedang dikirim);
        // nilai status asing jatuh ke terkirim, bukan menunggu.
        final m =
            ChatMessageModel.fromJson({..._messageJson, 'status': 'pending'});
        expect(m.delivery, MessageDelivery.sent);
      });
    });
  });
}
