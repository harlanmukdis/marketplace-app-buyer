/// Penyedia akun untuk test integrasi, dirancang agar **muat di plafon rate
/// limit login**.
///
/// ## 🔴 Kendalanya: 20 login per IP per 15 menit
///
/// Sejak backend v1.2.0 (commit `17df39e`) `POST /auth/login` dibatasi
/// **5× per email** dan **20× per IP**, keduanya berjendela 15 menit — dan
/// penghitungnya bertambah **sebelum** `password_verify`, jadi login yang
/// **berhasil pun ikut dihitung** (dipatok di `auth_service_test.dart`).
///
/// Versi lama suite ini mendaftar + login di `setUp`, yang berjalan **per
/// test**, sehingga satu putaran menembakkan ~138 login dan 100 dari 140 test
/// gagal berantai dengan `429`. Tidak ada jalan memutar di sisi test:
/// `register` maupun `verify-email` tidak mengembalikan token, dan `proxy_ips`
/// kosong sehingga `X-Forwarded-For` diabaikan.
///
/// ## Jalan keluarnya: satu akun per BERKAS, lalu diperpanjang, bukan login ulang
///
/// `POST /auth/refresh` **tidak dibatasi** — diverifikasi ke server, tiga
/// refresh beruntun semuanya `200` dan refresh token-nya dirotasi. Jadi akun
/// yang sudah pernah login bisa dihidupkan selamanya tanpa menyentuh kuota.
///
/// [sharedAccount] menyimpan akunnya ke berkas di direktori temp, sehingga:
///
/// * test **dalam satu berkas** berbagi satu akun (1 login, bukan 15);
/// * putaran **berikutnya** memakai ulang akun yang sama — token kedaluwarsa
///   diperpanjang lewat `/auth/refresh`, jadi **0 login**;
/// * `flutter test test/integration` bisa dijalankan berkali-kali beruntun
///   tanpa pernah menyentuh batas.
///
/// [freshAccount] tetap ada untuk test yang benar-benar memaku keadaan
/// "akun baru belum punya apa-apa" — sumber daya yang **tidak bisa dihapus**
/// lewat API (percakapan chat, notifikasi, poin yang terlanjur tercetak).
/// Itu satu-satunya yang masih memakai kuota, dan jumlahnya sengaja dijaga
/// sedikit.
///
/// Kalau cache-nya rusak atau akunnya hilang karena DB di-seed ulang, hapus
/// saja berkasnya — ia dibuat ulang sendiri:
///
/// ```bash
/// rm "$TMPDIR/marketplace_member_it_accounts.json"
/// ```
library;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';

/// Password seluruh akun uji, sama dengan akun seed panduan §3.
const testPassword = 'RahasiaAman123';

/// Akun uji beserta token yang sudah siap pakai.
typedef TestAccount = ({String email, String phone, String accessToken});

final File _cacheFile =
    File('${Directory.systemTemp.path}/marketplace_member_it_accounts.json');

/// Satu entri cache: identitas akun + token terakhir yang diketahui.
class _CachedAccount {
  _CachedAccount({
    required this.email,
    required this.phone,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAtMs,
  });

  final String email;
  final String phone;
  String accessToken;
  String refreshToken;
  int expiresAtMs;

  /// Disisakan satu menit supaya token tidak kedaluwarsa di tengah test yang
  /// sudah dimulai.
  bool get isFresh =>
      DateTime.now().millisecondsSinceEpoch < expiresAtMs - 60 * 1000;

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_at_ms': expiresAtMs,
      };

  static _CachedAccount fromJson(Map<String, dynamic> json) => _CachedAccount(
        email: json['email'] as String,
        phone: json['phone'] as String,
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        expiresAtMs: json['expires_at_ms'] as int,
      );
}

Map<String, _CachedAccount> _readCache() {
  if (!_cacheFile.existsSync()) return {};
  try {
    final raw = jsonDecode(_cacheFile.readAsStringSync()) as Map<String, dynamic>;
    return raw.map((key, value) => MapEntry(
        key, _CachedAccount.fromJson(value as Map<String, dynamic>)));
  } on Object {
    // Cache rusak bukan alasan menggagalkan suite — bangun ulang saja.
    return {};
  }
}

