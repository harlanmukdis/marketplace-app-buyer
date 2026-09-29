import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Locale untuk nilai yang **dikirim ke server**.
///
/// Wajib dipatok, tidak boleh mengikuti locale aktif. `CachedHelper.init()`
/// menyetel `Intl.defaultLocale` sesuai pilihan bahasa user, dan pada locale
/// `ar` `DateFormat` memakai angka Arab-Indic — sehingga tanggal yang dikirim
/// jadi `٢٠٢٦-٠٩-٠٦` dan ditolak backend. Format wire harus selalu ASCII.
const String _wireLocale = 'en_US';

/// Locale untuk yang **ditampilkan ke user**.
const String _displayLocale = 'id';

bool _dateSymbolsReady = false;

/// Memuat data locale `intl` sekali saja.
///
/// `DateFormat` dengan locale selain `en_US` melempar `LocaleDataException`
/// kalau data simbolnya belum dimuat. Dilakukan lazy di sini — bukan di
/// `initialize()` — supaya helper ini tetap benar saat dipakai unit test yang
/// tidak menjalankan DI.
void _ensureDateSymbols() {
  if (_dateSymbolsReady) return;
  initializeDateFormatting();
  _dateSymbolsReady = true;
}

/// Selisih waktu server terhadap UTC.
///
/// Backend mengirim timestamp **tanpa penanda timezone**
/// (`"2026-09-06 14:00:00"`), yang berarti waktu dinding server. Server berada
/// di WIB, dan Indonesia tidak memakai DST — jadi offset tetap +07:00 memang
/// benar sepanjang tahun, bukan penyederhanaan yang akan salah di musim lain.
///
/// Kalau backend nanti dipindah ke UTC, cukup ubah nilai ini.
const Duration kServerUtcOffset = Duration(hours: 7);

/// Mengubah timestamp server jadi **instan UTC yang benar**.
///
/// Kenapa tidak `DateTime.parse` saja: `DateTime.parse("2026-09-06 14:00:00")`
/// menghasilkan `DateTime` bertipe *local*, artinya Dart menganggap 14:00 itu
/// waktu perangkat. Padahal 14:00 itu waktu server (WIB). Di perangkat yang
/// timezone-nya bukan WIB — emulator sering UTC, dan di web ikut timezone OS —
/// hitung mundur batas bayar jadi melenceng berjam-jam, dan user bisa
/// kehilangan pesanan karena countdown-nya bohong.
///
/// Mengembalikan `null` untuk input null/kosong/tidak terbaca, supaya satu
/// field tanggal yang aneh tidak menggagalkan seluruh parsing model.
DateTime? parseServerInstant(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty || trimmed == '0000-00-00 00:00:00') return null;

  // Dibaca sebagai UTC dulu (suffix Z) supaya angka jamnya tidak digeser oleh
  // timezone perangkat, lalu digeser sendiri sesuai offset server.
  final asUtc = DateTime.tryParse('${trimmed.replaceFirst(' ', 'T')}Z');
  if (asUtc == null) return null;

  return asUtc.subtract(kServerUtcOffset);
}

/// Kebalikan [parseServerInstant] — untuk field tanggal yang dikirim ke server
/// (mis. `scheduled_date` pada batch kontrak).
String? formatForServer(DateTime? instant) {
  if (instant == null) return null;
  _ensureDateSymbols();
  final serverWallClock = instant.toUtc().add(kServerUtcOffset);
  return DateFormat('yyyy-MM-dd HH:mm:ss', _wireLocale).format(serverWallClock);
}

/// Hanya bagian tanggal, `YYYY-MM-DD` — format yang diminta field seperti
/// `scheduled_date`.
String? formatDateForServer(DateTime? instant) {
  if (instant == null) return null;
  _ensureDateSymbols();
  final serverWallClock = instant.toUtc().add(kServerUtcOffset);
  return DateFormat('yyyy-MM-dd', _wireLocale).format(serverWallClock);
}

/// Sisa waktu sampai [deadline]. Negatif berarti sudah lewat.
///
/// Selalu bandingkan dalam UTC supaya timezone perangkat tidak ikut campur.
Duration? remainingUntil(DateTime? deadline) {
  if (deadline == null) return null;
  return deadline.toUtc().difference(DateTime.now().toUtc());
}

bool isPast(DateTime? deadline) {
  final left = remainingUntil(deadline);
  return left != null && left.isNegative;
}

