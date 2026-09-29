import 'package:flutter/widgets.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/util/error_message.dart';

/// Kode untuk penolakan yang dibuat **aplikasi sendiri** sebelum menyentuh
/// jaringan (minimum topup, PIN belum 6 digit, subjek tiket kosong, …).
///
/// Hanya kode inilah yang `message`-nya boleh tampil ke user: teksnya ditulis
/// di aplikasi dalam bahasa Indonesia, bukan teks developer dari server.
/// Alias [ClientErrorCode.localValidation], dipertahankan supaya pemakai
/// yang sudah ada tidak perlu diubah.
const String kLocalValidationCode = ClientErrorCode.localValidation;

DataError localValidationError(String message) => DataError(
      code: kLocalValidationCode,
      message: message,
      kind: DataErrorKind.api,
    );

/// [errorMessageFor] plus pesan validasi lokal di atas.
///
/// [overrides] dipakai layar yang tahu konteks penolakannya — mis.
/// `VALIDATION_ERROR` saat mengganti PIN praktis berarti PIN lama salah,
/// sedangkan pada rekening berarti nama pemilik tidak cocok. Server memakai
/// kode yang sama untuk keduanya, jadi hanya layarnya yang bisa menyebut
/// sebab yang tepat.
String accountErrorText(
  BuildContext context,
  DataError error, {
  Map<String, String> overrides = const {},
}) {
  if (error.code == kLocalValidationCode) return error.message;
  final specific = overrides[error.code] ?? kAccountErrorMessages[error.code];
  if (specific != null) return specific;
  return errorMessageFor(context, error);
}

/// Kode error domain akun yang belum dipetakan `errorMessageFor`.
///
/// Sebagian besar milik **kontrak usulan** (mock: verifikasi identitas dan
/// ganti kontak, lihat `assets/mock/pending_api/README.md`). `INVALID_TOKEN`
/// sungguhan: dibalas `reset-password` untuk token yang salah, sudah
/// terpakai, atau lewat 60 menit — ketiganya tidak bisa dibedakan.
const Map<String, String> kAccountErrorMessages = {
  'INVALID_TOKEN': 'Kode reset tidak berlaku. Mungkin sudah dipakai atau lewat '
      '60 menit — minta tautan baru.',
  'INVALID_OTP': 'Kode OTP salah. Periksa lagi kode yang kami kirim.',
  'OTP_EXPIRED': 'Kode OTP sudah kedaluwarsa. Minta kode baru.',
  'CONTACT_CHANGE_NOT_FOUND': 'Permintaan penggantian sudah tidak berlaku. Mulai lagi dari awal.',
  'ID_CARD_ALREADY_USED': 'NIK ini sudah dipakai akun Xpedia lain. Satu KTP hanya untuk '
      'satu akun — hubungi Xpedia 911 kalau ini bukan akunmu.',
  'IDENTITY_LOCKED': 'Nama lengkap terkunci karena identitasmu sudah diverifikasi.',
};