void _writeCache(Map<String, _CachedAccount> cache) {
  try {
    _cacheFile.writeAsStringSync(
        jsonEncode(cache.map((key, value) => MapEntry(key, value.toJson()))));
  } on Object {
    // Gagal menulis cache hanya berarti putaran berikutnya login lagi.
  }
}

/// Memperpanjang token lewat `/auth/refresh`, yang **tidak kena rate limit**.
///
/// Mengembalikan `false` kalau refresh token-nya sudah tidak sah (mis. akun
/// hilang karena DB di-seed ulang) — pemanggil lalu mendaftar akun baru.
Future<bool> _tryRefresh(_CachedAccount account) async {
  final bare = DioClient.createBare(Env.apiBaseUrl);
  try {
    final response = await bare.post<dynamic>(
      '/auth/refresh',
      data: {'refresh_token': account.refreshToken},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    account.accessToken = data['access_token'] as String;
    account.refreshToken =
        (data['refresh_token'] ?? account.refreshToken) as String;
    account.expiresAtMs = DateTime.now().millisecondsSinceEpoch +
        (int.tryParse('${data['expires_in'] ?? 900}') ?? 900) * 1000;
    return true;
  } on Object {
    return false;
  } finally {
    bare.close(force: true);
  }
}

/// NIK 16 digit yang belum pernah dipakai — `POST /auth/register` menuntutnya
/// sejak backend `3e8906d` dan menolak duplikat dengan `409 IDENTITY_TAKEN`.
///
/// Diturunkan dari jam mikrodetik (16 digit sampai tahun 2286) ditambah
/// penghitung, supaya dua panggilan dalam mikrodetik yang sama tetap berbeda.
String uniqueIdCardNumber() {
  final value =
      (DateTime.now().microsecondsSinceEpoch + _idCardSeq++).toString();
  return value.padLeft(16, '0').substring(value.length > 16 ? value.length - 16 : 0);
}

int _idCardSeq = 0;

/// Mendaftarkan akun buyer baru lalu login. **Memakai satu kuota login.**
Future<_CachedAccount> _registerAndLogin(String label) async {
  final bare = DioClient.createBare(Env.apiBaseUrl);
  try {
    final auth = AuthService(bare);
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final email = 'uji.${_slug(label)}.$stamp@marketplace.local';
    final phone =
        '08${stamp.toString().substring(stamp.toString().length - 10)}';

    await auth.register(
      email: email,
      password: testPassword,
      fullName: label,
      phone: phone,
      idCardNumber: uniqueIdCardNumber(),
    );

    try {
      final session = await auth.login(email: email, password: testPassword);
      return _CachedAccount(
        email: email,
        phone: phone,
        accessToken: session.data.accessToken,
        refreshToken: session.data.refreshToken ?? '',
        expiresAtMs: DateTime.now().millisecondsSinceEpoch +
            session.data.lifetime.inMilliseconds,
      );
    } on Object catch (error) {
      if (_isRateLimited(error)) throw StateError(_rateLimitExplanation);
      rethrow;
    }
  } finally {
    bare.close(force: true);
  }
}

String _slug(String label) =>
    label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '.');

/// Akun **bersama** untuk seluruh test dalam satu berkas.
///
/// Dipanggil dari `setUpAll`, bukan `setUp`. Akunnya dipakai ulang lintas
/// putaran lewat cache disk, dan tokennya diperpanjang dengan `/auth/refresh`
/// — jadi biayanya **satu login seumur cache**, bukan satu per test.
///
/// ⚠️ Konsekuensinya keadaan akun **menumpuk** antar test dan antar putaran.
/// Test yang memaku "akun baru belum punya apa-apa" harus memakai
/// [freshAccount]; yang sumber dayanya bisa dihapus (keranjang, wishlist)
/// sebaiknya membersihkan diri di `setUp`.
Future<String> sharedAccount(Dio dio, {required String purpose}) async {
  final cache = _readCache();
  var account = cache[purpose];

  if (account != null && !account.isFresh) {
    if (!await _tryRefresh(account)) account = null;
  }
  if (account == null) {
    account = await _registerAndLogin(purpose);
    cache[purpose] = account;
  }
  _writeCache(cache);

  dio.options.headers['Authorization'] = 'Bearer ${account.accessToken}';
  return account.accessToken;
}

