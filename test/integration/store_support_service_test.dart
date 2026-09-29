/// Kontrak toko (`/stores/{id}`, `partners-performance`, ikuti toko) dan
/// Xpedia 911 (`/support-tickets*`) terhadap marketplace-api yang hidup.
///
/// ```bash
/// flutter test test/integration --concurrency=1
/// ```
///
/// Tiket **menumpuk** di akun bersama karena tidak ada endpoint hapus; semua
/// assertion di sini relatif terhadap tiket yang baru dibuat.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/store_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/support_service.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';

import 'support/test_account.dart';

/// Toko seed yang aktif; lihat `chat_service_test.dart`.
const _storeId = 2;

void main() {
  late Dio dio;
  late StoreService stores;
  late SupportService support;

  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    stores = StoreService(dio);
    support = SupportService(dio);
    await sharedAccount(dio, purpose: 'ringan');
  });

  tearDown(() => dio.close(force: true));

  group('toko', () {
    test('profil publik membawa status penjual dan lencana Signature', () async {
      final store = (await stores.fetchStore(_storeId)).data;
      expect(store.name, isNotEmpty);
      expect(SellerStatus.values.map((s) => s.name), contains(store.sellerStatus.name));
      expect(store.primaryStatus, isNotEmpty);
    });

    test('partners-performance memakai angka asli dan rating dari ulasan produk',
        () async {
      final perf = (await stores.fetchPerformance(_storeId)).data;
      expect(perf.totalOrders, greaterThanOrEqualTo(0));
      expect(perf.successRatePercent, inInclusiveRange(0, 100));
      // Seed tidak punya ulasan produk, jadi rating yang benar menurut
      // blueprint adalah 0 — walau `stores.rating_avg` bernilai "4.90". Itu
      // alasan storefront membaca rating dari sini.
      final store = (await stores.fetchStore(_storeId)).data;
      if (perf.totalReviews == 0) {
        expect(perf.hasRating, isFalse);
        expect(store.ratingAvg, isNot(perf.ratingAverage),
            reason: 'jika sama, backend sudah memperbaiki docs/22 #7');
      }
    });

    test('ikuti lalu berhenti mengikuti; mengikuti dua kali ditolak', () async {
      await stores.unfollow(_storeId); // 200 walau belum mengikuti
      await stores.follow(_storeId);

      await expectLater(
        stores.follow(_storeId),
        throwsA(predicate((e) => e.toString().contains('VALIDATION_ERROR'))),
        reason: 'follow tidak idempoten',
      );

      final following = (await stores.fetchFollowing()).data;
      expect(following.map((s) => s.id), contains(_storeId));

      await stores.unfollow(_storeId);
      final after = (await stores.fetchFollowing()).data;
      expect(after.map((s) => s.id), isNot(contains(_storeId)));
    });
  });

  group('Xpedia 911', () {
    test('membuat tiket, lalu pesan pertama memindahkannya ke in_progress',
        () async {
      final id = (await support.createTicket(
        category: SupportCategory.accountSecurity,
        subject: 'Uji otomatis',
        description: 'Tiket dari test integrasi',
      ))
          .data;
      expect(id, greaterThan(0));

      final ticket = (await support.fetchTicket(id)).data;
      expect(ticket.ticketNumber, startsWith('TIX-'));
      expect(ticket.status, 'open');
      expect(ticket.categoryValue, SupportCategory.accountSecurity);

      // `description` tidak ikut tersimpan sebagai pesan.
      expect((await support.fetchMessages(id)).data, isEmpty);

      await support.sendMessage(id, 'Halo Xpedia 911');
      final messages = (await support.fetchMessages(id)).data;
      expect(messages.single.message, 'Halo Xpedia 911');
      expect(messages.single.isAdminReply, isFalse);
      expect((await support.fetchTicket(id)).data.status, 'in_progress');

      final list = (await support.fetchTickets()).data;
      expect(list.map((t) => t.id), contains(id));
    });

    test('kategori di luar ENUM ditolak', () async {
      final response = await dio.post<dynamic>(
        '/support-tickets',
        data: {'category': 'lainnya', 'subject': 'x', 'description': 'x'},
        options: Options(validateStatus: (_) => true),
      );
      expect(response.statusCode, 422);
    });

    test('tiket yang tidak ada dibalas TICKET_NOT_FOUND', () async {
      await expectLater(
        support.fetchTicket(999999999),
        throwsA(predicate((e) => e.toString().contains('TICKET_NOT_FOUND'))),
      );
    });
  });
}
