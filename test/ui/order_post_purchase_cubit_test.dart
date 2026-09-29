/// Cubit pasca-beli yang memakai kontrak baru: permohonan pembatalan dan
/// Secure+ di detail pesanan, unggah bukti komplain, "Ulasan Saya", dan mode
/// ubah di formulir ulasan.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/media_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/complaint_evidence_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/my_reviews_cubit.dart';
import 'package:marketplace_app_member/ui/main/review/cubit/review_form_cubit.dart';

const _routeNotFound = DataError(
  code: 'CLIENT_BAD_RESPONSE',
  message: 'html',
  statusCode: 404,
  kind: DataErrorKind.server,
);

class _Orders implements OrderRepository {
  DataState<OrderModel> detail = const DataSuccess(OrderModel(id: 1, statusCode: 'packed'));
  DataState<CancellationRequestModel?> cancellation =
      const DataSuccess(null, meta: {'mock': true});
  DataState<InsurancePolicyModel?> insurance = const DataSuccess(null, meta: {'mock': true});
  final List<String> calls = [];

  @override
  Future<DataState<OrderModel>> fetchOrder(int id) async => detail;
  @override
  Future<DataState<OrderTrackingModel?>> fetchTracking(int id) async => const DataSuccess(null);
  @override
  Future<DataState<List<ShipmentEvidenceModel>>> fetchShipmentEvidence(int id) async =>
      const DataEmpty();
  @override
  Future<DataState<CancellationRequestModel?>> fetchCancellationRequest(int id) async {
    calls.add('getCancellation');
    return cancellation;
  }

  @override
  Future<DataState<CancellationRequestModel>> requestCancellation(
    int id, {
    required CancellationReason reason,
    String? note,
  }) async {
    calls.add('request:${reason.code}:${note ?? ''}');
    return DataSuccess(CancellationRequestModel(id: 9, reason: reason.code, note: note),
        meta: const {'mock': true});
  }

  @override
  Future<DataState<InsurancePolicyModel?>> fetchInsurance(int id) async {
    calls.add('getInsurance');
    return insurance;
  }

