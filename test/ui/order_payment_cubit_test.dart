/// Perilaku [OrderListCubit], [OrderDetailCubit], dan [PaymentCubit].
///
/// Yang paling penting di sini: **aksi status disaring di aplikasi**, karena
/// `POST /orders/{id}/complete` membalas halaman HTML berstatus 200 kalau
/// transisinya tidak sah — pesan yang tidak bisa dijelaskan ke user.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/payment_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_list_cubit.dart';
import 'package:marketplace_app_member/ui/main/payment/cubit/payment_cubit.dart';

OrderModel _order({int id = 1, String status = 'pending'}) =>
    OrderModel(id: id, statusCode: status, grandTotal: 92000);

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeOrderRepository implements OrderRepository {
  DataState<List<OrderModel>> listResult = DataSuccess([_order()]);
  DataState<OrderModel> detailResult = DataSuccess(_order());

  final List<String> calls = [];
  final List<int> requestedPages = [];

  @override
  Future<DataState<List<OrderModel>>> fetchOrders({int page = 1}) async {
    requestedPages.add(page);
    return listResult;
  }

  @override
  Future<DataState<OrderModel>> fetchOrder(int id) async {
    calls.add('fetch:$id');
    return detailResult;
  }

  @override
  Future<DataState<OrderModel>> cancel(int id, {String? reason}) async {
    calls.add('cancel:$id');
    return detailResult;
  }

  @override
  Future<DataState<OrderModel>> confirmDelivery(int id) async {
    calls.add('confirmDelivery:$id');
    return detailResult;
  }

  @override
  Future<DataState<OrderModel>> complete(int id) async {
    calls.add('complete:$id');
    return detailResult;
  }
}

class _FakePaymentRepository implements PaymentRepository {
  DataState<PaymentSnapshot> loadResult = const DataSuccess(
    PaymentSnapshot(
      payment: PaymentModel(id: 9, status: 'pending', amount: 92000),
      instruction: PaymentInstructionModel(qrString: 'QR-123'),
    ),
  );
  DataState<PaymentSnapshot> statusResult = const DataSuccess(
    PaymentSnapshot(
      payment: PaymentModel(id: 9, status: 'paid', amount: 92000),
    ),
  );

  final List<String> calls = [];

  @override
  Future<DataState<List<PaymentMethodModel>>> fetchMethods() async =>
      const DataSuccess([PaymentMethodModel(code: 'qris', name: 'QRIS')]);

  @override
  Future<DataState<PaymentSnapshot>> load(int txId) async {
    calls.add('load:$txId');
    return loadResult;
  }

  @override
  Future<DataState<PaymentSnapshot>> refreshStatus(int txId) async {
    calls.add('status:$txId');
    return statusResult;
  }
}

