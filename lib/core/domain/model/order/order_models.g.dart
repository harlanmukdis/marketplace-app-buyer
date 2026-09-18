// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
      id: const IntJson().fromJson(json['id']),
      orderNumber: json['order_number'] == null
          ? ''
          : const StringJson().fromJson(json['order_number']),
      checkoutSessionId:
          const StringOrNullJson().fromJson(json['checkout_session_id']),
      storeId: json['store_id'] == null
          ? 0
          : const IntJson().fromJson(json['store_id']),
      statusCode: json['status'] == null
          ? ''
          : const StringJson().fromJson(json['status']),
      subtotal: json['subtotal'] == null
          ? 0
          : const DoubleJson().fromJson(json['subtotal']),
      shippingCost: json['shipping_cost'] == null
          ? 0
          : const DoubleJson().fromJson(json['shipping_cost']),
      discountTotal: json['discount_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['discount_total']),
      cashbackTotal: json['cashback_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['cashback_total']),
      grandTotal: json['grand_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['grand_total']),
      courierCode: const StringOrNullJson().fromJson(json['courier_code']),
      courierService:
          const StringOrNullJson().fromJson(json['courier_service']),
      trackingNumber:
          const StringOrNullJson().fromJson(json['tracking_number']),
      shippingAddressSnapshot:
          const JsonMapJson().fromJson(json['shipping_address_snapshot']),
      paymentDeadline:
          const ServerDateTimeJson().fromJson(json['payment_deadline']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
      updatedAt: const ServerDateTimeJson().fromJson(json['updated_at']),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OrderItemModel>[],
      statusHistory: (json['status_history'] as List<dynamic>?)
              ?.map((e) =>
                  OrderStatusHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OrderStatusHistoryModel>[],
      refund: json['refund'] == null
          ? null
          : OrderRefundModel.fromJson(json['refund'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'order_number': const StringJson().toJson(instance.orderNumber),
      'checkout_session_id':
          const StringOrNullJson().toJson(instance.checkoutSessionId),
      'store_id': const IntJson().toJson(instance.storeId),
      'status': const StringJson().toJson(instance.statusCode),
      'subtotal': const DoubleJson().toJson(instance.subtotal),
      'shipping_cost': const DoubleJson().toJson(instance.shippingCost),
      'discount_total': const DoubleJson().toJson(instance.discountTotal),
      'cashback_total': const DoubleJson().toJson(instance.cashbackTotal),
      'grand_total': const DoubleJson().toJson(instance.grandTotal),
      'courier_code': const StringOrNullJson().toJson(instance.courierCode),
      'courier_service':
          const StringOrNullJson().toJson(instance.courierService),
      'tracking_number':
          const StringOrNullJson().toJson(instance.trackingNumber),
      'shipping_address_snapshot':
          const JsonMapJson().toJson(instance.shippingAddressSnapshot),
      'payment_deadline':
          const ServerDateTimeJson().toJson(instance.paymentDeadline),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
      'updated_at': const ServerDateTimeJson().toJson(instance.updatedAt),
      'items': instance.items,
      'status_history': instance.statusHistory,
      'refund': instance.refund,
    };

_OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    _OrderItemModel(
      id: const IntJson().fromJson(json['id']),
      productVariantId: json['product_variant_id'] == null
          ? 0
          : const IntJson().fromJson(json['product_variant_id']),
      productName: json['product_name_snapshot'] == null
          ? ''
          : const StringJson().fromJson(json['product_name_snapshot']),
      variantOptions:
          const JsonMapJson().fromJson(json['variant_options_snapshot']),
      price: json['price_snapshot'] == null
          ? 0
          : const DoubleJson().fromJson(json['price_snapshot']),
      quantity: json['quantity'] == null
          ? 0
          : const IntJson().fromJson(json['quantity']),
      subtotal: json['subtotal'] == null
          ? 0
          : const DoubleJson().fromJson(json['subtotal']),
    );

Map<String, dynamic> _$OrderItemModelToJson(_OrderItemModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'product_variant_id': const IntJson().toJson(instance.productVariantId),
      'product_name_snapshot': const StringJson().toJson(instance.productName),
      'variant_options_snapshot':
          const JsonMapJson().toJson(instance.variantOptions),
      'price_snapshot': const DoubleJson().toJson(instance.price),
      'quantity': const IntJson().toJson(instance.quantity),
      'subtotal': const DoubleJson().toJson(instance.subtotal),
    };

_OrderStatusHistoryModel _$OrderStatusHistoryModelFromJson(
        Map<String, dynamic> json) =>
    _OrderStatusHistoryModel(
      id: const IntJson().fromJson(json['id']),
      fromStatus: const StringOrNullJson().fromJson(json['from_status']),
      toStatus: json['to_status'] == null
          ? ''
          : const StringJson().fromJson(json['to_status']),
      notes: const StringOrNullJson().fromJson(json['notes']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$OrderStatusHistoryModelToJson(
        _OrderStatusHistoryModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'from_status': const StringOrNullJson().toJson(instance.fromStatus),
      'to_status': const StringJson().toJson(instance.toStatus),
      'notes': const StringOrNullJson().toJson(instance.notes),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_OrderRefundModel _$OrderRefundModelFromJson(Map<String, dynamic> json) =>
    _OrderRefundModel(
      id: const IntJson().fromJson(json['id']),
      status: json['status'] == null
          ? ''
          : const StringJson().fromJson(json['status']),
      reason: const StringOrNullJson().fromJson(json['reason']),
      amount: json['amount'] == null
          ? 0
          : const DoubleJson().fromJson(json['amount']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$OrderRefundModelToJson(_OrderRefundModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'status': const StringJson().toJson(instance.status),
      'reason': const StringOrNullJson().toJson(instance.reason),
      'amount': const DoubleJson().toJson(instance.amount),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };
