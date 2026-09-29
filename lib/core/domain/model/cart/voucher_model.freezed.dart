// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoucherModel {
  @IntJson()
  int get id;

  /// `null` = voucher platform (berlaku lintas toko).
  @IntOrNullJson()
  @JsonKey(name: 'store_id')
  int? get storeId;
  @StringJson()
  String get code;
  @StringJson()
  String get name;

  /// `percentage` / `fixed` / `free_shipping` / `cashback`.
  @StringJson()
  @JsonKey(name: 'discount_type')
  String get discountType;
  @DoubleJson()
  @JsonKey(name: 'discount_value')
  double get discountValue;
  @DoubleOrNullJson()
  @JsonKey(name: 'max_discount')
  double? get maxDiscount;
  @DoubleJson()
  @JsonKey(name: 'min_spend')
  double get minSpend;
  @ServerDateTimeJson()
  @JsonKey(name: 'valid_until')
  DateTime? get validUntil;

  /// `active` / `inactive` / `expired`.
  @StringJson()
  String get status;
  @ServerDateTimeJson()
  @JsonKey(name: 'claimed_at')
  DateTime? get claimedAt;

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VoucherModelCopyWith<VoucherModel> get copyWith =>
      _$VoucherModelCopyWithImpl<VoucherModel>(
          this as VoucherModel, _$identity);

  /// Serializes this VoucherModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VoucherModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.maxDiscount, maxDiscount) ||
                other.maxDiscount == maxDiscount) &&
            (identical(other.minSpend, minSpend) ||
                other.minSpend == minSpend) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.claimedAt, claimedAt) ||
                other.claimedAt == claimedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      code,
      name,
      discountType,
      discountValue,
      maxDiscount,
      minSpend,
      validUntil,
      status,
      claimedAt);

  @override
  String toString() {
    return 'VoucherModel(id: $id, storeId: $storeId, code: $code, name: $name, discountType: $discountType, discountValue: $discountValue, maxDiscount: $maxDiscount, minSpend: $minSpend, validUntil: $validUntil, status: $status, claimedAt: $claimedAt)';
  }
}

/// @nodoc
abstract mixin class $VoucherModelCopyWith<$Res> {
  factory $VoucherModelCopyWith(
          VoucherModel value, $Res Function(VoucherModel) _then) =
      _$VoucherModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
      @StringJson() String code,
      @StringJson() String name,
      @StringJson() @JsonKey(name: 'discount_type') String discountType,
      @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
      @DoubleOrNullJson() @JsonKey(name: 'max_discount') double? maxDiscount,
      @DoubleJson() @JsonKey(name: 'min_spend') double minSpend,
      @ServerDateTimeJson() @JsonKey(name: 'valid_until') DateTime? validUntil,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'claimed_at') DateTime? claimedAt});
}

/// @nodoc
class _$VoucherModelCopyWithImpl<$Res> implements $VoucherModelCopyWith<$Res> {
  _$VoucherModelCopyWithImpl(this._self, this._then);

  final VoucherModel _self;
  final $Res Function(VoucherModel) _then;

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = freezed,
    Object? code = null,
    Object? name = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscount = freezed,
    Object? minSpend = null,
    Object? validUntil = freezed,
    Object? status = null,
    Object? claimedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int?,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: null == discountType
          ? _self.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _self.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscount: freezed == maxDiscount
          ? _self.maxDiscount
          : maxDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      minSpend: null == minSpend
          ? _self.minSpend
          : minSpend // ignore: cast_nullable_to_non_nullable
              as double,
      validUntil: freezed == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      claimedAt: freezed == claimedAt
          ? _self.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VoucherModel].
