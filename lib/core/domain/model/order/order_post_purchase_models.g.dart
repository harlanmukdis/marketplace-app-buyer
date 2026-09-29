// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_post_purchase_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CancellationRequestModel _$CancellationRequestModelFromJson(
        Map<String, dynamic> json) =>
    _CancellationRequestModel(
      id: const IntJson().fromJson(json['id']),
      statusCode: json['status'] == null
          ? 'pending'
          : const StringJson().fromJson(json['status']),
      reason: json['reason'] == null
          ? ''
          : const StringJson().fromJson(json['reason']),
      note: const StringOrNullJson().fromJson(json['note']),
      rejectionReason:
          const StringOrNullJson().fromJson(json['rejection_reason']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
      sellerResponseDeadline:
          const ServerDateTimeJson().fromJson(json['seller_response_deadline']),
      resolvedAt: const ServerDateTimeJson().fromJson(json['resolved_at']),
    );

Map<String, dynamic> _$CancellationRequestModelToJson(
        _CancellationRequestModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'status': const StringJson().toJson(instance.statusCode),
      'reason': const StringJson().toJson(instance.reason),
      'note': const StringOrNullJson().toJson(instance.note),
      'rejection_reason':
          const StringOrNullJson().toJson(instance.rejectionReason),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
      'seller_response_deadline':
          const ServerDateTimeJson().toJson(instance.sellerResponseDeadline),
      'resolved_at': const ServerDateTimeJson().toJson(instance.resolvedAt),
    };

_InsurancePolicyModel _$InsurancePolicyModelFromJson(
        Map<String, dynamic> json) =>
    _InsurancePolicyModel(
      id: json['id'] == null ? 0 : const IntJson().fromJson(json['id']),
      tier: json['tier'] == null
          ? 'basic'
          : const StringJson().fromJson(json['tier']),
      premiumAmount: json['premium_amount'] == null
          ? 0
          : const DoubleJson().fromJson(json['premium_amount']),
      coverageAmount:
          const DoubleOrNullJson().fromJson(json['coverage_amount']),
      status: json['status'] == null
          ? 'active'
          : const StringJson().fromJson(json['status']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$InsurancePolicyModelToJson(
        _InsurancePolicyModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'tier': const StringJson().toJson(instance.tier),
      'premium_amount': const DoubleJson().toJson(instance.premiumAmount),
      'coverage_amount':
          const DoubleOrNullJson().toJson(instance.coverageAmount),
      'status': const StringJson().toJson(instance.status),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_MediaUploadModel _$MediaUploadModelFromJson(Map<String, dynamic> json) =>
    _MediaUploadModel(
      url: json['url'] == null ? '' : const StringJson().fromJson(json['url']),
      fileName: json['file_name'] == null
          ? ''
          : const StringJson().fromJson(json['file_name']),
      fileSizeKb: json['file_size_kb'] == null
          ? 0
          : const DoubleJson().fromJson(json['file_size_kb']),
      mimeType: json['mime_type'] == null
          ? ''
          : const StringJson().fromJson(json['mime_type']),
    );

Map<String, dynamic> _$MediaUploadModelToJson(_MediaUploadModel instance) =>
    <String, dynamic>{
      'url': const StringJson().toJson(instance.url),
      'file_name': const StringJson().toJson(instance.fileName),
      'file_size_kb': const DoubleJson().toJson(instance.fileSizeKb),
      'mime_type': const StringJson().toJson(instance.mimeType),
    };
