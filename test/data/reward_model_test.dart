/// Parsing model reward terhadap bentuk JSON dari server.
///
/// Saldo, loyalitas, dan tier disalin apa adanya dari respons sungguhan.
/// **Cashback tidak bisa**: `GET /me/cashback` mengembalikan `[]` di dev karena
/// barisnya baru terbit dari pesanan yang selesai — dan menyelesaikan pesanan
/// butuh aksi penjual. Bentuknya diturunkan dari skema
/// (`list_cashback` melakukan `SELECT *`, jadi kolom = field).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';

/// Respons `GET /me/points` apa adanya.
const _balanceJson = <String, dynamic>{
  'id': '2',
  'user_id': '1258',
  'balance': '0',
  'updated_at': '2026-09-19 04:51:23',
};

/// Respons `GET /me/loyalty` apa adanya, termasuk `tier` yang disisipkan.
const _loyaltyJson = <String, dynamic>{
  'id': '80',
  'user_id': '1258',
  'loyalty_tier_id': '1',
  'tier_points': '0',
  'tier_valid_until': '2027-09-19 04:51:23',
  'updated_at': '2026-09-19 04:51:23',
  'tier': {
    'id': '1',
    'code': 'bronze',
    'name': 'Bronze',
    'min_points': '0',
    'benefits': null,
  },
};

/// Respons `GET /loyalty/tiers` apa adanya.
const _tiersJson = <Map<String, dynamic>>[
  {'id': '1', 'code': 'bronze', 'name': 'Bronze', 'min_points': '0',
      'benefits': null},
  {'id': '2', 'code': 'silver', 'name': 'Silver', 'min_points': '1000',
      'benefits': null},
  {'id': '3', 'code': 'gold', 'name': 'Gold', 'min_points': '5000',
      'benefits': null},
  {'id': '4', 'code': 'platinum', 'name': 'Platinum', 'min_points': '20000',
      'benefits': null},
];

List<LoyaltyTierModel> get _tiers =>
    _tiersJson.map(LoyaltyTierModel.fromJson).toList();