void main() {
  late _FakeOrderRepository orders;
  late _FakePaymentRepository payments;

  setUp(() {
    orders = _FakeOrderRepository();
    payments = _FakePaymentRepository();
    injector.registerSingleton<OrderRepository>(orders);
    injector.registerSingleton<PaymentRepository>(payments);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('OrderListCubit — paginasi tanpa meta', () {
    test('halaman terisi PENUH dianggap masih ada lanjutannya', () async {
      // Server tidak mengirim total, jadi ini satu-satunya petunjuk.
      orders.listResult = DataSuccess(
        List.generate(OrderService.serverPageSize, (i) => _order(id: i + 1)),
      );
      final cubit = OrderListCubit();
      await cubit.load();

      expect((cubit.state as OrderListLoaded).hasMore, isTrue);
      await cubit.close();
    });

    test('halaman yang belum penuh berarti sudah habis', () async {
      orders.listResult = DataSuccess([_order()]);
      final cubit = OrderListCubit();
      await cubit.load();

      expect((cubit.state as OrderListLoaded).hasMore, isFalse);
      await cubit.close();
    });

    test('loadMore menambahkan halaman berikutnya', () async {
      orders.listResult = DataSuccess(
        List.generate(OrderService.serverPageSize, (i) => _order(id: i + 1)),
      );
      final cubit = OrderListCubit();
      await cubit.load();
      await cubit.loadMore();

      final state = cubit.state as OrderListLoaded;
      expect(state.page, 2);
      expect(orders.requestedPages, [1, 2]);
      expect(state.orders.length, OrderService.serverPageSize * 2);
      await cubit.close();
    });

    test('loadMore diabaikan kalau sudah habis', () async {
      orders.listResult = DataSuccess([_order()]);
      final cubit = OrderListCubit();
      await cubit.load();
      orders.requestedPages.clear();

      await cubit.loadMore();

      expect(orders.requestedPages, isEmpty);
      await cubit.close();
    });

    test('daftar kosong jadi OrderListEmpty', () async {
      orders.listResult = const DataEmpty();
      final cubit = OrderListCubit();
      await cubit.load();

      expect(cubit.state, isA<OrderListEmpty>());
      await cubit.close();
    });
  });

  group('OrderDetailCubit — aksi disaring status', () {
    test('complete pada pesanan pending TIDAK menyentuh jaringan', () async {
      // Penjaga terpenting: endpoint /complete membalas HTML 200 untuk
      // transisi tidak sah, yang sampai ke app sebagai CLIENT_BAD_RESPONSE.
      orders.detailResult = DataSuccess(_order(status: 'pending'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();

      await cubit.complete();

      expect(orders.calls, isEmpty);
      expect((cubit.state as OrderDetailLoaded).actionError?.code,
          ApiErrorCode.invalidTransition);
      await cubit.close();
    });

    test('complete pada pesanan delivered dikirim ke server', () async {
      orders.detailResult = DataSuccess(_order(status: 'delivered'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();

      await cubit.complete();

      expect(orders.calls, contains('complete:1'));
      await cubit.close();
    });

    test('confirmDelivery hanya sah dari status shipped', () async {
      orders.detailResult = DataSuccess(_order(status: 'paid'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();

      await cubit.confirmDelivery();
      expect(orders.calls, isEmpty);

      orders.detailResult = DataSuccess(_order(status: 'shipped'));
      await cubit.load();
      orders.calls.clear();
      await cubit.confirmDelivery();
      expect(orders.calls, contains('confirmDelivery:1'));
      await cubit.close();
    });

    test('cancel hanya sah selagi pending', () async {
      orders.detailResult = DataSuccess(_order(status: 'shipped'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();

      await cubit.cancel();

      expect(orders.calls, isEmpty);
      await cubit.close();
    });

    test('aksi gagal mempertahankan pesanan yang sudah tampil', () async {
      orders.detailResult = DataSuccess(_order(status: 'pending'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.detailResult = DataFailed(_error('NETWORK'));

      await cubit.cancel();

      final state = cubit.state as OrderDetailLoaded;
      expect(state.order.id, 1);
      expect(state.actionError?.code, 'NETWORK');
      await cubit.close();
    });
  });

  group('PaymentCubit', () {
    test('load membawa transaksi beserta instruksinya', () async {
      final cubit = PaymentCubit(9);
      await cubit.load();

      final state = cubit.state as PaymentReady;
      expect(state.snapshot.instruction?.kind, PaymentInstructionKind.qris);
      expect(state.snapshot.payment.isPending, isTrue);
      await cubit.close();
    });

    test('cek status MEMPERTAHANKAN instruksi yang sudah tampil', () async {
      // `refreshStatus` sengaja tidak mengambil instruksi lagi; tanpa
      // penjagaan ini, QR/VA akan hilang dari layar setelah user menekan
      // "cek status".
      final cubit = PaymentCubit(9);
      await cubit.load();

      await cubit.checkStatus();

      final state = cubit.state as PaymentReady;
      expect(state.snapshot.payment.isPaid, isTrue);
      expect(state.snapshot.instruction?.qrString, 'QR-123');
      await cubit.close();
    });

    test('cek status kedua diabaikan selagi yang pertama berjalan', () async {
      final cubit = PaymentCubit(9);
      await cubit.load();
      payments.calls.clear();

      final first = cubit.checkStatus();
      final second = cubit.checkStatus();
      await Future.wait([first, second]);

      expect(payments.calls.where((c) => c.startsWith('status:')).length, 1);
      await cubit.close();
    });
  });
}
