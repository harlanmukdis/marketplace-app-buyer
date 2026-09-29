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
  /// dan dikirim sebagai string berisi JSON.
  ///
  /// Sejak backend v1.x (blueprint Seller Ch.7) field ini **hanya ada di
  /// `GET /orders` (daftar)**. `GET /orders/{id}` menggantinya dengan
  /// [shippingAddress] yang sudah terselesaikan.
  @JsonMapJson()
  @JsonKey(name: 'shipping_address_snapshot')
  Map<String, dynamic>? get shippingAddressSnapshot;

  /// Alamat tujuan lengkap, **hanya di `GET /orders/{id}`**.
  ///
  /// ⚠️ Bukan snapshot: server menggabungkannya secara live ke
  /// `user_addresses`, jadi mengubah alamat itu sesudahnya ikut mengubah
  /// pesanan lama, dan menghapusnya membuat field ini `null`.
  @JsonKey(name: 'shipping_address')
  OrderShippingAddress? get shippingAddress;

  /// **Belum dikirim server** — kontrak yang diusulkan (lihat
  /// `OrderPaymentLinkStore`). Selama `null`, pakai [payableTransactionId].
  @IntOrNullJson()
  @JsonKey(name: 'payment_transaction_id')
  int? get paymentTransactionId;

  /// Pihak yang menyebabkan pembatalan: `buyer`, `seller`, `system`.
  @StringOrNullJson()
  @JsonKey(name: 'cancellation_fault')
  String? get cancellationFault;

  /// Custom order yang menunggu konfirmasi penjual. Statusnya tetap `paid`
  /// — **tidak ada status "Menunggu Konfirmasi" di server** — jadi
  /// [awaitsSellerConfirmation] yang menyimpulkannya.
  @BoolJson()
  @JsonKey(name: 'requires_custom_confirmation')
  bool get requiresCustomConfirmation;
  @ServerDateTimeJson()
  @JsonKey(name: 'custom_confirmed_at')
  DateTime? get customConfirmedAt;
  @IntOrNullJson()
  @JsonKey(name: 'estimated_lead_time_days')
  int? get estimatedLeadTimeDays;

  /// Penjual mengusulkan kirim sebagian karena sebagian barang tidak
  /// tersedia. Statusnya tetap `paid`; pembeli menjawab lewat
  /// `POST /orders/{id}/partial-fulfillment/respond`.
  @ServerDateTimeJson()
  @JsonKey(name: 'partial_fulfillment_proposed_at')
  DateTime? get partialFulfillmentProposedAt;

  /// `continue_partial` / `cancel_whole`, `null` selama belum dijawab.
  @StringOrNullJson()
  @JsonKey(name: 'partial_fulfillment_decision')
  String? get partialFulfillmentDecision;

  /// Tenggat pembayaran, 1 jam sesudah [createdAt].
  ///
  /// Dulu dikirim dalam UTC sementara [createdAt] dalam WIB; sejak backend
  /// menyeragamkan zona waktunya (commit `93c6a14`) keduanya WIB. Lihat
  /// catatan di kepala `checkout_models.dart`.
  @ServerDateTimeJson()
  @JsonKey(name: 'payment_deadline')
  DateTime? get paymentDeadline;
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
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId) &&
            (identical(other.cancellationFault, cancellationFault) ||
                other.cancellationFault == cancellationFault) &&
            (identical(other.requiresCustomConfirmation,
                    requiresCustomConfirmation) ||
                other.requiresCustomConfirmation ==
                    requiresCustomConfirmation) &&
            (identical(other.customConfirmedAt, customConfirmedAt) ||
                other.customConfirmedAt == customConfirmedAt) &&
            (identical(other.estimatedLeadTimeDays, estimatedLeadTimeDays) ||
                other.estimatedLeadTimeDays == estimatedLeadTimeDays) &&
            (identical(other.partialFulfillmentProposedAt,
                    partialFulfillmentProposedAt) ||
                other.partialFulfillmentProposedAt ==
                    partialFulfillmentProposedAt) &&
            (identical(other.partialFulfillmentDecision,
                    partialFulfillmentDecision) ||
                other.partialFulfillmentDecision ==
                    partialFulfillmentDecision) &&
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
        shippingAddress,
        paymentTransactionId,
        cancellationFault,
        requiresCustomConfirmation,
        customConfirmedAt,
        estimatedLeadTimeDays,
        partialFulfillmentProposedAt,
        partialFulfillmentDecision,
        paymentDeadline,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(items),
        const DeepCollectionEquality().hash(statusHistory),
        refund
      ]);

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, checkoutSessionId: $checkoutSessionId, storeId: $storeId, statusCode: $statusCode, subtotal: $subtotal, shippingCost: $shippingCost, discountTotal: $discountTotal, cashbackTotal: $cashbackTotal, grandTotal: $grandTotal, courierCode: $courierCode, courierService: $courierService, trackingNumber: $trackingNumber, shippingAddressSnapshot: $shippingAddressSnapshot, shippingAddress: $shippingAddress, paymentTransactionId: $paymentTransactionId, cancellationFault: $cancellationFault, requiresCustomConfirmation: $requiresCustomConfirmation, customConfirmedAt: $customConfirmedAt, estimatedLeadTimeDays: $estimatedLeadTimeDays, partialFulfillmentProposedAt: $partialFulfillmentProposedAt, partialFulfillmentDecision: $partialFulfillmentDecision, paymentDeadline: $paymentDeadline, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, statusHistory: $statusHistory, refund: $refund)';
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
      @JsonKey(name: 'shipping_address') OrderShippingAddress? shippingAddress,
      @IntOrNullJson()
      @JsonKey(name: 'payment_transaction_id')
      int? paymentTransactionId,
      @StringOrNullJson()
      @JsonKey(name: 'cancellation_fault')
      String? cancellationFault,
      @BoolJson()
      @JsonKey(name: 'requires_custom_confirmation')
      bool requiresCustomConfirmation,
      @ServerDateTimeJson()
      @JsonKey(name: 'custom_confirmed_at')
      DateTime? customConfirmedAt,
      @IntOrNullJson()
      @JsonKey(name: 'estimated_lead_time_days')
      int? estimatedLeadTimeDays,
      @ServerDateTimeJson()
      @JsonKey(name: 'partial_fulfillment_proposed_at')
      DateTime? partialFulfillmentProposedAt,
      @StringOrNullJson()
      @JsonKey(name: 'partial_fulfillment_decision')
      String? partialFulfillmentDecision,
      @ServerDateTimeJson()
      @JsonKey(name: 'payment_deadline')
      DateTime? paymentDeadline,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<OrderItemModel> items,
      @JsonKey(name: 'status_history')
      List<OrderStatusHistoryModel> statusHistory,
      OrderRefundModel? refund});

  $OrderShippingAddressCopyWith<$Res>? get shippingAddress;
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
    Object? shippingAddress = freezed,
    Object? paymentTransactionId = freezed,
    Object? cancellationFault = freezed,
    Object? requiresCustomConfirmation = null,
    Object? customConfirmedAt = freezed,
    Object? estimatedLeadTimeDays = freezed,
    Object? partialFulfillmentProposedAt = freezed,
    Object? partialFulfillmentDecision = freezed,
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
      shippingAddress: freezed == shippingAddress
          ? _self.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as OrderShippingAddress?,
      paymentTransactionId: freezed == paymentTransactionId
          ? _self.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationFault: freezed == cancellationFault
          ? _self.cancellationFault
          : cancellationFault // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresCustomConfirmation: null == requiresCustomConfirmation
          ? _self.requiresCustomConfirmation
          : requiresCustomConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      customConfirmedAt: freezed == customConfirmedAt
          ? _self.customConfirmedAt
          : customConfirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedLeadTimeDays: freezed == estimatedLeadTimeDays
          ? _self.estimatedLeadTimeDays
          : estimatedLeadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      partialFulfillmentProposedAt: freezed == partialFulfillmentProposedAt
          ? _self.partialFulfillmentProposedAt
          : partialFulfillmentProposedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      partialFulfillmentDecision: freezed == partialFulfillmentDecision
          ? _self.partialFulfillmentDecision
          : partialFulfillmentDecision // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $OrderShippingAddressCopyWith<$Res>? get shippingAddress {
    if (_self.shippingAddress == null) {
      return null;
    }

    return $OrderShippingAddressCopyWith<$Res>(_self.shippingAddress!, (value) {
      return _then(_self.copyWith(shippingAddress: value));
    });
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
            @JsonKey(name: 'shipping_address')
            OrderShippingAddress? shippingAddress,
            @IntOrNullJson()
            @JsonKey(name: 'payment_transaction_id')
            int? paymentTransactionId,
            @StringOrNullJson()
            @JsonKey(name: 'cancellation_fault')
            String? cancellationFault,
            @BoolJson()
            @JsonKey(name: 'requires_custom_confirmation')
            bool requiresCustomConfirmation,
            @ServerDateTimeJson()
            @JsonKey(name: 'custom_confirmed_at')
            DateTime? customConfirmedAt,
            @IntOrNullJson()
            @JsonKey(name: 'estimated_lead_time_days')
            int? estimatedLeadTimeDays,
            @ServerDateTimeJson()
            @JsonKey(name: 'partial_fulfillment_proposed_at')
            DateTime? partialFulfillmentProposedAt,
            @StringOrNullJson()
            @JsonKey(name: 'partial_fulfillment_decision')
            String? partialFulfillmentDecision,
            @ServerDateTimeJson()
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
            _that.shippingAddress,
            _that.paymentTransactionId,
            _that.cancellationFault,
            _that.requiresCustomConfirmation,
            _that.customConfirmedAt,
            _that.estimatedLeadTimeDays,
            _that.partialFulfillmentProposedAt,
            _that.partialFulfillmentDecision,
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
            @JsonKey(name: 'shipping_address')
            OrderShippingAddress? shippingAddress,
            @IntOrNullJson()
            @JsonKey(name: 'payment_transaction_id')
            int? paymentTransactionId,
            @StringOrNullJson()
            @JsonKey(name: 'cancellation_fault')
            String? cancellationFault,
            @BoolJson()
            @JsonKey(name: 'requires_custom_confirmation')
            bool requiresCustomConfirmation,
            @ServerDateTimeJson()
            @JsonKey(name: 'custom_confirmed_at')
            DateTime? customConfirmedAt,
            @IntOrNullJson()
            @JsonKey(name: 'estimated_lead_time_days')
            int? estimatedLeadTimeDays,
            @ServerDateTimeJson()
            @JsonKey(name: 'partial_fulfillment_proposed_at')
            DateTime? partialFulfillmentProposedAt,
            @StringOrNullJson()
            @JsonKey(name: 'partial_fulfillment_decision')
            String? partialFulfillmentDecision,
            @ServerDateTimeJson()
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
            _that.shippingAddress,
            _that.paymentTransactionId,
            _that.cancellationFault,
            _that.requiresCustomConfirmation,
            _that.customConfirmedAt,
            _that.estimatedLeadTimeDays,
            _that.partialFulfillmentProposedAt,
            _that.partialFulfillmentDecision,
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
            @JsonKey(name: 'shipping_address')
            OrderShippingAddress? shippingAddress,
            @IntOrNullJson()
            @JsonKey(name: 'payment_transaction_id')
            int? paymentTransactionId,
            @StringOrNullJson()
            @JsonKey(name: 'cancellation_fault')
            String? cancellationFault,
            @BoolJson()
            @JsonKey(name: 'requires_custom_confirmation')
            bool requiresCustomConfirmation,
            @ServerDateTimeJson()
            @JsonKey(name: 'custom_confirmed_at')
            DateTime? customConfirmedAt,
            @IntOrNullJson()
            @JsonKey(name: 'estimated_lead_time_days')
            int? estimatedLeadTimeDays,
            @ServerDateTimeJson()
            @JsonKey(name: 'partial_fulfillment_proposed_at')
            DateTime? partialFulfillmentProposedAt,
            @StringOrNullJson()
            @JsonKey(name: 'partial_fulfillment_decision')
            String? partialFulfillmentDecision,
            @ServerDateTimeJson()
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
            _that.shippingAddress,
            _that.paymentTransactionId,
            _that.cancellationFault,
            _that.requiresCustomConfirmation,
            _that.customConfirmedAt,
            _that.estimatedLeadTimeDays,
            _that.partialFulfillmentProposedAt,
            _that.partialFulfillmentDecision,
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
      @JsonKey(name: 'shipping_address') this.shippingAddress,
      @IntOrNullJson()
      @JsonKey(name: 'payment_transaction_id')
      this.paymentTransactionId,
      @StringOrNullJson()
      @JsonKey(name: 'cancellation_fault')
      this.cancellationFault,
      @BoolJson()
      @JsonKey(name: 'requires_custom_confirmation')
      this.requiresCustomConfirmation = false,
      @ServerDateTimeJson()
      @JsonKey(name: 'custom_confirmed_at')
      this.customConfirmedAt,
      @IntOrNullJson()
      @JsonKey(name: 'estimated_lead_time_days')
      this.estimatedLeadTimeDays,
      @ServerDateTimeJson()
      @JsonKey(name: 'partial_fulfillment_proposed_at')
      this.partialFulfillmentProposedAt,
      @StringOrNullJson()
      @JsonKey(name: 'partial_fulfillment_decision')
      this.partialFulfillmentDecision,
      @ServerDateTimeJson()
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
  /// dan dikirim sebagai string berisi JSON.
  ///
  /// Sejak backend v1.x (blueprint Seller Ch.7) field ini **hanya ada di
  /// `GET /orders` (daftar)**. `GET /orders/{id}` menggantinya dengan
  /// [shippingAddress] yang sudah terselesaikan.
  final Map<String, dynamic>? _shippingAddressSnapshot;

  /// ⚠️ **Hanya berisi `{"address_id": "59"}`**, bukan alamat lengkap —
  /// dan dikirim sebagai string berisi JSON.
  ///
  /// Sejak backend v1.x (blueprint Seller Ch.7) field ini **hanya ada di
  /// `GET /orders` (daftar)**. `GET /orders/{id}` menggantinya dengan
  /// [shippingAddress] yang sudah terselesaikan.
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

  /// Alamat tujuan lengkap, **hanya di `GET /orders/{id}`**.
  ///
  /// ⚠️ Bukan snapshot: server menggabungkannya secara live ke
  /// `user_addresses`, jadi mengubah alamat itu sesudahnya ikut mengubah
  /// pesanan lama, dan menghapusnya membuat field ini `null`.
  @override
  @JsonKey(name: 'shipping_address')
  final OrderShippingAddress? shippingAddress;

  /// **Belum dikirim server** — kontrak yang diusulkan (lihat
  /// `OrderPaymentLinkStore`). Selama `null`, pakai [payableTransactionId].
  @override
  @IntOrNullJson()
  @JsonKey(name: 'payment_transaction_id')
  final int? paymentTransactionId;

  /// Pihak yang menyebabkan pembatalan: `buyer`, `seller`, `system`.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'cancellation_fault')
  final String? cancellationFault;

  /// Custom order yang menunggu konfirmasi penjual. Statusnya tetap `paid`
  /// — **tidak ada status "Menunggu Konfirmasi" di server** — jadi
  /// [awaitsSellerConfirmation] yang menyimpulkannya.
  @override
  @BoolJson()
  @JsonKey(name: 'requires_custom_confirmation')
  final bool requiresCustomConfirmation;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'custom_confirmed_at')
  final DateTime? customConfirmedAt;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'estimated_lead_time_days')
  final int? estimatedLeadTimeDays;

  /// Penjual mengusulkan kirim sebagian karena sebagian barang tidak
  /// tersedia. Statusnya tetap `paid`; pembeli menjawab lewat
  /// `POST /orders/{id}/partial-fulfillment/respond`.
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'partial_fulfillment_proposed_at')
  final DateTime? partialFulfillmentProposedAt;

  /// `continue_partial` / `cancel_whole`, `null` selama belum dijawab.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'partial_fulfillment_decision')
  final String? partialFulfillmentDecision;

  /// Tenggat pembayaran, 1 jam sesudah [createdAt].
  ///
  /// Dulu dikirim dalam UTC sementara [createdAt] dalam WIB; sejak backend
  /// menyeragamkan zona waktunya (commit `93c6a14`) keduanya WIB. Lihat
  /// catatan di kepala `checkout_models.dart`.
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'payment_deadline')
  final DateTime? paymentDeadline;
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
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId) &&
            (identical(other.cancellationFault, cancellationFault) ||
                other.cancellationFault == cancellationFault) &&
            (identical(other.requiresCustomConfirmation,
                    requiresCustomConfirmation) ||
                other.requiresCustomConfirmation ==
                    requiresCustomConfirmation) &&
            (identical(other.customConfirmedAt, customConfirmedAt) ||
                other.customConfirmedAt == customConfirmedAt) &&
            (identical(other.estimatedLeadTimeDays, estimatedLeadTimeDays) ||
                other.estimatedLeadTimeDays == estimatedLeadTimeDays) &&
            (identical(other.partialFulfillmentProposedAt,
                    partialFulfillmentProposedAt) ||
                other.partialFulfillmentProposedAt ==
                    partialFulfillmentProposedAt) &&
            (identical(other.partialFulfillmentDecision,
                    partialFulfillmentDecision) ||
                other.partialFulfillmentDecision ==
                    partialFulfillmentDecision) &&
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
        shippingAddress,
        paymentTransactionId,
        cancellationFault,
        requiresCustomConfirmation,
        customConfirmedAt,
        estimatedLeadTimeDays,
        partialFulfillmentProposedAt,
        partialFulfillmentDecision,
        paymentDeadline,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_items),
        const DeepCollectionEquality().hash(_statusHistory),
        refund
      ]);

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, checkoutSessionId: $checkoutSessionId, storeId: $storeId, statusCode: $statusCode, subtotal: $subtotal, shippingCost: $shippingCost, discountTotal: $discountTotal, cashbackTotal: $cashbackTotal, grandTotal: $grandTotal, courierCode: $courierCode, courierService: $courierService, trackingNumber: $trackingNumber, shippingAddressSnapshot: $shippingAddressSnapshot, shippingAddress: $shippingAddress, paymentTransactionId: $paymentTransactionId, cancellationFault: $cancellationFault, requiresCustomConfirmation: $requiresCustomConfirmation, customConfirmedAt: $customConfirmedAt, estimatedLeadTimeDays: $estimatedLeadTimeDays, partialFulfillmentProposedAt: $partialFulfillmentProposedAt, partialFulfillmentDecision: $partialFulfillmentDecision, paymentDeadline: $paymentDeadline, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, statusHistory: $statusHistory, refund: $refund)';
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
      @JsonKey(name: 'shipping_address') OrderShippingAddress? shippingAddress,
      @IntOrNullJson()
      @JsonKey(name: 'payment_transaction_id')
      int? paymentTransactionId,
      @StringOrNullJson()
      @JsonKey(name: 'cancellation_fault')
      String? cancellationFault,
      @BoolJson()
      @JsonKey(name: 'requires_custom_confirmation')
      bool requiresCustomConfirmation,
      @ServerDateTimeJson()
      @JsonKey(name: 'custom_confirmed_at')
      DateTime? customConfirmedAt,
      @IntOrNullJson()
      @JsonKey(name: 'estimated_lead_time_days')
      int? estimatedLeadTimeDays,
      @ServerDateTimeJson()
      @JsonKey(name: 'partial_fulfillment_proposed_at')
      DateTime? partialFulfillmentProposedAt,
      @StringOrNullJson()
      @JsonKey(name: 'partial_fulfillment_decision')
      String? partialFulfillmentDecision,
      @ServerDateTimeJson()
      @JsonKey(name: 'payment_deadline')
      DateTime? paymentDeadline,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<OrderItemModel> items,
      @JsonKey(name: 'status_history')
      List<OrderStatusHistoryModel> statusHistory,
      OrderRefundModel? refund});

  @override
  $OrderShippingAddressCopyWith<$Res>? get shippingAddress;
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
    Object? shippingAddress = freezed,
    Object? paymentTransactionId = freezed,
    Object? cancellationFault = freezed,
    Object? requiresCustomConfirmation = null,
    Object? customConfirmedAt = freezed,
    Object? estimatedLeadTimeDays = freezed,
    Object? partialFulfillmentProposedAt = freezed,
    Object? partialFulfillmentDecision = freezed,
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
      shippingAddress: freezed == shippingAddress
          ? _self.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as OrderShippingAddress?,
      paymentTransactionId: freezed == paymentTransactionId
          ? _self.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationFault: freezed == cancellationFault
          ? _self.cancellationFault
          : cancellationFault // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresCustomConfirmation: null == requiresCustomConfirmation
          ? _self.requiresCustomConfirmation
          : requiresCustomConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      customConfirmedAt: freezed == customConfirmedAt
          ? _self.customConfirmedAt
          : customConfirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedLeadTimeDays: freezed == estimatedLeadTimeDays
          ? _self.estimatedLeadTimeDays
          : estimatedLeadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      partialFulfillmentProposedAt: freezed == partialFulfillmentProposedAt
          ? _self.partialFulfillmentProposedAt
          : partialFulfillmentProposedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      partialFulfillmentDecision: freezed == partialFulfillmentDecision
          ? _self.partialFulfillmentDecision
          : partialFulfillmentDecision // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $OrderShippingAddressCopyWith<$Res>? get shippingAddress {
    if (_self.shippingAddress == null) {
      return null;
    }

    return $OrderShippingAddressCopyWith<$Res>(_self.shippingAddress!, (value) {
      return _then(_self.copyWith(shippingAddress: value));
    });
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

  /// `false` untuk barang yang ditandai penjual tidak tersedia dalam usulan
  /// kirim sebagian.
  @BoolJson()
  @JsonKey(name: 'is_available')
  bool get isAvailable;

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
                other.subtotal == subtotal) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
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
      subtotal,
      isAvailable);

  @override
  String toString() {
    return 'OrderItemModel(id: $id, productVariantId: $productVariantId, productName: $productName, variantOptions: $variantOptions, price: $price, quantity: $quantity, subtotal: $subtotal, isAvailable: $isAvailable)';
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
      @DoubleJson() double subtotal,
      @BoolJson() @JsonKey(name: 'is_available') bool isAvailable});
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
    Object? isAvailable = null,
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
      isAvailable: null == isAvailable
          ? _self.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
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
            @DoubleJson() double subtotal,
            @BoolJson() @JsonKey(name: 'is_available') bool isAvailable)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel() when $default != null:
        return $default(
            _that.id,
            _that.productVariantId,
            _that.productName,
            _that.variantOptions,
            _that.price,
            _that.quantity,
            _that.subtotal,
            _that.isAvailable);
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
            @DoubleJson() double subtotal,
            @BoolJson() @JsonKey(name: 'is_available') bool isAvailable)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel():
        return $default(
            _that.id,
            _that.productVariantId,
            _that.productName,
            _that.variantOptions,
            _that.price,
            _that.quantity,
            _that.subtotal,
            _that.isAvailable);
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
            @DoubleJson() double subtotal,
            @BoolJson() @JsonKey(name: 'is_available') bool isAvailable)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderItemModel() when $default != null:
        return $default(
            _that.id,
            _that.productVariantId,
            _that.productName,
            _that.variantOptions,
            _that.price,
            _that.quantity,
            _that.subtotal,
            _that.isAvailable);
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
      @DoubleJson() this.subtotal = 0,
      @BoolJson() @JsonKey(name: 'is_available') this.isAvailable = true})
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

  /// `false` untuk barang yang ditandai penjual tidak tersedia dalam usulan
  /// kirim sebagian.
  @override
  @BoolJson()
  @JsonKey(name: 'is_available')
  final bool isAvailable;

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
                other.subtotal == subtotal) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
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
      subtotal,
      isAvailable);

  @override
  String toString() {
    return 'OrderItemModel(id: $id, productVariantId: $productVariantId, productName: $productName, variantOptions: $variantOptions, price: $price, quantity: $quantity, subtotal: $subtotal, isAvailable: $isAvailable)';
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
      @DoubleJson() double subtotal,
      @BoolJson() @JsonKey(name: 'is_available') bool isAvailable});
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
    Object? isAvailable = null,
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
      isAvailable: null == isAvailable
          ? _self.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
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
mixin _$OrderShippingAddress {
  @StringOrNullJson()
  @JsonKey(name: 'recipient_name')
  String? get recipientName;
  @StringOrNullJson()
  String? get phone;
  @StringOrNullJson()
  @JsonKey(name: 'full_address')
  String? get fullAddress;
  @StringOrNullJson()
  String? get city;
  @StringOrNullJson()
  String? get province;
  @StringOrNullJson()
  @JsonKey(name: 'postal_code')
  String? get postalCode;

  /// Create a copy of OrderShippingAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderShippingAddressCopyWith<OrderShippingAddress> get copyWith =>
      _$OrderShippingAddressCopyWithImpl<OrderShippingAddress>(
          this as OrderShippingAddress, _$identity);

  /// Serializes this OrderShippingAddress to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderShippingAddress &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recipientName, phone,
      fullAddress, city, province, postalCode);

  @override
  String toString() {
    return 'OrderShippingAddress(recipientName: $recipientName, phone: $phone, fullAddress: $fullAddress, city: $city, province: $province, postalCode: $postalCode)';
  }
}

