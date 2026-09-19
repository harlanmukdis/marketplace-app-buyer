// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipping_estimate_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShippingEstimateState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ShippingEstimateState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ShippingEstimateState()';
  }
}

/// @nodoc
class $ShippingEstimateStateCopyWith<$Res> {
  $ShippingEstimateStateCopyWith(
      ShippingEstimateState _, $Res Function(ShippingEstimateState) __);
}

/// Adds pattern-matching-related methods to [ShippingEstimateState].
extension ShippingEstimateStatePatterns on ShippingEstimateState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShippingEstimateHidden value)? hidden,
    TResult Function(ShippingEstimateLoading value)? loading,
    TResult Function(ShippingEstimateReady value)? ready,
    TResult Function(ShippingEstimateUnavailable value)? unavailable,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ShippingEstimateHidden() when hidden != null:
        return hidden(_that);
      case ShippingEstimateLoading() when loading != null:
        return loading(_that);
      case ShippingEstimateReady() when ready != null:
        return ready(_that);
      case ShippingEstimateUnavailable() when unavailable != null:
        return unavailable(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(ShippingEstimateHidden value) hidden,
    required TResult Function(ShippingEstimateLoading value) loading,
    required TResult Function(ShippingEstimateReady value) ready,
    required TResult Function(ShippingEstimateUnavailable value) unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case ShippingEstimateHidden():
        return hidden(_that);
      case ShippingEstimateLoading():
        return loading(_that);
      case ShippingEstimateReady():
        return ready(_that);
      case ShippingEstimateUnavailable():
        return unavailable(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShippingEstimateHidden value)? hidden,
    TResult? Function(ShippingEstimateLoading value)? loading,
    TResult? Function(ShippingEstimateReady value)? ready,
    TResult? Function(ShippingEstimateUnavailable value)? unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case ShippingEstimateHidden() when hidden != null:
        return hidden(_that);
      case ShippingEstimateLoading() when loading != null:
        return loading(_that);
      case ShippingEstimateReady() when ready != null:
        return ready(_that);
      case ShippingEstimateUnavailable() when unavailable != null:
        return unavailable(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? hidden,
    TResult Function(AddressModel address)? loading,
    TResult Function(AddressModel address, List<ShippingOptionModel> options)?
        ready,
    TResult Function(AddressModel address)? unavailable,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ShippingEstimateHidden() when hidden != null:
        return hidden();
      case ShippingEstimateLoading() when loading != null:
        return loading(_that.address);
      case ShippingEstimateReady() when ready != null:
        return ready(_that.address, _that.options);
      case ShippingEstimateUnavailable() when unavailable != null:
        return unavailable(_that.address);
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
  TResult when<TResult extends Object?>({
    required TResult Function() hidden,
    required TResult Function(AddressModel address) loading,
    required TResult Function(
            AddressModel address, List<ShippingOptionModel> options)
        ready,
    required TResult Function(AddressModel address) unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case ShippingEstimateHidden():
        return hidden();
      case ShippingEstimateLoading():
        return loading(_that.address);
      case ShippingEstimateReady():
        return ready(_that.address, _that.options);
      case ShippingEstimateUnavailable():
        return unavailable(_that.address);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? hidden,
    TResult? Function(AddressModel address)? loading,
    TResult? Function(AddressModel address, List<ShippingOptionModel> options)?
        ready,
    TResult? Function(AddressModel address)? unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case ShippingEstimateHidden() when hidden != null:
        return hidden();
      case ShippingEstimateLoading() when loading != null:
        return loading(_that.address);
      case ShippingEstimateReady() when ready != null:
        return ready(_that.address, _that.options);
      case ShippingEstimateUnavailable() when unavailable != null:
        return unavailable(_that.address);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ShippingEstimateHidden extends ShippingEstimateState {
  const ShippingEstimateHidden() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ShippingEstimateHidden);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ShippingEstimateState.hidden()';
  }
}

/// @nodoc

class ShippingEstimateLoading extends ShippingEstimateState {
  const ShippingEstimateLoading({required this.address}) : super._();

  final AddressModel address;

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShippingEstimateLoadingCopyWith<ShippingEstimateLoading> get copyWith =>
      _$ShippingEstimateLoadingCopyWithImpl<ShippingEstimateLoading>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShippingEstimateLoading &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

  @override
  String toString() {
    return 'ShippingEstimateState.loading(address: $address)';
  }
}

/// @nodoc
abstract mixin class $ShippingEstimateLoadingCopyWith<$Res>
    implements $ShippingEstimateStateCopyWith<$Res> {
  factory $ShippingEstimateLoadingCopyWith(ShippingEstimateLoading value,
          $Res Function(ShippingEstimateLoading) _then) =
      _$ShippingEstimateLoadingCopyWithImpl;
  @useResult
  $Res call({AddressModel address});

  $AddressModelCopyWith<$Res> get address;
}

/// @nodoc
class _$ShippingEstimateLoadingCopyWithImpl<$Res>
    implements $ShippingEstimateLoadingCopyWith<$Res> {
  _$ShippingEstimateLoadingCopyWithImpl(this._self, this._then);

  final ShippingEstimateLoading _self;
  final $Res Function(ShippingEstimateLoading) _then;

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? address = null,
  }) {
    return _then(ShippingEstimateLoading(
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressModel,
    ));
  }

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res> get address {
    return $AddressModelCopyWith<$Res>(_self.address, (value) {
      return _then(_self.copyWith(address: value));
    });
  }
}

