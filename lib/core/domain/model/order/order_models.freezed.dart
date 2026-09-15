// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {
  @IntJson()
  int get id;
  @StringJson()
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @StringOrNullJson()
  @JsonKey(name: 'checkout_session_id')
  String? get checkoutSessionId;
  @IntJson()
  @JsonKey(name: 'store_id')
  int get storeId;

  /// Kode status mentah. Pakai [status] untuk logika.
  @StringJson()
  @JsonKey(name: 'status')
  String get statusCode;
  @DoubleJson()
  double get subtotal;
  @DoubleJson()
  @JsonKey(name: 'shipping_cost')
  double get shippingCost;
  @DoubleJson()
  @JsonKey(name: 'discount_total')
  double get discountTotal;
  @DoubleJson()
  @JsonKey(name: 'cashback_total')
  double get cashbackTotal;
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  double get grandTotal;
  @StringOrNullJson()
  @JsonKey(name: 'courier_code')
  String? get courierCode;
  @StringOrNullJson()
  @JsonKey(name: 'courier_service')
  String? get courierService;
  @StringOrNullJson()
  @JsonKey(name: 'tracking_number')
  String? get trackingNumber;

  /// ⚠️ **Hanya berisi `{"address_id": "59"}`**, bukan alamat lengkap —
  /// dan dikirim sebagai string berisi JSON. Untuk menampilkan alamat
  /// tujuan, ambil dari `GET /me/addresses` memakai id ini.
  @JsonMapJson()
  @JsonKey(name: 'shipping_address_snapshot')
  Map<String, dynamic>? get shippingAddressSnapshot;

  /// **UTC**, seperti `expires_at` di checkout — bukan WIB seperti
  /// [createdAt] di respons yang sama. Lihat [ServerUtcDateTimeJson].
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'payment_deadline')
  DateTime? get paymentDeadline;

  /// **Waktu dinding server (WIB).**
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  List<OrderItemModel> get items;
  @JsonKey(name: 'status_history')
  List<OrderStatusHistoryModel> get statusHistory;
  OrderRefundModel? get refund;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<OrderModel> get copyWith =>
      _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.checkoutSessionId, checkoutSessionId) ||
                other.checkoutSessionId == checkoutSessionId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.discountTotal, discountTotal) ||
                other.discountTotal == discountTotal) &&
            (identical(other.cashbackTotal, cashbackTotal) ||
                other.cashbackTotal == cashbackTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.courierCode, courierCode) ||
                other.courierCode == courierCode) &&
            (identical(other.courierService, courierService) ||
                other.courierService == courierService) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            const DeepCollectionEquality().equals(
                other.shippingAddressSnapshot, shippingAddressSnapshot) &&
            (identical(other.paymentDeadline, paymentDeadline) ||
                other.paymentDeadline == paymentDeadline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            const DeepCollectionEquality()
                .equals(other.statusHistory, statusHistory) &&
            (identical(other.refund, refund) || other.refund == refund));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        checkoutSessionId,
        storeId,
        statusCode,
        subtotal,
        shippingCost,
        discountTotal,
        cashbackTotal,
        grandTotal,
        courierCode,
        courierService,
        trackingNumber,
        const DeepCollectionEquality().hash(shippingAddressSnapshot),
        paymentDeadline,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(items),
        const DeepCollectionEquality().hash(statusHistory),
        refund
      ]);

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, checkoutSessionId: $checkoutSessionId, storeId: $storeId, statusCode: $statusCode, subtotal: $subtotal, shippingCost: $shippingCost, discountTotal: $discountTotal, cashbackTotal: $cashbackTotal, grandTotal: $grandTotal, courierCode: $courierCode, courierService: $courierService, trackingNumber: $trackingNumber, shippingAddressSnapshot: $shippingAddressSnapshot, paymentDeadline: $paymentDeadline, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, statusHistory: $statusHistory, refund: $refund)';
  }
}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) _then) =
      _$OrderModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'order_number') String orderNumber,
      @StringOrNullJson()
      @JsonKey(name: 'checkout_session_id')
      String? checkoutSessionId,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() @JsonKey(name: 'status') String statusCode,
      @DoubleJson() double subtotal,
      @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
      @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
      @DoubleJson() @JsonKey(name: 'cashback_total') double cashbackTotal,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
      @StringOrNullJson() @JsonKey(name: 'courier_code') String? courierCode,
      @StringOrNullJson()
      @JsonKey(name: 'courier_service')
      String? courierService,
      @StringOrNullJson()
      @JsonKey(name: 'tracking_number')
      String? trackingNumber,
      @JsonMapJson()
      @JsonKey(name: 'shipping_address_snapshot')
      Map<String, dynamic>? shippingAddressSnapshot,
      @ServerUtcDateTimeJson()
      @JsonKey(name: 'payment_deadline')
      DateTime? paymentDeadline,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<OrderItemModel> items,
      @JsonKey(name: 'status_history')
      List<OrderStatusHistoryModel> statusHistory,
      OrderRefundModel? refund});

  $OrderRefundModelCopyWith<$Res>? get refund;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res> implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? checkoutSessionId = freezed,
    Object? storeId = null,
    Object? statusCode = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discountTotal = null,
    Object? cashbackTotal = null,
    Object? grandTotal = null,
    Object? courierCode = freezed,
    Object? courierService = freezed,
    Object? trackingNumber = freezed,
    Object? shippingAddressSnapshot = freezed,
    Object? paymentDeadline = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? items = null,
    Object? statusHistory = null,
    Object? refund = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      checkoutSessionId: freezed == checkoutSessionId
          ? _self.checkoutSessionId
          : checkoutSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _self.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      discountTotal: null == discountTotal
          ? _self.discountTotal
          : discountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      cashbackTotal: null == cashbackTotal
          ? _self.cashbackTotal
          : cashbackTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      courierCode: freezed == courierCode
          ? _self.courierCode
          : courierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      courierService: freezed == courierService
          ? _self.courierService
          : courierService // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _self.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddressSnapshot: freezed == shippingAddressSnapshot
          ? _self.shippingAddressSnapshot
          : shippingAddressSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      paymentDeadline: freezed == paymentDeadline
          ? _self.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      statusHistory: null == statusHistory
          ? _self.statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusHistoryModel>,
      refund: freezed == refund
          ? _self.refund
          : refund // ignore: cast_nullable_to_non_nullable
              as OrderRefundModel?,
    ));
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderRefundModelCopyWith<$Res>? get refund {
    if (_self.refund == null) {
      return null;
    }

    return $OrderRefundModelCopyWith<$Res>(_self.refund!, (value) {
      return _then(_self.copyWith(refund: value));
    });
  }
}