/// @nodoc
abstract mixin class $OrderShippingAddressCopyWith<$Res> {
  factory $OrderShippingAddressCopyWith(OrderShippingAddress value,
          $Res Function(OrderShippingAddress) _then) =
      _$OrderShippingAddressCopyWithImpl;
  @useResult
  $Res call(
      {@StringOrNullJson()
      @JsonKey(name: 'recipient_name')
      String? recipientName,
      @StringOrNullJson() String? phone,
      @StringOrNullJson() @JsonKey(name: 'full_address') String? fullAddress,
      @StringOrNullJson() String? city,
      @StringOrNullJson() String? province,
      @StringOrNullJson() @JsonKey(name: 'postal_code') String? postalCode});
}

/// @nodoc
class _$OrderShippingAddressCopyWithImpl<$Res>
    implements $OrderShippingAddressCopyWith<$Res> {
  _$OrderShippingAddressCopyWithImpl(this._self, this._then);

  final OrderShippingAddress _self;
  final $Res Function(OrderShippingAddress) _then;

  /// Create a copy of OrderShippingAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientName = freezed,
    Object? phone = freezed,
    Object? fullAddress = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? postalCode = freezed,
  }) {
    return _then(_self.copyWith(
      recipientName: freezed == recipientName
          ? _self.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullAddress: freezed == fullAddress
          ? _self.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _self.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderShippingAddress].
extension OrderShippingAddressPatterns on OrderShippingAddress {
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
    TResult Function(_OrderShippingAddress value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderShippingAddress() when $default != null:
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
    TResult Function(_OrderShippingAddress value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderShippingAddress():
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
    TResult? Function(_OrderShippingAddress value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderShippingAddress() when $default != null:
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
            @StringOrNullJson()
            @JsonKey(name: 'recipient_name')
            String? recipientName,
            @StringOrNullJson() String? phone,
            @StringOrNullJson()
            @JsonKey(name: 'full_address')
            String? fullAddress,
            @StringOrNullJson() String? city,
            @StringOrNullJson() String? province,
            @StringOrNullJson()
            @JsonKey(name: 'postal_code')
            String? postalCode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderShippingAddress() when $default != null:
        return $default(_that.recipientName, _that.phone, _that.fullAddress,
            _that.city, _that.province, _that.postalCode);
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
            @StringOrNullJson()
            @JsonKey(name: 'recipient_name')
            String? recipientName,
            @StringOrNullJson() String? phone,
            @StringOrNullJson()
            @JsonKey(name: 'full_address')
            String? fullAddress,
            @StringOrNullJson() String? city,
            @StringOrNullJson() String? province,
            @StringOrNullJson()
            @JsonKey(name: 'postal_code')
            String? postalCode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderShippingAddress():
        return $default(_that.recipientName, _that.phone, _that.fullAddress,
            _that.city, _that.province, _that.postalCode);
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
            @StringOrNullJson()
            @JsonKey(name: 'recipient_name')
            String? recipientName,
            @StringOrNullJson() String? phone,
            @StringOrNullJson()
            @JsonKey(name: 'full_address')
            String? fullAddress,
            @StringOrNullJson() String? city,
            @StringOrNullJson() String? province,
            @StringOrNullJson()
            @JsonKey(name: 'postal_code')
            String? postalCode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderShippingAddress() when $default != null:
        return $default(_that.recipientName, _that.phone, _that.fullAddress,
            _that.city, _that.province, _that.postalCode);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderShippingAddress extends OrderShippingAddress {
  const _OrderShippingAddress(
      {@StringOrNullJson() @JsonKey(name: 'recipient_name') this.recipientName,
      @StringOrNullJson() this.phone,
      @StringOrNullJson() @JsonKey(name: 'full_address') this.fullAddress,
      @StringOrNullJson() this.city,
      @StringOrNullJson() this.province,
      @StringOrNullJson() @JsonKey(name: 'postal_code') this.postalCode})
      : super._();
  factory _OrderShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$OrderShippingAddressFromJson(json);

  @override
  @StringOrNullJson()
  @JsonKey(name: 'recipient_name')
  final String? recipientName;
  @override
  @StringOrNullJson()
  final String? phone;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'full_address')
  final String? fullAddress;
  @override
  @StringOrNullJson()
  final String? city;
  @override
  @StringOrNullJson()
  final String? province;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'postal_code')
  final String? postalCode;

  /// Create a copy of OrderShippingAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderShippingAddressCopyWith<_OrderShippingAddress> get copyWith =>
      __$OrderShippingAddressCopyWithImpl<_OrderShippingAddress>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderShippingAddressToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderShippingAddress &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recipientName, phone,
      fullAddress, city, province, postalCode);

  @override
  String toString() {
    return 'OrderShippingAddress(recipientName: $recipientName, phone: $phone, fullAddress: $fullAddress, city: $city, province: $province, postalCode: $postalCode)';
  }
}

/// @nodoc
abstract mixin class _$OrderShippingAddressCopyWith<$Res>
    implements $OrderShippingAddressCopyWith<$Res> {
  factory _$OrderShippingAddressCopyWith(_OrderShippingAddress value,
          $Res Function(_OrderShippingAddress) _then) =
      __$OrderShippingAddressCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringOrNullJson()
      @JsonKey(name: 'recipient_name')
      String? recipientName,
      @StringOrNullJson() String? phone,
      @StringOrNullJson() @JsonKey(name: 'full_address') String? fullAddress,
      @StringOrNullJson() String? city,
      @StringOrNullJson() String? province,
      @StringOrNullJson() @JsonKey(name: 'postal_code') String? postalCode});
}

/// @nodoc
class __$OrderShippingAddressCopyWithImpl<$Res>
    implements _$OrderShippingAddressCopyWith<$Res> {
  __$OrderShippingAddressCopyWithImpl(this._self, this._then);

  final _OrderShippingAddress _self;
  final $Res Function(_OrderShippingAddress) _then;

  /// Create a copy of OrderShippingAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? recipientName = freezed,
    Object? phone = freezed,
    Object? fullAddress = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? postalCode = freezed,
  }) {
    return _then(_OrderShippingAddress(
      recipientName: freezed == recipientName
          ? _self.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullAddress: freezed == fullAddress
          ? _self.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _self.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// @nodoc
mixin _$OrderTrackingModel {
  @StringJson()
  @JsonKey(name: 'courier_code')
  String get courierCode;
  @StringJson()
  @JsonKey(name: 'service_type')
  String get serviceType;
  @StringOrNullJson()
  @JsonKey(name: 'awb_number')
  String? get awbNumber;

  /// `drop_off` (diantar penjual) atau `pickup` (dijemput kurir).
  @StringOrNullJson()
  @JsonKey(name: 'handover_method')
  String? get handoverMethod;

  /// `pending`, `picked_up`, `in_transit`, `delivered`, `returned`, `lost`.
  @StringJson()
  String get status;
  @ServerDateTimeJson()
  @JsonKey(name: 'shipped_at')
  DateTime? get shippedAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt;

  /// Peristiwa perjalanan dari kurir, **terbaru dulu**. Kosong selama server
  /// belum menulisnya (lihat catatan kelas).
  ///
  /// Kolomnya bertipe `JSON`, dan driver MySQL PHP meneruskan kolom JSON
  /// sebagai **string** — pola yang sama dengan `selected_couriers` di sesi
  /// checkout — jadi [TrackingHistoryJson] menerima array maupun string.
  @TrackingHistoryJson()
  @JsonKey(name: 'tracking_history')
  List<TrackingEventModel> get trackingHistory;

  /// Create a copy of OrderTrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderTrackingModelCopyWith<OrderTrackingModel> get copyWith =>
      _$OrderTrackingModelCopyWithImpl<OrderTrackingModel>(
          this as OrderTrackingModel, _$identity);

  /// Serializes this OrderTrackingModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderTrackingModel &&
            (identical(other.courierCode, courierCode) ||
                other.courierCode == courierCode) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.awbNumber, awbNumber) ||
                other.awbNumber == awbNumber) &&
            (identical(other.handoverMethod, handoverMethod) ||
                other.handoverMethod == handoverMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.shippedAt, shippedAt) ||
                other.shippedAt == shippedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            const DeepCollectionEquality()
                .equals(other.trackingHistory, trackingHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      courierCode,
      serviceType,
      awbNumber,
      handoverMethod,
      status,
      shippedAt,
      deliveredAt,
      const DeepCollectionEquality().hash(trackingHistory));

  @override
  String toString() {
    return 'OrderTrackingModel(courierCode: $courierCode, serviceType: $serviceType, awbNumber: $awbNumber, handoverMethod: $handoverMethod, status: $status, shippedAt: $shippedAt, deliveredAt: $deliveredAt, trackingHistory: $trackingHistory)';
  }
}

/// @nodoc
abstract mixin class $OrderTrackingModelCopyWith<$Res> {
  factory $OrderTrackingModelCopyWith(
          OrderTrackingModel value, $Res Function(OrderTrackingModel) _then) =
      _$OrderTrackingModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'courier_code') String courierCode,
      @StringJson() @JsonKey(name: 'service_type') String serviceType,
      @StringOrNullJson() @JsonKey(name: 'awb_number') String? awbNumber,
      @StringOrNullJson()
      @JsonKey(name: 'handover_method')
      String? handoverMethod,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'shipped_at') DateTime? shippedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'delivered_at')
      DateTime? deliveredAt,
      @TrackingHistoryJson()
      @JsonKey(name: 'tracking_history')
      List<TrackingEventModel> trackingHistory});
}

