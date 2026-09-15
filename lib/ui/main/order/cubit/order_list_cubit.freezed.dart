// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderListState()';
  }
}

/// @nodoc
class $OrderListStateCopyWith<$Res> {
  $OrderListStateCopyWith(OrderListState _, $Res Function(OrderListState) __);
}

/// Adds pattern-matching-related methods to [OrderListState].
extension OrderListStatePatterns on OrderListState {
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
    TResult Function(OrderListLoading value)? loading,
    TResult Function(OrderListLoaded value)? loaded,
    TResult Function(OrderListEmpty value)? empty,
    TResult Function(OrderListError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderListLoading() when loading != null:
        return loading(_that);
      case OrderListLoaded() when loaded != null:
        return loaded(_that);
      case OrderListEmpty() when empty != null:
        return empty(_that);
      case OrderListError() when error != null:
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
    required TResult Function(OrderListLoading value) loading,
    required TResult Function(OrderListLoaded value) loaded,
    required TResult Function(OrderListEmpty value) empty,
    required TResult Function(OrderListError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderListLoading():
        return loading(_that);
      case OrderListLoaded():
        return loaded(_that);
      case OrderListEmpty():
        return empty(_that);
      case OrderListError():
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
    TResult? Function(OrderListLoading value)? loading,
    TResult? Function(OrderListLoaded value)? loaded,
    TResult? Function(OrderListEmpty value)? empty,
    TResult? Function(OrderListError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderListLoading() when loading != null:
        return loading(_that);
      case OrderListLoaded() when loaded != null:
        return loaded(_that);
      case OrderListEmpty() when empty != null:
        return empty(_that);
      case OrderListError() when error != null:
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
    TResult Function(List<OrderModel> orders, int page, bool hasMore,
            bool isLoadingMore, DataError? loadMoreError)?
        loaded,
    TResult Function()? empty,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderListLoading() when loading != null:
        return loading();
      case OrderListLoaded() when loaded != null:
        return loaded(_that.orders, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case OrderListEmpty() when empty != null:
        return empty();
      case OrderListError() when error != null:
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
    required TResult Function(List<OrderModel> orders, int page, bool hasMore,
            bool isLoadingMore, DataError? loadMoreError)
        loaded,
    required TResult Function() empty,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderListLoading():
        return loading();
      case OrderListLoaded():
        return loaded(_that.orders, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case OrderListEmpty():
        return empty();
      case OrderListError():
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
    TResult? Function(List<OrderModel> orders, int page, bool hasMore,
            bool isLoadingMore, DataError? loadMoreError)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderListLoading() when loading != null:
        return loading();
      case OrderListLoaded() when loaded != null:
        return loaded(_that.orders, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case OrderListEmpty() when empty != null:
        return empty();
      case OrderListError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class OrderListLoading extends OrderListState {
  const OrderListLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderListLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderListState.loading()';
  }
}

/// @nodoc

class OrderListLoaded extends OrderListState {
  const OrderListLoaded(
      {required final List<OrderModel> orders,
      this.page = 1,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.loadMoreError})
      : _orders = orders,
        super._();

  final List<OrderModel> _orders;
  List<OrderModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @JsonKey()
  final int page;

  /// **Disimpulkan, bukan dibaca.** `GET /orders` tidak mengirim `meta`
  /// sama sekali — tidak ada `total` — jadi satu-satunya petunjuk adanya
  /// halaman berikutnya adalah halaman terakhir terisi penuh.
  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;
  final DataError? loadMoreError;

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderListLoadedCopyWith<OrderListLoaded> get copyWith =>
      _$OrderListLoadedCopyWithImpl<OrderListLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderListLoaded &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.loadMoreError, loadMoreError) ||
                other.loadMoreError == loadMoreError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_orders),
      page,
      hasMore,
      isLoadingMore,
      loadMoreError);

  @override
  String toString() {
    return 'OrderListState.loaded(orders: $orders, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
  }
}

/// @nodoc
abstract mixin class $OrderListLoadedCopyWith<$Res>
    implements $OrderListStateCopyWith<$Res> {
  factory $OrderListLoadedCopyWith(
          OrderListLoaded value, $Res Function(OrderListLoaded) _then) =
      _$OrderListLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<OrderModel> orders,
      int page,
      bool hasMore,
      bool isLoadingMore,
      DataError? loadMoreError});
}

/// @nodoc
class _$OrderListLoadedCopyWithImpl<$Res>
    implements $OrderListLoadedCopyWith<$Res> {
  _$OrderListLoadedCopyWithImpl(this._self, this._then);

  final OrderListLoaded _self;
  final $Res Function(OrderListLoaded) _then;

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orders = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(OrderListLoaded(
      orders: null == orders
          ? _self._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadMoreError: freezed == loadMoreError
          ? _self.loadMoreError
          : loadMoreError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class OrderListEmpty extends OrderListState {
  const OrderListEmpty() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderListEmpty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderListState.empty()';
  }
}

/// @nodoc

class OrderListError extends OrderListState {
  const OrderListError(this.error) : super._();

  final DataError error;

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderListErrorCopyWith<OrderListError> get copyWith =>
      _$OrderListErrorCopyWithImpl<OrderListError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderListError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'OrderListState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $OrderListErrorCopyWith<$Res>
    implements $OrderListStateCopyWith<$Res> {
  factory $OrderListErrorCopyWith(
          OrderListError value, $Res Function(OrderListError) _then) =
      _$OrderListErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$OrderListErrorCopyWithImpl<$Res>
    implements $OrderListErrorCopyWith<$Res> {
  _$OrderListErrorCopyWithImpl(this._self, this._then);

  final OrderListError _self;
  final $Res Function(OrderListError) _then;

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(OrderListError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