/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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
    TResult Function(_OrderModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
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
    TResult Function(_OrderModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel():
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
    TResult? Function(_OrderModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
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
            @IntJson() int id,
            @StringJson() @JsonKey(name: 'order_number') String orderNumber,
            @StringOrNullJson()
            @JsonKey(name: 'checkout_session_id')
            String? checkoutSessionId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @DoubleJson() double subtotal,
            @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
            @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
            @DoubleJson() @JsonKey(name: 'cashback_total') double cashbackTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @StringOrNullJson()
            @JsonKey(name: 'courier_code')
            String? courierCode,
            @StringOrNullJson()
            @JsonKey(name: 'courier_service')
            String? courierService,
            @StringOrNullJson()
            @JsonKey(name: 'tracking_number')
            String? trackingNumber,
            @JsonMapJson()
            @JsonKey(name: 'shipping_address_snapshot')
            Map<String, dynamic>? shippingAddressSnapshot,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'payment_deadline')
            DateTime? paymentDeadline,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            List<OrderItemModel> items,
            @JsonKey(name: 'status_history')
            List<OrderStatusHistoryModel> statusHistory,
            OrderRefundModel? refund)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
        return $default(
            _that.id,
            _that.orderNumber,
            _that.checkoutSessionId,
            _that.storeId,
            _that.statusCode,
            _that.subtotal,
            _that.shippingCost,
            _that.discountTotal,
            _that.cashbackTotal,
            _that.grandTotal,
            _that.courierCode,
            _that.courierService,
            _that.trackingNumber,
            _that.shippingAddressSnapshot,
            _that.paymentDeadline,
            _that.createdAt,
            _that.updatedAt,
            _that.items,
            _that.statusHistory,
            _that.refund);
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
            @IntJson() int id,
            @StringJson() @JsonKey(name: 'order_number') String orderNumber,
            @StringOrNullJson()
            @JsonKey(name: 'checkout_session_id')
            String? checkoutSessionId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @DoubleJson() double subtotal,
            @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
            @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
            @DoubleJson() @JsonKey(name: 'cashback_total') double cashbackTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @StringOrNullJson()
            @JsonKey(name: 'courier_code')
            String? courierCode,
            @StringOrNullJson()
            @JsonKey(name: 'courier_service')
            String? courierService,
            @StringOrNullJson()
            @JsonKey(name: 'tracking_number')
            String? trackingNumber,
            @JsonMapJson()
            @JsonKey(name: 'shipping_address_snapshot')
            Map<String, dynamic>? shippingAddressSnapshot,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'payment_deadline')
            DateTime? paymentDeadline,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            List<OrderItemModel> items,
            @JsonKey(name: 'status_history')
            List<OrderStatusHistoryModel> statusHistory,
            OrderRefundModel? refund)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel():
        return $default(
            _that.id,
            _that.orderNumber,
            _that.checkoutSessionId,
            _that.storeId,
            _that.statusCode,
            _that.subtotal,
            _that.shippingCost,
            _that.discountTotal,
            _that.cashbackTotal,
            _that.grandTotal,
            _that.courierCode,
            _that.courierService,
            _that.trackingNumber,
            _that.shippingAddressSnapshot,
            _that.paymentDeadline,
            _that.createdAt,
            _that.updatedAt,
            _that.items,
            _that.statusHistory,
            _that.refund);
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
            @IntJson() int id,
            @StringJson() @JsonKey(name: 'order_number') String orderNumber,
            @StringOrNullJson()
            @JsonKey(name: 'checkout_session_id')
            String? checkoutSessionId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @DoubleJson() double subtotal,
            @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
            @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
            @DoubleJson() @JsonKey(name: 'cashback_total') double cashbackTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @StringOrNullJson()
            @JsonKey(name: 'courier_code')
            String? courierCode,
            @StringOrNullJson()
            @JsonKey(name: 'courier_service')
            String? courierService,
            @StringOrNullJson()
            @JsonKey(name: 'tracking_number')
            String? trackingNumber,
            @JsonMapJson()
            @JsonKey(name: 'shipping_address_snapshot')
            Map<String, dynamic>? shippingAddressSnapshot,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'payment_deadline')
            DateTime? paymentDeadline,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            List<OrderItemModel> items,
            @JsonKey(name: 'status_history')
            List<OrderStatusHistoryModel> statusHistory,
            OrderRefundModel? refund)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
        return $default(
            _that.id,
            _that.orderNumber,
            _that.checkoutSessionId,
            _that.storeId,
            _that.statusCode,
            _that.subtotal,
            _that.shippingCost,
            _that.discountTotal,
            _that.cashbackTotal,
            _that.grandTotal,
            _that.courierCode,
            _that.courierService,
            _that.trackingNumber,
            _that.shippingAddressSnapshot,
            _that.paymentDeadline,
            _that.createdAt,
            _that.updatedAt,
            _that.items,
            _that.statusHistory,
            _that.refund);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderModel extends OrderModel {
  const _OrderModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'order_number') this.orderNumber = '',
      @StringOrNullJson()
      @JsonKey(name: 'checkout_session_id')
      this.checkoutSessionId,
      @IntJson() @JsonKey(name: 'store_id') this.storeId = 0,
      @StringJson() @JsonKey(name: 'status') this.statusCode = '',
      @DoubleJson() this.subtotal = 0,
      @DoubleJson() @JsonKey(name: 'shipping_cost') this.shippingCost = 0,
      @DoubleJson() @JsonKey(name: 'discount_total') this.discountTotal = 0,
      @DoubleJson() @JsonKey(name: 'cashback_total') this.cashbackTotal = 0,
      @DoubleJson() @JsonKey(name: 'grand_total') this.grandTotal = 0,
      @StringOrNullJson() @JsonKey(name: 'courier_code') this.courierCode,
      @StringOrNullJson() @JsonKey(name: 'courier_service') this.courierService,
      @StringOrNullJson() @JsonKey(name: 'tracking_number') this.trackingNumber,
      @JsonMapJson()
      @JsonKey(name: 'shipping_address_snapshot')
      final Map<String, dynamic>? shippingAddressSnapshot,
      @ServerUtcDateTimeJson()
      @JsonKey(name: 'payment_deadline')
      this.paymentDeadline,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') this.updatedAt,
      final List<OrderItemModel> items = const <OrderItemModel>[],
      @JsonKey(name: 'status_history')
      final List<OrderStatusHistoryModel> statusHistory =
          const <OrderStatusHistoryModel>[],
      this.refund})
      : _shippingAddressSnapshot = shippingAddressSnapshot,
        _items = items,
        _statusHistory = statusHistory,
        super._();
  factory _OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringJson()
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'checkout_session_id')
  final String? checkoutSessionId;
  @override
  @IntJson()
  @JsonKey(name: 'store_id')
  final int storeId;

  /// Kode status mentah. Pakai [status] untuk logika.
  @override
  @StringJson()
  @JsonKey(name: 'status')
  final String statusCode;
  @override
  @JsonKey()
  @DoubleJson()
  final double subtotal;
  @override
  @DoubleJson()
  @JsonKey(name: 'shipping_cost')
  final double shippingCost;
  @override
  @DoubleJson()
  @JsonKey(name: 'discount_total')
  final double discountTotal;
  @override
  @DoubleJson()
  @JsonKey(name: 'cashback_total')
  final double cashbackTotal;
  @override
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  final double grandTotal;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'courier_code')
  final String? courierCode;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'courier_service')
  final String? courierService;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;

  /// ⚠️ **Hanya berisi `{"address_id": "59"}`**, bukan alamat lengkap —
  /// dan dikirim sebagai string berisi JSON. Untuk menampilkan alamat
  /// tujuan, ambil dari `GET /me/addresses` memakai id ini.
  final Map<String, dynamic>? _shippingAddressSnapshot;

  /// ⚠️ **Hanya berisi `{"address_id": "59"}`**, bukan alamat lengkap —
  /// dan dikirim sebagai string berisi JSON. Untuk menampilkan alamat
  /// tujuan, ambil dari `GET /me/addresses` memakai id ini.
  @override
  @JsonMapJson()
  @JsonKey(name: 'shipping_address_snapshot')
  Map<String, dynamic>? get shippingAddressSnapshot {
    final value = _shippingAddressSnapshot;
    if (value == null) return null;
    if (_shippingAddressSnapshot is EqualUnmodifiableMapView)
      return _shippingAddressSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// **UTC**, seperti `expires_at` di checkout — bukan WIB seperti
  /// [createdAt] di respons yang sama. Lihat [ServerUtcDateTimeJson].
  @override
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'payment_deadline')
  final DateTime? paymentDeadline;

  /// **Waktu dinding server (WIB).**
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<OrderItemModel> _items;
  @override
  @JsonKey()
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<OrderStatusHistoryModel> _statusHistory;
  @override
  @JsonKey(name: 'status_history')
  List<OrderStatusHistoryModel> get statusHistory {
    if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusHistory);
  }

  @override
  final OrderRefundModel? refund;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderModelCopyWith<_OrderModel> get copyWith =>
      __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.checkoutSessionId, checkoutSessionId) ||
                other.checkoutSessionId == checkoutSessionId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.discountTotal, discountTotal) ||
                other.discountTotal == discountTotal) &&
            (identical(other.cashbackTotal, cashbackTotal) ||
                other.cashbackTotal == cashbackTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.courierCode, courierCode) ||
                other.courierCode == courierCode) &&
            (identical(other.courierService, courierService) ||
                other.courierService == courierService) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            const DeepCollectionEquality().equals(
                other._shippingAddressSnapshot, _shippingAddressSnapshot) &&
            (identical(other.paymentDeadline, paymentDeadline) ||
                other.paymentDeadline == paymentDeadline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._statusHistory, _statusHistory) &&
            (identical(other.refund, refund) || other.refund == refund));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        checkoutSessionId,
        storeId,
        statusCode,
        subtotal,
        shippingCost,
        discountTotal,
        cashbackTotal,
        grandTotal,
        courierCode,
        courierService,
        trackingNumber,
        const DeepCollectionEquality().hash(_shippingAddressSnapshot),
        paymentDeadline,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_items),
        const DeepCollectionEquality().hash(_statusHistory),
        refund
      ]);

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, checkoutSessionId: $checkoutSessionId, storeId: $storeId, statusCode: $statusCode, subtotal: $subtotal, shippingCost: $shippingCost, discountTotal: $discountTotal, cashbackTotal: $cashbackTotal, grandTotal: $grandTotal, courierCode: $courierCode, courierService: $courierService, trackingNumber: $trackingNumber, shippingAddressSnapshot: $shippingAddressSnapshot, paymentDeadline: $paymentDeadline, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, statusHistory: $statusHistory, refund: $refund)';
  }
}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(
          _OrderModel value, $Res Function(_OrderModel) _then) =
      __$OrderModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'order_number') String orderNumber,
      @StringOrNullJson()
      @JsonKey(name: 'checkout_session_id')
      String? checkoutSessionId,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() @JsonKey(name: 'status') String statusCode,
      @DoubleJson() double subtotal,
      @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
      @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
      @DoubleJson() @JsonKey(name: 'cashback_total') double cashbackTotal,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
      @StringOrNullJson() @JsonKey(name: 'courier_code') String? courierCode,
      @StringOrNullJson()
      @JsonKey(name: 'courier_service')
      String? courierService,
      @StringOrNullJson()
      @JsonKey(name: 'tracking_number')
      String? trackingNumber,
      @JsonMapJson()
      @JsonKey(name: 'shipping_address_snapshot')
      Map<String, dynamic>? shippingAddressSnapshot,
      @ServerUtcDateTimeJson()
      @JsonKey(name: 'payment_deadline')
      DateTime? paymentDeadline,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<OrderItemModel> items,
      @JsonKey(name: 'status_history')
      List<OrderStatusHistoryModel> statusHistory,
      OrderRefundModel? refund});

  @override
  $OrderRefundModelCopyWith<$Res>? get refund;
}