/// @nodoc
class _$OrderTrackingModelCopyWithImpl<$Res>
    implements $OrderTrackingModelCopyWith<$Res> {
  _$OrderTrackingModelCopyWithImpl(this._self, this._then);

  final OrderTrackingModel _self;
  final $Res Function(OrderTrackingModel) _then;

  /// Create a copy of OrderTrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courierCode = null,
    Object? serviceType = null,
    Object? awbNumber = freezed,
    Object? handoverMethod = freezed,
    Object? status = null,
    Object? shippedAt = freezed,
    Object? deliveredAt = freezed,
    Object? trackingHistory = null,
  }) {
    return _then(_self.copyWith(
      courierCode: null == courierCode
          ? _self.courierCode
          : courierCode // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _self.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      awbNumber: freezed == awbNumber
          ? _self.awbNumber
          : awbNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      handoverMethod: freezed == handoverMethod
          ? _self.handoverMethod
          : handoverMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      shippedAt: freezed == shippedAt
          ? _self.shippedAt
          : shippedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _self.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trackingHistory: null == trackingHistory
          ? _self.trackingHistory
          : trackingHistory // ignore: cast_nullable_to_non_nullable
              as List<TrackingEventModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderTrackingModel].
extension OrderTrackingModelPatterns on OrderTrackingModel {
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
    TResult Function(_OrderTrackingModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderTrackingModel() when $default != null:
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
    TResult Function(_OrderTrackingModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderTrackingModel():
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
    TResult? Function(_OrderTrackingModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderTrackingModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'courier_code') String courierCode,
            @StringJson() @JsonKey(name: 'service_type') String serviceType,
            @StringOrNullJson() @JsonKey(name: 'awb_number') String? awbNumber,
            @StringOrNullJson()
            @JsonKey(name: 'handover_method')
            String? handoverMethod,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'shipped_at')
            DateTime? shippedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'delivered_at')
            DateTime? deliveredAt,
            @TrackingHistoryJson()
            @JsonKey(name: 'tracking_history')
            List<TrackingEventModel> trackingHistory)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderTrackingModel() when $default != null:
        return $default(
            _that.courierCode,
            _that.serviceType,
            _that.awbNumber,
            _that.handoverMethod,
            _that.status,
            _that.shippedAt,
            _that.deliveredAt,
            _that.trackingHistory);
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
            @StringJson() @JsonKey(name: 'courier_code') String courierCode,
            @StringJson() @JsonKey(name: 'service_type') String serviceType,
            @StringOrNullJson() @JsonKey(name: 'awb_number') String? awbNumber,
            @StringOrNullJson()
            @JsonKey(name: 'handover_method')
            String? handoverMethod,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'shipped_at')
            DateTime? shippedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'delivered_at')
            DateTime? deliveredAt,
            @TrackingHistoryJson()
            @JsonKey(name: 'tracking_history')
            List<TrackingEventModel> trackingHistory)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderTrackingModel():
        return $default(
            _that.courierCode,
            _that.serviceType,
            _that.awbNumber,
            _that.handoverMethod,
            _that.status,
            _that.shippedAt,
            _that.deliveredAt,
            _that.trackingHistory);
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
            @StringJson() @JsonKey(name: 'courier_code') String courierCode,
            @StringJson() @JsonKey(name: 'service_type') String serviceType,
            @StringOrNullJson() @JsonKey(name: 'awb_number') String? awbNumber,
            @StringOrNullJson()
            @JsonKey(name: 'handover_method')
            String? handoverMethod,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'shipped_at')
            DateTime? shippedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'delivered_at')
            DateTime? deliveredAt,
            @TrackingHistoryJson()
            @JsonKey(name: 'tracking_history')
            List<TrackingEventModel> trackingHistory)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderTrackingModel() when $default != null:
        return $default(
            _that.courierCode,
            _that.serviceType,
            _that.awbNumber,
            _that.handoverMethod,
            _that.status,
            _that.shippedAt,
            _that.deliveredAt,
            _that.trackingHistory);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderTrackingModel extends OrderTrackingModel {
  const _OrderTrackingModel(
      {@StringJson() @JsonKey(name: 'courier_code') this.courierCode = '',
      @StringJson() @JsonKey(name: 'service_type') this.serviceType = '',
      @StringOrNullJson() @JsonKey(name: 'awb_number') this.awbNumber,
      @StringOrNullJson() @JsonKey(name: 'handover_method') this.handoverMethod,
      @StringJson() this.status = 'pending',
      @ServerDateTimeJson() @JsonKey(name: 'shipped_at') this.shippedAt,
      @ServerDateTimeJson() @JsonKey(name: 'delivered_at') this.deliveredAt,
      @TrackingHistoryJson()
      @JsonKey(name: 'tracking_history')
      final List<TrackingEventModel> trackingHistory =
          const <TrackingEventModel>[]})
      : _trackingHistory = trackingHistory,
        super._();
  factory _OrderTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingModelFromJson(json);

  @override
  @StringJson()
  @JsonKey(name: 'courier_code')
  final String courierCode;
  @override
  @StringJson()
  @JsonKey(name: 'service_type')
  final String serviceType;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'awb_number')
  final String? awbNumber;

  /// `drop_off` (diantar penjual) atau `pickup` (dijemput kurir).
  @override
  @StringOrNullJson()
  @JsonKey(name: 'handover_method')
  final String? handoverMethod;

  /// `pending`, `picked_up`, `in_transit`, `delivered`, `returned`, `lost`.
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'shipped_at')
  final DateTime? shippedAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;

  /// Peristiwa perjalanan dari kurir, **terbaru dulu**. Kosong selama server
  /// belum menulisnya (lihat catatan kelas).
  ///
  /// Kolomnya bertipe `JSON`, dan driver MySQL PHP meneruskan kolom JSON
  /// sebagai **string** — pola yang sama dengan `selected_couriers` di sesi
  /// checkout — jadi [TrackingHistoryJson] menerima array maupun string.
  final List<TrackingEventModel> _trackingHistory;

  /// Peristiwa perjalanan dari kurir, **terbaru dulu**. Kosong selama server
  /// belum menulisnya (lihat catatan kelas).
  ///
  /// Kolomnya bertipe `JSON`, dan driver MySQL PHP meneruskan kolom JSON
  /// sebagai **string** — pola yang sama dengan `selected_couriers` di sesi
  /// checkout — jadi [TrackingHistoryJson] menerima array maupun string.
  @override
  @TrackingHistoryJson()
  @JsonKey(name: 'tracking_history')
  List<TrackingEventModel> get trackingHistory {
    if (_trackingHistory is EqualUnmodifiableListView) return _trackingHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trackingHistory);
  }

  /// Create a copy of OrderTrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderTrackingModelCopyWith<_OrderTrackingModel> get copyWith =>
      __$OrderTrackingModelCopyWithImpl<_OrderTrackingModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderTrackingModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderTrackingModel &&
            (identical(other.courierCode, courierCode) ||
                other.courierCode == courierCode) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.awbNumber, awbNumber) ||
                other.awbNumber == awbNumber) &&
            (identical(other.handoverMethod, handoverMethod) ||
                other.handoverMethod == handoverMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.shippedAt, shippedAt) ||
                other.shippedAt == shippedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            const DeepCollectionEquality()
                .equals(other._trackingHistory, _trackingHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      courierCode,
      serviceType,
      awbNumber,
      handoverMethod,
      status,
      shippedAt,
      deliveredAt,
      const DeepCollectionEquality().hash(_trackingHistory));

  @override
  String toString() {
    return 'OrderTrackingModel(courierCode: $courierCode, serviceType: $serviceType, awbNumber: $awbNumber, handoverMethod: $handoverMethod, status: $status, shippedAt: $shippedAt, deliveredAt: $deliveredAt, trackingHistory: $trackingHistory)';
  }
}

