// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
      id: const IntJson().fromJson(json['id']),
      cartId: json['cart_id'] == null
          ? 0
          : const IntJson().fromJson(json['cart_id']),
      storeId: json['store_id'] == null
          ? 0
          : const IntJson().fromJson(json['store_id']),
      productVariantId: json['product_variant_id'] == null
          ? 0
          : const IntJson().fromJson(json['product_variant_id']),
      warehouseId: const IntOrNullJson().fromJson(json['warehouse_id']),
      quantity: json['quantity'] == null
          ? 1
          : const IntJson().fromJson(json['quantity']),
      isSelected: json['is_selected'] == null
          ? true
          : const BoolJson().fromJson(json['is_selected']),
      sku: const StringOrNullJson().fromJson(json['sku']),
      price: json['price'] == null
          ? 0
          : const DoubleJson().fromJson(json['price']),
      variantOptions: const JsonMapJson().fromJson(json['variant_options']),
      productName: json['product_name'] == null
          ? ''
          : const StringJson().fromJson(json['product_name']),
      storeName: json['store_name'] == null
          ? ''
          : const StringJson().fromJson(json['store_name']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'cart_id': const IntJson().toJson(instance.cartId),
      'store_id': const IntJson().toJson(instance.storeId),
      'product_variant_id': const IntJson().toJson(instance.productVariantId),
      'warehouse_id': const IntOrNullJson().toJson(instance.warehouseId),
      'quantity': const IntJson().toJson(instance.quantity),
      'is_selected': const BoolJson().toJson(instance.isSelected),
      'sku': const StringOrNullJson().toJson(instance.sku),
      'price': const DoubleJson().toJson(instance.price),
      'variant_options': const JsonMapJson().toJson(instance.variantOptions),
      'product_name': const StringJson().toJson(instance.productName),
      'store_name': const StringJson().toJson(instance.storeName),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_CartStoreGroup _$CartStoreGroupFromJson(Map<String, dynamic> json) =>
    _CartStoreGroup(
      storeName: json['store_name'] == null
          ? ''
          : const StringJson().fromJson(json['store_name']),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CartItemModel>[],
    );

Map<String, dynamic> _$CartStoreGroupToJson(_CartStoreGroup instance) =>
    <String, dynamic>{
      'store_name': const StringJson().toJson(instance.storeName),
      'items': instance.items,
    };

_AppliedVoucherModel _$AppliedVoucherModelFromJson(Map<String, dynamic> json) =>
    _AppliedVoucherModel(
      code:
          json['code'] == null ? '' : const StringJson().fromJson(json['code']),
      category: json['category'] == null
          ? ''
          : const StringJson().fromJson(json['category']),
      storeId: const IntOrNullJson().fromJson(json['store_id']),
      discountType: json['discount_type'] == null
          ? ''
          : const StringJson().fromJson(json['discount_type']),
      discountValue: json['discount_value'] == null
          ? 0
          : const DoubleJson().fromJson(json['discount_value']),
      maxDiscount: const DoubleOrNullJson().fromJson(json['max_discount']),
      discountAmount:
          const DoubleOrNullJson().fromJson(json['discount_amount']),
      voucherId: const IntOrNullJson().fromJson(json['voucher_id']),
      estimatedValue: const DoubleOrNullJson().fromJson(json['value']),
    );

Map<String, dynamic> _$AppliedVoucherModelToJson(
        _AppliedVoucherModel instance) =>
    <String, dynamic>{
      'code': const StringJson().toJson(instance.code),
      'category': const StringJson().toJson(instance.category),
      'store_id': const IntOrNullJson().toJson(instance.storeId),
      'discount_type': const StringJson().toJson(instance.discountType),
      'discount_value': const DoubleJson().toJson(instance.discountValue),
      'max_discount': const DoubleOrNullJson().toJson(instance.maxDiscount),
      'discount_amount':
          const DoubleOrNullJson().toJson(instance.discountAmount),
      'voucher_id': const IntOrNullJson().toJson(instance.voucherId),
      'value': const DoubleOrNullJson().toJson(instance.estimatedValue),
    };

_CartSummaryModel _$CartSummaryModelFromJson(Map<String, dynamic> json) =>
    _CartSummaryModel(
      subtotal: json['subtotal'] == null
          ? 0
          : const DoubleJson().fromJson(json['subtotal']),
      itemCount: json['item_count'] == null
          ? 0
          : const IntJson().fromJson(json['item_count']),
      vouchers: (json['vouchers'] as List<dynamic>?)
              ?.map((e) =>
                  AppliedVoucherModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AppliedVoucherModel>[],
      discountAmount: json['discount_amount'] == null
          ? 0
          : const DoubleJson().fromJson(json['discount_amount']),
    );

Map<String, dynamic> _$CartSummaryModelToJson(_CartSummaryModel instance) =>
    <String, dynamic>{
      'subtotal': const DoubleJson().toJson(instance.subtotal),
      'item_count': const IntJson().toJson(instance.itemCount),
      'vouchers': instance.vouchers,
      'discount_amount': const DoubleJson().toJson(instance.discountAmount),
    };
