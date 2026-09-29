/// Uji asap layar pasca-beli: daftar, detail, lacak, invoice, batal,
/// komplain, dan formulir ulasan — dipompa di atas repository palsu, supaya
/// overflow tata letak atau provider yang hilang ketahuan sebelum sampai ke
/// perangkat.
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
import 'package:marketplace_app_member/core/domain/model/review/review_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:dio/dio.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/media_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/complaint_evidence_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_cancel_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_complaint_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_detail_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_invoice_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_list_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_tracking_screen.dart';
import 'package:marketplace_app_member/ui/main/review/screens/review_form_screen.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _history = [
  OrderStatusHistoryModel(id: 1, toStatus: 'pending', createdAt: DateTime.utc(2026, 9, 15, 2)),
  OrderStatusHistoryModel(id: 2, toStatus: 'paid', createdAt: DateTime.utc(2026, 9, 15, 3)),
  OrderStatusHistoryModel(id: 3, toStatus: 'packed', createdAt: DateTime.utc(2026, 9, 16, 3)),
  OrderStatusHistoryModel(id: 4, toStatus: 'shipped', createdAt: DateTime.utc(2026, 9, 16, 9)),
];

OrderModel _order(String status, {bool custom = false, bool partial = false}) => OrderModel(
      id: 1,
      orderNumber: 'ORD-UW6RM272MR',
      storeId: 7,
      statusCode: status,
      subtotal: 150000,
      shippingCost: 17000,
      grandTotal: 167000,
      courierCode: 'jne',
      courierService: 'reg',
      trackingNumber: status == 'shipped' ? 'JN1234567890' : null,
      requiresCustomConfirmation: custom,
      partialFulfillmentProposedAt: partial ? DateTime.utc(2026, 9, 16) : null,
      paymentDeadline: DateTime.utc(2099),
      createdAt: DateTime.utc(2026, 9, 15, 2),
      shippingAddress: const OrderShippingAddress(
        recipientName: 'Budi',
        phone: '081234567890',
        fullAddress: 'Jl. Melati 10',
        city: 'Bandung',
        province: 'Jawa Barat',
        postalCode: '40111',
      ),
      items: [
        const OrderItemModel(
          id: 7,
          productName: 'Kopi Arabika Gayo 250g dengan nama yang cukup panjang sekali',
          variantOptions: {'ukuran': '250g'},
          price: 75000,
          quantity: 2,
          subtotal: 150000,
        ),
        if (partial)
          const OrderItemModel(id: 8, productName: 'Filter Kertas', isAvailable: false),
      ],
      statusHistory: _history,
    );

class _FakeOrders implements OrderRepository {
  DataState<OrderModel> detail = DataSuccess(_order('pending'));
  DataState<List<OrderModel>> list = DataSuccess([
    _order('pending'),
    _order('shipped').copyWith(id: 2),
    _order('completed').copyWith(id: 3),
    _order('cancelled').copyWith(id: 4),
  ]);
  DataState<OrderTrackingModel?> tracking = const DataSuccess(null);
  DataState<OrderInvoiceModel> invoice = const DataFailed(DataError(
    code: ApiErrorCode.invoiceNotAvailable,
    message: 'x',
    kind: DataErrorKind.api,
  ));

  @override
  Future<DataState<List<OrderModel>>> fetchOrders({int page = 1}) async => list;
  @override
  Future<DataState<OrderModel>> fetchOrder(int id) async => detail;
  @override
  Future<DataState<OrderTrackingModel?>> fetchTracking(int id) async => tracking;
  @override
  Future<DataState<List<ShipmentEvidenceModel>>> fetchShipmentEvidence(int id) async =>
      const DataSuccess([ShipmentEvidenceModel(id: 1, url: '')]);
  @override
  Future<DataState<OrderInvoiceModel>> fetchInvoice(int id) async => invoice;

