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
      shippingAddress: json['shipping_address'] == null
          ? null
          : OrderShippingAddress.fromJson(
              json['shipping_address'] as Map<String, dynamic>),
      paymentTransactionId:
          const IntOrNullJson().fromJson(json['payment_transaction_id']),
      cancellationFault:
          const StringOrNullJson().fromJson(json['cancellation_fault']),
      requiresCustomConfirmation: json['requires_custom_confirmation'] == null
          ? false
          : const BoolJson().fromJson(json['requires_custom_confirmation']),
      customConfirmedAt:
          const ServerDateTimeJson().fromJson(json['custom_confirmed_at']),
      estimatedLeadTimeDays:
          const IntOrNullJson().fromJson(json['estimated_lead_time_days']),
      partialFulfillmentProposedAt: const ServerDateTimeJson()
          .fromJson(json['partial_fulfillment_proposed_at']),
      partialFulfillmentDecision: const StringOrNullJson()
          .fromJson(json['partial_fulfillment_decision']),
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
      'shipping_address': instance.shippingAddress,
      'payment_transaction_id':
          const IntOrNullJson().toJson(instance.paymentTransactionId),
      'cancellation_fault':
          const StringOrNullJson().toJson(instance.cancellationFault),
      'requires_custom_confirmation':
          const BoolJson().toJson(instance.requiresCustomConfirmation),
      'custom_confirmed_at':
          const ServerDateTimeJson().toJson(instance.customConfirmedAt),
      'estimated_lead_time_days':
          const IntOrNullJson().toJson(instance.estimatedLeadTimeDays),
      'partial_fulfillment_proposed_at': const ServerDateTimeJson()
          .toJson(instance.partialFulfillmentProposedAt),
      'partial_fulfillment_decision':
          const StringOrNullJson().toJson(instance.partialFulfillmentDecision),
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
      isAvailable: json['is_available'] == null
          ? true
          : const BoolJson().fromJson(json['is_available']),
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
      'is_available': const BoolJson().toJson(instance.isAvailable),
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

_OrderShippingAddress _$OrderShippingAddressFromJson(
        Map<String, dynamic> json) =>
    _OrderShippingAddress(
      recipientName: const StringOrNullJson().fromJson(json['recipient_name']),
      phone: const StringOrNullJson().fromJson(json['phone']),
      fullAddress: const StringOrNullJson().fromJson(json['full_address']),
      city: const StringOrNullJson().fromJson(json['city']),
      province: const StringOrNullJson().fromJson(json['province']),
      postalCode: const StringOrNullJson().fromJson(json['postal_code']),
    );

