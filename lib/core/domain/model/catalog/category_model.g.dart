// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: const IntJson().fromJson(json['id']),
      parentId: const IntOrNullJson().fromJson(json['parent_id']),
      name:
          json['name'] == null ? '' : const StringJson().fromJson(json['name']),
      slug:
          json['slug'] == null ? '' : const StringJson().fromJson(json['slug']),
      iconUrl: const StringOrNullJson().fromJson(json['icon_url']),
      level:
          json['level'] == null ? 0 : const IntJson().fromJson(json['level']),
      sortOrder: json['sort_order'] == null
          ? 0
          : const IntJson().fromJson(json['sort_order']),
      isActive: json['is_active'] == null
          ? true
          : const BoolJson().fromJson(json['is_active']),
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CategoryModel>[],
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'parent_id': const IntOrNullJson().toJson(instance.parentId),
      'name': const StringJson().toJson(instance.name),
      'slug': const StringJson().toJson(instance.slug),
      'icon_url': const StringOrNullJson().toJson(instance.iconUrl),
      'level': const IntJson().toJson(instance.level),
      'sort_order': const IntJson().toJson(instance.sortOrder),
      'is_active': const BoolJson().toJson(instance.isActive),
      'children': instance.children,
    };
