/// Pembantu bersama untuk test integrasi yang butuh **akun buyer bersegel
/// baru**.
///
/// ## 🔴 Kenapa ini ada: rate limit login membuat suite ini mustahil utuh
///
/// Sejak backend v1.2.0 (commit `17df39e`) `POST /auth/login` dibatasi
/// **5× per email** dan **20× per IP**, keduanya dalam jendela 15 menit.
/// Suite ini punya ~135 test yang masing-masing mendaftar lalu login di
/// `setUp`, jadi ia menembus batas per-IP di test ke-21 dan sisanya gagal
/// berantai dengan `429 TOO_MANY_REQUESTS` — 100 dari 140 test merah,
/// semuanya dengan pesan yang tidak menyebut sebabnya.
///
/// Yang membuatnya tidak bisa diakali dari sisi test:
///
/// * `POST /auth/register` **tidak mengembalikan token** (hanya `user_id` +
///   `dev_verification_token`), dan `POST /auth/verify-email` juga tidak —
///   jadi login tidak bisa dilewati untuk mendapatkan sesi;
/// * `proxy_ips` di `application/config/config.php` **kosong**, jadi
///   `X-Forwarded-For` diabaikan dan IP-nya tidak bisa divariasikan;
/// * batas per-IP **20** itu plafon mutlak: skema apa pun di sisi FE tetap
///   tidak bisa melakukan lebih dari 20 login per 15 menit.
///
/// ## Kenapa suite ini TIDAK ditulis ulang supaya muat di 20 login
///
/// Karena penyebabnya kemungkinan besar bug, bukan kebijakan. Penghitungnya
/// bertambah **sebelum** `password_verify`, jadi **login yang BERHASIL pun
/// ikut dihitung** — diuji langsung: lima login berturut-turut dengan
/// password yang BENAR lolos, yang keenam dibalas `429`. Praktik lazimnya
/// menghitung percobaan **gagal** saja dan mengosongkan penghitung begitu
/// login berhasil.
///
/// Kalau backend memperbaikinya jadi menghitung kegagalan saja, suite ini
/// langsung hijau kembali tanpa diubah sama sekali — test-testnya selalu
/// login dengan kredensial yang benar. Menulis ulang 10 berkas jadi berbagi
/// akun per berkas justru akan membuang isolasi antar-test (banyak test
/// memang memaku "akun baru belum punya apa-apa") demi mengakali sesuatu
/// yang semestinya hilang sendiri.
///
/// Sampai itu terjadi, [registerAndLogin] mengubah kegagalan berantai yang
/// membingungkan itu jadi **satu pesan yang menyebut sebab dan jalan
/// keluarnya**.
library;

import 'package:dio/dio.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';

/// Password yang dipakai seluruh akun uji, sama dengan akun seed panduan §3.
const testPassword = 'RahasiaAman123';

/// Akun buyer yang baru dibuat, beserta token yang sudah siap pakai.
typedef TestAccount = ({String email, String phone, String accessToken});

/// Mendaftarkan akun buyer baru lalu login, dan **memasang header
/// `Authorization` pada [dio]**.
///
/// [label] hanya masuk ke `full_name`, memudahkan menelusuri baris yang
/// ditinggalkan suite di database dev.
Future<TestAccount> registerAndLogin(Dio dio, {String label = 'Uji'}) async {
  final auth = AuthService(dio);

  final stamp = DateTime.now().microsecondsSinceEpoch;
  final email = 'uji.${label.toLowerCase().replaceAll(' ', '.')}.$stamp'
      '@marketplace.local';
  final phone = '08${stamp.toString().substring(stamp.toString().length - 10)}';

  await auth.register(
    email: email,
    password: testPassword,
    fullName: label,
    phone: phone,
  );

  final String accessToken;
  try {
    final session = await auth.login(email: email, password: testPassword);
    accessToken = session.data.accessToken;
  } on Object catch (error) {
    if (_isRateLimited(error)) throw StateError(_rateLimitExplanation);
    rethrow;
  }

  dio.options.headers['Authorization'] = 'Bearer $accessToken';
  return (email: email, phone: phone, accessToken: accessToken);
}

/// Login ke akun yang sudah ada — dipakai test yang butuh akun seed
/// (mis. penjual), bukan akun baru.
Future<String> loginAs(
  Dio dio, {
  required String email,
  String password = testPassword,
}) async {
  try {
    final session = await AuthService(dio).login(email: email, password: password);
    dio.options.headers['Authorization'] =
        'Bearer ${session.data.accessToken}';
    return session.data.accessToken;
  } on Object catch (error) {
    if (_isRateLimited(error)) throw StateError(_rateLimitExplanation);
    rethrow;
  }
}

/// `TOO_MANY_REQUESTS` bisa sampai ke sini sebagai `ApiException` berisi
/// `DataError`, atau sebagai `DioException` mentah kalau lapisan service
/// dilewati. Dicocokkan lewat teksnya supaya keduanya tertangkap tanpa
/// mengikat helper ini ke satu bentuk exception.
bool _isRateLimited(Object error) =>
    error.toString().contains('TOO_MANY_REQUESTS') ||
    error.toString().contains('429');

const _rateLimitExplanation = '''
🔴 Login ditolak `429 TOO_MANY_REQUESTS` — suite ini menembus rate limit auth.

Batasnya (backend v1.2.0, commit 17df39e):
  POST /auth/login   5x per email / 15 menit
  POST /auth/login   20x per IP    / 15 menit   <-- yang kena duluan

Suite ini punya ~135 test yang masing-masing mendaftar + login di setUp, jadi
ia melewati 20 login di sekitar test ke-21.

Yang bisa dilakukan sekarang:
  * tunggu 15 menit, lalu jalankan SATU berkas saja
      flutter test test/integration/cart_service_test.dart
  * atau kosongkan penghitungnya di database dev:
      DELETE FROM auth_rate_limits;

Perbaikan sebenarnya ada di backend: penghitungnya bertambah SEBELUM
password_verify, jadi login yang BERHASIL pun ikut dihitung (diuji: 5 login
dengan password benar lolos, yang ke-6 dibalas 429). Menghitung percobaan
GAGAL saja — dan mengosongkan penghitung saat login berhasil — membuat suite
ini hijau lagi tanpa diubah, sekaligus menghilangkan risiko user sungguhan
terkunci di balik CGNAT operator seluler.

Selengkapnya: CLAUDE.md, "Rate limit auth".
''';
