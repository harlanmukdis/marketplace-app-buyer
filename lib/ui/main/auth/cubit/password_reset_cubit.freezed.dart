// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_reset_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PasswordResetState {
  bool get isSubmitting;
  DataError? get error;

  /// Terisi sesudah `forgot-password` diterima server. Server menjawab sama
  /// untuk email terdaftar maupun tidak, jadi ini **bukan** bukti email
  /// terkirim.
  String? get sentToEmail;

  /// Token reset yang dikirim backend development. `null` di production,
  /// dan juga `null` kalau emailnya tidak terdaftar.
  String? get devResetToken;

  /// Kata sandi baru tersimpan; seluruh sesi akun itu sudah dicabut server.
  bool get resetDone;

  /// Create a copy of PasswordResetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PasswordResetStateCopyWith<PasswordResetState> get copyWith =>
      _$PasswordResetStateCopyWithImpl<PasswordResetState>(
          this as PasswordResetState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PasswordResetState &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.sentToEmail, sentToEmail) ||
                other.sentToEmail == sentToEmail) &&
            (identical(other.devResetToken, devResetToken) ||
                other.devResetToken == devResetToken) &&
            (identical(other.resetDone, resetDone) ||
                other.resetDone == resetDone));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isSubmitting, error, sentToEmail, devResetToken, resetDone);

  @override
  String toString() {
    return 'PasswordResetState(isSubmitting: $isSubmitting, error: $error, sentToEmail: $sentToEmail, devResetToken: $devResetToken, resetDone: $resetDone)';
  }
}

/// @nodoc
abstract mixin class $PasswordResetStateCopyWith<$Res> {
  factory $PasswordResetStateCopyWith(
          PasswordResetState value, $Res Function(PasswordResetState) _then) =
      _$PasswordResetStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isSubmitting,
      DataError? error,
      String? sentToEmail,
      String? devResetToken,
      bool resetDone});
}

/// @nodoc
class _$PasswordResetStateCopyWithImpl<$Res>
    implements $PasswordResetStateCopyWith<$Res> {
  _$PasswordResetStateCopyWithImpl(this._self, this._then);

  final PasswordResetState _self;
  final $Res Function(PasswordResetState) _then;

  /// Create a copy of PasswordResetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? sentToEmail = freezed,
    Object? devResetToken = freezed,
    Object? resetDone = null,
  }) {
    return _then(_self.copyWith(
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
      sentToEmail: freezed == sentToEmail
          ? _self.sentToEmail
          : sentToEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      devResetToken: freezed == devResetToken
          ? _self.devResetToken
          : devResetToken // ignore: cast_nullable_to_non_nullable
              as String?,
      resetDone: null == resetDone
          ? _self.resetDone
          : resetDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [PasswordResetState].
extension PasswordResetStatePatterns on PasswordResetState {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PasswordResetState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PasswordResetState() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_PasswordResetState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PasswordResetState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PasswordResetState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PasswordResetState() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool isSubmitting, DataError? error, String? sentToEmail,
            String? devResetToken, bool resetDone)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PasswordResetState() when $default != null:
        return $default(_that.isSubmitting, _that.error, _that.sentToEmail,
            _that.devResetToken, _that.resetDone);
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
  TResult when<TResult extends Object?>(
    TResult Function(bool isSubmitting, DataError? error, String? sentToEmail,
            String? devResetToken, bool resetDone)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PasswordResetState():
        return $default(_that.isSubmitting, _that.error, _that.sentToEmail,
            _that.devResetToken, _that.resetDone);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool isSubmitting, DataError? error, String? sentToEmail,
            String? devResetToken, bool resetDone)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PasswordResetState() when $default != null:
        return $default(_that.isSubmitting, _that.error, _that.sentToEmail,
            _that.devResetToken, _that.resetDone);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PasswordResetState implements PasswordResetState {
  const _PasswordResetState(
      {this.isSubmitting = false,
      this.error,
      this.sentToEmail,
      this.devResetToken,
      this.resetDone = false});

  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final DataError? error;

  /// Terisi sesudah `forgot-password` diterima server. Server menjawab sama
  /// untuk email terdaftar maupun tidak, jadi ini **bukan** bukti email
  /// terkirim.
  @override
  final String? sentToEmail;

  /// Token reset yang dikirim backend development. `null` di production,
  /// dan juga `null` kalau emailnya tidak terdaftar.
  @override
  final String? devResetToken;

  /// Kata sandi baru tersimpan; seluruh sesi akun itu sudah dicabut server.
  @override
  @JsonKey()
  final bool resetDone;

  /// Create a copy of PasswordResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PasswordResetStateCopyWith<_PasswordResetState> get copyWith =>
      __$PasswordResetStateCopyWithImpl<_PasswordResetState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PasswordResetState &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.sentToEmail, sentToEmail) ||
                other.sentToEmail == sentToEmail) &&
            (identical(other.devResetToken, devResetToken) ||
                other.devResetToken == devResetToken) &&
            (identical(other.resetDone, resetDone) ||
                other.resetDone == resetDone));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isSubmitting, error, sentToEmail, devResetToken, resetDone);

  @override
  String toString() {
    return 'PasswordResetState(isSubmitting: $isSubmitting, error: $error, sentToEmail: $sentToEmail, devResetToken: $devResetToken, resetDone: $resetDone)';
  }
}

/// @nodoc
abstract mixin class _$PasswordResetStateCopyWith<$Res>
    implements $PasswordResetStateCopyWith<$Res> {
  factory _$PasswordResetStateCopyWith(
          _PasswordResetState value, $Res Function(_PasswordResetState) _then) =
      __$PasswordResetStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isSubmitting,
      DataError? error,
      String? sentToEmail,
      String? devResetToken,
      bool resetDone});
}

/// @nodoc
class __$PasswordResetStateCopyWithImpl<$Res>
    implements _$PasswordResetStateCopyWith<$Res> {
  __$PasswordResetStateCopyWithImpl(this._self, this._then);

  final _PasswordResetState _self;
  final $Res Function(_PasswordResetState) _then;

  /// Create a copy of PasswordResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? sentToEmail = freezed,
    Object? devResetToken = freezed,
    Object? resetDone = null,
  }) {
    return _then(_PasswordResetState(
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
      sentToEmail: freezed == sentToEmail
          ? _self.sentToEmail
          : sentToEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      devResetToken: freezed == devResetToken
          ? _self.devResetToken
          : devResetToken // ignore: cast_nullable_to_non_nullable
              as String?,
      resetDone: null == resetDone
          ? _self.resetDone
          : resetDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
