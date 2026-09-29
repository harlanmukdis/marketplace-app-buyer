/// Ruang chat: berbagi produk & pesanan (`product_share` / `order_share`).
///
/// Yang dipatok: kartu "Tanyakan produk ini" muncul hanya bila ruang dibuka
/// dari halaman produk, laci pesanan hanya menawarkan pesanan **dari toko
/// percakapan ini** (`GET /orders` tidak bisa disaring per toko), dan pesan
/// bagikan dirender sebagai kartu, bukan teks pengganti.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/services/token_store.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/chat/chat_room_context.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_share_cubit.dart';
import 'package:marketplace_app_member/ui/main/chat/screens/chat_room_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_catalog_repository.dart';

const _me = 1814;

class _Chat implements ChatRepository {
  List<ChatMessageModel> messages = const [];
  final List<String> calls = [];

  @override
  Future<DataState<List<ChatMessageModel>>> fetchMessages(int conversationId, {int page = 1}) async =>
      DataSuccess(messages);

  @override
  Future<DataState<List<ChatMessageModel>>> share(int conversationId,
      {int? productId, int? orderId}) async {
    calls.add('share:${productId ?? '-'}:${orderId ?? '-'}');
    messages = [
      ...messages,
      ChatMessageModel(
        id: 100 + messages.length,
        senderUserId: _me,
        typeCode: productId != null ? 'product_share' : 'order_share',
        sharedProductId: productId,
        sharedOrderId: orderId,
        createdAt: DateTime.utc(2026, 9, 29, 7),
      ),
    ];
    return DataSuccess(messages);
  }

  @override
  Future<DataState<void>> markRead(int conversationId) async => const DataSuccess(null);

  @override
  Future<DataState<List<ChatConversationModel>>> fetchConversations() async =>
      const DataSuccess([ChatConversationModel(id: 5, storeId: 3, storeName: 'Toko Tiga')]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Catalog extends FakeCatalogRepository {
  @override
  Future<DataState<ProductModel>> fetchProduct(int id, {bool forceRefresh = false}) async =>
      DataSuccess(ProductModel(id: id, storeId: 3, name: 'Cat Tembok $id', basePrice: 150000));
}

class _Orders implements OrderRepository {
  final List<int> pages = [];

  static const _all = [
    OrderModel(id: 41, orderNumber: 'ORD-TIGA-1', storeId: 3, statusCode: 'paid', grandTotal: 100000),
    OrderModel(id: 42, orderNumber: 'ORD-LAIN-1', storeId: 8, statusCode: 'paid'),
    OrderModel(id: 43, orderNumber: 'ORD-TIGA-2', storeId: 3, statusCode: 'completed'),
  ];

  @override
  Future<DataState<List<OrderModel>>> fetchOrders({int page = 1}) async {
    pages.add(page);
    return page == 1 ? const DataSuccess(_all) : const DataEmpty();
  }

  @override
  Future<DataState<OrderModel>> fetchOrder(int id) async {
    for (final o in _all) {
      if (o.id == id) return DataSuccess(o);
    }
    return const DataFailed(DataError(code: 'PERMISSION_DENIED', message: 'x', kind: DataErrorKind.api));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

late _Chat _chat;
late _Orders _orders;

Future<void> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => const ChatRoomScreen(conversationId: 5, storeName: 'Toko Tiga')),
    GoRoute(path: '/:rest(.*)', builder: (_, __) => const SizedBox()),
  ]);
  await tester.pumpWidget(MaterialApp.router(
    routerConfig: router,
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({kUserId: _me});
    await CachedHelper.init();
    ChatRoomContext.reset();
    _chat = _Chat();
    _orders = _Orders();
    injector
      ..registerSingleton<ChatRepository>(_chat)
      ..registerSingleton<CatalogRepository>(_Catalog())
      ..registerSingleton<OrderRepository>(_orders)
      ..registerSingleton<TokenStore>(TokenStore(const FlutterSecureStorage()));
  });

  tearDown(() => injector.reset());

  testWidgets('dibuka dari halaman produk: kartu "Tanyakan" mengirim product_share', (tester) async {
    ChatRoomContext.put(5, const ChatRoomContext(storeId: 3, productId: 7));
    await _pump(tester);

    expect(find.text('Produk Sedang Ditanyakan'), findsOneWidget);
    expect(find.text('Cat Tembok 7'), findsOneWidget);

    await tester.tap(find.text('Tanyakan'));
    await tester.pumpAndSettle();

    expect(_chat.calls, ['share:7:-']);
    expect(find.text('Produk Sedang Ditanyakan'), findsNothing);
    // Gelembung bagikan berupa kartu produk.
    expect(find.text('Produk dibagikan'), findsOneWidget);
    expect(find.text('Cat Tembok 7'), findsOneWidget);
  });

  testWidgets('tanpa konteks tidak ada kartu produk; konteks hanya dipakai sekali', (tester) async {
    await _pump(tester);
    expect(find.text('Produk Sedang Ditanyakan'), findsNothing);
    expect(ChatRoomContext.take(5), isNull);
  });

  testWidgets('laci lampiran: hanya pesanan dari toko ini, lalu order_share', (tester) async {
    await _pump(tester);

    await tester.tap(find.byTooltip('Lampirkan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pesanan'));
    await tester.pumpAndSettle();

    expect(find.text('Bagikan Pesanan'), findsOneWidget);
    expect(find.text('ORD-TIGA-1'), findsOneWidget);
    expect(find.text('ORD-TIGA-2'), findsOneWidget);
    expect(find.text('ORD-LAIN-1'), findsNothing);
    // Halaman 1 tidak penuh → berhenti, tidak menyisir halaman berikutnya.
    expect(_orders.pages, [1]);

    await tester.tap(find.text('ORD-TIGA-1'));
    await tester.pumpAndSettle();

    expect(_chat.calls, ['share:-:41']);
    expect(find.text('ORD-TIGA-1'), findsOneWidget);
  });

  testWidgets('pesanan yang tidak bisa dibaca jatuh ke nomor id', (tester) async {
    _chat.messages = [
      ChatMessageModel(
        id: 1,
        senderUserId: 99,
        typeCode: 'order_share',
        sharedOrderId: 77,
        createdAt: DateTime.utc(2026, 9, 29, 7),
      ),
    ];
    await _pump(tester);
    expect(find.text('Pesanan #77'), findsOneWidget);
  });

  test('ChatShareCubit menyelesaikan store_id dari daftar percakapan', () async {
    final cubit = ChatShareCubit(5);
    await cubit.loadOrderPicker();
    expect(cubit.state.storeId, 3);
    expect(cubit.state.pickerOrders.map((o) => o.id), [41, 43]);
    await cubit.close();
  });
}
