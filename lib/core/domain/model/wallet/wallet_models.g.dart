// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => _WalletModel(
      id: json['id'] == null ? 0 : const IntJson().fromJson(json['id']),
      balance: json['balance'] == null
          ? 0
          : const DoubleJson().fromJson(json['balance']),
      heldBalance: json['held_balance'] == null
          ? 0
          : const DoubleJson().fromJson(json['held_balance']),
      status: json['status'] == null
          ? 'active'
          : const StringJson().fromJson(json['status']),
      updatedAt: const ServerDateTimeJson().fromJson(json['updated_at']),
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) =>
                  WalletTransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WalletTransactionModel>[],
    );

Map<String, dynamic> _$WalletModelToJson(_WalletModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'balance': const DoubleJson().toJson(instance.balance),
      'held_balance': const DoubleJson().toJson(instance.heldBalance),
      'status': const StringJson().toJson(instance.status),
      'updated_at': const ServerDateTimeJson().toJson(instance.updatedAt),
      'transactions': instance.transactions,
    };

_WalletTransactionModel _$WalletTransactionModelFromJson(
        Map<String, dynamic> json) =>
    _WalletTransactionModel(
      id: const IntJson().fromJson(json['id']),
      typeCode:
          json['type'] == null ? '' : const StringJson().fromJson(json['type']),
      amount: json['amount'] == null
          ? 0
          : const DoubleJson().fromJson(json['amount']),
      balanceBefore: json['balance_before'] == null
          ? 0
          : const DoubleJson().fromJson(json['balance_before']),
      balanceAfter: json['balance_after'] == null
          ? 0
          : const DoubleJson().fromJson(json['balance_after']),
      referenceType: const StringOrNullJson().fromJson(json['reference_type']),
      referenceId: const IntOrNullJson().fromJson(json['reference_id']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$WalletTransactionModelToJson(
        _WalletTransactionModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'type': const StringJson().toJson(instance.typeCode),
      'amount': const DoubleJson().toJson(instance.amount),
      'balance_before': const DoubleJson().toJson(instance.balanceBefore),
      'balance_after': const DoubleJson().toJson(instance.balanceAfter),
      'reference_type': const StringOrNullJson().toJson(instance.referenceType),
      'reference_id': const IntOrNullJson().toJson(instance.referenceId),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_WalletTopupResult _$WalletTopupResultFromJson(Map<String, dynamic> json) =>
    _WalletTopupResult(
      paymentTransactionId: json['payment_transaction_id'] == null
          ? 0
          : const IntJson().fromJson(json['payment_transaction_id']),
      reference: const StringOrNullJson().fromJson(json['topup_reference']),
      amount: json['amount'] == null
          ? 0
          : const DoubleJson().fromJson(json['amount']),
    );

Map<String, dynamic> _$WalletTopupResultToJson(_WalletTopupResult instance) =>
    <String, dynamic>{
      'payment_transaction_id':
          const IntJson().toJson(instance.paymentTransactionId),
      'topup_reference': const StringOrNullJson().toJson(instance.reference),
      'amount': const DoubleJson().toJson(instance.amount),
    };
