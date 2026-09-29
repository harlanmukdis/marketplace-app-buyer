/// Perilaku cubit Xpedia 911 terhadap repository palsu.
///
/// Yang paling penting dipatok: `related_order_id` **hanya** berasal dari
/// rute (server tidak memeriksa kepemilikannya dan meledak 500 untuk id yang
/// tidak ada), dan percakapan diurutkan sendiri karena urutan server tidak
/// dijamin.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/support_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/support/cubit/support_list_cubit.dart';
import 'package:marketplace_app_member/ui/main/support/cubit/support_new_ticket_cubit.dart';
import 'package:marketplace_app_member/ui/main/support/cubit/support_ticket_cubit.dart';

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

SupportTicketModel _ticket(int id, {String status = 'open'}) => SupportTicketModel(
      id: id,
      ticketNumber: 'X911-$id',
      category: 'order_transaction',
      subject: 'Tiket $id',
      status: status,
    );

SupportMessageModel _message(int id, String at, {bool admin = false}) =>
    SupportMessageModel(
      id: id,
      message: 'pesan $id',
      isAdminReply: admin,
      createdAt: DateTime.parse(at),
    );

class _FakeSupportRepository implements SupportRepository {
  final Map<int, DataState<List<SupportTicketModel>>> pages = {};
  DataState<SupportTicketModel> ticketResult = DataSuccess(_ticket(5));
  DataState<List<SupportMessageModel>> messagesResult = const DataEmpty();
  DataState<SupportTicketModel>? createResult;
  DataState<List<SupportMessageModel>>? sendResult;

  final List<String> calls = [];
  int? lastRelatedOrderId;
  SupportCategory? lastCategory;

  @override
  Future<DataState<List<SupportTicketModel>>> fetchTickets({int page = 1}) async {
    calls.add('list:$page');
    return pages[page] ?? const DataEmpty();
  }

  @override
  Future<DataState<SupportTicketModel>> fetchTicket(int id) async {
    calls.add('ticket:$id');
    return ticketResult;
  }

  @override
  Future<DataState<SupportTicketModel>> createTicket({
    required SupportCategory category,
    required String subject,
    required String description,
    int? relatedOrderId,
  }) async {
    calls.add('create');
    lastCategory = category;
    lastRelatedOrderId = relatedOrderId;
    return createResult ?? DataSuccess(_ticket(99));
  }

  @override
  Future<DataState<List<SupportMessageModel>>> fetchMessages(int ticketId) async {
    calls.add('messages:$ticketId');
    return messagesResult;
  }

  @override
  Future<DataState<List<SupportMessageModel>>> sendMessage(int ticketId, String message) async {
    calls.add('send:$message');
    return sendResult ?? messagesResult;
  }
}

