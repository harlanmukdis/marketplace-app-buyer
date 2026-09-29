// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_reviews_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyReviewsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MyReviewsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MyReviewsState()';
  }
}

/// @nodoc
class $MyReviewsStateCopyWith<$Res> {
  $MyReviewsStateCopyWith(MyReviewsState _, $Res Function(MyReviewsState) __);
}

/// Adds pattern-matching-related methods to [MyReviewsState].
extension MyReviewsStatePatterns on MyReviewsState {
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
    TResult Function(MyReviewsLoading value)? loading,
    TResult Function(MyReviewsLoaded value)? loaded,
    TResult Function(MyReviewsEmpty value)? empty,
    TResult Function(MyReviewsUnsupported value)? unsupported,
    TResult Function(MyReviewsError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MyReviewsLoading() when loading != null:
        return loading(_that);
      case MyReviewsLoaded() when loaded != null:
        return loaded(_that);
      case MyReviewsEmpty() when empty != null:
        return empty(_that);
      case MyReviewsUnsupported() when unsupported != null:
        return unsupported(_that);
      case MyReviewsError() when error != null:
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
    required TResult Function(MyReviewsLoading value) loading,
    required TResult Function(MyReviewsLoaded value) loaded,
    required TResult Function(MyReviewsEmpty value) empty,
    required TResult Function(MyReviewsUnsupported value) unsupported,
    required TResult Function(MyReviewsError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case MyReviewsLoading():
        return loading(_that);
      case MyReviewsLoaded():
        return loaded(_that);
      case MyReviewsEmpty():
        return empty(_that);
      case MyReviewsUnsupported():
        return unsupported(_that);
      case MyReviewsError():
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
    TResult? Function(MyReviewsLoading value)? loading,
    TResult? Function(MyReviewsLoaded value)? loaded,
    TResult? Function(MyReviewsEmpty value)? empty,
    TResult? Function(MyReviewsUnsupported value)? unsupported,
    TResult? Function(MyReviewsError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case MyReviewsLoading() when loading != null:
        return loading(_that);
      case MyReviewsLoaded() when loaded != null:
        return loaded(_that);
      case MyReviewsEmpty() when empty != null:
        return empty(_that);
      case MyReviewsUnsupported() when unsupported != null:
        return unsupported(_that);
      case MyReviewsError() when error != null:
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
            List<MyReviewModel> reviews,
            Map<String, dynamic> meta,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError)?
        loaded,
    TResult Function(Map<String, dynamic> meta)? empty,
    TResult Function()? unsupported,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case MyReviewsLoading() when loading != null:
        return loading();
      case MyReviewsLoaded() when loaded != null:
        return loaded(_that.reviews, _that.meta, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case MyReviewsEmpty() when empty != null:
        return empty(_that.meta);
      case MyReviewsUnsupported() when unsupported != null:
        return unsupported();
      case MyReviewsError() when error != null:
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
            List<MyReviewModel> reviews,
            Map<String, dynamic> meta,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError)
        loaded,
    required TResult Function(Map<String, dynamic> meta) empty,
    required TResult Function() unsupported,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case MyReviewsLoading():
        return loading();
      case MyReviewsLoaded():
        return loaded(_that.reviews, _that.meta, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case MyReviewsEmpty():
        return empty(_that.meta);
      case MyReviewsUnsupported():
        return unsupported();
      case MyReviewsError():
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
            List<MyReviewModel> reviews,
            Map<String, dynamic> meta,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError)?
        loaded,
    TResult? Function(Map<String, dynamic> meta)? empty,
    TResult? Function()? unsupported,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case MyReviewsLoading() when loading != null:
        return loading();
      case MyReviewsLoaded() when loaded != null:
        return loaded(_that.reviews, _that.meta, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case MyReviewsEmpty() when empty != null:
        return empty(_that.meta);
      case MyReviewsUnsupported() when unsupported != null:
        return unsupported();
      case MyReviewsError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class MyReviewsLoading implements MyReviewsState {
  const MyReviewsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MyReviewsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MyReviewsState.loading()';
  }
}

/// @nodoc

class MyReviewsLoaded implements MyReviewsState {
  const MyReviewsLoaded(
      {required final List<MyReviewModel> reviews,
      final Map<String, dynamic> meta = const <String, dynamic>{},
      this.page = 1,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.loadMoreError})
      : _reviews = reviews,
        _meta = meta;

  final List<MyReviewModel> _reviews;
  List<MyReviewModel> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  /// `meta` halaman pertama — membawa `mock: true` selama `GET /me/reviews`
  /// masih disimulasikan.
  final Map<String, dynamic> _meta;

  /// `meta` halaman pertama — membawa `mock: true` selama `GET /me/reviews`
  /// masih disimulasikan.
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  @JsonKey()
  final int page;
  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;
  final DataError? loadMoreError;

  /// Create a copy of MyReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyReviewsLoadedCopyWith<MyReviewsLoaded> get copyWith =>
      _$MyReviewsLoadedCopyWithImpl<MyReviewsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyReviewsLoaded &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
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
      const DeepCollectionEquality().hash(_reviews),
      const DeepCollectionEquality().hash(_meta),
      page,
      hasMore,
      isLoadingMore,
      loadMoreError);

  @override
  String toString() {
    return 'MyReviewsState.loaded(reviews: $reviews, meta: $meta, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
  }
}

/// @nodoc
abstract mixin class $MyReviewsLoadedCopyWith<$Res>
    implements $MyReviewsStateCopyWith<$Res> {
  factory $MyReviewsLoadedCopyWith(
          MyReviewsLoaded value, $Res Function(MyReviewsLoaded) _then) =
      _$MyReviewsLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<MyReviewModel> reviews,
      Map<String, dynamic> meta,
      int page,
      bool hasMore,
      bool isLoadingMore,
      DataError? loadMoreError});
}

