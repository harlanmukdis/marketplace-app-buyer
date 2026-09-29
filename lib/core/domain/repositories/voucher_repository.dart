import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/voucher_model.dart';

/// Voucher milik pembeli dan rekomendasi untuk keranjang.
///
/// Memasang/melepas voucher ada di `CartRepository` — hasilnya keranjang
/// yang dibaca ulang, bukan daftar voucher.
abstract class VoucherRepository {
  Future<DataState<List<VoucherModel>>> fetchMyVouchers();

  /// Mengklaim kode lalu mengembalikan `GET /me/vouchers` hasil baca ulang —
  /// balasan klaim hanya `{id}` baris klaim, bukan voucher-nya.
  Future<DataState<List<VoucherModel>>> claim(String code);

  /// ⚠️ Jangan dipanggil saat tidak ada baris keranjang tercentang: server
  /// membalas 500 (lihat `VoucherService`).
  Future<DataState<List<AppliedVoucherModel>>> fetchRecommended();

  /// Sama syaratnya dengan [fetchRecommended].
  Future<DataState<List<AppliedVoucherModel>>> autoApply();
}
