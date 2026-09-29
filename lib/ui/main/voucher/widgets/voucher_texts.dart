import 'package:flutter/widgets.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/voucher_model.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Pesan untuk penolakan voucher yang belum dikenal `errorMessageFor`
/// ([VoucherErrorCode]). Sisanya diteruskan ke sana, jadi `error.message`
/// server tetap tidak pernah tampil.
String voucherErrorText(BuildContext context, DataError error) {
  switch (error.code) {
    case VoucherErrorCode.quotaExceeded:
      return 'Kuota voucher ini sudah habis.';
    case VoucherErrorCode.alreadyUsed:
      return 'Voucher ini sudah pernah kamu pakai.';
    case VoucherErrorCode.minSpendNotMet:
      return 'Belanjaan yang dipilih belum memenuhi minimum voucher ini.';
    case VoucherErrorCode.alreadyClaimed:
      return 'Voucher ini sudah ada di Voucher Saya.';
    // Klaim tanpa kode dibalas VALIDATION_ERROR tanpa kode khusus; aplikasi
    // sudah menolak kode kosong, jadi yang tersisa praktis kode tak dikenal.
    case ApiErrorCode.validationError:
      return 'Kode voucher tidak berlaku.';
  }
  return errorMessageFor(context, error);
}

/// Kalimat nilai voucher yang **diklaim** (`GET /me/vouchers`).
///
/// Cashback sengaja tidak ditulis sebagai potongan: nilainya jadi koin
/// sesudah pesanan selesai, bukan mengurangi yang dibayar (CLAUDE.md,
/// "Voucher keranjang").
String claimedVoucherValue(VoucherModel v) {
  if (v.isShipping) {
    return 'Potongan ongkir hingga ${formatRupiah(v.discountValue)}';
  }
  if (v.isCashback) return 'Cashback koin setelah pesanan selesai';
  if (v.isPercentage) {
    final cap = v.maxDiscount;
    return cap == null
        ? 'Diskon ${formatPercent(v.discountValue)}'
        : 'Diskon ${formatPercent(v.discountValue)} hingga ${formatRupiah(cap)}';
  }
  return 'Potongan ${formatRupiah(v.discountValue)}';
}

/// Kalimat nilai voucher terpasang / rekomendasi.
///
/// 🔴 `discount_amount` voucher ongkir `null` dan cashback `0` — keduanya
/// **bukan** potongan yang bisa ditulis "Hemat". Untuk rekomendasi ongkir,
/// `value` hanyalah potensi (`discount_value`), jadi ditulis "hingga".
String appliedVoucherValue(AppliedVoucherModel v) {
  if (v.isShipping) {
    final potential = v.estimatedValue ?? v.discountValue;
    return potential > 0
        ? 'Potongan ongkir hingga ${formatRupiah(potential)}, dihitung saat '
            'checkout'
        : 'Potongan ongkir dihitung saat checkout';
  }
  if (v.isCashback) return 'Cashback koin setelah pesanan selesai';
  final amount = v.discountAmount ?? v.estimatedValue ?? 0;
  return 'Hemat ${formatRupiah(amount)}';
}

/// Label slot penumpukan (maks 1 ongkir + 1 platform + 1 per toko).
String voucherSlotLabel(String category) => switch (category) {
      'shipping' => 'Bebas Ongkir',
      'platform' => 'Voucher Xpedia',
      'store' => 'Voucher Toko',
      _ => 'Voucher',
    };