  DataState<CancellationRequestModel?> cancellation = const DataSuccess(null, meta: {'mock': true});
  DataState<InsurancePolicyModel?> insurance = const DataSuccess(null, meta: {'mock': true});
  final List<String> refunds = [];
  final List<List<String>> refundEvidence = [];

  @override
  Future<DataState<CancellationRequestModel?>> fetchCancellationRequest(int id) async =>
      cancellation;
  @override
  Future<DataState<InsurancePolicyModel?>> fetchInsurance(int id) async => insurance;
  @override
  Future<DataState<CancellationRequestModel>> requestCancellation(
    int id, {
    required CancellationReason reason,
    String? note,
  }) async =>
      DataSuccess(CancellationRequestModel(id: 1, reason: reason.code, note: note),
          meta: const {'mock': true});
  @override
  Future<DataState<InsurancePolicyModel>> optInSecurePlus(int id) async =>
      const DataSuccess(InsurancePolicyModel(id: 1, tier: 'secure_plus', premiumAmount: 835));
  @override
  Future<DataState<OrderModel>> requestRefund(
    int id, {
    required String reason,
    List<String> evidenceUrls = const [],
  }) async {
    refunds.add(reason);
    refundEvidence.add(evidenceUrls);
    return DataSuccess(_order('refund_requested'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStores implements StoreRepository {
  @override
  Future<DataState<StoreModel>> fetchStore(int id) async =>
      DataSuccess(StoreModel(id: id, name: 'Toko Kopi Gayo', primaryStatus: 'official_store'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCart implements CartRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReviews implements ReviewRepository {
  @override
  Future<DataState<int>> create(int orderItemId, ReviewDraft draft) async =>
      const DataSuccess(1);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMedia implements MediaRepository {
  final List<String> uploaded = [];

  @override
  Future<DataState<MediaUploadModel>> upload({
    required List<int> bytes,
    required String fileName,
    String? mimeType,
    String? context,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
  }) async {
    uploaded.add(fileName);
    onProgress?.call(1);
    return DataSuccess(MediaUploadModel(
      url: 'http://localhost:8080/marketplace-api/uploads/$fileName',
      fileName: fileName,
      mimeType: mimeType ?? '',
    ));
  }
}

/// PNG 1x1 transparan, supaya `Image.memory` bisa mendekode pratinjau.
final _png = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

Future<void> _pump(WidgetTester tester, Widget screen, {bool withRouter = false}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  const delegates = <LocalizationsDelegate<dynamic>>[
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  // Dengan router: layar didorong di atas halaman kosong, supaya
  // `context.pop(true)` sesudah sukses punya tempat kembali.
  final router = withRouter
      ? GoRouter(
          initialLocation: '/screen',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => const Scaffold(body: Text('ASAL')),
              routes: [GoRoute(path: 'screen', builder: (_, __) => screen)],
            ),
          ],
        )
      : null;
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StoreDirectoryCubit()),
        BlocProvider(create: (_) => CartBadgeCubit()),
      ],
      child: router != null
          ? MaterialApp.router(
              localizationsDelegates: delegates,
              supportedLocales: S.delegate.supportedLocales,
              routerConfig: router,
            )
          : MaterialApp(
              localizationsDelegates: delegates,
              supportedLocales: S.delegate.supportedLocales,
              home: screen,
            ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  late _FakeOrders orders;
  late _FakeMedia media;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    orders = _FakeOrders();
    media = _FakeMedia();
    injector
      ..registerSingleton<MediaRepository>(media)
      ..registerSingleton<OrderRepository>(orders)
      ..registerSingleton<StoreRepository>(_FakeStores())
      ..registerSingleton<CartRepository>(_FakeCart())
      ..registerSingleton<ReviewRepository>(_FakeReviews());
  });

  tearDown(() async => injector.reset());

  testWidgets('daftar: tab, nomor pesanan, dan label status', (tester) async {
    await _pump(tester, OrderListScreen(onLogoTap: () {}));

    expect(find.text('Pesanan Saya'), findsOneWidget);
    expect(find.textContaining('ORD-'), findsWidgets);
    // Label tab dan pil status sama-sama "Menunggu Pembayaran".
    expect(find.text('Menunggu Pembayaran'), findsWidgets);
    expect(find.text('Bayar Sekarang'), findsOneWidget);
    expect(find.textContaining('Toko Kopi Gayo'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Lacak Paket'), 200,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('Lacak Paket'), findsOneWidget);

    final tabs = find.byType(Scrollable).first;
    final cancelledTab = find.descendant(of: tabs, matching: find.text('Dibatalkan'));
    await tester.drag(tabs, const Offset(-800, 0));
    await tester.pumpAndSettle();
    await tester.tap(cancelledTab);
    await tester.pump();
    expect(find.text('Lacak Paket'), findsNothing);
    expect(find.text('Bayar Sekarang'), findsNothing);
    expect(find.text('Lihat Detail'), findsOneWidget, reason: 'hanya kartu yang dibatalkan');
  });

  for (final status in ['pending', 'paid', 'packed', 'shipped', 'delivered', 'completed', 'cancelled']) {
    testWidgets('detail $status merender tanpa error', (tester) async {
      orders.detail = DataSuccess(_order(status));
      await _pump(tester, const OrderDetailScreen(orderId: 1));
      expect(find.text('Detail Pesanan'), findsOneWidget);
      expect(find.text('ORD-UW6RM272MR'), findsOneWidget);
      // Menggulir ke dasar supaya seksi bawah (bukti, biaya, riwayat) ikut
      // dirender dan diperiksa.
      await tester.scrollUntilVisible(find.textContaining('Xpedia 911, siap'), 400,
          scrollable: find.byType(Scrollable).first);
      expect(find.textContaining('Xpedia 911'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('detail custom order: 6 tahap dan banner 48 jam', (tester) async {
    orders.detail = DataSuccess(_order('paid', custom: true));
    await _pump(tester, const OrderDetailScreen(orderId: 1));
    expect(find.text('Menunggu Konfirmasi'), findsWidgets);
    expect(find.textContaining('48 jam'), findsOneWidget);
  });

  testWidgets('detail kirim sebagian menawarkan dua pilihan', (tester) async {
    orders.detail = DataSuccess(_order('paid', partial: true));
    await _pump(tester, const OrderDetailScreen(orderId: 1));
    expect(find.text('Lanjutkan Kirim Sebagian'), findsOneWidget);
    expect(find.text('Batalkan Seluruh Pesanan'), findsOneWidget);
  });

  testWidgets('detail selesai: Beri Ulasan per barang dan invoice', (tester) async {
    orders.detail = DataSuccess(_order('completed'));
    await _pump(tester, const OrderDetailScreen(orderId: 1));
    expect(find.text('Invoice Pesanan'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Beri Ulasan'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Beri Ulasan'), findsOneWidget);
    expect(find.text('Ajukan Komplain'), findsOneWidget);
  });

  testWidgets('lacak tanpa resi', (tester) async {
    orders.detail = DataSuccess(_order('paid'));
    await _pump(tester, const OrderTrackingScreen(orderId: 1));
    expect(find.text('Resi belum dibuat penjual'), findsOneWidget);
  });

  testWidgets('lacak dengan resi', (tester) async {
    orders.detail = DataSuccess(_order('shipped'));
    orders.tracking = DataSuccess(OrderTrackingModel(
      courierCode: 'jne',
      serviceType: 'reg',
      awbNumber: 'JN1234567890',
      status: 'in_transit',
      shippedAt: DateTime.utc(2026, 9, 16, 9),
    ));
    await _pump(tester, const OrderTrackingScreen(orderId: 1));
    expect(find.text('JN1234567890'), findsOneWidget);
    expect(find.text('Dalam perjalanan'), findsOneWidget);
    expect(find.text('Paket diserahkan ke kurir'), findsOneWidget);
  });

  testWidgets('invoice belum tersedia', (tester) async {
    await _pump(tester, const OrderInvoiceScreen(orderId: 1));
    expect(find.text('Invoice belum tersedia'), findsOneWidget);
  });

  testWidgets('invoice lunas', (tester) async {
    orders.invoice = DataSuccess(OrderInvoiceModel(
      invoiceNumber: 'INV20260916-000001',
      orderNumber: 'ORD-UW6RM272MR',
      store: const InvoiceStoreModel(id: 7, name: 'Toko Kopi Gayo'),
      items: _order('completed').items,
      subtotal: 150000,
      shippingCost: 17000,
      grandTotal: 167000,
    ));
    await _pump(tester, const OrderInvoiceScreen(orderId: 1));
    expect(find.text('INV20260916-000001'), findsOneWidget);
    expect(find.text('Lunas'), findsOneWidget);
  });

  testWidgets('batal: pesanan paid menjanjikan dana kembali ke Wallet', (tester) async {
    orders.detail = DataSuccess(_order('paid'));
    await _pump(tester, const OrderCancelScreen(orderId: 1));
    await tester.scrollUntilVisible(find.text('Dana kembali 100% ke Xpedia Wallet'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Dana kembali 100% ke Xpedia Wallet'), findsOneWidget);
  });

  testWidgets('batal: pesanan pending dibatalkan tanpa biaya', (tester) async {
    await _pump(tester, const OrderCancelScreen(orderId: 1));
    await tester.scrollUntilVisible(find.text('Pesanan dibatalkan tanpa biaya'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Pesanan dibatalkan tanpa biaya'), findsOneWidget);
    expect(find.text('Dana kembali 100% ke Xpedia Wallet'), findsNothing);
  });

  testWidgets('batal: pesanan packed menawarkan Ajukan Pembatalan (mock)', (tester) async {
    orders.detail = DataSuccess(_order('packed'));
    await _pump(tester, const OrderCancelScreen(orderId: 1));
    expect(find.text('Ajukan Pembatalan'), findsOneWidget, reason: 'judul app bar');
    expect(find.text('Pesanan sudah diproses penjual'), findsOneWidget, reason: 'banner peringatan');
    expect(find.text('Simulasi'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Estimasi terlalu lama'), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Alamat salah'), findsOneWidget);
    expect(find.text('Kirim Permohonan'), findsOneWidget);

    await tester.tap(find.text('Kirim Permohonan'));
    await tester.pumpAndSettle();
    expect(find.text('Kirim Permohonan?'), findsOneWidget);
    expect(find.text('Ya, Ajukan Pembatalan'), findsOneWidget);
  });

  testWidgets('batal: tanpa endpoint permohonan, kembali ke penjelasan', (tester) async {
    orders.detail = DataSuccess(_order('packed'));
    orders.cancellation = const DataFailed(DataError(
      code: 'CLIENT_BAD_RESPONSE',
      message: 'html',
      statusCode: 404,
      kind: DataErrorKind.server,
    ));
    await _pump(tester, const OrderCancelScreen(orderId: 1));
    expect(find.text('Pesanan sudah diproses penjual'), findsOneWidget);
    expect(find.text('Kirim Permohonan'), findsNothing);
    expect(find.text('Hubungi Xpedia 911'), findsOneWidget);
  });

  testWidgets('detail: status permohonan pembatalan tampil dengan lencana Simulasi',
      (tester) async {
    orders.detail = DataSuccess(_order('shipped'));
    orders.cancellation = DataSuccess(
      CancellationRequestModel(
        id: 5,
        statusCode: 'rejected',
        reason: 'eta_too_long',
        rejectionReason: 'Paket sudah di kurir',
        createdAt: DateTime.utc(2026, 9, 16, 10),
      ),
      meta: const {'mock': true},
    );
    await _pump(tester, const OrderDetailScreen(orderId: 1));
    expect(find.text('Permohonan Pembatalan'), findsOneWidget);
    expect(find.text('Ditolak Penjual'), findsOneWidget);
    expect(find.text('Estimasi terlalu lama'), findsOneWidget);
    expect(find.textContaining('Paket sudah di kurir'), findsOneWidget);
    expect(find.text('Simulasi'), findsWidgets);
    expect(find.text('Ajukan Pembatalan'), findsNothing, reason: 'satu pesanan satu permohonan');
  });

  testWidgets('detail: Bayar Sekarang muncul kalau id transaksi diketahui', (tester) async {
    orders.detail = DataSuccess(_order('pending').copyWith(paymentTransactionId: 55));
    await _pump(tester, const OrderDetailScreen(orderId: 1));
    expect(find.widgetWithText(FilledButton, 'Bayar Sekarang'), findsOneWidget);
  });

  testWidgets('detail: tanpa id transaksi, tidak ada Bayar Sekarang', (tester) async {
    await _pump(tester, const OrderDetailScreen(orderId: 1));
    expect(find.text('Bayar Sekarang'), findsNothing);
    expect(find.textContaining('instruksi pembayaran'), findsOneWidget);
  });

  testWidgets('detail paid: tawaran Secure+ tanpa kata "asuransi"', (tester) async {
    orders.detail = DataSuccess(_order('paid'));
    await _pump(tester, const OrderDetailScreen(orderId: 1));
    await tester.scrollUntilVisible(find.text('Aktifkan Xpedia Secure+'), 300,
        scrollable: find.byType(Scrollable).first);
    // 0,5% dari 167.000.
    expect(find.textContaining('Rp 835'), findsOneWidget);
    expect(find.textContaining(RegExp('asuransi', caseSensitive: false)), findsNothing);

    await tester.ensureVisible(find.text('Aktifkan Perlindungan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aktifkan Perlindungan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, Aktifkan'));
    await tester.pumpAndSettle();
    expect(find.text('Xpedia Secure+ aktif'), findsOneWidget);
  });

  testWidgets('lacak: riwayat kurir simulasi dirender sebagai linimasa', (tester) async {
    orders.detail = DataSuccess(_order('shipped'));
    orders.tracking = DataSuccess(
      OrderTrackingModel(
        courierCode: 'jne',
        serviceType: 'reg',
        awbNumber: 'JN1234567890',
        status: 'in_transit',
        shippedAt: DateTime.utc(2026, 9, 16, 9),
        trackingHistory: [
          TrackingEventModel(
            status: 'in_transit',
            description: 'Paket telah tiba di kota tujuan',
            location: 'Hub kota tujuan',
            occurredAt: DateTime.utc(2026, 9, 17, 2),
          ),
          TrackingEventModel(
            status: 'picked_up',
            description: 'Paket telah diserahkan penjual ke kurir',
            location: 'Kota asal',
            occurredAt: DateTime.utc(2026, 9, 16, 9),
          ),
        ],
      ),
      meta: const {'mock_fields': ['tracking_history']},
    );
    await _pump(tester, const OrderTrackingScreen(orderId: 1));
    expect(find.text('Detail Perjalanan'), findsOneWidget);
    expect(find.text('Simulasi'), findsOneWidget);
    expect(find.text('Paket telah tiba di kota tujuan'), findsOneWidget);
    expect(find.textContaining('Hub kota tujuan'), findsOneWidget);
    expect(find.textContaining('belum tersedia'), findsNothing);
  });

  testWidgets('komplain: tombol kirim mati sampai penjelasan diisi', (tester) async {
    orders.detail = DataSuccess(_order('delivered'));
    await _pump(tester, const OrderComplaintScreen(orderId: 1));
    final button = find.widgetWithText(FilledButton, 'Kirim Komplain');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    await tester.scrollUntilVisible(find.byType(TextField), 300, scrollable: find.byType(Scrollable).first);
    await tester.enterText(find.byType(TextField), 'Kemasan penyok');
    await tester.pump();
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
  });

  testWidgets('komplain: bukti diunggah lalu URL-nya ikut dikirim', (tester) async {
    orders.detail = DataSuccess(_order('delivered'));
    await _pump(
      tester,
      OrderComplaintScreen(
        orderId: 1,
        pickEvidence: () async => [
          PickedEvidence(name: 'kemasan.png', bytes: _png),
          PickedEvidence(name: 'unboxing.mp4', bytes: Uint8List(10)),
          PickedEvidence(name: 'dokumen.pdf', bytes: Uint8List(10)),
        ],
      ),
      withRouter: true,
    );
    await tester.scrollUntilVisible(find.text('Klik untuk upload foto atau video'), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text('Klik untuk upload foto atau video'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Klik untuk upload foto atau video'));
    await tester.pumpAndSettle();

    expect(media.uploaded, ['kemasan.png', 'unboxing.mp4'], reason: 'PDF ditolak di aplikasi');
    expect(find.text('VID'), findsOneWidget);
    expect(find.textContaining('dokumen.pdf: format tidak didukung'), findsOneWidget);

    // Kolom penjelasan ada di bawah zona unggah; diisi lewat controller-nya
    // (listener layar ikut memperbarui tombol kirim).
    tester
        .widget<TextField>(find.byType(TextField, skipOffstage: false))
        .controller!
        .text = 'Kemasan penyok';
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Kirim Komplain'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(orders.refunds.single, 'Barang rusak: Kemasan penyok');
    expect(orders.refundEvidence.single, hasLength(2));
    expect(orders.refundEvidence.single.first, endsWith('kemasan.png'));
    await tester.pumpAndSettle();
    expect(find.text('ASAL'), findsOneWidget, reason: 'layar tertutup sesudah terkirim');
  });

  testWidgets('invoice: nama & HP pembeli disensor, PDF dibagikan', (tester) async {
    Uint8List? shared;
    String? fileName;
    orders.invoice = DataSuccess(OrderInvoiceModel(
      invoiceNumber: 'INV20260916-000001',
      orderNumber: 'ORD-UW6RM272MR',
      store: const InvoiceStoreModel(id: 7, name: 'Toko Kopi Gayo'),
      shippingAddress: const OrderShippingAddress(
        recipientName: 'Budi Santoso',
        phone: '081234567890',
        fullAddress: 'Jl. Melati 10',
        city: 'Bandung',
      ),
      items: _order('completed').items,
      subtotal: 150000,
      shippingCost: 17000,
      grandTotal: 167000,
    ));
    await _pump(
      tester,
      OrderInvoiceScreen(
        orderId: 1,
        sharePdf: (bytes, name) async {
          shared = bytes;
          fileName = name;
        },
      ),
    );
    expect(find.textContaining('B*** S******'), findsOneWidget);
    expect(find.textContaining('0812*****890'), findsOneWidget);
    expect(find.textContaining('Budi'), findsNothing);

    await tester.runAsync(() async {
      await tester.tap(find.text('Download Invoice (.PDF)'));
      for (var i = 0; i < 50 && shared == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    });
    await tester.pump();
    expect(fileName, 'invoice-INV20260916-000001.pdf');
    expect(String.fromCharCodes(shared!.take(4)), '%PDF');
  });

  testWidgets('ulasan: formulir untuk pesanan selesai', (tester) async {
    orders.detail = DataSuccess(_order('completed'));
    await _pump(tester, const ReviewFormScreen(orderId: 1, orderItemId: 7));
    expect(find.text('Bagaimana kepuasan Anda?'), findsOneWidget);
    expect(find.text('Sangat Puas!'), findsOneWidget);
    expect(find.text('Kirim Ulasan'), findsOneWidget);
  });

  testWidgets('ulasan: pesanan belum selesai ditolak', (tester) async {
    orders.detail = DataSuccess(_order('delivered'));
    await _pump(tester, const ReviewFormScreen(orderId: 1, orderItemId: 7));
    expect(find.text('Ulasan belum bisa dikirim'), findsOneWidget);
  });
}