void main() {
  late _FakeSupportRepository repository;

  setUp(() {
    repository = _FakeSupportRepository();
    injector.registerSingleton<SupportRepository>(repository);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('SupportListCubit', () {
    test('daftar kosong adalah keadaan normal, bukan error', () async {
      final cubit = SupportListCubit();
      await cubit.load();

      final state = cubit.state as SupportListLoaded;
      expect(state.tickets, isEmpty);
      expect(state.hasMore, isFalse);
      await cubit.close();
    });

    test('halaman penuh berarti mungkin ada halaman berikutnya', () async {
      // Tanpa `meta`, satu-satunya petunjuk adalah halaman yang terisi penuh.
      repository.pages[1] = DataSuccess([for (var i = 1; i <= 20; i++) _ticket(i)]);
      repository.pages[2] = DataSuccess([_ticket(20), _ticket(21)]);
      final cubit = SupportListCubit();
      await cubit.load();
      expect((cubit.state as SupportListLoaded).hasMore, isTrue);

      await cubit.loadMore();

      final state = cubit.state as SupportListLoaded;
      expect(state.tickets.map((t) => t.id).toSet(), hasLength(21),
          reason: 'baris yang bergeser antarhalaman tidak digandakan');
      expect(state.tickets, hasLength(21));
      expect(state.hasMore, isFalse);
      await cubit.close();
    });

    test('gagal memuat halaman berikutnya mempertahankan daftar', () async {
      repository.pages[1] = DataSuccess([for (var i = 1; i <= 20; i++) _ticket(i)]);
      repository.pages[2] = DataFailed(_error(ClientErrorCode.network));
      final cubit = SupportListCubit();
      await cubit.load();

      await cubit.loadMore();

      final state = cubit.state as SupportListLoaded;
      expect(state.tickets, hasLength(20));
      expect(state.loadMoreError?.code, ClientErrorCode.network);
      await cubit.close();
    });
  });

  group('SupportNewTicketCubit', () {
    test('dibuka dari pesanan: kategori pesanan terpilih dan id diteruskan', () async {
      final cubit = SupportNewTicketCubit(relatedOrderId: 42);
      expect(cubit.state.category, SupportCategory.orderTransaction);

      await cubit.submit(subject: 'Paket belum sampai', description: 'Sudah 5 hari');

      expect(repository.lastRelatedOrderId, 42);
      expect(cubit.state.created?.id, 99);
      await cubit.close();
    });

    test('tanpa pesanan: tidak ada related_order_id sama sekali', () async {
      final cubit = SupportNewTicketCubit();
      expect(cubit.state.category, isNull);
      cubit.selectCategory(SupportCategory.accountSecurity);

      await cubit.submit(subject: 'Tidak bisa masuk', description: 'Lupa sandi');

      expect(repository.lastRelatedOrderId, isNull);
      expect(repository.lastCategory, SupportCategory.accountSecurity);
      await cubit.close();
    });

    test('kategori, subjek, dan deskripsi wajib — ditolak tanpa request', () async {
      final cubit = SupportNewTicketCubit();

      await cubit.submit(subject: 'A', description: 'B');
      expect(cubit.state.error?.message, contains('kategori'));

      cubit.selectCategory(SupportCategory.paymentWallet);
      await cubit.submit(subject: '   ', description: 'B');
      expect(cubit.state.error?.message, contains('subjek'));

      await cubit.submit(subject: 'A', description: '');
      expect(cubit.state.error?.message, contains('deskripsi'));
      expect(cubit.state.error?.code, ClientErrorCode.localValidation);

      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('subjek terlalu panjang ditolak', () async {
      final cubit = SupportNewTicketCubit(relatedOrderId: 1);

      await cubit.submit(
          subject: 'x' * (SupportNewTicketCubit.maxSubjectLength + 1), description: 'B');

      expect(repository.calls, isEmpty);
      expect(cubit.state.error?.message, contains('maksimal'));
      await cubit.close();
    });

    test('kegagalan server disimpan, formulir tetap bisa dikirim ulang', () async {
      repository.createResult = DataFailed(_error(ApiErrorCode.validationError));
      final cubit = SupportNewTicketCubit(relatedOrderId: 1);

      await cubit.submit(subject: 'A', description: 'B');

      expect(cubit.state.error?.code, ApiErrorCode.validationError);
      expect(cubit.state.created, isNull);
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });

    test('tidak mengirim dua kali setelah tiket terbentuk', () async {
      final cubit = SupportNewTicketCubit(relatedOrderId: 1);
      await cubit.submit(subject: 'A', description: 'B');
      await cubit.submit(subject: 'A', description: 'B');

      expect(repository.calls.where((c) => c == 'create'), hasLength(1));
      await cubit.close();
    });
  });

  group('SupportTicketCubit', () {
    test('percakapan diurutkan terlama dulu, id sebagai pemecah seri', () async {
      repository.messagesResult = DataSuccess([
        _message(12, '2026-09-28 10:00:05'),
        _message(11, '2026-09-28 10:00:01', admin: true),
        _message(10, '2026-09-28 10:00:01'),
      ]);
      final cubit = SupportTicketCubit(5);
      await cubit.load();

      final state = cubit.state as SupportTicketReady;
      expect(state.messages.map((m) => m.id), [10, 11, 12]);
      await cubit.close();
    });

    test('tiket tanpa pesan: siap, tanpa error', () async {
      final cubit = SupportTicketCubit(5);
      await cubit.load();

      final state = cubit.state as SupportTicketReady;
      expect(state.messages, isEmpty);
      expect(state.messagesError, isNull);
      await cubit.close();
    });

    test('pesan gagal dimuat ditandai, tiket tetap tampil', () async {
      repository.messagesResult = DataFailed(_error(ClientErrorCode.network));
      final cubit = SupportTicketCubit(5);
      await cubit.load();

      final state = cubit.state as SupportTicketReady;
      expect(state.ticket.id, 5);
      expect(state.messagesError?.code, ClientErrorCode.network);
      await cubit.close();
    });

    test('tiket tidak ditemukan jadi error layar', () async {
      repository.ticketResult = DataFailed(_error(ApiErrorCode.ticketNotFound));
      final cubit = SupportTicketCubit(5);
      await cubit.load();

      expect((cubit.state as SupportTicketError).error.code, ApiErrorCode.ticketNotFound);
      await cubit.close();
    });

    test('mengirim pesan membaca ulang percakapan dan status tiket', () async {
      final cubit = SupportTicketCubit(5);
      await cubit.load();
      repository.calls.clear();
      repository.sendResult = DataSuccess([_message(1, '2026-09-28 11:00:00')]);
      // Pesan pertama pengguna memindahkan tiket open → in_progress.
      repository.ticketResult = DataSuccess(_ticket(5, status: 'in_progress'));

      final sent = await cubit.send('  Halo  ');

      expect(sent, isTrue);
      expect(repository.calls, ['send:Halo', 'ticket:5']);
      final state = cubit.state as SupportTicketReady;
      expect(state.messages, hasLength(1));
      expect(state.ticket.status, 'in_progress');
      expect(state.isSending, isFalse);
      await cubit.close();
    });

    test('teks kosong tidak dikirim', () async {
      final cubit = SupportTicketCubit(5);
      await cubit.load();
      repository.calls.clear();

      expect(await cubit.send('   '), isFalse);
      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('tiket selesai tidak menerima pesan', () async {
      repository.ticketResult = DataSuccess(_ticket(5, status: 'resolved'));
      final cubit = SupportTicketCubit(5);
      await cubit.load();
      repository.calls.clear();

      expect(await cubit.send('Masih bermasalah'), isFalse);

      expect(repository.calls, isEmpty);
      expect((cubit.state as SupportTicketReady).actionError?.code,
          ClientErrorCode.localValidation);
      await cubit.close();
    });

    test('gagal kirim mempertahankan percakapan dan melaporkan error', () async {
      repository.messagesResult = DataSuccess([_message(1, '2026-09-28 10:00:00')]);
      final cubit = SupportTicketCubit(5);
      await cubit.load();
      repository.sendResult = DataFailed(_error(ApiErrorCode.validationError));

      expect(await cubit.send('Halo'), isFalse);

      final state = cubit.state as SupportTicketReady;
      expect(state.messages, hasLength(1));
      expect(state.actionError?.code, ApiErrorCode.validationError);
      await cubit.close();
    });
  });
}
