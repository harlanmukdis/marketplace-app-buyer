// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_share_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatShareState {
  /// Toko lawan bicara. Dari konteks pembuka, atau diselesaikan lewat
  /// daftar percakapan saat laci lampiran pertama dibuka.
  int? get storeId;

  /// Produk yang sedang ditanyakan (ruang dibuka dari halaman produk).
  int? get pinnedProductId;
  bool get pinnedDismissed;
  Map<int, ProductModel> get products;
  Map<int, OrderModel> get orders;
  Set<int> get failedProductIds;
  Set<int> get failedOrderIds;
  ChatPickerStatus get pickerStatus;
  List<OrderModel> get pickerOrders;
  DataError? get pickerError;

  /// Create a copy of ChatShareState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatShareStateCopyWith<ChatShareState> get copyWith =>
      _$ChatShareStateCopyWithImpl<ChatShareState>(
          this as ChatShareState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatShareState &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.pinnedProductId, pinnedProductId) ||
                other.pinnedProductId == pinnedProductId) &&
            (identical(other.pinnedDismissed, pinnedDismissed) ||
                other.pinnedDismissed == pinnedDismissed) &&
            const DeepCollectionEquality().equals(other.products, products) &&
            const DeepCollectionEquality().equals(other.orders, orders) &&
            const DeepCollectionEquality()
                .equals(other.failedProductIds, failedProductIds) &&
            const DeepCollectionEquality()
                .equals(other.failedOrderIds, failedOrderIds) &&
            (identical(other.pickerStatus, pickerStatus) ||
                other.pickerStatus == pickerStatus) &&
            const DeepCollectionEquality()
                .equals(other.pickerOrders, pickerOrders) &&
            (identical(other.pickerError, pickerError) ||
                other.pickerError == pickerError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      pinnedProductId,
      pinnedDismissed,
      const DeepCollectionEquality().hash(products),
      const DeepCollectionEquality().hash(orders),
      const DeepCollectionEquality().hash(failedProductIds),
      const DeepCollectionEquality().hash(failedOrderIds),
      pickerStatus,
      const DeepCollectionEquality().hash(pickerOrders),
      pickerError);

  @override
  String toString() {
    return 'ChatShareState(storeId: $storeId, pinnedProductId: $pinnedProductId, pinnedDismissed: $pinnedDismissed, products: $products, orders: $orders, failedProductIds: $failedProductIds, failedOrderIds: $failedOrderIds, pickerStatus: $pickerStatus, pickerOrders: $pickerOrders, pickerError: $pickerError)';
  }
}

/// @nodoc
abstract mixin class $ChatShareStateCopyWith<$Res> {
  factory $ChatShareStateCopyWith(
          ChatShareState value, $Res Function(ChatShareState) _then) =
      _$ChatShareStateCopyWithImpl;
  @useResult
  $Res call(
      {int? storeId,
      int? pinnedProductId,
      bool pinnedDismissed,
      Map<int, ProductModel> products,
      Map<int, OrderModel> orders,
      Set<int> failedProductIds,
      Set<int> failedOrderIds,
      ChatPickerStatus pickerStatus,
      List<OrderModel> pickerOrders,
      DataError? pickerError});
}

