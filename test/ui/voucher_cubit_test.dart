/// [VoucherCubit] dan [VoucherScreen] terhadap repository palsu.
///
/// Yang paling mahal kalau salah: rekomendasi/auto-apply **tidak boleh**
/// diminta selagi keranjang tidak punya baris tercentang — servernya 500.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/voucher_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/voucher_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/voucher/cubit/voucher_cubit.dart';
import 'package:marketplace_app_member/ui/main/voucher/screens/voucher_screen.dart';
import 'package:marketplace_app_member/ui/main/voucher/widgets/voucher_texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

CartSnapshot _cart(
        {int itemCount = 1, List<AppliedVoucherModel> vouchers = const []}) =>
    CartSnapshot(
      groups: const [],
      summary: CartSummaryModel(
        subtotal: 150000,
        itemCount: itemCount,
        vouchers: vouchers,
      ),
    );

const _hemat = AppliedVoucherModel(
  code: 'HEMAT10',
  category: 'platform',
  discountType: 'percentage',
  discountValue: 10,
  discountAmount: 15000,
);

class _FakeCart implements CartRepository {
  DataState<CartSnapshot> result = DataSuccess(_cart());
  DataState<CartSnapshot>? applyResult;
  final calls = <String>[];

  @override
  Future<DataState<CartSnapshot>> fetchCart() async {
    calls.add('fetch');
    return result;
  }

  @override
  Future<DataState<CartSnapshot>> applyVoucher(String code) async {
    calls.add('apply:$code');
    return applyResult ?? DataSuccess(_cart(vouchers: [_hemat]));
  }

  @override
  Future<DataState<CartSnapshot>> removeVoucher(String code) async {
    calls.add('remove:$code');
    return DataSuccess(_cart());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeVouchers implements VoucherRepository {
  DataState<List<VoucherModel>> mine = const DataSuccess([]);
  DataState<List<VoucherModel>>? claimResult;
  DataState<List<AppliedVoucherModel>> recommended = const DataSuccess([]);
  DataState<List<AppliedVoucherModel>> auto = const DataSuccess([]);
  final calls = <String>[];

  @override
  Future<DataState<List<VoucherModel>>> fetchMyVouchers() async {
    calls.add('mine');
    return mine;
  }

  @override
  Future<DataState<List<VoucherModel>>> claim(String code) async {
    calls.add('claim:$code');
    return claimResult ??
        DataSuccess([VoucherModel(id: 1, code: code, name: 'Diskon')]);
  }

  @override
  Future<DataState<List<AppliedVoucherModel>>> fetchRecommended() async {
    calls.add('recommended');
    return recommended;
  }

  @override
  Future<DataState<List<AppliedVoucherModel>>> autoApply() async {
    calls.add('auto');
    return auto;
  }
}

void main() {
  late _FakeCart cart;
  late _FakeVouchers vouchers;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    cart = _FakeCart();
    vouchers = _FakeVouchers();
    injector
      ..registerSingleton<CartRepository>(cart)
      ..registerSingleton<VoucherRepository>(vouchers);
  });

  tearDown(() async => injector.reset());

  group('keranjang kosong (tanpa baris tercentang)', () {
    setUp(() => cart.result = DataSuccess(_cart(itemCount: 0)));

    test('rekomendasi TIDAK diminta — servernya 500 untuk keranjang kosong',
        () async {
      final cubit = VoucherCubit();
      await cubit.load();

      expect(vouchers.calls, isNot(contains('recommended')));
      expect(cubit.state, isA<VoucherReady>());
      await cubit.close();
    });

    test('auto-apply dan pakai kode juga tidak menyentuh jaringan', () async {
      final cubit = VoucherCubit();
      await cubit.load();

      await cubit.autoApply();
      await cubit.apply('HEMAT10');

      expect(vouchers.calls, isNot(contains('auto')));
      expect(cart.calls.where((c) => c.startsWith('apply')), isEmpty);
      expect((cubit.state as VoucherReady).actionError?.code,
          ClientErrorCode.localValidation);
      await cubit.close();
    });

    test('klaim tetap boleh — tidak bergantung isi keranjang', () async {
      final cubit = VoucherCubit();
      await cubit.load();

      await cubit.claim(' KODE1 ');

      expect(vouchers.calls, contains('claim:KODE1'));
      expect((cubit.state as VoucherReady).claimed.single.code, 'KODE1');
      await cubit.close();
    });
  });