/// @nodoc
abstract mixin class _$OrderTrackingModelCopyWith<$Res>
    implements $OrderTrackingModelCopyWith<$Res> {
  factory _$OrderTrackingModelCopyWith(
          _OrderTrackingModel value, $Res Function(_OrderTrackingModel) _then) =
      __$OrderTrackingModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'courier_code') String courierCode,
      @StringJson() @JsonKey(name: 'service_type') String serviceType,
      @StringOrNullJson() @JsonKey(name: 'awb_number') String? awbNumber,
      @StringOrNullJson()
      @JsonKey(name: 'handover_method')
      String? handoverMethod,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'shipped_at') DateTime? shippedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'delivered_at')
      DateTime? deliveredAt,
      @TrackingHistoryJson()
      @JsonKey(name: 'tracking_history')
      List<TrackingEventModel> trackingHistory});
}

/// @nodoc
class __$OrderTrackingModelCopyWithImpl<$Res>
    implements _$OrderTrackingModelCopyWith<$Res> {
  __$OrderTrackingModelCopyWithImpl(this._self, this._then);

  final _OrderTrackingModel _self;
  final $Res Function(_OrderTrackingModel) _then;

  /// Create a copy of OrderTrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? courierCode = null,
    Object? serviceType = null,
    Object? awbNumber = freezed,
    Object? handoverMethod = freezed,
    Object? status = null,
    Object? shippedAt = freezed,
    Object? deliveredAt = freezed,
    Object? trackingHistory = null,
  }) {
    return _then(_OrderTrackingModel(
      courierCode: null == courierCode
          ? _self.courierCode
          : courierCode // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _self.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      awbNumber: freezed == awbNumber
          ? _self.awbNumber
          : awbNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      handoverMethod: freezed == handoverMethod
          ? _self.handoverMethod
          : handoverMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      shippedAt: freezed == shippedAt
          ? _self.shippedAt
          : shippedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _self.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trackingHistory: null == trackingHistory
          ? _self._trackingHistory
          : trackingHistory // ignore: cast_nullable_to_non_nullable
              as List<TrackingEventModel>,
    ));
  }
}