extension VoucherModelPatterns on VoucherModel {
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
    TResult Function(_VoucherModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VoucherModel() when $default != null:
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
    TResult Function(_VoucherModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoucherModel():
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
    TResult? Function(_VoucherModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoucherModel() when $default != null:
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
            @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
            @StringJson() String code,
            @StringJson() String name,
            @StringJson() @JsonKey(name: 'discount_type') String discountType,
            @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
            @DoubleOrNullJson()
            @JsonKey(name: 'max_discount')
            double? maxDiscount,
            @DoubleJson() @JsonKey(name: 'min_spend') double minSpend,
            @ServerDateTimeJson()
            @JsonKey(name: 'valid_until')
            DateTime? validUntil,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'claimed_at')
            DateTime? claimedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VoucherModel() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.code,
            _that.name,
            _that.discountType,
            _that.discountValue,
            _that.maxDiscount,
            _that.minSpend,
            _that.validUntil,
            _that.status,
            _that.claimedAt);
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
            @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
            @StringJson() String code,
            @StringJson() String name,
            @StringJson() @JsonKey(name: 'discount_type') String discountType,
            @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
            @DoubleOrNullJson()
            @JsonKey(name: 'max_discount')
            double? maxDiscount,
            @DoubleJson() @JsonKey(name: 'min_spend') double minSpend,
            @ServerDateTimeJson()
            @JsonKey(name: 'valid_until')
            DateTime? validUntil,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'claimed_at')
            DateTime? claimedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoucherModel():
        return $default(
            _that.id,
            _that.storeId,
            _that.code,
            _that.name,
            _that.discountType,
            _that.discountValue,
            _that.maxDiscount,
            _that.minSpend,
            _that.validUntil,
            _that.status,
            _that.claimedAt);
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
            @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
            @StringJson() String code,
            @StringJson() String name,
            @StringJson() @JsonKey(name: 'discount_type') String discountType,
            @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
            @DoubleOrNullJson()
            @JsonKey(name: 'max_discount')
            double? maxDiscount,
            @DoubleJson() @JsonKey(name: 'min_spend') double minSpend,
            @ServerDateTimeJson()
            @JsonKey(name: 'valid_until')
            DateTime? validUntil,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'claimed_at')
            DateTime? claimedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoucherModel() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.code,
            _that.name,
            _that.discountType,
            _that.discountValue,
            _that.maxDiscount,
            _that.minSpend,
            _that.validUntil,
            _that.status,
            _that.claimedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VoucherModel extends VoucherModel {
  const _VoucherModel(
      {@IntJson() this.id = 0,
      @IntOrNullJson() @JsonKey(name: 'store_id') this.storeId,
      @StringJson() this.code = '',
      @StringJson() this.name = '',
      @StringJson() @JsonKey(name: 'discount_type') this.discountType = '',
      @DoubleJson() @JsonKey(name: 'discount_value') this.discountValue = 0,
      @DoubleOrNullJson() @JsonKey(name: 'max_discount') this.maxDiscount,
      @DoubleJson() @JsonKey(name: 'min_spend') this.minSpend = 0,
      @ServerDateTimeJson() @JsonKey(name: 'valid_until') this.validUntil,
      @StringJson() this.status = 'active',
      @ServerDateTimeJson() @JsonKey(name: 'claimed_at') this.claimedAt})
      : super._();
  factory _VoucherModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int id;

  /// `null` = voucher platform (berlaku lintas toko).
  @override
  @IntOrNullJson()
  @JsonKey(name: 'store_id')
  final int? storeId;
  @override
  @JsonKey()
  @StringJson()
  final String code;
  @override
  @JsonKey()
  @StringJson()
  final String name;

  /// `percentage` / `fixed` / `free_shipping` / `cashback`.
  @override
  @StringJson()
  @JsonKey(name: 'discount_type')
  final String discountType;
  @override
  @DoubleJson()
  @JsonKey(name: 'discount_value')
  final double discountValue;
  @override
  @DoubleOrNullJson()
  @JsonKey(name: 'max_discount')
  final double? maxDiscount;
  @override
  @DoubleJson()
  @JsonKey(name: 'min_spend')
  final double minSpend;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'valid_until')
  final DateTime? validUntil;

  /// `active` / `inactive` / `expired`.
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'claimed_at')
  final DateTime? claimedAt;

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VoucherModelCopyWith<_VoucherModel> get copyWith =>
      __$VoucherModelCopyWithImpl<_VoucherModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VoucherModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VoucherModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.maxDiscount, maxDiscount) ||
                other.maxDiscount == maxDiscount) &&
            (identical(other.minSpend, minSpend) ||
                other.minSpend == minSpend) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.claimedAt, claimedAt) ||
                other.claimedAt == claimedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      code,
      name,
      discountType,
      discountValue,
      maxDiscount,
      minSpend,
      validUntil,
      status,
      claimedAt);

  @override
  String toString() {
    return 'VoucherModel(id: $id, storeId: $storeId, code: $code, name: $name, discountType: $discountType, discountValue: $discountValue, maxDiscount: $maxDiscount, minSpend: $minSpend, validUntil: $validUntil, status: $status, claimedAt: $claimedAt)';
  }
}

/// @nodoc
abstract mixin class _$VoucherModelCopyWith<$Res>
    implements $VoucherModelCopyWith<$Res> {
  factory _$VoucherModelCopyWith(
          _VoucherModel value, $Res Function(_VoucherModel) _then) =
      __$VoucherModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
      @StringJson() String code,
      @StringJson() String name,
      @StringJson() @JsonKey(name: 'discount_type') String discountType,
      @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
      @DoubleOrNullJson() @JsonKey(name: 'max_discount') double? maxDiscount,
      @DoubleJson() @JsonKey(name: 'min_spend') double minSpend,
      @ServerDateTimeJson() @JsonKey(name: 'valid_until') DateTime? validUntil,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'claimed_at') DateTime? claimedAt});
}

/// @nodoc
class __$VoucherModelCopyWithImpl<$Res>
    implements _$VoucherModelCopyWith<$Res> {
  __$VoucherModelCopyWithImpl(this._self, this._then);

  final _VoucherModel _self;
  final $Res Function(_VoucherModel) _then;

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storeId = freezed,
    Object? code = null,
    Object? name = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscount = freezed,
    Object? minSpend = null,
    Object? validUntil = freezed,
    Object? status = null,
    Object? claimedAt = freezed,
  }) {
    return _then(_VoucherModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int?,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: null == discountType
          ? _self.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _self.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscount: freezed == maxDiscount
          ? _self.maxDiscount
          : maxDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      minSpend: null == minSpend
          ? _self.minSpend
          : minSpend // ignore: cast_nullable_to_non_nullable
              as double,
      validUntil: freezed == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      claimedAt: freezed == claimedAt
          ? _self.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
