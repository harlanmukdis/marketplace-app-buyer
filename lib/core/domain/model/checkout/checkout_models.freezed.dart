// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckoutSessionCreated {
  @StringJson()
  String get id;
  @DoubleJson()
  double get subtotal;
  @DoubleJson()
  double get discount;
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  double get grandTotal;
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;

  /// Create a copy of CheckoutSessionCreated
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutSessionCreatedCopyWith<CheckoutSessionCreated> get copyWith =>
      _$CheckoutSessionCreatedCopyWithImpl<CheckoutSessionCreated>(
          this as CheckoutSessionCreated, _$identity);

  /// Serializes this CheckoutSessionCreated to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutSessionCreated &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, subtotal, discount, grandTotal, expiresAt);

  @override
  String toString() {
    return 'CheckoutSessionCreated(id: $id, subtotal: $subtotal, discount: $discount, grandTotal: $grandTotal, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class $CheckoutSessionCreatedCopyWith<$Res> {
  factory $CheckoutSessionCreatedCopyWith(CheckoutSessionCreated value,
          $Res Function(CheckoutSessionCreated) _then) =
      _$CheckoutSessionCreatedCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() String id,
      @DoubleJson() double subtotal,
      @DoubleJson() double discount,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
      @ServerUtcDateTimeJson()
      @JsonKey(name: 'expires_at')
      DateTime? expiresAt});
}

