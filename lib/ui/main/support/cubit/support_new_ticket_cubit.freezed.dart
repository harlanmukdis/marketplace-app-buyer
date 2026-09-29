// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_new_ticket_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportNewTicketState {
  SupportCategory? get category;
  bool get isSubmitting;
  DataError? get error;

  /// Tiket yang baru dibuat (hasil baca ulang). Layar mengganti rutenya ke
  /// halaman tiket ini.
  SupportTicketModel? get created;

  /// Create a copy of SupportNewTicketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportNewTicketStateCopyWith<SupportNewTicketState> get copyWith =>
      _$SupportNewTicketStateCopyWithImpl<SupportNewTicketState>(
          this as SupportNewTicketState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupportNewTicketState &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.created, created) || other.created == created));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, category, isSubmitting, error, created);

  @override
  String toString() {
    return 'SupportNewTicketState(category: $category, isSubmitting: $isSubmitting, error: $error, created: $created)';
  }
}

/// @nodoc
abstract mixin class $SupportNewTicketStateCopyWith<$Res> {
  factory $SupportNewTicketStateCopyWith(SupportNewTicketState value,
          $Res Function(SupportNewTicketState) _then) =
      _$SupportNewTicketStateCopyWithImpl;
  @useResult
  $Res call(
      {SupportCategory? category,
      bool isSubmitting,
      DataError? error,
      SupportTicketModel? created});

  $SupportTicketModelCopyWith<$Res>? get created;
}

/// @nodoc
class _$SupportNewTicketStateCopyWithImpl<$Res>
    implements $SupportNewTicketStateCopyWith<$Res> {
  _$SupportNewTicketStateCopyWithImpl(this._self, this._then);

  final SupportNewTicketState _self;
  final $Res Function(SupportNewTicketState) _then;

  /// Create a copy of SupportNewTicketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? created = freezed,
  }) {
    return _then(_self.copyWith(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as SupportCategory?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
      created: freezed == created
          ? _self.created
          : created // ignore: cast_nullable_to_non_nullable
              as SupportTicketModel?,
    ));
  }

  /// Create a copy of SupportNewTicketState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupportTicketModelCopyWith<$Res>? get created {
    if (_self.created == null) {
      return null;
    }

    return $SupportTicketModelCopyWith<$Res>(_self.created!, (value) {
      return _then(_self.copyWith(created: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SupportNewTicketState].
extension SupportNewTicketStatePatterns on SupportNewTicketState {
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
    TResult Function(_SupportNewTicketState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupportNewTicketState() when $default != null:
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
    TResult Function(_SupportNewTicketState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportNewTicketState():
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
    TResult? Function(_SupportNewTicketState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportNewTicketState() when $default != null:
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
    TResult Function(SupportCategory? category, bool isSubmitting,
            DataError? error, SupportTicketModel? created)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupportNewTicketState() when $default != null:
        return $default(
            _that.category, _that.isSubmitting, _that.error, _that.created);
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
    TResult Function(SupportCategory? category, bool isSubmitting,
            DataError? error, SupportTicketModel? created)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportNewTicketState():
        return $default(
            _that.category, _that.isSubmitting, _that.error, _that.created);
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
    TResult? Function(SupportCategory? category, bool isSubmitting,
            DataError? error, SupportTicketModel? created)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportNewTicketState() when $default != null:
        return $default(
            _that.category, _that.isSubmitting, _that.error, _that.created);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SupportNewTicketState implements SupportNewTicketState {
  const _SupportNewTicketState(
      {this.category, this.isSubmitting = false, this.error, this.created});

  @override
  final SupportCategory? category;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final DataError? error;

  /// Tiket yang baru dibuat (hasil baca ulang). Layar mengganti rutenya ke
  /// halaman tiket ini.
  @override
  final SupportTicketModel? created;

  /// Create a copy of SupportNewTicketState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SupportNewTicketStateCopyWith<_SupportNewTicketState> get copyWith =>
      __$SupportNewTicketStateCopyWithImpl<_SupportNewTicketState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SupportNewTicketState &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.created, created) || other.created == created));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, category, isSubmitting, error, created);

  @override
  String toString() {
    return 'SupportNewTicketState(category: $category, isSubmitting: $isSubmitting, error: $error, created: $created)';
  }
}

/// @nodoc
abstract mixin class _$SupportNewTicketStateCopyWith<$Res>
    implements $SupportNewTicketStateCopyWith<$Res> {
  factory _$SupportNewTicketStateCopyWith(_SupportNewTicketState value,
          $Res Function(_SupportNewTicketState) _then) =
      __$SupportNewTicketStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SupportCategory? category,
      bool isSubmitting,
      DataError? error,
      SupportTicketModel? created});

  @override
  $SupportTicketModelCopyWith<$Res>? get created;
}

/// @nodoc
class __$SupportNewTicketStateCopyWithImpl<$Res>
    implements _$SupportNewTicketStateCopyWith<$Res> {
  __$SupportNewTicketStateCopyWithImpl(this._self, this._then);

  final _SupportNewTicketState _self;
  final $Res Function(_SupportNewTicketState) _then;

  /// Create a copy of SupportNewTicketState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = freezed,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? created = freezed,
  }) {
    return _then(_SupportNewTicketState(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as SupportCategory?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
      created: freezed == created
          ? _self.created
          : created // ignore: cast_nullable_to_non_nullable
              as SupportTicketModel?,
    ));
  }

  /// Create a copy of SupportNewTicketState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupportTicketModelCopyWith<$Res>? get created {
    if (_self.created == null) {
      return null;
    }

    return $SupportTicketModelCopyWith<$Res>(_self.created!, (value) {
      return _then(_self.copyWith(created: value));
    });
  }
}

// dart format on
