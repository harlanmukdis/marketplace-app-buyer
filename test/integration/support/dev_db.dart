/// Akses **langsung ke database dev** untuk keadaan yang tidak bisa dibuat
/// lewat API.
///
/// ## Kenapa perlu
///
/// Sejak backend `d9ecb33` (docs/22 #1–#2) checkout **wallet-only**: setiap
/// `confirm` menuntut PIN Wallet dan saldo yang cukup. Di dev, saldo hanya
/// bisa bertambah lewat callback penyedia pembayaran yang menuntut HMAC dengan
/// secret yang tidak ada di repo — jadi tanpa suntikan SQL tidak ada satu pun
/// pesanan yang bisa dibuat dari test.
///
/// Ditambah lagi 🔴 **setiap `confirm` yang BERHASIL pun memakai kuota PIN**
/// (5 per 15 menit per user, dibagi dengan penarikan — `Rate_limiter` mencatat
/// percobaan sebelum `password_verify`). Suite ini membuat belasan pesanan per
/// putaran, jadi penghitungnya harus dikosongkan sebelum tiap pesanan.
///
/// ## Aturannya
///
/// * **Hanya untuk menyiapkan keadaan**, tidak pernah untuk memeriksa hasil —
///   yang diuji tetap balasan API.
/// * Hanya menyentuh akun uji milik suite ini, lewat `id` dari `GET /me`.
///
/// Klien `mysql` dan socket-nya bisa diganti tanpa mengubah kode:
///
/// ```bash
/// flutter test test/integration --concurrency=1 \
///   --dart-define=DEV_MYSQL_BIN=/usr/local/bin/mysql \
///   --dart-define=DEV_MYSQL_SOCKET=/tmp/mysql.sock
/// ```
///
/// ⚠️ Default-nya klien bawaan **XAMPP**, bukan `mysql` di PATH: klien MySQL 9
/// dari Homebrew tidak bisa login ke MariaDB 10.4 milik XAMPP
/// (`mysql_native_password` tidak dimuat, ERROR 2059).
library;

import 'dart:io';

import 'package:dio/dio.dart';

const _mysqlBin = String.fromEnvironment(
  'DEV_MYSQL_BIN',
  defaultValue: '/Applications/XAMPP/xamppfiles/bin/mysql',
);
const _mysqlSocket = String.fromEnvironment(
  'DEV_MYSQL_SOCKET',
  defaultValue: '/Applications/XAMPP/xamppfiles/var/mysql/mysql.sock',
);
const _mysqlDb = String.fromEnvironment('DEV_MYSQL_DB', defaultValue: 'marketplace');

/// PIN Wallet seluruh akun uji yang disiapkan [prepareWalletCheckout].
const testWalletPin = '123456';

/// Saldo minimum yang dijamin [prepareWalletCheckout] — jauh di atas harga
/// produk seed ditambah ongkir, supaya belasan pesanan per putaran muat.
const testWalletBalance = 50000000;

Future<String> _sql(String statement) async {
  final result = await Process.run(_mysqlBin, [
    '-N',
    '-u',
    'root',
    '--socket=$_mysqlSocket',
    _mysqlDb,
    '-e',
    statement,
  ]);
  if (result.exitCode != 0) {
    throw StateError('''
Gagal menjalankan SQL ke DB dev lewat $_mysqlBin:
${result.stderr}
Test checkout/pesanan butuh akses DB dev untuk menyuntik saldo & PIN Wallet
(checkout wallet-only, tidak ada cara sah menambah saldo di dev). Periksa
MySQL XAMPP hidup, atau set --dart-define=DEV_MYSQL_BIN / DEV_MYSQL_SOCKET.''');
  }
  return (result.stdout as String).trim();
}

/// Id user pemilik token di [dio].
Future<int> currentUserId(Dio dio) async {
  final response = await dio.get<dynamic>('/me');
  return int.parse('${(response.data['data'] as Map)['id']}');
}

/// Menyiapkan akun di [dio] supaya bisa checkout: PIN [testWalletPin],
/// saldo minimal [testWalletBalance], dan kuota PIN kosong.
///
/// PIN dipasang lewat **API** (`POST /me/withdrawal-pin`), bukan menulis hash:
/// hash lamanya dikosongkan dulu supaya itu terhitung "membuat PIN pertama
/// kali", yang tidak menuntut PIN lama maupun memakai kuota ganti PIN.
Future<int> prepareWalletCheckout(Dio dio) async {
  final userId = await currentUserId(dio);
  // `GET /wallet` membuat baris dompetnya kalau belum ada.
  await dio.get<dynamic>('/wallet');

  await _sql('UPDATE users SET withdrawal_pin_hash = NULL WHERE id = $userId');
  await dio.post<dynamic>('/me/withdrawal-pin', data: {'pin': testWalletPin});

  await _sql('UPDATE wallets SET balance = GREATEST(balance, $testWalletBalance) '
      'WHERE user_id = $userId');
  await resetPinAttempts(userId);
  return userId;
}

/// Mengosongkan penghitung percobaan PIN user ini (checkout + penarikan
/// berbagi `wallet_pin:verify:user:{id}`).
Future<void> resetPinAttempts(int userId) => _sql(
    "DELETE FROM auth_rate_limits WHERE rate_key IN "
    "('wallet_pin:verify:user:$userId', 'wallet_pin:change:user:$userId')");

/// Menghapus PIN Wallet — untuk menguji penolakan "PIN belum dibuat".
Future<void> clearWalletPin(int userId) =>
    _sql('UPDATE users SET withdrawal_pin_hash = NULL WHERE id = $userId');

/// Menyetel saldo persis — untuk menguji `INSUFFICIENT_BALANCE`.
Future<void> setWalletBalance(int userId, num balance) =>
    _sql('UPDATE wallets SET balance = $balance WHERE user_id = $userId');
