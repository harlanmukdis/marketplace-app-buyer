// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckoutState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CheckoutState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CheckoutState()';
  }
}

/// @nodoc
class $CheckoutStateCopyWith<$Res> {
  $CheckoutStateCopyWith(CheckoutState _, $Res Function(CheckoutState) __);
}

/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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
    TResult Function(CheckoutPreparing value)? preparing,
    TResult Function(CheckoutReady value)? ready,
    TResult Function(CheckoutConfirmed value)? confirmed,
    TResult Function(CheckoutError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing(_that);
      case CheckoutReady() when ready != null:
        return ready(_that);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that);
      case CheckoutError() when error != null:
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
    required TResult Function(CheckoutPreparing value) preparing,
    required TResult Function(CheckoutReady value) ready,
    required TResult Function(CheckoutConfirmed value) confirmed,
    required TResult Function(CheckoutError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing():
        return preparing(_that);
      case CheckoutReady():
        return ready(_that);
      case CheckoutConfirmed():
        return confirmed(_that);
      case CheckoutError():
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
    TResult? Function(CheckoutPreparing value)? preparing,
    TResult? Function(CheckoutReady value)? ready,
    TResult? Function(CheckoutConfirmed value)? confirmed,
    TResult? Function(CheckoutError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing(_that);
      case CheckoutReady() when ready != null:
        return ready(_that);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that);
      case CheckoutError() when error != null:
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
    TResult Function()? preparing,
    TResult Function(CheckoutSnapshot snapshot, bool isSubmitting,
            DataError? actionError)?
        ready,
    TResult Function(CheckoutConfirmResult result)? confirmed,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing();
      case CheckoutReady() when ready != null:
        return ready(_that.snapshot, _that.isSubmitting, _that.actionError);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that.result);
      case CheckoutError() when error != null:
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
    required TResult Function() preparing,
    required TResult Function(CheckoutSnapshot snapshot, bool isSubmitting,
            DataError? actionError)
        ready,
    required TResult Function(CheckoutConfirmResult result) confirmed,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing():
        return preparing();
      case CheckoutReady():
        return ready(_that.snapshot, _that.isSubmitting, _that.actionError);
      case CheckoutConfirmed():
        return confirmed(_that.result);
      case CheckoutError():
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
    TResult? Function()? preparing,
    TResult? Function(CheckoutSnapshot snapshot, bool isSubmitting,
            DataError? actionError)?
        ready,
    TResult? Function(CheckoutConfirmResult result)? confirmed,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing();
      case CheckoutReady() when ready != null:
        return ready(_that.snapshot, _that.isSubmitting, _that.actionError);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that.result);
      case CheckoutError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class CheckoutPreparing extends CheckoutState {
  const CheckoutPreparing() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CheckoutPreparing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CheckoutState.preparing()';
  }
}

/// @nodoc

class CheckoutReady extends CheckoutState {
  const CheckoutReady(
      {required this.snapshot, this.isSubmitting = false, this.actionError})
      : super._();

  final CheckoutSnapshot snapshot;

  /// Sedang mengirim pilihan kurir atau konfirmasi.
  @JsonKey()
  final bool isSubmitting;
  final DataError? actionError;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutReadyCopyWith<CheckoutReady> get copyWith =>
      _$CheckoutReadyCopyWithImpl<CheckoutReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutReady &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, snapshot, isSubmitting, actionError);

  @override
  String toString() {
    return 'CheckoutState.ready(snapshot: $snapshot, isSubmitting: $isSubmitting, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $CheckoutReadyCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutReadyCopyWith(
          CheckoutReady value, $Res Function(CheckoutReady) _then) =
      _$CheckoutReadyCopyWithImpl;
  @useResult
  $Res call(
      {CheckoutSnapshot snapshot, bool isSubmitting, DataError? actionError});
}

/// @nodoc
class _$CheckoutReadyCopyWithImpl<$Res>
    implements $CheckoutReadyCopyWith<$Res> {
  _$CheckoutReadyCopyWithImpl(this._self, this._then);

  final CheckoutReady _self;
  final $Res Function(CheckoutReady) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? snapshot = null,
    Object? isSubmitting = null,
    Object? actionError = freezed,
  }) {
    return _then(CheckoutReady(
      snapshot: null == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as CheckoutSnapshot,
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

class CheckoutConfirmed extends CheckoutState {
  const CheckoutConfirmed(this.result) : super._();

  final CheckoutConfirmResult result;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutConfirmedCopyWith<CheckoutConfirmed> get copyWith =>
      _$CheckoutConfirmedCopyWithImpl<CheckoutConfirmed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutConfirmed &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  @override
  String toString() {
    return 'CheckoutState.confirmed(result: $result)';
  }
}

/// @nodoc
abstract mixin class $CheckoutConfirmedCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutConfirmedCopyWith(
          CheckoutConfirmed value, $Res Function(CheckoutConfirmed) _then) =
      _$CheckoutConfirmedCopyWithImpl;
  @useResult
  $Res call({CheckoutConfirmResult result});

  $CheckoutConfirmResultCopyWith<$Res> get result;
}

/// @nodoc
class _$CheckoutConfirmedCopyWithImpl<$Res>
    implements $CheckoutConfirmedCopyWith<$Res> {
  _$CheckoutConfirmedCopyWithImpl(this._self, this._then);

  final CheckoutConfirmed _self;
  final $Res Function(CheckoutConfirmed) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? result = null,
  }) {
    return _then(CheckoutConfirmed(
      null == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as CheckoutConfirmResult,
    ));
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutConfirmResultCopyWith<$Res> get result {
    return $CheckoutConfirmResultCopyWith<$Res>(_self.result, (value) {
      return _then(_self.copyWith(result: value));
    });
  }
}

/// @nodoc

class CheckoutError extends CheckoutState {
  const CheckoutError(this.error) : super._();

  final DataError error;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutErrorCopyWith<CheckoutError> get copyWith =>
      _$CheckoutErrorCopyWithImpl<CheckoutError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'CheckoutState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $CheckoutErrorCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutErrorCopyWith(
          CheckoutError value, $Res Function(CheckoutError) _then) =
      _$CheckoutErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$CheckoutErrorCopyWithImpl<$Res>
    implements $CheckoutErrorCopyWith<$Res> {
  _$CheckoutErrorCopyWithImpl(this._self, this._then);

  final CheckoutError _self;
  final $Res Function(CheckoutError) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(CheckoutError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
