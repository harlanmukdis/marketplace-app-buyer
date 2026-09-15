// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      id: const IntJson().fromJson(json['id']),
      userId: json['user_id'] == null
          ? 0
          : const IntJson().fromJson(json['user_id']),
      label: json['label'] == null
          ? ''
          : const StringJson().fromJson(json['label']),
      recipientName: json['recipient_name'] == null
          ? ''
          : const StringJson().fromJson(json['recipient_name']),
      phone: json['phone'] == null
          ? ''
          : const StringJson().fromJson(json['phone']),
      fullAddress: json['full_address'] == null
          ? ''
          : const StringJson().fromJson(json['full_address']),
      city:
          json['city'] == null ? '' : const StringJson().fromJson(json['city']),
      province: json['province'] == null
          ? ''
          : const StringJson().fromJson(json['province']),
      postalCode: json['postal_code'] == null
          ? ''
          : const StringJson().fromJson(json['postal_code']),
      latitude: const DoubleOrNullJson().fromJson(json['latitude']),
      longitude: const DoubleOrNullJson().fromJson(json['longitude']),
      isPrimary: json['is_primary'] == null
          ? false
          : const BoolJson().fromJson(json['is_primary']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'user_id': const IntJson().toJson(instance.userId),
      'label': const StringJson().toJson(instance.label),
      'recipient_name': const StringJson().toJson(instance.recipientName),
      'phone': const StringJson().toJson(instance.phone),
      'full_address': const StringJson().toJson(instance.fullAddress),
      'city': const StringJson().toJson(instance.city),
      'province': const StringJson().toJson(instance.province),
      'postal_code': const StringJson().toJson(instance.postalCode),
      'latitude': const DoubleOrNullJson().toJson(instance.latitude),
      'longitude': const DoubleOrNullJson().toJson(instance.longitude),
      'is_primary': const BoolJson().toJson(instance.isPrimary),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };
