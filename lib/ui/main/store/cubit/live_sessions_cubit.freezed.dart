// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_sessions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveSessionsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LiveSessionsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LiveSessionsState()';
  }
}

/// @nodoc
class $LiveSessionsStateCopyWith<$Res> {
  $LiveSessionsStateCopyWith(
      LiveSessionsState _, $Res Function(LiveSessionsState) __);
}

/// Adds pattern-matching-related methods to [LiveSessionsState].
extension LiveSessionsStatePatterns on LiveSessionsState {
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
    TResult Function(LiveSessionsLoading value)? loading,
    TResult Function(LiveSessionsLoaded value)? loaded,
    TResult Function(LiveSessionsEmpty value)? empty,
    TResult Function(LiveSessionsUnavailable value)? unavailable,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LiveSessionsLoading() when loading != null:
        return loading(_that);
      case LiveSessionsLoaded() when loaded != null:
        return loaded(_that);
      case LiveSessionsEmpty() when empty != null:
        return empty(_that);
      case LiveSessionsUnavailable() when unavailable != null:
        return unavailable(_that);
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
    required TResult Function(LiveSessionsLoading value) loading,
    required TResult Function(LiveSessionsLoaded value) loaded,
    required TResult Function(LiveSessionsEmpty value) empty,
    required TResult Function(LiveSessionsUnavailable value) unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case LiveSessionsLoading():
        return loading(_that);
      case LiveSessionsLoaded():
        return loaded(_that);
      case LiveSessionsEmpty():
        return empty(_that);
      case LiveSessionsUnavailable():
        return unavailable(_that);
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
    TResult? Function(LiveSessionsLoading value)? loading,
    TResult? Function(LiveSessionsLoaded value)? loaded,
    TResult? Function(LiveSessionsEmpty value)? empty,
    TResult? Function(LiveSessionsUnavailable value)? unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case LiveSessionsLoading() when loading != null:
        return loading(_that);
      case LiveSessionsLoaded() when loaded != null:
        return loaded(_that);
      case LiveSessionsEmpty() when empty != null:
        return empty(_that);
      case LiveSessionsUnavailable() when unavailable != null:
        return unavailable(_that);
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
            List<LiveSessionModel> sessions, Map<String, dynamic> meta)?
        loaded,
    TResult Function(Map<String, dynamic> meta)? empty,
    TResult Function(DataError error)? unavailable,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LiveSessionsLoading() when loading != null:
        return loading();
      case LiveSessionsLoaded() when loaded != null:
        return loaded(_that.sessions, _that.meta);
      case LiveSessionsEmpty() when empty != null:
        return empty(_that.meta);
      case LiveSessionsUnavailable() when unavailable != null:
        return unavailable(_that.error);
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
            List<LiveSessionModel> sessions, Map<String, dynamic> meta)
        loaded,
    required TResult Function(Map<String, dynamic> meta) empty,
    required TResult Function(DataError error) unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case LiveSessionsLoading():
        return loading();
      case LiveSessionsLoaded():
        return loaded(_that.sessions, _that.meta);
      case LiveSessionsEmpty():
        return empty(_that.meta);
      case LiveSessionsUnavailable():
        return unavailable(_that.error);
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
            List<LiveSessionModel> sessions, Map<String, dynamic> meta)?
        loaded,
    TResult? Function(Map<String, dynamic> meta)? empty,
    TResult? Function(DataError error)? unavailable,
  }) {
    final _that = this;
    switch (_that) {
      case LiveSessionsLoading() when loading != null:
        return loading();
      case LiveSessionsLoaded() when loaded != null:
        return loaded(_that.sessions, _that.meta);
      case LiveSessionsEmpty() when empty != null:
        return empty(_that.meta);
      case LiveSessionsUnavailable() when unavailable != null:
        return unavailable(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class LiveSessionsLoading extends LiveSessionsState {
  const LiveSessionsLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LiveSessionsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LiveSessionsState.loading()';
  }
}

/// @nodoc

class LiveSessionsLoaded extends LiveSessionsState {
  const LiveSessionsLoaded(
      {required final List<LiveSessionModel> sessions,
      final Map<String, dynamic> meta = const <String, dynamic>{}})
      : _sessions = sessions,
        _meta = meta,
        super._();

  final List<LiveSessionModel> _sessions;
  List<LiveSessionModel> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  /// `meta` amplop — `meta.mock` menandai data simulasi (`SimulatedBadge`).
  final Map<String, dynamic> _meta;

  /// `meta` amplop — `meta.mock` menandai data simulasi (`SimulatedBadge`).
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  /// Create a copy of LiveSessionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LiveSessionsLoadedCopyWith<LiveSessionsLoaded> get copyWith =>
      _$LiveSessionsLoadedCopyWithImpl<LiveSessionsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LiveSessionsLoaded &&
            const DeepCollectionEquality().equals(other._sessions, _sessions) &&
            const DeepCollectionEquality().equals(other._meta, _meta));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sessions),
      const DeepCollectionEquality().hash(_meta));

  @override
  String toString() {
    return 'LiveSessionsState.loaded(sessions: $sessions, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $LiveSessionsLoadedCopyWith<$Res>
    implements $LiveSessionsStateCopyWith<$Res> {
  factory $LiveSessionsLoadedCopyWith(
          LiveSessionsLoaded value, $Res Function(LiveSessionsLoaded) _then) =
      _$LiveSessionsLoadedCopyWithImpl;
  @useResult
  $Res call({List<LiveSessionModel> sessions, Map<String, dynamic> meta});
}

/// @nodoc
class _$LiveSessionsLoadedCopyWithImpl<$Res>
    implements $LiveSessionsLoadedCopyWith<$Res> {
  _$LiveSessionsLoadedCopyWithImpl(this._self, this._then);

  final LiveSessionsLoaded _self;
  final $Res Function(LiveSessionsLoaded) _then;

  /// Create a copy of LiveSessionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sessions = null,
    Object? meta = null,
  }) {
    return _then(LiveSessionsLoaded(
      sessions: null == sessions
          ? _self._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<LiveSessionModel>,
      meta: null == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class LiveSessionsEmpty extends LiveSessionsState {
  const LiveSessionsEmpty(
      {final Map<String, dynamic> meta = const <String, dynamic>{}})
      : _meta = meta,
        super._();

  final Map<String, dynamic> _meta;
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  /// Create a copy of LiveSessionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LiveSessionsEmptyCopyWith<LiveSessionsEmpty> get copyWith =>
      _$LiveSessionsEmptyCopyWithImpl<LiveSessionsEmpty>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LiveSessionsEmpty &&
            const DeepCollectionEquality().equals(other._meta, _meta));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_meta));

  @override
  String toString() {
    return 'LiveSessionsState.empty(meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $LiveSessionsEmptyCopyWith<$Res>
    implements $LiveSessionsStateCopyWith<$Res> {
  factory $LiveSessionsEmptyCopyWith(
          LiveSessionsEmpty value, $Res Function(LiveSessionsEmpty) _then) =
      _$LiveSessionsEmptyCopyWithImpl;
  @useResult
  $Res call({Map<String, dynamic> meta});
}

/// @nodoc
class _$LiveSessionsEmptyCopyWithImpl<$Res>
    implements $LiveSessionsEmptyCopyWith<$Res> {
  _$LiveSessionsEmptyCopyWithImpl(this._self, this._then);

  final LiveSessionsEmpty _self;
  final $Res Function(LiveSessionsEmpty) _then;

  /// Create a copy of LiveSessionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? meta = null,
  }) {
    return _then(LiveSessionsEmpty(
      meta: null == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class LiveSessionsUnavailable extends LiveSessionsState {
  const LiveSessionsUnavailable(this.error) : super._();

  final DataError error;

  /// Create a copy of LiveSessionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LiveSessionsUnavailableCopyWith<LiveSessionsUnavailable> get copyWith =>
      _$LiveSessionsUnavailableCopyWithImpl<LiveSessionsUnavailable>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LiveSessionsUnavailable &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'LiveSessionsState.unavailable(error: $error)';
  }
}

/// @nodoc
abstract mixin class $LiveSessionsUnavailableCopyWith<$Res>
    implements $LiveSessionsStateCopyWith<$Res> {
  factory $LiveSessionsUnavailableCopyWith(LiveSessionsUnavailable value,
          $Res Function(LiveSessionsUnavailable) _then) =
      _$LiveSessionsUnavailableCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$LiveSessionsUnavailableCopyWithImpl<$Res>
    implements $LiveSessionsUnavailableCopyWith<$Res> {
  _$LiveSessionsUnavailableCopyWithImpl(this._self, this._then);

  final LiveSessionsUnavailable _self;
  final $Res Function(LiveSessionsUnavailable) _then;

  /// Create a copy of LiveSessionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(LiveSessionsUnavailable(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