/// @nodoc
class __$OrderModelCopyWithImpl<$Res> implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? checkoutSessionId = freezed,
    Object? storeId = null,
    Object? statusCode = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discountTotal = null,
    Object? cashbackTotal = null,
    Object? grandTotal = null,
    Object? courierCode = freezed,
    Object? courierService = freezed,
    Object? trackingNumber = freezed,
    Object? shippingAddressSnapshot = freezed,
    Object? paymentDeadline = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? items = null,
    Object? statusHistory = null,
    Object? refund = freezed,
  }) {
    return _then(_OrderModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      checkoutSessionId: freezed == checkoutSessionId
          ? _self.checkoutSessionId
          : checkoutSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _self.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      discountTotal: null == discountTotal
          ? _self.discountTotal
          : discountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      cashbackTotal: null == cashbackTotal
          ? _self.cashbackTotal
          : cashbackTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      courierCode: freezed == courierCode
          ? _self.courierCode
          : courierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      courierService: freezed == courierService
          ? _self.courierService
          : courierService // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _self.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddressSnapshot: freezed == shippingAddressSnapshot
          ? _self._shippingAddressSnapshot
          : shippingAddressSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      paymentDeadline: freezed == paymentDeadline
          ? _self.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      statusHistory: null == statusHistory
          ? _self._statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusHistoryModel>,
      refund: freezed == refund
          ? _self.refund
          : refund // ignore: cast_nullable_to_non_nullable
              as OrderRefundModel?,
    ));
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderRefundModelCopyWith<$Res>? get refund {
    if (_self.refund == null) {
      return null;
    }

    return $OrderRefundModelCopyWith<$Res>(_self.refund!, (value) {
      return _then(_self.copyWith(refund: value));
    });
  }
}