Map<String, dynamic> _$OrderShippingAddressToJson(
        _OrderShippingAddress instance) =>
    <String, dynamic>{
      'recipient_name': const StringOrNullJson().toJson(instance.recipientName),
      'phone': const StringOrNullJson().toJson(instance.phone),
      'full_address': const StringOrNullJson().toJson(instance.fullAddress),
      'city': const StringOrNullJson().toJson(instance.city),
      'province': const StringOrNullJson().toJson(instance.province),
      'postal_code': const StringOrNullJson().toJson(instance.postalCode),
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

_OrderTrackingModel _$OrderTrackingModelFromJson(Map<String, dynamic> json) =>
    _OrderTrackingModel(
      courierCode: json['courier_code'] == null
          ? ''
          : const StringJson().fromJson(json['courier_code']),
      serviceType: json['service_type'] == null
          ? ''
          : const StringJson().fromJson(json['service_type']),
      awbNumber: const StringOrNullJson().fromJson(json['awb_number']),
      handoverMethod:
          const StringOrNullJson().fromJson(json['handover_method']),
      status: json['status'] == null
          ? 'pending'
          : const StringJson().fromJson(json['status']),
      shippedAt: const ServerDateTimeJson().fromJson(json['shipped_at']),
      deliveredAt: const ServerDateTimeJson().fromJson(json['delivered_at']),
      trackingHistory: json['tracking_history'] == null
          ? const <TrackingEventModel>[]
          : const TrackingHistoryJson().fromJson(json['tracking_history']),
    );

Map<String, dynamic> _$OrderTrackingModelToJson(_OrderTrackingModel instance) =>
    <String, dynamic>{
      'courier_code': const StringJson().toJson(instance.courierCode),
      'service_type': const StringJson().toJson(instance.serviceType),
      'awb_number': const StringOrNullJson().toJson(instance.awbNumber),
      'handover_method':
          const StringOrNullJson().toJson(instance.handoverMethod),
      'status': const StringJson().toJson(instance.status),
      'shipped_at': const ServerDateTimeJson().toJson(instance.shippedAt),
      'delivered_at': const ServerDateTimeJson().toJson(instance.deliveredAt),
      'tracking_history':
          const TrackingHistoryJson().toJson(instance.trackingHistory),
    };

_TrackingEventModel _$TrackingEventModelFromJson(Map<String, dynamic> json) =>
    _TrackingEventModel(
      status: json['status'] == null
          ? 'in_transit'
          : const StringJson().fromJson(json['status']),
      description: json['description'] == null
          ? ''
          : const StringJson().fromJson(json['description']),
      location: const StringOrNullJson().fromJson(json['location']),
      occurredAt: const ServerDateTimeJson().fromJson(json['occurred_at']),
    );

Map<String, dynamic> _$TrackingEventModelToJson(_TrackingEventModel instance) =>
    <String, dynamic>{
      'status': const StringJson().toJson(instance.status),
      'description': const StringJson().toJson(instance.description),
      'location': const StringOrNullJson().toJson(instance.location),
      'occurred_at': const ServerDateTimeJson().toJson(instance.occurredAt),
    };

_ShipmentEvidenceModel _$ShipmentEvidenceModelFromJson(
        Map<String, dynamic> json) =>
    _ShipmentEvidenceModel(
      id: const IntJson().fromJson(json['id']),
      mediaType: json['media_type'] == null
          ? 'photo'
          : const StringJson().fromJson(json['media_type']),
      url: json['url'] == null ? '' : const StringJson().fromJson(json['url']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$ShipmentEvidenceModelToJson(
        _ShipmentEvidenceModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'media_type': const StringJson().toJson(instance.mediaType),
      'url': const StringJson().toJson(instance.url),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_OrderInvoiceModel _$OrderInvoiceModelFromJson(Map<String, dynamic> json) =>
    _OrderInvoiceModel(
      invoiceNumber: json['invoice_number'] == null
          ? ''
          : const StringJson().fromJson(json['invoice_number']),
      generatedAt: const ServerDateTimeJson().fromJson(json['generated_at']),
      orderNumber: json['order_number'] == null
          ? ''
          : const StringJson().fromJson(json['order_number']),
      orderDate: const ServerDateTimeJson().fromJson(json['order_date']),
      store: json['store'] == null
          ? null
          : InvoiceStoreModel.fromJson(json['store'] as Map<String, dynamic>),
      shippingAddress: json['shipping_address'] == null
          ? null
          : OrderShippingAddress.fromJson(
              json['shipping_address'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OrderItemModel>[],
      subtotal: json['subtotal'] == null
          ? 0
          : const DoubleJson().fromJson(json['subtotal']),
      shippingCost: json['shipping_cost'] == null
          ? 0
          : const DoubleJson().fromJson(json['shipping_cost']),
      discountTotal: json['discount_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['discount_total']),
      grandTotal: json['grand_total'] == null
          ? 0
          : const DoubleJson().fromJson(json['grand_total']),
    );

Map<String, dynamic> _$OrderInvoiceModelToJson(_OrderInvoiceModel instance) =>
    <String, dynamic>{
      'invoice_number': const StringJson().toJson(instance.invoiceNumber),
      'generated_at': const ServerDateTimeJson().toJson(instance.generatedAt),
      'order_number': const StringJson().toJson(instance.orderNumber),
      'order_date': const ServerDateTimeJson().toJson(instance.orderDate),
      'store': instance.store,
      'shipping_address': instance.shippingAddress,
      'items': instance.items,
      'subtotal': const DoubleJson().toJson(instance.subtotal),
      'shipping_cost': const DoubleJson().toJson(instance.shippingCost),
      'discount_total': const DoubleJson().toJson(instance.discountTotal),
      'grand_total': const DoubleJson().toJson(instance.grandTotal),
    };

_InvoiceStoreModel _$InvoiceStoreModelFromJson(Map<String, dynamic> json) =>
    _InvoiceStoreModel(
      id: json['id'] == null ? 0 : const IntJson().fromJson(json['id']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
    );

Map<String, dynamic> _$InvoiceStoreModelToJson(_InvoiceStoreModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'name': const StringJson().toJson(instance.name),
    };
