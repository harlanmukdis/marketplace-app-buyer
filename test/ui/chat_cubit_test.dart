/// Perilaku [ChatListCubit] dan [ChatRoomCubit] terhadap repository palsu.
///
/// Yang paling banyak diuji adalah **penambalan urutan server**: `ORDER BY
/// created_at DESC` tanpa pemecah seri, di atas kolom beresolusi satu detik,
/// menghasilkan transkrip yang teracak.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketplace_app_member/core/services/token_store.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_list_cubit.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_room_cubit.dart';

const _me = 1814;

ChatMessageModel _msg(int id, {DateTime? at, int sender = _me}) =>
    ChatMessageModel(
      id: id,
      senderUserId: sender,
      typeCode: 'text',
      content: 'Pesan $id',
      createdAt: at ?? DateTime.utc(2026, 9, 20, 16, 55, id),
    );

ChatConversationModel _conv(int id, {DateTime? last, DateTime? created}) =>
    ChatConversationModel(
      id: id,
      storeId: id,
      storeName: 'Toko $id',
      lastMessageAt: last,
      createdAt: created ?? DateTime.utc(2026, 9, 20, 10),
    );

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeChatRepository implements ChatRepository {
  DataState<List<ChatConversationModel>> conversations =
      DataSuccess([_conv(1, last: DateTime.utc(2026, 9, 20, 12))]);
  DataState<int> openResult = const DataSuccess(5);
  DataState<List<ChatMessageModel>> messages = DataSuccess([_msg(1)]);
  DataState<List<ChatMessageModel>>? sendResult;

  final List<String> calls = [];

  @override
  Future<DataState<List<ChatConversationModel>>> fetchConversations() async {
    calls.add('list');
    return conversations;
  }

  @override
  Future<DataState<int>> openConversation({required int storeId}) async {
    calls.add('open:$storeId');
    return openResult;
  }

  @override
  Future<DataState<List<ChatMessageModel>>> fetchMessages(
    int conversationId, {
    int page = 1,
  }) async {
    calls.add('messages:$conversationId:$page');
    return messages;
  }

  @override
  Future<DataState<List<ChatMessageModel>>> sendMessage(
    int conversationId, {
    required String content,
  }) async {
    calls.add('send:$content');
    return sendResult ?? messages;
  }

  @override
  Future<DataState<List<ChatMessageModel>>> share(
    int conversationId, {
    int? productId,
    int? orderId,
  }) async {
    calls.add('share:${productId ?? '-'}:${orderId ?? '-'}');
    return sendResult ?? messages;
  }

  @override
  Future<DataState<void>> markRead(int conversationId) async {
    calls.add('read:$conversationId');
    return const DataSuccess(null);
  }
}

