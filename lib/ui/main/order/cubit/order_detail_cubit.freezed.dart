// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderDetailState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderDetailState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderDetailState()';
  }
}

/// @nodoc
class $OrderDetailStateCopyWith<$Res> {
  $OrderDetailStateCopyWith(
      OrderDetailState _, $Res Function(OrderDetailState) __);
}

/// Adds pattern-matching-related methods to [OrderDetailState].
extension OrderDetailStatePatterns on OrderDetailState {
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
    TResult Function(OrderDetailLoading value)? loading,
    TResult Function(OrderDetailLoaded value)? loaded,
    TResult Function(OrderDetailError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading(_that);
      case OrderDetailLoaded() when loaded != null:
        return loaded(_that);
      case OrderDetailError() when error != null:
        return error(_that);
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
    required TResult Function(OrderDetailLoading value) loading,
    required TResult Function(OrderDetailLoaded value) loaded,
    required TResult Function(OrderDetailError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading():
        return loading(_that);
      case OrderDetailLoaded():
        return loaded(_that);
      case OrderDetailError():
        return error(_that);
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
    TResult? Function(OrderDetailLoading value)? loading,
    TResult? Function(OrderDetailLoaded value)? loaded,
    TResult? Function(OrderDetailError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading(_that);
      case OrderDetailLoaded() when loaded != null:
        return loaded(_that);
      case OrderDetailError() when error != null:
        return error(_that);
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
    TResult Function()? loading,
    TResult Function(
            OrderModel order, bool isSubmitting, DataError? actionError)?
        loaded,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading();
      case OrderDetailLoaded() when loaded != null:
        return loaded(_that.order, _that.isSubmitting, _that.actionError);
      case OrderDetailError() when error != null:
        return error(_that.error);
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
    required TResult Function() loading,
    required TResult Function(
            OrderModel order, bool isSubmitting, DataError? actionError)
        loaded,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading():
        return loading();
      case OrderDetailLoaded():
        return loaded(_that.order, _that.isSubmitting, _that.actionError);
      case OrderDetailError():
        return error(_that.error);
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
    TResult? Function()? loading,
    TResult? Function(
            OrderModel order, bool isSubmitting, DataError? actionError)?
        loaded,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading();
      case OrderDetailLoaded() when loaded != null:
        return loaded(_that.order, _that.isSubmitting, _that.actionError);
      case OrderDetailError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class OrderDetailLoading extends OrderDetailState {
  const OrderDetailLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderDetailLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderDetailState.loading()';
  }
}

/// @nodoc

class OrderDetailLoaded extends OrderDetailState {
  const OrderDetailLoaded(
      {required this.order, this.isSubmitting = false, this.actionError})
      : super._();

  final OrderModel order;

  /// Sedang mengirim aksi status (batal / konfirmasi terima / selesai).
  @JsonKey()
  final bool isSubmitting;
  final DataError? actionError;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderDetailLoadedCopyWith<OrderDetailLoaded> get copyWith =>
      _$OrderDetailLoadedCopyWithImpl<OrderDetailLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderDetailLoaded &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, order, isSubmitting, actionError);

  @override
  String toString() {
    return 'OrderDetailState.loaded(order: $order, isSubmitting: $isSubmitting, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $OrderDetailLoadedCopyWith<$Res>
    implements $OrderDetailStateCopyWith<$Res> {
  factory $OrderDetailLoadedCopyWith(
          OrderDetailLoaded value, $Res Function(OrderDetailLoaded) _then) =
      _$OrderDetailLoadedCopyWithImpl;
  @useResult
  $Res call({OrderModel order, bool isSubmitting, DataError? actionError});

  $OrderModelCopyWith<$Res> get order;
}

/// @nodoc
class _$OrderDetailLoadedCopyWithImpl<$Res>
    implements $OrderDetailLoadedCopyWith<$Res> {
  _$OrderDetailLoadedCopyWithImpl(this._self, this._then);

  final OrderDetailLoaded _self;
  final $Res Function(OrderDetailLoaded) _then;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? order = null,
    Object? isSubmitting = null,
    Object? actionError = freezed,
  }) {
    return _then(OrderDetailLoaded(
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderModel,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<$Res> get order {
    return $OrderModelCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

/// @nodoc

class OrderDetailError extends OrderDetailState {
  const OrderDetailError(this.error) : super._();

  final DataError error;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderDetailErrorCopyWith<OrderDetailError> get copyWith =>
      _$OrderDetailErrorCopyWithImpl<OrderDetailError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderDetailError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'OrderDetailState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $OrderDetailErrorCopyWith<$Res>
    implements $OrderDetailStateCopyWith<$Res> {
  factory $OrderDetailErrorCopyWith(
          OrderDetailError value, $Res Function(OrderDetailError) _then) =
      _$OrderDetailErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$OrderDetailErrorCopyWithImpl<$Res>
    implements $OrderDetailErrorCopyWith<$Res> {
  _$OrderDetailErrorCopyWithImpl(this._self, this._then);

  final OrderDetailError _self;
  final $Res Function(OrderDetailError) _then;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(OrderDetailError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