/// @nodoc
mixin _$TrackingEventModel {
  /// Status pengiriman **saat peristiwa itu**, memakai ENUM yang sama
  /// dengan `order_shipments.status` (`picked_up`, `in_transit`,
  /// `delivered`, `returned`, `lost`) supaya tidak ada kosakata kedua.
  @StringJson()
  String get status;
  @StringJson()
  String get description;
  @StringOrNullJson()
  String? get location;
  @ServerDateTimeJson()
  @JsonKey(name: 'occurred_at')
  DateTime? get occurredAt;

  /// Create a copy of TrackingEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrackingEventModelCopyWith<TrackingEventModel> get copyWith =>
      _$TrackingEventModelCopyWithImpl<TrackingEventModel>(
          this as TrackingEventModel, _$identity);

  /// Serializes this TrackingEventModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TrackingEventModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, description, location, occurredAt);

  @override
  String toString() {
    return 'TrackingEventModel(status: $status, description: $description, location: $location, occurredAt: $occurredAt)';
  }
}

/// @nodoc
abstract mixin class $TrackingEventModelCopyWith<$Res> {
  factory $TrackingEventModelCopyWith(
          TrackingEventModel value, $Res Function(TrackingEventModel) _then) =
      _$TrackingEventModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() String status,
      @StringJson() String description,
      @StringOrNullJson() String? location,
      @ServerDateTimeJson()
      @JsonKey(name: 'occurred_at')
      DateTime? occurredAt});
}