/// @nodoc
class _$MyReviewsLoadedCopyWithImpl<$Res>
    implements $MyReviewsLoadedCopyWith<$Res> {
  _$MyReviewsLoadedCopyWithImpl(this._self, this._then);

  final MyReviewsLoaded _self;
  final $Res Function(MyReviewsLoaded) _then;

  /// Create a copy of MyReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reviews = null,
    Object? meta = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(MyReviewsLoaded(
      reviews: null == reviews
          ? _self._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<MyReviewModel>,
      meta: null == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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

class MyReviewsEmpty implements MyReviewsState {
  const MyReviewsEmpty(
      {final Map<String, dynamic> meta = const <String, dynamic>{}})
      : _meta = meta;

  final Map<String, dynamic> _meta;
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  /// Create a copy of MyReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyReviewsEmptyCopyWith<MyReviewsEmpty> get copyWith =>
      _$MyReviewsEmptyCopyWithImpl<MyReviewsEmpty>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyReviewsEmpty &&
            const DeepCollectionEquality().equals(other._meta, _meta));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_meta));

  @override
  String toString() {
    return 'MyReviewsState.empty(meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $MyReviewsEmptyCopyWith<$Res>
    implements $MyReviewsStateCopyWith<$Res> {
  factory $MyReviewsEmptyCopyWith(
          MyReviewsEmpty value, $Res Function(MyReviewsEmpty) _then) =
      _$MyReviewsEmptyCopyWithImpl;
  @useResult
  $Res call({Map<String, dynamic> meta});
}

/// @nodoc
class _$MyReviewsEmptyCopyWithImpl<$Res>
    implements $MyReviewsEmptyCopyWith<$Res> {
  _$MyReviewsEmptyCopyWithImpl(this._self, this._then);

  final MyReviewsEmpty _self;
  final $Res Function(MyReviewsEmpty) _then;

  /// Create a copy of MyReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? meta = null,
  }) {
    return _then(MyReviewsEmpty(
      meta: null == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class MyReviewsUnsupported implements MyReviewsState {
  const MyReviewsUnsupported();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MyReviewsUnsupported);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MyReviewsState.unsupported()';
  }
}

/// @nodoc

class MyReviewsError implements MyReviewsState {
  const MyReviewsError(this.error);

  final DataError error;

  /// Create a copy of MyReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyReviewsErrorCopyWith<MyReviewsError> get copyWith =>
      _$MyReviewsErrorCopyWithImpl<MyReviewsError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyReviewsError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'MyReviewsState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $MyReviewsErrorCopyWith<$Res>
    implements $MyReviewsStateCopyWith<$Res> {
  factory $MyReviewsErrorCopyWith(
          MyReviewsError value, $Res Function(MyReviewsError) _then) =
      _$MyReviewsErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$MyReviewsErrorCopyWithImpl<$Res>
    implements $MyReviewsErrorCopyWith<$Res> {
  _$MyReviewsErrorCopyWithImpl(this._self, this._then);

  final MyReviewsError _self;
  final $Res Function(MyReviewsError) _then;

  /// Create a copy of MyReviewsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(MyReviewsError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
