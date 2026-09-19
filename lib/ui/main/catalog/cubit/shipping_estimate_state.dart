part of 'shipping_estimate_cubit.dart';

/// Status estimasi ongkir di halaman produk.
///
/// Tidak ada varian `error`, dan itu disengaja: ongkir adalah informasi
/// pelengkap, sehingga kegagalannya disembunyikan ([ShippingEstimateHidden])
/// alih-alih memunculkan spanduk error di halaman produk. Lihat
/// [ShippingEstimateCubit].
@freezed
sealed class ShippingEstimateState with _$ShippingEstimateState {
  const ShippingEstimateState._();

  /// Tidak ditampilkan sama sekali — belum masuk, belum punya alamat lengkap,
  /// atau permintaannya gagal.
  const factory ShippingEstimateState.hidden() = ShippingEstimateHidden;

  const factory ShippingEstimateState.loading({
    required AddressModel address,
  }) = ShippingEstimateLoading;

  const factory ShippingEstimateState.ready({
    required AddressModel address,
    required List<ShippingOptionModel> options,
  }) = ShippingEstimateReady;

  /// Tidak ada kurir yang melayani alamat ini — jawaban yang sah, dan lebih
  /// baik diketahui sebelum barangnya masuk keranjang.
  const factory ShippingEstimateState.unavailable({
    required AddressModel address,
  }) = ShippingEstimateUnavailable;
}

extension ShippingEstimateReadyX on ShippingEstimateReady {
  /// Opsi termurah. Server sudah mengurutkannya, tapi diurutkan ulang di sini
  /// supaya "mulai dari" tetap benar kalau urutannya berubah.
  ShippingOptionModel get cheapest =>
      options.reduce((a, b) => a.cost <= b.cost ? a : b);

  /// `true` kalau ada lebih dari satu pilihan untuk ditampilkan.
  bool get hasAlternatives => options.length > 1;
}