/// @nodoc
mixin _$OrderItemModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'product_variant_id')
  int get productVariantId;
  @StringJson()
  @JsonKey(name: 'product_name_snapshot')
  String get productName;

  /// String berisi JSON, seperti `variant_options` di katalog.
  @JsonMapJson()
  @JsonKey(name: 'variant_options_snapshot')
  Map<String, dynamic>? get variantOptions;
  @DoubleJson()
  @JsonKey(name: 'price_snapshot')
  double get price;
  @IntJson()
  int get quantity;
  @DoubleJson()
  double get subtotal;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      _$OrderItemModelCopyWithImpl<OrderItemModel>(
          this as OrderItemModel, _$identity);

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productVariantId, productVariantId) ||
                other.productVariantId == productVariantId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality()
                .equals(other.variantOptions, variantOptions) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productVariantId,
      productName,
      const DeepCollectionEquality().hash(variantOptions),
      price,
      quantity,
      subtotal);

  @override
  String toString() {
    return 'OrderItemModel(id: $id, productVariantId: $productVariantId, productName: $productName, variantOptions: $variantOptions, price: $price, quantity: $quantity, subtotal: $subtotal)';
  }
}

/// @nodoc
abstract mixin class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
          OrderItemModel value, $Res Function(OrderItemModel) _then) =
      _$OrderItemModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'product_variant_id') int productVariantId,
      @StringJson() @JsonKey(name: 'product_name_snapshot') String productName,
      @JsonMapJson()
      @JsonKey(name: 'variant_options_snapshot')
      Map<String, dynamic>? variantOptions,
      @DoubleJson() @JsonKey(name: 'price_snapshot') double price,
      @IntJson() int quantity,
      @DoubleJson() double subtotal});
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._self, this._then);

  final OrderItemModel _self;
  final $Res Function(OrderItemModel) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productVariantId = null,
    Object? productName = null,
    Object? variantOptions = freezed,
    Object? price = null,
    Object? quantity = null,
    Object? subtotal = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productVariantId: null == productVariantId
          ? _self.productVariantId
          : productVariantId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      variantOptions: freezed == variantOptions
          ? _self.variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderItemModel].
