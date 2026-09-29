// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'identity_verification_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IdentityVerificationState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IdentityVerificationState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'IdentityVerificationState()';
  }
}

/// @nodoc
class $IdentityVerificationStateCopyWith<$Res> {
  $IdentityVerificationStateCopyWith(
      IdentityVerificationState _, $Res Function(IdentityVerificationState) __);
}

/// Adds pattern-matching-related methods to [IdentityVerificationState].
extension IdentityVerificationStatePatterns on IdentityVerificationState {
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
    TResult Function(IdentityVerificationLoading value)? loading,
    TResult Function(IdentityVerificationUnavailable value)? unavailable,
    TResult Function(IdentityVerificationReady value)? ready,
    TResult Function(IdentityVerificationError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case IdentityVerificationLoading() when loading != null:
        return loading(_that);
      case IdentityVerificationUnavailable() when unavailable != null:
        return unavailable(_that);
      case IdentityVerificationReady() when ready != null:
        return ready(_that);
      case IdentityVerificationError() when error != null:
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
    required TResult Function(IdentityVerificationLoading value) loading,
    required TResult Function(IdentityVerificationUnavailable value)
        unavailable,
    required TResult Function(IdentityVerificationReady value) ready,
    required TResult Function(IdentityVerificationError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case IdentityVerificationLoading():
        return loading(_that);
      case IdentityVerificationUnavailable():
        return unavailable(_that);
      case IdentityVerificationReady():
        return ready(_that);
      case IdentityVerificationError():
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
    TResult? Function(IdentityVerificationLoading value)? loading,
    TResult? Function(IdentityVerificationUnavailable value)? unavailable,
    TResult? Function(IdentityVerificationReady value)? ready,
    TResult? Function(IdentityVerificationError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case IdentityVerificationLoading() when loading != null:
        return loading(_that);
      case IdentityVerificationUnavailable() when unavailable != null:
        return unavailable(_that);
      case IdentityVerificationReady() when ready != null:
        return ready(_that);
      case IdentityVerificationError() when error != null:
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
    TResult Function()? unavailable,
    TResult Function(
            IdentityVerificationModel verification,
            Map<String, dynamic> meta,
            bool isSubmitting,
            DataError? submitError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case IdentityVerificationLoading() when loading != null:
        return loading();
      case IdentityVerificationUnavailable() when unavailable != null:
        return unavailable();
      case IdentityVerificationReady() when ready != null:
        return ready(_that.verification, _that.meta, _that.isSubmitting,
            _that.submitError);
      case IdentityVerificationError() when error != null:
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
    required TResult Function() unavailable,
    required TResult Function(
            IdentityVerificationModel verification,
            Map<String, dynamic> meta,
            bool isSubmitting,
            DataError? submitError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case IdentityVerificationLoading():
        return loading();
      case IdentityVerificationUnavailable():
        return unavailable();
      case IdentityVerificationReady():
        return ready(_that.verification, _that.meta, _that.isSubmitting,
            _that.submitError);
      case IdentityVerificationError():
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
    TResult? Function()? unavailable,
    TResult? Function(
            IdentityVerificationModel verification,
            Map<String, dynamic> meta,
            bool isSubmitting,
            DataError? submitError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case IdentityVerificationLoading() when loading != null:
        return loading();
      case IdentityVerificationUnavailable() when unavailable != null:
        return unavailable();
      case IdentityVerificationReady() when ready != null:
        return ready(_that.verification, _that.meta, _that.isSubmitting,
            _that.submitError);
      case IdentityVerificationError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class IdentityVerificationLoading implements IdentityVerificationState {
  const IdentityVerificationLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IdentityVerificationLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'IdentityVerificationState.loading()';
  }
}

/// @nodoc

class IdentityVerificationUnavailable implements IdentityVerificationState {
  const IdentityVerificationUnavailable();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IdentityVerificationUnavailable);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'IdentityVerificationState.unavailable()';
  }
}

/// @nodoc

class IdentityVerificationReady implements IdentityVerificationState {
  const IdentityVerificationReady(
      {required this.verification,
      final Map<String, dynamic> meta = const <String, dynamic>{},
      this.isSubmitting = false,
      this.submitError})
      : _meta = meta;

  final IdentityVerificationModel verification;

  /// Untuk lencana "Simulasi".
  final Map<String, dynamic> _meta;

  /// Untuk lencana "Simulasi".
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  @JsonKey()
  final bool isSubmitting;
  final DataError? submitError;

  /// Create a copy of IdentityVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IdentityVerificationReadyCopyWith<IdentityVerificationReady> get copyWith =>
      _$IdentityVerificationReadyCopyWithImpl<IdentityVerificationReady>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IdentityVerificationReady &&
            (identical(other.verification, verification) ||
                other.verification == verification) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, verification,
      const DeepCollectionEquality().hash(_meta), isSubmitting, submitError);

  @override
  String toString() {
    return 'IdentityVerificationState.ready(verification: $verification, meta: $meta, isSubmitting: $isSubmitting, submitError: $submitError)';
  }
}

/// @nodoc
abstract mixin class $IdentityVerificationReadyCopyWith<$Res>
    implements $IdentityVerificationStateCopyWith<$Res> {
  factory $IdentityVerificationReadyCopyWith(IdentityVerificationReady value,
          $Res Function(IdentityVerificationReady) _then) =
      _$IdentityVerificationReadyCopyWithImpl;
  @useResult
  $Res call(
      {IdentityVerificationModel verification,
      Map<String, dynamic> meta,
      bool isSubmitting,
      DataError? submitError});

  $IdentityVerificationModelCopyWith<$Res> get verification;
}

/// @nodoc
class _$IdentityVerificationReadyCopyWithImpl<$Res>
    implements $IdentityVerificationReadyCopyWith<$Res> {
  _$IdentityVerificationReadyCopyWithImpl(this._self, this._then);

  final IdentityVerificationReady _self;
  final $Res Function(IdentityVerificationReady) _then;

  /// Create a copy of IdentityVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? verification = null,
    Object? meta = null,
    Object? isSubmitting = null,
    Object? submitError = freezed,
  }) {
    return _then(IdentityVerificationReady(
      verification: null == verification
          ? _self.verification
          : verification // ignore: cast_nullable_to_non_nullable
              as IdentityVerificationModel,
      meta: null == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      submitError: freezed == submitError
          ? _self.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }

  /// Create a copy of IdentityVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IdentityVerificationModelCopyWith<$Res> get verification {
    return $IdentityVerificationModelCopyWith<$Res>(_self.verification,
        (value) {
      return _then(_self.copyWith(verification: value));
    });
  }
}

/// @nodoc

class IdentityVerificationError implements IdentityVerificationState {
  const IdentityVerificationError(this.error);

  final DataError error;

  /// Create a copy of IdentityVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IdentityVerificationErrorCopyWith<IdentityVerificationError> get copyWith =>
      _$IdentityVerificationErrorCopyWithImpl<IdentityVerificationError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IdentityVerificationError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'IdentityVerificationState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $IdentityVerificationErrorCopyWith<$Res>
    implements $IdentityVerificationStateCopyWith<$Res> {
  factory $IdentityVerificationErrorCopyWith(IdentityVerificationError value,
          $Res Function(IdentityVerificationError) _then) =
      _$IdentityVerificationErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$IdentityVerificationErrorCopyWithImpl<$Res>
    implements $IdentityVerificationErrorCopyWith<$Res> {
  _$IdentityVerificationErrorCopyWithImpl(this._self, this._then);

  final IdentityVerificationError _self;
  final $Res Function(IdentityVerificationError) _then;

  /// Create a copy of IdentityVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(IdentityVerificationError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