  test('ada barang tercentang → rekomendasi diminta', () async {
    final cubit = VoucherCubit();
    await cubit.load();

    expect(vouchers.calls, containsAll(['mine', 'recommended']));
    await cubit.close();
  });

  test('pakai kode → ringkasan dari baca ulang keranjang + rekomendasi ulang',
      () async {
    final cubit = VoucherCubit();
    await cubit.load();
    vouchers.calls.clear();

    await cubit.apply('HEMAT10');

    final state = cubit.state as VoucherReady;
    expect(state.summary.vouchers.single.code, 'HEMAT10');
    expect(state.notice, contains('HEMAT10'));
    expect(vouchers.calls, ['recommended'],
        reason: 'isi slot berubah, jadi "terbaik per slot" ikut berubah');
    await cubit.close();
  });

  test('penolakan server jadi actionError, isi lama dipertahankan', () async {
    cart.applyResult = DataFailed(_error(VoucherErrorCode.minSpendNotMet));
    final cubit = VoucherCubit();
    await cubit.load();

    await cubit.apply('BESAR');

    final state = cubit.state as VoucherReady;
    expect(state.actionError?.code, VoucherErrorCode.minSpendNotMet);
    expect(state.busyCode, isNull);
    expect(state.summary.itemCount, 1);
    await cubit.close();
  });

  test('gagal memuat Voucher Saya tidak menggagalkan layar', () async {
    vouchers.mine = DataFailed(_error('CLIENT_NETWORK'));
    final cubit = VoucherCubit();
    await cubit.load();

    expect((cubit.state as VoucherReady).claimedError?.code, 'CLIENT_NETWORK');
    await cubit.close();
  });

  test('gagal memuat keranjang → layar error', () async {
    cart.result = DataFailed(_error('CLIENT_NETWORK'));
    final cubit = VoucherCubit();
    await cubit.load();

    expect(cubit.state, isA<VoucherError>());
    await cubit.close();
  });

  group('kalimat nilai voucher', () {
    test('ongkir (discount_amount null) tidak pernah ditulis "Hemat"', () {
      const shipping = AppliedVoucherModel(
          code: 'ONGKIR', category: 'shipping', discountType: 'free_shipping');
      expect(appliedVoucherValue(shipping), isNot(contains('Hemat')));
    });

    test('cashback (discount_amount 0) bukan potongan', () {
      const cashback = AppliedVoucherModel(
          code: 'CB',
          category: 'platform',
          discountType: 'cashback',
          discountAmount: 0);
      expect(appliedVoucherValue(cashback), contains('Cashback'));
      expect(appliedVoucherValue(cashback), isNot(contains('Rp')));
    });

    test('persentase dengan batas', () {
      expect(
        claimedVoucherValue(const VoucherModel(
            discountType: 'percentage', discountValue: 10, maxDiscount: 50000)),
        'Diskon 10% hingga Rp 50.000',
      );
    });
  });

  testWidgets('layar: keadaan kosong di dev tampil apa adanya', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const VoucherScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Punya kode voucher?'), findsOneWidget);
    expect(find.text('Belum ada voucher yang dipakai.'), findsOneWidget);
    expect(find.text('Belum ada voucher yang cocok untuk isi keranjangmu.'),
        findsOneWidget);
    await tester.scrollUntilVisible(find.text('Belum ada voucher'), 200,
        scrollable: find
            .descendant(
                of: find.byType(ListView), matching: find.byType(Scrollable))
            .first);
    expect(find.text('Belum ada voucher'), findsOneWidget);
    // "Gunakan Otomatis" hanya ditawarkan kalau ada rekomendasi.
    expect(find.text('Gunakan Otomatis'), findsNothing);
  });
}