/// Hitung mundur ringkas: `"2 hari 3 jam"`, `"5 jam 12 menit"`, `"8 menit"`.
///
/// Aman dipakai untuk deadline dari marketplace-api. Peringatan lama di sini
/// menyangkut bug selisih jam PHP vs MySQL di backend Markas, yang sudah
/// tidak dipakai; drift serupa di marketplace-api diperbaiki backend pada
/// commit `93c6a14` (lihat CLAUDE.md "Drift dua zona waktu SUDAH
/// DIPERBAIKI"). Kalau test integrasi yang memaku selisih 15 menit / 1 jam
/// merah lagi, driftnya kembali — dan saat itu hitung mundur ikut salah.
///
/// Batas bersatuan "jam kerja" (mis. konfirmasi toko 1×24 jam kerja) juga
/// tidak boleh dihitung sendiri karena melewatkan akhir pekan dan libur
/// nasional — selalu pakai field deadline dari server.
String formatCountdown(Duration? left) {
  if (left == null) return '-';
  if (left.isNegative) return 'Waktu habis';

  final days = left.inDays;
  final hours = left.inHours % 24;
  final minutes = left.inMinutes % 60;

  if (days > 0) return '$days hari $hours jam';
  if (left.inHours > 0) return '${left.inHours} jam $minutes menit';
  if (left.inMinutes > 0) return '${left.inMinutes} menit';
  return 'kurang dari 1 menit';
}

DateFormat? _dateTimeDisplayCache;
DateFormat? _dateDisplayCache;

DateFormat get _dateTimeDisplay {
  _ensureDateSymbols();
  return _dateTimeDisplayCache ??=
      DateFormat('d MMM yyyy, HH:mm', _displayLocale);
}

DateFormat get _dateDisplay {
  _ensureDateSymbols();
  return _dateDisplayCache ??= DateFormat('d MMMM yyyy', _displayLocale);
}

/// Tampilan tanggal-waktu dalam **waktu server (WIB)**, bukan waktu perangkat.
///
/// Disengaja: nomor surat jalan, batas bayar, dan jadwal kirim semuanya
/// disepakati dalam WIB antara pembeli dan toko. Menampilkannya dalam timezone
/// perangkat justru membingungkan kalau user sedang di luar negeri.
String formatServerDateTime(DateTime? instant, {String fallback = '-'}) {
  if (instant == null) return fallback;
  return '${_dateTimeDisplay.format(instant.toUtc().add(kServerUtcOffset))} WIB';
}

String formatServerDate(DateTime? instant, {String fallback = '-'}) {
  if (instant == null) return fallback;
  return _dateDisplay.format(instant.toUtc().add(kServerUtcOffset));
}

/// Menampilkan batas waktu sebagai **tanggal-jam absolut**, bukan hitung
/// mundur.
///
/// Waktu absolut tetap berguna di samping hitung mundur: user bisa
/// mencocokkannya dengan jam dindingnya sendiri.
///
/// Contoh keluaran: `"Batas bayar 6 Sep 2026, 14:00 WIB"`.
String formatServerDeadline(DateTime? instant, {String prefix = 'Batas'}) {
  if (instant == null) return '-';
  return '$prefix ${formatServerDateTime(instant)}';
}

final NumberFormat _rupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

/// Format nominal jadi `"Rp 6.500.000"`.
///
/// **Hanya memformat, tidak pernah menghitung.** Subtotal, ongkir, diskon, dan
/// total selalu datang jadi dari server (aturan §10.4 spec: tidak boleh ada
/// perhitungan uang di sisi tampilan). Kalau sebuah angka terasa perlu
/// dijumlahkan di app, itu tanda field-nya belum ada di respons — minta ke BE,
/// jangan hitung sendiri, karena hasilnya akan berbeda dari yang ditagih.
String formatRupiah(num? amount, {String fallback = '-'}) {
  if (amount == null) return fallback;
  return _rupiah.format(amount);
}

final NumberFormat _plainNumber = NumberFormat.decimalPattern('id_ID');

/// Angka berpemisah ribuan tanpa simbol mata uang — untuk nilai yang **bukan
/// uang**, seperti saldo poin dan koin.
///
/// Sengaja dipisahkan dari [formatRupiah]: memberi awalan `Rp` pada poin
/// membuatnya terbaca sebagai rupiah, padahal nilainya sama sekali tidak
/// setara.
String formatNumber(num? value, {String fallback = '-'}) {
  if (value == null) return fallback;
  return _plainNumber.format(value);
}

/// Angka ringkas gaya Indonesia untuk jumlah terjual/pengikut/ulasan:
/// `980`, `1,2rb`, `12,3rb`, `1,5jt`.
///
/// Stitch menulis "1.2k"; inventaris desainnya sendiri mencatat itu gaya
/// Inggris, dan layar beranda/detailnya sudah memakai "1,2rb".
String formatCompact(num? value) {
  if (value == null) return '0';
  final v = value.abs();
  String trim(double x) {
    final text = x.toStringAsFixed(1).replaceAll('.', ',');
    return text.endsWith(',0') ? text.substring(0, text.length - 2) : text;
  }

  final sign = value < 0 ? '-' : '';
  if (v >= 1000000) return '$sign${trim(v / 1000000)}jt';
  if (v >= 1000) return '$sign${trim(v / 1000)}rb';
  return '$sign${v.round()}';
}

/// Rating satu desimal dengan koma: `4,9`.
String formatRating(num? value) =>
    (value ?? 0).toDouble().toStringAsFixed(1).replaceAll('.', ',');

/// Persen satu desimal gaya Indonesia: `98,7%`. Bilangan bulat tanpa desimal.
String formatPercent(num? value) {
  final v = (value ?? 0).toDouble();
  final text = v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(1).replaceAll('.', ',');
  return '$text%';
}
