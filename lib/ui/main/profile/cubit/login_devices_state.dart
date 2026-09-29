part of 'login_devices_cubit.dart';

@freezed
sealed class LoginDevicesState with _$LoginDevicesState {
  /// Nilai [LoginDevicesReady.revokingKey] saat "keluar dari semua perangkat
  /// lain" sedang berjalan.
  static const String allOthersKey = '*';

  const factory LoginDevicesState.loading() = LoginDevicesLoading;

  const factory LoginDevicesState.ready({
    required List<LoginDevice> devices,

    /// [LoginDevice.key] yang sedang dicabut. Satu per satu: `php -S`
    /// single-threaded dan setiap perangkat bisa berisi banyak sesi.
    String? revokingKey,
    DataError? actionError,
  }) = LoginDevicesReady;

  const factory LoginDevicesState.error(DataError error) = LoginDevicesError;
}
