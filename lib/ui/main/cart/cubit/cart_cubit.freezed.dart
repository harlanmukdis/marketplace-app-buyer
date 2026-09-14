// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CartState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CartState()';
  }
}

/// @nodoc
class $CartStateCopyWith<$Res> {
  $CartStateCopyWith(CartState _, $Res Function(CartState) __);
}

/// Adds pattern-matching-related methods to [CartState].
extension CartStatePatterns on CartState {
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
    TResult Function(CartLoading value)? loading,
    TResult Function(CartReady value)? ready,
    TResult Function(CartError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CartLoading() when loading != null:
        return loading(_that);
      case CartReady() when ready != null:
        return ready(_that);
      case CartError() when error != null:
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
    required TResult Function(CartLoading value) loading,
    required TResult Function(CartReady value) ready,
    required TResult Function(CartError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case CartLoading():
        return loading(_that);
      case CartReady():
        return ready(_that);
      case CartError():
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
    TResult? Function(CartLoading value)? loading,
    TResult? Function(CartReady value)? ready,
    TResult? Function(CartError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CartLoading() when loading != null:
        return loading(_that);
      case CartReady() when ready != null:
        return ready(_that);
      case CartError() when error != null:
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
    TResult Function(CartSnapshot cart, Set<int> mutatingItemIds,
            DataError? actionError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CartLoading() when loading != null:
        return loading();
      case CartReady() when ready != null:
        return ready(_that.cart, _that.mutatingItemIds, _that.actionError);
      case CartError() when error != null:
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
            CartSnapshot cart, Set<int> mutatingItemIds, DataError? actionError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case CartLoading():
        return loading();
      case CartReady():
        return ready(_that.cart, _that.mutatingItemIds, _that.actionError);
      case CartError():
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
    TResult? Function(CartSnapshot cart, Set<int> mutatingItemIds,
            DataError? actionError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CartLoading() when loading != null:
        return loading();
      case CartReady() when ready != null:
        return ready(_that.cart, _that.mutatingItemIds, _that.actionError);
      case CartError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class CartLoading extends CartState {
  const CartLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CartLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CartState.loading()';
  }
}

/// @nodoc

class CartReady extends CartState {
  const CartReady(
      {required this.cart,
      final Set<int> mutatingItemIds = const <int>{},
      this.actionError})
      : _mutatingItemIds = mutatingItemIds,
        super._();

  final CartSnapshot cart;

  /// Id baris yang sedang menunggu balasan server.
  final Set<int> _mutatingItemIds;

  /// Id baris yang sedang menunggu balasan server.
  @JsonKey()
  Set<int> get mutatingItemIds {
    if (_mutatingItemIds is EqualUnmodifiableSetView) return _mutatingItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_mutatingItemIds);
  }

  /// Kegagalan aksi terakhir yang **tidak** menghapus isi keranjang —
  /// mis. gagal mengubah kuantitas. Layar menampilkannya sebagai snackbar,
  /// bukan sebagai layar error.
  final DataError? actionError;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CartReadyCopyWith<CartReady> get copyWith =>
      _$CartReadyCopyWithImpl<CartReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CartReady &&
            (identical(other.cart, cart) || other.cart == cart) &&
            const DeepCollectionEquality()
                .equals(other._mutatingItemIds, _mutatingItemIds) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cart,
      const DeepCollectionEquality().hash(_mutatingItemIds), actionError);

  @override
  String toString() {
    return 'CartState.ready(cart: $cart, mutatingItemIds: $mutatingItemIds, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $CartReadyCopyWith<$Res>
    implements $CartStateCopyWith<$Res> {
  factory $CartReadyCopyWith(CartReady value, $Res Function(CartReady) _then) =
      _$CartReadyCopyWithImpl;
  @useResult
  $Res call(
      {CartSnapshot cart, Set<int> mutatingItemIds, DataError? actionError});
}

/// @nodoc
class _$CartReadyCopyWithImpl<$Res> implements $CartReadyCopyWith<$Res> {
  _$CartReadyCopyWithImpl(this._self, this._then);

  final CartReady _self;
  final $Res Function(CartReady) _then;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cart = null,
    Object? mutatingItemIds = null,
    Object? actionError = freezed,
  }) {
    return _then(CartReady(
      cart: null == cart
          ? _self.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as CartSnapshot,
      mutatingItemIds: null == mutatingItemIds
          ? _self._mutatingItemIds
          : mutatingItemIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class CartError extends CartState {
  const CartError(this.error) : super._();

  final DataError error;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CartErrorCopyWith<CartError> get copyWith =>
      _$CartErrorCopyWithImpl<CartError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CartError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'CartState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $CartErrorCopyWith<$Res>
    implements $CartStateCopyWith<$Res> {
  factory $CartErrorCopyWith(CartError value, $Res Function(CartError) _then) =
      _$CartErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$CartErrorCopyWithImpl<$Res> implements $CartErrorCopyWith<$Res> {
  _$CartErrorCopyWithImpl(this._self, this._then);

  final CartError _self;
  final $Res Function(CartError) _then;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(CartError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
