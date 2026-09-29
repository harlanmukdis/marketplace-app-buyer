import 'package:flutter/widgets.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Pesan untuk kode error pembayaran Wallet yang **belum** dikenal
/// `errorMessageFor` — kodenya baru diusulkan ke backend
/// ([WalletPayErrorCode]). Sisanya diteruskan ke `errorMessageFor`, jadi
/// `error.message` server tetap tidak pernah tampil.
///
/// Begitu kodenya masuk `ApiErrorCode`, pindahkan cabang-cabang ini ke
/// `lib/util/error_message.dart` dan hapus berkas ini.
String checkoutErrorText(BuildContext context, DataError error) {
  switch (error.code) {
    case WalletPayErrorCode.invalidPin:
      final left = _int(error.details?['attempts_left']);
      if (left == null) return 'PIN salah. Coba lagi.';
      if (left <= 0) {
        return 'PIN salah. Percobaan habis — tunggu beberapa menit.';
      }
      return 'PIN salah. Sisa $left percobaan.';
    case WalletPayErrorCode.pinNotSet:
      return 'Kamu belum membuat PIN Wallet. Buat PIN dulu untuk membayar.';
    case ApiErrorCode.insufficientBalance:
      final shortfall = error.walletShortfall;
      return shortfall == null || shortfall == 0
          ? 'Saldo Wallet tidak mencukupi. Top up dulu untuk melanjutkan.'
          : 'Saldo Wallet kurang ${formatRupiah(shortfall.toDouble())}. '
              'Top up dulu untuk melanjutkan.';
  }
  return errorMessageFor(context, error);
}

int? _int(Object? raw) {
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw);
  return null;
}
