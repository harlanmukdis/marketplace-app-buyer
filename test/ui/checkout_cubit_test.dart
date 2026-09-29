/// Perilaku [CheckoutCubit] terhadap repository palsu.
///
/// Fokusnya pada keputusan yang mahal kalau salah: sesi checkout **menahan
/// stok di server**, jadi yang diuji terutama kapan sesi dibatalkan dan kapan
/// tidak.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/core/services/order_payment_link_store.dart';
import 'package:marketplace_app_member/ui/main/checkout/cubit/checkout_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _option1 = ShippingOptionModel(
  courierCode: 'jnt',
  serviceCode: 'ez',
  serviceName: 'J&T EZ',
  cost: 17000,
);
const _option2 = ShippingOptionModel(
  courierCode: 'jne',
  serviceCode: 'reg',
  serviceName: 'JNE REG',
  cost: 9000,
);

/// Sesi dua toko; [couriers] menentukan toko mana yang sudah punya kurir.
CheckoutSnapshot _snapshot({
  String id = 'sesi-1',
  String status = 'stock_reserved',
  Map<String, dynamic>? couriers,
}) {
  return CheckoutSnapshot(
    session: CheckoutSessionModel(
      id: id,
      status: status,
      cartSnapshot: '[{"store_id":"1"},{"store_id":"2"}]',
      grandTotal: 3049000,
      // Jauh di depan supaya canConfirm tidak gagal karena tenggat.
      expiresAt: DateTime.utc(2099),
      selectedCouriers: couriers,
    ),
    shippingOptions: {
      '1': const [_option1],
      '2': const [_option2],
    },
  );
}

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

const _enough = WalletSummaryModel(
  walletBalance: 5000000,
  grandTotal: 3049000,
  canPay: true,
  pinSet: true,
);

const _short = WalletSummaryModel(
  walletBalance: 750000,
  grandTotal: 3049000,
  shortfall: 2299000,
  canPay: false,
  pinSet: true,
);

const _bothCouriers = {
  '1': {'courier_code': 'jnt', 'service_code': 'ez'},
  '2': {'courier_code': 'jne', 'service_code': 'reg'},
};

class _FakeCheckoutRepository implements CheckoutRepository {
  DataState<CheckoutSnapshot> snapshotResult = DataSuccess(_snapshot());
  DataState<CheckoutConfirmResult> confirmResult =
      const DataSuccess(CheckoutConfirmResult(orderIds: [1, 2]));

  DataState<WalletSummaryModel> walletResult = const DataSuccess(_enough);

  final List<String> calls = [];

  /// Dicatat terpisah dari [calls]: ringkasan saldo dimuat ulang setiap
  /// snapshot baru, dan kebanyakan test tidak peduli.
  final List<String> walletCalls = [];
  String? lastPin;
  Map<String, CourierChoice>? lastSelection;

  @override
  Future<DataState<CheckoutSnapshot>> startSession({
    required int addressId,
    String? voucherCode,
  }) async {
    calls.add('start:$addressId');
    return snapshotResult;
  }

  @override
  Future<DataState<CheckoutSnapshot>> refresh(String sessionId) async {
    calls.add('refresh:$sessionId');
    return snapshotResult;
  }

  @override
  Future<DataState<CheckoutSnapshot>> changeAddress(
    String sessionId, {
    required int addressId,
  }) async {
    calls.add('address:$sessionId:$addressId');
    return snapshotResult;
  }

  @override
  Future<DataState<CheckoutSnapshot>> setShipping(
    String sessionId,
    Map<String, CourierChoice> selection,
  ) async {
    calls.add('shipping:$sessionId');
    lastSelection = selection;
    return snapshotResult;
  }

  @override
  Future<DataState<CheckoutConfirmResult>> confirm(
    String sessionId, {
    required String pin,
  }) async {
    calls.add('confirm:$sessionId');
    lastPin = pin;
    return confirmResult;
  }

  @override
  Future<DataState<WalletSummaryModel>> fetchWalletSummary(
      String sessionId) async {
    walletCalls.add(sessionId);
    return walletResult;
  }

  @override
  Future<DataState<void>> cancelSession(String sessionId) async {
    calls.add('cancel:$sessionId');
    return const DataSuccess(null);
  }
}

class _FakeWalletRepository implements WalletRepository {
  final topups = <double>[];

