/// Parsing model notifikasi terhadap bentuk JSON dari server.
///
/// JSON di bawah **disalin apa adanya** dari respons `GET /me/notifications`
/// sungguhan. Menerbitkan satu notifikasi untuk menangkapnya butuh jalan
/// memutar: backend tidak pernah membuat notifikasi dari alur pembeli mana
/// pun, jadi barisnya dibuat lewat undangan staf toko — satu-satunya pemanggil
/// `Notification_model->create()` yang ada di seluruh kode backend.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';

void main() {
  /// Respons sungguhan, termasuk `data` yang **berupa string berisi JSON**.
  const json = <String, dynamic>{
    'id': '1',
    'user_id': '821',
    'type': 'staff_invitation',
    'title': 'Undangan Staf Toko',
    'body': 'Anda diundang bergabung sebagai staf toko "Kedai Kopi Nusantara"',
    'data': '{"store_id":"1","invitation_token":"32fd40e8666091cb1b6d2c80"}',
    'is_read': '0',
    'created_at': '2026-09-15 23:22:50',
  };

  group('NotificationModel', () {
    test('membaca baris notifikasi sungguhan', () {
      final notification = NotificationModel.fromJson(json);

      expect(notification.id, 1);
      expect(notification.title, 'Undangan Staf Toko');
      expect(notification.body, contains('Kedai Kopi Nusantara'));
      expect(notification.createdAt, isNotNull);
    });

    test('🔴 `data` yang berupa string JSON tetap terbaca sebagai map', () {
      // Jebakan yang sama dengan `selected_couriers` di sesi checkout: kolom
      // bertipe JSON di MySQL diteruskan driver PHP sebagai string. Tanpa
      // JsonMapJson, baris ini melempar CastError dan menggagalkan seluruh
      // halaman notifikasi — bukan satu barisnya saja.
      final notification = NotificationModel.fromJson(json);

      expect(notification.data, isA<Map<String, dynamic>>());
      expect(notification.data!['store_id'], '1');
    });

    test('`data` rusak menghasilkan null, bukan lemparan', () {
      // Satu notifikasi dengan muatan rusak tidak boleh mengosongkan kotak
      // masuk.
      final notification =
          NotificationModel.fromJson({...json, 'data': 'bukan json'});
      expect(notification.data, isNull);
      expect(notification.hasDestination, isFalse);
    });

    test('`data` null diterima apa adanya', () {
      final notification = NotificationModel.fromJson({...json, 'data': null});
      expect(notification.data, isNull);
      expect(notification.title, isNotEmpty);
    });

    test('is_read "0" terbaca false, bukan truthy', () {
      // String "0" itu truthy kalau diperiksa sembarangan — sumber bug halus
      // yang akan membuat semua notifikasi terlihat sudah dibaca.
      expect(NotificationModel.fromJson(json).isRead, isFalse);
      expect(NotificationModel.fromJson(json).isUnread, isTrue);
      expect(
        NotificationModel.fromJson({...json, 'is_read': '1'}).isRead,
        isTrue,
      );
    });
  });

  group('tujuan deep-link', () {
    test('order_id dibaca walau nilainya string', () {
      // Nilai di dalam `data` ikut aturan angka-sebagai-string seperti sisa
      // API — terbukti pada `{"store_id":"1"}` di atas.
      final notification = NotificationModel.fromJson(
        {...json, 'type': 'order_paid', 'data': '{"order_id":"42"}'},
      );

      expect(notification.orderId, 42);
      expect(notification.hasDestination, isTrue);
    });

    test('order_id berupa angka asli juga dibaca', () {
      final notification = NotificationModel.fromJson(
        {...json, 'data': {'order_id': 42}},
      );
      expect(notification.orderId, 42);
    });

    test('notifikasi tanpa tujuan tidak mengaku punya tujuan', () {
      // Undangan staf membawa store_id — tapi app member tidak punya layar
      // toko, jadi ia bukan tujuan yang bisa dibuka.
      final notification = NotificationModel.fromJson(json);
      expect(notification.orderId, isNull);
      expect(notification.productId, isNull);
      expect(notification.hasDestination, isFalse);
    });
  });

  group('NotificationKind', () {
    test('menggolongkan kode yang dijanjikan notification_templates', () {
      // Empat kode ini tercantum di kolom `code` tabel templat sebagai niat
      // backend, walau belum satu pun pernah terbit.
      expect(NotificationKind.fromType('order_paid'), NotificationKind.payment);
      expect(
        NotificationKind.fromType('order_shipped'),
        NotificationKind.shipment,
      );
      expect(
        NotificationKind.fromType('voucher_expiring'),
        NotificationKind.promo,
      );
      expect(
        NotificationKind.fromType('chat_new_message'),
        NotificationKind.chat,
      );
    });

    test('menggolongkan satu-satunya jenis yang benar-benar terbit', () {
      expect(
        NotificationKind.fromType('staff_invitation'),
        NotificationKind.account,
      );
    });

    test('jenis tak dikenal jatuh ke golongan umum, bukan melempar', () {
      // Kolomnya VARCHAR bebas, bukan ENUM — jenis baru akan muncul tanpa
      // aba-aba, dan notifikasinya tetap harus tampil utuh.
      expect(
        NotificationKind.fromType('sesuatu_yang_baru'),
        NotificationKind.other,
      );
      expect(NotificationKind.fromType(null), NotificationKind.other);
      expect(NotificationKind.fromType(''), NotificationKind.other);
    });

    test('pencocokan kata kunci menampung varian yang belum ada', () {
      expect(
        NotificationKind.fromType('order_cancelled'),
        NotificationKind.order,
      );
      expect(
        NotificationKind.fromType('refund_approved'),
        NotificationKind.payment,
      );
      expect(
        NotificationKind.fromType('flash_sale_started'),
        NotificationKind.promo,
      );
    });
  });
}
