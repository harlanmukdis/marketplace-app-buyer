/// Perilaku [ProductDetailCubit] dan aturan stok pemilih varian.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/product_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/variant_sheet.dart';

import 'support/fake_catalog_repository.dart';

class _DetailCatalog extends FakeCatalogRepository {
  DataState<ProductModel> detail = const DataEmpty();
  final List<bool> forceRefreshCalls = [];

  @override
  Future<DataState<ProductModel>> fetchProduct(int id, {bool forceRefresh = false}) async {
    forceRefreshCalls.add(forceRefresh);
    return detail;
  }
}

ProductModel _product({int stockA = 5, int stockB = 3}) => ProductModel(
      id: 1,
      variants: [
        ProductVariantModel(id: 10, stock: stockA),
        ProductVariantModel(id: 11, stock: stockB),
      ],
    );

void main() {
  late _DetailCatalog catalog;

  setUp(() {
    catalog = _DetailCatalog();
    injector.registerSingleton<CatalogRepository>(catalog);
  });

  tearDown(() async {
    await injector.reset();
  });

  test('varian awal adalah yang pertama masih berstok', () async {
    catalog.detail = DataSuccess(_product(stockA: 0));
    final cubit = ProductDetailCubit(1);
    await cubit.load();

    expect((cubit.state as ProductDetailLoaded).selectedVariant?.id, 11);
    await cubit.close();
  });

  test('refresh tidak memancarkan loading dan mempertahankan varian terpilih', () async {
    catalog.detail = DataSuccess(_product());
    final cubit = ProductDetailCubit(1);
    await cubit.load();
    cubit.selectVariant(_product().variants[1]);

    final emitted = <ProductDetailState>[];
    final sub = cubit.stream.listen(emitted.add);
    catalog.detail = DataSuccess(_product(stockB: 1));
    await cubit.refresh();
    await sub.cancel();

    expect(emitted.whereType<ProductDetailLoading>(), isEmpty,
        reason: 'halaman tidak boleh berkedip jadi spinner sesudah tambah keranjang');
    final state = cubit.state as ProductDetailLoaded;
    expect(state.selectedVariant?.id, 11);
    expect(state.selectedVariant?.stock, 1);
    expect(catalog.forceRefreshCalls.last, isTrue);
    await cubit.close();
  });

  test('refresh gagal mempertahankan halaman yang sudah tampil', () async {
    catalog.detail = DataSuccess(_product());
    final cubit = ProductDetailCubit(1);
    await cubit.load();

    catalog.detail = const DataFailed(
      DataError(code: 'SERVER_ERROR', message: 'x', kind: DataErrorKind.api),
    );
    await cubit.refresh();

    expect(cubit.state, isA<ProductDetailLoaded>());
    await cubit.close();
  });

  group('purchasableStockOf', () {
    test('varian nonaktif dan stok tak diketahui dianggap nol', () {
      // Checkout mereservasi stok gudang untuk SEMUA mode — Pre-Order pun —
      // jadi tanpa stok tidak ada yang bisa dibeli.
      expect(purchasableStockOf(const ProductVariantModel(id: 1, stock: 4, isActive: false)), 0);
      expect(purchasableStockOf(const ProductVariantModel(id: 1)), 0);
      expect(purchasableStockOf(const ProductVariantModel(id: 1, stock: -2)), 0);
      expect(purchasableStockOf(const ProductVariantModel(id: 1, stock: 7)), 7);
    });
  });
}
