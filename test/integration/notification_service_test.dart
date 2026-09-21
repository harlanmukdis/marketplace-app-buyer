/// Kontrak `/me/notifications*` terhadap marketplace-api yang **benar-benar
/// jalan**.
///
/// ```bash
/// flutter test test/integration --concurrency=1
/// ```
///
/// ## 🔴 Test ini harus MENERBITKAN notifikasinya sendiri
///
/// Alur pembeli tidak pernah menghasilkan notifikasi. Ditelusuri ke seluruh
/// kode backend: satu-satunya pemanggil `Notification_model->create()` adalah
/// **undangan staf toko** (`store_staff/controllers/Staff.php`) — tidak ada
/// yang terbit dari pesanan, pembayaran, pengiriman, chat, atau voucher,
/// padahal `notification_templates` mencantumkan `order_paid`,
/// `order_shipped`, `voucher_expiring`, dan `chat_new_message` sebagai
/// niatnya.
///
/// Jadi supaya bentuk responsnya bisa dipatok sama sekali, test ini login
/// sebagai dua penjual seed lalu mengundang akun ujinya sebagai staf. Itu
/// jalan memutar, dan kalau suatu saat backend menerbitkan notifikasi dari
/// alur pesanan, test ini bisa disederhanakan jadi "beli lalu periksa kotak
/// masuk".
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/notification_service.dart';

/// Penjual seed beserta id tokonya (panduan FE §3).
const _sellers = <({String email, int storeId})>[
  (email: 'budi.santoso@kedaikopi.id', storeId: 1),
  (email: 'agus.wijaya@gadgetstore.id', storeId: 2),
];
const _seedPassword = 'RahasiaAman123';

