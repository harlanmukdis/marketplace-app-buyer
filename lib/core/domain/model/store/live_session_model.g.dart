// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveSessionModel _$LiveSessionModelFromJson(Map<String, dynamic> json) =>
    _LiveSessionModel(
      id: const IntJson().fromJson(json['id']),
      storeId: json['store_id'] == null
          ? 0
          : const IntJson().fromJson(json['store_id']),
      storeName: json['store_name'] == null
          ? ''
          : const StringJson().fromJson(json['store_name']),
      title: json['title'] == null
          ? ''
          : const StringJson().fromJson(json['title']),
      thumbnailUrl: const StringOrNullJson().fromJson(json['thumbnail_url']),
      status: json['status'] == null
          ? 'live'
          : const StringJson().fromJson(json['status']),
      viewerCount: json['viewer_count'] == null
          ? 0
          : const IntJson().fromJson(json['viewer_count']),
      startedAt: const ServerDateTimeJson().fromJson(json['started_at']),
      scheduledAt: const ServerDateTimeJson().fromJson(json['scheduled_at']),
      promoLabel: const StringOrNullJson().fromJson(json['promo_label']),
      soldCount: json['sold_count'] == null
          ? 0
          : const IntJson().fromJson(json['sold_count']),
    );

Map<String, dynamic> _$LiveSessionModelToJson(_LiveSessionModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'store_id': const IntJson().toJson(instance.storeId),
      'store_name': const StringJson().toJson(instance.storeName),
      'title': const StringJson().toJson(instance.title),
      'thumbnail_url': const StringOrNullJson().toJson(instance.thumbnailUrl),
      'status': const StringJson().toJson(instance.status),
      'viewer_count': const IntJson().toJson(instance.viewerCount),
      'started_at': const ServerDateTimeJson().toJson(instance.startedAt),
      'scheduled_at': const ServerDateTimeJson().toJson(instance.scheduledAt),
      'promo_label': const StringOrNullJson().toJson(instance.promoLabel),
      'sold_count': const IntJson().toJson(instance.soldCount),
    };
