/// Uji asap "Ulasan Saya": ulasan yang masih bisa diubah vs terkunci, lencana
/// Simulasi, dan keadaan "belum tersedia" saat endpoint-nya tidak ada.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/review/screens/my_reviews_screen.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Reviews implements ReviewRepository {
  DataState<List<MyReviewModel>> mine = const DataEmpty();
  final List<int> updated = [];

  @override
  Future<DataState<List<MyReviewModel>>> fetchMine({int page = 1}) async => mine;

  @override
  Future<DataState<MyReviewModel>> update(int reviewId, ReviewUpdateDraft draft) async {
    updated.add(reviewId);
    final old = (mine as DataSuccess<List<MyReviewModel>>).data.firstWhere((r) => r.id == reviewId);
    return DataSuccess(old.copyWith(rating: draft.rating, comment: draft.comment));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Stores implements StoreRepository {
  @override
  Future<DataState<StoreModel>> fetchStore(int id) async =>
      DataSuccess(StoreModel(id: id, name: 'Toko Simulasi'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Stub implements OrderRepository, CartRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _now = DateTime.now().toUtc();

final _editable = MyReviewModel(
  id: 1,
  orderId: 3,
  orderItemId: 7,
  storeId: 2,
  productName: 'Produk Simulasi A',
  rating: 5,
  comment: 'Bagus',
  isEditable: true,
  createdAt: _now.subtract(const Duration(days: 2)),
  editableUntil: _now.add(const Duration(days: 28)),
);

final _locked = MyReviewModel(
  id: 2,
  productName: 'Produk Simulasi B',
  rating: 3,
  isAnonymous: true,
  createdAt: _now.subtract(const Duration(days: 45)),
  editableUntil: _now.subtract(const Duration(days: 15)),
);

Future<void> _pump(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => StoreDirectoryCubit()),
      BlocProvider(create: (_) => CartBadgeCubit()),
    ],
    child: const MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MyReviewsScreen(),
    ),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  late _Reviews reviews;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    reviews = _Reviews();
    final stub = _Stub();
    injector
      ..registerSingleton<ReviewRepository>(reviews)
      ..registerSingleton<StoreRepository>(_Stores())
      ..registerSingleton<OrderRepository>(stub)
      ..registerSingleton<CartRepository>(stub);
  });

  tearDown(() async => injector.reset());

  testWidgets('bisa diubah vs terkunci, dengan lencana Simulasi', (tester) async {
    reviews.mine = DataSuccess([_editable, _locked], meta: const {'mock': true, 'total': 2});
    await _pump(tester);
    expect(find.text('Ulasan Saya'), findsOneWidget);
    expect(find.text('Simulasi'), findsOneWidget);
    expect(find.text('Produk Simulasi A'), findsOneWidget);
    expect(find.text('Ubah Ulasan'), findsOneWidget);
    expect(find.text('Terkunci'), findsOneWidget);
    expect(find.text('Anonim'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ubah membuka formulir mode ubah dan mengganti barisnya', (tester) async {
    reviews.mine = DataSuccess([_editable, _locked], meta: const {'mock': true, 'total': 2});
    await _pump(tester);
    await tester.tap(find.text('Ubah Ulasan'));
    await tester.pumpAndSettle();
    expect(find.text('Ubah Ulasan'), findsOneWidget, reason: 'judul formulir');
    expect(find.text('Simpan Perubahan'), findsOneWidget);

    await tester.tap(find.byTooltip('2 bintang'));
    await tester.pump();
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(reviews.updated, [1]);
    expect(find.text('Ulasan Saya'), findsOneWidget, reason: 'kembali ke daftar');
  });

  testWidgets('endpoint belum ada → belum tersedia', (tester) async {
    reviews.mine = const DataFailed(DataError(
      code: 'CLIENT_BAD_RESPONSE',
      message: 'html',
      statusCode: 404,
      kind: DataErrorKind.server,
    ));
    await _pump(tester);
    expect(find.text('Ulasan Saya belum tersedia'), findsOneWidget);
  });

  testWidgets('kosong', (tester) async {
    await _pump(tester);
    expect(find.text('Belum ada ulasan'), findsOneWidget);
  });
}