/// @nodoc
class _$ChatShareStateCopyWithImpl<$Res>
    implements $ChatShareStateCopyWith<$Res> {
  _$ChatShareStateCopyWithImpl(this._self, this._then);

  final ChatShareState _self;
  final $Res Function(ChatShareState) _then;

  /// Create a copy of ChatShareState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = freezed,
    Object? pinnedProductId = freezed,
    Object? pinnedDismissed = null,
    Object? products = null,
    Object? orders = null,
    Object? failedProductIds = null,
    Object? failedOrderIds = null,
    Object? pickerStatus = null,
    Object? pickerOrders = null,
    Object? pickerError = freezed,
  }) {
    return _then(_self.copyWith(
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int?,
      pinnedProductId: freezed == pinnedProductId
          ? _self.pinnedProductId
          : pinnedProductId // ignore: cast_nullable_to_non_nullable
              as int?,
      pinnedDismissed: null == pinnedDismissed
          ? _self.pinnedDismissed
          : pinnedDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      products: null == products
          ? _self.products
          : products // ignore: cast_nullable_to_non_nullable
              as Map<int, ProductModel>,
      orders: null == orders
          ? _self.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as Map<int, OrderModel>,
      failedProductIds: null == failedProductIds
          ? _self.failedProductIds
          : failedProductIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      failedOrderIds: null == failedOrderIds
          ? _self.failedOrderIds
          : failedOrderIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      pickerStatus: null == pickerStatus
          ? _self.pickerStatus
          : pickerStatus // ignore: cast_nullable_to_non_nullable
              as ChatPickerStatus,
      pickerOrders: null == pickerOrders
          ? _self.pickerOrders
          : pickerOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      pickerError: freezed == pickerError
          ? _self.pickerError
          : pickerError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatShareState].
extension ChatShareStatePatterns on ChatShareState {
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
    TResult Function(_ChatShareState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatShareState() when $default != null:
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
    TResult Function(_ChatShareState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatShareState():
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
    TResult? Function(_ChatShareState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatShareState() when $default != null:
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
            int? storeId,
            int? pinnedProductId,
            bool pinnedDismissed,
            Map<int, ProductModel> products,
            Map<int, OrderModel> orders,
            Set<int> failedProductIds,
            Set<int> failedOrderIds,
            ChatPickerStatus pickerStatus,
            List<OrderModel> pickerOrders,
            DataError? pickerError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatShareState() when $default != null:
        return $default(
            _that.storeId,
            _that.pinnedProductId,
            _that.pinnedDismissed,
            _that.products,
            _that.orders,
            _that.failedProductIds,
            _that.failedOrderIds,
            _that.pickerStatus,
            _that.pickerOrders,
            _that.pickerError);
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
            int? storeId,
            int? pinnedProductId,
            bool pinnedDismissed,
            Map<int, ProductModel> products,
            Map<int, OrderModel> orders,
            Set<int> failedProductIds,
            Set<int> failedOrderIds,
            ChatPickerStatus pickerStatus,
            List<OrderModel> pickerOrders,
            DataError? pickerError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatShareState():
        return $default(
            _that.storeId,
            _that.pinnedProductId,
            _that.pinnedDismissed,
            _that.products,
            _that.orders,
            _that.failedProductIds,
            _that.failedOrderIds,
            _that.pickerStatus,
            _that.pickerOrders,
            _that.pickerError);
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
            int? storeId,
            int? pinnedProductId,
            bool pinnedDismissed,
            Map<int, ProductModel> products,
            Map<int, OrderModel> orders,
            Set<int> failedProductIds,
            Set<int> failedOrderIds,
            ChatPickerStatus pickerStatus,
            List<OrderModel> pickerOrders,
            DataError? pickerError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatShareState() when $default != null:
        return $default(
            _that.storeId,
            _that.pinnedProductId,
            _that.pinnedDismissed,
            _that.products,
            _that.orders,
            _that.failedProductIds,
            _that.failedOrderIds,
            _that.pickerStatus,
            _that.pickerOrders,
            _that.pickerError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ChatShareState extends ChatShareState {
  const _ChatShareState(
      {this.storeId,
      this.pinnedProductId,
      this.pinnedDismissed = false,
      final Map<int, ProductModel> products = const <int, ProductModel>{},
      final Map<int, OrderModel> orders = const <int, OrderModel>{},
      final Set<int> failedProductIds = const <int>{},
      final Set<int> failedOrderIds = const <int>{},
      this.pickerStatus = ChatPickerStatus.idle,
      final List<OrderModel> pickerOrders = const <OrderModel>[],
      this.pickerError})
      : _products = products,
        _orders = orders,
        _failedProductIds = failedProductIds,
        _failedOrderIds = failedOrderIds,
        _pickerOrders = pickerOrders,
        super._();

  /// Toko lawan bicara. Dari konteks pembuka, atau diselesaikan lewat
  /// daftar percakapan saat laci lampiran pertama dibuka.
  @override
  final int? storeId;

  /// Produk yang sedang ditanyakan (ruang dibuka dari halaman produk).
  @override
  final int? pinnedProductId;
  @override
  @JsonKey()
  final bool pinnedDismissed;
  final Map<int, ProductModel> _products;
  @override
  @JsonKey()
  Map<int, ProductModel> get products {
    if (_products is EqualUnmodifiableMapView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_products);
  }

  final Map<int, OrderModel> _orders;
  @override
  @JsonKey()
  Map<int, OrderModel> get orders {
    if (_orders is EqualUnmodifiableMapView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_orders);
  }

  final Set<int> _failedProductIds;
  @override
  @JsonKey()
  Set<int> get failedProductIds {
    if (_failedProductIds is EqualUnmodifiableSetView) return _failedProductIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_failedProductIds);
  }

  final Set<int> _failedOrderIds;
  @override
  @JsonKey()
  Set<int> get failedOrderIds {
    if (_failedOrderIds is EqualUnmodifiableSetView) return _failedOrderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_failedOrderIds);
  }

  @override
  @JsonKey()
  final ChatPickerStatus pickerStatus;
  final List<OrderModel> _pickerOrders;
  @override
  @JsonKey()
  List<OrderModel> get pickerOrders {
    if (_pickerOrders is EqualUnmodifiableListView) return _pickerOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pickerOrders);
  }

  @override
  final DataError? pickerError;

  /// Create a copy of ChatShareState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatShareStateCopyWith<_ChatShareState> get copyWith =>
      __$ChatShareStateCopyWithImpl<_ChatShareState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatShareState &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.pinnedProductId, pinnedProductId) ||
                other.pinnedProductId == pinnedProductId) &&
            (identical(other.pinnedDismissed, pinnedDismissed) ||
                other.pinnedDismissed == pinnedDismissed) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            const DeepCollectionEquality()
                .equals(other._failedProductIds, _failedProductIds) &&
            const DeepCollectionEquality()
                .equals(other._failedOrderIds, _failedOrderIds) &&
            (identical(other.pickerStatus, pickerStatus) ||
                other.pickerStatus == pickerStatus) &&
            const DeepCollectionEquality()
                .equals(other._pickerOrders, _pickerOrders) &&
            (identical(other.pickerError, pickerError) ||
                other.pickerError == pickerError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      pinnedProductId,
      pinnedDismissed,
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(_orders),
      const DeepCollectionEquality().hash(_failedProductIds),
      const DeepCollectionEquality().hash(_failedOrderIds),
      pickerStatus,
      const DeepCollectionEquality().hash(_pickerOrders),
      pickerError);

  @override
  String toString() {
    return 'ChatShareState(storeId: $storeId, pinnedProductId: $pinnedProductId, pinnedDismissed: $pinnedDismissed, products: $products, orders: $orders, failedProductIds: $failedProductIds, failedOrderIds: $failedOrderIds, pickerStatus: $pickerStatus, pickerOrders: $pickerOrders, pickerError: $pickerError)';
  }
}

/// @nodoc
abstract mixin class _$ChatShareStateCopyWith<$Res>
    implements $ChatShareStateCopyWith<$Res> {
  factory _$ChatShareStateCopyWith(
          _ChatShareState value, $Res Function(_ChatShareState) _then) =
      __$ChatShareStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? storeId,
      int? pinnedProductId,
      bool pinnedDismissed,
      Map<int, ProductModel> products,
      Map<int, OrderModel> orders,
      Set<int> failedProductIds,
      Set<int> failedOrderIds,
      ChatPickerStatus pickerStatus,
      List<OrderModel> pickerOrders,
      DataError? pickerError});
}

