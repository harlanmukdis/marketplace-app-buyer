// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VoucherModel _$VoucherModelFromJson(Map<String, dynamic> json) =>
    _VoucherModel(
      id: json['id'] == null ? 0 : const IntJson().fromJson(json['id']),
      storeId: const IntOrNullJson().fromJson(json['store_id']),
      code:
          json['code'] == null ? '' : const StringJson().fromJson(json['code']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      discountType: json['discount_type'] == null
          ? ''
          : const StringJson().fromJson(json['discount_type']),
      discountValue: json['discount_value'] == null
          ? 0
          : const DoubleJson().fromJson(json['discount_value']),
      maxDiscount: const DoubleOrNullJson().fromJson(json['max_discount']),
      minSpend: json['min_spend'] == null
          ? 0
          : const DoubleJson().fromJson(json['min_spend']),
      validUntil: const ServerDateTimeJson().fromJson(json['valid_until']),
      status: json['status'] == null
          ? 'active'
          : const StringJson().fromJson(json['status']),
      claimedAt: const ServerDateTimeJson().fromJson(json['claimed_at']),
    );

Map<String, dynamic> _$VoucherModelToJson(_VoucherModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'store_id': const IntOrNullJson().toJson(instance.storeId),
      'code': const StringJson().toJson(instance.code),
      'name': const StringJson().toJson(instance.name),
      'discount_type': const StringJson().toJson(instance.discountType),
      'discount_value': const DoubleJson().toJson(instance.discountValue),
      'max_discount': const DoubleOrNullJson().toJson(instance.maxDiscount),
      'min_spend': const DoubleJson().toJson(instance.minSpend),
      'valid_until': const ServerDateTimeJson().toJson(instance.validUntil),
      'status': const StringJson().toJson(instance.status),
      'claimed_at': const ServerDateTimeJson().toJson(instance.claimedAt),
    };
