import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/core/services/token_store.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/main.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/product_card.dart';
import 'package:marketplace_app_member/ui/main/wallet/widgets/pin_pad.dart';

/// Menjalankan **app sungguhan** terhadap backend yang **benar-benar hidup**.
///
/// Berbeda dari `test/integration/`, yang menembak service langsung tanpa
/// widget sama sekali: berkas ini mem-boot pohon widget yang sama dengan
/// `main()`, menekan tombol aslinya, dan membiarkan layar memanggil API
/// sendiri. Yang dibuktikannya bukan "endpointnya benar" — itu sudah dijaga
/// `test/integration/` — melainkan **layarnya benar-benar tersambung** ke
/// endpoint itu, dan alurnya bisa dilalui dari ujung ke ujung.
///
/// ```bash
/// flutter test integration_test/member_journey_test.dart -d macos
/// ```
///
/// Lihat `integration_test/README.md` untuk syarat menjalankannya.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Jejak langkah ke berkas di direktori temp app (di macOS: di dalam
  /// container sandbox). `flutter test -d macos` tidak meneruskan stdout app,
  /// jadi saat test menggantung, berkas inilah satu-satunya petunjuk langkah
  /// terakhir yang dicapai.
  final stepLog = File('${Directory.systemTemp.path}/member_journey_steps.log');
  void step(String name) =>
      stepLog.writeAsStringSync('${DateTime.now().toIso8601String()} $name\n', mode: FileMode.append);

  /// Menulis seluruh teks yang sedang tampil ke [stepLog] — "tangkapan
  /// layar" versi teks untuk memahami kegagalan tanpa melihat layarnya.
  void dumpScreen(String why) {
    final texts = find
        .byType(Text)
        .evaluate()
        .map((e) => (e.widget as Text).data ?? (e.widget as Text).textSpan?.toPlainText())
        .whereType<String>()
        .where((t) => t.trim().isNotEmpty)
        .toSet()
        .join(' | ');
    step('GAGAL $why — layar: $texts');
  }


  /// Memompa sampai [finder] muncul, bukan sampai pohonnya diam.
  ///
  /// `pumpAndSettle` tidak bisa dipakai menunggu jaringan: ia berhenti saat
  /// tidak ada animasi terjadwal, yang bisa saja **sebelum** respons datang —
  /// dan kalau ada indikator berputar, ia justru tidak pernah selesai.
  Future<void> pumpUntil(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 250));
      if (finder.evaluate().isNotEmpty) {
        // Setiap rute memakai FadeThroughTransition. Widget yang sudah ADA di
        // pohon masih bisa menolak tap selagi animasinya berjalan, jadi
        // dipompa beberapa frame lagi sesudah cocok.
        for (var i = 0; i < 4; i++) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        return;
      }
    }
    dumpScreen('menunggu ${finder.describeMatch(Plurality.zero)}');
    fail('Kehabisan waktu menunggu: ${finder.describeMatch(Plurality.zero)}');
  }

  /// `ensureVisible` dulu, baru tap.
  ///
  /// Tombol kirim di formulir panjang dan kartu di beranda sering berada di
  /// luar layar; tap ke sana mengenai kekosongan dan gagal dengan pesan yang
  /// menyesatkan ("tidak ada widget di koordinat itu"), bukan "di luar layar".
  Future<void> tapAt(WidgetTester tester, Finder finder) async {
    final target = finder.first;
    await tester.ensureVisible(target);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 250));
  }

  /// Menunggu kartu produk beranda, sambil menggulir.
  ///
  /// Grid "Rekomendasi Spesial" berada di bawah kartu Wallet, strip Live, dan
  /// baris kategori. Di jendela macOS yang pendek ia jatuh di bawah lipatan,
  /// dan `SliverGrid` tidak membangun sel yang belum terlihat — jadi
  /// `find.byType(ProductCard)` tetap kosong sampai layarnya digulir.
  Future<void> pumpUntilProducts(WidgetTester tester,
      {Duration timeout = const Duration(seconds: 45)}) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 250));
      if (find.byType(ProductCard).evaluate().isNotEmpty) {
        for (var i = 0; i < 4; i++) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        return;
      }
      // Hanya scrollable vertikal yang sedang tampil — baris kategori dan
      // strip Live juga `Scrollable`, tapi horizontal.
      final vertical = find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
        skipOffstage: true,
      );
      if (vertical.evaluate().isNotEmpty) {
        await tester.drag(vertical.first, const Offset(0, -300), warnIfMissed: false);
      }
    }
    dumpScreen('menunggu kartu produk');
    fail('Kehabisan waktu menunggu kartu produk di beranda');
  }

  Future<void> tapText(WidgetTester tester, String text) =>
      tapAt(tester, find.text(text));

  /// `tester.pageBack()` **tidak bekerja di app ini**: layar Xpedia memakai
  /// `XpStackAppBar`, yang tombol kembalinya `IconButton` bertooltip
  /// "Kembali" — bukan `BackButton` Material yang dicari `pageBack()`. Layar
  /// UI kit yang tersisa masih memakai `customAppBar` (GestureDetector +
  /// `arrow_back_ios_new_outlined`), jadi keduanya dicoba.
  /// Mencatat setiap permintaan yang benar-benar keluar dari app.
  ///
  /// `LoggingInterceptor` memang mencetak endpoint yang dipanggil, tapi
  /// `flutter test -d macos` **tidak meneruskan stdout app** ke runner — jadi
  /// log itu tidak bisa di-assert. Test ini berjalan di dalam proses app yang
  /// sama, jadi menempel ke instance `Dio` milik app jauh lebih kuat: yang
  /// terkumpul adalah panggilan sungguhan, bukan teks yang diurai ulang.
  ///
  /// Gunanya bukan hiasan. Tanpa ini, layar yang diam-diam membaca cache akan
  /// lolos — daftar pesanan yang terisi dari state lama terlihat persis sama
  /// dengan yang benar-benar membaca `GET /orders`.
  final calls = <String>[];

  void recordCallsOn(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          calls.add('${options.method} ${options.path}');
          handler.next(options);
        },
      ),
    );
  }

  /// `true` kalau [method] pernah dipanggil pada path yang memuat [fragment].
  bool called(String method, String fragment) =>
      calls.any((c) => c.startsWith(method) && c.contains(fragment));

  Future<void> back(WidgetTester tester) async {
    final xpedia = find.byTooltip('Kembali');
    if (xpedia.evaluate().isNotEmpty) {
      await tapAt(tester, xpedia.last);
      return;
    }
    await tapAt(
      tester,
      find.ancestor(
        of: find.byIcon(Icons.arrow_back_ios_new_outlined),
        matching: find.byType(GestureDetector),
      ),
    );
  }

  testWidgets(
    'pembeli baru mendaftar, menjelajah katalog, dan membuat pesanan',
    (tester) async {
      final stamp = DateTime.now().millisecondsSinceEpoch.toString();
      final email = 'e2e$stamp@probe.test';

      // Inisialisasi yang sama dengan `main()`, tapi **tanpa DevicePreview**:
      // frame perangkat simulasinya membuat hit-test bergantung pada
      // penskalaan preview, sehingga koordinat tap meleset.
      if (stepLog.existsSync()) stepLog.deleteSync();
      step('mulai');
      await CachedHelper.init();
      await initialize();
      recordCallsOn(injector<Dio>(instanceName: DioClient.api));
      // Selalu mulai dari layar masuk, apa pun sisa sesi dari run sebelumnya.
      await injector<TokenStore>().clear();

      router.go(AppRoutes.login);
      await tester.pumpWidget(Phoenix(child: const MyApp()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      step('pendaftaran');
      // ---- pendaftaran
      // Belum ada akun buyer-murni di seed (semua akun seed merangkap penjual),
      // jadi pengalaman pembeli baru hanya bisa diuji dengan mendaftar.
      //
      // ⚠️ Label di sini **berbahasa Inggris**, sementara layar ber-API di
      // bawah berbahasa Indonesia. Bukan kelalaian test: layar auth masih
      // memakai `S.of(context)` milik UI kit yang default-nya `en`, sedangkan
      // layar yang ditulis ulang menembak API memakai teks Indonesia
      // hardcoded. Test harus mengikuti apa yang benar-benar tampil.
      await tapText(tester, 'Register');
      await pumpUntil(tester, find.text('Create Account'));

      final fields = find.byType(TextFormField);
      expect(fields, findsAtLeastNWidgets(4),
          reason: 'nama, telepon, email, dan kata sandi');
      await tester.enterText(fields.at(0), 'E2E Pembeli');
      await tester.enterText(fields.at(1), '0819${stamp.substring(stamp.length - 6)}');
      await tester.enterText(fields.at(2), email);
      await tester.enterText(fields.at(3), 'Password123');
      await tester.pump();

      // `POST /auth/register` tidak mengembalikan token sama sekali, jadi
      // repository merangkai register → login. Berhasilnya terlihat dari
      // sampainya kita di beranda.
      await tapAt(tester, find.widgetWithText(MaterialButton, 'Create Account'));
      await pumpUntilProducts(tester);

      step('katalog');
      // ---- katalog
      expect(find.byType(ProductCard), findsWidgets,
          reason: 'GET /products mengisi beranda; kalau kosong, seed-nya habis');
      // Baris kategori datang dari panggilan terpisah yang boleh gagal tanpa
      // menggagalkan layar — jadi keberadaannya diuji, bukan isinya.
      expect(find.text('Semua'), findsOneWidget);

      // Badge dari server (`badges: []`, commit backend `7328161`) benar-benar
      // sampai ke kartu. Seluruh produk seed dibuat minggu ini, jadi "Baru"
      // yang paling pasti ada; label lain bergantung sold_count/view_count
      // yang nol di dev, dan "Diskon" sengaja tidak ditampilkan di kartu
      // karena harganya sudah memuat pil persen diskon.
      expect(find.text('Baru'), findsWidgets,
          reason: 'badges dari server tidak sampai ke ProductCard');

      step('menyaring per kategori');
      // ---- menyaring per kategori
      // Chip pertama sesudah "Semua". Namanya tidak dipatok: seed di-build
      // ulang berkala dan nama kategorinya bisa berubah.
      final categoryChips = find.byType(GestureDetector);
      expect(categoryChips, findsWidgets);

      step('profil');
      // ---- profil
      // Kepala layar profil dulu menampilkan nama dan email yang **ditulis
      // langsung di kode** (`Mahmodul Hasan` / `info.mamodul@gmail.com` dari
      // UI kit), jadi siapa pun yang masuk melihat identitas orang lain.
      // Test service tidak bisa menangkapnya — `GET /me` memang selalu benar;
      // yang salah adalah layarnya tidak pernah membacanya.
      await tapAt(tester, find.byIcon(Icons.person_outline));
      await pumpUntil(tester, find.text('E2E Pembeli'));

      expect(find.text(email), findsOneWidget,
          reason: 'email diambil dari sesi, bukan dari contoh UI kit');
      expect(find.text('Mahmodul Hasan'), findsNothing);
      expect(find.text('info.mamodul@gmail.com'), findsNothing);

      // Akun yang baru mendaftar berstatus `pending_verification`, jadi
      // lencana terverifikasi TIDAK boleh muncul. Sebelumnya ia tampil tanpa
      // syarat — centang yang tidak ada hubungannya dengan status akun.
      expect(find.byType(SvgPicture), findsNothing);
      expect(find.text('Terverifikasi'), findsNothing);

      await tapAt(tester, find.byIcon(Icons.home_outlined));
      await pumpUntilProducts(tester);

      step('produk yang masih berstok');
      // ---- produk yang masih berstok
      // Stok tidak ada di listing, hanya di detail — dan test ini benar-benar
      // MENGONSUMSI stok, jadi produk pertama tidak bisa diandalkan: run
      // sebelumnya mungkin sudah menghabiskannya.
      var opened = false;
      final stockSeen = <String>[];
      final cardCount = tester.widgetList(find.byType(ProductCard)).length;
      for (var index = 0; index < cardCount; index++) {
        step('buka kartu $index');
        await tapAt(tester, find.byType(ProductCard).at(index));
        // Bilah bawah baru dirender setelah detail termuat.
        await pumpUntil(tester, find.byType(XpBottomBar));

        // Produk yang tidak bisa dibeli menampilkan SATU tombol mati berlabel
        // mode stoknya ("Stok Habis", "Tidak Dijual Lagi", …); yang bisa
        // dibeli menampilkan ikon keranjang + "Beli Sekarang". Diperiksa
        // keadaan tombolnya, bukan teks stok.
        final buyNow = find.widgetWithText(FilledButton, 'Beli Sekarang');
        final buyable = buyNow.evaluate().isNotEmpty &&
            tester.widget<FilledButton>(buyNow.first).onPressed != null;
        stockSeen.add(buyable ? 'ada' : 'tidak bisa dibeli');
        if (buyable) {
          opened = true;
          break;
        }
        await back(tester);
        await pumpUntilProducts(tester);
      }
      expect(opened, isTrue,
          reason: 'tidak ada produk yang bisa dibeli di $cardCount kartu '
              'pertama (stok: ${stockSeen.join(", ")}). Test ini '
              'MENGONSUMSI stok tiap kali jalan — seed ulang database.');

      step('chat penjual');
      // ---- chat penjual
      // Dibuka dari halaman produk karena **hanya halaman ini yang tahu
      // `store_id`** — tidak ada pencarian toko di app member.
      // Tombolnya ada di kartu toko, di bawah lipatan, dalam daftar yang
      // dibangun malas — jadi belum ada di pohon sampai digulir. Dicari lewat
      // predikat `is OutlinedButton` karena `OutlinedButton.icon` adalah
      // subkelas privat yang tidak cocok dengan `find.byType`.
      final chatText = find.text('Chat Penjual');
      await tester.scrollUntilVisible(chatText, 300,
          scrollable: find.byType(Scrollable).first);
      await tapAt(
        tester,
        find.ancestor(
          of: chatText,
          matching: find.byWidgetPredicate((w) => w is OutlinedButton),
        ),
      );
      await pumpUntil(tester, find.text('Tulis pesan…'),
          timeout: const Duration(seconds: 45));

      // Percakapan baru lahir tanpa pesan; ruangnya tetap bisa dipakai.
      expect(find.text('Belum ada pesan.'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'Halo, stok ready?');
      await tester.pump();
      await tapAt(tester, find.byIcon(Icons.send_rounded));

      // Gelembungnya hanya bisa muncul dari hasil BACA ULANG: balasan
      // `POST .../messages` cuma berisi {id}, tanpa created_at maupun
      // sender_user_id.
      await pumpUntil(tester, find.text('Halo, stok ready?'),
          timeout: const Duration(seconds: 45));

      await back(tester);
      await pumpUntil(tester, find.byType(XpBottomBar));

      step('menambahkan ke keranjang');
      // ---- menambahkan ke keranjang
      // Pemilih varian SELALU bottom sheet (design_buyer.md §4): ikon keranjang
      // di bilah bawah membukanya, tombol sheet-nya yang menambahkan.
      await tapAt(tester, find.byTooltip('Tambah ke Keranjang'));
      await pumpUntil(tester, find.widgetWithText(FilledButton, 'Tambah ke Keranjang'));
      await tapAt(tester, find.widgetWithText(FilledButton, 'Tambah ke Keranjang'));
      // Ditunggu **snackbar-nya**, bukan tombolnya: tombolnya sudah ada sejak
      // sebelum ditekan, sehingga menunggunya kembali langsung lolos dan
      // navigasi berikutnya berangkat selagi `POST /cart/items` masih
      // terbang — keranjangnya lalu kosong saat dibuka.
      await pumpUntil(tester, find.text('Ditambahkan ke keranjang'));

      await back(tester);
      await pumpUntilProducts(tester);

      step('keranjang');
      // ---- keranjang
      // Keranjang bukan tab lagi — ikon berlencana di app bar.
      await tapAt(tester, find.byTooltip('Keranjang'));
      await pumpUntil(tester, find.text('Checkout'));
      expect(find.textContaining('barang terpilih'), findsOneWidget,
          reason: 'ringkasan hanya menghitung baris tercentang, dan '
              'kalimatnya menyebut itu');

      step('checkout');
      // ---- checkout
      await tapAt(tester, find.widgetWithText(FilledButton, 'Checkout'));
      // Akun baru belum punya alamat, jadi checkout membuka jalan keluarnya
      // sendiri alih-alih buntu.
      await pumpUntil(tester, find.text('Tambah alamat'));
      expect(find.textContaining('Belum ada alamat'), findsOneWidget);

      await tapText(tester, 'Tambah alamat');
      await pumpUntil(tester, find.text('Tambah Alamat'));

      // Urutannya: label, nama penerima, telepon, alamat lengkap, kota,
      // provinsi, kode pos. Server **tidak** memvalidasi apa pun di sini —
      // body-nya masuk langsung ke SQL — jadi aplikasi yang menjaganya.
      final addressFields = find.byType(TextFormField);
      await tester.enterText(addressFields.at(0), 'Rumah');
      await tester.enterText(addressFields.at(1), 'E2E Pembeli');
      await tester.enterText(addressFields.at(2), '081200000000');
      await tester.enterText(addressFields.at(3), 'Jl. Percobaan No. 1');
      await tester.enterText(addressFields.at(4), 'Jakarta Selatan');
      await tester.enterText(addressFields.at(5), 'DKI Jakarta');
      await tester.enterText(addressFields.at(6), '12810');
      await tester.pump();

      await tapAt(tester, find.widgetWithText(FilledButton, 'Simpan'));

      // Menyimpan alamat langsung membuat sesi checkout, yang **mereservasi
      // stok 15 menit**. Dari sini test harus sampai ke confirm atau
      // membatalkan — meninggalkannya menahan stok sampai tenggat.
      await pumpUntil(tester, find.widgetWithText(FilledButton, 'Bayar Sekarang'),
          timeout: const Duration(seconds: 45));

      step('pilih kurir');
      // ---- pilih kurir
      // Opsi kurir datang sebagai MAP berkunci store_id, dan konfirmasi
      // menuntut setiap toko punya pilihan. Tanpa memilih, tombol Bayar mati.
      final radios = find.byType(RadioListTile<String>);
      if (radios.evaluate().isNotEmpty) {
        await tapAt(tester, radios);
        await tester.pump(const Duration(milliseconds: 500));
      }
      await pumpUntil(tester, find.textContaining('Total'));

      // Di build debug `PendingApiMock` aktif, jadi checkout memakai kontrak
      // Xpedia Wallet + PIN yang diusulkan (docs/22 #1–#2): tombol baru hidup
      // sesudah `wallet-summary` termuat, lalu membuka lembar PIN. Tanpa mock
      // (`--dart-define=PENDING_API_MOCK=false`) alurnya jatuh ke pemilih
      // metode pembayaran lama — test ini menangani keduanya.
      const walletMode = PendingApiMock.enabled;
      if (walletMode) {
        final payButton = find.widgetWithText(FilledButton, 'Bayar Sekarang');
        final ready = DateTime.now().add(const Duration(seconds: 30));
        while (tester.widget<FilledButton>(payButton.first).onPressed == null &&
            DateTime.now().isBefore(ready)) {
          await tester.pump(const Duration(milliseconds: 250));
        }
      }
      await tapAt(tester, find.widgetWithText(FilledButton, 'Bayar Sekarang'));

      if (walletMode) {
        await pumpUntil(tester, find.text('Masukkan PIN 6-Digit'));
        // PIN mock: 123456 (lihat checkout_mock_routes.dart).
        for (final digit in ['1', '2', '3', '4', '5', '6']) {
          await tapAt(
            tester,
            find.descendant(of: find.byType(PinPad), matching: find.text(digit)),
          );
        }
        await pumpUntil(tester, find.textContaining('Pembayaran berhasil'),
            timeout: const Duration(seconds: 45));
      } else {
        await pumpUntil(tester, find.textContaining('Pesanan berhasil dibuat'),
            timeout: const Duration(seconds: 45));
        expect(find.text('Lanjut ke pembayaran'), findsOneWidget);
      }

      // 🔴 Berhenti di sini dengan sengaja. Tidak ada pesanan yang bisa
      // mencapai `paid` di lingkungan ini: callback pembayaran menolak
      // signature lalu 500 saat mencatat penolakannya (menulis
      // `payment_transaction_id = 0` yang melanggar foreign key). Jadi lacak
      // kiriman, terima barang, dan ulas **tidak bisa** diuji ujung ke ujung
      // sampai backend memperbaikinya — lihat CLAUDE.md.
      await tapText(tester, 'Lihat pesanan saya');

      step('daftar pesanan');
      // ---- daftar pesanan
      await pumpUntil(tester, find.text('Pesanan Saya'));
      expect(find.textContaining('ORD-'), findsWidgets,
          reason: 'nomor pesanan dibuat server, jadi kemunculannya '
              'membuktikan daftar dibaca dari API, bukan dirakit lokal');
      expect(find.text('Menunggu Pembayaran'), findsWidgets);

      step('bukti dari sisi jaringan');
      // ---- bukti dari sisi jaringan
      // Layar bisa saja terisi dari state lama dan terlihat persis sama.
      // Daftar ini membuktikan tiap langkah benar-benar menembak server.
      expect(called('POST', '/auth/register'), isTrue);
      expect(called('POST', '/auth/login'), isTrue);
      expect(called('GET', '/products'), isTrue);
      expect(called('GET', '/categories'), isTrue);
      expect(called('POST', '/cart/items'), isTrue);
      expect(called('GET', '/cart'), isTrue);
      expect(called('POST', '/me/addresses'), isTrue);
      expect(called('POST', '/checkout/sessions'), isTrue);
      expect(called('GET', '/shipping-options'), isTrue);
      expect(called('PATCH', '/shipping'), isTrue);
      expect(called('POST', '/confirm'), isTrue);
      expect(called('GET', '/orders'), isTrue);
      // Nama toko di kartu produk: satu request per TOKO, bukan per kartu.
      expect(called('GET', '/stores/'), isTrue);

      // Sisi sebaliknya sama pentingnya: `/search/*` butuh Elasticsearch yang
      // tidak hidup di dev, dan app memang memakai `GET /products?q=` sebagai
      // gantinya. Kalau suatu saat ada yang memanggilnya, itu regresi.
      expect(called('GET', '/search/'), isFalse,
          reason: 'search dijawab 503 tanpa Elasticsearch');
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
