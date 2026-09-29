// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SupportListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SupportListState()';
  }
}

/// @nodoc
class $SupportListStateCopyWith<$Res> {
  $SupportListStateCopyWith(
      SupportListState _, $Res Function(SupportListState) __);
}

/// Adds pattern-matching-related methods to [SupportListState].
extension SupportListStatePatterns on SupportListState {
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
    TResult Function(SupportListLoading value)? loading,
    TResult Function(SupportListLoaded value)? loaded,
    TResult Function(SupportListError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SupportListLoading() when loading != null:
        return loading(_that);
      case SupportListLoaded() when loaded != null:
        return loaded(_that);
      case SupportListError() when error != null:
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
    required TResult Function(SupportListLoading value) loading,
    required TResult Function(SupportListLoaded value) loaded,
    required TResult Function(SupportListError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportListLoading():
        return loading(_that);
      case SupportListLoaded():
        return loaded(_that);
      case SupportListError():
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
    TResult? Function(SupportListLoading value)? loading,
    TResult? Function(SupportListLoaded value)? loaded,
    TResult? Function(SupportListError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportListLoading() when loading != null:
        return loading(_that);
      case SupportListLoaded() when loaded != null:
        return loaded(_that);
      case SupportListError() when error != null:
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
    TResult Function(List<SupportTicketModel> tickets, int page, bool hasMore,
            bool isLoadingMore, DataError? loadMoreError)?
        loaded,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SupportListLoading() when loading != null:
        return loading();
      case SupportListLoaded() when loaded != null:
        return loaded(_that.tickets, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case SupportListError() when error != null:
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
    required TResult Function(List<SupportTicketModel> tickets, int page,
            bool hasMore, bool isLoadingMore, DataError? loadMoreError)
        loaded,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportListLoading():
        return loading();
      case SupportListLoaded():
        return loaded(_that.tickets, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case SupportListError():
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
    TResult? Function(List<SupportTicketModel> tickets, int page, bool hasMore,
            bool isLoadingMore, DataError? loadMoreError)?
        loaded,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportListLoading() when loading != null:
        return loading();
      case SupportListLoaded() when loaded != null:
        return loaded(_that.tickets, _that.page, _that.hasMore,
            _that.isLoadingMore, _that.loadMoreError);
      case SupportListError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SupportListLoading implements SupportListState {
  const SupportListLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SupportListLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SupportListState.loading()';
  }
}

/// @nodoc

class SupportListLoaded implements SupportListState {
  const SupportListLoaded(
      {required final List<SupportTicketModel> tickets,
      this.page = 1,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.loadMoreError})
      : _tickets = tickets;

  final List<SupportTicketModel> _tickets;
  List<SupportTicketModel> get tickets {
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tickets);
  }

  @JsonKey()
  final int page;
  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;
  final DataError? loadMoreError;

  /// Create a copy of SupportListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportListLoadedCopyWith<SupportListLoaded> get copyWith =>
      _$SupportListLoadedCopyWithImpl<SupportListLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupportListLoaded &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
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
      const DeepCollectionEquality().hash(_tickets),
      page,
      hasMore,
      isLoadingMore,
      loadMoreError);

  @override
  String toString() {
    return 'SupportListState.loaded(tickets: $tickets, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
  }
}

/// @nodoc
abstract mixin class $SupportListLoadedCopyWith<$Res>
    implements $SupportListStateCopyWith<$Res> {
  factory $SupportListLoadedCopyWith(
          SupportListLoaded value, $Res Function(SupportListLoaded) _then) =
      _$SupportListLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<SupportTicketModel> tickets,
      int page,
      bool hasMore,
      bool isLoadingMore,
      DataError? loadMoreError});
}

/// @nodoc
class _$SupportListLoadedCopyWithImpl<$Res>
    implements $SupportListLoadedCopyWith<$Res> {
  _$SupportListLoadedCopyWithImpl(this._self, this._then);

  final SupportListLoaded _self;
  final $Res Function(SupportListLoaded) _then;

  /// Create a copy of SupportListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tickets = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
  }) {
    return _then(SupportListLoaded(
      tickets: null == tickets
          ? _self._tickets
          : tickets // ignore: cast_nullable_to_non_nullable
              as List<SupportTicketModel>,
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

class SupportListError implements SupportListState {
  const SupportListError(this.error);

  final DataError error;

  /// Create a copy of SupportListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportListErrorCopyWith<SupportListError> get copyWith =>
      _$SupportListErrorCopyWithImpl<SupportListError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupportListError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'SupportListState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $SupportListErrorCopyWith<$Res>
    implements $SupportListStateCopyWith<$Res> {
  factory $SupportListErrorCopyWith(
          SupportListError value, $Res Function(SupportListError) _then) =
      _$SupportListErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$SupportListErrorCopyWithImpl<$Res>
    implements $SupportListErrorCopyWith<$Res> {
  _$SupportListErrorCopyWithImpl(this._self, this._then);

  final SupportListError _self;
  final $Res Function(SupportListError) _then;

  /// Create a copy of SupportListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(SupportListError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