/// Email akun bersama [purpose] — untuk test yang perlu menyebut identitasnya
/// (mis. mengundang akun itu sebagai staf toko).
String sharedAccountEmail(String purpose) {
  final account = _readCache()[purpose];
  if (account == null) {
    throw StateError('sharedAccount(purpose: "$purpose") belum dipanggil');
  }
  return account.email;
}

/// Akun **baru yang benar-benar kosong**. Memakai satu kuota login, jadi
/// pakai hanya kalau keadaan awalnya memang yang sedang diuji.
Future<TestAccount> freshAccount(Dio dio, {String label = 'Uji'}) async {
  final account = await _registerAndLogin(label);
  dio.options.headers['Authorization'] = 'Bearer ${account.accessToken}';
  return (
    email: account.email,
    phone: account.phone,
    accessToken: account.accessToken
  );
}

/// Login ke akun yang **sudah ada dan tetap**, mis. penjual seed.
///
/// Ikut di-cache dan diperpanjang seperti [sharedAccount], karena akun seed
/// dipakai berulang kali oleh test notifikasi.
Future<String> loginAs(
  Dio dio, {
  required String email,
  String password = testPassword,
}) async {
  final key = 'seed:$email';
  final cache = _readCache();
  var account = cache[key];

  if (account != null && !account.isFresh) {
    if (!await _tryRefresh(account)) account = null;
  }

  if (account == null) {
    final bare = DioClient.createBare(Env.apiBaseUrl);
    try {
      final session =
          await AuthService(bare).login(email: email, password: password);
      account = _CachedAccount(
        email: email,
        phone: '',
        accessToken: session.data.accessToken,
        refreshToken: session.data.refreshToken ?? '',
        expiresAtMs: DateTime.now().millisecondsSinceEpoch +
            session.data.lifetime.inMilliseconds,
      );
      cache[key] = account;
    } on Object catch (error) {
      if (_isRateLimited(error)) throw StateError(_rateLimitExplanation);
      rethrow;
    } finally {
      bare.close(force: true);
    }
  }
  _writeCache(cache);

  dio.options.headers['Authorization'] = 'Bearer ${account.accessToken}';
  return account.accessToken;
}

/// `TOO_MANY_REQUESTS` bisa sampai sebagai `ApiException` berisi `DataError`
/// atau sebagai `DioException` mentah. Dicocokkan lewat teksnya supaya
/// keduanya tertangkap tanpa mengikat helper ini ke satu bentuk exception.
bool _isRateLimited(Object error) =>
    error.toString().contains('TOO_MANY_REQUESTS') ||
    error.toString().contains('429');

const _rateLimitExplanation = '''
🔴 Login ditolak `429 TOO_MANY_REQUESTS` — kuota login habis.

Batasnya (backend v1.2.0, commit 17df39e):
  POST /auth/login   5x per email / 15 menit
  POST /auth/login   20x per IP    / 15 menit   <-- yang biasanya kena

Suite ini seharusnya hemat login: tiap berkas memakai satu akun bersama yang
di-cache ke disk dan diperpanjang lewat /auth/refresh (yang TIDAK dibatasi).
Kalau pesan ini muncul, biasanya salah satu dari:

  * cache akunnya terhapus ATAU database baru di-seed ulang, sehingga seluruh
    akun bersama harus dibuat lagi dari nol dalam satu putaran;
  * ada test baru yang memanggil freshAccount() padahal cukup sharedAccount();
  * suite dijalankan bersamaan dengan integration_test/ atau probe manual.

Jalan keluar tercepat — tunggu 15 menit, atau kosongkan penghitungnya di DB dev:
  mysql -u root --socket=/Applications/XAMPP/xamppfiles/var/mysql/mysql.sock \\
    marketplace -e "DELETE FROM auth_rate_limits;"

Selengkapnya: CLAUDE.md, "Rate limit auth".
''';
