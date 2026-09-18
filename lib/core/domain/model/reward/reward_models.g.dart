// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RewardBalanceModel _$RewardBalanceModelFromJson(Map<String, dynamic> json) =>
    _RewardBalanceModel(
      id: json['id'] == null ? 0 : const IntJson().fromJson(json['id']),
      balance: json['balance'] == null
          ? 0
          : const IntJson().fromJson(json['balance']),
      updatedAt: const ServerDateTimeJson().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$RewardBalanceModelToJson(_RewardBalanceModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'balance': const IntJson().toJson(instance.balance),
      'updated_at': const ServerDateTimeJson().toJson(instance.updatedAt),
    };

_LoyaltyTierModel _$LoyaltyTierModelFromJson(Map<String, dynamic> json) =>
    _LoyaltyTierModel(
      id: json['id'] == null ? 0 : const IntJson().fromJson(json['id']),
      code:
          json['code'] == null ? '' : const StringJson().fromJson(json['code']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      minPoints: json['min_points'] == null
          ? 0
          : const IntJson().fromJson(json['min_points']),
      benefits: const JsonMapJson().fromJson(json['benefits']),
    );

Map<String, dynamic> _$LoyaltyTierModelToJson(_LoyaltyTierModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'code': const StringJson().toJson(instance.code),
      'name': const StringJson().toJson(instance.name),
      'min_points': const IntJson().toJson(instance.minPoints),
      'benefits': const JsonMapJson().toJson(instance.benefits),
    };

_LoyaltyMembershipModel _$LoyaltyMembershipModelFromJson(
        Map<String, dynamic> json) =>
    _LoyaltyMembershipModel(
      id: json['id'] == null ? 0 : const IntJson().fromJson(json['id']),
      tierId: json['loyalty_tier_id'] == null
          ? 0
          : const IntJson().fromJson(json['loyalty_tier_id']),
      tierPoints: json['tier_points'] == null
          ? 0
          : const IntJson().fromJson(json['tier_points']),
      validUntil: const ServerDateTimeJson().fromJson(json['tier_valid_until']),
      updatedAt: const ServerDateTimeJson().fromJson(json['updated_at']),
      tier: json['tier'] == null
          ? null
          : LoyaltyTierModel.fromJson(json['tier'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoyaltyMembershipModelToJson(
        _LoyaltyMembershipModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'loyalty_tier_id': const IntJson().toJson(instance.tierId),
      'tier_points': const IntJson().toJson(instance.tierPoints),
      'tier_valid_until':
          const ServerDateTimeJson().toJson(instance.validUntil),
      'updated_at': const ServerDateTimeJson().toJson(instance.updatedAt),
      'tier': instance.tier,
    };

_CashbackTransactionModel _$CashbackTransactionModelFromJson(
        Map<String, dynamic> json) =>
    _CashbackTransactionModel(
      id: const IntJson().fromJson(json['id']),
      orderId: const IntOrNullJson().fromJson(json['order_id']),
      amount: json['amount'] == null
          ? 0
          : const DoubleJson().fromJson(json['amount']),
      statusCode: json['status'] == null
          ? ''
          : const StringJson().fromJson(json['status']),
      creditedAt: const ServerDateTimeJson().fromJson(json['credited_at']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$CashbackTransactionModelToJson(
        _CashbackTransactionModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'order_id': const IntOrNullJson().toJson(instance.orderId),
      'amount': const DoubleJson().toJson(instance.amount),
      'status': const StringJson().toJson(instance.statusCode),
      'credited_at': const ServerDateTimeJson().toJson(instance.creditedAt),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_RewardBreakdownModel _$RewardBreakdownModelFromJson(
        Map<String, dynamic> json) =>
    _RewardBreakdownModel(
      base: json['base'] == null ? 0 : const IntJson().fromJson(json['base']),
      tierBonus: json['tier_bonus'] == null
          ? 0
          : const IntJson().fromJson(json['tier_bonus']),
      paymentMethodBonus: json['payment_method_bonus'] == null
          ? 0
          : const IntJson().fromJson(json['payment_method_bonus']),
      voucherCashback: json['voucher_cashback'] == null
          ? 0
          : const IntJson().fromJson(json['voucher_cashback']),
    );

Map<String, dynamic> _$RewardBreakdownModelToJson(
        _RewardBreakdownModel instance) =>
    <String, dynamic>{
      'base': const IntJson().toJson(instance.base),
      'tier_bonus': const IntJson().toJson(instance.tierBonus),
      'payment_method_bonus':
          const IntJson().toJson(instance.paymentMethodBonus),
      'voucher_cashback': const IntJson().toJson(instance.voucherCashback),
    };

_RewardPreviewModel _$RewardPreviewModelFromJson(Map<String, dynamic> json) =>
    _RewardPreviewModel(
      subtotal: json['subtotal'] == null
          ? 0
          : const DoubleJson().fromJson(json['subtotal']),
      estimatedCoins: json['estimated_cashback_coins'] == null
          ? 0
          : const IntJson().fromJson(json['estimated_cashback_coins']),
      breakdown: json['breakdown'] == null
          ? null
          : RewardBreakdownModel.fromJson(
              json['breakdown'] as Map<String, dynamic>),
      tier:
          json['tier'] == null ? '' : const StringJson().fromJson(json['tier']),
      status: json['status'] == null
          ? ''
          : const StringJson().fromJson(json['status']),
    );

Map<String, dynamic> _$RewardPreviewModelToJson(_RewardPreviewModel instance) =>
    <String, dynamic>{
      'subtotal': const DoubleJson().toJson(instance.subtotal),
      'estimated_cashback_coins':
          const IntJson().toJson(instance.estimatedCoins),
      'breakdown': instance.breakdown,
      'tier': const StringJson().toJson(instance.tier),
      'status': const StringJson().toJson(instance.status),
    };