/// @nodoc
class _$TrackingEventModelCopyWithImpl<$Res>
    implements $TrackingEventModelCopyWith<$Res> {
  _$TrackingEventModelCopyWithImpl(this._self, this._then);

  final TrackingEventModel _self;
  final $Res Function(TrackingEventModel) _then;

  /// Create a copy of TrackingEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? description = null,
    Object? location = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      occurredAt: freezed == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TrackingEventModel].
extension TrackingEventModelPatterns on TrackingEventModel {
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
    TResult Function(_TrackingEventModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackingEventModel() when $default != null:
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
    TResult Function(_TrackingEventModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackingEventModel():
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
    TResult? Function(_TrackingEventModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackingEventModel() when $default != null:
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
            @StringJson() String status,
            @StringJson() String description,
            @StringOrNullJson() String? location,
            @ServerDateTimeJson()
            @JsonKey(name: 'occurred_at')
            DateTime? occurredAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TrackingEventModel() when $default != null:
        return $default(
            _that.status, _that.description, _that.location, _that.occurredAt);
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
            @StringJson() String status,
            @StringJson() String description,
            @StringOrNullJson() String? location,
            @ServerDateTimeJson()
            @JsonKey(name: 'occurred_at')
            DateTime? occurredAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackingEventModel():
        return $default(
            _that.status, _that.description, _that.location, _that.occurredAt);
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
            @StringJson() String status,
            @StringJson() String description,
            @StringOrNullJson() String? location,
            @ServerDateTimeJson()
            @JsonKey(name: 'occurred_at')
            DateTime? occurredAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TrackingEventModel() when $default != null:
        return $default(
            _that.status, _that.description, _that.location, _that.occurredAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TrackingEventModel extends TrackingEventModel {
  const _TrackingEventModel(
      {@StringJson() this.status = 'in_transit',
      @StringJson() this.description = '',
      @StringOrNullJson() this.location,
      @ServerDateTimeJson() @JsonKey(name: 'occurred_at') this.occurredAt})
      : super._();
  factory _TrackingEventModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingEventModelFromJson(json);

  /// Status pengiriman **saat peristiwa itu**, memakai ENUM yang sama
  /// dengan `order_shipments.status` (`picked_up`, `in_transit`,
  /// `delivered`, `returned`, `lost`) supaya tidak ada kosakata kedua.
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @JsonKey()
  @StringJson()
  final String description;
  @override
  @StringOrNullJson()
  final String? location;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'occurred_at')
  final DateTime? occurredAt;

  /// Create a copy of TrackingEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrackingEventModelCopyWith<_TrackingEventModel> get copyWith =>
      __$TrackingEventModelCopyWithImpl<_TrackingEventModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrackingEventModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackingEventModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, description, location, occurredAt);

  @override
  String toString() {
    return 'TrackingEventModel(status: $status, description: $description, location: $location, occurredAt: $occurredAt)';
  }
}

/// @nodoc
abstract mixin class _$TrackingEventModelCopyWith<$Res>
    implements $TrackingEventModelCopyWith<$Res> {
  factory _$TrackingEventModelCopyWith(
          _TrackingEventModel value, $Res Function(_TrackingEventModel) _then) =
      __$TrackingEventModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() String status,
      @StringJson() String description,
      @StringOrNullJson() String? location,
      @ServerDateTimeJson()
      @JsonKey(name: 'occurred_at')
      DateTime? occurredAt});
}

/// @nodoc
class __$TrackingEventModelCopyWithImpl<$Res>
    implements _$TrackingEventModelCopyWith<$Res> {
  __$TrackingEventModelCopyWithImpl(this._self, this._then);

  final _TrackingEventModel _self;
  final $Res Function(_TrackingEventModel) _then;

  /// Create a copy of TrackingEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? description = null,
    Object? location = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(_TrackingEventModel(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      occurredAt: freezed == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$ShipmentEvidenceModel {
  @IntJson()
  int get id;

  /// `photo` / `video`.
  @StringJson()
  @JsonKey(name: 'media_type')
  String get mediaType;
  @StringJson()
  String get url;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of ShipmentEvidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShipmentEvidenceModelCopyWith<ShipmentEvidenceModel> get copyWith =>
      _$ShipmentEvidenceModelCopyWithImpl<ShipmentEvidenceModel>(
          this as ShipmentEvidenceModel, _$identity);

  /// Serializes this ShipmentEvidenceModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShipmentEvidenceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, mediaType, url, createdAt);

  @override
  String toString() {
    return 'ShipmentEvidenceModel(id: $id, mediaType: $mediaType, url: $url, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ShipmentEvidenceModelCopyWith<$Res> {
  factory $ShipmentEvidenceModelCopyWith(ShipmentEvidenceModel value,
          $Res Function(ShipmentEvidenceModel) _then) =
      _$ShipmentEvidenceModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'media_type') String mediaType,
      @StringJson() String url,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$ShipmentEvidenceModelCopyWithImpl<$Res>
    implements $ShipmentEvidenceModelCopyWith<$Res> {
  _$ShipmentEvidenceModelCopyWithImpl(this._self, this._then);

  final ShipmentEvidenceModel _self;
  final $Res Function(ShipmentEvidenceModel) _then;

  /// Create a copy of ShipmentEvidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaType = null,
    Object? url = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaType: null == mediaType
          ? _self.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShipmentEvidenceModel].
extension ShipmentEvidenceModelPatterns on ShipmentEvidenceModel {
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
    TResult Function(_ShipmentEvidenceModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShipmentEvidenceModel() when $default != null:
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
    TResult Function(_ShipmentEvidenceModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShipmentEvidenceModel():
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
    TResult? Function(_ShipmentEvidenceModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShipmentEvidenceModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'media_type') String mediaType,
            @StringJson() String url,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShipmentEvidenceModel() when $default != null:
        return $default(_that.id, _that.mediaType, _that.url, _that.createdAt);
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
            @StringJson() @JsonKey(name: 'media_type') String mediaType,
            @StringJson() String url,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShipmentEvidenceModel():
        return $default(_that.id, _that.mediaType, _that.url, _that.createdAt);
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
            @StringJson() @JsonKey(name: 'media_type') String mediaType,
            @StringJson() String url,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShipmentEvidenceModel() when $default != null:
        return $default(_that.id, _that.mediaType, _that.url, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ShipmentEvidenceModel extends ShipmentEvidenceModel {
  const _ShipmentEvidenceModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'media_type') this.mediaType = 'photo',
      @StringJson() this.url = '',
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _ShipmentEvidenceModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentEvidenceModelFromJson(json);

  @override
  @IntJson()
  final int id;

  /// `photo` / `video`.
  @override
  @StringJson()
  @JsonKey(name: 'media_type')
  final String mediaType;
  @override
  @JsonKey()
  @StringJson()
  final String url;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of ShipmentEvidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShipmentEvidenceModelCopyWith<_ShipmentEvidenceModel> get copyWith =>
      __$ShipmentEvidenceModelCopyWithImpl<_ShipmentEvidenceModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShipmentEvidenceModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShipmentEvidenceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, mediaType, url, createdAt);

  @override
  String toString() {
    return 'ShipmentEvidenceModel(id: $id, mediaType: $mediaType, url: $url, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ShipmentEvidenceModelCopyWith<$Res>
    implements $ShipmentEvidenceModelCopyWith<$Res> {
  factory _$ShipmentEvidenceModelCopyWith(_ShipmentEvidenceModel value,
          $Res Function(_ShipmentEvidenceModel) _then) =
      __$ShipmentEvidenceModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'media_type') String mediaType,
      @StringJson() String url,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$ShipmentEvidenceModelCopyWithImpl<$Res>
    implements _$ShipmentEvidenceModelCopyWith<$Res> {
  __$ShipmentEvidenceModelCopyWithImpl(this._self, this._then);

  final _ShipmentEvidenceModel _self;
  final $Res Function(_ShipmentEvidenceModel) _then;

  /// Create a copy of ShipmentEvidenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? mediaType = null,
    Object? url = null,
    Object? createdAt = freezed,
  }) {
    return _then(_ShipmentEvidenceModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaType: null == mediaType
          ? _self.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$OrderInvoiceModel {
  @StringJson()
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @ServerDateTimeJson()
  @JsonKey(name: 'generated_at')
  DateTime? get generatedAt;
  @StringJson()
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @ServerDateTimeJson()
  @JsonKey(name: 'order_date')
  DateTime? get orderDate;
  @JsonKey(name: 'store')
  InvoiceStoreModel? get store;
  @JsonKey(name: 'shipping_address')
  OrderShippingAddress? get shippingAddress;
  List<OrderItemModel> get items;
  @DoubleJson()
  double get subtotal;
  @DoubleJson()
  @JsonKey(name: 'shipping_cost')
  double get shippingCost;
  @DoubleJson()
  @JsonKey(name: 'discount_total')
  double get discountTotal;
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  double get grandTotal;

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderInvoiceModelCopyWith<OrderInvoiceModel> get copyWith =>
      _$OrderInvoiceModelCopyWithImpl<OrderInvoiceModel>(
          this as OrderInvoiceModel, _$identity);

  /// Serializes this OrderInvoiceModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderInvoiceModel &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.discountTotal, discountTotal) ||
                other.discountTotal == discountTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      invoiceNumber,
      generatedAt,
      orderNumber,
      orderDate,
      store,
      shippingAddress,
      const DeepCollectionEquality().hash(items),
      subtotal,
      shippingCost,
      discountTotal,
      grandTotal);

  @override
  String toString() {
    return 'OrderInvoiceModel(invoiceNumber: $invoiceNumber, generatedAt: $generatedAt, orderNumber: $orderNumber, orderDate: $orderDate, store: $store, shippingAddress: $shippingAddress, items: $items, subtotal: $subtotal, shippingCost: $shippingCost, discountTotal: $discountTotal, grandTotal: $grandTotal)';
  }
}

/// @nodoc
abstract mixin class $OrderInvoiceModelCopyWith<$Res> {
  factory $OrderInvoiceModelCopyWith(
          OrderInvoiceModel value, $Res Function(OrderInvoiceModel) _then) =
      _$OrderInvoiceModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'invoice_number') String invoiceNumber,
      @ServerDateTimeJson()
      @JsonKey(name: 'generated_at')
      DateTime? generatedAt,
      @StringJson() @JsonKey(name: 'order_number') String orderNumber,
      @ServerDateTimeJson() @JsonKey(name: 'order_date') DateTime? orderDate,
      @JsonKey(name: 'store') InvoiceStoreModel? store,
      @JsonKey(name: 'shipping_address') OrderShippingAddress? shippingAddress,
      List<OrderItemModel> items,
      @DoubleJson() double subtotal,
      @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
      @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal});

  $InvoiceStoreModelCopyWith<$Res>? get store;
  $OrderShippingAddressCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class _$OrderInvoiceModelCopyWithImpl<$Res>
    implements $OrderInvoiceModelCopyWith<$Res> {
  _$OrderInvoiceModelCopyWithImpl(this._self, this._then);

  final OrderInvoiceModel _self;
  final $Res Function(OrderInvoiceModel) _then;

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceNumber = null,
    Object? generatedAt = freezed,
    Object? orderNumber = null,
    Object? orderDate = freezed,
    Object? store = freezed,
    Object? shippingAddress = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discountTotal = null,
    Object? grandTotal = null,
  }) {
    return _then(_self.copyWith(
      invoiceNumber: null == invoiceNumber
          ? _self.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: freezed == generatedAt
          ? _self.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: freezed == orderDate
          ? _self.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      store: freezed == store
          ? _self.store
          : store // ignore: cast_nullable_to_non_nullable
              as InvoiceStoreModel?,
      shippingAddress: freezed == shippingAddress
          ? _self.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as OrderShippingAddress?,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
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
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InvoiceStoreModelCopyWith<$Res>? get store {
    if (_self.store == null) {
      return null;
    }

    return $InvoiceStoreModelCopyWith<$Res>(_self.store!, (value) {
      return _then(_self.copyWith(store: value));
    });
  }

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderShippingAddressCopyWith<$Res>? get shippingAddress {
    if (_self.shippingAddress == null) {
      return null;
    }

    return $OrderShippingAddressCopyWith<$Res>(_self.shippingAddress!, (value) {
      return _then(_self.copyWith(shippingAddress: value));
    });
  }
}

/// Adds pattern-matching-related methods to [OrderInvoiceModel].
extension OrderInvoiceModelPatterns on OrderInvoiceModel {
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
    TResult Function(_OrderInvoiceModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderInvoiceModel() when $default != null:
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
    TResult Function(_OrderInvoiceModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderInvoiceModel():
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
    TResult? Function(_OrderInvoiceModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderInvoiceModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'invoice_number') String invoiceNumber,
            @ServerDateTimeJson()
            @JsonKey(name: 'generated_at')
            DateTime? generatedAt,
            @StringJson() @JsonKey(name: 'order_number') String orderNumber,
            @ServerDateTimeJson()
            @JsonKey(name: 'order_date')
            DateTime? orderDate,
            @JsonKey(name: 'store') InvoiceStoreModel? store,
            @JsonKey(name: 'shipping_address')
            OrderShippingAddress? shippingAddress,
            List<OrderItemModel> items,
            @DoubleJson() double subtotal,
            @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
            @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderInvoiceModel() when $default != null:
        return $default(
            _that.invoiceNumber,
            _that.generatedAt,
            _that.orderNumber,
            _that.orderDate,
            _that.store,
            _that.shippingAddress,
            _that.items,
            _that.subtotal,
            _that.shippingCost,
            _that.discountTotal,
            _that.grandTotal);
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
            @StringJson() @JsonKey(name: 'invoice_number') String invoiceNumber,
            @ServerDateTimeJson()
            @JsonKey(name: 'generated_at')
            DateTime? generatedAt,
            @StringJson() @JsonKey(name: 'order_number') String orderNumber,
            @ServerDateTimeJson()
            @JsonKey(name: 'order_date')
            DateTime? orderDate,
            @JsonKey(name: 'store') InvoiceStoreModel? store,
            @JsonKey(name: 'shipping_address')
            OrderShippingAddress? shippingAddress,
            List<OrderItemModel> items,
            @DoubleJson() double subtotal,
            @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
            @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderInvoiceModel():
        return $default(
            _that.invoiceNumber,
            _that.generatedAt,
            _that.orderNumber,
            _that.orderDate,
            _that.store,
            _that.shippingAddress,
            _that.items,
            _that.subtotal,
            _that.shippingCost,
            _that.discountTotal,
            _that.grandTotal);
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
            @StringJson() @JsonKey(name: 'invoice_number') String invoiceNumber,
            @ServerDateTimeJson()
            @JsonKey(name: 'generated_at')
            DateTime? generatedAt,
            @StringJson() @JsonKey(name: 'order_number') String orderNumber,
            @ServerDateTimeJson()
            @JsonKey(name: 'order_date')
            DateTime? orderDate,
            @JsonKey(name: 'store') InvoiceStoreModel? store,
            @JsonKey(name: 'shipping_address')
            OrderShippingAddress? shippingAddress,
            List<OrderItemModel> items,
            @DoubleJson() double subtotal,
            @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
            @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderInvoiceModel() when $default != null:
        return $default(
            _that.invoiceNumber,
            _that.generatedAt,
            _that.orderNumber,
            _that.orderDate,
            _that.store,
            _that.shippingAddress,
            _that.items,
            _that.subtotal,
            _that.shippingCost,
            _that.discountTotal,
            _that.grandTotal);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OrderInvoiceModel implements OrderInvoiceModel {
  const _OrderInvoiceModel(
      {@StringJson() @JsonKey(name: 'invoice_number') this.invoiceNumber = '',
      @ServerDateTimeJson() @JsonKey(name: 'generated_at') this.generatedAt,
      @StringJson() @JsonKey(name: 'order_number') this.orderNumber = '',
      @ServerDateTimeJson() @JsonKey(name: 'order_date') this.orderDate,
      @JsonKey(name: 'store') this.store,
      @JsonKey(name: 'shipping_address') this.shippingAddress,
      final List<OrderItemModel> items = const <OrderItemModel>[],
      @DoubleJson() this.subtotal = 0,
      @DoubleJson() @JsonKey(name: 'shipping_cost') this.shippingCost = 0,
      @DoubleJson() @JsonKey(name: 'discount_total') this.discountTotal = 0,
      @DoubleJson() @JsonKey(name: 'grand_total') this.grandTotal = 0})
      : _items = items;
  factory _OrderInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$OrderInvoiceModelFromJson(json);

  @override
  @StringJson()
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'generated_at')
  final DateTime? generatedAt;
  @override
  @StringJson()
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'order_date')
  final DateTime? orderDate;
  @override
  @JsonKey(name: 'store')
  final InvoiceStoreModel? store;
  @override
  @JsonKey(name: 'shipping_address')
  final OrderShippingAddress? shippingAddress;
  final List<OrderItemModel> _items;
  @override
  @JsonKey()
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

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
  @JsonKey(name: 'grand_total')
  final double grandTotal;

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderInvoiceModelCopyWith<_OrderInvoiceModel> get copyWith =>
      __$OrderInvoiceModelCopyWithImpl<_OrderInvoiceModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderInvoiceModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderInvoiceModel &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.discountTotal, discountTotal) ||
                other.discountTotal == discountTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      invoiceNumber,
      generatedAt,
      orderNumber,
      orderDate,
      store,
      shippingAddress,
      const DeepCollectionEquality().hash(_items),
      subtotal,
      shippingCost,
      discountTotal,
      grandTotal);

  @override
  String toString() {
    return 'OrderInvoiceModel(invoiceNumber: $invoiceNumber, generatedAt: $generatedAt, orderNumber: $orderNumber, orderDate: $orderDate, store: $store, shippingAddress: $shippingAddress, items: $items, subtotal: $subtotal, shippingCost: $shippingCost, discountTotal: $discountTotal, grandTotal: $grandTotal)';
  }
}

/// @nodoc
abstract mixin class _$OrderInvoiceModelCopyWith<$Res>
    implements $OrderInvoiceModelCopyWith<$Res> {
  factory _$OrderInvoiceModelCopyWith(
          _OrderInvoiceModel value, $Res Function(_OrderInvoiceModel) _then) =
      __$OrderInvoiceModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'invoice_number') String invoiceNumber,
      @ServerDateTimeJson()
      @JsonKey(name: 'generated_at')
      DateTime? generatedAt,
      @StringJson() @JsonKey(name: 'order_number') String orderNumber,
      @ServerDateTimeJson() @JsonKey(name: 'order_date') DateTime? orderDate,
      @JsonKey(name: 'store') InvoiceStoreModel? store,
      @JsonKey(name: 'shipping_address') OrderShippingAddress? shippingAddress,
      List<OrderItemModel> items,
      @DoubleJson() double subtotal,
      @DoubleJson() @JsonKey(name: 'shipping_cost') double shippingCost,
      @DoubleJson() @JsonKey(name: 'discount_total') double discountTotal,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal});

  @override
  $InvoiceStoreModelCopyWith<$Res>? get store;
  @override
  $OrderShippingAddressCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class __$OrderInvoiceModelCopyWithImpl<$Res>
    implements _$OrderInvoiceModelCopyWith<$Res> {
  __$OrderInvoiceModelCopyWithImpl(this._self, this._then);

  final _OrderInvoiceModel _self;
  final $Res Function(_OrderInvoiceModel) _then;

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? invoiceNumber = null,
    Object? generatedAt = freezed,
    Object? orderNumber = null,
    Object? orderDate = freezed,
    Object? store = freezed,
    Object? shippingAddress = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discountTotal = null,
    Object? grandTotal = null,
  }) {
    return _then(_OrderInvoiceModel(
      invoiceNumber: null == invoiceNumber
          ? _self.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: freezed == generatedAt
          ? _self.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: freezed == orderDate
          ? _self.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      store: freezed == store
          ? _self.store
          : store // ignore: cast_nullable_to_non_nullable
              as InvoiceStoreModel?,
      shippingAddress: freezed == shippingAddress
          ? _self.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as OrderShippingAddress?,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
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
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InvoiceStoreModelCopyWith<$Res>? get store {
    if (_self.store == null) {
      return null;
    }

    return $InvoiceStoreModelCopyWith<$Res>(_self.store!, (value) {
      return _then(_self.copyWith(store: value));
    });
  }

  /// Create a copy of OrderInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderShippingAddressCopyWith<$Res>? get shippingAddress {
    if (_self.shippingAddress == null) {
      return null;
    }

    return $OrderShippingAddressCopyWith<$Res>(_self.shippingAddress!, (value) {
      return _then(_self.copyWith(shippingAddress: value));
    });
  }
}

/// @nodoc
mixin _$InvoiceStoreModel {
  @IntJson()
  int get id;
  @StringJson()
  String get name;

  /// Create a copy of InvoiceStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InvoiceStoreModelCopyWith<InvoiceStoreModel> get copyWith =>
      _$InvoiceStoreModelCopyWithImpl<InvoiceStoreModel>(
          this as InvoiceStoreModel, _$identity);

  /// Serializes this InvoiceStoreModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InvoiceStoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'InvoiceStoreModel(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $InvoiceStoreModelCopyWith<$Res> {
  factory $InvoiceStoreModelCopyWith(
          InvoiceStoreModel value, $Res Function(InvoiceStoreModel) _then) =
      _$InvoiceStoreModelCopyWithImpl;
  @useResult
  $Res call({@IntJson() int id, @StringJson() String name});
}

/// @nodoc
class _$InvoiceStoreModelCopyWithImpl<$Res>
    implements $InvoiceStoreModelCopyWith<$Res> {
  _$InvoiceStoreModelCopyWithImpl(this._self, this._then);

  final InvoiceStoreModel _self;
  final $Res Function(InvoiceStoreModel) _then;

  /// Create a copy of InvoiceStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [InvoiceStoreModel].
extension InvoiceStoreModelPatterns on InvoiceStoreModel {
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
    TResult Function(_InvoiceStoreModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceStoreModel() when $default != null:
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
    TResult Function(_InvoiceStoreModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceStoreModel():
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
    TResult? Function(_InvoiceStoreModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceStoreModel() when $default != null:
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
    TResult Function(@IntJson() int id, @StringJson() String name)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceStoreModel() when $default != null:
        return $default(_that.id, _that.name);
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
    TResult Function(@IntJson() int id, @StringJson() String name) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceStoreModel():
        return $default(_that.id, _that.name);
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
    TResult? Function(@IntJson() int id, @StringJson() String name)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceStoreModel() when $default != null:
        return $default(_that.id, _that.name);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InvoiceStoreModel implements InvoiceStoreModel {
  const _InvoiceStoreModel(
      {@IntJson() this.id = 0, @StringJson() this.name = ''});
  factory _InvoiceStoreModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceStoreModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int id;
  @override
  @JsonKey()
  @StringJson()
  final String name;

  /// Create a copy of InvoiceStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InvoiceStoreModelCopyWith<_InvoiceStoreModel> get copyWith =>
      __$InvoiceStoreModelCopyWithImpl<_InvoiceStoreModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InvoiceStoreModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InvoiceStoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'InvoiceStoreModel(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$InvoiceStoreModelCopyWith<$Res>
    implements $InvoiceStoreModelCopyWith<$Res> {
  factory _$InvoiceStoreModelCopyWith(
          _InvoiceStoreModel value, $Res Function(_InvoiceStoreModel) _then) =
      __$InvoiceStoreModelCopyWithImpl;
  @override
  @useResult
  $Res call({@IntJson() int id, @StringJson() String name});
}

/// @nodoc
class __$InvoiceStoreModelCopyWithImpl<$Res>
    implements _$InvoiceStoreModelCopyWith<$Res> {
  __$InvoiceStoreModelCopyWithImpl(this._self, this._then);

  final _InvoiceStoreModel _self;
  final $Res Function(_InvoiceStoreModel) _then;

  /// Create a copy of InvoiceStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_InvoiceStoreModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
