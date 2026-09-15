import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'address_cubit.freezed.dart';
part 'address_state.dart';

/// Daftar alamat pengiriman.
///
/// ⚠️ **Kelengkapan alamat divalidasi di sini, bukan di server.** `POST
/// /me/addresses` dengan field kosong dibalas `201` dan benar-benar tersimpan
/// — alamat semacam itu baru terasa salah saat paket tidak bisa dikirim. Jadi
/// [save] menolak draft yang belum lengkap sebelum menyentuh jaringan.
class AddressCubit extends Cubit<AddressState> {
  AddressCubit()
      : _repository = injector<AddressRepository>(),
        super(const AddressState.loading());

  static AddressCubit get(BuildContext context) => BlocProvider.of(context);

  final AddressRepository _repository;

  Future<void> load() async {
    emit(const AddressState.loading());
    final result = await _repository.fetchAddresses();
    if (isClosed) return;
    _applyList(result);
  }

  /// Menyimpan alamat baru ([id] null) atau memperbarui yang ada.
  ///
  /// Mengembalikan `true` kalau tersimpan, supaya pemanggil (mis. lembar
  /// formulir) tahu kapan boleh menutup dirinya. Draft yang belum lengkap
  /// ditolak tanpa request, dan alasannya dilaporkan lewat
  /// [AddressReady.actionError].
  Future<bool> save(AddressDraft draft, {int? id}) async {
    if (!draft.isComplete) {
      _emitActionError(DataError(
        code: ApiErrorCode.validationError,
        message: 'Lengkapi dulu: ${draft.missingFields.join(', ')}',
        kind: DataErrorKind.api,
      ));
      return false;
    }

    final result = await _guardSaving(
      () => id == null
          ? _repository.create(draft)
          : _repository.update(id, draft),
    );
    return result;
  }

  Future<bool> remove(int id) => _guardSaving(() => _repository.delete(id));

  /// Menandai satu alamat sebagai utama; repository yang melepas tanda pada
  /// alamat lain, karena server tidak melakukannya.
  Future<bool> setPrimary(int id) =>
      _guardSaving(() => _repository.setPrimary(id));

  void clearActionError() {
    final current = state;
    if (current is! AddressReady || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  Future<bool> _guardSaving(
    Future<DataState<List<AddressModel>>> Function() action,
  ) async {
    final current = state;
    if (current is AddressReady) {
      if (current.isSaving) return false;
      emit(current.copyWith(isSaving: true, actionError: null));
    }

    final result = await action();
    if (isClosed) return false;

    if (result is DataFailed<List<AddressModel>>) {
      _emitActionError(result.error);
      return false;
    }
    _applyList(result);
    return true;
  }

  void _applyList(DataState<List<AddressModel>> result) {
    switch (result) {
      case DataSuccess(:final data):
        emit(AddressState.ready(addresses: data));
      case DataEmpty():
        emit(const AddressState.ready());
      case DataFailed(:final error):
        emit(AddressState.error(error));
      case DataLoading():
        break;
    }
  }

  /// Melaporkan kegagalan aksi tanpa membuang daftar yang sudah tampil.
  void _emitActionError(DataError error) {
    final current = state;
    if (current is AddressReady) {
      emit(current.copyWith(isSaving: false, actionError: error));
    } else {
      emit(AddressState.error(error));
    }
  }
}