extension OrderItemModelPatterns on OrderItemModel {
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
    TResult Function(_OrderItemModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel() when $default != null:
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
    TResult Function(_OrderItemModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel():
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
    TResult? Function(_OrderItemModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel() when $default != null:
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
            @IntJson() int id,
            @IntJson()
            @JsonKey(name: 'product_variant_id')
            int productVariantId,
            @StringJson()
            @JsonKey(name: 'product_name_snapshot')
            String productName,
            @JsonMapJson()
            @JsonKey(name: 'variant_options_snapshot')
            Map<String, dynamic>? variantOptions,
            @DoubleJson() @JsonKey(name: 'price_snapshot') double price,
            @IntJson() int quantity,
            @DoubleJson() double subtotal)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel() when $default != null:
        return $default(_that.id, _that.productVariantId, _that.productName,
            _that.variantOptions, _that.price, _that.quantity, _that.subtotal);
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
            @IntJson() int id,
            @IntJson()
            @JsonKey(name: 'product_variant_id')
            int productVariantId,
            @StringJson()
            @JsonKey(name: 'product_name_snapshot')
            String productName,
            @JsonMapJson()
            @JsonKey(name: 'variant_options_snapshot')
            Map<String, dynamic>? variantOptions,
            @DoubleJson() @JsonKey(name: 'price_snapshot') double price,
            @IntJson() int quantity,
            @DoubleJson() double subtotal)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel():
        return $default(_that.id, _that.productVariantId, _that.productName,
            _that.variantOptions, _that.price, _that.quantity, _that.subtotal);
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
            @IntJson() int id,
            @IntJson()
            @JsonKey(name: 'product_variant_id')
            int productVariantId,
            @StringJson()
            @JsonKey(name: 'product_name_snapshot')
            String productName,
            @JsonMapJson()
            @JsonKey(name: 'variant_options_snapshot')
            Map<String, dynamic>? variantOptions,
            @DoubleJson() @JsonKey(name: 'price_snapshot') double price,
            @IntJson() int quantity,
            @DoubleJson() double subtotal)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel() when $default != null:
        return $default(_that.id, _that.productVariantId, _that.productName,
            _that.variantOptions, _that.price, _that.quantity, _that.subtotal);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderItemModel extends OrderItemModel {
  const _OrderItemModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'product_variant_id') this.productVariantId = 0,
      @StringJson()
      @JsonKey(name: 'product_name_snapshot')
      this.productName = '',
      @JsonMapJson()
      @JsonKey(name: 'variant_options_snapshot')
      final Map<String, dynamic>? variantOptions,
      @DoubleJson() @JsonKey(name: 'price_snapshot') this.price = 0,
      @IntJson() this.quantity = 0,
      @DoubleJson() this.subtotal = 0})
      : _variantOptions = variantOptions,
        super._();
  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'product_variant_id')
  final int productVariantId;
  @override
  @StringJson()
  @JsonKey(name: 'product_name_snapshot')
  final String productName;

  /// String berisi JSON, seperti `variant_options` di katalog.
  final Map<String, dynamic>? _variantOptions;

  /// String berisi JSON, seperti `variant_options` di katalog.
  @override
  @JsonMapJson()
  @JsonKey(name: 'variant_options_snapshot')
  Map<String, dynamic>? get variantOptions {
    final value = _variantOptions;
    if (value == null) return null;
    if (_variantOptions is EqualUnmodifiableMapView) return _variantOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @DoubleJson()
  @JsonKey(name: 'price_snapshot')
  final double price;
  @override
  @JsonKey()
  @IntJson()
  final int quantity;
  @override
  @JsonKey()
  @DoubleJson()
  final double subtotal;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderItemModelCopyWith<_OrderItemModel> get copyWith =>
      __$OrderItemModelCopyWithImpl<_OrderItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productVariantId, productVariantId) ||
                other.productVariantId == productVariantId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality()
                .equals(other._variantOptions, _variantOptions) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productVariantId,
      productName,
      const DeepCollectionEquality().hash(_variantOptions),
      price,
      quantity,
      subtotal);

  @override
  String toString() {
    return 'OrderItemModel(id: $id, productVariantId: $productVariantId, productName: $productName, variantOptions: $variantOptions, price: $price, quantity: $quantity, subtotal: $subtotal)';
  }
}

