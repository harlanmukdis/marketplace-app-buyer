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
/// sebagai penjual seed lalu mengundang akun ujinya sebagai staf. Itu jalan
/// memutar, dan kalau suatu saat backend menerbitkan notifikasi dari alur
/// pesanan, test ini bisa disederhanakan jadi "beli lalu periksa kotak
/// masuk".
///
/// ## 🔴 Kotak masuk TIDAK bisa dikosongkan, jadi pembelinya baru tiap putaran
///
/// Tidak ada endpoint hapus notifikasi. Akun bersama lintas putaran akan
/// menumpuk notifikasi sampai setiap assertion jumlah jadi salah, jadi berkas
/// ini memakai **satu pembeli baru per putaran** — satu login, bukan satu per
/// test (lihat plafon 20 login per IP di `support/test_account.dart`).
///
/// Login penjualnya sendiri **di-cache lintas putaran**, jadi ketiga seed itu
/// hanya benar-benar login sekali seumur cache.
///
/// Kotak masuknya diisi sekali di `setUpAll` dari tiga toko seed — seorang
/// pembeli hanya bisa diundang **sekali per toko**, jadi jumlah toko adalah
/// batas atasnya. Karena itu assertion di sini **relatif** ("ada yang
/// belum dibaca", "lebih dari satu"), bukan jumlah mutlak.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/notification_service.dart';

import 'support/test_account.dart';

/// Penjual seed beserta id tokonya (panduan FE §3).
///
/// Tiga, bukan kedelapannya: seluruh assertion di berkas ini relatif ("ada
/// yang belum dibaca", "lebih dari satu"), jadi tiga notifikasi sudah cukup —
/// dan tiap penjual tambahan berarti satu login lagi saat cache dingin.
const _sellers = <({String email, int storeId})>[
  (email: 'budi.santoso@kedaikopi.id', storeId: 1),
  (email: 'agus.wijaya@gadgetstore.id', storeId: 2),
  (email: 'rudi.hartono@rumahmode.id', storeId: 3),
];

