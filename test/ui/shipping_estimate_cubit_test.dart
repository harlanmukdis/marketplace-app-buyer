/// Perilaku [ShippingEstimateCubit] terhadap repository palsu.
///
/// Fokusnya pada **kapan estimasi disembunyikan**: ini informasi pelengkap di
/// halaman produk, jadi belum masuk / belum punya alamat / jaringan gagal
/// tidak boleh memunculkan spanduk error. Yang tetap tampil hanya dua keadaan
/// yang menjawab pertanyaan user.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/shipping_estimate_cubit.dart';

import 'support/fake_catalog_repository.dart';

AddressModel _address({
  int id = 7,
  bool primary = true,
  String city = 'Jakarta Selatan',
  String fullAddress = 'Jl. Uji No. 1',
}) =>
    AddressModel(
      id: id,
      label: 'Rumah',
      recipientName: 'Uji',
      phone: '081200000000',
      fullAddress: fullAddress,
      city: city,
      province: 'DKI Jakarta',
      postalCode: '12810',
      isPrimary: primary,
    );

const _options = <ShippingOptionModel>[
  ShippingOptionModel(
    courierCode: 'sicepat',
    serviceCode: 'reg',
    serviceName: 'SiCepat Reguler',
    cost: 17500,
    etdMinDays: 3,
    etdMaxDays: 6,
  ),
  ShippingOptionModel(
    courierCode: 'jnt',
    serviceCode: 'ez',
    serviceName: 'J&T EZ',
    cost: 17000,
    etdMinDays: 3,
    etdMaxDays: 7,
  ),
];

DataError _error(String code) =>
    DataError(code: code, message: code, kind: DataErrorKind.api);

class _FakeAddressRepository implements AddressRepository {
  DataState<List<AddressModel>> result = DataSuccess([_address()]);
  int calls = 0;

  @override
  Future<DataState<List<AddressModel>>> fetchAddresses() async {
    calls++;
    return result;
  }

  @override
  Future<DataState<List<AddressModel>>> create(AddressDraft draft) async =>
      result;

  @override
  Future<DataState<List<AddressModel>>> update(
          int id, AddressDraft draft) async =>
      result;

  @override
  Future<DataState<List<AddressModel>>> delete(int id) async => result;

  @override
  Future<DataState<List<AddressModel>>> setPrimary(int id) async => result;
}

void main() {
  late FakeCatalogRepository catalog;
  late _FakeAddressRepository addresses;

  setUp(() {
    catalog = FakeCatalogRepository();
    addresses = _FakeAddressRepository();
    injector.registerSingleton<CatalogRepository>(catalog);
    injector.registerSingleton<AddressRepository>(addresses);
  });

  tearDown(() async {
    await injector.reset();
  });

  group('kapan disembunyikan', () {
    test('tanpa alamat sama sekali', () async {
      addresses.result = const DataEmpty();

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      expect(cubit.state, isA<ShippingEstimateHidden>());
      expect(catalog.estimateCalls, isEmpty,
          reason: 'tidak menembak estimasi tanpa alamat');
      await cubit.close();
    });

    test('gagal memuat alamat — mis. belum masuk', () async {
      addresses.result = DataFailed(_error('UNAUTHENTICATED'));

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      expect(cubit.state, isA<ShippingEstimateHidden>());
      await cubit.close();
    });

    test('alamat TIDAK LENGKAP tidak dipakai', () async {
      // Checkout pun menolaknya, jadi ongkirnya akan menyesatkan.
      addresses.result = DataSuccess([_address(fullAddress: '', city: '')]);

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      expect(cubit.state, isA<ShippingEstimateHidden>());
      expect(catalog.estimateCalls, isEmpty);
      await cubit.close();
    });

    test('estimasi gagal — termasuk stok habis — disembunyikan, bukan error',
        () async {
      // Stok habis sudah diberitakan indikator stok di halaman yang sama.
      catalog.estimateResult = DataFailed(_error('STOCK_INSUFFICIENT'));

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      expect(cubit.state, isA<ShippingEstimateHidden>());
      expect(cubit.lastError?.code, 'STOCK_INSUFFICIENT',
          reason: 'errornya disimpan untuk diagnosis, tapi tidak ditampilkan');
      await cubit.close();
    });
  });

  group('kapan ditampilkan', () {
    test('ada opsi → termurah dipakai sebagai "mulai dari"', () async {
      catalog.estimateResult = const DataSuccess(_options);

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      final state = cubit.state as ShippingEstimateReady;
      // Server mengurutkan termurah dulu, tapi cubit tidak bergantung padanya.
      expect(state.cheapest.cost, 17000);
      expect(state.cheapest.courierCode, 'jnt');
      expect(state.hasAlternatives, isTrue);
      expect(state.address.city, 'Jakarta Selatan');
      await cubit.close();
    });

    test('satu opsi saja tidak menawarkan "lihat pilihan lain"', () async {
      catalog.estimateResult = DataSuccess([_options.first]);

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      expect((cubit.state as ShippingEstimateReady).hasAlternatives, isFalse);
      await cubit.close();
    });

    test('NOL opsi kurir adalah jawaban, bukan kegagalan', () async {
      // Sejak backend menyaring kurir menurut `store_couriers`, ini mungkin —
      // dan penting diketahui sebelum barangnya masuk keranjang, karena
      // checkout akan buntu di pemilihan pengiriman.
      catalog.estimateResult = const DataEmpty();

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      expect(cubit.state, isA<ShippingEstimateUnavailable>());
      await cubit.close();
    });
  });

  group('alamat dan varian', () {
    test('alamat utama yang dipilih, bukan yang pertama', () async {
      // `primaryAddressOf` yang sama dengan checkout — kalau berbeda, ongkir
      // yang diintip di halaman produk tidak cocok dengan yang dibayar.
      addresses.result = DataSuccess([
        _address(id: 3, primary: false),
        _address(id: 9),
      ]);
      catalog.estimateResult = const DataSuccess(_options);

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);

      expect(catalog.estimateCalls.single.addressId, 9);
      await cubit.close();
    });

    test('ganti varian menghitung ulang TANPA memuat alamat lagi', () async {
      catalog.estimateResult = const DataSuccess(_options);

      final cubit = ShippingEstimateCubit(1);
      await cubit.load(variantId: 2);
      await cubit.load(variantId: 5);

      expect(addresses.calls, 1, reason: 'alamatnya ditahan');
      expect(catalog.estimateCalls.map((c) => c.variantId), [2, 5]);
      await cubit.close();
    });

    test('tanpa variantId server memakai varian pertama', () async {
      catalog.estimateResult = const DataSuccess(_options);

      final cubit = ShippingEstimateCubit(1);
      await cubit.load();

      expect(catalog.estimateCalls.single.variantId, isNull);
      await cubit.close();
    });
  });
}
