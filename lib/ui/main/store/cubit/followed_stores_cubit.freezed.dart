// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'followed_stores_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowedStoresState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FollowedStoresState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FollowedStoresState()';
  }
}

/// @nodoc
class $FollowedStoresStateCopyWith<$Res> {
  $FollowedStoresStateCopyWith(
      FollowedStoresState _, $Res Function(FollowedStoresState) __);
}

/// Adds pattern-matching-related methods to [FollowedStoresState].
extension FollowedStoresStatePatterns on FollowedStoresState {
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
    TResult Function(FollowedStoresLoading value)? loading,
    TResult Function(FollowedStoresLoaded value)? loaded,
    TResult Function(FollowedStoresError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FollowedStoresLoading() when loading != null:
        return loading(_that);
      case FollowedStoresLoaded() when loaded != null:
        return loaded(_that);
      case FollowedStoresError() when error != null:
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
    required TResult Function(FollowedStoresLoading value) loading,
    required TResult Function(FollowedStoresLoaded value) loaded,
    required TResult Function(FollowedStoresError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case FollowedStoresLoading():
        return loading(_that);
      case FollowedStoresLoaded():
        return loaded(_that);
      case FollowedStoresError():
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
    TResult? Function(FollowedStoresLoading value)? loading,
    TResult? Function(FollowedStoresLoaded value)? loaded,
    TResult? Function(FollowedStoresError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case FollowedStoresLoading() when loading != null:
        return loading(_that);
      case FollowedStoresLoaded() when loaded != null:
        return loaded(_that);
      case FollowedStoresError() when error != null:
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
            List<FollowedStoreModel> stores,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError,
            Set<int> mutatingIds,
            DataError? actionError)?
        loaded,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FollowedStoresLoading() when loading != null:
        return loading();
      case FollowedStoresLoaded() when loaded != null:
        return loaded(
            _that.stores,
            _that.page,
            _that.hasMore,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.mutatingIds,
            _that.actionError);
      case FollowedStoresError() when error != null:
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
            List<FollowedStoreModel> stores,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError,
            Set<int> mutatingIds,
            DataError? actionError)
        loaded,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case FollowedStoresLoading():
        return loading();
      case FollowedStoresLoaded():
        return loaded(
            _that.stores,
            _that.page,
            _that.hasMore,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.mutatingIds,
            _that.actionError);
      case FollowedStoresError():
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
            List<FollowedStoreModel> stores,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError,
            Set<int> mutatingIds,
            DataError? actionError)?
        loaded,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case FollowedStoresLoading() when loading != null:
        return loading();
      case FollowedStoresLoaded() when loaded != null:
        return loaded(
            _that.stores,
            _that.page,
            _that.hasMore,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.mutatingIds,
            _that.actionError);
      case FollowedStoresError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class FollowedStoresLoading implements FollowedStoresState {
  const FollowedStoresLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FollowedStoresLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FollowedStoresState.loading()';
  }
}

/// @nodoc

class FollowedStoresLoaded implements FollowedStoresState {
  const FollowedStoresLoaded(
      {required final List<FollowedStoreModel> stores,
      this.page = 1,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.loadMoreError,
      final Set<int> mutatingIds = const <int>{},
      this.actionError})
      : _stores = stores,
        _mutatingIds = mutatingIds;

  final List<FollowedStoreModel> _stores;
  List<FollowedStoreModel> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  @JsonKey()
  final int page;
  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;
  final DataError? loadMoreError;

  /// Id toko yang sedang dilepas, supaya hanya barisnya yang terkunci.
  final Set<int> _mutatingIds;

  /// Id toko yang sedang dilepas, supaya hanya barisnya yang terkunci.
  @JsonKey()
  Set<int> get mutatingIds {
    if (_mutatingIds is EqualUnmodifiableSetView) return _mutatingIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_mutatingIds);
  }

  final DataError? actionError;

  /// Create a copy of FollowedStoresState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FollowedStoresLoadedCopyWith<FollowedStoresLoaded> get copyWith =>
      _$FollowedStoresLoadedCopyWithImpl<FollowedStoresLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FollowedStoresLoaded &&
            const DeepCollectionEquality().equals(other._stores, _stores) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.loadMoreError, loadMoreError) ||
                other.loadMoreError == loadMoreError) &&
            const DeepCollectionEquality()
                .equals(other._mutatingIds, _mutatingIds) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stores),
      page,
      hasMore,
      isLoadingMore,
      loadMoreError,
      const DeepCollectionEquality().hash(_mutatingIds),
      actionError);

  @override
  String toString() {
    return 'FollowedStoresState.loaded(stores: $stores, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError, mutatingIds: $mutatingIds, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $FollowedStoresLoadedCopyWith<$Res>
    implements $FollowedStoresStateCopyWith<$Res> {
  factory $FollowedStoresLoadedCopyWith(FollowedStoresLoaded value,
          $Res Function(FollowedStoresLoaded) _then) =
      _$FollowedStoresLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<FollowedStoreModel> stores,
      int page,
      bool hasMore,
      bool isLoadingMore,
      DataError? loadMoreError,
      Set<int> mutatingIds,
      DataError? actionError});
}

/// @nodoc
class _$FollowedStoresLoadedCopyWithImpl<$Res>
    implements $FollowedStoresLoadedCopyWith<$Res> {
  _$FollowedStoresLoadedCopyWithImpl(this._self, this._then);

  final FollowedStoresLoaded _self;
  final $Res Function(FollowedStoresLoaded) _then;

  /// Create a copy of FollowedStoresState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stores = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
    Object? mutatingIds = null,
    Object? actionError = freezed,
  }) {
    return _then(FollowedStoresLoaded(
      stores: null == stores
          ? _self._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<FollowedStoreModel>,
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
      mutatingIds: null == mutatingIds
          ? _self._mutatingIds
          : mutatingIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class FollowedStoresError implements FollowedStoresState {
  const FollowedStoresError(this.error);

  final DataError error;

  /// Create a copy of FollowedStoresState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FollowedStoresErrorCopyWith<FollowedStoresError> get copyWith =>
      _$FollowedStoresErrorCopyWithImpl<FollowedStoresError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FollowedStoresError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'FollowedStoresState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $FollowedStoresErrorCopyWith<$Res>
    implements $FollowedStoresStateCopyWith<$Res> {
  factory $FollowedStoresErrorCopyWith(
          FollowedStoresError value, $Res Function(FollowedStoresError) _then) =
      _$FollowedStoresErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$FollowedStoresErrorCopyWithImpl<$Res>
    implements $FollowedStoresErrorCopyWith<$Res> {
  _$FollowedStoresErrorCopyWithImpl(this._self, this._then);

  final FollowedStoresError _self;
  final $Res Function(FollowedStoresError) _then;

  /// Create a copy of FollowedStoresState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(FollowedStoresError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
