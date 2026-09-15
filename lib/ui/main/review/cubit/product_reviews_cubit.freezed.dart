// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_reviews_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductReviewsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProductReviewsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProductReviewsState()';
  }
}

/// @nodoc
class $ProductReviewsStateCopyWith<$Res> {
  $ProductReviewsStateCopyWith(
      ProductReviewsState _, $Res Function(ProductReviewsState) __);
}

/// Adds pattern-matching-related methods to [ProductReviewsState].
extension ProductReviewsStatePatterns on ProductReviewsState {
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
    TResult Function(ProductReviewsLoading value)? loading,
    TResult Function(ProductReviewsLoaded value)? loaded,
    TResult Function(ProductReviewsEmpty value)? empty,
    TResult Function(ProductReviewsError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ProductReviewsLoading() when loading != null:
        return loading(_that);
      case ProductReviewsLoaded() when loaded != null:
        return loaded(_that);
      case ProductReviewsEmpty() when empty != null:
        return empty(_that);
      case ProductReviewsError() when error != null:
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
    required TResult Function(ProductReviewsLoading value) loading,
    required TResult Function(ProductReviewsLoaded value) loaded,
    required TResult Function(ProductReviewsEmpty value) empty,
    required TResult Function(ProductReviewsError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case ProductReviewsLoading():
        return loading(_that);
      case ProductReviewsLoaded():
        return loaded(_that);
      case ProductReviewsEmpty():
        return empty(_that);
      case ProductReviewsError():
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
    TResult? Function(ProductReviewsLoading value)? loading,
    TResult? Function(ProductReviewsLoaded value)? loaded,
    TResult? Function(ProductReviewsEmpty value)? empty,
    TResult? Function(ProductReviewsError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ProductReviewsLoading() when loading != null:
        return loading(_that);
      case ProductReviewsLoaded() when loaded != null:
        return loaded(_that);
      case ProductReviewsEmpty() when empty != null:
        return empty(_that);
      case ProductReviewsError() when error != null:
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
    TResult Function(ReviewPage page, int pageNumber, bool hasMore,
            bool isLoadingMore, int? ratingFilter, DataError? loadMoreError)?
        loaded,
    TResult Function(RatingHistogram histogram, int? ratingFilter)? empty,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ProductReviewsLoading() when loading != null:
        return loading();
      case ProductReviewsLoaded() when loaded != null:
        return loaded(_that.page, _that.pageNumber, _that.hasMore,
            _that.isLoadingMore, _that.ratingFilter, _that.loadMoreError);
      case ProductReviewsEmpty() when empty != null:
        return empty(_that.histogram, _that.ratingFilter);
      case ProductReviewsError() when error != null:
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
    required TResult Function(ReviewPage page, int pageNumber, bool hasMore,
            bool isLoadingMore, int? ratingFilter, DataError? loadMoreError)
        loaded,
    required TResult Function(RatingHistogram histogram, int? ratingFilter)
        empty,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case ProductReviewsLoading():
        return loading();
      case ProductReviewsLoaded():
        return loaded(_that.page, _that.pageNumber, _that.hasMore,
            _that.isLoadingMore, _that.ratingFilter, _that.loadMoreError);
      case ProductReviewsEmpty():
        return empty(_that.histogram, _that.ratingFilter);
      case ProductReviewsError():
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
    TResult? Function(ReviewPage page, int pageNumber, bool hasMore,
            bool isLoadingMore, int? ratingFilter, DataError? loadMoreError)?
        loaded,
    TResult? Function(RatingHistogram histogram, int? ratingFilter)? empty,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ProductReviewsLoading() when loading != null:
        return loading();
      case ProductReviewsLoaded() when loaded != null:
        return loaded(_that.page, _that.pageNumber, _that.hasMore,
            _that.isLoadingMore, _that.ratingFilter, _that.loadMoreError);
      case ProductReviewsEmpty() when empty != null:
        return empty(_that.histogram, _that.ratingFilter);
      case ProductReviewsError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ProductReviewsLoading extends ProductReviewsState {
  const ProductReviewsLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProductReviewsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProductReviewsState.loading()';
  }
}

/// @nodoc

class ProductReviewsLoaded extends ProductReviewsState {
  const ProductReviewsLoaded(
      {required this.page,
      this.pageNumber = 1,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.ratingFilter,
      this.loadMoreError})
      : super._();

  final ReviewPage page;
  @JsonKey()
  final int pageNumber;
  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;

  /// Filter bintang aktif (1–5); `null` berarti semua.
  final int? ratingFilter;
  final DataError? loadMoreError;

  /// Create a copy of ProductReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductReviewsLoadedCopyWith<ProductReviewsLoaded> get copyWith =>
      _$ProductReviewsLoadedCopyWithImpl<ProductReviewsLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductReviewsLoaded &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.ratingFilter, ratingFilter) ||
                other.ratingFilter == ratingFilter) &&
            (identical(other.loadMoreError, loadMoreError) ||
                other.loadMoreError == loadMoreError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, pageNumber, hasMore,
      isLoadingMore, ratingFilter, loadMoreError);

  @override
  String toString() {
    return 'ProductReviewsState.loaded(page: $page, pageNumber: $pageNumber, hasMore: $hasMore, isLoadingMore: $isLoadingMore, ratingFilter: $ratingFilter, loadMoreError: $loadMoreError)';
  }
}

/// @nodoc
abstract mixin class $ProductReviewsLoadedCopyWith<$Res>
    implements $ProductReviewsStateCopyWith<$Res> {
  factory $ProductReviewsLoadedCopyWith(ProductReviewsLoaded value,
          $Res Function(ProductReviewsLoaded) _then) =
      _$ProductReviewsLoadedCopyWithImpl;
  @useResult
  $Res call(
      {ReviewPage page,
      int pageNumber,
      bool hasMore,
      bool isLoadingMore,
      int? ratingFilter,
      DataError? loadMoreError});
}

/// @nodoc
class _$ProductReviewsLoadedCopyWithImpl<$Res>
    implements $ProductReviewsLoadedCopyWith<$Res> {
  _$ProductReviewsLoadedCopyWithImpl(this._self, this._then);

  final ProductReviewsLoaded _self;
  final $Res Function(ProductReviewsLoaded) _then;

  /// Create a copy of ProductReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? page = null,
    Object? pageNumber = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? ratingFilter = freezed,
    Object? loadMoreError = freezed,
  }) {
    return _then(ProductReviewsLoaded(
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as ReviewPage,
      pageNumber: null == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      ratingFilter: freezed == ratingFilter
          ? _self.ratingFilter
          : ratingFilter // ignore: cast_nullable_to_non_nullable
              as int?,
      loadMoreError: freezed == loadMoreError
          ? _self.loadMoreError
          : loadMoreError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class ProductReviewsEmpty extends ProductReviewsState {
  const ProductReviewsEmpty(
      {this.histogram = RatingHistogram.empty, this.ratingFilter})
      : super._();

  @JsonKey()
  final RatingHistogram histogram;
  final int? ratingFilter;

  /// Create a copy of ProductReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductReviewsEmptyCopyWith<ProductReviewsEmpty> get copyWith =>
      _$ProductReviewsEmptyCopyWithImpl<ProductReviewsEmpty>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductReviewsEmpty &&
            (identical(other.histogram, histogram) ||
                other.histogram == histogram) &&
            (identical(other.ratingFilter, ratingFilter) ||
                other.ratingFilter == ratingFilter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, histogram, ratingFilter);

  @override
  String toString() {
    return 'ProductReviewsState.empty(histogram: $histogram, ratingFilter: $ratingFilter)';
  }
}

/// @nodoc
abstract mixin class $ProductReviewsEmptyCopyWith<$Res>
    implements $ProductReviewsStateCopyWith<$Res> {
  factory $ProductReviewsEmptyCopyWith(
          ProductReviewsEmpty value, $Res Function(ProductReviewsEmpty) _then) =
      _$ProductReviewsEmptyCopyWithImpl;
  @useResult
  $Res call({RatingHistogram histogram, int? ratingFilter});
}

/// @nodoc
class _$ProductReviewsEmptyCopyWithImpl<$Res>
    implements $ProductReviewsEmptyCopyWith<$Res> {
  _$ProductReviewsEmptyCopyWithImpl(this._self, this._then);

  final ProductReviewsEmpty _self;
  final $Res Function(ProductReviewsEmpty) _then;

  /// Create a copy of ProductReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? histogram = null,
    Object? ratingFilter = freezed,
  }) {
    return _then(ProductReviewsEmpty(
      histogram: null == histogram
          ? _self.histogram
          : histogram // ignore: cast_nullable_to_non_nullable
              as RatingHistogram,
      ratingFilter: freezed == ratingFilter
          ? _self.ratingFilter
          : ratingFilter // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class ProductReviewsError extends ProductReviewsState {
  const ProductReviewsError(this.error) : super._();

  final DataError error;

  /// Create a copy of ProductReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductReviewsErrorCopyWith<ProductReviewsError> get copyWith =>
      _$ProductReviewsErrorCopyWithImpl<ProductReviewsError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductReviewsError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'ProductReviewsState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $ProductReviewsErrorCopyWith<$Res>
    implements $ProductReviewsStateCopyWith<$Res> {
  factory $ProductReviewsErrorCopyWith(
          ProductReviewsError value, $Res Function(ProductReviewsError) _then) =
      _$ProductReviewsErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$ProductReviewsErrorCopyWithImpl<$Res>
    implements $ProductReviewsErrorCopyWith<$Res> {
  _$ProductReviewsErrorCopyWithImpl(this._self, this._then);

  final ProductReviewsError _self;
  final $Res Function(ProductReviewsError) _then;

  /// Create a copy of ProductReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(ProductReviewsError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
