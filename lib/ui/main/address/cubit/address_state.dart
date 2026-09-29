part of 'address_cubit.dart';

/// Status daftar alamat.
///
/// Tidak ada cabang khusus "kosong": daftar kosong adalah [AddressReady]
/// dengan `addresses` kosong, dan layarnya menampilkan ajakan menambah. Itu
/// membuat tombol "tambah alamat" tetap ada di keadaan mana pun.
@freezed
sealed class AddressState with _$AddressState {
  const AddressState._();

  const factory AddressState.loading() = AddressLoading;

  const factory AddressState.ready({
    @Default(<AddressModel>[]) List<AddressModel> addresses,

    /// Sedang mengirim perubahan (tambah/ubah/hapus/set utama).
    @Default(false) bool isSaving,

    /// Kegagalan aksi terakhir; isi daftar tetap dipertahankan.
    DataError? actionError,
  }) = AddressReady;

  const factory AddressState.error(DataError error) = AddressError;

  /// Alamat utama yang dipakai checkout sebagai tujuan default.
  ///
  /// Dipilih lewat `primaryAddressOf` karena server membolehkan beberapa
  /// alamat bertanda utama sekaligus.
  AddressModel? get primary => switch (this) {
        AddressReady(:final addresses) => primaryAddressOf(addresses),
        _ => null,
      };

  /// Sisa slot alamat sebelum batas [AddressCubit.maxAddresses].
  int get remainingSlots => switch (this) {
        AddressReady(:final addresses) =>
          (AddressCubit.maxAddresses - addresses.length)
              .clamp(0, AddressCubit.maxAddresses),
        _ => 0,
      };

  bool get canAddMore => this is AddressReady && remainingSlots > 0;

  /// Alamat yang benar-benar bisa dipakai mengirim barang.
  ///
  /// Server menerima alamat berisi field kosong, jadi daftar ini bisa lebih
  /// pendek dari [AddressReady.addresses] — dan checkout hanya boleh
  /// menawarkan yang ada di sini.
  List<AddressModel> get usable => switch (this) {
        AddressReady(:final addresses) =>
          addresses.where((a) => a.isComplete).toList(),
        _ => const [],
      };
}
