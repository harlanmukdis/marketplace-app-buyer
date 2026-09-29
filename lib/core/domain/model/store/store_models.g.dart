// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => _StoreModel(
      id: const IntJson().fromJson(json['id']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      slug:
          json['slug'] == null ? '' : const StringJson().fromJson(json['slug']),
      description: const StringOrNullJson().fromJson(json['description']),
      logoUrl: const StringOrNullJson().fromJson(json['logo_url']),
      bannerUrl: const StringOrNullJson().fromJson(json['banner_url']),
      ratingAvg: json['rating_avg'] == null
          ? 0
          : const DoubleJson().fromJson(json['rating_avg']),
      ratingCount: json['rating_count'] == null
          ? 0
          : const IntJson().fromJson(json['rating_count']),
      followerCount: json['follower_count'] == null
          ? 0
          : const IntJson().fromJson(json['follower_count']),
      openedAt: const ServerDateTimeJson().fromJson(json['opened_at']),
      primaryStatus: json['primary_status'] == null
          ? 'unverified'
          : const StringJson().fromJson(json['primary_status']),
      hasSignatureBadge: json['has_signature_badge'] == null
          ? false
          : const BoolJson().fromJson(json['has_signature_badge']),
      isFollowing: json['is_following'] == null
          ? false
          : const BoolJson().fromJson(json['is_following']),
    );

Map<String, dynamic> _$StoreModelToJson(_StoreModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'name': const StringJson().toJson(instance.name),
      'slug': const StringJson().toJson(instance.slug),
      'description': const StringOrNullJson().toJson(instance.description),
      'logo_url': const StringOrNullJson().toJson(instance.logoUrl),
      'banner_url': const StringOrNullJson().toJson(instance.bannerUrl),
      'rating_avg': const DoubleJson().toJson(instance.ratingAvg),
      'rating_count': const IntJson().toJson(instance.ratingCount),
      'follower_count': const IntJson().toJson(instance.followerCount),
      'opened_at': const ServerDateTimeJson().toJson(instance.openedAt),
      'primary_status': const StringJson().toJson(instance.primaryStatus),
      'has_signature_badge':
          const BoolJson().toJson(instance.hasSignatureBadge),
      'is_following': const BoolJson().toJson(instance.isFollowing),
    };

_FollowedStoreModel _$FollowedStoreModelFromJson(Map<String, dynamic> json) =>
    _FollowedStoreModel(
      id: const IntJson().fromJson(json['id']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      logoUrl: const StringOrNullJson().fromJson(json['logo_url']),
      ratingAvg: json['rating_avg'] == null
          ? 0
          : const DoubleJson().fromJson(json['rating_avg']),
      ratingCount: json['rating_count'] == null
          ? 0
          : const IntJson().fromJson(json['rating_count']),
      followedAt: const ServerDateTimeJson().fromJson(json['followed_at']),
    );

Map<String, dynamic> _$FollowedStoreModelToJson(_FollowedStoreModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'name': const StringJson().toJson(instance.name),
      'logo_url': const StringOrNullJson().toJson(instance.logoUrl),
      'rating_avg': const DoubleJson().toJson(instance.ratingAvg),
      'rating_count': const IntJson().toJson(instance.ratingCount),
      'followed_at': const ServerDateTimeJson().toJson(instance.followedAt),
    };
