part of 'voucher_cubit.dart';

/// Status layar voucher.
///
/// Tiga sumbernya dimuat terpisah dan boleh gagal sendiri-sendiri: keranjang
/// (voucher terpasang — **fatal**, karena tanpa itu layar tidak tahu apakah
/// rekomendasi boleh diminta), voucher saya, dan rekomendasi (keduanya tidak
/// fatal).
@freezed
sealed class VoucherState with _$VoucherState {
  const VoucherState._();

  const factory VoucherState.loading() = VoucherLoading;

  const factory VoucherState.ready({
    /// Ringkasan keranjang: `vouchers` yang terpasang + `item_count` baris
    /// tercentang.
    required CartSummaryModel summary,
    @Default(<VoucherModel>[]) List<VoucherModel> claimed,
    DataError? claimedError,

    /// Kosong — dan **tidak diminta** — selama tidak ada baris tercentang:
    /// servernya membalas 500 untuk keranjang kosong.
    @Default(<AppliedVoucherModel>[]) List<AppliedVoucherModel> recommended,
    DataError? recommendedError,

    /// Kode yang sedang dipasang/dilepas/diklaim, untuk mengunci tombolnya
    /// saja.
    String? busyCode,
    @Default(false) bool autoApplying,
    DataError? actionError,

    /// Kalimat sukses sekali tampil (snackbar), mis. "Voucher dipasang".
    String? notice,
  }) = VoucherReady;

  const factory VoucherState.error(DataError error) = VoucherError;
}
