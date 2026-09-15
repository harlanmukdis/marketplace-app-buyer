// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NotificationState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotificationState()';
  }
}

/// @nodoc
class $NotificationStateCopyWith<$Res> {
  $NotificationStateCopyWith(
      NotificationState _, $Res Function(NotificationState) __);
}

/// Adds pattern-matching-related methods to [NotificationState].
extension NotificationStatePatterns on NotificationState {
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
    TResult Function(NotificationLoading value)? loading,
    TResult Function(NotificationEmpty value)? empty,
    TResult Function(NotificationLoaded value)? loaded,
    TResult Function(NotificationError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case NotificationLoading() when loading != null:
        return loading(_that);
      case NotificationEmpty() when empty != null:
        return empty(_that);
      case NotificationLoaded() when loaded != null:
        return loaded(_that);
      case NotificationError() when error != null:
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
    required TResult Function(NotificationLoading value) loading,
    required TResult Function(NotificationEmpty value) empty,
    required TResult Function(NotificationLoaded value) loaded,
    required TResult Function(NotificationError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case NotificationLoading():
        return loading(_that);
      case NotificationEmpty():
        return empty(_that);
      case NotificationLoaded():
        return loaded(_that);
      case NotificationError():
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
    TResult? Function(NotificationLoading value)? loading,
    TResult? Function(NotificationEmpty value)? empty,
    TResult? Function(NotificationLoaded value)? loaded,
    TResult? Function(NotificationError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case NotificationLoading() when loading != null:
        return loading(_that);
      case NotificationEmpty() when empty != null:
        return empty(_that);
      case NotificationLoaded() when loaded != null:
        return loaded(_that);
      case NotificationError() when error != null:
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
    TResult Function()? empty,
    TResult Function(
            List<NotificationModel> notifications,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError,
            bool isSubmitting,
            DataError? actionError)?
        loaded,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case NotificationLoading() when loading != null:
        return loading();
      case NotificationEmpty() when empty != null:
        return empty();
      case NotificationLoaded() when loaded != null:
        return loaded(
            _that.notifications,
            _that.page,
            _that.hasMore,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.isSubmitting,
            _that.actionError);
      case NotificationError() when error != null:
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
    required TResult Function() empty,
    required TResult Function(
            List<NotificationModel> notifications,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError,
            bool isSubmitting,
            DataError? actionError)
        loaded,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case NotificationLoading():
        return loading();
      case NotificationEmpty():
        return empty();
      case NotificationLoaded():
        return loaded(
            _that.notifications,
            _that.page,
            _that.hasMore,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.isSubmitting,
            _that.actionError);
      case NotificationError():
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
    TResult? Function()? empty,
    TResult? Function(
            List<NotificationModel> notifications,
            int page,
            bool hasMore,
            bool isLoadingMore,
            DataError? loadMoreError,
            bool isSubmitting,
            DataError? actionError)?
        loaded,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case NotificationLoading() when loading != null:
        return loading();
      case NotificationEmpty() when empty != null:
        return empty();
      case NotificationLoaded() when loaded != null:
        return loaded(
            _that.notifications,
            _that.page,
            _that.hasMore,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.isSubmitting,
            _that.actionError);
      case NotificationError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class NotificationLoading extends NotificationState {
  const NotificationLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NotificationLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotificationState.loading()';
  }
}

/// @nodoc

class NotificationEmpty extends NotificationState {
  const NotificationEmpty() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NotificationEmpty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotificationState.empty()';
  }
}

/// @nodoc

class NotificationLoaded extends NotificationState {
  const NotificationLoaded(
      {required final List<NotificationModel> notifications,
      this.page = 1,
      this.hasMore = false,
      this.isLoadingMore = false,
      this.loadMoreError,
      this.isSubmitting = false,
      this.actionError})
      : _notifications = notifications,
        super._();

  final List<NotificationModel> _notifications;
  List<NotificationModel> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @JsonKey()
  final int page;
  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;
  final DataError? loadMoreError;

  /// Sedang menandai semuanya terbaca.
  @JsonKey()
  final bool isSubmitting;
  final DataError? actionError;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationLoadedCopyWith<NotificationLoaded> get copyWith =>
      _$NotificationLoadedCopyWithImpl<NotificationLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationLoaded &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.loadMoreError, loadMoreError) ||
                other.loadMoreError == loadMoreError) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_notifications),
      page,
      hasMore,
      isLoadingMore,
      loadMoreError,
      isSubmitting,
      actionError);

  @override
  String toString() {
    return 'NotificationState.loaded(notifications: $notifications, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError, isSubmitting: $isSubmitting, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $NotificationLoadedCopyWith<$Res>
    implements $NotificationStateCopyWith<$Res> {
  factory $NotificationLoadedCopyWith(
          NotificationLoaded value, $Res Function(NotificationLoaded) _then) =
      _$NotificationLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<NotificationModel> notifications,
      int page,
      bool hasMore,
      bool isLoadingMore,
      DataError? loadMoreError,
      bool isSubmitting,
      DataError? actionError});
}

/// @nodoc
class _$NotificationLoadedCopyWithImpl<$Res>
    implements $NotificationLoadedCopyWith<$Res> {
  _$NotificationLoadedCopyWithImpl(this._self, this._then);

  final NotificationLoaded _self;
  final $Res Function(NotificationLoaded) _then;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? notifications = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
    Object? isSubmitting = null,
    Object? actionError = freezed,
  }) {
    return _then(NotificationLoaded(
      notifications: null == notifications
          ? _self._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
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
}

/// @nodoc

class NotificationError extends NotificationState {
  const NotificationError(this.error) : super._();

  final DataError error;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationErrorCopyWith<NotificationError> get copyWith =>
      _$NotificationErrorCopyWithImpl<NotificationError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'NotificationState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $NotificationErrorCopyWith<$Res>
    implements $NotificationStateCopyWith<$Res> {
  factory $NotificationErrorCopyWith(
          NotificationError value, $Res Function(NotificationError) _then) =
      _$NotificationErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$NotificationErrorCopyWithImpl<$Res>
    implements $NotificationErrorCopyWith<$Res> {
  _$NotificationErrorCopyWithImpl(this._self, this._then);

  final NotificationError _self;
  final $Res Function(NotificationError) _then;

  /// Create a copy of NotificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(NotificationError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
