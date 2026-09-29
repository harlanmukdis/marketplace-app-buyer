// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProvinceModel {
  @IntJson()
  int get id;
  @StringJson()
  @JsonKey(name: 'province_name')
  String get name;
  @BoolJson()
  bool get active;

  /// Create a copy of ProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProvinceModelCopyWith<ProvinceModel> get copyWith =>
      _$ProvinceModelCopyWithImpl<ProvinceModel>(
          this as ProvinceModel, _$identity);

  /// Serializes this ProvinceModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProvinceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, active);

  @override
  String toString() {
    return 'ProvinceModel(id: $id, name: $name, active: $active)';
  }
}

/// @nodoc
abstract mixin class $ProvinceModelCopyWith<$Res> {
  factory $ProvinceModelCopyWith(
          ProvinceModel value, $Res Function(ProvinceModel) _then) =
      _$ProvinceModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'province_name') String name,
      @BoolJson() bool active});
}

/// @nodoc
class _$ProvinceModelCopyWithImpl<$Res>
    implements $ProvinceModelCopyWith<$Res> {
  _$ProvinceModelCopyWithImpl(this._self, this._then);

  final ProvinceModel _self;
  final $Res Function(ProvinceModel) _then;

  /// Create a copy of ProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? active = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProvinceModel].
extension ProvinceModelPatterns on ProvinceModel {
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
    TResult Function(_ProvinceModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProvinceModel() when $default != null:
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
    TResult Function(_ProvinceModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProvinceModel():
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
    TResult? Function(_ProvinceModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProvinceModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'province_name') String name,
            @BoolJson() bool active)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProvinceModel() when $default != null:
        return $default(_that.id, _that.name, _that.active);
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
            @StringJson() @JsonKey(name: 'province_name') String name,
            @BoolJson() bool active)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProvinceModel():
        return $default(_that.id, _that.name, _that.active);
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
            @StringJson() @JsonKey(name: 'province_name') String name,
            @BoolJson() bool active)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProvinceModel() when $default != null:
        return $default(_that.id, _that.name, _that.active);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProvinceModel implements ProvinceModel {
  const _ProvinceModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'province_name') this.name = '',
      @BoolJson() this.active = true});
  factory _ProvinceModel.fromJson(Map<String, dynamic> json) =>
      _$ProvinceModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringJson()
  @JsonKey(name: 'province_name')
  final String name;
  @override
  @JsonKey()
  @BoolJson()
  final bool active;

  /// Create a copy of ProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProvinceModelCopyWith<_ProvinceModel> get copyWith =>
      __$ProvinceModelCopyWithImpl<_ProvinceModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProvinceModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProvinceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, active);

  @override
  String toString() {
    return 'ProvinceModel(id: $id, name: $name, active: $active)';
  }
}

/// @nodoc
abstract mixin class _$ProvinceModelCopyWith<$Res>
    implements $ProvinceModelCopyWith<$Res> {
  factory _$ProvinceModelCopyWith(
          _ProvinceModel value, $Res Function(_ProvinceModel) _then) =
      __$ProvinceModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'province_name') String name,
      @BoolJson() bool active});
}

/// @nodoc
class __$ProvinceModelCopyWithImpl<$Res>
    implements _$ProvinceModelCopyWith<$Res> {
  __$ProvinceModelCopyWithImpl(this._self, this._then);

  final _ProvinceModel _self;
  final $Res Function(_ProvinceModel) _then;

  /// Create a copy of ProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? active = null,
  }) {
    return _then(_ProvinceModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$CityModel {
  @IntJson()
  int get id;
  @StringJson()
  @JsonKey(name: 'city_name')
  String get name;
  @IntJson()
  @JsonKey(name: 'province_id')
  int get provinceId;
  @BoolJson()
  bool get active;

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CityModelCopyWith<CityModel> get copyWith =>
      _$CityModelCopyWithImpl<CityModel>(this as CityModel, _$identity);

  /// Serializes this CityModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CityModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provinceId, provinceId) ||
                other.provinceId == provinceId) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, provinceId, active);

  @override
  String toString() {
    return 'CityModel(id: $id, name: $name, provinceId: $provinceId, active: $active)';
  }
}

/// @nodoc
abstract mixin class $CityModelCopyWith<$Res> {
  factory $CityModelCopyWith(CityModel value, $Res Function(CityModel) _then) =
      _$CityModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'city_name') String name,
      @IntJson() @JsonKey(name: 'province_id') int provinceId,
      @BoolJson() bool active});
}

/// @nodoc
class _$CityModelCopyWithImpl<$Res> implements $CityModelCopyWith<$Res> {
  _$CityModelCopyWithImpl(this._self, this._then);

  final CityModel _self;
  final $Res Function(CityModel) _then;

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provinceId = null,
    Object? active = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      provinceId: null == provinceId
          ? _self.provinceId
          : provinceId // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CityModel].
extension CityModelPatterns on CityModel {
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
    TResult Function(_CityModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CityModel() when $default != null:
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
    TResult Function(_CityModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CityModel():
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
    TResult? Function(_CityModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CityModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'city_name') String name,
            @IntJson() @JsonKey(name: 'province_id') int provinceId,
            @BoolJson() bool active)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CityModel() when $default != null:
        return $default(_that.id, _that.name, _that.provinceId, _that.active);
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
            @StringJson() @JsonKey(name: 'city_name') String name,
            @IntJson() @JsonKey(name: 'province_id') int provinceId,
            @BoolJson() bool active)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CityModel():
        return $default(_that.id, _that.name, _that.provinceId, _that.active);
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
            @StringJson() @JsonKey(name: 'city_name') String name,
            @IntJson() @JsonKey(name: 'province_id') int provinceId,
            @BoolJson() bool active)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CityModel() when $default != null:
        return $default(_that.id, _that.name, _that.provinceId, _that.active);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CityModel implements CityModel {
  const _CityModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'city_name') this.name = '',
      @IntJson() @JsonKey(name: 'province_id') this.provinceId = 0,
      @BoolJson() this.active = true});
  factory _CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringJson()
  @JsonKey(name: 'city_name')
  final String name;
  @override
  @IntJson()
  @JsonKey(name: 'province_id')
  final int provinceId;
  @override
  @JsonKey()
  @BoolJson()
  final bool active;

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CityModelCopyWith<_CityModel> get copyWith =>
      __$CityModelCopyWithImpl<_CityModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CityModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CityModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provinceId, provinceId) ||
                other.provinceId == provinceId) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, provinceId, active);

  @override
  String toString() {
    return 'CityModel(id: $id, name: $name, provinceId: $provinceId, active: $active)';
  }
}

/// @nodoc
abstract mixin class _$CityModelCopyWith<$Res>
    implements $CityModelCopyWith<$Res> {
  factory _$CityModelCopyWith(
          _CityModel value, $Res Function(_CityModel) _then) =
      __$CityModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'city_name') String name,
      @IntJson() @JsonKey(name: 'province_id') int provinceId,
      @BoolJson() bool active});
}

/// @nodoc
class __$CityModelCopyWithImpl<$Res> implements _$CityModelCopyWith<$Res> {
  __$CityModelCopyWithImpl(this._self, this._then);

  final _CityModel _self;
  final $Res Function(_CityModel) _then;

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provinceId = null,
    Object? active = null,
  }) {
    return _then(_CityModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      provinceId: null == provinceId
          ? _self.provinceId
          : provinceId // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
