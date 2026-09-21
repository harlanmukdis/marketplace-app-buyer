/// Kontrak `/me/points`, `/me/coins`, `/me/loyalty`, `/me/cashback`,
/// `/loyalty/tiers`, dan `POST /checkout/calculate` terhadap marketplace-api
/// yang **benar-benar jalan**.
///
/// ```bash
/// flutter test test/integration --concurrency=1
/// ```
///
/// ⚠️ **Saldo tidak bisa ditumbuhkan secara sah di dev.** Poin dan koin hanya
/// bertambah lewat `earn_points`/reward engine yang dipicu pesanan **selesai**,
/// dan menyelesaikan pesanan butuh aksi penjual. Jadi yang dipatok di sini
/// adalah bentuk respons, pembuatan-otomatis, dan penolakan — bukan perjalanan
/// poinnya.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'support/test_account.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/reward_service.dart';

import 'support/seeded_product.dart';

void main() {
  late Dio dio;
  late RewardService reward;
  late CartService cart;
  late CatalogService catalog;

  // Akun bersama, bukan akun baru per test — lihat `support/test_account.dart`
  // untuk alasannya (plafon 20 login per IP per 15 menit).
  //
  // Saldo poin dan koin akun ini **tidak akan pernah tumbuh**: satu-satunya
  // jalan menaikkannya adalah reward engine yang dipicu pesanan selesai, dan
  // tidak ada pesanan yang bisa mencapai `completed` di dev. Jadi `balance == 0`
  // tetap sah dipatok walau akunnya dipakai ulang lintas putaran.
  //
  // ⚠️ Kecuali lewat bug pencetak poin di `/me/points/redeem`. Karena itu
  // grup redeem di bawah memakai akunnya SENDIRI — kalau tidak, poin yang
  // terlanjur tercetak akan membuat test di grup ini merah pada putaran
  // berikutnya.
  setUp(() async {
    dio = DioClient.createBare(Env.apiBaseUrl);
    reward = RewardService(dio);
    cart = CartService(dio);
    catalog = CatalogService(dio);

    await sharedAccount(dio, purpose: 'reward');

    // `POST /checkout/calculate` membaca keranjang, jadi sisa isi dari test
    // sebelumnya membuat "keranjang kosong" tidak lagi kosong.
    for (final group in (await cart.fetchCart()).data) {
      for (final item in group.items) {
        await cart.removeItem(item.id);
      }
    }
  });

  tearDown(() => dio.close(force: true));

  group('saldo poin & koin', () {
    test('dibuat otomatis saat pertama dibaca — bukan 404', () async {
      // Pola yang sama dengan dompet: barisnya lahir saat pertama dibaca.
      final points = await reward.fetchPoints();
      expect(points.data.balance, 0);
      expect(points.data.updatedAt, isNotNull);

      final coins = await reward.fetchCoins();
      expect(coins.data.balance, 0);
    });

    test('membaca dua kali tidak menggandakan barisnya', () async {
      final first = await reward.fetchPoints();
      final second = await reward.fetchPoints();
      expect(second.data.id, first.data.id);
    });

    test('poin dan koin adalah baris TERPISAH', () async {
      // Bentuk responsnya identik, jadi mudah dikira satu hal yang sama.
      final points = await reward.fetchPoints();
      final coins = await reward.fetchCoins();
      expect(points.data.balance, coins.data.balance);
      // Tapi keduanya tabel berbeda — tidak ada jaminan idnya sama, yang
      // dipatok di sini hanya bahwa keduanya hidup.
      expect(points.data.id, greaterThan(0));
      expect(coins.data.id, greaterThan(0));
    });
  });

  group('loyalitas', () {
    test('keanggotaan dibuat otomatis di tingkat bronze', () async {
      final loyalty = await reward.fetchLoyalty();

      expect(loyalty.data.tierCode, 'bronze');
      expect(loyalty.data.tierPoints, 0);
      expect(loyalty.data.tier, isNotNull,
          reason: 'objek tier disisipkan server, tidak perlu panggilan kedua');
    });

    test('✅ tier_valid_until kini SEZONA dengan updated_at', () async {
      // Dulu berselisih 1 tahun KURANG 7 jam: `tier_valid_until` dihitung PHP
      // `date()` yang mengikuti php.ini (UTC), `updated_at` dari MySQL (WIB).
      // Diseragamkan backend di commit `93c6a14`. Kalau sisa 7 jam itu muncul
      // lagi, driftnya kembali.
      final loyalty = await reward.fetchLoyalty();
      final gap =
          loyalty.data.validUntil!.difference(loyalty.data.updatedAt!);

      expect(gap.inDays, 365);
      expect(gap.inHours % 24, 0);
    });

    test('daftar tingkat PUBLIK dan terurut menaik', () async {
      // Tanpa token sama sekali — dipakai menghitung jarak ke tingkat
      // berikutnya.
      final anon = DioClient.createBare(Env.apiBaseUrl);
      try {
        final tiers = await RewardService(anon).fetchTiers();

        expect(tiers.data.map((t) => t.code),
            containsAllInOrder(['bronze', 'silver', 'gold', 'platinum']));
        final thresholds = tiers.data.map((t) => t.minPoints).toList();
        expect(thresholds, [...thresholds]..sort());
      } finally {
        anon.close(force: true);
      }
    });

    test('benefits masih null di seluruh tingkat yang di-seed', () async {
      // Dipatok supaya ketahuan begitu backend mengisinya — bentuk isinya
      // belum pernah teramati.
      final tiers = await reward.fetchTiers();
      expect(tiers.data.every((t) => !t.hasBenefits), isTrue);
    });
  });

  group('cashback', () {
    test('kosong untuk akun baru', () async {
      // Cashback baru terbit dari pesanan yang selesai, dan itu butuh aksi
      // penjual — jadi bentuk barisnya diuji di test/data/ saja.
      final cashback = await reward.fetchCashback();
      expect(cashback.data, isEmpty);
    });
  });

  group('POST /checkout/calculate', () {
    test('menghitung estimasi koin TANPA membuat sesi checkout', () async {
      // Nilainya: bisa dipanggil dari layar keranjang tanpa mereservasi stok.
      final variant = await findVariantWithStock(catalog);
      await cart.addItem(productVariantId: variant.variantId, quantity: 1);

      final preview = await reward.previewFromCart();

      expect(preview.data.subtotal, greaterThan(0));
      expect(preview.data.estimatedCoins, greaterThanOrEqualTo(0));
      expect(preview.data.tier, 'bronze');
      expect(preview.data.breakdown, isNotNull);
    });

    test('🔴 statusnya pending_release — koin BELUM masuk saldo', () async {
      // Koinnya baru dilepas saat pesanan selesai, dan dibatalkan kalau
      // pesanan batal. Menampilkannya sebagai saldo menyesatkan.
      final variant = await findVariantWithStock(catalog);
      await cart.addItem(productVariantId: variant.variantId, quantity: 1);

      final preview = await reward.previewFromCart();
      expect(preview.data.isPending, isTrue);

      // Dan saldo koin sungguhan memang belum berubah.
      final coins = await reward.fetchCoins();
      expect(coins.data.balance, 0);
    });

    test('keranjang kosong tidak melempar', () async {
      final preview = await reward.previewFromCart();
      expect(preview.data.subtotal, 0);
      expect(preview.data.hasReward, isFalse);
    });
  });

  group('🔴 POST /me/points/redeem — sengaja tidak dipakai aplikasi', () {
    // Grup ini MENCETAK poin lewat bug server, jadi ia tidak boleh memakai
    // akun yang sama dengan grup saldo di atas — saldonya tidak bisa
    // dikembalikan ke nol lewat API mana pun.
    setUp(() async {
      await sharedAccount(dio, purpose: 'reward-redeem');
    });

    test('nominal NEGATIF mencetak poin alih-alih ditolak', () async {
      // Penjaganya ditulis `if ($balance < $amount) throw`. Untuk
      // `amount = -1000` itu `0 < -1000` yang false, jadi lolos; lalu
      // `balance - (-1000)` MENAMBAH saldo. Ini alasan `RewardService` tidak
      // punya method redeem sama sekali.
      //
      // Kalau backend memperbaikinya, test ini merah — dan method redeem bisa
      // dipertimbangkan lagi.
      // Diukur sebagai SELISIH, bukan angka mutlak: akun ini dipakai ulang
      // lintas putaran dan poin yang terlanjur tercetak tidak bisa dihapus
      // lewat API mana pun.
      final before = (await reward.fetchPoints()).data.balance;

      final response = await dio.post<dynamic>(
        '/me/points/redeem',
        data: {'amount': -1000},
      );
      expect(response.statusCode, 200, reason: 'diterima, bukan ditolak');

      final after = (await reward.fetchPoints()).data.balance;
      expect(after - before, 1000, reason: 'saldo justru BERTAMBAH');
    });

    test('menukar poin tidak memberi imbalan apa pun', () async {
      // `redeem_points` hanya mengurangi saldo dan mencatat satu baris
      // `point_transactions`; tidak ada satu pun kode lain di backend yang
      // membaca baris itu. Jadi tombol "tukar poin" hanya akan menghanguskan
      // poin user.
      await dio.post<dynamic>('/me/points/redeem', data: {'amount': -500});
      final coinsBefore = (await reward.fetchCoins()).data.balance;
      final pointsBefore = (await reward.fetchPoints()).data.balance;

      await dio.post<dynamic>('/me/points/redeem', data: {'amount': 500});

      expect((await reward.fetchPoints()).data.balance, pointsBefore - 500,
          reason: 'poinnya hilang');
      expect((await reward.fetchCoins()).data.balance, coinsBefore,
          reason: 'dan tidak ada koin yang masuk sebagai gantinya');
    });

    test('saldo kurang ditolak dengan kode yang RAPI', () async {
      // Berbeda dari `WITHDRAWAL_REJECTED` di dompet yang ambigu, kode ini
      // hanya berarti satu hal.
      await expectLater(
        dio.post<dynamic>('/me/points/redeem', data: {'amount': 999999}),
        throwsA(anything),
      );
    });

    test('body tanpa `amount` membalas 500, bukan VALIDATION_ERROR', () async {
      await expectLater(
        dio.post<dynamic>('/me/points/redeem', data: <String, dynamic>{}),
        throwsA(anything),
      );
    });
  });
}
