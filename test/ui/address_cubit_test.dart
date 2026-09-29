/// Perilaku [AddressCubit] terhadap repository palsu.
///
/// Fokusnya aturan yang **tidak ditegakkan server**: batas 3 alamat
/// (docs/22 #9) dan kelengkapan alamat — `POST /me/addresses` menerima
/// keduanya apa adanya.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';

AddressModel _address(int id) => AddressModel(
      id: id,
      label: 'Rumah',
      recipientName: 'Budi',
      phone: '081234567890',
      fullAddress: 'Jl. Melati $id',
      city: 'Jakarta Selatan',
      province: 'DKI Jakarta',
      postalCode: '12430',
    );

const _completeDraft = AddressDraft(
  recipientName: 'Budi',
  phone: '081234567890',
  fullAddress: 'Jl. Mawar 1',
  city: 'Bandung',
  province: 'Jawa Barat',
  postalCode: '40111',
);

class _FakeAddressRepository implements AddressRepository {
  List<AddressModel> addresses = [];
  final List<String> calls = [];

  DataState<List<AddressModel>> _list() => DataSuccess(List.of(addresses));

  @override
  Future<DataState<List<AddressModel>>> fetchAddresses() async {
    calls.add('fetch');
    return _list();
  }

  @override
  Future<DataState<List<AddressModel>>> create(AddressDraft draft) async {
    calls.add('create');
    addresses.add(_address(addresses.length + 100));
    return _list();
  }

  @override
  Future<DataState<List<AddressModel>>> update(
      int id, AddressDraft draft) async {
    calls.add('update:$id');
    return _list();
  }

  @override
  Future<DataState<List<AddressModel>>> delete(int id) async {
    calls.add('delete:$id');
    addresses.removeWhere((a) => a.id == id);
    return _list();
  }

  @override
  Future<DataState<List<AddressModel>>> setPrimary(int id) async {
    calls.add('primary:$id');
    return _list();
  }
}

void main() {
  late _FakeAddressRepository repository;

  setUp(() {
    repository = _FakeAddressRepository();
    injector.registerSingleton<AddressRepository>(repository);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('batas 3 alamat', () {
    test('alamat keempat DITOLAK tanpa request ke server', () async {
      repository.addresses = [_address(1), _address(2), _address(3)];
      final cubit = AddressCubit();
      await cubit.load();

      final saved = await cubit.save(_completeDraft);

      expect(saved, isFalse);
      expect(repository.calls, isNot(contains('create')));
      final state = cubit.state as AddressReady;
      expect(state.addresses, hasLength(3));
      // Kode validasi lokal: satu-satunya yang pesannya boleh tampil.
      expect(state.actionError?.code, ClientErrorCode.localValidation);
      expect(state.actionError?.message, contains('Maksimal 3 alamat'));
      expect(state.canAddMore, isFalse);
      expect(state.remainingSlots, 0);
      await cubit.close();
    });

    test('mengubah alamat yang ada tetap boleh saat kuota penuh', () async {
      repository.addresses = [_address(1), _address(2), _address(3)];
      final cubit = AddressCubit();
      await cubit.load();

      final saved = await cubit.save(_completeDraft, id: 2);

      expect(saved, isTrue);
      expect(repository.calls, contains('update:2'));
      await cubit.close();
    });

    test('alamat ketiga masih diterima, lalu kuotanya habis', () async {
      repository.addresses = [_address(1), _address(2)];
      final cubit = AddressCubit();
      await cubit.load();
      expect(cubit.state.remainingSlots, 1);

      final saved = await cubit.save(_completeDraft);

      expect(saved, isTrue);
      expect(repository.calls, contains('create'));
      expect(cubit.state.remainingSlots, 0);
      await cubit.close();
    });

    test('menghapus satu alamat membuka slot lagi', () async {
      repository.addresses = [_address(1), _address(2), _address(3)];
      final cubit = AddressCubit();
      await cubit.load();

      await cubit.remove(1);

      expect(cubit.state.canAddMore, isTrue);
      expect(cubit.state.remainingSlots, 1);
      await cubit.close();
    });
  });

  test('draft tak lengkap ditolak dengan nama field berbahasa Indonesia',
      () async {
    final cubit = AddressCubit();
    await cubit.load();

    final saved = await cubit.save(const AddressDraft(recipientName: 'Budi'));

    expect(saved, isFalse);
    expect(repository.calls, isNot(contains('create')));
    final error = (cubit.state as AddressReady).actionError!;
    expect(error.code, ClientErrorCode.localValidation);
    expect(error.message, contains('nomor telepon'));
    expect(error.message, isNot(contains('postal_code')));
    await cubit.close();
  });
}