  @override
  Future<DataState<WalletTopupResult>> topup({
    required double amount,
    String paymentMethod = 'qris',
  }) async {
    topups.add(amount);
    return DataSuccess(
        WalletTopupResult(paymentTransactionId: 77, amount: amount));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// `start` lalu tunggu ringkasan Wallet (yang sengaja tidak di-`await`
/// cubit) selesai dimuat.
Future<void> _start(CheckoutCubit cubit) async {
  await cubit.start(addressId: 5);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  late _FakeCheckoutRepository repository;
  late _FakeWalletRepository wallets;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    repository = _FakeCheckoutRepository();
    wallets = _FakeWalletRepository();
    injector.registerSingleton<CheckoutRepository>(repository);
    injector.registerSingleton<WalletRepository>(wallets);
  });

  tearDown(() async {
    await injector.reset();
  });

  test('start memuat sesi', () async {
    final cubit = CheckoutCubit();
    await cubit.start(addressId: 5);

    expect(cubit.state, isA<CheckoutReady>());
    expect(repository.calls, ['start:5']);
    await cubit.close();
  });

  group('reservasi stok', () {
    test('menutup cubit MEMBATALKAN sesi yang belum dikonfirmasi', () async {
      // Tanpa ini, stok tertahan sampai tenggat 15 menit hanya karena user
      // menutup layar checkout.
      final cubit = CheckoutCubit();
      await cubit.start(addressId: 5);
      repository.calls.clear();

      await cubit.close();
      await Future<void>.delayed(Duration.zero);

      expect(repository.calls, contains('cancel:sesi-1'));
    });

    test('sesi yang SUDAH dikonfirmasi tidak dibatalkan saat cubit ditutup',
        () async {
      // Membatalkannya akan mencoba melepas reservasi milik order yang sudah
      // terbentuk.
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.snapshotResult =
          DataSuccess(_snapshot(couriers: _bothCouriers));
      await cubit.refresh();
      await Future<void>.delayed(Duration.zero);
      await cubit.payWithWallet('123456');
      repository.calls.clear();

      await cubit.close();
      await Future<void>.delayed(Duration.zero);

      expect(repository.calls.any((c) => c.startsWith('cancel:')), isFalse);
    });

    test('sesi yang tidak lagi stock_reserved tidak ikut dibatalkan', () async {
      repository.snapshotResult =
          DataSuccess(_snapshot(status: 'awaiting_payment'));
      final cubit = CheckoutCubit();
      await cubit.start(addressId: 5);
      repository.calls.clear();

      await cubit.close();
      await Future<void>.delayed(Duration.zero);

      expect(repository.calls.any((c) => c.startsWith('cancel:')), isFalse);
    });
  });

  group('ganti alamat', () {
    test('mengubah sesi di tempat — TIDAK membatalkan lalu membuat ulang',
        () async {
      // Sampai backend memperbaiki PATCH .../address (commit `8235c33`),
      // ini terpaksa dilakukan dengan cancel + start, yang melepas lalu
      // mengambil ulang reservasi stok — user bisa kehilangan barangnya ke
      // pembeli lain hanya karena salah pilih alamat.
      final cubit = CheckoutCubit();
      await cubit.start(addressId: 5);
      repository.calls.clear();

      await cubit.changeAddress(9);

      expect(repository.calls, ['address:sesi-1:9']);
      expect(repository.calls.any((c) => c.startsWith('cancel:')), isFalse);
      await cubit.close();
    });

    test('tanpa sesi terbuka, alamatnya dipakai MEMULAI sesi', () async {
      final cubit = CheckoutCubit();

      await cubit.changeAddress(9);

      expect(repository.calls, ['start:9']);
      await cubit.close();
    });
  });

  group('pilih kurir', () {
    test('mengirim SELURUH pilihan, bukan hanya yang berubah', () async {
      // Endpointnya mengganti isi selected_couriers, jadi mengirim satu toko
      // saja akan menghapus pilihan toko lain.
      repository.snapshotResult = DataSuccess(_snapshot(couriers: {
        '1': {'courier_code': 'jnt', 'service_code': 'ez'},
      }));
      final cubit = CheckoutCubit();
      await cubit.start(addressId: 5);

      await cubit.selectCourier('2', _option2);

      expect(repository.lastSelection!.keys.toSet(), {'1', '2'});
      expect(repository.lastSelection!['1']!.courierCode, 'jnt');
      expect(repository.lastSelection!['2']!.serviceCode, 'reg');
      await cubit.close();
    });

    test('gagal memilih kurir TIDAK membuang sesi yang sedang berjalan',
        () async {
      final cubit = CheckoutCubit();
      await cubit.start(addressId: 5);
      repository.snapshotResult = DataFailed(_error('NETWORK'));

      await cubit.selectCourier('1', _option1);

      final state = cubit.state as CheckoutReady;
      expect(state.actionError?.code, 'NETWORK');
      expect(state.isSubmitting, isFalse);
      await cubit.close();
    });
  });

