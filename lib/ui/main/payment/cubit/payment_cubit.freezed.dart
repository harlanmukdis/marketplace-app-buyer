// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PaymentState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaymentState()';
  }
}

/// @nodoc
class $PaymentStateCopyWith<$Res> {
  $PaymentStateCopyWith(PaymentState _, $Res Function(PaymentState) __);
}

/// Adds pattern-matching-related methods to [PaymentState].
extension PaymentStatePatterns on PaymentState {
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
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentReady value)? ready,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PaymentLoading() when loading != null:
        return loading(_that);
      case PaymentReady() when ready != null:
        return ready(_that);
      case PaymentError() when error != null:
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
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentReady value) ready,
    required TResult Function(PaymentError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case PaymentLoading():
        return loading(_that);
      case PaymentReady():
        return ready(_that);
      case PaymentError():
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
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentReady value)? ready,
    TResult? Function(PaymentError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case PaymentLoading() when loading != null:
        return loading(_that);
      case PaymentReady() when ready != null:
        return ready(_that);
      case PaymentError() when error != null:
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
            PaymentSnapshot snapshot, bool isChecking, DataError? actionError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PaymentLoading() when loading != null:
        return loading();
      case PaymentReady() when ready != null:
        return ready(_that.snapshot, _that.isChecking, _that.actionError);
      case PaymentError() when error != null:
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
            PaymentSnapshot snapshot, bool isChecking, DataError? actionError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case PaymentLoading():
        return loading();
      case PaymentReady():
        return ready(_that.snapshot, _that.isChecking, _that.actionError);
      case PaymentError():
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
            PaymentSnapshot snapshot, bool isChecking, DataError? actionError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case PaymentLoading() when loading != null:
        return loading();
      case PaymentReady() when ready != null:
        return ready(_that.snapshot, _that.isChecking, _that.actionError);
      case PaymentError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class PaymentLoading extends PaymentState {
  const PaymentLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PaymentLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PaymentState.loading()';
  }
}

/// @nodoc

class PaymentReady extends PaymentState {
  const PaymentReady(
      {required this.snapshot, this.isChecking = false, this.actionError})
      : super._();

  final PaymentSnapshot snapshot;

  /// Sedang memeriksa ulang status ke server.
  @JsonKey()
  final bool isChecking;
  final DataError? actionError;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaymentReadyCopyWith<PaymentReady> get copyWith =>
      _$PaymentReadyCopyWithImpl<PaymentReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaymentReady &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.isChecking, isChecking) ||
                other.isChecking == isChecking) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, snapshot, isChecking, actionError);

  @override
  String toString() {
    return 'PaymentState.ready(snapshot: $snapshot, isChecking: $isChecking, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $PaymentReadyCopyWith<$Res>
    implements $PaymentStateCopyWith<$Res> {
  factory $PaymentReadyCopyWith(
          PaymentReady value, $Res Function(PaymentReady) _then) =
      _$PaymentReadyCopyWithImpl;
  @useResult
  $Res call(
      {PaymentSnapshot snapshot, bool isChecking, DataError? actionError});
}

/// @nodoc
class _$PaymentReadyCopyWithImpl<$Res> implements $PaymentReadyCopyWith<$Res> {
  _$PaymentReadyCopyWithImpl(this._self, this._then);

  final PaymentReady _self;
  final $Res Function(PaymentReady) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? snapshot = null,
    Object? isChecking = null,
    Object? actionError = freezed,
  }) {
    return _then(PaymentReady(
      snapshot: null == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as PaymentSnapshot,
      isChecking: null == isChecking
          ? _self.isChecking
          : isChecking // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class PaymentError extends PaymentState {
  const PaymentError(this.error) : super._();

  final DataError error;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaymentErrorCopyWith<PaymentError> get copyWith =>
      _$PaymentErrorCopyWithImpl<PaymentError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaymentError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'PaymentState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $PaymentErrorCopyWith<$Res>
    implements $PaymentStateCopyWith<$Res> {
  factory $PaymentErrorCopyWith(
          PaymentError value, $Res Function(PaymentError) _then) =
      _$PaymentErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$PaymentErrorCopyWithImpl<$Res> implements $PaymentErrorCopyWith<$Res> {
  _$PaymentErrorCopyWithImpl(this._self, this._then);

  final PaymentError _self;
  final $Res Function(PaymentError) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(PaymentError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
