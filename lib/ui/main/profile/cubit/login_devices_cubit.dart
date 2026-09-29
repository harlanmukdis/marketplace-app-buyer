import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'login_devices_cubit.freezed.dart';
part 'login_devices_state.dart';

/// Perangkat yang sedang login — `GET`/`DELETE /me/sessions`, endpoint
/// **sungguhan**.
///
/// Perangkat ini sendiri tidak dicabut lewat sini: mencabut sesinya lewat
/// `DELETE` membiarkan token di perangkat tetap tersimpan, dan app baru sadar
/// saat refresh berikutnya gagal. Layar memakai `AuthCubit.logout()` untuk
/// itu, yang mencabut refresh token **dan** membersihkan perangkat.
class LoginDevicesCubit extends Cubit<LoginDevicesState> {
  LoginDevicesCubit()
      : _repository = injector<AccountRepository>(),
        super(const LoginDevicesState.loading());

  static LoginDevicesCubit get(BuildContext context) => BlocProvider.of(context);

  final AccountRepository _repository;

  Future<void> load() async {
    final result = await _repository.fetchDevices();
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => LoginDevicesState.ready(devices: data),
      DataFailed(:final error) => LoginDevicesState.error(error),
      _ => const LoginDevicesState.ready(devices: []),
    });
  }

  /// Mengeluarkan satu perangkat lain.
  Future<void> revoke(LoginDevice device) async {
    final current = state;
    if (current is! LoginDevicesReady || current.revokingKey != null || device.isCurrent) return;
    emit(current.copyWith(revokingKey: device.key, actionError: null));
    final result = await _repository.revokeDevice(device);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => LoginDevicesState.ready(devices: data),
      DataEmpty() => const LoginDevicesState.ready(devices: []),
      DataFailed(:final error) => current.copyWith(revokingKey: null, actionError: error),
      _ => current.copyWith(revokingKey: null),
    });
  }

  /// "Keluar dari semua perangkat lain".
  Future<void> revokeOthers() async {
    final current = state;
    if (current is! LoginDevicesReady || current.revokingKey != null) return;
    final others = current.devices.where((d) => !d.isCurrent).toList();
    if (others.isEmpty) return;
    emit(current.copyWith(revokingKey: LoginDevicesState.allOthersKey, actionError: null));
    DataState<List<LoginDevice>> result = const DataLoading();
    for (final device in others) {
      result = await _repository.revokeDevice(device);
      if (result is DataFailed) break;
    }
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => LoginDevicesState.ready(devices: data),
      DataEmpty() => const LoginDevicesState.ready(devices: []),
      DataFailed(:final error) => current.copyWith(revokingKey: null, actionError: error),
      _ => current.copyWith(revokingKey: null),
    });
  }
}