void main() {
  group('RewardBalanceModel', () {
    test('saldo akun baru terbaca nol, bukan error', () {
      // Barisnya dibuat otomatis saat pertama dibaca — tidak pernah 404.
      final points = RewardBalanceModel.fromJson(_balanceJson);
      expect(points.balance, 0);
      expect(points.isEmpty, isTrue);
      expect(points.updatedAt, isNotNull);
    });

    test('balance datang sebagai STRING dan tetap terbaca sebagai int', () {
      final points =
          RewardBalanceModel.fromJson({..._balanceJson, 'balance': '12500'});
      expect(points.balance, 12500);
      expect(points.isEmpty, isFalse);
    });
  });

  group('LoyaltyMembershipModel', () {
    test('tier tersisip sehingga nama tingkat tidak butuh panggilan kedua',
        () {
      final loyalty = LoyaltyMembershipModel.fromJson(_loyaltyJson);
      expect(loyalty.tierName, 'Bronze');
      expect(loyalty.tierCode, 'bronze');
      expect(loyalty.tierPoints, 0);
    });

    test('✅ tier_valid_until kini SEZONA dengan updated_at', () {
      // Dulu tidak: `tier_valid_until` dihitung PHP `date()` yang mengikuti
      // php.ini (UTC) sementara `updated_at` dari CURRENT_TIMESTAMP MySQL
      // (WIB), sehingga selisihnya 1 tahun KURANG 7 jam. Backend
      // menyeragamkannya di commit `93c6a14`.
      final loyalty = LoyaltyMembershipModel.fromJson(_loyaltyJson);
      final gap = loyalty.validUntil!.difference(loyalty.updatedAt!);

      expect(gap.inDays, 365);
      expect(gap.inHours % 24, 0, reason: 'tidak ada sisa 7 jam lagi');
    });

    test('tingkat berikutnya dicari dari AMBANG, bukan urutan id', () {
      // Supaya tetap benar kalau backend menyisipkan tingkat baru di tengah.
      final loyalty = LoyaltyMembershipModel.fromJson(
          {..._loyaltyJson, 'tier_points': '1500'});

      expect(loyalty.nextTier(_tiers)?.code, 'gold');
      expect(loyalty.pointsUntil(_tiers[2]), 3500);
    });

    test('tingkat tertinggi tidak punya tingkat berikutnya', () {
      final loyalty = LoyaltyMembershipModel.fromJson(
          {..._loyaltyJson, 'tier_points': '25000'});
      expect(loyalty.nextTier(_tiers), isNull);
    });

    test('kemajuan dihitung dari ambang tingkat SEKARANG, bukan dari nol', () {
      // Kalau dihitung dari nol, seorang Gold (5000) dengan 12500 poin akan
      // terlihat baru 62% menuju Platinum padahal sudah menempuh separuh
      // jarak antara Gold dan Platinum.
      final loyalty = LoyaltyMembershipModel.fromJson({
        ..._loyaltyJson,
        'tier_points': '12500',
        'tier': _tiersJson[2], // Gold, min 5000
      });

      // (12500 - 5000) / (20000 - 5000) = 0.5
      expect(loyalty.progressToward(_tiers[3]), 0.5);
    });

    test('kemajuan tidak pernah keluar dari 0..1', () {
      final loyalty = LoyaltyMembershipModel.fromJson(
          {..._loyaltyJson, 'tier_points': '99999'});
      expect(loyalty.progressToward(_tiers[1]), 1);
    });
  });

  group('LoyaltyTierModel', () {
    test('benefits null di seluruh seed tidak dianggap punya isi', () {
      final tier = LoyaltyTierModel.fromJson(_tiersJson.first);
      expect(tier.benefits, isNull);
      expect(tier.hasBenefits, isFalse);
    });

    test('benefits berupa STRING JSON tetap terbaca sebagai map', () {
      // Kolomnya bertipe JSON di MySQL; kalau suatu saat diisi, driver PHP
      // meneruskannya sebagai string — jebakan yang sama dengan
      // `selected_couriers`.
      final tier = LoyaltyTierModel.fromJson(
          {..._tiersJson.first, 'benefits': '{"free_shipping_quota":2}'});
      expect(tier.benefits!['free_shipping_quota'], 2);
      expect(tier.hasBenefits, isTrue);
    });
  });

  group('CashbackTransactionModel', () {
    Map<String, dynamic> row({String status = 'credited'}) => {
          'id': '7',
          'user_id': '1258',
          'order_id': '42',
          'amount': '15000.00',
          'status': status,
          'credited_at': '2026-09-19 10:00:00',
          'created_at': '2026-09-19 09:00:00',
        };

    test('baris cashback terbaca lengkap', () {
      final cashback = CashbackTransactionModel.fromJson(row());
      expect(cashback.orderId, 42);
      expect(cashback.amount, 15000);
      expect(cashback.isCredited, isTrue);
      expect(cashback.statusLabel, 'Masuk saldo');
    });

    test('cashback tanpa pesanan tetap sah', () {
      final cashback =
          CashbackTransactionModel.fromJson({...row(), 'order_id': null});
      expect(cashback.orderId, isNull);
    });

    test('status tak dikenal jatuh ke kodenya sendiri, bukan "Status lain"',
        () {
      final cashback =
          CashbackTransactionModel.fromJson(row(status: 'reversed'));
      expect(cashback.status, CashbackStatus.unknown);
      expect(cashback.statusLabel, 'reversed');
      expect(cashback.isCredited, isFalse);
    });
  });

  group('RewardPreviewModel', () {
    /// Respons `POST /checkout/calculate` apa adanya.
    const responseJson = <String, dynamic>{
      'subtotal': 50000,
      'rewards': {
        'estimated_cashback_coins': 50,
        'breakdown': {'base': 50, 'tier_bonus': 0},
        'tier': 'bronze',
        'status': 'pending_release',
      },
    };

    test('angka reward BERSARANG di `rewards`, subtotal di tingkat teratas',
        () {
      // Bentuk yang tidak seragam ini alasan ada `fromResponse` tersendiri.
      final preview = RewardPreviewModel.fromResponse(responseJson);

      expect(preview.subtotal, 50000);
      expect(preview.estimatedCoins, 50);
      expect(preview.tier, 'bronze');
      expect(preview.breakdown?.base, 50);
    });

    test('🔴 pending_release berarti koin BELUM masuk saldo', () {
      // Menampilkannya sebagai saldo membuat pembeli mengira sudah punya koin
      // yang belum tentu terbit — koinnya dibatalkan kalau pesanan batal.
      final preview = RewardPreviewModel.fromResponse(responseJson);
      expect(preview.isPending, isTrue);
      expect(preview.hasReward, isTrue);
    });

    test('rincian tanpa bonus tidak mengaku punya bonus', () {
      final preview = RewardPreviewModel.fromResponse(responseJson);
      expect(preview.breakdown!.hasBonus, isFalse);
    });

    test('respons tanpa blok rewards tidak melempar', () {
      final preview =
          RewardPreviewModel.fromResponse(const {'subtotal': 10000});
      expect(preview.subtotal, 10000);
      expect(preview.estimatedCoins, 0);
      expect(preview.hasReward, isFalse);
    });
  });
}
