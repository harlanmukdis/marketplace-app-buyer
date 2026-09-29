import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

/// Panggilan HTTP untuk `/me/addresses`.
///
/// ⚠️ **Path-nya `/me/addresses`, bukan `/addresses`.** Yang terakhir milik
/// backend lama dan tidak terdaftar di marketplace-api.
///
/// ⚠️ **Server tidak memvalidasi field wajib.** `POST` dengan hanya
/// `recipient_name` dibalas `201` dan menyimpan alamat berisi kota, provinsi,
/// kode pos, dan telepon kosong. Validasi ada di lapisan UI.
///
/// Seperti keranjang, `PATCH` membalas `data: null` — tidak ada alamat hasil
/// perubahan yang bisa dipakai, jadi pemanggil harus membaca ulang [list].
class AddressService {
  AddressService(this._dio);

  final Dio _dio;

  Future<ApiEnvelope<List<AddressModel>>> list() async {
    const context = 'GET /me/addresses';
    try {
      final response = await _dio.get<dynamic>('/me/addresses');
      return parseEnvelopeList(response, AddressModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/addresses` → id alamat baru.
  ///
  /// Nama field wajib persis seperti di bawah. Mengirim nama ala backend lama
  /// (`address_line`, `district`, `is_default`) membuat server membalas
  /// **500 halaman HTML**, karena field asing diteruskan mentah ke `INSERT`.
  Future<ApiEnvelope<int>> create({
    required String label,
    required String recipientName,
    required String phone,
    required String fullAddress,
    required String city,
    required String province,
    required String postalCode,
    bool isPrimary = false,
    double? latitude,
    double? longitude,
    int? cityId,
  }) async {
    const context = 'POST /me/addresses';
    try {
      final response = await _dio.post<dynamic>(
        '/me/addresses',
        data: _body(
          label: label,
          recipientName: recipientName,
          phone: phone,
          fullAddress: fullAddress,
          city: city,
          province: province,
          postalCode: postalCode,
          isPrimary: isPrimary,
          latitude: latitude,
          longitude: longitude,
          cityId: cityId,
          includeCityId: cityId != null,
        ),
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `PATCH /me/addresses/{id}` — pembaruan sebagian; field yang tidak dikirim
  /// dibiarkan apa adanya. Balasannya `data: null`.
  Future<ApiEnvelope<dynamic>> update(
    int id, {
    String? label,
    String? recipientName,
    String? phone,
    String? fullAddress,
    String? city,
    String? province,
    String? postalCode,
    bool? isPrimary,
    double? latitude,
    double? longitude,
    int? cityId,
    bool includeCityId = false,
  }) async {
    final context = 'PATCH /me/addresses/$id';
    try {
      final response = await _dio.patch<dynamic>(
        '/me/addresses/$id',
        data: _body(
          label: label,
          recipientName: recipientName,
          phone: phone,
          fullAddress: fullAddress,
          city: city,
          province: province,
          postalCode: postalCode,
          isPrimary: isPrimary,
          latitude: latitude,
          longitude: longitude,
          cityId: cityId,
          includeCityId: includeCityId,
        ),
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<dynamic>> delete(int id) async {
    final context = 'DELETE /me/addresses/$id';
    try {
      final response = await _dio.delete<dynamic>('/me/addresses/$id');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// Menyusun body, membuang field yang `null` supaya `PATCH` benar-benar
  /// parsial dan tidak menimpa kolom lain dengan kosong.
  ///
  /// `city_id` pengecualian: dengan [includeCityId] ia dikirim **walau
  /// `null`**, supaya kota yang diganti ke teks bebas melepas tautan master
  /// lamanya — kalau tidak, alamat menyimpan teks "Bogor" dengan `city_id`
  /// milik Bandung.
  Map<String, dynamic> _body({
    String? label,
    String? recipientName,
    String? phone,
    String? fullAddress,
    String? city,
    String? province,
    String? postalCode,
    bool? isPrimary,
    double? latitude,
    double? longitude,
    int? cityId,
    bool includeCityId = false,
  }) {
    return <String, dynamic>{
      if (label != null) 'label': label,
      if (recipientName != null) 'recipient_name': recipientName,
      if (phone != null) 'phone': phone,
      if (fullAddress != null) 'full_address': fullAddress,
      if (city != null) 'city': city,
      if (province != null) 'province': province,
      if (postalCode != null) 'postal_code': postalCode,
      // tinyint: kirim 1/0, bukan true/false.
      if (isPrimary != null) 'is_primary': isPrimary ? 1 : 0,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (includeCityId) 'city_id': cityId,
    };
  }
}
