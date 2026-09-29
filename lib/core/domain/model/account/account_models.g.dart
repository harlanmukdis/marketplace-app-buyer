// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginSessionModel _$LoginSessionModelFromJson(Map<String, dynamic> json) =>
    _LoginSessionModel(
      id: const IntJson().fromJson(json['id']),
      deviceId: const StringOrNullJson().fromJson(json['device_id']),
      ipAddress: const StringOrNullJson().fromJson(json['ip_address']),
      userAgent: const StringOrNullJson().fromJson(json['user_agent']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
      expiresAt: const ServerDateTimeJson().fromJson(json['expires_at']),
      isCurrent: _boolOrNull(json['is_current']),
    );

Map<String, dynamic> _$LoginSessionModelToJson(_LoginSessionModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'device_id': const StringOrNullJson().toJson(instance.deviceId),
      'ip_address': const StringOrNullJson().toJson(instance.ipAddress),
      'user_agent': const StringOrNullJson().toJson(instance.userAgent),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
      'expires_at': const ServerDateTimeJson().toJson(instance.expiresAt),
      'is_current': instance.isCurrent,
    };

_IdentityVerificationModel _$IdentityVerificationModelFromJson(
        Map<String, dynamic> json) =>
    _IdentityVerificationModel(
      status: json['status'] == null
          ? 'none'
          : const StringJson().fromJson(json['status']),
      idCardNumberMasked:
          const StringOrNullJson().fromJson(json['id_card_number_masked']),
      fullName: const StringOrNullJson().fromJson(json['full_name']),
      rejectionReason:
          const StringOrNullJson().fromJson(json['rejection_reason']),
      submittedAt: const ServerDateTimeJson().fromJson(json['submitted_at']),
      verifiedAt: const ServerDateTimeJson().fromJson(json['verified_at']),
    );

Map<String, dynamic> _$IdentityVerificationModelToJson(
        _IdentityVerificationModel instance) =>
    <String, dynamic>{
      'status': const StringJson().toJson(instance.status),
      'id_card_number_masked':
          const StringOrNullJson().toJson(instance.idCardNumberMasked),
      'full_name': const StringOrNullJson().toJson(instance.fullName),
      'rejection_reason':
          const StringOrNullJson().toJson(instance.rejectionReason),
      'submitted_at': const ServerDateTimeJson().toJson(instance.submittedAt),
      'verified_at': const ServerDateTimeJson().toJson(instance.verifiedAt),
    };

_ContactChangeChallenge _$ContactChangeChallengeFromJson(
        Map<String, dynamic> json) =>
    _ContactChangeChallenge(
      requestId: json['request_id'] == null
          ? ''
          : const StringJson().fromJson(json['request_id']),
      type: json['type'] == null
          ? 'email'
          : const StringJson().fromJson(json['type']),
      stage: json['stage'] == null
          ? 'current_contact'
          : const StringJson().fromJson(json['stage']),
      otpSentTo: const StringOrNullJson().fromJson(json['otp_sent_to']),
      expiresAt: const ServerDateTimeJson().fromJson(json['expires_at']),
      newValue: const StringOrNullJson().fromJson(json['new_value']),
    );

Map<String, dynamic> _$ContactChangeChallengeToJson(
        _ContactChangeChallenge instance) =>
    <String, dynamic>{
      'request_id': const StringJson().toJson(instance.requestId),
      'type': const StringJson().toJson(instance.type),
      'stage': const StringJson().toJson(instance.stage),
      'otp_sent_to': const StringOrNullJson().toJson(instance.otpSentTo),
      'expires_at': const ServerDateTimeJson().toJson(instance.expiresAt),
      'new_value': const StringOrNullJson().toJson(instance.newValue),
    };