/// @nodoc
class _$CheckoutSessionCreatedCopyWithImpl<$Res>
    implements $CheckoutSessionCreatedCopyWith<$Res> {
  _$CheckoutSessionCreatedCopyWithImpl(this._self, this._then);

  final CheckoutSessionCreated _self;
  final $Res Function(CheckoutSessionCreated) _then;

  /// Create a copy of CheckoutSessionCreated
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? grandTotal = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CheckoutSessionCreated].
extension CheckoutSessionCreatedPatterns on CheckoutSessionCreated {
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
    TResult Function(_CheckoutSessionCreated value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionCreated() when $default != null:
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
    TResult Function(_CheckoutSessionCreated value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionCreated():
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
    TResult? Function(_CheckoutSessionCreated value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionCreated() when $default != null:
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
            @StringJson() String id,
            @DoubleJson() double subtotal,
            @DoubleJson() double discount,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionCreated() when $default != null:
        return $default(_that.id, _that.subtotal, _that.discount,
            _that.grandTotal, _that.expiresAt);
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
            @StringJson() String id,
            @DoubleJson() double subtotal,
            @DoubleJson() double discount,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionCreated():
        return $default(_that.id, _that.subtotal, _that.discount,
            _that.grandTotal, _that.expiresAt);
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
            @StringJson() String id,
            @DoubleJson() double subtotal,
            @DoubleJson() double discount,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionCreated() when $default != null:
        return $default(_that.id, _that.subtotal, _that.discount,
            _that.grandTotal, _that.expiresAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CheckoutSessionCreated extends CheckoutSessionCreated {
  const _CheckoutSessionCreated(
      {@StringJson() this.id = '',
      @DoubleJson() this.subtotal = 0,
      @DoubleJson() this.discount = 0,
      @DoubleJson() @JsonKey(name: 'grand_total') this.grandTotal = 0,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expires_at') this.expiresAt})
      : super._();
  factory _CheckoutSessionCreated.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionCreatedFromJson(json);

  @override
  @JsonKey()
  @StringJson()
  final String id;
  @override
  @JsonKey()
  @DoubleJson()
  final double subtotal;
  @override
  @JsonKey()
  @DoubleJson()
  final double discount;
  @override
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  final double grandTotal;
  @override
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  /// Create a copy of CheckoutSessionCreated
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CheckoutSessionCreatedCopyWith<_CheckoutSessionCreated> get copyWith =>
      __$CheckoutSessionCreatedCopyWithImpl<_CheckoutSessionCreated>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CheckoutSessionCreatedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CheckoutSessionCreated &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, subtotal, discount, grandTotal, expiresAt);

  @override
  String toString() {
    return 'CheckoutSessionCreated(id: $id, subtotal: $subtotal, discount: $discount, grandTotal: $grandTotal, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class _$CheckoutSessionCreatedCopyWith<$Res>
    implements $CheckoutSessionCreatedCopyWith<$Res> {
  factory _$CheckoutSessionCreatedCopyWith(_CheckoutSessionCreated value,
          $Res Function(_CheckoutSessionCreated) _then) =
      __$CheckoutSessionCreatedCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() String id,
      @DoubleJson() double subtotal,
      @DoubleJson() double discount,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
      @ServerUtcDateTimeJson()
      @JsonKey(name: 'expires_at')
      DateTime? expiresAt});
}

/// @nodoc
class __$CheckoutSessionCreatedCopyWithImpl<$Res>
    implements _$CheckoutSessionCreatedCopyWith<$Res> {
  __$CheckoutSessionCreatedCopyWithImpl(this._self, this._then);

  final _CheckoutSessionCreated _self;
  final $Res Function(_CheckoutSessionCreated) _then;

  /// Create a copy of CheckoutSessionCreated
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? grandTotal = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_CheckoutSessionCreated(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$CheckoutSessionModel {
  @StringJson()
  String get id;

  /// `stock_reserved` → `awaiting_payment` sesudah konfirmasi.
  /// Sesi yang dibatalkan berstatus **`expired`**, bukan `cancelled`.
  @StringJson()
  String get status;

  /// ⚠️ Dikirim sebagai **string berisi JSON**, bukan array bersarang.
  /// Dipakai [snapshotItems] untuk membacanya.
  @StringOrNullJson()
  @JsonKey(name: 'cart_snapshot')
  String? get cartSnapshot;
  @IntOrNullJson()
  @JsonKey(name: 'shipping_address_id')
  int? get shippingAddressId;

  /// `null` sebelum kurir dipilih; sesudahnya map berkunci `store_id`.
  ///
  /// ⚠️ **Dikirim sebagai string berisi JSON**, bukan objek — sama seperti
  /// [cartSnapshot]. Ini menyesatkan karena balasan
  /// `PATCH /checkout/sessions/{id}/shipping` mengirim field bernama sama
  /// sebagai objek sungguhan; yang *tersimpan di sesi* berupa string.
  /// Tanpa [JsonMapJson], `GET /checkout/sessions/{id}` melempar
  /// `type 'String' is not a subtype of type 'Map<String, dynamic>?'`
  /// begitu kurir dipilih — persis di tengah alur checkout.
  @JsonMapJson()
  @JsonKey(name: 'selected_couriers')
  Map<String, dynamic>? get selectedCouriers;

  /// Sama seperti [selectedCouriers]: string berisi JSON, bukan objek.
  @JsonMapJson()
  @JsonKey(name: 'applied_vouchers')
  Map<String, dynamic>? get appliedVouchers;

  /// String berdesimal di endpoint ini (`"3049000.00"`), angka di
  /// `POST /checkout/sessions`.
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  double get grandTotal;

  /// **UTC** — lihat [ServerUtcDateTimeJson].
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;

  /// **Waktu dinding server (WIB)** — konverter berbeda dari [expiresAt],
  /// dan itu memang disengaja.
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of CheckoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutSessionModelCopyWith<CheckoutSessionModel> get copyWith =>
      _$CheckoutSessionModelCopyWithImpl<CheckoutSessionModel>(
          this as CheckoutSessionModel, _$identity);

  /// Serializes this CheckoutSessionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.cartSnapshot, cartSnapshot) ||
                other.cartSnapshot == cartSnapshot) &&
            (identical(other.shippingAddressId, shippingAddressId) ||
                other.shippingAddressId == shippingAddressId) &&
            const DeepCollectionEquality()
                .equals(other.selectedCouriers, selectedCouriers) &&
            const DeepCollectionEquality()
                .equals(other.appliedVouchers, appliedVouchers) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      status,
      cartSnapshot,
      shippingAddressId,
      const DeepCollectionEquality().hash(selectedCouriers),
      const DeepCollectionEquality().hash(appliedVouchers),
      grandTotal,
      expiresAt,
      createdAt);

  @override
  String toString() {
    return 'CheckoutSessionModel(id: $id, status: $status, cartSnapshot: $cartSnapshot, shippingAddressId: $shippingAddressId, selectedCouriers: $selectedCouriers, appliedVouchers: $appliedVouchers, grandTotal: $grandTotal, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CheckoutSessionModelCopyWith<$Res> {
  factory $CheckoutSessionModelCopyWith(CheckoutSessionModel value,
          $Res Function(CheckoutSessionModel) _then) =
      _$CheckoutSessionModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() String id,
      @StringJson() String status,
      @StringOrNullJson() @JsonKey(name: 'cart_snapshot') String? cartSnapshot,
      @IntOrNullJson()
      @JsonKey(name: 'shipping_address_id')
      int? shippingAddressId,
      @JsonMapJson()
      @JsonKey(name: 'selected_couriers')
      Map<String, dynamic>? selectedCouriers,
      @JsonMapJson()
      @JsonKey(name: 'applied_vouchers')
      Map<String, dynamic>? appliedVouchers,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$CheckoutSessionModelCopyWithImpl<$Res>
    implements $CheckoutSessionModelCopyWith<$Res> {
  _$CheckoutSessionModelCopyWithImpl(this._self, this._then);

  final CheckoutSessionModel _self;
  final $Res Function(CheckoutSessionModel) _then;

  /// Create a copy of CheckoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? cartSnapshot = freezed,
    Object? shippingAddressId = freezed,
    Object? selectedCouriers = freezed,
    Object? appliedVouchers = freezed,
    Object? grandTotal = null,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      cartSnapshot: freezed == cartSnapshot
          ? _self.cartSnapshot
          : cartSnapshot // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddressId: freezed == shippingAddressId
          ? _self.shippingAddressId
          : shippingAddressId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCouriers: freezed == selectedCouriers
          ? _self.selectedCouriers
          : selectedCouriers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      appliedVouchers: freezed == appliedVouchers
          ? _self.appliedVouchers
          : appliedVouchers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CheckoutSessionModel].
extension CheckoutSessionModelPatterns on CheckoutSessionModel {
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
    TResult Function(_CheckoutSessionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionModel() when $default != null:
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
    TResult Function(_CheckoutSessionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionModel():
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
    TResult? Function(_CheckoutSessionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionModel() when $default != null:
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
            @StringJson() String id,
            @StringJson() String status,
            @StringOrNullJson()
            @JsonKey(name: 'cart_snapshot')
            String? cartSnapshot,
            @IntOrNullJson()
            @JsonKey(name: 'shipping_address_id')
            int? shippingAddressId,
            @JsonMapJson()
            @JsonKey(name: 'selected_couriers')
            Map<String, dynamic>? selectedCouriers,
            @JsonMapJson()
            @JsonKey(name: 'applied_vouchers')
            Map<String, dynamic>? appliedVouchers,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionModel() when $default != null:
        return $default(
            _that.id,
            _that.status,
            _that.cartSnapshot,
            _that.shippingAddressId,
            _that.selectedCouriers,
            _that.appliedVouchers,
            _that.grandTotal,
            _that.expiresAt,
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
            @StringJson() String id,
            @StringJson() String status,
            @StringOrNullJson()
            @JsonKey(name: 'cart_snapshot')
            String? cartSnapshot,
            @IntOrNullJson()
            @JsonKey(name: 'shipping_address_id')
            int? shippingAddressId,
            @JsonMapJson()
            @JsonKey(name: 'selected_couriers')
            Map<String, dynamic>? selectedCouriers,
            @JsonMapJson()
            @JsonKey(name: 'applied_vouchers')
            Map<String, dynamic>? appliedVouchers,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionModel():
        return $default(
            _that.id,
            _that.status,
            _that.cartSnapshot,
            _that.shippingAddressId,
            _that.selectedCouriers,
            _that.appliedVouchers,
            _that.grandTotal,
            _that.expiresAt,
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
            @StringJson() String id,
            @StringJson() String status,
            @StringOrNullJson()
            @JsonKey(name: 'cart_snapshot')
            String? cartSnapshot,
            @IntOrNullJson()
            @JsonKey(name: 'shipping_address_id')
            int? shippingAddressId,
            @JsonMapJson()
            @JsonKey(name: 'selected_couriers')
            Map<String, dynamic>? selectedCouriers,
            @JsonMapJson()
            @JsonKey(name: 'applied_vouchers')
            Map<String, dynamic>? appliedVouchers,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSessionModel() when $default != null:
        return $default(
            _that.id,
            _that.status,
            _that.cartSnapshot,
            _that.shippingAddressId,
            _that.selectedCouriers,
            _that.appliedVouchers,
            _that.grandTotal,
            _that.expiresAt,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CheckoutSessionModel extends CheckoutSessionModel {
  const _CheckoutSessionModel(
      {@StringJson() this.id = '',
      @StringJson() this.status = '',
      @StringOrNullJson() @JsonKey(name: 'cart_snapshot') this.cartSnapshot,
      @IntOrNullJson()
      @JsonKey(name: 'shipping_address_id')
      this.shippingAddressId,
      @JsonMapJson()
      @JsonKey(name: 'selected_couriers')
      final Map<String, dynamic>? selectedCouriers,
      @JsonMapJson()
      @JsonKey(name: 'applied_vouchers')
      final Map<String, dynamic>? appliedVouchers,
      @DoubleJson() @JsonKey(name: 'grand_total') this.grandTotal = 0,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expires_at') this.expiresAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : _selectedCouriers = selectedCouriers,
        _appliedVouchers = appliedVouchers,
        super._();
  factory _CheckoutSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionModelFromJson(json);

  @override
  @JsonKey()
  @StringJson()
  final String id;

  /// `stock_reserved` → `awaiting_payment` sesudah konfirmasi.
  /// Sesi yang dibatalkan berstatus **`expired`**, bukan `cancelled`.
  @override
  @JsonKey()
  @StringJson()
  final String status;

  /// ⚠️ Dikirim sebagai **string berisi JSON**, bukan array bersarang.
  /// Dipakai [snapshotItems] untuk membacanya.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'cart_snapshot')
  final String? cartSnapshot;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'shipping_address_id')
  final int? shippingAddressId;

  /// `null` sebelum kurir dipilih; sesudahnya map berkunci `store_id`.
  ///
  /// ⚠️ **Dikirim sebagai string berisi JSON**, bukan objek — sama seperti
  /// [cartSnapshot]. Ini menyesatkan karena balasan
  /// `PATCH /checkout/sessions/{id}/shipping` mengirim field bernama sama
  /// sebagai objek sungguhan; yang *tersimpan di sesi* berupa string.
  /// Tanpa [JsonMapJson], `GET /checkout/sessions/{id}` melempar
  /// `type 'String' is not a subtype of type 'Map<String, dynamic>?'`
  /// begitu kurir dipilih — persis di tengah alur checkout.
  final Map<String, dynamic>? _selectedCouriers;

  /// `null` sebelum kurir dipilih; sesudahnya map berkunci `store_id`.
  ///
  /// ⚠️ **Dikirim sebagai string berisi JSON**, bukan objek — sama seperti
  /// [cartSnapshot]. Ini menyesatkan karena balasan
  /// `PATCH /checkout/sessions/{id}/shipping` mengirim field bernama sama
  /// sebagai objek sungguhan; yang *tersimpan di sesi* berupa string.
  /// Tanpa [JsonMapJson], `GET /checkout/sessions/{id}` melempar
  /// `type 'String' is not a subtype of type 'Map<String, dynamic>?'`
  /// begitu kurir dipilih — persis di tengah alur checkout.
  @override
  @JsonMapJson()
  @JsonKey(name: 'selected_couriers')
  Map<String, dynamic>? get selectedCouriers {
    final value = _selectedCouriers;
    if (value == null) return null;
    if (_selectedCouriers is EqualUnmodifiableMapView) return _selectedCouriers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Sama seperti [selectedCouriers]: string berisi JSON, bukan objek.
  final Map<String, dynamic>? _appliedVouchers;

  /// Sama seperti [selectedCouriers]: string berisi JSON, bukan objek.
  @override
  @JsonMapJson()
  @JsonKey(name: 'applied_vouchers')
  Map<String, dynamic>? get appliedVouchers {
    final value = _appliedVouchers;
    if (value == null) return null;
    if (_appliedVouchers is EqualUnmodifiableMapView) return _appliedVouchers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// String berdesimal di endpoint ini (`"3049000.00"`), angka di
  /// `POST /checkout/sessions`.
  @override
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  final double grandTotal;

  /// **UTC** — lihat [ServerUtcDateTimeJson].
  @override
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  /// **Waktu dinding server (WIB)** — konverter berbeda dari [expiresAt],
  /// dan itu memang disengaja.
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of CheckoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CheckoutSessionModelCopyWith<_CheckoutSessionModel> get copyWith =>
      __$CheckoutSessionModelCopyWithImpl<_CheckoutSessionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CheckoutSessionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CheckoutSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.cartSnapshot, cartSnapshot) ||
                other.cartSnapshot == cartSnapshot) &&
            (identical(other.shippingAddressId, shippingAddressId) ||
                other.shippingAddressId == shippingAddressId) &&
            const DeepCollectionEquality()
                .equals(other._selectedCouriers, _selectedCouriers) &&
            const DeepCollectionEquality()
                .equals(other._appliedVouchers, _appliedVouchers) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      status,
      cartSnapshot,
      shippingAddressId,
      const DeepCollectionEquality().hash(_selectedCouriers),
      const DeepCollectionEquality().hash(_appliedVouchers),
      grandTotal,
      expiresAt,
      createdAt);

  @override
  String toString() {
    return 'CheckoutSessionModel(id: $id, status: $status, cartSnapshot: $cartSnapshot, shippingAddressId: $shippingAddressId, selectedCouriers: $selectedCouriers, appliedVouchers: $appliedVouchers, grandTotal: $grandTotal, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CheckoutSessionModelCopyWith<$Res>
    implements $CheckoutSessionModelCopyWith<$Res> {
  factory _$CheckoutSessionModelCopyWith(_CheckoutSessionModel value,
          $Res Function(_CheckoutSessionModel) _then) =
      __$CheckoutSessionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() String id,
      @StringJson() String status,
      @StringOrNullJson() @JsonKey(name: 'cart_snapshot') String? cartSnapshot,
      @IntOrNullJson()
      @JsonKey(name: 'shipping_address_id')
      int? shippingAddressId,
      @JsonMapJson()
      @JsonKey(name: 'selected_couriers')
      Map<String, dynamic>? selectedCouriers,
      @JsonMapJson()
      @JsonKey(name: 'applied_vouchers')
      Map<String, dynamic>? appliedVouchers,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$CheckoutSessionModelCopyWithImpl<$Res>
    implements _$CheckoutSessionModelCopyWith<$Res> {
  __$CheckoutSessionModelCopyWithImpl(this._self, this._then);

  final _CheckoutSessionModel _self;
  final $Res Function(_CheckoutSessionModel) _then;

  /// Create a copy of CheckoutSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? cartSnapshot = freezed,
    Object? shippingAddressId = freezed,
    Object? selectedCouriers = freezed,
    Object? appliedVouchers = freezed,
    Object? grandTotal = null,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_CheckoutSessionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      cartSnapshot: freezed == cartSnapshot
          ? _self.cartSnapshot
          : cartSnapshot // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddressId: freezed == shippingAddressId
          ? _self.shippingAddressId
          : shippingAddressId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCouriers: freezed == selectedCouriers
          ? _self._selectedCouriers
          : selectedCouriers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      appliedVouchers: freezed == appliedVouchers
          ? _self._appliedVouchers
          : appliedVouchers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$ShippingOptionModel {
  @StringJson()
  @JsonKey(name: 'courier_code')
  String get courierCode;
  @StringJson()
  @JsonKey(name: 'service_code')
  String get serviceCode;
  @StringJson()
  @JsonKey(name: 'service_name')
  String get serviceName;
  @StringOrNullJson()
  String? get zone;
  @DoubleJson()
  @JsonKey(name: 'weight_kg')
  double get weightKg;
  @DoubleJson()
  double get cost;
  @IntJson()
  @JsonKey(name: 'etd_min_days')
  int get etdMinDays;
  @IntJson()
  @JsonKey(name: 'etd_max_days')
  int get etdMaxDays;

  /// Create a copy of ShippingOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShippingOptionModelCopyWith<ShippingOptionModel> get copyWith =>
      _$ShippingOptionModelCopyWithImpl<ShippingOptionModel>(
          this as ShippingOptionModel, _$identity);

  /// Serializes this ShippingOptionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShippingOptionModel &&
            (identical(other.courierCode, courierCode) ||
                other.courierCode == courierCode) &&
            (identical(other.serviceCode, serviceCode) ||
                other.serviceCode == serviceCode) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.etdMinDays, etdMinDays) ||
                other.etdMinDays == etdMinDays) &&
            (identical(other.etdMaxDays, etdMaxDays) ||
                other.etdMaxDays == etdMaxDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, courierCode, serviceCode,
      serviceName, zone, weightKg, cost, etdMinDays, etdMaxDays);

  @override
  String toString() {
    return 'ShippingOptionModel(courierCode: $courierCode, serviceCode: $serviceCode, serviceName: $serviceName, zone: $zone, weightKg: $weightKg, cost: $cost, etdMinDays: $etdMinDays, etdMaxDays: $etdMaxDays)';
  }
}

/// @nodoc
abstract mixin class $ShippingOptionModelCopyWith<$Res> {
  factory $ShippingOptionModelCopyWith(
          ShippingOptionModel value, $Res Function(ShippingOptionModel) _then) =
      _$ShippingOptionModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'courier_code') String courierCode,
      @StringJson() @JsonKey(name: 'service_code') String serviceCode,
      @StringJson() @JsonKey(name: 'service_name') String serviceName,
      @StringOrNullJson() String? zone,
      @DoubleJson() @JsonKey(name: 'weight_kg') double weightKg,
      @DoubleJson() double cost,
      @IntJson() @JsonKey(name: 'etd_min_days') int etdMinDays,
      @IntJson() @JsonKey(name: 'etd_max_days') int etdMaxDays});
}

/// @nodoc
class _$ShippingOptionModelCopyWithImpl<$Res>
    implements $ShippingOptionModelCopyWith<$Res> {
  _$ShippingOptionModelCopyWithImpl(this._self, this._then);

  final ShippingOptionModel _self;
  final $Res Function(ShippingOptionModel) _then;

  /// Create a copy of ShippingOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courierCode = null,
    Object? serviceCode = null,
    Object? serviceName = null,
    Object? zone = freezed,
    Object? weightKg = null,
    Object? cost = null,
    Object? etdMinDays = null,
    Object? etdMaxDays = null,
  }) {
    return _then(_self.copyWith(
      courierCode: null == courierCode
          ? _self.courierCode
          : courierCode // ignore: cast_nullable_to_non_nullable
              as String,
      serviceCode: null == serviceCode
          ? _self.serviceCode
          : serviceCode // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      zone: freezed == zone
          ? _self.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: null == weightKg
          ? _self.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _self.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      etdMinDays: null == etdMinDays
          ? _self.etdMinDays
          : etdMinDays // ignore: cast_nullable_to_non_nullable
              as int,
      etdMaxDays: null == etdMaxDays
          ? _self.etdMaxDays
          : etdMaxDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShippingOptionModel].
extension ShippingOptionModelPatterns on ShippingOptionModel {
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
    TResult Function(_ShippingOptionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShippingOptionModel() when $default != null:
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
    TResult Function(_ShippingOptionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingOptionModel():
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
    TResult? Function(_ShippingOptionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingOptionModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'service_code') String serviceCode,
            @StringJson() @JsonKey(name: 'service_name') String serviceName,
            @StringOrNullJson() String? zone,
            @DoubleJson() @JsonKey(name: 'weight_kg') double weightKg,
            @DoubleJson() double cost,
            @IntJson() @JsonKey(name: 'etd_min_days') int etdMinDays,
            @IntJson() @JsonKey(name: 'etd_max_days') int etdMaxDays)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShippingOptionModel() when $default != null:
        return $default(
            _that.courierCode,
            _that.serviceCode,
            _that.serviceName,
            _that.zone,
            _that.weightKg,
            _that.cost,
            _that.etdMinDays,
            _that.etdMaxDays);
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
            @StringJson() @JsonKey(name: 'service_code') String serviceCode,
            @StringJson() @JsonKey(name: 'service_name') String serviceName,
            @StringOrNullJson() String? zone,
            @DoubleJson() @JsonKey(name: 'weight_kg') double weightKg,
            @DoubleJson() double cost,
            @IntJson() @JsonKey(name: 'etd_min_days') int etdMinDays,
            @IntJson() @JsonKey(name: 'etd_max_days') int etdMaxDays)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingOptionModel():
        return $default(
            _that.courierCode,
            _that.serviceCode,
            _that.serviceName,
            _that.zone,
            _that.weightKg,
            _that.cost,
            _that.etdMinDays,
            _that.etdMaxDays);
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
            @StringJson() @JsonKey(name: 'service_code') String serviceCode,
            @StringJson() @JsonKey(name: 'service_name') String serviceName,
            @StringOrNullJson() String? zone,
            @DoubleJson() @JsonKey(name: 'weight_kg') double weightKg,
            @DoubleJson() double cost,
            @IntJson() @JsonKey(name: 'etd_min_days') int etdMinDays,
            @IntJson() @JsonKey(name: 'etd_max_days') int etdMaxDays)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingOptionModel() when $default != null:
        return $default(
            _that.courierCode,
            _that.serviceCode,
            _that.serviceName,
            _that.zone,
            _that.weightKg,
            _that.cost,
            _that.etdMinDays,
            _that.etdMaxDays);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ShippingOptionModel extends ShippingOptionModel {
  const _ShippingOptionModel(
      {@StringJson() @JsonKey(name: 'courier_code') this.courierCode = '',
      @StringJson() @JsonKey(name: 'service_code') this.serviceCode = '',
      @StringJson() @JsonKey(name: 'service_name') this.serviceName = '',
      @StringOrNullJson() this.zone,
      @DoubleJson() @JsonKey(name: 'weight_kg') this.weightKg = 0,
      @DoubleJson() this.cost = 0,
      @IntJson() @JsonKey(name: 'etd_min_days') this.etdMinDays = 0,
      @IntJson() @JsonKey(name: 'etd_max_days') this.etdMaxDays = 0})
      : super._();
  factory _ShippingOptionModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingOptionModelFromJson(json);

  @override
  @StringJson()
  @JsonKey(name: 'courier_code')
  final String courierCode;
  @override
  @StringJson()
  @JsonKey(name: 'service_code')
  final String serviceCode;
  @override
  @StringJson()
  @JsonKey(name: 'service_name')
  final String serviceName;
  @override
  @StringOrNullJson()
  final String? zone;
  @override
  @DoubleJson()
  @JsonKey(name: 'weight_kg')
  final double weightKg;
  @override
  @JsonKey()
  @DoubleJson()
  final double cost;
  @override
  @IntJson()
  @JsonKey(name: 'etd_min_days')
  final int etdMinDays;
  @override
  @IntJson()
  @JsonKey(name: 'etd_max_days')
  final int etdMaxDays;

  /// Create a copy of ShippingOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShippingOptionModelCopyWith<_ShippingOptionModel> get copyWith =>
      __$ShippingOptionModelCopyWithImpl<_ShippingOptionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShippingOptionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShippingOptionModel &&
            (identical(other.courierCode, courierCode) ||
                other.courierCode == courierCode) &&
            (identical(other.serviceCode, serviceCode) ||
                other.serviceCode == serviceCode) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.etdMinDays, etdMinDays) ||
                other.etdMinDays == etdMinDays) &&
            (identical(other.etdMaxDays, etdMaxDays) ||
                other.etdMaxDays == etdMaxDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, courierCode, serviceCode,
      serviceName, zone, weightKg, cost, etdMinDays, etdMaxDays);

  @override
  String toString() {
    return 'ShippingOptionModel(courierCode: $courierCode, serviceCode: $serviceCode, serviceName: $serviceName, zone: $zone, weightKg: $weightKg, cost: $cost, etdMinDays: $etdMinDays, etdMaxDays: $etdMaxDays)';
  }
}

/// @nodoc
abstract mixin class _$ShippingOptionModelCopyWith<$Res>
    implements $ShippingOptionModelCopyWith<$Res> {
  factory _$ShippingOptionModelCopyWith(_ShippingOptionModel value,
          $Res Function(_ShippingOptionModel) _then) =
      __$ShippingOptionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'courier_code') String courierCode,
      @StringJson() @JsonKey(name: 'service_code') String serviceCode,
      @StringJson() @JsonKey(name: 'service_name') String serviceName,
      @StringOrNullJson() String? zone,
      @DoubleJson() @JsonKey(name: 'weight_kg') double weightKg,
      @DoubleJson() double cost,
      @IntJson() @JsonKey(name: 'etd_min_days') int etdMinDays,
      @IntJson() @JsonKey(name: 'etd_max_days') int etdMaxDays});
}

/// @nodoc
class __$ShippingOptionModelCopyWithImpl<$Res>
    implements _$ShippingOptionModelCopyWith<$Res> {
  __$ShippingOptionModelCopyWithImpl(this._self, this._then);

  final _ShippingOptionModel _self;
  final $Res Function(_ShippingOptionModel) _then;

  /// Create a copy of ShippingOptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? courierCode = null,
    Object? serviceCode = null,
    Object? serviceName = null,
    Object? zone = freezed,
    Object? weightKg = null,
    Object? cost = null,
    Object? etdMinDays = null,
    Object? etdMaxDays = null,
  }) {
    return _then(_ShippingOptionModel(
      courierCode: null == courierCode
          ? _self.courierCode
          : courierCode // ignore: cast_nullable_to_non_nullable
              as String,
      serviceCode: null == serviceCode
          ? _self.serviceCode
          : serviceCode // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: null == serviceName
          ? _self.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      zone: freezed == zone
          ? _self.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: null == weightKg
          ? _self.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      cost: null == cost
          ? _self.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
      etdMinDays: null == etdMinDays
          ? _self.etdMinDays
          : etdMinDays // ignore: cast_nullable_to_non_nullable
              as int,
      etdMaxDays: null == etdMaxDays
          ? _self.etdMaxDays
          : etdMaxDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ShippingSelectionResult {
  @JsonKey(name: 'selected_couriers')
  Map<String, dynamic>? get selectedCouriers;
  @DoubleJson()
  @JsonKey(name: 'shipping_total')
  double get shippingTotal;
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  double get grandTotal;

  /// Create a copy of ShippingSelectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShippingSelectionResultCopyWith<ShippingSelectionResult> get copyWith =>
      _$ShippingSelectionResultCopyWithImpl<ShippingSelectionResult>(
          this as ShippingSelectionResult, _$identity);

  /// Serializes this ShippingSelectionResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShippingSelectionResult &&
            const DeepCollectionEquality()
                .equals(other.selectedCouriers, selectedCouriers) &&
            (identical(other.shippingTotal, shippingTotal) ||
                other.shippingTotal == shippingTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(selectedCouriers),
      shippingTotal,
      grandTotal);

  @override
  String toString() {
    return 'ShippingSelectionResult(selectedCouriers: $selectedCouriers, shippingTotal: $shippingTotal, grandTotal: $grandTotal)';
  }
}

/// @nodoc
abstract mixin class $ShippingSelectionResultCopyWith<$Res> {
  factory $ShippingSelectionResultCopyWith(ShippingSelectionResult value,
          $Res Function(ShippingSelectionResult) _then) =
      _$ShippingSelectionResultCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'selected_couriers')
      Map<String, dynamic>? selectedCouriers,
      @DoubleJson() @JsonKey(name: 'shipping_total') double shippingTotal,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal});
}

/// @nodoc
class _$ShippingSelectionResultCopyWithImpl<$Res>
    implements $ShippingSelectionResultCopyWith<$Res> {
  _$ShippingSelectionResultCopyWithImpl(this._self, this._then);

  final ShippingSelectionResult _self;
  final $Res Function(ShippingSelectionResult) _then;

  /// Create a copy of ShippingSelectionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCouriers = freezed,
    Object? shippingTotal = null,
    Object? grandTotal = null,
  }) {
    return _then(_self.copyWith(
      selectedCouriers: freezed == selectedCouriers
          ? _self.selectedCouriers
          : selectedCouriers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      shippingTotal: null == shippingTotal
          ? _self.shippingTotal
          : shippingTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ShippingSelectionResult].
extension ShippingSelectionResultPatterns on ShippingSelectionResult {
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
    TResult Function(_ShippingSelectionResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShippingSelectionResult() when $default != null:
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
    TResult Function(_ShippingSelectionResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingSelectionResult():
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
    TResult? Function(_ShippingSelectionResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingSelectionResult() when $default != null:
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
            @JsonKey(name: 'selected_couriers')
            Map<String, dynamic>? selectedCouriers,
            @DoubleJson() @JsonKey(name: 'shipping_total') double shippingTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ShippingSelectionResult() when $default != null:
        return $default(
            _that.selectedCouriers, _that.shippingTotal, _that.grandTotal);
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
            @JsonKey(name: 'selected_couriers')
            Map<String, dynamic>? selectedCouriers,
            @DoubleJson() @JsonKey(name: 'shipping_total') double shippingTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingSelectionResult():
        return $default(
            _that.selectedCouriers, _that.shippingTotal, _that.grandTotal);
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
            @JsonKey(name: 'selected_couriers')
            Map<String, dynamic>? selectedCouriers,
            @DoubleJson() @JsonKey(name: 'shipping_total') double shippingTotal,
            @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ShippingSelectionResult() when $default != null:
        return $default(
            _that.selectedCouriers, _that.shippingTotal, _that.grandTotal);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ShippingSelectionResult implements ShippingSelectionResult {
  const _ShippingSelectionResult(
      {@JsonKey(name: 'selected_couriers')
      final Map<String, dynamic>? selectedCouriers,
      @DoubleJson() @JsonKey(name: 'shipping_total') this.shippingTotal = 0,
      @DoubleJson() @JsonKey(name: 'grand_total') this.grandTotal = 0})
      : _selectedCouriers = selectedCouriers;
  factory _ShippingSelectionResult.fromJson(Map<String, dynamic> json) =>
      _$ShippingSelectionResultFromJson(json);

  final Map<String, dynamic>? _selectedCouriers;
  @override
  @JsonKey(name: 'selected_couriers')
  Map<String, dynamic>? get selectedCouriers {
    final value = _selectedCouriers;
    if (value == null) return null;
    if (_selectedCouriers is EqualUnmodifiableMapView) return _selectedCouriers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @DoubleJson()
  @JsonKey(name: 'shipping_total')
  final double shippingTotal;
  @override
  @DoubleJson()
  @JsonKey(name: 'grand_total')
  final double grandTotal;

  /// Create a copy of ShippingSelectionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShippingSelectionResultCopyWith<_ShippingSelectionResult> get copyWith =>
      __$ShippingSelectionResultCopyWithImpl<_ShippingSelectionResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShippingSelectionResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShippingSelectionResult &&
            const DeepCollectionEquality()
                .equals(other._selectedCouriers, _selectedCouriers) &&
            (identical(other.shippingTotal, shippingTotal) ||
                other.shippingTotal == shippingTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_selectedCouriers),
      shippingTotal,
      grandTotal);

  @override
  String toString() {
    return 'ShippingSelectionResult(selectedCouriers: $selectedCouriers, shippingTotal: $shippingTotal, grandTotal: $grandTotal)';
  }
}

/// @nodoc
abstract mixin class _$ShippingSelectionResultCopyWith<$Res>
    implements $ShippingSelectionResultCopyWith<$Res> {
  factory _$ShippingSelectionResultCopyWith(_ShippingSelectionResult value,
          $Res Function(_ShippingSelectionResult) _then) =
      __$ShippingSelectionResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'selected_couriers')
      Map<String, dynamic>? selectedCouriers,
      @DoubleJson() @JsonKey(name: 'shipping_total') double shippingTotal,
      @DoubleJson() @JsonKey(name: 'grand_total') double grandTotal});
}

/// @nodoc
class __$ShippingSelectionResultCopyWithImpl<$Res>
    implements _$ShippingSelectionResultCopyWith<$Res> {
  __$ShippingSelectionResultCopyWithImpl(this._self, this._then);

  final _ShippingSelectionResult _self;
  final $Res Function(_ShippingSelectionResult) _then;

  /// Create a copy of ShippingSelectionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedCouriers = freezed,
    Object? shippingTotal = null,
    Object? grandTotal = null,
  }) {
    return _then(_ShippingSelectionResult(
      selectedCouriers: freezed == selectedCouriers
          ? _self._selectedCouriers
          : selectedCouriers // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      shippingTotal: null == shippingTotal
          ? _self.shippingTotal
          : shippingTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$CheckoutConfirmResult {
  @JsonKey(name: 'order_ids')
  List<int> get orderIds;
  @IntOrNullJson()
  @JsonKey(name: 'payment_transaction_id')
  int? get paymentTransactionId;

  /// Create a copy of CheckoutConfirmResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutConfirmResultCopyWith<CheckoutConfirmResult> get copyWith =>
      _$CheckoutConfirmResultCopyWithImpl<CheckoutConfirmResult>(
          this as CheckoutConfirmResult, _$identity);

  /// Serializes this CheckoutConfirmResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutConfirmResult &&
            const DeepCollectionEquality().equals(other.orderIds, orderIds) &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(orderIds), paymentTransactionId);

  @override
  String toString() {
    return 'CheckoutConfirmResult(orderIds: $orderIds, paymentTransactionId: $paymentTransactionId)';
  }
}

/// @nodoc
abstract mixin class $CheckoutConfirmResultCopyWith<$Res> {
  factory $CheckoutConfirmResultCopyWith(CheckoutConfirmResult value,
          $Res Function(CheckoutConfirmResult) _then) =
      _$CheckoutConfirmResultCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'order_ids') List<int> orderIds,
      @IntOrNullJson()
      @JsonKey(name: 'payment_transaction_id')
      int? paymentTransactionId});
}

/// @nodoc
class _$CheckoutConfirmResultCopyWithImpl<$Res>
    implements $CheckoutConfirmResultCopyWith<$Res> {
  _$CheckoutConfirmResultCopyWithImpl(this._self, this._then);

  final CheckoutConfirmResult _self;
  final $Res Function(CheckoutConfirmResult) _then;

  /// Create a copy of CheckoutConfirmResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderIds = null,
    Object? paymentTransactionId = freezed,
  }) {
    return _then(_self.copyWith(
      orderIds: null == orderIds
          ? _self.orderIds
          : orderIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      paymentTransactionId: freezed == paymentTransactionId
          ? _self.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CheckoutConfirmResult].
extension CheckoutConfirmResultPatterns on CheckoutConfirmResult {
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
    TResult Function(_CheckoutConfirmResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutConfirmResult() when $default != null:
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
    TResult Function(_CheckoutConfirmResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutConfirmResult():
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
    TResult? Function(_CheckoutConfirmResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutConfirmResult() when $default != null:
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
            @JsonKey(name: 'order_ids') List<int> orderIds,
            @IntOrNullJson()
            @JsonKey(name: 'payment_transaction_id')
            int? paymentTransactionId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutConfirmResult() when $default != null:
        return $default(_that.orderIds, _that.paymentTransactionId);
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
            @JsonKey(name: 'order_ids') List<int> orderIds,
            @IntOrNullJson()
            @JsonKey(name: 'payment_transaction_id')
            int? paymentTransactionId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutConfirmResult():
        return $default(_that.orderIds, _that.paymentTransactionId);
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
            @JsonKey(name: 'order_ids') List<int> orderIds,
            @IntOrNullJson()
            @JsonKey(name: 'payment_transaction_id')
            int? paymentTransactionId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutConfirmResult() when $default != null:
        return $default(_that.orderIds, _that.paymentTransactionId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CheckoutConfirmResult extends CheckoutConfirmResult {
  const _CheckoutConfirmResult(
      {@JsonKey(name: 'order_ids') final List<int> orderIds = const <int>[],
      @IntOrNullJson()
      @JsonKey(name: 'payment_transaction_id')
      this.paymentTransactionId})
      : _orderIds = orderIds,
        super._();
  factory _CheckoutConfirmResult.fromJson(Map<String, dynamic> json) =>
      _$CheckoutConfirmResultFromJson(json);

  final List<int> _orderIds;
  @override
  @JsonKey(name: 'order_ids')
  List<int> get orderIds {
    if (_orderIds is EqualUnmodifiableListView) return _orderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderIds);
  }

  @override
  @IntOrNullJson()
  @JsonKey(name: 'payment_transaction_id')
  final int? paymentTransactionId;

  /// Create a copy of CheckoutConfirmResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CheckoutConfirmResultCopyWith<_CheckoutConfirmResult> get copyWith =>
      __$CheckoutConfirmResultCopyWithImpl<_CheckoutConfirmResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CheckoutConfirmResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CheckoutConfirmResult &&
            const DeepCollectionEquality().equals(other._orderIds, _orderIds) &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_orderIds), paymentTransactionId);

  @override
  String toString() {
    return 'CheckoutConfirmResult(orderIds: $orderIds, paymentTransactionId: $paymentTransactionId)';
  }
}

/// @nodoc
abstract mixin class _$CheckoutConfirmResultCopyWith<$Res>
    implements $CheckoutConfirmResultCopyWith<$Res> {
  factory _$CheckoutConfirmResultCopyWith(_CheckoutConfirmResult value,
          $Res Function(_CheckoutConfirmResult) _then) =
      __$CheckoutConfirmResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'order_ids') List<int> orderIds,
      @IntOrNullJson()
      @JsonKey(name: 'payment_transaction_id')
      int? paymentTransactionId});
}

/// @nodoc
class __$CheckoutConfirmResultCopyWithImpl<$Res>
    implements _$CheckoutConfirmResultCopyWith<$Res> {
  __$CheckoutConfirmResultCopyWithImpl(this._self, this._then);

  final _CheckoutConfirmResult _self;
  final $Res Function(_CheckoutConfirmResult) _then;

  /// Create a copy of CheckoutConfirmResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orderIds = null,
    Object? paymentTransactionId = freezed,
  }) {
    return _then(_CheckoutConfirmResult(
      orderIds: null == orderIds
          ? _self._orderIds
          : orderIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      paymentTransactionId: freezed == paymentTransactionId
          ? _self.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
