// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddressState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddressState()';
  }
}

/// @nodoc
class $AddressStateCopyWith<$Res> {
  $AddressStateCopyWith(AddressState _, $Res Function(AddressState) __);
}

/// Adds pattern-matching-related methods to [AddressState].
extension AddressStatePatterns on AddressState {
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
    TResult Function(AddressLoading value)? loading,
    TResult Function(AddressReady value)? ready,
    TResult Function(AddressError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AddressLoading() when loading != null:
        return loading(_that);
      case AddressReady() when ready != null:
        return ready(_that);
      case AddressError() when error != null:
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
    required TResult Function(AddressLoading value) loading,
    required TResult Function(AddressReady value) ready,
    required TResult Function(AddressError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case AddressLoading():
        return loading(_that);
      case AddressReady():
        return ready(_that);
      case AddressError():
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
    TResult? Function(AddressLoading value)? loading,
    TResult? Function(AddressReady value)? ready,
    TResult? Function(AddressError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case AddressLoading() when loading != null:
        return loading(_that);
      case AddressReady() when ready != null:
        return ready(_that);
      case AddressError() when error != null:
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
    TResult Function(List<AddressModel> addresses, bool isSaving,
            DataError? actionError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AddressLoading() when loading != null:
        return loading();
      case AddressReady() when ready != null:
        return ready(_that.addresses, _that.isSaving, _that.actionError);
      case AddressError() when error != null:
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
            List<AddressModel> addresses, bool isSaving, DataError? actionError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case AddressLoading():
        return loading();
      case AddressReady():
        return ready(_that.addresses, _that.isSaving, _that.actionError);
      case AddressError():
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
    TResult? Function(List<AddressModel> addresses, bool isSaving,
            DataError? actionError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case AddressLoading() when loading != null:
        return loading();
      case AddressReady() when ready != null:
        return ready(_that.addresses, _that.isSaving, _that.actionError);
      case AddressError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AddressLoading extends AddressState {
  const AddressLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddressLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddressState.loading()';
  }
}

/// @nodoc

class AddressReady extends AddressState {
  const AddressReady(
      {final List<AddressModel> addresses = const <AddressModel>[],
      this.isSaving = false,
      this.actionError})
      : _addresses = addresses,
        super._();

  final List<AddressModel> _addresses;
  @JsonKey()
  List<AddressModel> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  /// Sedang mengirim perubahan (tambah/ubah/hapus/set utama).
  @JsonKey()
  final bool isSaving;

  /// Kegagalan aksi terakhir; isi daftar tetap dipertahankan.
  final DataError? actionError;

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddressReadyCopyWith<AddressReady> get copyWith =>
      _$AddressReadyCopyWithImpl<AddressReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddressReady &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_addresses), isSaving, actionError);

  @override
  String toString() {
    return 'AddressState.ready(addresses: $addresses, isSaving: $isSaving, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $AddressReadyCopyWith<$Res>
    implements $AddressStateCopyWith<$Res> {
  factory $AddressReadyCopyWith(
          AddressReady value, $Res Function(AddressReady) _then) =
      _$AddressReadyCopyWithImpl;
  @useResult
  $Res call(
      {List<AddressModel> addresses, bool isSaving, DataError? actionError});
}

/// @nodoc
class _$AddressReadyCopyWithImpl<$Res> implements $AddressReadyCopyWith<$Res> {
  _$AddressReadyCopyWithImpl(this._self, this._then);

  final AddressReady _self;
  final $Res Function(AddressReady) _then;

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? addresses = null,
    Object? isSaving = null,
    Object? actionError = freezed,
  }) {
    return _then(AddressReady(
      addresses: null == addresses
          ? _self._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<AddressModel>,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class AddressError extends AddressState {
  const AddressError(this.error) : super._();

  final DataError error;

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddressErrorCopyWith<AddressError> get copyWith =>
      _$AddressErrorCopyWithImpl<AddressError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddressError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'AddressState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $AddressErrorCopyWith<$Res>
    implements $AddressStateCopyWith<$Res> {
  factory $AddressErrorCopyWith(
          AddressError value, $Res Function(AddressError) _then) =
      _$AddressErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$AddressErrorCopyWithImpl<$Res> implements $AddressErrorCopyWith<$Res> {
  _$AddressErrorCopyWithImpl(this._self, this._then);

  final AddressError _self;
  final $Res Function(AddressError) _then;

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(AddressError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
