// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    _PaymentMethodModel(
      code:
          json['code'] == null ? '' : const StringJson().fromJson(json['code']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
    );

Map<String, dynamic> _$PaymentMethodModelToJson(_PaymentMethodModel instance) =>
    <String, dynamic>{
      'code': const StringJson().toJson(instance.code),
      'name': const StringJson().toJson(instance.name),
    };

_PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) =>
    _PaymentModel(
      id: const IntJson().fromJson(json['id']),
      checkoutSessionId:
          const StringOrNullJson().fromJson(json['checkout_session_id']),
      paymentMethod: json['payment_method'] == null
          ? ''
          : const StringJson().fromJson(json['payment_method']),
      provider: const StringOrNullJson().fromJson(json['provider']),
      providerReference:
          const StringOrNullJson().fromJson(json['provider_reference']),
      amount: json['amount'] == null
          ? 0
          : const DoubleJson().fromJson(json['amount']),
      status: json['status'] == null
          ? ''
          : const StringJson().fromJson(json['status']),
      paidAt: const ServerDateTimeJson().fromJson(json['paid_at']),
      expiredAt: const ServerUtcDateTimeJson().fromJson(json['expired_at']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$PaymentModelToJson(_PaymentModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'checkout_session_id':
          const StringOrNullJson().toJson(instance.checkoutSessionId),
      'payment_method': const StringJson().toJson(instance.paymentMethod),
      'provider': const StringOrNullJson().toJson(instance.provider),
      'provider_reference':
          const StringOrNullJson().toJson(instance.providerReference),
      'amount': const DoubleJson().toJson(instance.amount),
      'status': const StringJson().toJson(instance.status),
      'paid_at': const ServerDateTimeJson().toJson(instance.paidAt),
      'expired_at': const ServerUtcDateTimeJson().toJson(instance.expiredAt),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_PaymentInstructionModel _$PaymentInstructionModelFromJson(
        Map<String, dynamic> json) =>
    _PaymentInstructionModel(
      qrString: const StringOrNullJson().fromJson(json['qr_string']),
      vaNumber: const StringOrNullJson().fromJson(json['va_number']),
      bank: const StringOrNullJson().fromJson(json['bank']),
      expiresAt: const ServerUtcDateTimeJson().fromJson(json['expires_at']),
    );

Map<String, dynamic> _$PaymentInstructionModelToJson(
        _PaymentInstructionModel instance) =>
    <String, dynamic>{
      'qr_string': const StringOrNullJson().toJson(instance.qrString),
      'va_number': const StringOrNullJson().toJson(instance.vaNumber),
      'bank': const StringOrNullJson().toJson(instance.bank),
      'expires_at': const ServerUtcDateTimeJson().toJson(instance.expiresAt),
    };
