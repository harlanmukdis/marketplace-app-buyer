/// Perilaku [CartCubit] terhadap repository palsu.
///
/// Yang diuji terutama **pembatasan yang tidak dilakukan server**: kuantitas
/// melebihi batas, kuantitas nol, dan ketukan ganda. Kalau bagian ini lepas,
/// keranjang bisa berisi nilai yang baru gagal jauh kemudian di checkout.
library;

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/cart/cubit/cart_cubit.dart';

CartSnapshot _snapshot({int quantity = 2, bool selected = true}) {
  final item = CartItemModel(
    id: 1,
    storeId: 7,
    productVariantId: 3,
    quantity: quantity,
    isSelected: selected,
    price: 1000,
    productName: 'Kopi',
    storeName: 'Toko Kopi',
  );
  return CartSnapshot(
    groups: [CartStoreGroup(storeName: 'Toko Kopi', items: [item])],
    summary: CartSummaryModel(
      subtotal: selected ? 1000.0 * quantity : 0.0,
      itemCount: selected ? 1 : 0,
    ),
  );
}

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeCartRepository implements CartRepository {
  DataState<CartSnapshot> result = DataSuccess(_snapshot());

  final List<String> calls = [];
  int? lastQuantity;
  int? lastVariantId;

  /// Menahan balasan supaya ketukan kedua bisa diuji saat yang pertama
  /// belum selesai.
  Future<void>? gate;

  Future<DataState<CartSnapshot>> _respond(String call) async {
    calls.add(call);
    if (gate != null) await gate;
    return result;
  }

  @override
  Future<DataState<CartSnapshot>> fetchCart() => _respond('fetch');

  @override
  Future<DataState<CartSnapshot>> addItem({
    required int productVariantId,
    required int quantity,
  }) {
    lastVariantId = productVariantId;
    lastQuantity = quantity;
    return _respond('add');
  }

  @override
  Future<DataState<CartSnapshot>> updateQuantity(int itemId, int quantity) {
    lastQuantity = quantity;
    return _respond('update:$itemId');
  }

  @override
  Future<DataState<CartSnapshot>> setSelected(int itemId, bool isSelected) =>
      _respond('select:$itemId:$isSelected');

  @override
  Future<DataState<CartSnapshot>> removeItem(int itemId) =>
      _respond('remove:$itemId');

  @override
  Future<DataState<CartSnapshot>> applyVoucher(String code) =>
      _respond('voucher:$code');

  @override
  Future<DataState<CartSnapshot>> removeVoucher(String code) =>
      _respond('voucher-lepas:$code');
}

void main() {
  late _FakeCartRepository repository;

  setUp(() {
    repository = _FakeCartRepository();
    injector.registerSingleton<CartRepository>(repository);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('load', () {
    test('sukses jadi CartReady berisi keranjang', () async {
      final cubit = CartCubit();
      await cubit.load();

      final state = cubit.state as CartReady;
      expect(state.cart.totalLines, 1);
      expect(state.cart.summary.subtotal, 2000);
      await cubit.close();
    });

    test('gagal jadi CartError', () async {
      repository.result = DataFailed(_error('NETWORK'));
      final cubit = CartCubit();
      await cubit.load();

      expect(cubit.state, isA<CartError>());
      await cubit.close();
    });
  });

  group('pembatasan kuantitas yang tidak dilakukan server', () {
    test('kuantitas di atas batas dipotong sebelum dikirim', () async {
      final cubit = CartCubit();
      await cubit.load();
      await cubit.changeQuantity(1, 99999);

      expect(repository.lastQuantity, CartCubit.maxQuantityPerLine);
      await cubit.close();
    });

    test('kuantitas nol MENGHAPUS baris, bukan mengirim quantity 0', () async {
      // Mengirim 0 diterima server dan menyisakan baris hantu berkuantitas
      // nol yang tetap tampil di keranjang.
      final cubit = CartCubit();
      await cubit.load();
      repository.calls.clear();

      await cubit.changeQuantity(1, 0);

      expect(repository.calls, contains('remove:1'));
      expect(repository.calls.any((c) => c.startsWith('update:')), isFalse);
      await cubit.close();
    });

    test('kuantitas negatif juga menghapus, bukan dikirim apa adanya',
        () async {
      final cubit = CartCubit();
      await cubit.load();
      repository.calls.clear();

      await cubit.changeQuantity(1, -5);

      expect(repository.calls, contains('remove:1'));
      await cubit.close();
    });

    test('addItem memastikan kuantitas minimal 1', () async {
      final cubit = CartCubit();
      await cubit.addItem(productVariantId: 3, quantity: 0);

      expect(repository.lastQuantity, 1);
      expect(repository.lastVariantId, 3);
      await cubit.close();
    });

    test('decrement dari 1 menghapus baris', () async {
      repository.result = DataSuccess(_snapshot(quantity: 1));
      final cubit = CartCubit();
      await cubit.load();
      repository.calls.clear();

      await cubit.decrement(1);

      expect(repository.calls, contains('remove:1'));
      await cubit.close();
    });

    test('increment menaikkan dari kuantitas yang sedang tampil', () async {
      repository.result = DataSuccess(_snapshot(quantity: 4));
      final cubit = CartCubit();
      await cubit.load();

      await cubit.increment(1);

      expect(repository.lastQuantity, 5);
      await cubit.close();
    });
  });

  group('ketukan ganda', () {
    test('aksi kedua pada baris yang sama diabaikan selagi menunggu', () async {
      final cubit = CartCubit();
      await cubit.load();

      // Tahan balasan, lalu tekan dua kali.
      final completer = Completer<void>();
      repository.gate = completer.future;
      repository.calls.clear();

      final first = cubit.changeQuantity(1, 5);
      final second = cubit.changeQuantity(1, 6);

      completer.complete();
      await Future.wait([first, second]);

      expect(repository.calls.where((c) => c.startsWith('update:')).length, 1,
          reason: 'permintaan kedua tidak boleh saling mendahului');
      await cubit.close();
    });
  });

  group('kegagalan aksi', () {
    test('isi keranjang dipertahankan, hanya actionError yang terisi',
        () async {
      final cubit = CartCubit();
      await cubit.load();

      repository.result = DataFailed(_error('STOCK_INSUFFICIENT'));
      await cubit.changeQuantity(1, 3);

      final state = cubit.state as CartReady;
      // Mengosongkan keranjang karena satu tombol gagal akan terlihat seperti
      // barangnya hilang.
      expect(state.cart.totalLines, 1);
      expect(state.actionError?.code, 'STOCK_INSUFFICIENT');
      expect(state.mutatingItemIds, isEmpty);
      await cubit.close();
    });

    test('clearActionError membuang pesan supaya snackbar tidak berulang',
        () async {
      final cubit = CartCubit();
      await cubit.load();
      repository.result = DataFailed(_error('NETWORK'));
      await cubit.removeItem(1);

      cubit.clearActionError();

      expect((cubit.state as CartReady).actionError, isNull);
      await cubit.close();
    });
  });

  test('setSelected meneruskan nilai centang apa adanya', () async {
    final cubit = CartCubit();
    await cubit.load();
    await cubit.setSelected(1, false);

    expect(repository.calls, contains('select:1:false'));
    await cubit.close();
  });
}
