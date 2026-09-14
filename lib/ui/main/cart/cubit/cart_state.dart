part of 'cart_cubit.dart';

/// Status layar keranjang.
///
/// [CartReady] dipakai untuk keranjang berisi **maupun** kosong; kekosongan
/// bukan keadaan yang berbeda, hanya isi yang nol. Itu membuat aksi seperti
/// "muat ulang" tetap tersedia tanpa cabang khusus.
///
/// [CartReady.mutatingItemIds] menandai baris yang sedang dikirim ke server,
/// supaya hanya baris itu yang dikunci — bukan seluruh layar. Mengunci
/// semuanya membuat keranjang terasa membeku tiap kali satu tombol ditekan.
@freezed
sealed class CartState with _$CartState {
  const CartState._();

  const factory CartState.loading() = CartLoading;

  const factory CartState.ready({
    required CartSnapshot cart,

    /// Id baris yang sedang menunggu balasan server.
    @Default(<int>{}) Set<int> mutatingItemIds,

    /// Kegagalan aksi terakhir yang **tidak** menghapus isi keranjang —
    /// mis. gagal mengubah kuantitas. Layar menampilkannya sebagai snackbar,
    /// bukan sebagai layar error.
    DataError? actionError,
  }) = CartReady;

  /// Gagal memuat keranjang sama sekali.
  const factory CartState.error(DataError error) = CartError;

  bool get isBusy => switch (this) {
        CartReady(:final mutatingItemIds) => mutatingItemIds.isNotEmpty,
        CartLoading() => true,
        _ => false,
      };
}
