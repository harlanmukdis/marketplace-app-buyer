import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl(this._service);

  final AddressService _service;

  @override
  Future<DataState<List<AddressModel>>> fetchAddresses() => _readBack();

  @override
  Future<DataState<List<AddressModel>>> create(AddressDraft draft) =>
      _mutateThenRead(() => _service.create(
            label: draft.label,
            recipientName: draft.recipientName,
            phone: draft.phone,
            fullAddress: draft.fullAddress,
            city: draft.city,
            province: draft.province,
            postalCode: draft.postalCode,
            isPrimary: draft.isPrimary,
            latitude: draft.latitude,
            longitude: draft.longitude,
            cityId: draft.cityId,
          ));

  @override
  Future<DataState<List<AddressModel>>> update(int id, AddressDraft draft) =>
      _mutateThenRead(() => _service.update(
            id,
            label: draft.label,
            recipientName: draft.recipientName,
            phone: draft.phone,
            fullAddress: draft.fullAddress,
            city: draft.city,
            province: draft.province,
            postalCode: draft.postalCode,
            isPrimary: draft.isPrimary,
            latitude: draft.latitude,
            longitude: draft.longitude,
            cityId: draft.cityId,
            includeCityId: true,
          ));

  @override
  Future<DataState<List<AddressModel>>> delete(int id) =>
      _mutateThenRead(() => _service.delete(id));

  /// Menandai satu alamat sebagai utama, **dan melepas tanda itu dari yang
  /// lain**.
  ///
  /// Server tidak melakukannya: menyetel `is_primary: 1` pada alamat kedua
  /// membiarkan alamat pertama tetap bertanda utama, sehingga daftar bisa
  /// punya beberapa "utama" sekaligus. Kerapian itu ditegakkan di sini —
  /// sekali, di satu tempat — daripada dibiarkan bocor ke setiap layar yang
  /// menampilkan alamat.
  @override
  Future<DataState<List<AddressModel>>> setPrimary(int id) async {
    final current = await fetchAddresses();
    if (current is! DataSuccess<List<AddressModel>>) return current;

    try {
      await _service.update(id, isPrimary: true);
      for (final address in current.data) {
        if (address.id != id && address.isPrimary) {
          await _service.update(address.id, isPrimary: false);
        }
      }
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return _readBack();
  }

  Future<DataState<List<AddressModel>>> _mutateThenRead(
    Future<Object?> Function() mutate,
  ) async {
    try {
      await mutate();
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return _readBack();
  }

  Future<DataState<List<AddressModel>>> _readBack() async {
    try {
      final env = await _service.list();
      // Daftar kosong dikembalikan sebagai DataSuccess, bukan DataEmpty:
      // "belum punya alamat" adalah keadaan normal yang layarnya tangani
      // dengan ajakan menambah, bukan keadaan kosong yang perlu dibedakan.
      return DataSuccess(env.data, meta: env.meta, statusCode: env.statusCode);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }
}
