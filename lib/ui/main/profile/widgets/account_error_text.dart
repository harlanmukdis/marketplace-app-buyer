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
/// `INVALID_TOKEN` sungguhan dan dipakai dua alur: `reset-password` (token
/// 60 menit) dan ganti email/HP (`change-confirm`, token 30 menit). Salah,
/// sudah terpakai, dan kedaluwarsa tidak bisa dibedakan, jadi pesannya umum;
/// layar yang tahu konteksnya memakai `overrides`. Sisanya milik **kontrak
/// usulan** (mock verifikasi identitas, `assets/mock/pending_api/README.md`).
const Map<String, String> kAccountErrorMessages = {
  'INVALID_TOKEN': 'Kode tidak berlaku. Mungkin salah, sudah dipakai, atau '
      'kedaluwarsa — minta kode baru.',
  'ID_CARD_ALREADY_USED': 'NIK ini sudah dipakai akun Xpedia lain. Satu KTP hanya untuk '
      'satu akun — hubungi Xpedia 911 kalau ini bukan akunmu.',
  'IDENTITY_LOCKED': 'Nama lengkap terkunci karena identitasmu sudah diverifikasi.',
};
