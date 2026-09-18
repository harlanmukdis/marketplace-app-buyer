// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewardState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RewardState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RewardState()';
  }
}

/// @nodoc
class $RewardStateCopyWith<$Res> {
  $RewardStateCopyWith(RewardState _, $Res Function(RewardState) __);
}

/// Adds pattern-matching-related methods to [RewardState].
extension RewardStatePatterns on RewardState {
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
    TResult Function(RewardLoading value)? loading,
    TResult Function(RewardReady value)? ready,
    TResult Function(RewardError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case RewardLoading() when loading != null:
        return loading(_that);
      case RewardReady() when ready != null:
        return ready(_that);
      case RewardError() when error != null:
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
    required TResult Function(RewardLoading value) loading,
    required TResult Function(RewardReady value) ready,
    required TResult Function(RewardError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case RewardLoading():
        return loading(_that);
      case RewardReady():
        return ready(_that);
      case RewardError():
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
    TResult? Function(RewardLoading value)? loading,
    TResult? Function(RewardReady value)? ready,
    TResult? Function(RewardError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case RewardLoading() when loading != null:
        return loading(_that);
      case RewardReady() when ready != null:
        return ready(_that);
      case RewardError() when error != null:
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
    TResult Function(RewardOverview overview)? ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case RewardLoading() when loading != null:
        return loading();
      case RewardReady() when ready != null:
        return ready(_that.overview);
      case RewardError() when error != null:
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
    required TResult Function(RewardOverview overview) ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case RewardLoading():
        return loading();
      case RewardReady():
        return ready(_that.overview);
      case RewardError():
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
    TResult? Function(RewardOverview overview)? ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case RewardLoading() when loading != null:
        return loading();
      case RewardReady() when ready != null:
        return ready(_that.overview);
      case RewardError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class RewardLoading extends RewardState {
  const RewardLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RewardLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'RewardState.loading()';
  }
}

/// @nodoc

class RewardReady extends RewardState {
  const RewardReady({required this.overview}) : super._();

  final RewardOverview overview;

  /// Create a copy of RewardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RewardReadyCopyWith<RewardReady> get copyWith =>
      _$RewardReadyCopyWithImpl<RewardReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RewardReady &&
            (identical(other.overview, overview) ||
                other.overview == overview));
  }

  @override
  int get hashCode => Object.hash(runtimeType, overview);

  @override
  String toString() {
    return 'RewardState.ready(overview: $overview)';
  }
}

/// @nodoc
abstract mixin class $RewardReadyCopyWith<$Res>
    implements $RewardStateCopyWith<$Res> {
  factory $RewardReadyCopyWith(
          RewardReady value, $Res Function(RewardReady) _then) =
      _$RewardReadyCopyWithImpl;
  @useResult
  $Res call({RewardOverview overview});
}

/// @nodoc
class _$RewardReadyCopyWithImpl<$Res> implements $RewardReadyCopyWith<$Res> {
  _$RewardReadyCopyWithImpl(this._self, this._then);

  final RewardReady _self;
  final $Res Function(RewardReady) _then;

  /// Create a copy of RewardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? overview = null,
  }) {
    return _then(RewardReady(
      overview: null == overview
          ? _self.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as RewardOverview,
    ));
  }
}

/// @nodoc

class RewardError extends RewardState {
  const RewardError(this.error) : super._();

  final DataError error;

  /// Create a copy of RewardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RewardErrorCopyWith<RewardError> get copyWith =>
      _$RewardErrorCopyWithImpl<RewardError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RewardError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'RewardState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $RewardErrorCopyWith<$Res>
    implements $RewardStateCopyWith<$Res> {
  factory $RewardErrorCopyWith(
          RewardError value, $Res Function(RewardError) _then) =
      _$RewardErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$RewardErrorCopyWithImpl<$Res> implements $RewardErrorCopyWith<$Res> {
  _$RewardErrorCopyWithImpl(this._self, this._then);

  final RewardError _self;
  final $Res Function(RewardError) _then;

  /// Create a copy of RewardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(RewardError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
