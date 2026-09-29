// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_devices_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginDevicesState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoginDevicesState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LoginDevicesState()';
  }
}

/// @nodoc
class $LoginDevicesStateCopyWith<$Res> {
  $LoginDevicesStateCopyWith(
      LoginDevicesState _, $Res Function(LoginDevicesState) __);
}

/// Adds pattern-matching-related methods to [LoginDevicesState].
extension LoginDevicesStatePatterns on LoginDevicesState {
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
    TResult Function(LoginDevicesLoading value)? loading,
    TResult Function(LoginDevicesReady value)? ready,
    TResult Function(LoginDevicesError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoginDevicesLoading() when loading != null:
        return loading(_that);
      case LoginDevicesReady() when ready != null:
        return ready(_that);
      case LoginDevicesError() when error != null:
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
    required TResult Function(LoginDevicesLoading value) loading,
    required TResult Function(LoginDevicesReady value) ready,
    required TResult Function(LoginDevicesError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case LoginDevicesLoading():
        return loading(_that);
      case LoginDevicesReady():
        return ready(_that);
      case LoginDevicesError():
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
    TResult? Function(LoginDevicesLoading value)? loading,
    TResult? Function(LoginDevicesReady value)? ready,
    TResult? Function(LoginDevicesError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case LoginDevicesLoading() when loading != null:
        return loading(_that);
      case LoginDevicesReady() when ready != null:
        return ready(_that);
      case LoginDevicesError() when error != null:
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
    TResult Function(List<LoginDevice> devices, String? revokingKey,
            DataError? actionError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoginDevicesLoading() when loading != null:
        return loading();
      case LoginDevicesReady() when ready != null:
        return ready(_that.devices, _that.revokingKey, _that.actionError);
      case LoginDevicesError() when error != null:
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
    required TResult Function(List<LoginDevice> devices, String? revokingKey,
            DataError? actionError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case LoginDevicesLoading():
        return loading();
      case LoginDevicesReady():
        return ready(_that.devices, _that.revokingKey, _that.actionError);
      case LoginDevicesError():
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
    TResult? Function(List<LoginDevice> devices, String? revokingKey,
            DataError? actionError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case LoginDevicesLoading() when loading != null:
        return loading();
      case LoginDevicesReady() when ready != null:
        return ready(_that.devices, _that.revokingKey, _that.actionError);
      case LoginDevicesError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class LoginDevicesLoading implements LoginDevicesState {
  const LoginDevicesLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoginDevicesLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LoginDevicesState.loading()';
  }
}

/// @nodoc

class LoginDevicesReady implements LoginDevicesState {
  const LoginDevicesReady(
      {required final List<LoginDevice> devices,
      this.revokingKey,
      this.actionError})
      : _devices = devices;

  final List<LoginDevice> _devices;
  List<LoginDevice> get devices {
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  /// [LoginDevice.key] yang sedang dicabut. Satu per satu: `php -S`
  /// single-threaded dan setiap perangkat bisa berisi banyak sesi.
  final String? revokingKey;
  final DataError? actionError;

  /// Create a copy of LoginDevicesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginDevicesReadyCopyWith<LoginDevicesReady> get copyWith =>
      _$LoginDevicesReadyCopyWithImpl<LoginDevicesReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginDevicesReady &&
            const DeepCollectionEquality().equals(other._devices, _devices) &&
            (identical(other.revokingKey, revokingKey) ||
                other.revokingKey == revokingKey) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_devices), revokingKey, actionError);

  @override
  String toString() {
    return 'LoginDevicesState.ready(devices: $devices, revokingKey: $revokingKey, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $LoginDevicesReadyCopyWith<$Res>
    implements $LoginDevicesStateCopyWith<$Res> {
  factory $LoginDevicesReadyCopyWith(
          LoginDevicesReady value, $Res Function(LoginDevicesReady) _then) =
      _$LoginDevicesReadyCopyWithImpl;
  @useResult
  $Res call(
      {List<LoginDevice> devices, String? revokingKey, DataError? actionError});
}

/// @nodoc
class _$LoginDevicesReadyCopyWithImpl<$Res>
    implements $LoginDevicesReadyCopyWith<$Res> {
  _$LoginDevicesReadyCopyWithImpl(this._self, this._then);

  final LoginDevicesReady _self;
  final $Res Function(LoginDevicesReady) _then;

  /// Create a copy of LoginDevicesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? devices = null,
    Object? revokingKey = freezed,
    Object? actionError = freezed,
  }) {
    return _then(LoginDevicesReady(
      devices: null == devices
          ? _self._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<LoginDevice>,
      revokingKey: freezed == revokingKey
          ? _self.revokingKey
          : revokingKey // ignore: cast_nullable_to_non_nullable
              as String?,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class LoginDevicesError implements LoginDevicesState {
  const LoginDevicesError(this.error);

  final DataError error;

  /// Create a copy of LoginDevicesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginDevicesErrorCopyWith<LoginDevicesError> get copyWith =>
      _$LoginDevicesErrorCopyWithImpl<LoginDevicesError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginDevicesError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'LoginDevicesState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $LoginDevicesErrorCopyWith<$Res>
    implements $LoginDevicesStateCopyWith<$Res> {
  factory $LoginDevicesErrorCopyWith(
          LoginDevicesError value, $Res Function(LoginDevicesError) _then) =
      _$LoginDevicesErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$LoginDevicesErrorCopyWithImpl<$Res>
    implements $LoginDevicesErrorCopyWith<$Res> {
  _$LoginDevicesErrorCopyWithImpl(this._self, this._then);

  final LoginDevicesError _self;
  final $Res Function(LoginDevicesError) _then;

  /// Create a copy of LoginDevicesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(LoginDevicesError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
