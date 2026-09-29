import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'location_models.freezed.dart';
part 'location_models.g.dart';

/// Satu provinsi dari `GET /locations/provinces` (publik).
///
/// ⚠️ **Konvensi kolomnya berbeda dari seluruh API**: `province_name`,
/// `active`, `created_date` — bukan `name`, `is_active`, `created_at`. Tabel
/// master lokasi memakai kolom audit gaya lain (`created_by`/`modified_by`).
@freezed
abstract class ProvinceModel with _$ProvinceModel {
  const factory ProvinceModel({
    @IntJson() required int id,
    @StringJson() @JsonKey(name: 'province_name') @Default('') String name,
    @BoolJson() @Default(true) bool active,
  }) = _ProvinceModel;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) =>
      _$ProvinceModelFromJson(json);
}

/// Satu kota/kabupaten dari `GET /locations/cities?province_id=`.
///
/// Id-nya yang dikirim sebagai `city_id` di alamat — kolom FK opsional yang
/// menempel ke master ini. Teks `city`/`province` tetap wajib dikirim:
/// checkout dan ongkir masih membaca teksnya, bukan `city_id`.
@freezed
abstract class CityModel with _$CityModel {
  const factory CityModel({
    @IntJson() required int id,
    @StringJson() @JsonKey(name: 'city_name') @Default('') String name,
    @IntJson() @JsonKey(name: 'province_id') @Default(0) int provinceId,
    @BoolJson() @Default(true) bool active,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
}
