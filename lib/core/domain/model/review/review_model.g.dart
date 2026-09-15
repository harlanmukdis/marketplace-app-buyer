// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => _ReviewModel(
      id: const IntJson().fromJson(json['id']),
      orderItemId: json['order_item_id'] == null
          ? 0
          : const IntJson().fromJson(json['order_item_id']),
      userId: json['user_id'] == null
          ? 0
          : const IntJson().fromJson(json['user_id']),
      productId: json['product_id'] == null
          ? 0
          : const IntJson().fromJson(json['product_id']),
      rating:
          json['rating'] == null ? 0 : const IntJson().fromJson(json['rating']),
      comment: const StringOrNullJson().fromJson(json['comment']),
      isAnonymous: json['is_anonymous'] == null
          ? false
          : const BoolJson().fromJson(json['is_anonymous']),
      status: json['status'] == null
          ? 'published'
          : const StringJson().fromJson(json['status']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'order_item_id': const IntJson().toJson(instance.orderItemId),
      'user_id': const IntJson().toJson(instance.userId),
      'product_id': const IntJson().toJson(instance.productId),
      'rating': const IntJson().toJson(instance.rating),
      'comment': const StringOrNullJson().toJson(instance.comment),
      'is_anonymous': const BoolJson().toJson(instance.isAnonymous),
      'status': const StringJson().toJson(instance.status),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };
