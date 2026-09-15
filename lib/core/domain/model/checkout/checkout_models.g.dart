// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckoutSessionCreated _$CheckoutSessionCreatedFromJson(
        Map<String, dynamic> json) =>
    _CheckoutSessionCreated(
      id: json['id'] == null ? '' : const StringJson().fromJson(json['id']),
      subtotal: json['subtotal'] == null
          ? 0
          : const DoubleJson().fromJson(json['subtotal']),
      discount: json['discount'] == null
          ? 0
          : const DoubleJson().fromJson(json['discount']),
      grandTotal: json['grand_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['grand_total']),
      expiresAt: const ServerUtcDateTimeJson().fromJson(json['expires_at']),
    );

Map<String, dynamic> _$CheckoutSessionCreatedToJson(
        _CheckoutSessionCreated instance) =>
    <String, dynamic>{
      'id': const StringJson().toJson(instance.id),
      'subtotal': const DoubleJson().toJson(instance.subtotal),
      'discount': const DoubleJson().toJson(instance.discount),
      'grand_total': const DoubleJson().toJson(instance.grandTotal),
      'expires_at': const ServerUtcDateTimeJson().toJson(instance.expiresAt),
    };

_CheckoutSessionModel _$CheckoutSessionModelFromJson(
        Map<String, dynamic> json) =>
    _CheckoutSessionModel(
      id: json['id'] == null ? '' : const StringJson().fromJson(json['id']),
      status: json['status'] == null
          ? ''
          : const StringJson().fromJson(json['status']),
      cartSnapshot: const StringOrNullJson().fromJson(json['cart_snapshot']),
      shippingAddressId:
          const IntOrNullJson().fromJson(json['shipping_address_id']),
      selectedCouriers: const JsonMapJson().fromJson(json['selected_couriers']),
      appliedVouchers: const JsonMapJson().fromJson(json['applied_vouchers']),
      grandTotal: json['grand_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['grand_total']),
      expiresAt: const ServerUtcDateTimeJson().fromJson(json['expires_at']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$CheckoutSessionModelToJson(
        _CheckoutSessionModel instance) =>
    <String, dynamic>{
      'id': const StringJson().toJson(instance.id),
      'status': const StringJson().toJson(instance.status),
      'cart_snapshot': const StringOrNullJson().toJson(instance.cartSnapshot),
      'shipping_address_id':
          const IntOrNullJson().toJson(instance.shippingAddressId),
      'selected_couriers':
          const JsonMapJson().toJson(instance.selectedCouriers),
      'applied_vouchers': const JsonMapJson().toJson(instance.appliedVouchers),
      'grand_total': const DoubleJson().toJson(instance.grandTotal),
      'expires_at': const ServerUtcDateTimeJson().toJson(instance.expiresAt),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_ShippingOptionModel _$ShippingOptionModelFromJson(Map<String, dynamic> json) =>
    _ShippingOptionModel(
      courierCode: json['courier_code'] == null
          ? ''
          : const StringJson().fromJson(json['courier_code']),
      serviceCode: json['service_code'] == null
          ? ''
          : const StringJson().fromJson(json['service_code']),
      serviceName: json['service_name'] == null
          ? ''
          : const StringJson().fromJson(json['service_name']),
      zone: const StringOrNullJson().fromJson(json['zone']),
      weightKg: json['weight_kg'] == null
          ? 0
          : const DoubleJson().fromJson(json['weight_kg']),
      cost:
          json['cost'] == null ? 0 : const DoubleJson().fromJson(json['cost']),
      etdMinDays: json['etd_min_days'] == null
          ? 0
          : const IntJson().fromJson(json['etd_min_days']),
      etdMaxDays: json['etd_max_days'] == null
          ? 0
          : const IntJson().fromJson(json['etd_max_days']),
    );

Map<String, dynamic> _$ShippingOptionModelToJson(
        _ShippingOptionModel instance) =>
    <String, dynamic>{
      'courier_code': const StringJson().toJson(instance.courierCode),
      'service_code': const StringJson().toJson(instance.serviceCode),
      'service_name': const StringJson().toJson(instance.serviceName),
      'zone': const StringOrNullJson().toJson(instance.zone),
      'weight_kg': const DoubleJson().toJson(instance.weightKg),
      'cost': const DoubleJson().toJson(instance.cost),
      'etd_min_days': const IntJson().toJson(instance.etdMinDays),
      'etd_max_days': const IntJson().toJson(instance.etdMaxDays),
    };

_ShippingSelectionResult _$ShippingSelectionResultFromJson(
        Map<String, dynamic> json) =>
    _ShippingSelectionResult(
      selectedCouriers: json['selected_couriers'] as Map<String, dynamic>?,
      shippingTotal: json['shipping_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['shipping_total']),
      grandTotal: json['grand_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['grand_total']),
    );

Map<String, dynamic> _$ShippingSelectionResultToJson(
        _ShippingSelectionResult instance) =>
    <String, dynamic>{
      'selected_couriers': instance.selectedCouriers,
      'shipping_total': const DoubleJson().toJson(instance.shippingTotal),
      'grand_total': const DoubleJson().toJson(instance.grandTotal),
    };

_CheckoutConfirmResult _$CheckoutConfirmResultFromJson(
        Map<String, dynamic> json) =>
    _CheckoutConfirmResult(
      orderIds: (json['order_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      paymentTransactionId:
          const IntOrNullJson().fromJson(json['payment_transaction_id']),
    );

Map<String, dynamic> _$CheckoutConfirmResultToJson(
        _CheckoutConfirmResult instance) =>
    <String, dynamic>{
      'order_ids': instance.orderIds,
      'payment_transaction_id':
          const IntOrNullJson().toJson(instance.paymentTransactionId),
    };
