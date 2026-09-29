// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishlistItemModel _$WishlistItemModelFromJson(Map<String, dynamic> json) =>
    _WishlistItemModel(
      wishlistItemId: json['wishlist_item_id'] == null
          ? 0
          : const IntJson().fromJson(json['wishlist_item_id']),
      productId: const IntJson().fromJson(json['product_id']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      slug:
          json['slug'] == null ? '' : const StringJson().fromJson(json['slug']),
      minPrice: json['min_price'] == null
          ? 0
          : const DoubleJson().fromJson(json['min_price']),
      imageUrl: const StringOrNullJson().fromJson(json['image_url']),
      productStatus: json['product_status'] == null
          ? 'active'
          : const StringJson().fromJson(json['product_status']),
      addedAt: const ServerDateTimeJson().fromJson(json['added_at']),
      alertEnabled: const _BoolOrNullJson().fromJson(json['alert_enabled']),
    );

Map<String, dynamic> _$WishlistItemModelToJson(_WishlistItemModel instance) =>
    <String, dynamic>{
      'wishlist_item_id': const IntJson().toJson(instance.wishlistItemId),
      'product_id': const IntJson().toJson(instance.productId),
      'name': const StringJson().toJson(instance.name),
      'slug': const StringJson().toJson(instance.slug),
      'min_price': const DoubleJson().toJson(instance.minPrice),
      'image_url': const StringOrNullJson().toJson(instance.imageUrl),
      'product_status': const StringJson().toJson(instance.productStatus),
      'added_at': const ServerDateTimeJson().toJson(instance.addedAt),
      'alert_enabled': const _BoolOrNullJson().toJson(instance.alertEnabled),
    };
