// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_change_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactChangeState {
  ContactType get type;
  String? get newValue;

  /// `null` = belum meminta kode; terisi = menunggu kode dimasukkan.
  ContactChangeRequest? get request;
  bool get isBusy;
  DataError? get error;

  /// Kontak baru sudah tersimpan di server.
  bool get completed;

  /// Create a copy of ContactChangeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContactChangeStateCopyWith<ContactChangeState> get copyWith =>
      _$ContactChangeStateCopyWithImpl<ContactChangeState>(
          this as ContactChangeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContactChangeState &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, type, newValue, request, isBusy, error, completed);

  @override
  String toString() {
    return 'ContactChangeState(type: $type, newValue: $newValue, request: $request, isBusy: $isBusy, error: $error, completed: $completed)';
  }
}

/// @nodoc
abstract mixin class $ContactChangeStateCopyWith<$Res> {
  factory $ContactChangeStateCopyWith(
          ContactChangeState value, $Res Function(ContactChangeState) _then) =
      _$ContactChangeStateCopyWithImpl;
  @useResult
  $Res call(
      {ContactType type,
      String? newValue,
      ContactChangeRequest? request,
      bool isBusy,
      DataError? error,
      bool completed});
}

/// @nodoc
class _$ContactChangeStateCopyWithImpl<$Res>
    implements $ContactChangeStateCopyWith<$Res> {
  _$ContactChangeStateCopyWithImpl(this._self, this._then);

  final ContactChangeState _self;
  final $Res Function(ContactChangeState) _then;

  /// Create a copy of ContactChangeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? newValue = freezed,
    Object? request = freezed,
    Object? isBusy = null,
    Object? error = freezed,
    Object? completed = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContactType,
      newValue: freezed == newValue
          ? _self.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as String?,
      request: freezed == request
          ? _self.request
          : request // ignore: cast_nullable_to_non_nullable
              as ContactChangeRequest?,
      isBusy: null == isBusy
          ? _self.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ContactChangeState].
extension ContactChangeStatePatterns on ContactChangeState {
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
    TResult Function(_ContactChangeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ContactChangeState() when $default != null:
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
    TResult Function(_ContactChangeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactChangeState():
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
    TResult? Function(_ContactChangeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactChangeState() when $default != null:
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
    TResult Function(
            ContactType type,
            String? newValue,
            ContactChangeRequest? request,
            bool isBusy,
            DataError? error,
            bool completed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ContactChangeState() when $default != null:
        return $default(_that.type, _that.newValue, _that.request, _that.isBusy,
            _that.error, _that.completed);
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
    TResult Function(
            ContactType type,
            String? newValue,
            ContactChangeRequest? request,
            bool isBusy,
            DataError? error,
            bool completed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactChangeState():
        return $default(_that.type, _that.newValue, _that.request, _that.isBusy,
            _that.error, _that.completed);
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
    TResult? Function(
            ContactType type,
            String? newValue,
            ContactChangeRequest? request,
            bool isBusy,
            DataError? error,
            bool completed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ContactChangeState() when $default != null:
        return $default(_that.type, _that.newValue, _that.request, _that.isBusy,
            _that.error, _that.completed);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ContactChangeState extends ContactChangeState {
  const _ContactChangeState(
      {required this.type,
      this.newValue,
      this.request,
      this.isBusy = false,
      this.error,
      this.completed = false})
      : super._();

  @override
  final ContactType type;
  @override
  final String? newValue;

  /// `null` = belum meminta kode; terisi = menunggu kode dimasukkan.
  @override
  final ContactChangeRequest? request;
  @override
  @JsonKey()
  final bool isBusy;
  @override
  final DataError? error;

  /// Kontak baru sudah tersimpan di server.
  @override
  @JsonKey()
  final bool completed;

  /// Create a copy of ContactChangeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ContactChangeStateCopyWith<_ContactChangeState> get copyWith =>
      __$ContactChangeStateCopyWithImpl<_ContactChangeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ContactChangeState &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, type, newValue, request, isBusy, error, completed);

  @override
  String toString() {
    return 'ContactChangeState(type: $type, newValue: $newValue, request: $request, isBusy: $isBusy, error: $error, completed: $completed)';
  }
}

/// @nodoc
abstract mixin class _$ContactChangeStateCopyWith<$Res>
    implements $ContactChangeStateCopyWith<$Res> {
  factory _$ContactChangeStateCopyWith(
          _ContactChangeState value, $Res Function(_ContactChangeState) _then) =
      __$ContactChangeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ContactType type,
      String? newValue,
      ContactChangeRequest? request,
      bool isBusy,
      DataError? error,
      bool completed});
}

/// @nodoc
class __$ContactChangeStateCopyWithImpl<$Res>
    implements _$ContactChangeStateCopyWith<$Res> {
  __$ContactChangeStateCopyWithImpl(this._self, this._then);

  final _ContactChangeState _self;
  final $Res Function(_ContactChangeState) _then;

  /// Create a copy of ContactChangeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? newValue = freezed,
    Object? request = freezed,
    Object? isBusy = null,
    Object? error = freezed,
    Object? completed = null,
  }) {
    return _then(_ContactChangeState(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContactType,
      newValue: freezed == newValue
          ? _self.newValue
          : newValue // ignore: cast_nullable_to_non_nullable
              as String?,
      request: freezed == request
          ? _self.request
          : request // ignore: cast_nullable_to_non_nullable
              as ContactChangeRequest?,
      isBusy: null == isBusy
          ? _self.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
