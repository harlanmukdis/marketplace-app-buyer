/// Perilaku [NotificationCubit] terhadap repository palsu.
///
/// Fokusnya pada tiga hal yang dipaksa keterbatasan server: paginasi yang
/// **disimpulkan** (tidak ada `meta`), jumlah belum dibaca yang hanya **batas
/// bawah** (tidak ada endpoint penghitung), dan penandaan terbaca yang
/// **optimistis lalu dikembalikan kalau gagal** (endpointnya membalas
/// `data: null`, dan `200` bahkan untuk id yang tidak ada).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/notification_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/notification_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/notification/cubit/notification_cubit.dart';

/// Id yang lebih besar berarti lebih baru, seperti kolom auto-increment
/// sungguhan. [createdAt] bisa disamakan antar beberapa notifikasi untuk
/// meniru stempel waktu yang bertabrakan di detik yang sama.
NotificationModel _notification(
  int id, {
  bool isRead = false,
  DateTime? createdAt,
}) =>
    NotificationModel(
      id: id,
      typeCode: 'order_paid',
      title: 'Notifikasi $id',
      body: 'Isi $id',
      isRead: isRead,
      createdAt: createdAt ?? DateTime.utc(2026, 9, 15, 12, 0, id),
    );

List<NotificationModel> _page(int count, {int from = 1}) =>
    [for (var i = 0; i < count; i++) _notification(from + i)];

/// Mencari satu notifikasi menurut id, supaya test tidak bergantung pada
/// posisinya di daftar.
NotificationModel _byId(NotificationLoaded state, int id) =>
    state.notifications.firstWhere((n) => n.id == id);

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeNotificationRepository implements NotificationRepository {
  /// Hasil per halaman; halaman yang tidak terdaftar dianggap kosong.
  final Map<int, DataState<List<NotificationModel>>> pages = {
    1: DataSuccess(_page(3)),
  };

  DataState<void> markReadResult = const DataSuccess(null);
  DataState<void> markAllReadResult = const DataSuccess(null);

  final List<String> calls = [];

  @override
  Future<DataState<List<NotificationModel>>> fetchNotifications({
    int page = 1,
  }) async {
    calls.add('fetch:$page');
    return pages[page] ?? const DataEmpty();
  }

  @override
  Future<DataState<void>> markRead(int id) async {
    calls.add('read:$id');
    return markReadResult;
  }

  @override
  Future<DataState<void>> markAllRead() async {
    calls.add('read-all');
    return markAllReadResult;
  }
}

