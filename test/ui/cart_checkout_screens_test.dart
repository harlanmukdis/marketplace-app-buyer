/// Uji asap layar pembelian: keranjang, kelola alamat, checkout, pembayaran.
///
/// Test cubit memanggil method langsung, sehingga tidak bisa menangkap layar
/// yang meledak saat dirender (overflow, provider hilang) atau tombol yang
/// tidak tersambung ke cubit — kelas bug yang sama dengan tombol "Tambah ke
/// Keranjang" yang dulu mati (CLAUDE.md, "Bug pertama yang ditemukan lapisan
/// ini"). Di sini seluruh layar dipompa di atas repository palsu.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/model/payment/payment_models.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/payment_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/address/screens/address_list_screen.dart';
import 'package:marketplace_app_member/ui/main/cart/screens/cart_screen.dart';
import 'package:marketplace_app_member/ui/main/checkout/screens/checkout_screen.dart';
import 'package:marketplace_app_member/ui/main/payment/screens/payment_screen.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/wallet/widgets/pin_pad.dart';
import 'package:shared_preferences/shared_preferences.dart';

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

const _cart = CartSnapshot(
  groups: [
    CartStoreGroup(storeName: 'Toko Kopi', items: [
      CartItemModel(
        id: 1,
        storeId: 7,
        quantity: 2,
        price: 75000,
        productName: 'Kopi Arabika Gayo 250g',
        variantOptions: {'ukuran': '250g'},
      ),
      CartItemModel(
        id: 2,
        storeId: 7,
        isSelected: false,
        price: 20000,
        productName: 'Filter Kertas',
      ),
    ]),
  ],
  summary: CartSummaryModel(subtotal: 150000, itemCount: 1),
);

AddressModel _address(int id, {bool primary = false}) => AddressModel(
      id: id,
      label: 'Rumah',
      recipientName: 'Budi Santoso',
      phone: '081298447890',
      fullAddress: 'Jl. Melati No. $id',
      city: 'Jakarta Selatan',
      province: 'DKI Jakarta',
      postalCode: '12430',
      isPrimary: primary,
    );

class _FakeCart implements CartRepository {
  DataState<CartSnapshot> result = const DataSuccess(_cart);
  final calls = <String>[];

  Future<DataState<CartSnapshot>> _r(String c) async {
    calls.add(c);
    return result;
  }

  @override
  Future<DataState<CartSnapshot>> fetchCart() => _r('fetch');
  @override
  Future<DataState<CartSnapshot>> addItem(
          {required int productVariantId, required int quantity}) =>
      _r('add');
  @override
  Future<DataState<CartSnapshot>> updateQuantity(int itemId, int quantity) =>
      _r('update:$itemId:$quantity');
  @override
  Future<DataState<CartSnapshot>> setSelected(int itemId, bool isSelected) =>
      _r('select:$itemId:$isSelected');
  @override
  Future<DataState<CartSnapshot>> removeItem(int itemId) =>
      _r('remove:$itemId');
  @override
  Future<DataState<CartSnapshot>> applyVoucher(String code) => _r('v:$code');
  @override
  Future<DataState<CartSnapshot>> removeVoucher(String code) => _r('rv:$code');
}

