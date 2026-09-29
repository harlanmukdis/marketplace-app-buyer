// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishlistState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WishlistState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WishlistState()';
  }
}

/// @nodoc
class $WishlistStateCopyWith<$Res> {
  $WishlistStateCopyWith(WishlistState _, $Res Function(WishlistState) __);
}

/// Adds pattern-matching-related methods to [WishlistState].
extension WishlistStatePatterns on WishlistState {
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
    TResult Function(WishlistLoading value)? loading,
    TResult Function(WishlistReady value)? ready,
    TResult Function(WishlistError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case WishlistLoading() when loading != null:
        return loading(_that);
      case WishlistReady() when ready != null:
        return ready(_that);
      case WishlistError() when error != null:
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
    required TResult Function(WishlistLoading value) loading,
    required TResult Function(WishlistReady value) ready,
    required TResult Function(WishlistError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case WishlistLoading():
        return loading(_that);
      case WishlistReady():
        return ready(_that);
      case WishlistError():
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
    TResult? Function(WishlistLoading value)? loading,
    TResult? Function(WishlistReady value)? ready,
    TResult? Function(WishlistError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case WishlistLoading() when loading != null:
        return loading(_that);
      case WishlistReady() when ready != null:
        return ready(_that);
      case WishlistError() when error != null:
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
            List<WishlistItemModel> items,
            Set<int> mutatingProductIds,
            Set<int> alertMutatingIds,
            Map<String, dynamic> meta,
            DataError? actionError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case WishlistLoading() when loading != null:
        return loading();
      case WishlistReady() when ready != null:
        return ready(_that.items, _that.mutatingProductIds,
            _that.alertMutatingIds, _that.meta, _that.actionError);
      case WishlistError() when error != null:
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
            List<WishlistItemModel> items,
            Set<int> mutatingProductIds,
            Set<int> alertMutatingIds,
            Map<String, dynamic> meta,
            DataError? actionError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case WishlistLoading():
        return loading();
      case WishlistReady():
        return ready(_that.items, _that.mutatingProductIds,
            _that.alertMutatingIds, _that.meta, _that.actionError);
      case WishlistError():
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
            List<WishlistItemModel> items,
            Set<int> mutatingProductIds,
            Set<int> alertMutatingIds,
            Map<String, dynamic> meta,
            DataError? actionError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case WishlistLoading() when loading != null:
        return loading();
      case WishlistReady() when ready != null:
        return ready(_that.items, _that.mutatingProductIds,
            _that.alertMutatingIds, _that.meta, _that.actionError);
      case WishlistError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class WishlistLoading extends WishlistState {
  const WishlistLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WishlistLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WishlistState.loading()';
  }
}

/// @nodoc

class WishlistReady extends WishlistState {
  const WishlistReady(
      {final List<WishlistItemModel> items = const <WishlistItemModel>[],
      final Set<int> mutatingProductIds = const <int>{},
      final Set<int> alertMutatingIds = const <int>{},
      final Map<String, dynamic> meta = const <String, dynamic>{},
      this.actionError})
      : _items = items,
        _mutatingProductIds = mutatingProductIds,
        _alertMutatingIds = alertMutatingIds,
        _meta = meta,
        super._();

  final List<WishlistItemModel> _items;
  @JsonKey()
  List<WishlistItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Id **produk** yang sedang dikirim ke server, supaya hanya barisnya yang
  /// terkunci — bukan seluruh layar.
  final Set<int> _mutatingProductIds;

  /// Id **produk** yang sedang dikirim ke server, supaya hanya barisnya yang
  /// terkunci — bukan seluruh layar.
  @JsonKey()
  Set<int> get mutatingProductIds {
    if (_mutatingProductIds is EqualUnmodifiableSetView)
      return _mutatingProductIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_mutatingProductIds);
  }

  /// Id produk yang sakelar pantau harganya sedang dikirim.
  final Set<int> _alertMutatingIds;

  /// Id produk yang sakelar pantau harganya sedang dikirim.
  @JsonKey()
  Set<int> get alertMutatingIds {
    if (_alertMutatingIds is EqualUnmodifiableSetView) return _alertMutatingIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_alertMutatingIds);
  }

  /// `meta` baca terakhir. `meta.mock_fields` berisi `alert_enabled`
  /// selama pantau harga masih disimulasikan (docs/22 #13).
  final Map<String, dynamic> _meta;

  /// `meta` baca terakhir. `meta.mock_fields` berisi `alert_enabled`
  /// selama pantau harga masih disimulasikan (docs/22 #13).
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  final DataError? actionError;

  /// Create a copy of WishlistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WishlistReadyCopyWith<WishlistReady> get copyWith =>
      _$WishlistReadyCopyWithImpl<WishlistReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WishlistReady &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._mutatingProductIds, _mutatingProductIds) &&
            const DeepCollectionEquality()
                .equals(other._alertMutatingIds, _alertMutatingIds) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_mutatingProductIds),
      const DeepCollectionEquality().hash(_alertMutatingIds),
      const DeepCollectionEquality().hash(_meta),
      actionError);

  @override
  String toString() {
    return 'WishlistState.ready(items: $items, mutatingProductIds: $mutatingProductIds, alertMutatingIds: $alertMutatingIds, meta: $meta, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $WishlistReadyCopyWith<$Res>
    implements $WishlistStateCopyWith<$Res> {
  factory $WishlistReadyCopyWith(
          WishlistReady value, $Res Function(WishlistReady) _then) =
      _$WishlistReadyCopyWithImpl;
  @useResult
  $Res call(
      {List<WishlistItemModel> items,
      Set<int> mutatingProductIds,
      Set<int> alertMutatingIds,
      Map<String, dynamic> meta,
      DataError? actionError});
}

/// @nodoc
class _$WishlistReadyCopyWithImpl<$Res>
    implements $WishlistReadyCopyWith<$Res> {
  _$WishlistReadyCopyWithImpl(this._self, this._then);

  final WishlistReady _self;
  final $Res Function(WishlistReady) _then;

  /// Create a copy of WishlistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? mutatingProductIds = null,
    Object? alertMutatingIds = null,
    Object? meta = null,
    Object? actionError = freezed,
  }) {
    return _then(WishlistReady(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WishlistItemModel>,
      mutatingProductIds: null == mutatingProductIds
          ? _self._mutatingProductIds
          : mutatingProductIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      alertMutatingIds: null == alertMutatingIds
          ? _self._alertMutatingIds
          : alertMutatingIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      meta: null == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class WishlistError extends WishlistState {
  const WishlistError(this.error) : super._();

  final DataError error;

  /// Create a copy of WishlistState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WishlistErrorCopyWith<WishlistError> get copyWith =>
      _$WishlistErrorCopyWithImpl<WishlistError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WishlistError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'WishlistState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $WishlistErrorCopyWith<$Res>
    implements $WishlistStateCopyWith<$Res> {
  factory $WishlistErrorCopyWith(
          WishlistError value, $Res Function(WishlistError) _then) =
      _$WishlistErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$WishlistErrorCopyWithImpl<$Res>
    implements $WishlistErrorCopyWith<$Res> {
  _$WishlistErrorCopyWithImpl(this._self, this._then);

  final WishlistError _self;
  final $Res Function(WishlistError) _then;

  /// Create a copy of WishlistState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(WishlistError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