/// @nodoc
abstract mixin class _$OrderItemModelCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$OrderItemModelCopyWith(
          _OrderItemModel value, $Res Function(_OrderItemModel) _then) =
      __$OrderItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'product_variant_id') int productVariantId,
      @StringJson() @JsonKey(name: 'product_name_snapshot') String productName,
      @JsonMapJson()
      @JsonKey(name: 'variant_options_snapshot')
      Map<String, dynamic>? variantOptions,
      @DoubleJson() @JsonKey(name: 'price_snapshot') double price,
      @IntJson() int quantity,
      @DoubleJson() double subtotal});
}

/// @nodoc
class __$OrderItemModelCopyWithImpl<$Res>
    implements _$OrderItemModelCopyWith<$Res> {
  __$OrderItemModelCopyWithImpl(this._self, this._then);

  final _OrderItemModel _self;
  final $Res Function(_OrderItemModel) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? productVariantId = null,
    Object? productName = null,
    Object? variantOptions = freezed,
    Object? price = null,
    Object? quantity = null,
    Object? subtotal = null,
  }) {
    return _then(_OrderItemModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productVariantId: null == productVariantId
          ? _self.productVariantId
          : productVariantId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      variantOptions: freezed == variantOptions
          ? _self._variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$OrderStatusHistoryModel {
  @IntJson()
  int get id;
  @StringOrNullJson()
  @JsonKey(name: 'from_status')
  String? get fromStatus;
  @StringJson()
  @JsonKey(name: 'to_status')
  String get toStatus;
  @StringOrNullJson()
  String? get notes;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of OrderStatusHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderStatusHistoryModelCopyWith<OrderStatusHistoryModel> get copyWith =>
      _$OrderStatusHistoryModelCopyWithImpl<OrderStatusHistoryModel>(
          this as OrderStatusHistoryModel, _$identity);

  /// Serializes this OrderStatusHistoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderStatusHistoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromStatus, fromStatus) ||
                other.fromStatus == fromStatus) &&
            (identical(other.toStatus, toStatus) ||
                other.toStatus == toStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fromStatus, toStatus, notes, createdAt);

  @override
  String toString() {
    return 'OrderStatusHistoryModel(id: $id, fromStatus: $fromStatus, toStatus: $toStatus, notes: $notes, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $OrderStatusHistoryModelCopyWith<$Res> {
  factory $OrderStatusHistoryModelCopyWith(OrderStatusHistoryModel value,
          $Res Function(OrderStatusHistoryModel) _then) =
      _$OrderStatusHistoryModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringOrNullJson() @JsonKey(name: 'from_status') String? fromStatus,
      @StringJson() @JsonKey(name: 'to_status') String toStatus,
      @StringOrNullJson() String? notes,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$OrderStatusHistoryModelCopyWithImpl<$Res>
    implements $OrderStatusHistoryModelCopyWith<$Res> {
  _$OrderStatusHistoryModelCopyWithImpl(this._self, this._then);

  final OrderStatusHistoryModel _self;
  final $Res Function(OrderStatusHistoryModel) _then;

  /// Create a copy of OrderStatusHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromStatus = freezed,
    Object? toStatus = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fromStatus: freezed == fromStatus
          ? _self.fromStatus
          : fromStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      toStatus: null == toStatus
          ? _self.toStatus
          : toStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderStatusHistoryModel].
extension OrderStatusHistoryModelPatterns on OrderStatusHistoryModel {
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
    TResult Function(_OrderStatusHistoryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderStatusHistoryModel() when $default != null:
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
    TResult Function(_OrderStatusHistoryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderStatusHistoryModel():
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
    TResult? Function(_OrderStatusHistoryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderStatusHistoryModel() when $default != null:
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
            @IntJson() int id,
            @StringOrNullJson()
            @JsonKey(name: 'from_status')
            String? fromStatus,
            @StringJson() @JsonKey(name: 'to_status') String toStatus,
            @StringOrNullJson() String? notes,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderStatusHistoryModel() when $default != null:
        return $default(_that.id, _that.fromStatus, _that.toStatus, _that.notes,
            _that.createdAt);
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
            @IntJson() int id,
            @StringOrNullJson()
            @JsonKey(name: 'from_status')
            String? fromStatus,
            @StringJson() @JsonKey(name: 'to_status') String toStatus,
            @StringOrNullJson() String? notes,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderStatusHistoryModel():
        return $default(_that.id, _that.fromStatus, _that.toStatus, _that.notes,
            _that.createdAt);
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
            @IntJson() int id,
            @StringOrNullJson()
            @JsonKey(name: 'from_status')
            String? fromStatus,
            @StringJson() @JsonKey(name: 'to_status') String toStatus,
            @StringOrNullJson() String? notes,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderStatusHistoryModel() when $default != null:
        return $default(_that.id, _that.fromStatus, _that.toStatus, _that.notes,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderStatusHistoryModel extends OrderStatusHistoryModel {
  const _OrderStatusHistoryModel(
      {@IntJson() required this.id,
      @StringOrNullJson() @JsonKey(name: 'from_status') this.fromStatus,
      @StringJson() @JsonKey(name: 'to_status') this.toStatus = '',
      @StringOrNullJson() this.notes,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'from_status')
  final String? fromStatus;
  @override
  @StringJson()
  @JsonKey(name: 'to_status')
  final String toStatus;
  @override
  @StringOrNullJson()
  final String? notes;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of OrderStatusHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderStatusHistoryModelCopyWith<_OrderStatusHistoryModel> get copyWith =>
      __$OrderStatusHistoryModelCopyWithImpl<_OrderStatusHistoryModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderStatusHistoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderStatusHistoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromStatus, fromStatus) ||
                other.fromStatus == fromStatus) &&
            (identical(other.toStatus, toStatus) ||
                other.toStatus == toStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fromStatus, toStatus, notes, createdAt);

  @override
  String toString() {
    return 'OrderStatusHistoryModel(id: $id, fromStatus: $fromStatus, toStatus: $toStatus, notes: $notes, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$OrderStatusHistoryModelCopyWith<$Res>
    implements $OrderStatusHistoryModelCopyWith<$Res> {
  factory _$OrderStatusHistoryModelCopyWith(_OrderStatusHistoryModel value,
          $Res Function(_OrderStatusHistoryModel) _then) =
      __$OrderStatusHistoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringOrNullJson() @JsonKey(name: 'from_status') String? fromStatus,
      @StringJson() @JsonKey(name: 'to_status') String toStatus,
      @StringOrNullJson() String? notes,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$OrderStatusHistoryModelCopyWithImpl<$Res>
    implements _$OrderStatusHistoryModelCopyWith<$Res> {
  __$OrderStatusHistoryModelCopyWithImpl(this._self, this._then);

  final _OrderStatusHistoryModel _self;
  final $Res Function(_OrderStatusHistoryModel) _then;

  /// Create a copy of OrderStatusHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? fromStatus = freezed,
    Object? toStatus = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_OrderStatusHistoryModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fromStatus: freezed == fromStatus
          ? _self.fromStatus
          : fromStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      toStatus: null == toStatus
          ? _self.toStatus
          : toStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$OrderRefundModel {
  @IntJson()
  int get id;
  @StringJson()
  String get status;
  @StringOrNullJson()
  String? get reason;
  @DoubleJson()
  double get amount;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of OrderRefundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderRefundModelCopyWith<OrderRefundModel> get copyWith =>
      _$OrderRefundModelCopyWithImpl<OrderRefundModel>(
          this as OrderRefundModel, _$identity);

  /// Serializes this OrderRefundModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderRefundModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, status, reason, amount, createdAt);

  @override
  String toString() {
    return 'OrderRefundModel(id: $id, status: $status, reason: $reason, amount: $amount, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $OrderRefundModelCopyWith<$Res> {
  factory $OrderRefundModelCopyWith(
          OrderRefundModel value, $Res Function(OrderRefundModel) _then) =
      _$OrderRefundModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String status,
      @StringOrNullJson() String? reason,
      @DoubleJson() double amount,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$OrderRefundModelCopyWithImpl<$Res>
    implements $OrderRefundModelCopyWith<$Res> {
  _$OrderRefundModelCopyWithImpl(this._self, this._then);

  final OrderRefundModel _self;
  final $Res Function(OrderRefundModel) _then;

  /// Create a copy of OrderRefundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? reason = freezed,
    Object? amount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderRefundModel].
extension OrderRefundModelPatterns on OrderRefundModel {
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
    TResult Function(_OrderRefundModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderRefundModel() when $default != null:
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
    TResult Function(_OrderRefundModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderRefundModel():
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
    TResult? Function(_OrderRefundModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderRefundModel() when $default != null:
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
            @IntJson() int id,
            @StringJson() String status,
            @StringOrNullJson() String? reason,
            @DoubleJson() double amount,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderRefundModel() when $default != null:
        return $default(_that.id, _that.status, _that.reason, _that.amount,
            _that.createdAt);
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
            @IntJson() int id,
            @StringJson() String status,
            @StringOrNullJson() String? reason,
            @DoubleJson() double amount,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderRefundModel():
        return $default(_that.id, _that.status, _that.reason, _that.amount,
            _that.createdAt);
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
            @IntJson() int id,
            @StringJson() String status,
            @StringOrNullJson() String? reason,
            @DoubleJson() double amount,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderRefundModel() when $default != null:
        return $default(_that.id, _that.status, _that.reason, _that.amount,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderRefundModel implements OrderRefundModel {
  const _OrderRefundModel(
      {@IntJson() required this.id,
      @StringJson() this.status = '',
      @StringOrNullJson() this.reason,
      @DoubleJson() this.amount = 0,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt});
  factory _OrderRefundModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRefundModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @StringOrNullJson()
  final String? reason;
  @override
  @JsonKey()
  @DoubleJson()
  final double amount;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of OrderRefundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderRefundModelCopyWith<_OrderRefundModel> get copyWith =>
      __$OrderRefundModelCopyWithImpl<_OrderRefundModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderRefundModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderRefundModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, status, reason, amount, createdAt);

  @override
  String toString() {
    return 'OrderRefundModel(id: $id, status: $status, reason: $reason, amount: $amount, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$OrderRefundModelCopyWith<$Res>
    implements $OrderRefundModelCopyWith<$Res> {
  factory _$OrderRefundModelCopyWith(
          _OrderRefundModel value, $Res Function(_OrderRefundModel) _then) =
      __$OrderRefundModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String status,
      @StringOrNullJson() String? reason,
      @DoubleJson() double amount,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$OrderRefundModelCopyWithImpl<$Res>
    implements _$OrderRefundModelCopyWith<$Res> {
  __$OrderRefundModelCopyWithImpl(this._self, this._then);

  final _OrderRefundModel _self;
  final $Res Function(_OrderRefundModel) _then;

  /// Create a copy of OrderRefundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? reason = freezed,
    Object? amount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_OrderRefundModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