void main() {
  late _FakeNotificationRepository repository;

  setUp(() {
    repository = _FakeNotificationRepository();
    injector.registerSingleton<NotificationRepository>(repository);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('memuat', () {
    test('kotak masuk kosong jadi status tersendiri, bukan daftar hampa',
        () async {
      // Kosong adalah keadaan NORMAL di domain ini: backend tidak pernah
      // menerbitkan notifikasi untuk pembeli. Layarnya harus bisa
      // menjelaskannya, bukan menampilkan daftar kosong yang terlihat seperti
      // gagal memuat.
      repository.pages[1] = const DataEmpty();

      final cubit = NotificationCubit();
      await cubit.load();

      expect(cubit.state, isA<NotificationEmpty>());
      await cubit.close();
    });

    test('gagal memuat berakhir di status error', () async {
      repository.pages[1] = DataFailed(_error('NETWORK'));

      final cubit = NotificationCubit();
      await cubit.load();

      expect(cubit.state, isA<NotificationError>());
      await cubit.close();
    });

    test('halaman yang belum penuh berarti tidak ada halaman berikutnya',
        () async {
      // Tidak ada `meta` di respons, jadi ini satu-satunya petunjuk yang ada.
      final cubit = NotificationCubit();
      await cubit.load();

      final state = cubit.state as NotificationLoaded;
      expect(state.notifications, hasLength(3));
      expect(state.hasMore, isFalse);
      await cubit.close();
    });

    test('halaman terisi penuh dianggap masih ada lanjutannya', () async {
      repository.pages[1] =
          DataSuccess(_page(NotificationService.serverPageSize));

      final cubit = NotificationCubit();
      await cubit.load();

      expect((cubit.state as NotificationLoaded).hasMore, isTrue);
      await cubit.close();
    });
  });

  group('paginasi', () {
    setUp(() {
      repository.pages[1] =
          DataSuccess(_page(NotificationService.serverPageSize));
      repository.pages[2] = DataSuccess(_page(5, from: 100));
    });

    test('halaman berikutnya ditambahkan, bukan menggantikan', () async {
      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.loadMore();

      final state = cubit.state as NotificationLoaded;
      expect(
        state.notifications,
        hasLength(NotificationService.serverPageSize + 5),
      );
      expect(state.page, 2);
      expect(state.hasMore, isFalse);
      await cubit.close();
    });

    test('halaman kosong menghentikan paginasi tanpa dianggap error',
        () async {
      repository.pages.remove(2);

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.loadMore();

      final state = cubit.state as NotificationLoaded;
      expect(state.hasMore, isFalse);
      expect(state.loadMoreError, isNull);
      await cubit.close();
    });

    test('gagal memuat halaman berikutnya tidak mengosongkan yang sudah ada',
        () async {
      repository.pages[2] = DataFailed(_error('NETWORK'));

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.loadMore();

      final state = cubit.state as NotificationLoaded;
      expect(
        state.notifications,
        hasLength(NotificationService.serverPageSize),
      );
      expect(state.loadMoreError, isNotNull);
      await cubit.close();
    });
  });

  group('🔴 menambal urutan server yang tidak stabil', () {
    test('notifikasi sedetik dikembalikan TERLAMA DULU, diurutkan ulang',
        () async {
      // Diuji ke server: tiga notifikasi berstempel `2026-09-15 23:32:09`
      // kembali dengan id 13, 14, 15 — menaik, jadi terlama dulu. Penyebabnya
      // `ORDER BY created_at DESC` tanpa pemecah seri, di atas kolom DATETIME
      // yang resolusinya satu detik.
      final sameSecond = DateTime.utc(2026, 9, 15, 23, 32, 9);
      repository.pages[1] = DataSuccess([
        _notification(13, createdAt: sameSecond),
        _notification(14, createdAt: sameSecond),
        _notification(15, createdAt: sameSecond),
      ]);

      final cubit = NotificationCubit();
      await cubit.load();

      final state = cubit.state as NotificationLoaded;
      expect(state.notifications.map((n) => n.id), [15, 14, 13]);
      await cubit.close();
    });

    test('stempel waktu berbeda tetap mengikuti urutan server', () async {
      // Pengurutan ulang hanya boleh memperbaiki seri, bukan menyusun ulang
      // daftar yang urutannya sudah benar.
      repository.pages[1] = DataSuccess([
        _notification(9, createdAt: DateTime.utc(2026, 9, 15, 23, 40)),
        _notification(2, createdAt: DateTime.utc(2026, 9, 15, 23, 30)),
        _notification(7, createdAt: DateTime.utc(2026, 9, 15, 23, 20)),
      ]);

      final cubit = NotificationCubit();
      await cubit.load();

      expect(
        (cubit.state as NotificationLoaded).notifications.map((n) => n.id),
        [9, 2, 7],
      );
      await cubit.close();
    });

    test('baris yang muncul di DUA halaman hanya tampil sekali', () async {
      // LIMIT/OFFSET di atas urutan tak deterministik tidak menjamin satu
      // baris cuma muncul di satu halaman. Tanpa penyaringan ini, notifikasi
      // yang sama tampil dua kali di layar.
      final firstPage = _page(NotificationService.serverPageSize);
      repository.pages[1] = DataSuccess(firstPage);
      repository.pages[2] = DataSuccess([
        firstPage.last, // terulang dari halaman sebelumnya
        _notification(100),
      ]);

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.loadMore();

      final ids =
          (cubit.state as NotificationLoaded).notifications.map((n) => n.id);
      expect(ids.toSet(), hasLength(ids.length));
      expect(ids, hasLength(NotificationService.serverPageSize + 1));
      await cubit.close();
    });

    test('tanda terbaca yang baru disetel tidak tertimpa halaman berikutnya',
        () async {
      // Baris yang terulang datang dari server dengan is_read lamanya. Kalau
      // salinan baru menang, notifikasi yang baru saja dibuka berkedip jadi
      // belum dibaca lagi.
      final firstPage = _page(NotificationService.serverPageSize);
      repository.pages[1] = DataSuccess(firstPage);
      repository.pages[2] = DataSuccess([firstPage.last]);

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markRead(firstPage.last.id);
      await cubit.loadMore();

      final state = cubit.state as NotificationLoaded;
      expect(_byId(state, firstPage.last.id).isRead, isTrue);
      await cubit.close();
    });
  });

  group('jumlah belum dibaca', () {
    test('dihitung dari yang sudah dimuat', () async {
      repository.pages[1] = DataSuccess([
        _notification(1),
        _notification(2, isRead: true),
        _notification(3),
      ]);

      final cubit = NotificationCubit();
      await cubit.load();

      final state = cubit.state as NotificationLoaded;
      expect(state.unreadCount, 2);
      expect(state.unreadCountIsPartial, isFalse);
      expect(state.unreadLabel, '2');
      await cubit.close();
    });

    test('⚠️ ditandai sebagai batas bawah selama masih ada halaman lain',
        () async {
      // Tidak ada endpoint penghitung di backend, jadi angkanya tidak bisa
      // lebih baik dari halaman yang sudah diambil. Menampilkannya tanpa
      // penanda akan membuat user mengira kotak masuknya lebih sepi dari
      // sebenarnya.
      repository.pages[1] =
          DataSuccess(_page(NotificationService.serverPageSize));

      final cubit = NotificationCubit();
      await cubit.load();

      final state = cubit.state as NotificationLoaded;
      expect(state.unreadCountIsPartial, isTrue);
      expect(state.unreadLabel, '${NotificationService.serverPageSize}+');
      await cubit.close();
    });
  });

  group('menandai terbaca', () {
    test('barisnya berubah lebih dulu, tanpa membaca ulang daftar', () async {
      // Baca ulang akan menghabiskan satu permintaan penuh dan melompatkan
      // posisi gulir setiap kali satu baris disentuh.
      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markRead(1);

      final state = cubit.state as NotificationLoaded;
      expect(_byId(state, 1).isRead, isTrue);
      expect(state.unreadCount, 2);
      expect(repository.calls, ['fetch:1', 'read:1']);
      await cubit.close();
    });

    test('gagal menandai MENGEMBALIKAN tandanya', () async {
      // Kalau tidak, barisnya terlihat terbaca padahal server masih
      // menganggapnya baru — dan akan "muncul lagi" saat berikutnya dimuat.
      repository.markReadResult = DataFailed(_error('NETWORK'));

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markRead(1);

      final state = cubit.state as NotificationLoaded;
      expect(_byId(state, 1).isRead, isFalse);
      expect(state.actionError, isNotNull);
      await cubit.close();
    });

    test('notifikasi yang sudah terbaca tidak dikirim ulang ke server',
        () async {
      repository.pages[1] = DataSuccess([_notification(1, isRead: true)]);

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markRead(1);

      expect(repository.calls, ['fetch:1']);
      await cubit.close();
    });

    test('id yang tidak ada di daftar tidak menyentuh jaringan', () async {
      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markRead(9999);

      expect(repository.calls, ['fetch:1']);
      await cubit.close();
    });
  });

  group('menandai semua terbaca', () {
    test('seluruh baris yang dimuat berubah dalam satu permintaan', () async {
      // Server menandai semuanya termasuk halaman yang belum dimuat, jadi
      // tidak perlu menyusuri halaman satu per satu.
      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markAllRead();

      final state = cubit.state as NotificationLoaded;
      expect(state.unreadCount, 0);
      expect(repository.calls, ['fetch:1', 'read-all']);
      await cubit.close();
    });

    test('gagal mengembalikan seluruh tanda semula', () async {
      repository.pages[1] = DataSuccess([
        _notification(1),
        _notification(2, isRead: true),
      ]);
      repository.markAllReadResult = DataFailed(_error('NETWORK'));

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markAllRead();

      final state = cubit.state as NotificationLoaded;
      expect(_byId(state, 1).isRead, isFalse);
      // Termasuk mempertahankan baris yang memang sudah terbaca sejak awal.
      expect(_byId(state, 2).isRead, isTrue);
      expect(state.actionError, isNotNull);
      await cubit.close();
    });

    test('tidak dipanggil saat semuanya sudah terbaca dan tidak ada lanjutan',
        () async {
      repository.pages[1] = DataSuccess([_notification(1, isRead: true)]);

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markAllRead();

      expect(repository.calls, ['fetch:1']);
      await cubit.close();
    });

    test('tetap dipanggil saat halaman berikutnya bisa menyimpan yang belum '
        'dibaca', () async {
      // Semua yang dimuat sudah terbaca, tapi halaman berikutnya belum
      // diperiksa — menolak di sini akan membuat tombolnya tidak berfungsi
      // untuk notifikasi yang tidak terlihat.
      repository.pages[1] = DataSuccess([
        for (var i = 0; i < NotificationService.serverPageSize; i++)
          _notification(i + 1, isRead: true),
      ]);

      final cubit = NotificationCubit();
      await cubit.load();
      await cubit.markAllRead();

      expect(repository.calls, ['fetch:1', 'read-all']);
      await cubit.close();
    });
  });
}
