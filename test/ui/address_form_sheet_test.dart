/// Formulir alamat + master lokasi (`GET /locations/*`).
///
/// Yang dipatok: urutan tujuh kolom tetap (test integrasi mengetik ke kolom
/// menurut indeks), memilih kota dari daftar mengisi provinsinya dan
/// mengirim `city_id`, dan mengetik ulang kota melepas `city_id` — teks bebas
/// tetap sah karena master baru berisi 15 kota.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/location/location_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/location_repository.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/generated/l10n.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';
import 'package:marketplace_app_member/ui/main/address/screens/address_form_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Addresses implements AddressRepository {
  AddressDraft? created;
  AddressDraft? updated;

  @override
  Future<DataState<List<AddressModel>>> fetchAddresses() async => const DataEmpty();

  @override
  Future<DataState<List<AddressModel>>> create(AddressDraft draft) async {
    created = draft;
    return const DataSuccess([AddressModel(id: 1)]);
  }

  @override
  Future<DataState<List<AddressModel>>> update(int id, AddressDraft draft) async {
    updated = draft;
    return const DataSuccess([AddressModel(id: 1)]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Locations implements LocationRepository {
  final List<String> calls = [];

  @override
  Future<DataState<List<ProvinceModel>>> fetchProvinces() async {
    calls.add('provinces');
    return const DataSuccess([
      ProvinceModel(id: 3, name: 'Jawa Barat'),
      ProvinceModel(id: 4, name: 'Jawa Timur'),
    ]);
  }

  @override
  Future<DataState<List<CityModel>>> fetchCities({int? provinceId}) async {
    calls.add('cities:${provinceId ?? 'all'}');
    const all = [
      CityModel(id: 12, name: 'Bandung', provinceId: 3),
      CityModel(id: 20, name: 'Surabaya', provinceId: 4),
    ];
    return DataSuccess(
        provinceId == null ? all : all.where((c) => c.provinceId == provinceId).toList());
  }
}

late _Addresses _addresses;
late _Locations _locations;

Future<void> _open(WidgetTester tester, {AddressModel? existing}) async {
  tester.view.physicalSize = const Size(390, 844) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider(
      create: (_) => AddressCubit()..load(),
      child: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => AddressFormSheet.show(context, existing: existing),
              child: const Text('buka'),
            ),
          ),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
  await tester.tap(find.text('buka'));
  await tester.pumpAndSettle();
}

Finder _field(int index) => find.byType(TextFormField).at(index);

String _text(WidgetTester tester, int index) =>
    tester.widget<TextFormField>(_field(index)).controller!.text;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    _addresses = _Addresses();
    _locations = _Locations();
    injector
      ..registerSingleton<AddressRepository>(_addresses)
      ..registerSingleton<LocationRepository>(_locations);
  });

  tearDown(() => injector.reset());

  testWidgets('tujuh kolom dengan urutan tetap; master tidak ditembak sebelum dipakai',
      (tester) async {
    await _open(tester);
    expect(find.text('Tambah Alamat'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(7));
    expect(find.widgetWithText(FilledButton, 'Simpan'), findsOneWidget);
    expect(_locations.calls, isEmpty);
  });

  testWidgets('memilih kota mengisi provinsi dan mengirim city_id', (tester) async {
    await _open(tester);

    await tester.tap(find.byTooltip('Pilih kota dari daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Kota/Kabupaten'), findsOneWidget);
    await tester.tap(find.text('Bandung'));
    await tester.pumpAndSettle();

    expect(_text(tester, 4), 'Bandung');
    expect(_text(tester, 5), 'Jawa Barat');

    await tester.enterText(_field(1), 'Budi');
    await tester.enterText(_field(2), '08123456789');
    await tester.enterText(_field(3), 'Jl. Melati 1');
    await tester.enterText(_field(6), '40111');
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(_addresses.created?.cityId, 12);
    expect(_addresses.created?.city, 'Bandung');
    expect(_addresses.created?.province, 'Jawa Barat');
  });

  testWidgets('mengetik ulang kota melepas city_id (teks bebas tetap sah)', (tester) async {
    await _open(
      tester,
      existing: const AddressModel(
        id: 9,
        label: 'Rumah',
        recipientName: 'Budi',
        phone: '0812',
        fullAddress: 'Jl. A',
        city: 'Bandung',
        province: 'Jawa Barat',
        postalCode: '40111',
        cityId: 12,
      ),
    );

    await tester.enterText(_field(4), 'Cimahi');
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(_addresses.updated?.city, 'Cimahi');
    expect(_addresses.updated?.cityId, isNull);
  });

  testWidgets('memilih provinsi menyaring daftar kota', (tester) async {
    await _open(tester);

    await tester.tap(find.byTooltip('Pilih provinsi dari daftar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jawa Timur'));
    await tester.pumpAndSettle();
    expect(_text(tester, 5), 'Jawa Timur');

    await tester.tap(find.byTooltip('Pilih kota dari daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Surabaya'), findsOneWidget);
    expect(find.text('Bandung'), findsNothing);
    expect(_locations.calls, contains('cities:4'));
  });
}