  @override
  Future<DataState<InsurancePolicyModel>> optInSecurePlus(int id) async {
    calls.add('optIn');
    return const DataSuccess(InsurancePolicyModel(id: 3, tier: 'secure_plus', premiumAmount: 500));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Media implements MediaRepository {
  final List<String> started = [];
  final Map<String, Completer<DataState<MediaUploadModel>>> pending = {};
  DataState<MediaUploadModel> Function(String name)? immediate;

  @override
  Future<DataState<MediaUploadModel>> upload({
    required List<int> bytes,
    required String fileName,
    String? mimeType,
    String? context,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
  }) {
    started.add(fileName);
    final now = immediate;
    if (now != null) return Future.value(now(fileName));
    return (pending[fileName] = Completer()).future;
  }
}

class _Reviews implements ReviewRepository {
  DataState<List<MyReviewModel>> Function(int page) mine =
      (_) => const DataEmpty(meta: {'mock': true});
  final List<String> calls = [];

  @override
  Future<DataState<List<MyReviewModel>>> fetchMine({int page = 1}) async => mine(page);

  @override
  Future<DataState<MyReviewModel>> update(int reviewId, ReviewUpdateDraft draft) async {
    calls.add('update:$reviewId:${draft.rating}:${draft.comment}');
    return DataSuccess(_review(reviewId).copyWith(rating: draft.rating, comment: draft.comment));
  }

  @override
  Future<DataState<int>> create(int orderItemId, ReviewDraft draft) async {
    calls.add('create:$orderItemId');
    return const DataSuccess(1);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

MyReviewModel _review(int id, {bool editable = true}) => MyReviewModel(
      id: id,
      orderId: 1,
      orderItemId: 7,
      productName: 'Produk $id',
      rating: 4,
      comment: 'Lama',
      isEditable: editable,
      editableUntil: DateTime.now().toUtc().add(Duration(days: editable ? 10 : -1)),
    );

PickedEvidence _file(String name, {int size = 10}) =>
    PickedEvidence(name: name, bytes: Uint8List(size));

void main() {
  late _Orders orders;
  late _Reviews reviews;

  setUp(() {
    orders = _Orders();
    reviews = _Reviews();
    injector
      ..registerSingleton<OrderRepository>(orders)
      ..registerSingleton<ReviewRepository>(reviews);
  });

  tearDown(() async => injector.reset());

  group('OrderDetailCubit — permohonan pembatalan & Secure+', () {
    test('packed: memuat permohonan (null) dan status polis', () async {
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      final state = cubit.state as OrderDetailLoaded;
      expect(state.cancellationRequest, isNull);
      expect(state.cancellationSupported, isTrue);
      expect(state.cancellationMeta['mock'], isTrue);
      expect(state.insuranceKnown, isTrue);
    });

    test('rute belum ada → cancellationSupported false, bukan error', () async {
      orders.cancellation = const DataFailed(_routeNotFound);
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      final state = cubit.state as OrderDetailLoaded;
      expect(state.cancellationSupported, isFalse);
      expect(state.actionError, isNull);
    });

    test('mengajukan sekali; ketukan kedua diabaikan', () async {
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      await cubit.requestCancellation(CancellationReason.wrongVariant, note: 'Ukuran');
      await cubit.requestCancellation(CancellationReason.other);
      final state = cubit.state as OrderDetailLoaded;
      expect(state.cancellationRequest!.reason, 'wrong_variant');
      expect(orders.calls.where((c) => c.startsWith('request:')), ['request:wrong_variant:Ukuran']);
    });

    test('status paid tidak boleh mengajukan permohonan', () async {
      orders.detail = const DataSuccess(OrderModel(id: 1, statusCode: 'paid'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      expect(orders.calls, isNot(contains('getCancellation')));
      await cubit.requestCancellation(CancellationReason.other);
      expect((cubit.state as OrderDetailLoaded).actionError, isNotNull);
      expect(orders.calls.where((c) => c.startsWith('request:')), isEmpty);
    });

    test('opt-in Secure+ hanya untuk pending/paid, sekali', () async {
      orders.detail = const DataSuccess(OrderModel(id: 1, statusCode: 'paid', grandTotal: 100000));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      await cubit.optInSecurePlus();
      expect((cubit.state as OrderDetailLoaded).insurance!.isSecurePlus, isTrue);
      await cubit.optInSecurePlus();
      expect(orders.calls.where((c) => c == 'optIn'), hasLength(1));
    });

    test('opt-in ditolak aplikasi untuk pesanan yang sudah dikemas', () async {
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      await cubit.optInSecurePlus();
      expect(orders.calls, isNot(contains('optIn')));
      expect((cubit.state as OrderDetailLoaded).actionError, isNotNull);
    });
  });

  group('ComplaintEvidenceCubit', () {
    test('validasi format, ukuran, dan jumlah — tanpa menyentuh jaringan', () async {
      final media = _Media()..immediate = (n) => DataSuccess(MediaUploadModel(url: 'u/$n'));
      final cubit = ComplaintEvidenceCubit(repository: media);
      cubit.addFiles([
        _file('a.jpg'),
        _file('b.pdf'),
        _file('c.mp4', size: ComplaintEvidenceCubit.maxBytes + 1),
        _file('d.PNG'),
        _file('e.webm'),
        _file('f.mov'),
        _file('g.jpeg'),
        _file('h.jpg'),
      ]);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.items.map((i) => i.fileName),
          ['a.jpg', 'd.PNG', 'e.webm', 'f.mov', 'g.jpeg']);
      final message = cubit.state.pickError!.message;
      expect(message, contains('b.pdf: format tidak didukung'));
      expect(message, contains('c.mp4: lebih dari 10 MB'));
      expect(message, contains('h.jpg: maksimal 5 berkas'));
      expect(cubit.state.pickError!.code, ClientErrorCode.localValidation);
      expect(cubit.state.isFull, isTrue);
      await cubit.close();
    });

    test('nama tanpa ekstensi dilengkapi dari MIME', () {
      final cubit = ComplaintEvidenceCubit(repository: _Media());
      cubit.addFiles([PickedEvidence(name: 'image_picker_123', bytes: Uint8List(1), mimeType: 'image/png')]);
      expect(cubit.state.items.single.fileName, 'image_picker_123.png');
      expect(cubit.state.items.single.mimeType, 'image/png');
    });

    test('unggah berurutan, satu per satu', () async {
      final media = _Media();
      final cubit = ComplaintEvidenceCubit(repository: media);
      cubit.addFiles([_file('a.jpg'), _file('b.jpg')]);
      await Future<void>.delayed(Duration.zero);
      expect(media.started, ['a.jpg'], reason: 'php -S single-threaded');
      expect(cubit.state.isSettled, isFalse);

      media.pending['a.jpg']!.complete(const DataSuccess(MediaUploadModel(url: 'u/a')));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(media.started, ['a.jpg', 'b.jpg']);
      media.pending['b.jpg']!.complete(const DataSuccess(MediaUploadModel(url: 'u/b')));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isSettled, isTrue);
      expect(cubit.state.uploadedUrls, ['u/a', 'u/b']);
    });

    test('gagal → belum settled; ulangi atau hapus menyelesaikannya', () async {
      var fail = true;
      final media = _Media()
        ..immediate = (n) => fail
            ? const DataFailed(DataError(code: 'UPLOAD_FAILED', message: 'x', kind: DataErrorKind.api))
            : DataSuccess(MediaUploadModel(url: 'u/$n'));
      final cubit = ComplaintEvidenceCubit(repository: media);
      cubit.addFiles([_file('a.jpg'), _file('b.jpg')]);
      for (var i = 0; i < 6; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(cubit.state.hasFailed, isTrue);
      expect(cubit.state.isSettled, isFalse);

      fail = false;
      final first = cubit.state.items.first.localId;
      cubit.retry(first);
      for (var i = 0; i < 6; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      cubit.remove(cubit.state.items.last.localId);
      expect(cubit.state.isSettled, isTrue);
      expect(cubit.state.uploadedUrls, ['u/a.jpg']);
    });
  });

  group('MyReviewsCubit', () {
    test('kosong, belum didukung, dan halaman berikutnya dari meta.total', () async {
      final cubit = MyReviewsCubit();
      await cubit.load();
      expect(cubit.state, isA<MyReviewsEmpty>());

      reviews.mine = (_) => const DataFailed(_routeNotFound);
      await cubit.load();
      expect(cubit.state, isA<MyReviewsUnsupported>());

      reviews.mine = (page) => DataSuccess(
            page == 1 ? [_review(1), _review(2)] : [_review(2), _review(3)],
            meta: const {'total': 3, 'mock': true},
          );
      await cubit.load();
      expect((cubit.state as MyReviewsLoaded).hasMore, isTrue);
      await cubit.loadMore();
      final loaded = cubit.state as MyReviewsLoaded;
      expect(loaded.reviews.map((r) => r.id), [1, 2, 3], reason: 'baris berulang dibuang');
      expect(loaded.hasMore, isFalse);

      cubit.replace(_review(2).copyWith(rating: 1));
      expect((cubit.state as MyReviewsLoaded).reviews[1].rating, 1);
    });
  });

  group('ReviewFormCubit — mode ubah', () {
    test('terisi dari ulasan lama dan mengirim PATCH, bukan POST', () async {
      final cubit = ReviewFormCubit(orderId: 1, orderItemId: 7, existing: _review(5));
      await cubit.load();
      final ready = cubit.state as ReviewFormReady;
      expect(ready.isEditing, isTrue);
      expect(ready.rating, 4);
      expect(ready.comment, 'Lama');

      cubit
        ..setRating(2)
        ..setComment('Baru');
      await cubit.submit();
      expect(reviews.calls, ['update:5:2:Baru']);
      final done = cubit.state as ReviewFormReady;
      expect(done.submitted, isTrue);
      expect(done.updated!.rating, 2);
    });

    test('lewat 30 hari → error tanpa formulir', () async {
      final cubit =
          ReviewFormCubit(orderId: 1, orderItemId: 7, existing: _review(5, editable: false));
      await cubit.load();
      expect((cubit.state as ReviewFormError).error.code, 'REVIEW_EDIT_WINDOW_CLOSED');
    });
  });
}
