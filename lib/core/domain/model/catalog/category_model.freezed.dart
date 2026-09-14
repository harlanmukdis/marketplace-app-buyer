// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryModel {
  @IntJson()
  int get id;
  @IntOrNullJson()
  @JsonKey(name: 'parent_id')
  int? get parentId;
  @StringJson()
  String get name;
  @StringJson()
  String get slug;
  @StringOrNullJson()
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @IntJson()
  int get level;
  @IntJson()
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @BoolJson()
  @JsonKey(name: 'is_active')
  bool get isActive;
  List<CategoryModel> get children;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      _$CategoryModelCopyWithImpl<CategoryModel>(
          this as CategoryModel, _$identity);

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other.children, children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      parentId,
      name,
      slug,
      iconUrl,
      level,
      sortOrder,
      isActive,
      const DeepCollectionEquality().hash(children));

  @override
  String toString() {
    return 'CategoryModel(id: $id, parentId: $parentId, name: $name, slug: $slug, iconUrl: $iconUrl, level: $level, sortOrder: $sortOrder, isActive: $isActive, children: $children)';
  }
}

/// @nodoc
abstract mixin class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
          CategoryModel value, $Res Function(CategoryModel) _then) =
      _$CategoryModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntOrNullJson() @JsonKey(name: 'parent_id') int? parentId,
      @StringJson() String name,
      @StringJson() String slug,
      @StringOrNullJson() @JsonKey(name: 'icon_url') String? iconUrl,
      @IntJson() int level,
      @IntJson() @JsonKey(name: 'sort_order') int sortOrder,
      @BoolJson() @JsonKey(name: 'is_active') bool isActive,
      List<CategoryModel> children});
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._self, this._then);

  final CategoryModel _self;
  final $Res Function(CategoryModel) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? name = null,
    Object? slug = null,
    Object? iconUrl = freezed,
    Object? level = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? children = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _self.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      children: null == children
          ? _self.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryModel].
extension CategoryModelPatterns on CategoryModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CategoryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CategoryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CategoryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @IntJson() int id,
            @IntOrNullJson() @JsonKey(name: 'parent_id') int? parentId,
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() @JsonKey(name: 'icon_url') String? iconUrl,
            @IntJson() int level,
            @IntJson() @JsonKey(name: 'sort_order') int sortOrder,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive,
            List<CategoryModel> children)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
        return $default(
            _that.id,
            _that.parentId,
            _that.name,
            _that.slug,
            _that.iconUrl,
            _that.level,
            _that.sortOrder,
            _that.isActive,
            _that.children);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @IntJson() int id,
            @IntOrNullJson() @JsonKey(name: 'parent_id') int? parentId,
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() @JsonKey(name: 'icon_url') String? iconUrl,
            @IntJson() int level,
            @IntJson() @JsonKey(name: 'sort_order') int sortOrder,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive,
            List<CategoryModel> children)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel():
        return $default(
            _that.id,
            _that.parentId,
            _that.name,
            _that.slug,
            _that.iconUrl,
            _that.level,
            _that.sortOrder,
            _that.isActive,
            _that.children);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @IntJson() int id,
            @IntOrNullJson() @JsonKey(name: 'parent_id') int? parentId,
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() @JsonKey(name: 'icon_url') String? iconUrl,
            @IntJson() int level,
            @IntJson() @JsonKey(name: 'sort_order') int sortOrder,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive,
            List<CategoryModel> children)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
        return $default(
            _that.id,
            _that.parentId,
            _that.name,
            _that.slug,
            _that.iconUrl,
            _that.level,
            _that.sortOrder,
            _that.isActive,
            _that.children);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CategoryModel extends CategoryModel {
  const _CategoryModel(
      {@IntJson() required this.id,
      @IntOrNullJson() @JsonKey(name: 'parent_id') this.parentId,
      @StringJson() this.name = '',
      @StringJson() this.slug = '',
      @StringOrNullJson() @JsonKey(name: 'icon_url') this.iconUrl,
      @IntJson() this.level = 0,
      @IntJson() @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @BoolJson() @JsonKey(name: 'is_active') this.isActive = true,
      final List<CategoryModel> children = const <CategoryModel>[]})
      : _children = children,
        super._();
  factory _CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'parent_id')
  final int? parentId;
  @override
  @JsonKey()
  @StringJson()
  final String name;
  @override
  @JsonKey()
  @StringJson()
  final String slug;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey()
  @IntJson()
  final int level;
  @override
  @IntJson()
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @BoolJson()
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<CategoryModel> _children;
  @override
  @JsonKey()
  List<CategoryModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryModelCopyWith<_CategoryModel> get copyWith =>
      __$CategoryModelCopyWithImpl<_CategoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      parentId,
      name,
      slug,
      iconUrl,
      level,
      sortOrder,
      isActive,
      const DeepCollectionEquality().hash(_children));

  @override
  String toString() {
    return 'CategoryModel(id: $id, parentId: $parentId, name: $name, slug: $slug, iconUrl: $iconUrl, level: $level, sortOrder: $sortOrder, isActive: $isActive, children: $children)';
  }
}

/// @nodoc
abstract mixin class _$CategoryModelCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$CategoryModelCopyWith(
          _CategoryModel value, $Res Function(_CategoryModel) _then) =
      __$CategoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntOrNullJson() @JsonKey(name: 'parent_id') int? parentId,
      @StringJson() String name,
      @StringJson() String slug,
      @StringOrNullJson() @JsonKey(name: 'icon_url') String? iconUrl,
      @IntJson() int level,
      @IntJson() @JsonKey(name: 'sort_order') int sortOrder,
      @BoolJson() @JsonKey(name: 'is_active') bool isActive,
      List<CategoryModel> children});
}

/// @nodoc
class __$CategoryModelCopyWithImpl<$Res>
    implements _$CategoryModelCopyWith<$Res> {
  __$CategoryModelCopyWithImpl(this._self, this._then);

  final _CategoryModel _self;
  final $Res Function(_CategoryModel) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? name = null,
    Object? slug = null,
    Object? iconUrl = freezed,
    Object? level = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? children = null,
  }) {
    return _then(_CategoryModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _self.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      children: null == children
          ? _self._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
    ));
  }
}

// dart format on
