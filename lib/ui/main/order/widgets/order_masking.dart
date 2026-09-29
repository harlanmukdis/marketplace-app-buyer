/// Penyensoran data pribadi di invoice (docs/22 #6).
///
/// ⚠️ **Semestinya dilakukan server.** `GET /orders/{id}/invoice` mengirim
/// nama, nomor HP, dan alamat pembeli **utuh**, jadi siapa pun yang memegang
/// respons (atau PDF yang dibagikan) melihat semuanya. Kontrak yang diusulkan
/// adalah field `shipping_address_masked` di respons invoice (lihat
/// `assets/mock/pending_api/README.md`). Sampai itu ada, invoice di layar dan
/// PDF-nya disensor di sini — lebih baik daripada membagikan data utuh.
library;

/// "Andi Saputra" → "A*** S******": huruf pertama tiap kata dipertahankan,
/// sisanya bintang sepanjang aslinya.
String maskName(String? name) {
  final text = (name ?? '').trim();
  if (text.isEmpty) return '';
  return text
      .split(RegExp(r'\s+'))
      .map((word) => word.length <= 1 ? word : '${word[0]}${'*' * (word.length - 1)}')
      .join(' ');
}

/// "081234567456" → "0812*****456": empat digit awal dan tiga digit akhir.
///
/// Pemisah (spasi, strip) dibuang lebih dulu supaya panjang sensornya tidak
/// bocor dari format penulisan. Nomor yang terlalu pendek untuk disisakan
/// ujungnya disensor seluruhnya.
String maskPhone(String? phone) {
  final digits = (phone ?? '').replaceAll(RegExp(r'[\s\-().]'), '');
  if (digits.isEmpty) return '';
  if (digits.length <= 7) return '*' * digits.length;
  return '${digits.substring(0, 4)}${'*' * (digits.length - 7)}${digits.substring(digits.length - 3)}';
}

/// Alamat jalan disensor per kata (angka ikut jadi bintang); kota, provinsi,
/// dan kode pos dibiarkan — itu yang dibutuhkan invoice sebagai bukti tujuan
/// kirim, sama dengan yang boleh dilihat penjual (`shipping_address_for_seller`).
String maskStreet(String? street) {
  final text = (street ?? '').trim();
  if (text.isEmpty) return '';
  return text.split(RegExp(r'\s+')).map((word) {
    if (word.length <= 1) return RegExp(r'\d').hasMatch(word) ? '*' : word;
    final first = RegExp(r'\d').hasMatch(word[0]) ? '*' : word[0];
    return '$first${'*' * (word.length - 1)}';
  }).join(' ');
}
