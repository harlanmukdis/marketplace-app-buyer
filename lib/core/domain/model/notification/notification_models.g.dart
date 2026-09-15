// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: const IntJson().fromJson(json['id']),
      typeCode:
          json['type'] == null ? '' : const StringJson().fromJson(json['type']),
      title: json['title'] == null
          ? ''
          : const StringJson().fromJson(json['title']),
      body:
          json['body'] == null ? '' : const StringJson().fromJson(json['body']),
      data: const JsonMapJson().fromJson(json['data']),
      isRead: json['is_read'] == null
          ? false
          : const BoolJson().fromJson(json['is_read']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'type': const StringJson().toJson(instance.typeCode),
      'title': const StringJson().toJson(instance.title),
      'body': const StringJson().toJson(instance.body),
      'data': const JsonMapJson().toJson(instance.data),
      'is_read': const BoolJson().toJson(instance.isRead),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };
