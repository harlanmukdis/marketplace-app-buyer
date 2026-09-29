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
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
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

  /// Kalau diisi, halaman ke-n diambil dari sini alih-alih [listResult].
  Map<int, DataState<List<OrderModel>>> pages = {};

  @override
  Future<DataState<List<OrderModel>>> fetchOrders({int page = 1}) async {
    requestedPages.add(page);
    return pages[page] ?? listResult;
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
  Future<DataState<OrderModel>> confirmDelivery(int id, {String? sealCode}) async {
    calls.add(sealCode == null ? 'confirmDelivery:$id' : 'confirmDelivery:$id:$sealCode');
    return detailResult;
  }

  DataState<OrderTrackingModel?> trackingResult = const DataSuccess(null);

  @override
  Future<DataState<OrderTrackingModel?>> fetchTracking(int id) async {
    calls.add('tracking:$id');
    return trackingResult;
  }

  @override
  Future<DataState<List<ShipmentEvidenceModel>>> fetchShipmentEvidence(int id) async =>
      const DataEmpty();

  @override
  Future<DataState<OrderInvoiceModel>> fetchInvoice(int id) async =>
      const DataSuccess(OrderInvoiceModel(invoiceNumber: 'INV-1'));

  @override
  Future<DataState<OrderModel>> respondPartialFulfillment(
      int id, PartialFulfillmentDecision decision) async {
    calls.add('partial:$id:${decision.code}');
    return detailResult;
  }

  final List<List<String>> refundEvidence = [];

  @override
  Future<DataState<OrderModel>> requestRefund(
    int id, {
    required String reason,
    List<String> evidenceUrls = const [],
  }) async {
    calls.add('refund:$id:$reason');
    refundEvidence.add(evidenceUrls);
    return detailResult;
  }

  // Pelengkap detail pesanan dari kontrak yang diusulkan. Dicatat terpisah
  // dari [calls] supaya urutan aksi status yang dipatok test lain tidak
  // ikut berubah.
  DataState<CancellationRequestModel?> cancellationResult = const DataSuccess(null);
  DataState<CancellationRequestModel> requestCancellationResult = const DataSuccess(
    CancellationRequestModel(id: 501, reason: 'wrong_address'),
    meta: {'mock': true},
  );
  DataState<InsurancePolicyModel?> insuranceResult = const DataSuccess(null);
  DataState<InsurancePolicyModel> optInResult =
      const DataSuccess(InsurancePolicyModel(id: 77, tier: 'secure_plus', premiumAmount: 460));
  final List<String> extraCalls = [];

  @override
  Future<DataState<CancellationRequestModel?>> fetchCancellationRequest(int id) async {
    extraCalls.add('cancellation:$id');
    return cancellationResult;
  }

  @override
  Future<DataState<CancellationRequestModel>> requestCancellation(
    int id, {
    required CancellationReason reason,
    String? note,
  }) async {
    extraCalls.add('requestCancellation:$id:${reason.code}:${note ?? ''}');
    return requestCancellationResult;
  }

  @override
  Future<DataState<InsurancePolicyModel?>> fetchInsurance(int id) async {
    extraCalls.add('insurance:$id');
    return insuranceResult;
  }

  @override
  Future<DataState<InsurancePolicyModel>> optInSecurePlus(int id) async {
    extraCalls.add('optIn:$id');
    return optInResult;
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

  group('OrderListCubit — tab status disaring di aplikasi', () {
    List<OrderModel> page(int start, String Function(int i) status) => List.generate(
          OrderService.serverPageSize,
          (i) => _order(id: start + i, status: status(i)),
        );

    test('tab menyaring halaman yang sudah dimuat', () async {
      orders.listResult = DataSuccess([
        _order(id: 1, status: 'pending'),
        _order(id: 2, status: 'shipped'),
        _order(id: 3, status: 'packed'),
        _order(id: 4, status: 'paid'),
      ]);
      final cubit = OrderListCubit();
      await cubit.load();

      await cubit.setFilter(OrderListFilter.processing);
      final state = cubit.state as OrderListLoaded;
      expect(state.visibleOrders.map((o) => o.id), [3, 4]);
      expect(state.orders.length, 4, reason: 'daftar mentah tidak ikut terpotong');
      await cubit.close();
    });

    test('tab yang tipis memuat halaman berikutnya sampai target', () async {
      // Halaman 1 penuh tanpa satu pun pesanan batal; halaman 2 berisi 12.
      orders.pages = {
        1: DataSuccess(page(1, (_) => 'completed')),
        2: DataSuccess(page(100, (i) => i < 12 ? 'cancelled' : 'completed')),
      };
      final cubit = OrderListCubit();
      await cubit.load();
      orders.requestedPages.clear();

      await cubit.setFilter(OrderListFilter.cancelled);

      final state = cubit.state as OrderListLoaded;
      expect(orders.requestedPages, [2]);
      expect(state.visibleOrders.length, 12);
      await cubit.close();
    });

    test('pemuatan otomatis berhenti di batas halaman', () async {
      // Server tak pernah kehabisan halaman dan tak pernah ada yang cocok.
      orders.listResult = DataSuccess(page(1, (_) => 'completed'));
      final cubit = OrderListCubit();
      await cubit.load();
      orders.requestedPages.clear();

      await cubit.setFilter(OrderListFilter.cancelled);

      expect(orders.requestedPages.length, OrderListCubit.maxAutoPages);
      final state = cubit.state as OrderListLoaded;
      expect(state.hasMore, isTrue, reason: 'tombol "Muat lebih banyak" tetap ada');
      expect(state.visibleOrders, isEmpty);
      await cubit.close();
    });

    test('pemuatan otomatis berhenti begitu halaman habis', () async {
      orders.pages = {
        1: DataSuccess(page(1, (_) => 'completed')),
        2: DataSuccess([_order(id: 500, status: 'cancelled')]),
      };
      final cubit = OrderListCubit();
      await cubit.load();
      orders.requestedPages.clear();

      await cubit.setFilter(OrderListFilter.cancelled);

      expect(orders.requestedPages, [2]);
      expect((cubit.state as OrderListLoaded).hasMore, isFalse);
      await cubit.close();
    });

    test('tab Semua tidak memicu pemuatan otomatis', () async {
      orders.listResult = DataSuccess(page(1, (_) => 'completed'));
      final cubit = OrderListCubit();
      await cubit.load();
      orders.requestedPages.clear();

      await cubit.setFilter(OrderListFilter.completed);
      await cubit.setFilter(OrderListFilter.all);

      expect(orders.requestedPages, isEmpty,
          reason: 'halaman 1 sudah berisi ≥ target untuk tab Selesai');
      await cubit.close();
    });

    test('tab bertahan melewati refresh', () async {
      orders.listResult = DataSuccess([
        _order(id: 1, status: 'pending'),
        _order(id: 2, status: 'completed'),
      ]);
      final cubit = OrderListCubit();
      await cubit.load();
      await cubit.setFilter(OrderListFilter.completed);

      await cubit.refresh();

      final state = cubit.state as OrderListLoaded;
      expect(state.filter, OrderListFilter.completed);
      expect(state.visibleOrders.map((o) => o.id), [2]);
      await cubit.close();
    });

    test('status refund hanya muncul di Semua', () {
      final refund = _order(status: 'refund_requested');
      for (final filter in OrderListFilter.values) {
        expect(filter.matches(refund), filter == OrderListFilter.all, reason: filter.name);
      }
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

    test('cancel juga sah untuk pesanan paid', () async {
      orders.detailResult = DataSuccess(_order(status: 'paid'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();

      await cubit.cancel(reason: 'Alamat salah');

      expect(orders.calls, contains('cancel:1'));
      await cubit.close();
    });

    test('confirmDelivery meneruskan kode segel Secure+', () async {
      orders.detailResult = DataSuccess(_order(status: 'shipped'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();

      await cubit.confirmDelivery(sealCode: 'AB12CD');

      expect(orders.calls, contains('confirmDelivery:1:AB12CD'));
      await cubit.close();
    });

    test('resi hanya diminta untuk pesanan yang sudah dikirim', () async {
      orders.detailResult = DataSuccess(_order(status: 'paid'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      expect(orders.calls.where((c) => c.startsWith('tracking')), isEmpty);

      orders.detailResult = DataSuccess(_order(status: 'shipped'));
      orders.trackingResult = const DataSuccess(
        OrderTrackingModel(courierCode: 'jne', awbNumber: 'JN123', status: 'in_transit'),
      );
      await cubit.load();

      final state = cubit.state as OrderDetailLoaded;
      expect(orders.calls, contains('tracking:1'));
      expect(state.tracking?.awbNumber, 'JN123');
      await cubit.close();
    });

    test('aksi sukses mempertahankan resi yang sudah termuat', () async {
      orders.detailResult = DataSuccess(_order(status: 'shipped'));
      orders.trackingResult = const DataSuccess(OrderTrackingModel(awbNumber: 'JN123'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();

      orders.detailResult = DataSuccess(_order(status: 'delivered'));
      await cubit.confirmDelivery();

      final state = cubit.state as OrderDetailLoaded;
      expect(state.order.status, OrderStatus.delivered);
      expect(state.tracking?.awbNumber, 'JN123');
      await cubit.close();
    });

    test('kegagalan resi tidak menggagalkan halaman', () async {
      orders.detailResult = DataSuccess(_order(status: 'shipped'));
      orders.trackingResult = DataFailed(_error('CLIENT_NETWORK'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();

      final state = cubit.state as OrderDetailLoaded;
      expect(state.tracking, isNull);
      await cubit.close();
    });

    test('komplain hanya sah sesudah barang diterima', () async {
      orders.detailResult = DataSuccess(_order(status: 'shipped'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();
      await cubit.requestRefund('Barang rusak: pecah');
      expect(orders.calls, isEmpty);

      orders.detailResult = DataSuccess(_order(status: 'delivered'));
      await cubit.load();
      orders.calls.clear();
      await cubit.requestRefund('Barang rusak: pecah');
      expect(orders.calls, contains('refund:1:Barang rusak: pecah'));
      await cubit.close();
    });

    test('jawaban kirim sebagian hanya sah selama usulannya menunggu', () async {
      orders.detailResult = DataSuccess(_order(status: 'paid'));
      final cubit = OrderDetailCubit(1);
      await cubit.load();
      orders.calls.clear();
      await cubit.respondPartialFulfillment(PartialFulfillmentDecision.cancelWhole);
      expect(orders.calls, isEmpty);

      orders.detailResult = DataSuccess(_order(status: 'paid').copyWith(
        partialFulfillmentProposedAt: DateTime.utc(2026, 9, 16),
      ));
      await cubit.load();
      orders.calls.clear();
      await cubit.respondPartialFulfillment(PartialFulfillmentDecision.cancelWhole);
      expect(orders.calls, contains('partial:1:cancel_whole'));
      await cubit.close();
    });

    test('cancel tidak sah sesudah dikirim', () async {
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