  group('konfirmasi', () {
    test('ditolak selagi ada toko tanpa kurir', () async {
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.calls.clear();

      await cubit.payWithWallet('123456');

      expect(repository.calls, isEmpty, reason: 'tidak menyentuh jaringan');
      expect((cubit.state as CheckoutReady).actionError?.code,
          ApiErrorCode.checkoutConfirmFailed);
      await cubit.close();
    });

    test('berhasil berujung CheckoutConfirmed berisi order_ids', () async {
      repository.snapshotResult = DataSuccess(_snapshot(couriers: {
        '1': {'courier_code': 'jnt', 'service_code': 'ez'},
        '2': {'courier_code': 'jne', 'service_code': 'reg'},
      }));
      final cubit = CheckoutCubit();
      await _start(cubit);

      await cubit.payWithWallet('123456');

      final state = cubit.state as CheckoutConfirmed;
      expect(state.result.orderIds, [1, 2]);
      expect(state.result.isMultiStore, isTrue);
      await cubit.close();
    });

    test('konfirmasi kedua diabaikan selagi yang pertama berjalan', () async {
      // Backend belum menangani Idempotency-Key, jadi panggilan ganda bisa
      // membuat order ganda.
      repository.snapshotResult = DataSuccess(_snapshot(couriers: {
        '1': {'courier_code': 'jnt', 'service_code': 'ez'},
        '2': {'courier_code': 'jne', 'service_code': 'reg'},
      }));
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.calls.clear();

      final first = cubit.payWithWallet('123456');
      final second = cubit.payWithWallet('123456');
      await Future.wait([first, second]);

      expect(repository.calls.where((c) => c.startsWith('confirm:')).length, 1);
      await cubit.close();
    });

    test('gagal konfirmasi mempertahankan sesi supaya bisa dicoba lagi',
        () async {
      repository.snapshotResult = DataSuccess(_snapshot(couriers: {
        '1': {'courier_code': 'jnt', 'service_code': 'ez'},
        '2': {'courier_code': 'jne', 'service_code': 'reg'},
      }));
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.confirmResult =
          DataFailed(_error(ApiErrorCode.stockInsufficient));

      await cubit.payWithWallet('123456');

      final state = cubit.state as CheckoutReady;
      expect(state.actionError?.code, ApiErrorCode.stockInsufficient);
      await cubit.close();
    });
  });

