// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: const IntJson().fromJson(json['id']),
      storeId: json['store_id'] == null
          ? 0
          : const IntJson().fromJson(json['store_id']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      slug:
          json['slug'] == null ? '' : const StringJson().fromJson(json['slug']),
      description: const StringOrNullJson().fromJson(json['description']),
      productType: json['product_type'] == null
          ? 'physical'
          : const StringJson().fromJson(json['product_type']),
      basePrice: json['base_price'] == null
          ? 0
          : const DoubleJson().fromJson(json['base_price']),
      compareAtPrice:
          const DoubleOrNullJson().fromJson(json['compare_at_price']),
      weightGrams: const IntOrNullJson().fromJson(json['weight_grams']),
      status: json['status'] == null
          ? 'active'
          : const StringJson().fromJson(json['status']),
      soldCount: json['sold_count'] == null
          ? 0
          : const IntJson().fromJson(json['sold_count']),
      viewCount: json['view_count'] == null
          ? 0
          : const IntJson().fromJson(json['view_count']),
      ratingAvg: json['rating_avg'] == null
          ? 0
          : const DoubleJson().fromJson(json['rating_avg']),
      ratingCount: json['rating_count'] == null
          ? 0
          : const IntJson().fromJson(json['rating_count']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
      stock: const IntOrNullJson().fromJson(json['stock']),
      flashSale: json['flash_sale'] == null
          ? null
          : FlashSaleModel.fromJson(json['flash_sale'] as Map<String, dynamic>),
      listingImageUrl: const StringOrNullJson().fromJson(json['image_url']),
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      fulfillmentMode: json['fulfillment_mode'] == null
          ? 'ready_stock'
          : const StringJson().fromJson(json['fulfillment_mode']),
      fulfillmentLeadTimeDays:
          const IntOrNullJson().fromJson(json['fulfillment_lead_time_days']),
      availability: const StringOrNullJson().fromJson(json['availability']),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProductVariantModel>[],
      images: (json['images'] as List<dynamic>?)
              ?.map(
                  (e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProductImageModel>[],
      couriers: (json['couriers'] as List<dynamic>?)
              ?.map((e) => CourierModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CourierModel>[],
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'store_id': const IntJson().toJson(instance.storeId),
      'name': const StringJson().toJson(instance.name),
      'slug': const StringJson().toJson(instance.slug),
      'description': const StringOrNullJson().toJson(instance.description),
      'product_type': const StringJson().toJson(instance.productType),
      'base_price': const DoubleJson().toJson(instance.basePrice),
      'compare_at_price':
          const DoubleOrNullJson().toJson(instance.compareAtPrice),
      'weight_grams': const IntOrNullJson().toJson(instance.weightGrams),
      'status': const StringJson().toJson(instance.status),
      'sold_count': const IntJson().toJson(instance.soldCount),
      'view_count': const IntJson().toJson(instance.viewCount),
      'rating_avg': const DoubleJson().toJson(instance.ratingAvg),
      'rating_count': const IntJson().toJson(instance.ratingCount),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
      'stock': const IntOrNullJson().toJson(instance.stock),
      'flash_sale': instance.flashSale,
      'image_url': const StringOrNullJson().toJson(instance.listingImageUrl),
      'badges': instance.badges,
      'fulfillment_mode': const StringJson().toJson(instance.fulfillmentMode),
      'fulfillment_lead_time_days':
          const IntOrNullJson().toJson(instance.fulfillmentLeadTimeDays),
      'availability': const StringOrNullJson().toJson(instance.availability),
      'variants': instance.variants,
      'images': instance.images,
      'couriers': instance.couriers,
    };

_ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) =>
    _ProductVariantModel(
      id: const IntJson().fromJson(json['id']),
      productId: json['product_id'] == null
          ? 0
          : const IntJson().fromJson(json['product_id']),
      sku: const StringOrNullJson().fromJson(json['sku']),
      variantOptions: const JsonMapJson().fromJson(json['variant_options']),
      price: json['price'] == null
          ? 0
          : const DoubleJson().fromJson(json['price']),
      weightGrams: const IntOrNullJson().fromJson(json['weight_grams']),
      imageUrl: const StringOrNullJson().fromJson(json['image_url']),
      isActive: json['is_active'] == null
          ? true
          : const BoolJson().fromJson(json['is_active']),
      stock: const IntOrNullJson().fromJson(json['stock']),
      warehouseCity: const StringOrNullJson().fromJson(json['warehouse_city']),
      warehouseProvince:
          const StringOrNullJson().fromJson(json['warehouse_province']),
    );

Map<String, dynamic> _$ProductVariantModelToJson(
        _ProductVariantModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'product_id': const IntJson().toJson(instance.productId),
      'sku': const StringOrNullJson().toJson(instance.sku),
      'variant_options': const JsonMapJson().toJson(instance.variantOptions),
      'price': const DoubleJson().toJson(instance.price),
      'weight_grams': const IntOrNullJson().toJson(instance.weightGrams),
      'image_url': const StringOrNullJson().toJson(instance.imageUrl),
      'is_active': const BoolJson().toJson(instance.isActive),
      'stock': const IntOrNullJson().toJson(instance.stock),
      'warehouse_city': const StringOrNullJson().toJson(instance.warehouseCity),
      'warehouse_province':
          const StringOrNullJson().toJson(instance.warehouseProvince),
    };

_ProductImageModel _$ProductImageModelFromJson(Map<String, dynamic> json) =>
    _ProductImageModel(
      id: const IntJson().fromJson(json['id']),
      imageUrl: json['image_url'] == null
          ? ''
          : const StringJson().fromJson(json['image_url']),
      sortOrder: json['sort_order'] == null
          ? 0
          : const IntJson().fromJson(json['sort_order']),
    );

Map<String, dynamic> _$ProductImageModelToJson(_ProductImageModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'image_url': const StringJson().toJson(instance.imageUrl),
      'sort_order': const IntJson().toJson(instance.sortOrder),
    };

_CourierModel _$CourierModelFromJson(Map<String, dynamic> json) =>
    _CourierModel(
      code:
          json['code'] == null ? '' : const StringJson().fromJson(json['code']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      isActive: json['is_active'] == null
          ? true
          : const BoolJson().fromJson(json['is_active']),
    );

Map<String, dynamic> _$CourierModelToJson(_CourierModel instance) =>
    <String, dynamic>{
      'code': const StringJson().toJson(instance.code),
      'name': const StringJson().toJson(instance.name),
      'is_active': const BoolJson().toJson(instance.isActive),
    };

_FlashSaleModel _$FlashSaleModelFromJson(Map<String, dynamic> json) =>
    _FlashSaleModel(
      flashPrice: json['flash_price'] == null
          ? 0
          : const DoubleJson().fromJson(json['flash_price']),
      soldCount: json['sold_count'] == null
          ? 0
          : const IntJson().fromJson(json['sold_count']),
      stockQuota: json['stock_quota'] == null
          ? 0
          : const IntJson().fromJson(json['stock_quota']),
      endsAt: const ServerDateTimeJson().fromJson(json['ends_at']),
    );

Map<String, dynamic> _$FlashSaleModelToJson(_FlashSaleModel instance) =>
    <String, dynamic>{
      'flash_price': const DoubleJson().toJson(instance.flashPrice),
      'sold_count': const IntJson().toJson(instance.soldCount),
      'stock_quota': const IntJson().toJson(instance.stockQuota),
      'ends_at': const ServerDateTimeJson().toJson(instance.endsAt),
    };
