// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProvinceModel _$ProvinceModelFromJson(Map<String, dynamic> json) =>
    _ProvinceModel(
      id: const IntJson().fromJson(json['id']),
      name: json['province_name'] == null
          ? ''
          : const StringJson().fromJson(json['province_name']),
      active: json['active'] == null
          ? true
          : const BoolJson().fromJson(json['active']),
    );

Map<String, dynamic> _$ProvinceModelToJson(_ProvinceModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'province_name': const StringJson().toJson(instance.name),
      'active': const BoolJson().toJson(instance.active),
    };

_CityModel _$CityModelFromJson(Map<String, dynamic> json) => _CityModel(
      id: const IntJson().fromJson(json['id']),
      name: json['city_name'] == null
          ? ''
          : const StringJson().fromJson(json['city_name']),
      provinceId: json['province_id'] == null
          ? 0
          : const IntJson().fromJson(json['province_id']),
      active: json['active'] == null
          ? true
          : const BoolJson().fromJson(json['active']),
    );

Map<String, dynamic> _$CityModelToJson(_CityModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'city_name': const StringJson().toJson(instance.name),
      'province_id': const IntJson().toJson(instance.provinceId),
      'active': const BoolJson().toJson(instance.active),
    };
