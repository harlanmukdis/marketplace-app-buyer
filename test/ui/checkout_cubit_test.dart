/// Perilaku [CheckoutCubit] terhadap repository palsu.
///
/// Fokusnya pada keputusan yang mahal kalau salah: sesi checkout **menahan
/// stok di server**, jadi yang diuji terutama kapan sesi dibatalkan dan kapan
/// tidak.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/checkout/cubit/checkout_cubit.dart';

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

class _FakeCheckoutRepository implements CheckoutRepository {
  DataState<CheckoutSnapshot> snapshotResult = DataSuccess(_snapshot());
  DataState<CheckoutConfirmResult> confirmResult =
      const DataSuccess(CheckoutConfirmResult(orderIds: [1, 2]));

  final List<String> calls = [];
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
    required String paymentMethod,
  }) async {
    calls.add('confirm:$sessionId');
    return confirmResult;
  }

  @override
  Future<DataState<void>> cancelSession(String sessionId) async {
    calls.add('cancel:$sessionId');
    return const DataSuccess(null);
  }
}

void main() {
  late _FakeCheckoutRepository repository;

  setUp(() {
    repository = _FakeCheckoutRepository();
    injector.registerSingleton<CheckoutRepository>(repository);
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
      await cubit.start(addressId: 5);
      repository.snapshotResult = DataSuccess(_snapshot(couriers: {
        '1': {'courier_code': 'jnt', 'service_code': 'ez'},
        '2': {'courier_code': 'jne', 'service_code': 'reg'},
      }));
      await cubit.refresh();
      await cubit.confirm(paymentMethod: 'qris');
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
    test('membatalkan sesi lama LALU membuat sesi baru', () async {
      // PATCH .../address rusak di server, jadi ini satu-satunya cara. Urutan
      // penting: tanpa cancel lebih dulu, stok yang sama tertahan dua kali
      // dan sesi baru bisa gagal karena "habis" oleh sesi user sendiri.
      final cubit = CheckoutCubit();
      await cubit.start(addressId: 5);
      repository.calls.clear();

      await cubit.changeAddress(9);

      expect(repository.calls, ['cancel:sesi-1', 'start:9']);
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
      await cubit.start(addressId: 5);
      repository.calls.clear();

      await cubit.confirm(paymentMethod: 'qris');

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
      await cubit.start(addressId: 5);

      await cubit.confirm(paymentMethod: 'qris');

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
      await cubit.start(addressId: 5);
      repository.calls.clear();

      final first = cubit.confirm(paymentMethod: 'qris');
      final second = cubit.confirm(paymentMethod: 'qris');
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
      await cubit.start(addressId: 5);
      repository.confirmResult =
          DataFailed(_error(ApiErrorCode.stockInsufficient));

      await cubit.confirm(paymentMethod: 'qris');

      final state = cubit.state as CheckoutReady;
      expect(state.actionError?.code, ApiErrorCode.stockInsufficient);
      await cubit.close();
    });
  });
}
