// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_invoice_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderInvoiceState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderInvoiceState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderInvoiceState()';
  }
}

/// @nodoc
class $OrderInvoiceStateCopyWith<$Res> {
  $OrderInvoiceStateCopyWith(
      OrderInvoiceState _, $Res Function(OrderInvoiceState) __);
}

/// Adds pattern-matching-related methods to [OrderInvoiceState].
extension OrderInvoiceStatePatterns on OrderInvoiceState {
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
    TResult Function(OrderInvoiceLoading value)? loading,
    TResult Function(OrderInvoiceLoaded value)? loaded,
    TResult Function(OrderInvoiceUnavailable value)? unavailable,
    TResult Function(OrderInvoiceError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderInvoiceLoading() when loading != null:
        return loading(_that);
      case OrderInvoiceLoaded() when loaded != null:
        return loaded(_that);
      case OrderInvoiceUnavailable() when unavailable != null:
        return unavailable(_that);
      case OrderInvoiceError() when error != null:
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
    required TResult Function(OrderInvoiceLoading value) loading,
    required TResult Function(OrderInvoiceLoaded value) loaded,
    required TResult Function(OrderInvoiceUnavailable value) unavailable,
    required TResult Function(OrderInvoiceError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderInvoiceLoading():
        return loading(_that);
      case OrderInvoiceLoaded():
        return loaded(_that);
      case OrderInvoiceUnavailable():
        return unavailable(_that);
      case OrderInvoiceError():
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
    TResult? Function(OrderInvoiceLoading value)? loading,
    TResult? Function(OrderInvoiceLoaded value)? loaded,
    TResult? Function(OrderInvoiceUnavailable value)? unavailable,
    TResult? Function(OrderInvoiceError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderInvoiceLoading() when loading != null:
        return loading(_that);
      case OrderInvoiceLoaded() when loaded != null:
        return loaded(_that);
      case OrderInvoiceUnavailable() when unavailable != null:
        return unavailable(_that);
      case OrderInvoiceError() when error != null:
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
    TResult Function(OrderInvoiceModel invoice)? loaded,
    TResult Function()? unavailable,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderInvoiceLoading() when loading != null:
        return loading();
      case OrderInvoiceLoaded() when loaded != null:
        return loaded(_that.invoice);
      case OrderInvoiceUnavailable() when unavailable != null:
        return unavailable();
      case OrderInvoiceError() when error != null:
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
    required TResult Function(OrderInvoiceModel invoice) loaded,
    required TResult Function() unavailable,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderInvoiceLoading():
        return loading();
      case OrderInvoiceLoaded():
        return loaded(_that.invoice);
      case OrderInvoiceUnavailable():
        return unavailable();
      case OrderInvoiceError():
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
    TResult? Function(OrderInvoiceModel invoice)? loaded,
    TResult? Function()? unavailable,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderInvoiceLoading() when loading != null:
        return loading();
      case OrderInvoiceLoaded() when loaded != null:
        return loaded(_that.invoice);
      case OrderInvoiceUnavailable() when unavailable != null:
        return unavailable();
      case OrderInvoiceError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class OrderInvoiceLoading implements OrderInvoiceState {
  const OrderInvoiceLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderInvoiceLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderInvoiceState.loading()';
  }
}

/// @nodoc

class OrderInvoiceLoaded implements OrderInvoiceState {
  const OrderInvoiceLoaded(this.invoice);

  final OrderInvoiceModel invoice;

  /// Create a copy of OrderInvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderInvoiceLoadedCopyWith<OrderInvoiceLoaded> get copyWith =>
      _$OrderInvoiceLoadedCopyWithImpl<OrderInvoiceLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderInvoiceLoaded &&
            (identical(other.invoice, invoice) || other.invoice == invoice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, invoice);

  @override
  String toString() {
    return 'OrderInvoiceState.loaded(invoice: $invoice)';
  }
}

/// @nodoc
abstract mixin class $OrderInvoiceLoadedCopyWith<$Res>
    implements $OrderInvoiceStateCopyWith<$Res> {
  factory $OrderInvoiceLoadedCopyWith(
          OrderInvoiceLoaded value, $Res Function(OrderInvoiceLoaded) _then) =
      _$OrderInvoiceLoadedCopyWithImpl;
  @useResult
  $Res call({OrderInvoiceModel invoice});

  $OrderInvoiceModelCopyWith<$Res> get invoice;
}

/// @nodoc
class _$OrderInvoiceLoadedCopyWithImpl<$Res>
    implements $OrderInvoiceLoadedCopyWith<$Res> {
  _$OrderInvoiceLoadedCopyWithImpl(this._self, this._then);

  final OrderInvoiceLoaded _self;
  final $Res Function(OrderInvoiceLoaded) _then;

  /// Create a copy of OrderInvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? invoice = null,
  }) {
    return _then(OrderInvoiceLoaded(
      null == invoice
          ? _self.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as OrderInvoiceModel,
    ));
  }

  /// Create a copy of OrderInvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderInvoiceModelCopyWith<$Res> get invoice {
    return $OrderInvoiceModelCopyWith<$Res>(_self.invoice, (value) {
      return _then(_self.copyWith(invoice: value));
    });
  }
}

/// @nodoc

class OrderInvoiceUnavailable implements OrderInvoiceState {
  const OrderInvoiceUnavailable();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderInvoiceUnavailable);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderInvoiceState.unavailable()';
  }
}

/// @nodoc

class OrderInvoiceError implements OrderInvoiceState {
  const OrderInvoiceError(this.error);

  final DataError error;

  /// Create a copy of OrderInvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderInvoiceErrorCopyWith<OrderInvoiceError> get copyWith =>
      _$OrderInvoiceErrorCopyWithImpl<OrderInvoiceError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderInvoiceError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'OrderInvoiceState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $OrderInvoiceErrorCopyWith<$Res>
    implements $OrderInvoiceStateCopyWith<$Res> {
  factory $OrderInvoiceErrorCopyWith(
          OrderInvoiceError value, $Res Function(OrderInvoiceError) _then) =
      _$OrderInvoiceErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$OrderInvoiceErrorCopyWithImpl<$Res>
    implements $OrderInvoiceErrorCopyWith<$Res> {
  _$OrderInvoiceErrorCopyWithImpl(this._self, this._then);

  final OrderInvoiceError _self;
  final $Res Function(OrderInvoiceError) _then;

  /// Create a copy of OrderInvoiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(OrderInvoiceError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