void main() {
  late Dio dio;
  late NotificationService notifications;
  late TestAccount buyer;

  /// Menerbitkan satu notifikasi untuk [buyer] lewat undangan staf.
  ///
  /// Memakai koneksi terpisah supaya token penjual tidak mengotori `dio`
  /// milik pembeli.
  Future<void> inviteAsStaff(({String email, int storeId}) seller) async {
    final sellerDio = DioClient.createBare(Env.apiBaseUrl);
    try {
      await loginAs(sellerDio, email: seller.email);
      await sellerDio.post<dynamic>(
        '/stores/${seller.storeId}/staff/invite',
        data: {'email': buyer.email, 'store_staff_role_id': 1},
      );
    } finally {
      sellerDio.close(force: true);
    }
  }

  setUpAll(() async {
    final bootstrap = DioClient.createBare(Env.apiBaseUrl);
    try {
      buyer = await freshAccount(bootstrap, label: 'Notifikasi');
    } finally {
      bootstrap.close(force: true);
    }

    // Diundang berturut-turut supaya sebagian pasti berbagi stempel waktu
    // yang sama — itu yang diperiksa test urutan di bawah.
    for (final seller in _sellers) {
      await inviteAsStaff(seller);
    }
  });

  setUp(() {
    dio = DioClient.createBare(Env.apiBaseUrl);
    dio.options.headers['Authorization'] = 'Bearer ${buyer.accessToken}';
    notifications = NotificationService(dio);
  });

  tearDown(() => dio.close(force: true));

  /// Akun yang tidak pernah diundang siapa pun, jadi kotak masuknya permanen
  /// kosong — aman dipakai ulang lintas putaran.
  Future<Dio> emptyInboxAccount() async {
    final other = DioClient.createBare(Env.apiBaseUrl);
    await sharedAccount(other, purpose: 'kosong');
    return other;
  }

  group('GET /me/notifications', () {
    test('kotak masuk tanpa undangan tetap kosong — dan itu keadaan normalnya',
        () async {
      // Bukan sekadar "akun baru belum punya apa-apa": pembeli mana pun akan
      // tetap kosong selamanya sampai backend memasang pemanggilan
      // Notification_model->create() di alur pesanan/pembayaran.
      final other = await emptyInboxAccount();
      addTearDown(() => other.close(force: true));

      final result = await NotificationService(other).fetchNotifications();
      expect(result.data, isEmpty);
    });

    test('🔴 respons TIDAK membawa meta paginasi sama sekali', () async {
      // Karena itu NotificationCubit menyimpulkan adanya halaman berikutnya
      // dari "halaman terakhir terisi penuh", bukan dari meta.total.
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
      final raw = await dio.get<dynamic>('/me/notifications');
      final row = (raw.data['data'] as List).first as Map;
      expect(row['data'], isA<String>());

      // Dan model tetap membacanya sebagai map.
      final parsed = (await notifications.fetchNotifications()).data.first;
      expect(parsed.data, isA<Map<String, dynamic>>());
      expect(parsed.data!['store_id'], isNotNull);
    });

    test('🔴 urutannya TIDAK stabil untuk notifikasi sedetik', () async {
      // `list_for_user` mengurutkan `ORDER BY created_at DESC` saja, tanpa
      // pemecah seri, sementara `created_at` bertipe DATETIME yang
      // resolusinya satu detik. Notifikasi yang terbit berbarengan karena itu
      // kembali dalam urutan sembarang.
      //
      // ⚠️ Arah serinya **sembarang**, jadi yang dipatok adalah fakta
      // deterministiknya — stempel waktunya bertabrakan, sehingga `id` wajib
      // jadi pemecah seri (`NotificationCubit._merge`). Memaku salah satu
      // arah akan membuat test ini merah sewaktu-waktu tanpa ada yang
      // berubah.
      final result = await notifications.fetchNotifications();
      expect(result.data.length, greaterThan(1));

      final stamps = result.data.map((n) => n.createdAt).toList();
      final collides = stamps.toSet().length < stamps.length;
      if (!collides) {
        // Kebetulan tiap undangan jatuh di detik yang berbeda — di sini
        // server memang bisa mengurutkan dengan benar.
        final sorted = [...stamps]..sort((a, b) => b!.compareTo(a!));
        expect(stamps, sorted);
        return;
      }

      expect(result.data.map((n) => n.id).toSet(), hasLength(result.data.length),
          reason: 'id-nya tetap unik, jadi bisa dipakai sebagai pemecah seri');
    });

    test('halaman jauh di belakang mengembalikan daftar kosong', () async {
      final result = await notifications.fetchNotifications(page: 99);
      expect(result.data, isEmpty);
    });

    test('🔴 ?per_page= DIABAIKAN server', () async {
      // Controllernya memanggil list_for_user($userId, $page) — persis dua
      // parameter — jadi ukuran halaman tidak bisa diatur pemanggil. Itu
      // sebabnya NotificationService tidak menerima parameter perPage sama
      // sekali: menyediakannya hanya membuat pemanggil mengira bisa
      // mengaturnya.
      final limited = await dio.get<dynamic>(
        '/me/notifications',
        queryParameters: {'per_page': 1},
      );
      expect((limited.data['data'] as List).length, greaterThan(1),
          reason: 'diminta 1, tetap dikirim semuanya');
    });
  });

  group('menandai terbaca', () {
    test('menandai satu notifikasi benar-benar mengubahnya', () async {
      // Dicari yang masih belum dibaca, bukan `.single`: kotak masuk berisi
      // beberapa undangan, dan test read-all di bawah menandai semuanya.
      final before = (await notifications.fetchNotifications()).data;
      final target = before.firstWhere((n) => !n.isRead);

      final response = await notifications.markRead(target.id);
      expect(response.statusCode, 200);

      final after = (await notifications.fetchNotifications())
          .data
          .firstWhere((n) => n.id == target.id);
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
      final mine = (await notifications.fetchNotifications())
          .data
          .firstWhere((n) => !n.isRead);

      // Pembeli lain mencoba menandai notifikasi milik pembeli ini.
      final other = await emptyInboxAccount();
      addTearDown(() => other.close(force: true));

      final response = await NotificationService(other).markRead(mine.id);
      expect(response.statusCode, 200,
          reason: 'ditolak diam-diam, bukan 403/404');

      // Klausa WHERE user_id melindungi datanya — hanya statusnya yang
      // menyesatkan.
      final after = (await notifications.fetchNotifications())
          .data
          .firstWhere((n) => n.id == mine.id);
      expect(after.isRead, isFalse);
    });

    test('read-all menandai seluruhnya sekaligus', () async {
      await notifications.markAllRead();

      final after = await notifications.fetchNotifications();
      expect(after.data, isNotEmpty);
      expect(after.data.every((n) => n.isRead), isTrue);
    });

    test('read-all pada kotak masuk kosong tidak melempar', () async {
      final other = await emptyInboxAccount();
      addTearDown(() => other.close(force: true));

      final response = await NotificationService(other).markAllRead();
      expect(response.statusCode, 200);
    });
  });
}