/// @nodoc

class ShippingEstimateReady extends ShippingEstimateState {
  const ShippingEstimateReady(
      {required this.address, required final List<ShippingOptionModel> options})
      : _options = options,
        super._();

  final AddressModel address;
  final List<ShippingOptionModel> _options;
  List<ShippingOptionModel> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShippingEstimateReadyCopyWith<ShippingEstimateReady> get copyWith =>
      _$ShippingEstimateReadyCopyWithImpl<ShippingEstimateReady>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShippingEstimateReady &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, address, const DeepCollectionEquality().hash(_options));

  @override
  String toString() {
    return 'ShippingEstimateState.ready(address: $address, options: $options)';
  }
}

/// @nodoc
abstract mixin class $ShippingEstimateReadyCopyWith<$Res>
    implements $ShippingEstimateStateCopyWith<$Res> {
  factory $ShippingEstimateReadyCopyWith(ShippingEstimateReady value,
          $Res Function(ShippingEstimateReady) _then) =
      _$ShippingEstimateReadyCopyWithImpl;
  @useResult
  $Res call({AddressModel address, List<ShippingOptionModel> options});

  $AddressModelCopyWith<$Res> get address;
}

/// @nodoc
class _$ShippingEstimateReadyCopyWithImpl<$Res>
    implements $ShippingEstimateReadyCopyWith<$Res> {
  _$ShippingEstimateReadyCopyWithImpl(this._self, this._then);

  final ShippingEstimateReady _self;
  final $Res Function(ShippingEstimateReady) _then;

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? address = null,
    Object? options = null,
  }) {
    return _then(ShippingEstimateReady(
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      options: null == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<ShippingOptionModel>,
    ));
  }

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res> get address {
    return $AddressModelCopyWith<$Res>(_self.address, (value) {
      return _then(_self.copyWith(address: value));
    });
  }
}

/// @nodoc

class ShippingEstimateUnavailable extends ShippingEstimateState {
  const ShippingEstimateUnavailable({required this.address}) : super._();

  final AddressModel address;

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShippingEstimateUnavailableCopyWith<ShippingEstimateUnavailable>
      get copyWith => _$ShippingEstimateUnavailableCopyWithImpl<
          ShippingEstimateUnavailable>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShippingEstimateUnavailable &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

  @override
  String toString() {
    return 'ShippingEstimateState.unavailable(address: $address)';
  }
}

/// @nodoc
abstract mixin class $ShippingEstimateUnavailableCopyWith<$Res>
    implements $ShippingEstimateStateCopyWith<$Res> {
  factory $ShippingEstimateUnavailableCopyWith(
          ShippingEstimateUnavailable value,
          $Res Function(ShippingEstimateUnavailable) _then) =
      _$ShippingEstimateUnavailableCopyWithImpl;
  @useResult
  $Res call({AddressModel address});

  $AddressModelCopyWith<$Res> get address;
}

/// @nodoc
class _$ShippingEstimateUnavailableCopyWithImpl<$Res>
    implements $ShippingEstimateUnavailableCopyWith<$Res> {
  _$ShippingEstimateUnavailableCopyWithImpl(this._self, this._then);

  final ShippingEstimateUnavailable _self;
  final $Res Function(ShippingEstimateUnavailable) _then;

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? address = null,
  }) {
    return _then(ShippingEstimateUnavailable(
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressModel,
    ));
  }

  /// Create a copy of ShippingEstimateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res> get address {
    return $AddressModelCopyWith<$Res>(_self.address, (value) {
      return _then(_self.copyWith(address: value));
    });
  }
}

// dart format on
