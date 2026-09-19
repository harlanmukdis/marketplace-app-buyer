import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'shipping_estimate_cubit.freezed.dart';
part 'shipping_estimate_state.dart';

/// Estimasi ongkir di halaman produk.
///
/// **Kenapa ini layak ada padahal checkout sudah menghitung ongkir:** satu-
/// satunya cara lain mengetahui ongkir adalah `POST /checkout/sessions`, yang
/// **mereservasi stok 15 menit**. Memakainya untuk sekadar mengintip ongkir
/// berarti menahan stok orang lain setiap kali seseorang penasaran.
///
/// ⚠️ **Ini informasi pelengkap, bukan tujuan halaman.** Karena itu hampir
/// semua kegagalan berakhir sebagai [ShippingEstimateHidden] — belum masuk,
/// belum punya alamat, atau jaringan bermasalah tidak layak memunculkan
/// spanduk error di halaman produk. Yang tetap ditampilkan hanya dua keadaan
/// yang **menjawab pertanyaan user**: ada ongkirnya, atau tidak ada kurir yang
/// melayani alamat itu.
class ShippingEstimateCubit extends Cubit<ShippingEstimateState> {
  ShippingEstimateCubit(this.productId)
      : _catalog = injector<CatalogRepository>(),
        _addresses = injector<AddressRepository>(),
        super(const ShippingEstimateState.hidden());

  static ShippingEstimateCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final int productId;
  final CatalogRepository _catalog;
  final AddressRepository _addresses;

  /// Alamat yang dipakai, dimuat sekali lalu ditahan supaya berganti varian
  /// tidak menembak `/me/addresses` lagi.
  AddressModel? _address;
  bool _addressLoaded = false;

  /// Memuat estimasi untuk [variantId].
  ///
  /// Dipanggil ulang setiap varian berganti: berat dan gudang asal berbeda per
  /// varian, jadi ongkirnya pun berbeda.
  Future<void> load({int? variantId}) async {
    final address = await _resolveAddress();
    if (isClosed) return;

    if (address == null) {
      // Belum masuk, belum punya alamat, atau alamatnya belum lengkap —
      // ketiganya bukan error yang perlu diberitakan di halaman produk.
      emit(const ShippingEstimateState.hidden());
      return;
    }

    emit(ShippingEstimateState.loading(address: address));

    final result = await _catalog.fetchShippingEstimate(
      productId,
      addressId: address.id,
      variantId: variantId,
    );
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(ShippingEstimateState.ready(address: address, options: data));
      case DataEmpty():
        // Sejak backend menyaring kurir menurut `store_couriers`, nol opsi
        // adalah jawaban yang sah — dan justru penting diketahui sebelum user
        // menambahkan barangnya ke keranjang.
        emit(ShippingEstimateState.unavailable(address: address));
      case DataFailed(:final error):
        // Stok habis sudah diberitakan indikator stok di halaman yang sama,
        // jadi tidak perlu diulang di sini.
        emit(const ShippingEstimateState.hidden());
        _lastError = error;
      case DataLoading():
        break;
    }
  }

  /// Error terakhir, disimpan hanya untuk keperluan diagnosis — tidak pernah
  /// ditampilkan.
  DataError? _lastError;
  DataError? get lastError => _lastError;

  /// Mengambil alamat utama, sekali saja.
  ///
  /// Memakai `primaryAddressOf` yang sama dengan checkout supaya ongkir yang
  /// diintip di halaman produk memakai alamat yang sama dengan yang nanti
  /// dipakai membayar — kalau berbeda, angkanya berubah tanpa penjelasan.
  Future<AddressModel?> _resolveAddress() async {
    if (_addressLoaded) return _address;
    _addressLoaded = true;

    final result = await _addresses.fetchAddresses();
    if (isClosed) return null;

    if (result case DataSuccess(:final data)) {
      final chosen = primaryAddressOf(data);
      // Alamat tak lengkap tidak dipakai: checkout pun menolaknya, jadi
      // ongkirnya akan menyesatkan.
      _address = (chosen != null && chosen.isComplete) ? chosen : null;
    }
    return _address;
  }
}