/// @nodoc
class __$ChatShareStateCopyWithImpl<$Res>
    implements _$ChatShareStateCopyWith<$Res> {
  __$ChatShareStateCopyWithImpl(this._self, this._then);

  final _ChatShareState _self;
  final $Res Function(_ChatShareState) _then;

  /// Create a copy of ChatShareState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? storeId = freezed,
    Object? pinnedProductId = freezed,
    Object? pinnedDismissed = null,
    Object? products = null,
    Object? orders = null,
    Object? failedProductIds = null,
    Object? failedOrderIds = null,
    Object? pickerStatus = null,
    Object? pickerOrders = null,
    Object? pickerError = freezed,
  }) {
    return _then(_ChatShareState(
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int?,
      pinnedProductId: freezed == pinnedProductId
          ? _self.pinnedProductId
          : pinnedProductId // ignore: cast_nullable_to_non_nullable
              as int?,
      pinnedDismissed: null == pinnedDismissed
          ? _self.pinnedDismissed
          : pinnedDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      products: null == products
          ? _self._products
          : products // ignore: cast_nullable_to_non_nullable
              as Map<int, ProductModel>,
      orders: null == orders
          ? _self._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as Map<int, OrderModel>,
      failedProductIds: null == failedProductIds
          ? _self._failedProductIds
          : failedProductIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      failedOrderIds: null == failedOrderIds
          ? _self._failedOrderIds
          : failedOrderIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      pickerStatus: null == pickerStatus
          ? _self.pickerStatus
          : pickerStatus // ignore: cast_nullable_to_non_nullable
              as ChatPickerStatus,
      pickerOrders: null == pickerOrders
          ? _self._pickerOrders
          : pickerOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      pickerError: freezed == pickerError
          ? _self.pickerError
          : pickerError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

// dart format on
