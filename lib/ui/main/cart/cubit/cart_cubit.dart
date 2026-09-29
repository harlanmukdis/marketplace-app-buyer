import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'cart_cubit.freezed.dart';
part 'cart_state.dart';

/// Keranjang belanja.
///
/// ⚠️ **Cubit inilah satu-satunya yang membatasi kuantitas.** Server menerima
/// apa pun — `quantity: 99999` untuk varian berstok 150 dibalas `200` dan
/// tersimpan, begitu juga `0`. Kalau pembatasan di sini dilepas, user baru
/// tahu keranjangnya mustahil ketika checkout gagal, jauh setelah ia memilih.
///
/// Stok per baris **tidak dikirim `GET /cart`**, jadi batas atas yang bisa
/// ditegakkan di layar keranjang hanyalah [maxQuantityPerLine]. Batas
/// sesungguhnya terhadap stok ditegakkan di halaman detail produk, yang tahu
/// stok variannya.
class CartCubit extends Cubit<CartState> {
  CartCubit()
      : _repository = injector<CartRepository>(),
        super(const CartState.loading());

  static CartCubit get(BuildContext context) => BlocProvider.of(context);

  final CartRepository _repository;

  /// Batas atas kuantitas per baris.
  ///
  /// Angka kewarasan, bukan aturan bisnis: keranjang tidak tahu stok, jadi
  /// yang bisa dicegah di sini hanyalah nilai yang jelas keliru — biasanya
  /// dari menahan tombol "+" atau salah ketik.
  static const int maxQuantityPerLine = 999;

