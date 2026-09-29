import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';

/// Alamat pengiriman milik user.
///
/// Sama seperti keranjang, setiap mutasi mengembalikan **daftar hasil baca
/// ulang**, bukan `void`: `PATCH` membalas `data: null`, jadi tidak ada cara
/// lain mengetahui keadaan sesudahnya.
abstract class AddressRepository {
  Future<DataState<List<AddressModel>>> fetchAddresses();

  /// Menambah alamat.
  ///
  /// ⚠️ Server menerima alamat dengan field kosong, jadi pemanggil wajib
  /// memvalidasi kelengkapan lebih dulu — `AddressModel.isComplete`
  /// merangkumnya.
  Future<DataState<List<AddressModel>>> create(AddressDraft draft);

  Future<DataState<List<AddressModel>>> update(int id, AddressDraft draft);

  Future<DataState<List<AddressModel>>> delete(int id);

  /// Menandai satu alamat sebagai utama.
  ///
  /// ⚠️ Server **tidak** melepas tanda pada alamat lain, sehingga bisa ada
  /// beberapa alamat bertanda utama sekaligus. Implementasinya melepas tanda
  /// itu satu per satu di sisi aplikasi.
  Future<DataState<List<AddressModel>>> setPrimary(int id);
}

/// Isian formulir alamat.
///
/// Dipisahkan dari [AddressModel] karena yang dikirim ke server tidak punya
/// `id`, `user_id`, maupun `created_at` — dan supaya formulir tidak perlu
/// merakit model yang separuh fieldnya karangan.
class AddressDraft {
  const AddressDraft({
    this.label = 'Rumah',
    this.recipientName = '',
    this.phone = '',
    this.fullAddress = '',
    this.city = '',
    this.province = '',
    this.postalCode = '',
    this.isPrimary = false,
    this.latitude,
    this.longitude,
    this.cityId,
  });

  final String label;
  final String recipientName;
  final String phone;
  final String fullAddress;
  final String city;
  final String province;
  final String postalCode;
  final bool isPrimary;
  final double? latitude;
  final double? longitude;

  /// Id `master_cities` kalau kota dipilih dari daftar; `null` untuk teks
  /// bebas. Tetap sah: master lokasi di seed baru berisi 15 kota.
  final int? cityId;

  factory AddressDraft.from(AddressModel address) => AddressDraft(
        label: address.label,
        recipientName: address.recipientName,
        phone: address.phone,
        fullAddress: address.fullAddress,
        city: address.city,
        province: address.province,
        postalCode: address.postalCode,
        isPrimary: address.isPrimary,
        latitude: address.latitude,
        longitude: address.longitude,
        cityId: address.cityId,
      );

  /// Field yang masih kosong, untuk ditandai di formulir.
  ///
  /// Kosong berarti siap dikirim. Server sendiri tidak memeriksa apa pun.
  Set<String> get missingFields => {
        if (recipientName.trim().isEmpty) 'recipient_name',
        if (phone.trim().isEmpty) 'phone',
        if (fullAddress.trim().isEmpty) 'full_address',
        if (city.trim().isEmpty) 'city',
        if (province.trim().isEmpty) 'province',
        if (postalCode.trim().isEmpty) 'postal_code',
      };

  bool get isComplete => missingFields.isEmpty;
}
