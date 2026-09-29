// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreProfileState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is StoreProfileState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'StoreProfileState()';
  }
}

/// @nodoc
class $StoreProfileStateCopyWith<$Res> {
  $StoreProfileStateCopyWith(
      StoreProfileState _, $Res Function(StoreProfileState) __);
}

/// Adds pattern-matching-related methods to [StoreProfileState].
extension StoreProfileStatePatterns on StoreProfileState {
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
    TResult Function(StoreProfileLoading value)? loading,
    TResult Function(StoreProfileLoaded value)? loaded,
    TResult Function(StoreProfileError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case StoreProfileLoading() when loading != null:
        return loading(_that);
      case StoreProfileLoaded() when loaded != null:
        return loaded(_that);
      case StoreProfileError() when error != null:
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
    required TResult Function(StoreProfileLoading value) loading,
    required TResult Function(StoreProfileLoaded value) loaded,
    required TResult Function(StoreProfileError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProfileLoading():
        return loading(_that);
      case StoreProfileLoaded():
        return loaded(_that);
      case StoreProfileError():
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
    TResult? Function(StoreProfileLoading value)? loading,
    TResult? Function(StoreProfileLoaded value)? loaded,
    TResult? Function(StoreProfileError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProfileLoading() when loading != null:
        return loading(_that);
      case StoreProfileLoaded() when loaded != null:
        return loaded(_that);
      case StoreProfileError() when error != null:
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
            StoreModel store,
            StorePerformanceModel? performance,
            Map<String, dynamic> performanceMeta,
            bool isFollowBusy,
            DataError? actionError)?
        loaded,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case StoreProfileLoading() when loading != null:
        return loading();
      case StoreProfileLoaded() when loaded != null:
        return loaded(_that.store, _that.performance, _that.performanceMeta,
            _that.isFollowBusy, _that.actionError);
      case StoreProfileError() when error != null:
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
            StoreModel store,
            StorePerformanceModel? performance,
            Map<String, dynamic> performanceMeta,
            bool isFollowBusy,
            DataError? actionError)
        loaded,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProfileLoading():
        return loading();
      case StoreProfileLoaded():
        return loaded(_that.store, _that.performance, _that.performanceMeta,
            _that.isFollowBusy, _that.actionError);
      case StoreProfileError():
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
            StoreModel store,
            StorePerformanceModel? performance,
            Map<String, dynamic> performanceMeta,
            bool isFollowBusy,
            DataError? actionError)?
        loaded,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case StoreProfileLoading() when loading != null:
        return loading();
      case StoreProfileLoaded() when loaded != null:
        return loaded(_that.store, _that.performance, _that.performanceMeta,
            _that.isFollowBusy, _that.actionError);
      case StoreProfileError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class StoreProfileLoading extends StoreProfileState {
  const StoreProfileLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is StoreProfileLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'StoreProfileState.loading()';
  }
}

/// @nodoc

class StoreProfileLoaded extends StoreProfileState {
  const StoreProfileLoaded(
      {required this.store,
      this.performance,
      final Map<String, dynamic> performanceMeta = const <String, dynamic>{},
      this.isFollowBusy = false,
      this.actionError})
      : _performanceMeta = performanceMeta,
        super._();

  final StoreModel store;

  /// `null` kalau `partners-performance` gagal — baris metrik disembunyikan,
  /// bukan diisi nol.
  final StorePerformanceModel? performance;

  /// `meta` respons performance. `meta.mock_fields` memuat
  /// `service_performance.online_status` selama status online toko masih
  /// disimulasikan — dipakai `SimulatedBadge` di metrik "Online".
  final Map<String, dynamic> _performanceMeta;

  /// `meta` respons performance. `meta.mock_fields` memuat
  /// `service_performance.online_status` selama status online toko masih
  /// disimulasikan — dipakai `SimulatedBadge` di metrik "Online".
  @JsonKey()
  Map<String, dynamic> get performanceMeta {
    if (_performanceMeta is EqualUnmodifiableMapView) return _performanceMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_performanceMeta);
  }

  @JsonKey()
  final bool isFollowBusy;
  final DataError? actionError;

  /// Create a copy of StoreProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoreProfileLoadedCopyWith<StoreProfileLoaded> get copyWith =>
      _$StoreProfileLoadedCopyWithImpl<StoreProfileLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoreProfileLoaded &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.performance, performance) ||
                other.performance == performance) &&
            const DeepCollectionEquality()
                .equals(other._performanceMeta, _performanceMeta) &&
            (identical(other.isFollowBusy, isFollowBusy) ||
                other.isFollowBusy == isFollowBusy) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      store,
      performance,
      const DeepCollectionEquality().hash(_performanceMeta),
      isFollowBusy,
      actionError);

  @override
  String toString() {
    return 'StoreProfileState.loaded(store: $store, performance: $performance, performanceMeta: $performanceMeta, isFollowBusy: $isFollowBusy, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $StoreProfileLoadedCopyWith<$Res>
    implements $StoreProfileStateCopyWith<$Res> {
  factory $StoreProfileLoadedCopyWith(
          StoreProfileLoaded value, $Res Function(StoreProfileLoaded) _then) =
      _$StoreProfileLoadedCopyWithImpl;
  @useResult
  $Res call(
      {StoreModel store,
      StorePerformanceModel? performance,
      Map<String, dynamic> performanceMeta,
      bool isFollowBusy,
      DataError? actionError});

  $StoreModelCopyWith<$Res> get store;
}

/// @nodoc
class _$StoreProfileLoadedCopyWithImpl<$Res>
    implements $StoreProfileLoadedCopyWith<$Res> {
  _$StoreProfileLoadedCopyWithImpl(this._self, this._then);

  final StoreProfileLoaded _self;
  final $Res Function(StoreProfileLoaded) _then;

  /// Create a copy of StoreProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? store = null,
    Object? performance = freezed,
    Object? performanceMeta = null,
    Object? isFollowBusy = null,
    Object? actionError = freezed,
  }) {
    return _then(StoreProfileLoaded(
      store: null == store
          ? _self.store
          : store // ignore: cast_nullable_to_non_nullable
              as StoreModel,
      performance: freezed == performance
          ? _self.performance
          : performance // ignore: cast_nullable_to_non_nullable
              as StorePerformanceModel?,
      performanceMeta: null == performanceMeta
          ? _self._performanceMeta
          : performanceMeta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isFollowBusy: null == isFollowBusy
          ? _self.isFollowBusy
          : isFollowBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }

  /// Create a copy of StoreProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoreModelCopyWith<$Res> get store {
    return $StoreModelCopyWith<$Res>(_self.store, (value) {
      return _then(_self.copyWith(store: value));
    });
  }
}

/// @nodoc

class StoreProfileError extends StoreProfileState {
  const StoreProfileError(this.error) : super._();

  final DataError error;

  /// Create a copy of StoreProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoreProfileErrorCopyWith<StoreProfileError> get copyWith =>
      _$StoreProfileErrorCopyWithImpl<StoreProfileError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoreProfileError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'StoreProfileState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $StoreProfileErrorCopyWith<$Res>
    implements $StoreProfileStateCopyWith<$Res> {
  factory $StoreProfileErrorCopyWith(
          StoreProfileError value, $Res Function(StoreProfileError) _then) =
      _$StoreProfileErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$StoreProfileErrorCopyWithImpl<$Res>
    implements $StoreProfileErrorCopyWith<$Res> {
  _$StoreProfileErrorCopyWithImpl(this._self, this._then);

  final StoreProfileError _self;
  final $Res Function(StoreProfileError) _then;

  /// Create a copy of StoreProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(StoreProfileError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
