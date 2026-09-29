// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_picker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationPickerState {
  /// `null` = belum pernah dimuat.
  List<ProvinceModel>? get provinces;

  /// Kota per `province_id`; kunci `0` = seluruh kota.
  Map<int, List<CityModel>> get cities;
  bool get loadingProvinces;
  bool get loadingCities;
  DataError? get error;

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationPickerStateCopyWith<LocationPickerState> get copyWith =>
      _$LocationPickerStateCopyWithImpl<LocationPickerState>(
          this as LocationPickerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocationPickerState &&
            const DeepCollectionEquality().equals(other.provinces, provinces) &&
            const DeepCollectionEquality().equals(other.cities, cities) &&
            (identical(other.loadingProvinces, loadingProvinces) ||
                other.loadingProvinces == loadingProvinces) &&
            (identical(other.loadingCities, loadingCities) ||
                other.loadingCities == loadingCities) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(provinces),
      const DeepCollectionEquality().hash(cities),
      loadingProvinces,
      loadingCities,
      error);

  @override
  String toString() {
    return 'LocationPickerState(provinces: $provinces, cities: $cities, loadingProvinces: $loadingProvinces, loadingCities: $loadingCities, error: $error)';
  }
}

/// @nodoc
abstract mixin class $LocationPickerStateCopyWith<$Res> {
  factory $LocationPickerStateCopyWith(
          LocationPickerState value, $Res Function(LocationPickerState) _then) =
      _$LocationPickerStateCopyWithImpl;
  @useResult
  $Res call(
      {List<ProvinceModel>? provinces,
      Map<int, List<CityModel>> cities,
      bool loadingProvinces,
      bool loadingCities,
      DataError? error});
}

/// @nodoc
class _$LocationPickerStateCopyWithImpl<$Res>
    implements $LocationPickerStateCopyWith<$Res> {
  _$LocationPickerStateCopyWithImpl(this._self, this._then);

  final LocationPickerState _self;
  final $Res Function(LocationPickerState) _then;

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provinces = freezed,
    Object? cities = null,
    Object? loadingProvinces = null,
    Object? loadingCities = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      provinces: freezed == provinces
          ? _self.provinces
          : provinces // ignore: cast_nullable_to_non_nullable
              as List<ProvinceModel>?,
      cities: null == cities
          ? _self.cities
          : cities // ignore: cast_nullable_to_non_nullable
              as Map<int, List<CityModel>>,
      loadingProvinces: null == loadingProvinces
          ? _self.loadingProvinces
          : loadingProvinces // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingCities: null == loadingCities
          ? _self.loadingCities
          : loadingCities // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LocationPickerState].
extension LocationPickerStatePatterns on LocationPickerState {
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
    TResult Function(_LocationPickerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocationPickerState() when $default != null:
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
    TResult Function(_LocationPickerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationPickerState():
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
    TResult? Function(_LocationPickerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationPickerState() when $default != null:
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
            List<ProvinceModel>? provinces,
            Map<int, List<CityModel>> cities,
            bool loadingProvinces,
            bool loadingCities,
            DataError? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LocationPickerState() when $default != null:
        return $default(_that.provinces, _that.cities, _that.loadingProvinces,
            _that.loadingCities, _that.error);
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
            List<ProvinceModel>? provinces,
            Map<int, List<CityModel>> cities,
            bool loadingProvinces,
            bool loadingCities,
            DataError? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationPickerState():
        return $default(_that.provinces, _that.cities, _that.loadingProvinces,
            _that.loadingCities, _that.error);
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
            List<ProvinceModel>? provinces,
            Map<int, List<CityModel>> cities,
            bool loadingProvinces,
            bool loadingCities,
            DataError? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LocationPickerState() when $default != null:
        return $default(_that.provinces, _that.cities, _that.loadingProvinces,
            _that.loadingCities, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LocationPickerState implements LocationPickerState {
  const _LocationPickerState(
      {final List<ProvinceModel>? provinces,
      final Map<int, List<CityModel>> cities = const <int, List<CityModel>>{},
      this.loadingProvinces = false,
      this.loadingCities = false,
      this.error})
      : _provinces = provinces,
        _cities = cities;

  /// `null` = belum pernah dimuat.
  final List<ProvinceModel>? _provinces;

  /// `null` = belum pernah dimuat.
  @override
  List<ProvinceModel>? get provinces {
    final value = _provinces;
    if (value == null) return null;
    if (_provinces is EqualUnmodifiableListView) return _provinces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Kota per `province_id`; kunci `0` = seluruh kota.
  final Map<int, List<CityModel>> _cities;

  /// Kota per `province_id`; kunci `0` = seluruh kota.
  @override
  @JsonKey()
  Map<int, List<CityModel>> get cities {
    if (_cities is EqualUnmodifiableMapView) return _cities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_cities);
  }

  @override
  @JsonKey()
  final bool loadingProvinces;
  @override
  @JsonKey()
  final bool loadingCities;
  @override
  final DataError? error;

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocationPickerStateCopyWith<_LocationPickerState> get copyWith =>
      __$LocationPickerStateCopyWithImpl<_LocationPickerState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocationPickerState &&
            const DeepCollectionEquality()
                .equals(other._provinces, _provinces) &&
            const DeepCollectionEquality().equals(other._cities, _cities) &&
            (identical(other.loadingProvinces, loadingProvinces) ||
                other.loadingProvinces == loadingProvinces) &&
            (identical(other.loadingCities, loadingCities) ||
                other.loadingCities == loadingCities) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_provinces),
      const DeepCollectionEquality().hash(_cities),
      loadingProvinces,
      loadingCities,
      error);

  @override
  String toString() {
    return 'LocationPickerState(provinces: $provinces, cities: $cities, loadingProvinces: $loadingProvinces, loadingCities: $loadingCities, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$LocationPickerStateCopyWith<$Res>
    implements $LocationPickerStateCopyWith<$Res> {
  factory _$LocationPickerStateCopyWith(_LocationPickerState value,
          $Res Function(_LocationPickerState) _then) =
      __$LocationPickerStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<ProvinceModel>? provinces,
      Map<int, List<CityModel>> cities,
      bool loadingProvinces,
      bool loadingCities,
      DataError? error});
}

/// @nodoc
class __$LocationPickerStateCopyWithImpl<$Res>
    implements _$LocationPickerStateCopyWith<$Res> {
  __$LocationPickerStateCopyWithImpl(this._self, this._then);

  final _LocationPickerState _self;
  final $Res Function(_LocationPickerState) _then;

  /// Create a copy of LocationPickerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? provinces = freezed,
    Object? cities = null,
    Object? loadingProvinces = null,
    Object? loadingCities = null,
    Object? error = freezed,
  }) {
    return _then(_LocationPickerState(
      provinces: freezed == provinces
          ? _self._provinces
          : provinces // ignore: cast_nullable_to_non_nullable
              as List<ProvinceModel>?,
      cities: null == cities
          ? _self._cities
          : cities // ignore: cast_nullable_to_non_nullable
              as Map<int, List<CityModel>>,
      loadingProvinces: null == loadingProvinces
          ? _self.loadingProvinces
          : loadingProvinces // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingCities: null == loadingCities
          ? _self.loadingCities
          : loadingCities // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

// dart format on