void main() {
  late _FakeChatRepository repository;

  setUp(() async {
    // `ChatRoomCubit` membaca id user dari `TokenStore.userId`, yang
    // mengambilnya SINKRON dari SharedPreferences — jadi prefs harus ada
    // sebelum cubit dibuat. Pola yang sama dipakai splash_navigation_test.
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({kUserId: _me});
    await CachedHelper.init();

    repository = _FakeChatRepository();
    injector
      ..registerSingleton<ChatRepository>(repository)
      // `userId` dibaca sinkron dari SharedPreferences, bukan dari secure
      // storage — jadi instance ini cukup untuk memberi `null`, yang justru
      // kasus yang perlu diuji (gelembung tidak boleh mengaku milik sendiri
      // saat id user tidak diketahui).
      ..registerSingleton<TokenStore>(TokenStore(const FlutterSecureStorage()));
  });

  tearDown(() async {
    await injector.reset();
  });

  group('ChatListCubit', () {
    test('tanpa percakapan berakhir di status empty tersendiri', () async {
      repository.conversations = const DataEmpty();

      final cubit = ChatListCubit();
      await cubit.load();

      expect(cubit.state, isA<ChatListEmpty>());
      await cubit.close();
    });

    test('percakapan TANPA pesan tidak tenggelam di bawah yang lama',
        () async {
      // `last_message_at` null untuk percakapan yang baru dibuka, dan MySQL
      // menaruh NULL di akhir pada ORDER BY ... DESC — sehingga percakapan
      // yang baru saja dibuat muncul paling bawah.
      repository.conversations = DataSuccess([
        _conv(1, last: DateTime.utc(2026, 9, 19)),
        _conv(2, created: DateTime.utc(2026, 9, 20, 18)), // baru, tanpa pesan
      ]);

      final cubit = ChatListCubit();
      await cubit.load();

      final ids = (cubit.state as ChatListLoaded)
          .conversations
          .map((c) => c.id)
          .toList();
      expect(ids, [2, 1]);
      await cubit.close();
    });

    test('membuka percakapan mengembalikan idnya', () async {
      final cubit = ChatListCubit();

      expect(await cubit.openWithStore(3), 5);
      expect(repository.calls, ['open:3']);
      await cubit.close();
    });

    test('gagal membuka percakapan tidak mengosongkan daftar', () async {
      repository.openResult = DataFailed(_error('NETWORK'));

      final cubit = ChatListCubit();
      await cubit.load();
      final id = await cubit.openWithStore(3);

      expect(id, isNull);
      final state = cubit.state;
      expect(state, isA<ChatListLoaded>());
      expect((state as ChatListLoaded).actionError, isNotNull);
      expect(state.conversations, isNotEmpty);
      await cubit.close();
    });
  });

  group('ChatRoomCubit — urutan', () {
    test('🔴 transkrip teracak dari server diurutkan ulang', () async {
      // Bentuk nyata dari server: blok detik MENURUN, isi tiap detik MENAIK.
      //   12  16:55:37   Pesan ke-4
      //    9  16:55:35   Pesan ke-1
      //   10  16:55:35   Pesan ke-2
      //   11  16:55:35   Pesan ke-3
      // Membaliknya menghasilkan 11, 10, 9, 12 — percakapan yang kacau.
      final detikA = DateTime.utc(2026, 9, 20, 16, 55, 35);
      final detikB = DateTime.utc(2026, 9, 20, 16, 55, 37);
      repository.messages = DataSuccess([
        _msg(12, at: detikB),
        _msg(9, at: detikA),
        _msg(10, at: detikA),
        _msg(11, at: detikA),
      ]);

      final cubit = ChatRoomCubit(7);
      await cubit.load();

      expect(
        (cubit.state as ChatRoomReady).messages.map((m) => m.id),
        [9, 10, 11, 12],
        reason: 'terlama di atas, dengan id sebagai pemecah seri',
      );
      await cubit.close();
    });

    test('pesan yang sama tidak tampil dua kali setelah baca ulang', () async {
      final cubit = ChatRoomCubit(7);
      await cubit.load();
      await cubit.refresh();

      final ids = (cubit.state as ChatRoomReady).messages.map((m) => m.id);
      expect(ids.toSet(), hasLength(ids.length));
      await cubit.close();
    });
  });

  group('ChatRoomCubit — kirim', () {
    test('menandai terbaca saat ruang dibuka', () async {
      final cubit = ChatRoomCubit(7);
      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(repository.calls, contains('read:7'));
      await cubit.close();
    });

    test('teks kosong ditolak TANPA menyentuh jaringan', () async {
      // Server menerimanya dan membalas 201 dengan content null, menyisakan
      // gelembung hampa yang tidak bisa dihapus.
      final cubit = ChatRoomCubit(7);
      await cubit.load();
      repository.calls.clear();

      await cubit.send('   ');

      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('pesan terkirim muncul dari hasil BACA ULANG, bukan dari balasan',
        () async {
      // `POST .../messages` hanya membalas {id} — tanpa created_at maupun
      // sender_user_id, jadi gelembungnya tidak bisa dirender dari situ.
      repository.sendResult = DataSuccess([_msg(1), _msg(2)]);

      final cubit = ChatRoomCubit(7);
      await cubit.load();
      await cubit.send('Halo');

      final state = cubit.state as ChatRoomReady;
      expect(state.messages.map((m) => m.id), [1, 2]);
      expect(state.isSending, isFalse);
      await cubit.close();
    });

    test('gagal mengirim tidak menghapus percakapan yang sedang dibaca',
        () async {
      repository.sendResult = DataFailed(_error('NETWORK'));

      final cubit = ChatRoomCubit(7);
      await cubit.load();
      await cubit.send('Halo');

      final state = cubit.state as ChatRoomReady;
      expect(state.messages, isNotEmpty);
      expect(state.actionError, isNotNull);
      expect(state.isSending, isFalse);
      await cubit.close();
    });

    test('ketukan kirim kedua diabaikan selagi yang pertama berjalan',
        () async {
      final cubit = ChatRoomCubit(7);
      await cubit.load();
      repository.calls.clear();

      await Future.wait([cubit.send('Satu'), cubit.send('Dua')]);

      expect(repository.calls.where((c) => c.startsWith('send:')),
          ['send:Satu']);
      await cubit.close();
    });

    test('gelembung "menunggu" tampil selama kirim, lalu hilang', () async {
      repository.sendResult = DataSuccess([_msg(1), _msg(2)]);

      final cubit = ChatRoomCubit(7);
      await cubit.load();
      final seen = <String?>[];
      final sub = cubit.stream.listen((s) {
        if (s is ChatRoomReady) seen.add(s.pendingText);
      });

      final sent = await cubit.send('  Halo  ');
      await Future<void>.delayed(Duration.zero);

      expect(sent, isTrue);
      // Isi yang dikirim sudah dipangkas — sama dengan yang sampai ke server.
      expect(seen.first, 'Halo');
      expect((cubit.state as ChatRoomReady).pendingText, isNull);
      await sub.cancel();
      await cubit.close();
    });

    test('🔴 CHAT_CONTENT_BLOCKED: send() melapor gagal supaya teks '
        'dikembalikan ke kolom ketik', () async {
      // Filter konten server menolak nomor HP/email/tautan dengan 422 dan
      // TIDAK menyimpan pesannya — layar mengandalkan nilai kembalian ini
      // untuk mengembalikan ketikan user.
      repository.sendResult = DataFailed(_error('CHAT_CONTENT_BLOCKED'));

      final cubit = ChatRoomCubit(7);
      await cubit.load();
      final sent = await cubit.send('Hubungi 08123456789');

      final state = cubit.state as ChatRoomReady;
      expect(sent, isFalse);
      expect(state.actionError?.code, 'CHAT_CONTENT_BLOCKED');
      expect(state.pendingText, isNull);
      expect(state.messages.map((m) => m.id), [1]);
      await cubit.close();
    });

    test('teks kosong melapor tidak terkirim', () async {
      final cubit = ChatRoomCubit(7);
      await cubit.load();
      expect(await cubit.send('   '), isFalse);
      await cubit.close();
    });
  });

  group('ChatRoomCubit.share', () {
    test('membagikan produk lalu memakai hasil baca ulang', () async {
      final cubit = ChatRoomCubit(5);
      await cubit.load();
      repository.sendResult = DataSuccess([
        _msg(1),
        const ChatMessageModel(id: 2, senderUserId: _me, typeCode: 'product_share', sharedProductId: 9),
      ]);

      final sent = await cubit.share(productId: 9);

      expect(sent, isTrue);
      expect(repository.calls, contains('share:9:-'));
      final state = cubit.state as ChatRoomReady;
      expect(state.messages.last.type, ChatMessageType.productShare);
      expect(state.pendingText, isNull);
      await cubit.close();
    });

    test('gagal membagikan pesanan melapor error tanpa menghapus percakapan', () async {
      final cubit = ChatRoomCubit(5);
      await cubit.load();
      repository.sendResult = DataFailed(_error('VALIDATION_ERROR'));

      final sent = await cubit.share(orderId: 44);

      expect(sent, isFalse);
      expect(repository.calls, contains('share:-:44'));
      final state = cubit.state as ChatRoomReady;
      expect(state.messages, hasLength(1));
      expect(state.actionError?.code, 'VALIDATION_ERROR');
      await cubit.close();
    });
  });
}