void main() {
  late Dio dio;
  late NotificationService notifications;
  late String buyerEmail;

  /// Menerbitkan satu notifikasi untuk [buyerEmail] lewat undangan staf.
  ///
  /// Memakai koneksi terpisah supaya token penjual tidak mengotori `dio`
  /// milik pembeli.
  Future<void> inviteAsStaff(({String email, int storeId}) seller) async {
    final sellerDio = DioClient.createBare(Env.apiBaseUrl);
    try {
      await loginAs(sellerDio, email: seller.email, password: _seedPassword);

      await sellerDio.post<dynamic>(
        '/stores/${seller.storeId}/staff/invite',
        data: {'email': buyerEmail, 'store_staff_role_id': 1},
      );
    } finally {
      sellerDio.close(force: true);
    }
  }

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    final auth = AuthService(dio);
    notifications = NotificationService(dio);

    final stamp = DateTime.now().microsecondsSinceEpoch;
    buyerEmail = 'uji.notif.$stamp@marketplace.local';
    final phone =
        '08${stamp.toString().substring(stamp.toString().length - 10)}';

    await auth.register(
      email: buyerEmail,
      password: _seedPassword,
      fullName: 'Uji Notifikasi',
      phone: phone,
    );
    await loginAs(dio, email: buyerEmail, password: _seedPassword);
  });

  tearDown(() => dio.close(force: true));

  group('GET /me/notifications', () {
    test('kotak masuk akun baru kosong — dan itu keadaan normalnya', () async {
      // Bukan sekadar "akun baru belum punya apa-apa": pembeli mana pun akan
      // tetap kosong selamanya sampai backend memasang pemanggilan
      // Notification_model->create() di alur pesanan/pembayaran.
      final result = await notifications.fetchNotifications();
      expect(result.data, isEmpty);
    });

    test('🔴 respons TIDAK membawa meta paginasi sama sekali', () async {
      // Karena itu NotificationCubit menyimpulkan adanya halaman berikutnya
      // dari "halaman terakhir terisi penuh", bukan dari meta.total.
      await inviteAsStaff(_sellers.first);

      final result = await notifications.fetchNotifications();
      expect(result.data, isNotEmpty);
      expect(result.meta, isEmpty,
          reason: 'tidak ada total/per_page di respons');
    });

    test('notifikasi membawa `data` sebagai STRING JSON, bukan objek',
        () async {
      // Jebakan yang sama dengan `selected_couriers` di sesi checkout. Kalau
      // suatu saat backend mengirimkannya sebagai objek sungguhan,
      // JsonMapJson tetap membacanya — tapi test ini yang akan lebih dulu
      // memberi tahu bahwa bentuknya berubah.
      await inviteAsStaff(_sellers.first);

      final raw = await dio.get<dynamic>('/me/notifications');
      final row = (raw.data['data'] as List).first as Map;
      expect(row['data'], isA<String>());

      // Dan model tetap membacanya sebagai map.
      final parsed = (await notifications.fetchNotifications()).data.first;
      expect(parsed.data, isA<Map<String, dynamic>>());
      expect(parsed.data!['store_id'], isNotNull);
    });

    test('🔴 urutannya TIDAK stabil untuk notifikasi sedetik — terlama dulu',
        () async {
      // `list_for_user` mengurutkan `ORDER BY created_at DESC` saja, tanpa
      // pemecah seri, sementara `created_at` bertipe DATETIME yang
      // resolusinya satu detik. Dua notifikasi yang terbit berbarengan karena
      // itu kembali dalam urutan sembarang — di praktiknya urutan primary
      // key, alias KEBALIKAN dari yang dijanjikan.
      //
      // Dipatok apa adanya: kalau backend menambahkan `, id DESC`, test ini
      // merah lebih dulu dan penambalan di NotificationCubit._merge bisa
      // ditinjau ulang.
      await inviteAsStaff(_sellers[0]);
      await inviteAsStaff(_sellers[1]);

      final result = await notifications.fetchNotifications();
      expect(result.data, hasLength(2));

      final sameSecond =
          result.data.first.createdAt == result.data.last.createdAt;
      if (!sameSecond) {
        // Kebetulan melewati batas detik — di sini server memang benar.
        expect(result.data.first.createdAt!
            .isAfter(result.data.last.createdAt!), isTrue);
        return;
      }

      // ⚠️ Arah serinya **sembarang**: diamati menaik di sini, tapi endpoint
      // chat yang punya bug persis sama mengembalikan menurun pada run lain.
      // Jadi yang dipatok adalah fakta deterministiknya — stempel waktunya
      // bertabrakan, sehingga `id` wajib jadi pemecah seri
      // (`NotificationCubit._merge`). Memaku salah satu arah akan membuat
      // test ini merah sewaktu-waktu tanpa ada yang berubah.
      expect(
        {result.data.first.createdAt, result.data.last.createdAt},
        hasLength(1),
        reason: 'dua notifikasi berbagi satu stempel waktu, jadi urutan di '
            'antara mereka tidak bisa disimpulkan dari created_at',
      );
      expect(result.data.map((n) => n.id).toSet(), hasLength(2));
    });

    test('halaman jauh di belakang mengembalikan daftar kosong', () async {
      await inviteAsStaff(_sellers.first);
      final result = await notifications.fetchNotifications(page: 99);
      expect(result.data, isEmpty);
    });

    test('🔴 ?per_page= DIABAIKAN server', () async {
      // Controllernya memanggil list_for_user($userId, $page) — persis dua
      // parameter — jadi ukuran halaman tidak bisa diatur pemanggil. Itu
      // sebabnya NotificationService tidak menerima parameter perPage sama
      // sekali: menyediakannya hanya membuat pemanggil mengira bisa
      // mengaturnya.
      await inviteAsStaff(_sellers[0]);
      await inviteAsStaff(_sellers[1]);

      final limited = await dio.get<dynamic>(
        '/me/notifications',
        queryParameters: {'per_page': 1},
      );
      expect((limited.data['data'] as List), hasLength(2),
          reason: 'diminta 1, tetap dikirim 2');
    });
  });

  group('menandai terbaca', () {
    test('menandai satu notifikasi benar-benar mengubahnya', () async {
      await inviteAsStaff(_sellers.first);
      final before = (await notifications.fetchNotifications()).data.single;
      expect(before.isRead, isFalse);

      final response = await notifications.markRead(before.id);
      expect(response.statusCode, 200);

      final after = (await notifications.fetchNotifications()).data.single;
      expect(after.isRead, isTrue);
    });

    test('🔴 id yang TIDAK ADA tetap dibalas 200', () async {
      // Modelnya menjalankan UPDATE … WHERE id AND user_id tanpa memeriksa
      // jumlah baris terpengaruh. Karena itu sukses bukan bukti sesuatu
      // berubah — pola yang sama dengan mutasi keranjang.
      final response = await notifications.markRead(99999999);
      expect(response.statusCode, 200);
    });

    test('🔴 notifikasi MILIK ORANG LAIN juga dibalas 200, tanpa berubah',
        () async {
      await inviteAsStaff(_sellers.first);
      final mine = (await notifications.fetchNotifications()).data.single;

      // Pembeli kedua mencoba menandai notifikasi milik pembeli pertama.
      final otherDio = DioClient.createBare(Env.apiBaseUrl);
      try {
        final stamp = DateTime.now().microsecondsSinceEpoch;
        final otherEmail = 'uji.notif.lain.$stamp@marketplace.local';
        final auth = AuthService(otherDio);
        await auth.register(
          email: otherEmail,
          password: _seedPassword,
          fullName: 'Uji Notifikasi Lain',
          phone: '08${stamp.toString().substring(stamp.toString().length - 10)}',
        );
        await loginAs(otherDio, email: otherEmail, password: _seedPassword);

        final response = await NotificationService(otherDio).markRead(mine.id);
        expect(response.statusCode, 200,
            reason: 'ditolak diam-diam, bukan 403/404');
      } finally {
        otherDio.close(force: true);
      }

      // Klausa WHERE user_id melindungi datanya — hanya statusnya yang
      // menyesatkan.
      final after = (await notifications.fetchNotifications()).data.single;
      expect(after.isRead, isFalse);
    });

    test('read-all menandai seluruhnya sekaligus', () async {
      await inviteAsStaff(_sellers[0]);
      await inviteAsStaff(_sellers[1]);

      await notifications.markAllRead();

      final after = await notifications.fetchNotifications();
      expect(after.data, hasLength(2));
      expect(after.data.every((n) => n.isRead), isTrue);
    });

    test('read-all pada kotak masuk kosong tidak melempar', () async {
      final response = await notifications.markAllRead();
      expect(response.statusCode, 200);
    });
  });
}
