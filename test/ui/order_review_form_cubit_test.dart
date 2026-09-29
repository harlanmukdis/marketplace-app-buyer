/// Perilaku [ReviewFormCubit].
///
/// Yang dipatok: formulir **tidak pernah terbuka** untuk pesanan yang pasti
/// ditolak server (`404 ORDER_ITEM_NOT_FOUND` untuk status selain
/// `completed`), dan ulasan tidak terkirim dua kali.
library;

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/review_form_cubit.dart';

OrderModel _order(String status) => OrderModel(
      id: 1,
      statusCode: status,
      items: const [OrderItemModel(id: 7, productName: 'Kopi Gayo', quantity: 1)],
    );

class _FakeOrderRepository implements OrderRepository {
  DataState<OrderModel> detail = DataSuccess(_order('completed'));

  @override
  Future<DataState<OrderModel>> fetchOrder(int id) async => detail;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReviewRepository implements ReviewRepository {
  final List<ReviewDraft> drafts = [];
  final List<int> itemIds = [];
  DataState<int> result = const DataSuccess(9);
  Completer<void>? gate;

  @override
  Future<DataState<int>> create(int orderItemId, ReviewDraft draft) async {
    itemIds.add(orderItemId);
    drafts.add(draft);
    await gate?.future;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeOrderRepository orders;
  late _FakeReviewRepository reviews;

  setUp(() {
    orders = _FakeOrderRepository();
    reviews = _FakeReviewRepository();
    injector.registerSingleton<OrderRepository>(orders);
    injector.registerSingleton<ReviewRepository>(reviews);
  });

  tearDown(() async => injector.reset());

  ReviewFormCubit build() => ReviewFormCubit(orderId: 1, orderItemId: 7);

  test('pesanan completed membuka formulir dengan bintang 5', () async {
    final cubit = build();
    await cubit.load();

    final state = cubit.state as ReviewFormReady;
    expect(state.productName, 'Kopi Gayo');
    expect(state.rating, 5);
    await cubit.close();
  });

  test('pesanan belum selesai TIDAK membuka formulir', () async {
    orders.detail = DataSuccess(_order('delivered'));
    final cubit = build();
    await cubit.load();

    final state = cubit.state as ReviewFormError;
    // Kode yang sama dengan penolakan server, supaya pesannya menyebut
    // syarat "pesanan selesai", bukan "tidak ditemukan".
    expect(state.error.code, ApiErrorCode.orderItemNotFound);
    await cubit.close();
  });

  test('baris yang bukan milik pesanan ini ditolak', () async {
    final cubit = ReviewFormCubit(orderId: 1, orderItemId: 99);
    await cubit.load();

    expect((cubit.state as ReviewFormError).error.code, ApiErrorCode.orderNotFound);
    await cubit.close();
  });

  test('isian dikirim ke order item yang benar', () async {
    final cubit = build();
    await cubit.load();
    cubit
      ..setRating(4)
      ..setComment('  Wangi dan segar  ')
      ..setAnonymous(true);

    await cubit.submit();

    expect(reviews.itemIds, [7]);
    final json = reviews.drafts.single.toJson();
    expect(json['rating'], 4);
    expect(json['comment'], 'Wangi dan segar');
    expect(json['is_anonymous'], 1);
    expect(json.containsKey('media'), isFalse);
    expect((cubit.state as ReviewFormReady).submitted, isTrue);
    await cubit.close();
  });

  test('rating di luar 1–5 diabaikan', () async {
    final cubit = build();
    await cubit.load();
    cubit
      ..setRating(0)
      ..setRating(6);

    expect((cubit.state as ReviewFormReady).rating, 5);
    await cubit.close();
  });

  test('komentar dipotong di 500 karakter', () async {
    final cubit = build();
    await cubit.load();
    cubit.setComment('a' * 700);

    expect((cubit.state as ReviewFormReady).comment.length, ReviewFormCubit.maxCommentLength);
    await cubit.close();
  });

  test('ketukan kedua selagi mengirim diabaikan', () async {
    reviews.gate = Completer<void>();
    final cubit = build();
    await cubit.load();

    final first = cubit.submit();
    final second = cubit.submit();
    reviews.gate!.complete();
    await Future.wait([first, second]);

    expect(reviews.itemIds.length, 1);
    await cubit.close();
  });

  test('gagal mengirim mempertahankan isian', () async {
    reviews.result = const DataFailed(DataError(
      code: 'CLIENT_NETWORK',
      message: 'offline',
      kind: DataErrorKind.network,
    ));
    final cubit = build();
    await cubit.load();
    cubit.setComment('Mantap');

    await cubit.submit();

    final state = cubit.state as ReviewFormReady;
    expect(state.submitted, isFalse);
    expect(state.comment, 'Mantap');
    expect(state.submitError?.code, 'CLIENT_NETWORK');
    await cubit.close();
  });
}
