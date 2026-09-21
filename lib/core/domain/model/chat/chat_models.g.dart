// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatConversationModel _$ChatConversationModelFromJson(
        Map<String, dynamic> json) =>
    _ChatConversationModel(
      id: const IntJson().fromJson(json['id']),
      storeId: json['store_id'] == null
          ? 0
          : const IntJson().fromJson(json['store_id']),
      storeName: json['store_name'] == null
          ? ''
          : const StringJson().fromJson(json['store_name']),
      lastMessageAt:
          const ServerDateTimeJson().fromJson(json['last_message_at']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
      buyerUnreadCount: json['buyer_unread_count'] == null
          ? 0
          : const IntJson().fromJson(json['buyer_unread_count']),
    );

Map<String, dynamic> _$ChatConversationModelToJson(
        _ChatConversationModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'store_id': const IntJson().toJson(instance.storeId),
      'store_name': const StringJson().toJson(instance.storeName),
      'last_message_at':
          const ServerDateTimeJson().toJson(instance.lastMessageAt),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
      'buyer_unread_count': const IntJson().toJson(instance.buyerUnreadCount),
    };

_ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    _ChatMessageModel(
      id: const IntJson().fromJson(json['id']),
      senderUserId: json['sender_user_id'] == null
          ? 0
          : const IntJson().fromJson(json['sender_user_id']),
      typeCode: json['message_type'] == null
          ? ''
          : const StringJson().fromJson(json['message_type']),
      content: const StringOrNullJson().fromJson(json['content']),
      sharedProductId:
          const IntOrNullJson().fromJson(json['shared_product_id']),
      sharedOrderId: const IntOrNullJson().fromJson(json['shared_order_id']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
      readAt: const ServerDateTimeJson().fromJson(json['read_at']),
    );

Map<String, dynamic> _$ChatMessageModelToJson(_ChatMessageModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'sender_user_id': const IntJson().toJson(instance.senderUserId),
      'message_type': const StringJson().toJson(instance.typeCode),
      'content': const StringOrNullJson().toJson(instance.content),
      'shared_product_id':
          const IntOrNullJson().toJson(instance.sharedProductId),
      'shared_order_id': const IntOrNullJson().toJson(instance.sharedOrderId),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
      'read_at': const ServerDateTimeJson().toJson(instance.readAt),
    };