  group('ringkasan saldo Wallet', () {
    test('termuat → alur Wallet siap', () async {
      repository.walletResult =
          const DataSuccess(_enough, meta: {'mock': true});
      final cubit = CheckoutCubit();
      await _start(cubit);

      final state = cubit.state as CheckoutReady;
      expect(state.paymentMode, CheckoutPaymentMode.wallet);
      expect(state.wallet, _enough);
      expect(state.walletMeta, {'mock': true});
      await cubit.close();
    });

    test('gagal dimuat → walletError, tombol bayar mati', () async {
      repository.walletResult = DataFailed(_error('CLIENT_NETWORK'));
      final cubit = CheckoutCubit();
      await _start(cubit);

      final state = cubit.state as CheckoutReady;
      expect(state.paymentMode, CheckoutPaymentMode.detecting);
      expect(state.walletError?.code, 'CLIENT_NETWORK');
      expect(state.canPay, isFalse);
      await cubit.close();
    });

    test('tanpa ringkasan saldo, bayar ditolak tanpa menyentuh jaringan',
        () async {
      repository.snapshotResult =
          DataSuccess(_snapshot(couriers: _bothCouriers));
      repository.walletResult = DataFailed(_error('CLIENT_NETWORK'));
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.calls.clear();

      await cubit.payWithWallet('123456');

      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('total berubah (kurir dipilih) → ringkasan saldo dimuat ulang',
        () async {
      repository.walletResult = const DataSuccess(_enough);
      final cubit = CheckoutCubit();
      await _start(cubit);

      await cubit.selectCourier('1', _option1);
      await Future<void>.delayed(Duration.zero);

      expect(repository.walletCalls, hasLength(2));
      await cubit.close();
    });
  });

  group('bayar dengan Wallet', () {
    setUp(() {
      repository.snapshotResult =
          DataSuccess(_snapshot(couriers: _bothCouriers));
      repository.walletResult = const DataSuccess(_enough);
      repository.confirmResult = const DataSuccess(
        CheckoutConfirmResult(
          orderIds: [11, 12],
          paymentTransactionId: 55,
          paid: true,
          walletTransactionId: 900001,
          balanceAfter: 1951000,
        ),
        meta: {
          'mock_fields': ['paid']
        },
      );
    });

    test('PIN dikirim → CheckoutConfirmed yang sudah dibayar', () async {
      final cubit = CheckoutCubit();
      await _start(cubit);
      expect(cubit.state.canPay, isTrue);

      await cubit.payWithWallet('123456');

      expect(repository.lastPin, '123456');
      final state = cubit.state as CheckoutConfirmed;
      expect(state.result.paid, isTrue);
      expect(state.meta, {
        'mock_fields': ['paid']
      });
      await cubit.close();
    });

    test('tautan order → transaksi disimpan', () async {
      final cubit = CheckoutCubit();
      await _start(cubit);

      await cubit.payWithWallet('123456');

      expect(OrderPaymentLinkStore.transactionFor(11), 55);
      expect(OrderPaymentLinkStore.transactionFor(12), 55);
      await cubit.close();
    });

    test('saldo kurang ditolak TANPA menyentuh jaringan', () async {
      // Percobaan PIN dibatasi server; jangan dihabiskan untuk penolakan
      // yang sudah pasti.
      repository.walletResult = const DataSuccess(_short);
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.calls.clear();
      expect(cubit.state.canPay, isFalse);

      await cubit.payWithWallet('123456');

      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('PIN belum dibuat → tombol mati, bayar ditolak lokal', () async {
      repository.walletResult =
          const DataSuccess(WalletSummaryModel(canPay: true, pinSet: false));
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.calls.clear();

      expect(cubit.state.canPay, isFalse);
      await cubit.payWithWallet('123456');
      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('PIN salah masuk pinError, sesi tetap hidup', () async {
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.confirmResult = const DataFailed(DataError(
        code: 'INVALID_PIN',
        message: 'PIN salah',
        details: {'attempts_left': 4},
        statusCode: 422,
        kind: DataErrorKind.api,
      ));

      await cubit.payWithWallet('111111');

      final state = cubit.state as CheckoutReady;
      expect(state.pinError?.code, 'INVALID_PIN');
      expect(state.actionError, isNull);
      expect(state.isSubmitting, isFalse);

      repository.calls.clear();
      await cubit.close();
      await Future<void>.delayed(Duration.zero);
      expect(repository.calls, contains('cancel:sesi-1'),
          reason: 'reservasi masih milik sesi yang belum dikonfirmasi');
    });

    test('INSUFFICIENT_BALANCE dari server → actionError + saldo dimuat ulang',
        () async {
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.confirmResult =
          DataFailed(_error(ApiErrorCode.insufficientBalance));
      final before = repository.walletCalls.length;

      await cubit.payWithWallet('123456');
      await Future<void>.delayed(Duration.zero);

      expect(repository.walletCalls.length, before + 1);
      await cubit.close();
    });

    test('pembayaran kedua diabaikan selagi yang pertama berjalan', () async {
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.calls.clear();

      await Future.wait([
        cubit.payWithWallet('123456'),
        cubit.payWithWallet('123456'),
      ]);

      expect(repository.calls.where((c) => c.startsWith('confirm:')).length, 1);
      await cubit.close();
    });

    test('PIN bukan 6 digit ditolak lokal', () async {
      final cubit = CheckoutCubit();
      await _start(cubit);
      repository.calls.clear();

      await cubit.payWithWallet('12a4');

      expect(repository.calls, isEmpty);
      expect((cubit.state as CheckoutReady).pinError?.code,
          ClientErrorCode.localValidation);
      await cubit.close();
    });
  });

  group('top up dari checkout', () {
    setUp(() => repository.walletResult = const DataSuccess(_short));

    test('di bawah Rp 10.000 ditolak lokal', () async {
      final cubit = CheckoutCubit();
      await _start(cubit);

      await cubit.startTopup(5000);

      expect(wallets.topups, isEmpty);
      expect((cubit.state as CheckoutReady).actionError?.code,
          ClientErrorCode.localValidation);
      await cubit.close();
    });

    test('berhasil → transaksi menunggu dibuka, lalu saldo dimuat ulang',
        () async {
      final cubit = CheckoutCubit();
      await _start(cubit);

      await cubit.startTopup(2299000);
      expect(wallets.topups, [2299000]);
      expect((cubit.state as CheckoutReady).pendingTopupTxId, 77);

      final before = repository.walletCalls.length;
      cubit.topupHandled();
      expect((cubit.state as CheckoutReady).pendingTopupTxId, isNull);
      await cubit.reloadWallet();
      expect(repository.walletCalls.length, before + 1);
      await cubit.close();
    });
  });

  test('saran top up: selisih dibulatkan ke atas, tak pernah di bawah minimum',
      () {
    expect(
        const WalletSummaryModel(shortfall: 2298500.5).suggestedTopup, 2299000);
    expect(const WalletSummaryModel(shortfall: 1200).suggestedTopup, 10000);
  });
}
