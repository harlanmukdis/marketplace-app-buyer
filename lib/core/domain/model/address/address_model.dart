import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

/// Alamat pengiriman dari `GET /me/addresses`.
///
/// ⚠️ **Nama fieldnya berbeda dari app lama.** Yang benar: [fullAddress]
/// (`full_address`) dan [isPrimary] (`is_primary`). Nama ala Markas —
/// `address_line`, `district`, `is_default` — tidak punya kolom, dan
/// mengirimnya membuat server membalas **500 halaman HTML**, bukan
/// `VALIDATION_ERROR`: field asing diteruskan mentah ke `INSERT`.
///
/// ⚠️ **Server tidak memvalidasi field wajib.** Sudah diuji: `POST` dengan
/// hanya `recipient_name` dibalas `201` dan menyimpan alamat dengan kota,
/// provinsi, kode pos, dan telepon **kosong**. Validasi kelengkapan adalah
/// tanggung jawab aplikasi — lihat [isComplete].
@freezed
abstract class AddressModel with _$AddressModel {
  const AddressModel._();

  const factory AddressModel({
    @IntJson() required int id,
    @IntJson() @JsonKey(name: 'user_id') @Default(0) int userId,

    /// Server mengisi `'Rumah'` kalau tidak dikirim.
    @StringJson() @Default('') String label,
    @StringJson()
    @JsonKey(name: 'recipient_name')
    @Default('')
    String recipientName,
    @StringJson() @Default('') String phone,

    /// Alamat lengkap satu baris. **Bukan** `address_line`.
    @StringJson()
    @JsonKey(name: 'full_address')
    @Default('')
    String fullAddress,
    @StringJson() @Default('') String city,
    @StringJson() @Default('') String province,
    @StringJson() @JsonKey(name: 'postal_code') @Default('') String postalCode,

    /// FK opsional ke `master_cities` (`GET /locations/cities`). `null` untuk
    /// alamat lama atau kota yang diketik bebas — master lokasi di seed baru
    /// berisi 15 kota, jadi teks bebas tetap sah.
    @IntOrNullJson() @JsonKey(name: 'city_id') int? cityId,
    @DoubleOrNullJson() double? latitude,
    @DoubleOrNullJson() double? longitude,

    /// Dikirim sebagai `"0"`/`"1"`.
    ///
    /// ⚠️ **Boleh lebih dari satu alamat bertanda primary.** Sudah diuji:
    /// menyetel `is_primary: 1` pada alamat kedua **tidak** melepas tanda pada
    /// alamat pertama. Jangan mengandalkan keunikannya — pakai
    /// [primaryAddressOf] yang memilih satu secara deterministik.
    @BoolJson() @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  /// Cukup lengkap untuk dipakai checkout.
  ///
  /// Server menerima alamat kosong, jadi pemeriksaan ini harus dilakukan
  /// sebelum alamat ditawarkan sebagai tujuan pengiriman — bukan sesudah
  /// checkout gagal.
  bool get isComplete =>
      recipientName.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      fullAddress.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      province.trim().isNotEmpty &&
      postalCode.trim().isNotEmpty;

  /// Ringkasan satu baris untuk ditampilkan di daftar dan di checkout.
  String get summary {
    final parts = [fullAddress, city, province, postalCode]
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty);
    return parts.join(', ');
  }
}

/// Memilih satu alamat utama dari daftar.
///
/// Dibutuhkan karena server membolehkan **beberapa** alamat bertanda primary
/// sekaligus. Aturannya: alamat primary pertama yang lengkap, lalu alamat
/// primary pertama apa pun, lalu alamat lengkap pertama, lalu alamat pertama.
/// `null` hanya kalau daftarnya kosong.
AddressModel? primaryAddressOf(List<AddressModel> addresses) {
  if (addresses.isEmpty) return null;
  for (final a in addresses) {
    if (a.isPrimary && a.isComplete) return a;
  }
  for (final a in addresses) {
    if (a.isPrimary) return a;
  }
  for (final a in addresses) {
    if (a.isComplete) return a;
  }
  return addresses.first;
}
