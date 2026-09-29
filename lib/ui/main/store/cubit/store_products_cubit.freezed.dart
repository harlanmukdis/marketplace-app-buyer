// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_products_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreProductsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is StoreProductsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'StoreProductsState()';
  }
}

/// @nodoc
class $StoreProductsStateCopyWith<$Res> {
  $StoreProductsStateCopyWith(
      StoreProductsState _, $Res Function(StoreProductsState) __);
}

/// Adds pattern-matching-related methods to [StoreProductsState].
extension StoreProductsStatePatterns on StoreProductsState {
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
    TResult Function(StoreProductsLoading value)? loading,
    TResult Function(StoreProductsLoaded value)? loaded,
    TResult Function(StoreProductsEmpty value)? empty,
    TResult Function(StoreProductsError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case StoreProductsLoading() when loading != null:
        return loading(_that);
      case StoreProductsLoaded() when loaded != null:
        return loaded(_that);
      case StoreProductsEmpty() when empty != null:
        return empty(_that);
      case StoreProductsError() when error != null:
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
    required TResult Function(StoreProductsLoading value) loading,
    required TResult Function(StoreProductsLoaded value) loaded,
    required TResult Function(StoreProductsEmpty value) empty,
    required TResult Function(StoreProductsError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProductsLoading():
        return loading(_that);
      case StoreProductsLoaded():
        return loaded(_that);
      case StoreProductsEmpty():
        return empty(_that);
      case StoreProductsError():
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
    TResult? Function(StoreProductsLoading value)? loading,
    TResult? Function(StoreProductsLoaded value)? loaded,
    TResult? Function(StoreProductsEmpty value)? empty,
    TResult? Function(StoreProductsError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProductsLoading() when loading != null:
        return loading(_that);
      case StoreProductsLoaded() when loaded != null:
        return loaded(_that);
      case StoreProductsEmpty() when empty != null:
        return empty(_that);
      case StoreProductsError() when error != null:
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
    TResult Function(List<ProductModel> products, int? total, int page,
            bool hasMore, bool isLoadingMore, DataError? loadMoreError)?
        loaded,
    TResult Function()? empty,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case StoreProductsLoading() when loading != null:
        return loading();
      case StoreProductsLoaded() when loaded != null:
        return loaded(_that.products, _that.total, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case StoreProductsEmpty() when empty != null:
        return empty();
      case StoreProductsError() when error != null:
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
    required TResult Function(List<ProductModel> products, int? total, int page,
            bool hasMore, bool isLoadingMore, DataError? loadMoreError)
        loaded,
    required TResult Function() empty,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProductsLoading():
        return loading();
      case StoreProductsLoaded():
        return loaded(_that.products, _that.total, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case StoreProductsEmpty():
        return empty();
      case StoreProductsError():
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
    TResult? Function(List<ProductModel> products, int? total, int page,
            bool hasMore, bool isLoadingMore, DataError? loadMoreError)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProductsLoading() when loading != null:
        return loading();
      case StoreProductsLoaded() when loaded != null:
        return loaded(_that.products, _that.total, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case StoreProductsEmpty() when empty != null:
        return empty();
      case StoreProductsError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class StoreProductsLoading implements StoreProductsState {
  const StoreProductsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is StoreProductsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'StoreProductsState.loading()';
  }
}

/// @nodoc

class StoreProductsLoaded implements StoreProductsState {
  const StoreProductsLoaded(
      {required final List<ProductModel> products,
      this.total,
      this.page = 1,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.loadMoreError})
      : _products = products;

  final List<ProductModel> _products;
  List<ProductModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  /// `meta.total` — `null` kalau server tidak mengirimnya.
  final int? total;
  @JsonKey()
  final int page;
  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;
  final DataError? loadMoreError;

  /// Create a copy of StoreProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoreProductsLoadedCopyWith<StoreProductsLoaded> get copyWith =>
      _$StoreProductsLoadedCopyWithImpl<StoreProductsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoreProductsLoaded &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.total, total) || other.total == total) &&
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
      const DeepCollectionEquality().hash(_products),
      total,
      page,
      hasMore,
      isLoadingMore,
      loadMoreError);

  @override
  String toString() {
    return 'StoreProductsState.loaded(products: $products, total: $total, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
  }
}

/// @nodoc
abstract mixin class $StoreProductsLoadedCopyWith<$Res>
    implements $StoreProductsStateCopyWith<$Res> {
  factory $StoreProductsLoadedCopyWith(
          StoreProductsLoaded value, $Res Function(StoreProductsLoaded) _then) =
      _$StoreProductsLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<ProductModel> products,
      int? total,
      int page,
      bool hasMore,
      bool isLoadingMore,
      DataError? loadMoreError});
}

/// @nodoc
class _$StoreProductsLoadedCopyWithImpl<$Res>
    implements $StoreProductsLoadedCopyWith<$Res> {
  _$StoreProductsLoadedCopyWithImpl(this._self, this._then);

  final StoreProductsLoaded _self;
  final $Res Function(StoreProductsLoaded) _then;

  /// Create a copy of StoreProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? products = null,
    Object? total = freezed,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(StoreProductsLoaded(
      products: null == products
          ? _self._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
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

class StoreProductsEmpty implements StoreProductsState {
  const StoreProductsEmpty();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is StoreProductsEmpty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'StoreProductsState.empty()';
  }
}

/// @nodoc

class StoreProductsError implements StoreProductsState {
  const StoreProductsError(this.error);

  final DataError error;

  /// Create a copy of StoreProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoreProductsErrorCopyWith<StoreProductsError> get copyWith =>
      _$StoreProductsErrorCopyWithImpl<StoreProductsError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoreProductsError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'StoreProductsState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $StoreProductsErrorCopyWith<$Res>
    implements $StoreProductsStateCopyWith<$Res> {
  factory $StoreProductsErrorCopyWith(
          StoreProductsError value, $Res Function(StoreProductsError) _then) =
      _$StoreProductsErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$StoreProductsErrorCopyWithImpl<$Res>
    implements $StoreProductsErrorCopyWith<$Res> {
  _$StoreProductsErrorCopyWithImpl(this._self, this._then);

  final StoreProductsError _self;
  final $Res Function(StoreProductsError) _then;

  /// Create a copy of StoreProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(StoreProductsError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
