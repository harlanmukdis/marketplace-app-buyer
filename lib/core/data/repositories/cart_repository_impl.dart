import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';

/// Implementasi [CartRepository] di atas [CartService].
///
/// Tidak memakai `RepositoryGuard` seperti katalog, karena bentuknya berbeda:
/// hampir semua method di sini adalah **mutasi lalu baca ulang**, dan yang
/// dikembalikan selalu [CartSnapshot] hasil dua panggilan — bukan amplop
/// tunggal yang tinggal dibungkus.
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._service);

  final CartService _service;

  @override
  Future<DataState<CartSnapshot>> fetchCart() => _readBack();

  @override
  Future<DataState<CartSnapshot>> addItem({
    required int productVariantId,
    required int quantity,
  }) {
    return _mutateThenRead(() => _service.addItem(
          productVariantId: productVariantId,
          quantity: quantity,
        ));
  }

  @override
  Future<DataState<CartSnapshot>> updateQuantity(int itemId, int quantity) =>
      _mutateThenRead(() => _service.updateItem(itemId, quantity: quantity));

  @override
  Future<DataState<CartSnapshot>> setSelected(int itemId, bool isSelected) =>
      _mutateThenRead(
          () => _service.updateItem(itemId, isSelected: isSelected));

  @override
  Future<DataState<CartSnapshot>> removeItem(int itemId) =>
      _mutateThenRead(() => _service.removeItem(itemId));

  @override
  Future<DataState<CartSnapshot>> applyVoucher(String code) =>
      _mutateThenRead(() => _service.applyVoucher(code));

  /// Menjalankan mutasi lalu membaca ulang keranjang.
  ///
  /// Kegagalan mutasi dilaporkan apa adanya **tanpa** membaca ulang: kalau
  /// `POST` dibalas `VARIANT_NOT_FOUND`, keranjangnya tidak berubah dan
  /// menembak dua permintaan lagi hanya menunda pesan errornya.
  Future<DataState<CartSnapshot>> _mutateThenRead(
    Future<Object?> Function() mutate,
  ) async {
    try {
      await mutate();
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return _readBack();
  }

  /// Membaca isi keranjang dan ringkasannya sekaligus.
  ///
  /// Keduanya ditembak paralel karena tidak saling bergantung, tapi di-`await`
  /// terpisah: kalau dibungkus `Future.wait` dan salah satunya melempar lebih
  /// dulu, kegagalan yang lain menjadi *unhandled async error* yang muncul di
  /// log tanpa sumber yang jelas.
  ///
  /// Kalau salah satunya gagal, seluruh hasil dianggap gagal. Menampilkan
  /// daftar barang dengan total yang salah lebih berbahaya daripada
  /// menampilkan pesan error — user membuat keputusan belanja dari angka itu.
  Future<DataState<CartSnapshot>> _readBack() async {
    final cartFuture = _service.fetchCart();
    final summaryFuture = _service.fetchSummary();

    DataError? failure;
    var groups = const <CartStoreGroup>[];
    var summary = const CartSummaryModel();

    try {
      groups = (await cartFuture).data;
    } on ApiException catch (e) {
      failure = e.error;
    }

    try {
      summary = (await summaryFuture).data;
    } on ApiException catch (e) {
      failure ??= e.error;
    }

    if (failure != null) return DataFailed(failure);
    return DataSuccess(CartSnapshot(groups: groups, summary: summary));
  }
}