  Future<void> load() async {
    emit(const CartState.loading());
    final result = await _repository.fetchCart();
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(CartState.ready(cart: data));
      case DataEmpty():
        emit(const CartState.ready(cart: CartSnapshot.empty));
      case DataFailed(:final error):
        emit(CartState.error(error));
      case DataLoading():
        break;
    }
  }

  /// Menambah varian ke keranjang.
  ///
  /// Dipanggil dari halaman detail produk, yang sudah membatasi [quantity]
  /// terhadap stok varian. Di sini hanya dijaga agar tidak nol atau negatif.
  Future<void> addItem({
    required int productVariantId,
    required int quantity,
  }) async {
    final safeQuantity = quantity.clamp(1, maxQuantityPerLine);
    await _mutate(
      itemId: null,
      action: () => _repository.addItem(
        productVariantId: productVariantId,
        quantity: safeQuantity,
      ),
    );
  }

  /// Mengubah kuantitas satu baris.
  ///
  /// Nilai di bawah 1 **tidak** dikirim sebagai `0` — itu akan menyisakan
  /// baris hantu berkuantitas nol yang tetap tampil di keranjang dan tetap
  /// dihitung `item_count`. Yang benar adalah menghapus barisnya.
  Future<void> changeQuantity(int itemId, int quantity) async {
    if (quantity < 1) return removeItem(itemId);

    final safeQuantity = quantity.clamp(1, maxQuantityPerLine);
    await _mutate(
      itemId: itemId,
      action: () => _repository.updateQuantity(itemId, safeQuantity),
    );
  }

  Future<void> increment(int itemId) async {
    final item = _itemById(itemId);
    if (item == null) return;
    await changeQuantity(itemId, item.quantity + 1);
  }

  Future<void> decrement(int itemId) async {
    final item = _itemById(itemId);
    if (item == null) return;
    await changeQuantity(itemId, item.quantity - 1);
  }

  Future<void> setSelected(int itemId, bool isSelected) => _mutate(
        itemId: itemId,
        action: () => _repository.setSelected(itemId, isSelected),
      );

  Future<void> removeItem(int itemId) => _mutate(
        itemId: itemId,
        action: () => _repository.removeItem(itemId),
      );

  /// Mencentang / melepas centang banyak baris sekaligus — dipakai "Pilih
  /// Semua" dan centang per toko.
  ///
  /// Server **tidak punya endpoint massal**: tiap baris tetap satu `PATCH`
  /// (plus baca ulang dari repository). Baris yang sudah bernilai sama
  /// dilewati supaya tidak ada request sia-sia.
  Future<void> setSelectedMany(Iterable<int> itemIds, bool isSelected) {
    final targets = [
      for (final id in itemIds)
        if (_itemById(id) case final item? when item.isSelected != isSelected)
          id,
    ];
    return _mutateMany(
      targets,
      (id) => _repository.setSelected(id, isSelected),
    );
  }

  /// Menghapus banyak baris sekaligus (tombol "Hapus" di atas keranjang).
  /// Sama seperti [setSelectedMany], satu `DELETE` per baris.
  Future<void> removeItems(Iterable<int> itemIds) => _mutateMany(
        itemIds.toList(),
        _repository.removeItem,
      );

  Future<void> applyVoucher(String code) => _mutate(
        itemId: null,
        action: () => _repository.applyVoucher(code),
      );

  Future<void> removeVoucher(String code) => _mutate(
        itemId: null,
        action: () => _repository.removeVoucher(code),
      );

  /// Membuang pesan error aksi setelah ditampilkan, supaya snackbar yang sama
  /// tidak muncul lagi pada rebuild berikutnya.
  void clearActionError() {
    final current = state;
    if (current is! CartReady || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  /// Menjalankan satu mutasi sambil menandai baris yang terlibat sebagai
  /// sedang sibuk.
  ///
  /// Saat gagal, isi keranjang yang lama **dipertahankan** dan hanya
  /// [CartReady.actionError] yang terisi — mengosongkan keranjang karena satu
  /// tombol gagal akan terlihat seperti barangnya hilang.
  Future<void> _mutate({
    required int? itemId,
    required Future<DataState<CartSnapshot>> Function() action,
  }) async {
    final current = state;
    if (current is CartReady && itemId != null) {
      // Tombol yang sama ditekan dua kali sebelum balasan pertama datang akan
      // mengirim dua permintaan yang saling mendahului; abaikan yang kedua.
      if (current.mutatingItemIds.contains(itemId)) return;
      emit(current.copyWith(
        mutatingItemIds: {...current.mutatingItemIds, itemId},
        actionError: null,
      ));
    }

    final result = await action();
    if (isClosed) return;

    final previous = state;
    switch (result) {
      case DataSuccess(:final data):
        emit(CartState.ready(cart: data));
      case DataEmpty():
        emit(const CartState.ready(cart: CartSnapshot.empty));
      case DataFailed(:final error):
        if (previous is CartReady) {
          emit(previous.copyWith(
            mutatingItemIds: <int>{...previous.mutatingItemIds}..remove(itemId),
            actionError: error,
          ));
        } else {
          emit(CartState.error(error));
        }
      case DataLoading():
        break;
    }
  }

  /// Menjalankan mutasi per baris secara **berurutan**, bukan paralel:
  /// `php -S` di dev single-threaded, dan tiap mutasi diikuti baca ulang —
  /// paralel hanya menghasilkan snapshot yang saling mendahului.
  ///
  /// Berhenti pada kegagalan pertama; isi keranjang terakhir yang diketahui
  /// tetap tampil dan kegagalannya jadi [CartReady.actionError].
  Future<void> _mutateMany(
    List<int> itemIds,
    Future<DataState<CartSnapshot>> Function(int itemId) action,
  ) async {
    final current = state;
    if (current is! CartReady || itemIds.isEmpty) return;
    if (itemIds.any(current.mutatingItemIds.contains)) return;
    emit(current.copyWith(
      mutatingItemIds: {...current.mutatingItemIds, ...itemIds},
      actionError: null,
    ));

    CartSnapshot? latest;
    DataError? failure;
    for (final id in itemIds) {
      final result = await action(id);
      if (isClosed) return;
      switch (result) {
        case DataSuccess(:final data):
          latest = data;
        case DataEmpty():
          latest = CartSnapshot.empty;
        case DataFailed(:final error):
          failure = error;
        case DataLoading():
          break;
      }
      if (failure != null) break;
    }

    final previous = state;
    final remaining = previous is CartReady
        ? ({...previous.mutatingItemIds}..removeAll(itemIds))
        : <int>{};
    final cart = latest ?? (previous is CartReady ? previous.cart : null);
    if (cart == null) {
      if (failure != null) emit(CartState.error(failure));
      return;
    }
    emit(CartState.ready(
      cart: cart,
      mutatingItemIds: remaining,
      actionError: failure,
    ));
  }

  CartItemModel? _itemById(int itemId) {
    final current = state;
    if (current is! CartReady) return null;
    for (final item in current.cart.allItems) {
      if (item.id == itemId) return item;
    }
    return null;
  }
}