class _FakeStores implements StoreRepository {
  @override
  Future<DataState<StoreModel>> fetchStore(int id) async => DataSuccess(
      StoreModel(id: id, name: 'Toko Kopi', primaryStatus: 'official_store'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReward implements RewardRepository {
  @override
  Future<DataState<RewardPreviewModel>> previewFromCart() async =>
      DataFailed(_error('NETWORK'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAddresses implements AddressRepository {
  List<AddressModel> addresses = [_address(1, primary: true), _address(2)];

  @override
  Future<DataState<List<AddressModel>>> fetchAddresses() async =>
      DataSuccess(List.of(addresses));
  @override
  Future<DataState<List<AddressModel>>> create(AddressDraft draft) async =>
      DataSuccess(List.of(addresses));
  @override
  Future<DataState<List<AddressModel>>> update(
          int id, AddressDraft draft) async =>
      DataSuccess(List.of(addresses));
  @override
  Future<DataState<List<AddressModel>>> delete(int id) async {
    addresses.removeWhere((a) => a.id == id);
    return DataSuccess(List.of(addresses));
  }

  @override
  Future<DataState<List<AddressModel>>> setPrimary(int id) async =>
      DataSuccess(List.of(addresses));
}

class _FakeCheckout implements CheckoutRepository {
  DataState<CheckoutSnapshot>? startResult;

  /// Default: saldo cukup untuk `grand_total` sesi palsu di bawah.
  DataState<WalletSummaryModel> walletResult = const DataSuccess(
    WalletSummaryModel(
      walletBalance: 2500000,
      grandTotal: 159000,
      canPay: true,
      pinSet: true,
    ),
  );
  DataState<CheckoutConfirmResult> confirmResult = const DataSuccess(
      CheckoutConfirmResult(orderIds: [1], paymentTransactionId: 5, paid: true));
  final calls = <String>[];

  CheckoutSnapshot get snapshot => CheckoutSnapshot(
        session: CheckoutSessionModel(
          id: 'sesi-1',
          status: 'stock_reserved',
          shippingAddressId: 1,
          cartSnapshot: '[{"store_id":"7","product_name":"Kopi Arabika",'
              '"price":"75000.00","quantity":"2"}]',
          // Sudah termasuk ongkir 9000 — begitulah `set_shipping` menulisnya.
          grandTotal: 159000,
          selectedCouriers: const {
            '7': {
              'courier_code': 'jne',
              'service_code': 'reg',
              'service_name': 'JNE REG',
              'cost': 9000,
            },
          },
          expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 14)),
        ),
        shippingOptions: const {
          '7': [
            ShippingOptionModel(
                courierCode: 'jne',
                serviceCode: 'reg',
                serviceName: 'JNE REG',
                cost: 9000,
                etdMinDays: 2,
                etdMaxDays: 4),
          ],
        },
      );

  @override
  Future<DataState<CheckoutSnapshot>> startSession(
      {required int addressId, String? voucherCode}) async {
    calls.add('start:$addressId');
    return startResult ?? DataSuccess(snapshot);
  }

  @override
  Future<DataState<CheckoutSnapshot>> refresh(String sessionId) async =>
      DataSuccess(snapshot);
  @override
  Future<DataState<CheckoutSnapshot>> changeAddress(String sessionId,
          {required int addressId}) async =>
      DataSuccess(snapshot);
  @override
  Future<DataState<CheckoutSnapshot>> setShipping(
          String sessionId, Map<String, CourierChoice> selection) async =>
      DataSuccess(snapshot);
  @override
  Future<DataState<CheckoutConfirmResult>> confirm(String sessionId,
      {required String pin}) async {
    calls.add('confirm:$pin');
    return confirmResult;
  }

  @override
  Future<DataState<WalletSummaryModel>> fetchWalletSummary(
          String sessionId) async =>
      walletResult;

  @override
  Future<DataState<void>> cancelSession(String sessionId) async {
    calls.add('cancel');
    return const DataSuccess(null);
  }
}

class _FakePayments implements PaymentRepository {
  @override
  Future<DataState<List<PaymentMethodModel>>> fetchMethods() async =>
      const DataSuccess([
        PaymentMethodModel(code: 'qris', name: 'QRIS'),
        PaymentMethodModel(code: 'virtual_account', name: 'Virtual Account'),
      ]);

  PaymentSnapshot get _snapshot => PaymentSnapshot(
        payment: PaymentModel(
          id: 5,
          amount: 159000,
          status: 'pending',
          expiredAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        ),
        instruction: const PaymentInstructionModel(
            vaNumber: '8808123456789', bank: 'BCA'),
      );

  @override
  Future<DataState<PaymentSnapshot>> load(int txId) async =>
      DataSuccess(_snapshot);
  @override
  Future<DataState<PaymentSnapshot>> refreshStatus(int txId) async =>
      DataSuccess(_snapshot);
}

Future<void> _pump(WidgetTester tester, Widget screen) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StoreDirectoryCubit()),
        BlocProvider(create: (_) => CartBadgeCubit()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: screen,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

/// Blok Wallet ada di bawah daftar, di luar area yang dibangun `ListView`.
Future<void> _scrollTo(WidgetTester tester, Finder finder) =>
    tester.scrollUntilVisible(finder, 300,
        scrollable: find
            .descendant(
                of: find.byType(ListView), matching: find.byType(Scrollable))
            .first);

void main() {
  late _FakeCart cart;
  late _FakeCheckout checkout;
  late _FakeAddresses addresses;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    cart = _FakeCart();
    checkout = _FakeCheckout();
    addresses = _FakeAddresses();
    injector
      ..registerSingleton<CartRepository>(cart)
      ..registerSingleton<StoreRepository>(_FakeStores())
      ..registerSingleton<RewardRepository>(_FakeReward())
      ..registerSingleton<AddressRepository>(addresses)
      ..registerSingleton<CheckoutRepository>(checkout)
      ..registerSingleton<PaymentRepository>(_FakePayments());
  });

  tearDown(() async {
    await injector.reset();
  });

  group('keranjang', () {
    testWidgets('merender grup toko, total, dan tombol Checkout',
        (tester) async {
      await _pump(tester, const CartScreen());

      expect(find.text('Keranjang Belanja'), findsOneWidget);
      expect(find.text('Pilih Semua (2)'), findsOneWidget);
      expect(find.text('Toko Kopi'), findsOneWidget);
      expect(find.text('Varian: 250g'), findsOneWidget);
      expect(find.textContaining('barang terpilih'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Checkout'), findsOneWidget);
      // Kartu voucher selalu ada — pintu ke layar voucher.
      expect(find.text('Voucher Belanja & Bebas Ongkir'), findsOneWidget);
      // Lencana app bar ikut snapshot layar ini, tanpa request tambahan.
      final context = tester.element(find.byType(CartScreen));
      expect(context.read<CartBadgeCubit>().state, 2);
    });

    testWidgets('"Pilih Semua" mencentang baris yang belum tercentang saja',
        (tester) async {
      await _pump(tester, const CartScreen());
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      expect(cart.calls, contains('select:2:true'));
      expect(cart.calls, isNot(contains('select:1:true')));
    });

    testWidgets('"Hapus" meminta konfirmasi dulu', (tester) async {
      await _pump(tester, const CartScreen());
      await tester.tap(find.widgetWithText(TextButton, 'Hapus'));
      await tester.pumpAndSettle();
      expect(find.text('Hapus 1 barang?'), findsOneWidget);
      expect(cart.calls.where((c) => c.startsWith('remove')), isEmpty);

      await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
      await tester.pumpAndSettle();
      expect(cart.calls, contains('remove:1'));
    });

    testWidgets('keranjang kosong menampilkan empty state', (tester) async {
      cart.result = const DataSuccess(CartSnapshot.empty);
      await _pump(tester, const CartScreen());
      expect(find.text('Keranjang masih kosong'), findsOneWidget);
    });
  });

  group('kelola alamat', () {
    testWidgets('penghitung kapasitas dan tombol tambah', (tester) async {
      await _pump(tester, const AddressListScreen());

      expect(find.text('2 / 3 Alamat'), findsOneWidget);
      expect(find.text('Sisa 1 slot alamat'), findsOneWidget);
      expect(find.text('Utama'), findsOneWidget);
      expect(find.text('Jadikan Alamat Utama'), findsOneWidget);
      expect(find.textContaining('0812****890'), findsWidgets);
    });

    testWidgets('kuota penuh mematikan tambah alamat', (tester) async {
      addresses.addresses = [
        _address(1, primary: true),
        _address(2),
        _address(3),
      ];
      await _pump(tester, const AddressListScreen());

      expect(find.text('Kuota alamat penuh'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Tambah Alamat Baru'), 300);
      await tester.tap(find.text('Tambah Alamat Baru'));
      await tester.pumpAndSettle();
      // Lembar formulir tidak terbuka.
      expect(find.text('Tambah Alamat'), findsNothing);
    });
  });

  group('checkout', () {
    testWidgets('total TIDAK menambahkan ongkir dua kali', (tester) async {
      await _pump(tester, const CheckoutScreen());
      await tester.pump();

      expect(find.text('Checkout Pembayaran'), findsOneWidget);
      // Checkout wallet-only (backend d9ecb33): tidak ada pemilih metode.
      expect(find.text('Metode Pembayaran'), findsNothing);
      expect(find.text('QRIS'), findsNothing);
      // grand_total sesi sudah termasuk ongkir.
      expect(find.text('Rp 159.000'), findsWidgets);
      expect(find.text('Rp 168.000'), findsNothing);
      expect(
          find.widgetWithText(FilledButton, 'Bayar Sekarang'), findsOneWidget);
    });

    testWidgets('Wallet: saldo & total satu kartu, Bayar → PIN → lunas',
        (tester) async {
      checkout.confirmResult = const DataSuccess(
        CheckoutConfirmResult(
          orderIds: [1],
          paymentTransactionId: 5,
          paid: true,
          balanceAfter: 2341000,
        ),
      );
      await _pump(tester, const CheckoutScreen());
      await tester.pump();
      await _scrollTo(tester, find.text('Xpedia Wallet'));

      expect(find.text('Xpedia Wallet'), findsOneWidget);
      expect(find.text('Rp 2.500.000'), findsOneWidget);
      expect(find.text('Saldo kamu mencukupi untuk pembayaran ini'),
          findsOneWidget);
      // Data sungguhan, bukan simulasi.
      expect(find.text('Simulasi'), findsNothing);
      // Alur Wallet tidak menawarkan metode lain.
      expect(find.text('QRIS'), findsNothing);

      await tester.tap(find.widgetWithText(FilledButton, 'Bayar Sekarang'));
      await tester.pumpAndSettle();
      expect(find.text('Masukkan PIN 6-Digit'), findsOneWidget);
      expect(checkout.calls.where((c) => c.startsWith('confirm')), isEmpty,
          reason: 'tidak ada bayar satu ketukan');

      for (final digit in ['1', '2', '3', '4', '5', '6']) {
        await tester.tap(find.descendant(
            of: find.byType(PinPad), matching: find.text(digit)));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      expect(checkout.calls, contains('confirm:123456'));
      expect(find.text('Pembayaran berhasil'), findsOneWidget);
      expect(find.text('Rp 2.341.000'), findsOneWidget);
      expect(find.text('Lihat pesanan saya'), findsOneWidget);
      expect(find.text('Lanjut ke pembayaran'), findsNothing);
    });

    testWidgets('Wallet saldo kurang: Bayar mati, selisih + Top Up',
        (tester) async {
      checkout.walletResult = const DataSuccess(WalletSummaryModel(
        walletBalance: 100000,
        grandTotal: 159000,
        shortfall: 59000,
        canPay: false,
        pinSet: true,
      ));
      await _pump(tester, const CheckoutScreen());
      await tester.pump();
      await _scrollTo(tester, find.text('Top Up Saldo Sekarang'));

      expect(find.text('Saldo Kurang Rp 59.000'), findsOneWidget);
      expect(find.text('Top Up Saldo Sekarang'), findsOneWidget);
      expect(find.text('Isi saldo untuk melanjutkan'), findsOneWidget);
      final pay = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Bayar Sekarang'));
      expect(pay.onPressed, isNull);
      // Server sungguhan tidak mengirim `meta.mock` → tanpa lencana.
      expect(find.text('Simulasi'), findsNothing);
    });

    testWidgets('SHIPPING_COVERAGE_UNAVAILABLE menawarkan ganti alamat',
        (tester) async {
      checkout.startResult =
          DataFailed(_error(ApiErrorCode.shippingCoverageUnavailable));
      await _pump(tester, const CheckoutScreen());
      await tester.pump();

      expect(
          find.text('Barang tidak bisa dikirim ke alamat ini'), findsOneWidget);
      expect(find.text('Ganti Alamat'), findsOneWidget);
      expect(find.text('Kembali ke keranjang'), findsOneWidget);
    });

    testWidgets('tanpa alamat, ajakan menambah', (tester) async {
      addresses.addresses = [];
      await _pump(tester, const CheckoutScreen());

      expect(find.text('Tambah alamat'), findsOneWidget);
      expect(find.textContaining('Belum ada alamat'), findsOneWidget);
      expect(checkout.calls, isEmpty);
    });
  });

  testWidgets('pembayaran VA menampilkan nomor dan total', (tester) async {
    await _pump(tester, const PaymentScreen(transactionId: 5));

    expect(find.text('Virtual Account BCA'), findsOneWidget);
    expect(find.text('8808123456789'), findsOneWidget);
    expect(find.text('Rp 159.000'), findsOneWidget);
    expect(find.text('Saya sudah bayar, cek status'), findsOneWidget);
  });
}
