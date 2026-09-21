/// Parsing model wishlist dan ulasan terhadap bentuk JSON yang **benar-benar
/// dikirim** server (15 September 2026).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';

void main() {
  group('WishlistItemModel', () {
    /// Baris `GET /wishlist` apa adanya.
    const json = <String, dynamic>{
      'wishlist_item_id': '2',
      'added_at': '2026-09-15 22:14:33',
      'product_id': '3',
      'name': 'Keripik Singkong Balado 250g',
      'slug': 'keripik-singkong-balado-250g',
      'min_price': '22000.00',
      'image_url': 'https://picsum.photos/seed/keripik-singkong-1/600/600',
      'product_status': 'active',
    };

    test('dua id dibedakan — yang dipakai menghapus adalah product_id', () {
      // DELETE /wishlist/items/{id} menerima id PRODUK. Sudah diuji dengan
      // keduanya sengaja berbeda: menghapus 3 membuang baris ini, yang
      // wishlist_item_id-nya 2.
      final item = WishlistItemModel.fromJson(json);

      expect(item.productId, 3);
      expect(item.wishlistItemId, 2);
      expect(item.productId, isNot(item.wishlistItemId));
    });

    test('wishlist MEMBAWA image_url, tidak seperti listing produk', () {
      final item = WishlistItemModel.fromJson(json);
      expect(item.imageUrl, isNotEmpty);
      expect(item.minPrice, 22000);
    });

    test('produk non-aktif ditandai, bukan disembunyikan', () {
      final archived =
          WishlistItemModel.fromJson({...json, 'product_status': 'archived'});
      expect(archived.isAvailable, isFalse);
      expect(WishlistItemModel.fromJson(json).isAvailable, isTrue);
    });
  });

  group('ReviewModel', () {
    const json = <String, dynamic>{
      'id': '7',
      'order_item_id': '15',
      'user_id': '186',
      'product_id': '1',
      'rating': '5',
      'comment': 'Kopinya wangi.',
      'is_anonymous': '0',
      'status': 'published',
      'created_at': '2026-09-15 22:30:00',
      'reply': null,
    };

    test('angka string terbaca sebagai angka', () {
      final review = ReviewModel.fromJson(json);
      expect(review.rating, 5);
      expect(review.productId, 1);
      expect(review.hasComment, isTrue);
    });

    test('nama pengulas selalu generik — server tidak mengirimkannya', () {
      // Responsnya hanya membawa user_id; tidak ada nama maupun avatar.
      final review = ReviewModel.fromJson(json);
      expect(review.displayName, 'Pembeli');
      expect(json.containsKey('user_name'), isFalse);
    });

    test('komentar kosong tidak dianggap ada', () {
      expect(ReviewModel.fromJson({...json, 'comment': null}).hasComment,
          isFalse);
      expect(ReviewModel.fromJson({...json, 'comment': '   '}).hasComment,
          isFalse);
    });

    test('✅ balasan penjual kini ikut di daftar', () {
      // Ditambahkan backend di `d614bd8`. Sebelumnya `list_for_product` hanya
      // `SELECT *` dari tabel `reviews`, jadi balasan yang sudah tersimpan
      // tidak pernah sampai ke pembeli MAUPUN ke penjualnya sendiri.
      final review = ReviewModel.fromJson({
        ...json,
        'reply': {
          'reply_text': 'Terima kasih kak!',
          'created_at': '2026-09-16 08:00:00',
        },
      });

      expect(review.hasReply, isTrue);
      expect(review.reply!.replyText, 'Terima kasih kak!');

      // Waktunya lewat `ServerDateTimeJson` seperti field waktu lain — dibaca
      // sebagai waktu dinding WIB lalu disimpan UTC. Yang dipatok selisihnya,
      // bukan angka absolutnya, supaya test tidak ikut berubah kalau zona
      // penyimpanannya digeser: ulasan 15/09 22:30, balasan 16/09 08:00.
      expect(review.reply!.createdAt!.difference(review.createdAt!),
          const Duration(hours: 9, minutes: 30));
    });

    test('balasan dikirim sebagai OBJEK, bukan string JSON', () {
      // Berbeda dari `data` di notifikasi dan `selected_couriers` di sesi
      // checkout, yang keduanya berupa string dan butuh JsonMapJson. Di sini
      // server merakitnya sendiri di PHP, jadi bentuknya objek sungguhan —
      // test ini yang akan memberi tahu kalau itu berubah.
      final raw = <String, dynamic>{
        ...json,
        'reply': {'reply_text': 'Siap kak', 'created_at': '2026-09-16 08:00:00'},
      };
      expect(raw['reply'], isA<Map<String, dynamic>>());
      expect(ReviewModel.fromJson(raw).reply, isA<ReviewReplyModel>());
    });

    test('ulasan tanpa balasan tetap terbaca', () {
      // `reply` null untuk ulasan yang belum dibalas — mayoritas kasusnya.
      final review = ReviewModel.fromJson(json);
      expect(review.reply, isNull);
      expect(review.hasReply, isFalse);
    });

    test('balasan berisi teks kosong tidak dianggap ada', () {
      // Endpoint balasannya tidak memvalidasi panjang, jadi `reply` bisa ada
      // tapi hampa — merendernya akan menampilkan kotak balasan kosong.
      final review = ReviewModel.fromJson({
        ...json,
        'reply': {'reply_text': '   ', 'created_at': '2026-09-16 08:00:00'},
      });
      expect(review.reply, isNotNull);
      expect(review.hasReply, isFalse);
    });
  });

  group('RatingHistogram', () {
    /// `meta` dari `GET /products/{id}/reviews` apa adanya.
    const meta = <String, dynamic>{
      'page': 1,
      'per_page': 20,
      'total': 4,
      'rating_histogram': {
        'total': 4,
        'breakdown': [
          {'rating': 5, 'count': 2, 'percentage': 50},
          {'rating': 4, 'count': 1, 'percentage': 25},
          {'rating': 3, 'count': 1, 'percentage': 25},
          {'rating': 2, 'count': 0, 'percentage': 0},
          {'rating': 1, 'count': 0, 'percentage': 0},
        ],
      },
    };

    test('sebaran per bintang terbaca lengkap', () {
      final histogram = RatingHistogram.fromMeta(meta);
      expect(histogram.total, 4);
      expect(histogram.breakdown, hasLength(5));
      expect(histogram.breakdown.first.rating, 5);
      expect(histogram.breakdown.first.count, 2);
    });

    test('rata-rata dihitung dari sebarannya', () {
      // (5*2 + 4*1 + 3*1) / 4 = 4.25
      expect(RatingHistogram.fromMeta(meta).average, 4.25);
    });

    test('ratio bar dari percentage yang sudah dihitung server', () {
      final histogram = RatingHistogram.fromMeta(meta);
      expect(histogram.breakdown.first.ratio, 0.5);
      expect(histogram.breakdown.last.ratio, 0);
    });

    test('produk tanpa ulasan menghasilkan histogram kosong tanpa bagi nol',
        () {
      final histogram = RatingHistogram.fromMeta(const {
        'rating_histogram': {'total': 0, 'breakdown': []},
      });
      expect(histogram.isEmpty, isTrue);
      expect(histogram.average, 0);
    });

    test('meta tanpa histogram tidak melempar', () {
      expect(RatingHistogram.fromMeta(const {'total': 0}).isEmpty, isTrue);
      expect(RatingHistogram.fromMeta(const {}).isEmpty, isTrue);
    });
  });

  group('ReviewDraft', () {
    test('rating di luar 1-5 ditolak sebelum dikirim', () {
      // Model backend membaca $data['rating'] tanpa validasi, jadi nilai aneh
      // akan tersimpan apa adanya.
      expect(const ReviewDraft(rating: 0).isValid, isFalse);
      expect(const ReviewDraft(rating: 6).isValid, isFalse);
      expect(const ReviewDraft(rating: 1).isValid, isTrue);
      expect(const ReviewDraft(rating: 5).isValid, isTrue);
    });

    test('body memakai tinyint untuk is_anonymous', () {
      final json = const ReviewDraft(rating: 4, isAnonymous: true).toJson();
      expect(json['is_anonymous'], 1);
      expect(json['rating'], 4);
    });

    test('komentar kosong tidak ikut dikirim', () {
      final json = const ReviewDraft(rating: 4, comment: '   ').toJson();
      expect(json.containsKey('comment'), isFalse);
    });

    test('media dikirim sebagai daftar {type, url}', () {
      final json = const ReviewDraft(
        rating: 5,
        media: [ReviewMediaDraft(type: 'photo', url: 'https://x/a.jpg')],
      ).toJson();

      expect(json['media'], [
        {'type': 'photo', 'url': 'https://x/a.jpg'},
      ]);
    });
  });
}
