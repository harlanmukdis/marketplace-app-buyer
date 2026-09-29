/// Pemilih varian: tombolnya benar-benar menambah ke keranjang.
///
/// Ini lapisan yang dulu tidak diuji siapa pun — `CartCubit.addItem` benar
/// dan `CartService` benar, tapi tombol di halaman produk mati selamanya
/// karena "sibuk" disimpulkan dari `CartLoading` (CLAUDE.md, "Bug pertama
/// yang ditemukan lapisan ini"). Test di sini menekan tombolnya sungguhan.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/catalog/widgets/variant_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeCartRepository implements CartRepository {
  final List<({int variantId, int quantity})> added = [];
  DataState<CartSnapshot> result = const DataSuccess(CartSnapshot.empty);

  @override
  Future<DataState<CartSnapshot>> addItem({
    required int productVariantId,
    required int quantity,
  }) async {
    added.add((variantId: productVariantId, quantity: quantity));
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _product = ProductModel(
  id: 1,
  name: 'Kaos',
  basePrice: 100000,
  variants: [
    ProductVariantModel(id: 10, price: 100000, stock: 2, variantOptions: {'warna': 'Hitam'}),
    ProductVariantModel(id: 11, price: 120000, stock: 0, variantOptions: {'warna': 'Putih'}),
    ProductVariantModel(id: 12, price: 110000, stock: 5, variantOptions: {'warna': 'Biru'}),
  ],
);

void main() {
  late _FakeCartRepository cart;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    cart = _FakeCartRepository();
    injector.registerSingleton<CartRepository>(cart);
  });

  tearDown(() async {
    await injector.reset();
  });

  /// Membuka sheet; hasilnya dibaca lewat fungsi yang dikembalikan, karena
  /// baru terisi setelah sheet ditutup.
  Future<VariantSheetResult? Function()> open(WidgetTester tester) async {
    VariantSheetResult? result;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showVariantSheet(
                context,
                product: _product,
                initialVariant: _product.variants.first,
                intent: VariantSheetIntent.addToCart,
              );
            },
            child: const Text('buka'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();
    return () => result;
  }

  testWidgets('tombol Tambah ke Keranjang hidup dan mengirim varian terpilih',
      (tester) async {
    final result = await open(tester);

    // Ganti ke Biru, lalu tambah jadi 2 unit.
    await tester.tap(find.text('Biru'));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Tambah'));
    await tester.pump();

    final button = find.widgetWithText(FilledButton, 'Tambah ke Keranjang');
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull,
        reason: 'tombol tidak boleh mati karena CartCubit masih "loading"');
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(cart.added, [(variantId: 12, quantity: 2)]);
    expect(result()?.added, isTrue);
    expect(result()?.variant?.id, 12);
  });

  testWidgets('varian habis tampil "(Habis)" dan tidak bisa dipilih', (tester) async {
    await open(tester);

    expect(find.text('Putih (Habis)'), findsOneWidget);
    await tester.tap(find.text('Putih (Habis)'));
    await tester.pump();
    // Masih Hitam yang terpilih.
    expect(find.text('Hitam'), findsWidgets);
    expect(find.textContaining('Sisa Stok: 2'), findsOneWidget);
  });

  testWidgets('kuantitas dibatasi stok varian', (tester) async {
    await open(tester);

    final plus = find.bySemanticsLabel('Tambah');
    await tester.tap(plus);
    await tester.pump();
    await tester.tap(plus);
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Tambah ke Keranjang'));
    await tester.pumpAndSettle();
    expect(cart.added.single.quantity, 2, reason: 'stok Hitam hanya 2');
  });

  testWidgets('gagal menambah: sheet tetap terbuka dan tombol hidup lagi', (tester) async {
    cart.result = const DataFailed(
      DataError(code: 'VARIANT_NOT_FOUND', message: 'x', kind: DataErrorKind.api),
    );
    await open(tester);

    final button = find.widgetWithText(FilledButton, 'Tambah ke Keranjang');
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(button, findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
  });
}
