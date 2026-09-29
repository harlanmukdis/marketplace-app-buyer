// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_post_purchase_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CancellationRequestModel {
  @IntJson()
  int get id;
  @StringJson()
  @JsonKey(name: 'status')
  String get statusCode;

  /// Kode [CancellationReason].
  @StringJson()
  String get reason;
  @StringOrNullJson()
  String? get note;

  /// Diisi penjual saat menolak.
  @StringOrNullJson()
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Batas waktu penjual menjawab (desain: "1x24 jam").
  @ServerDateTimeJson()
  @JsonKey(name: 'seller_response_deadline')
  DateTime? get sellerResponseDeadline;
  @ServerDateTimeJson()
  @JsonKey(name: 'resolved_at')
  DateTime? get resolvedAt;

  /// Create a copy of CancellationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CancellationRequestModelCopyWith<CancellationRequestModel> get copyWith =>
      _$CancellationRequestModelCopyWithImpl<CancellationRequestModel>(
          this as CancellationRequestModel, _$identity);

  /// Serializes this CancellationRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CancellationRequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sellerResponseDeadline, sellerResponseDeadline) ||
                other.sellerResponseDeadline == sellerResponseDeadline) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, statusCode, reason, note,
      rejectionReason, createdAt, sellerResponseDeadline, resolvedAt);

  @override
  String toString() {
    return 'CancellationRequestModel(id: $id, statusCode: $statusCode, reason: $reason, note: $note, rejectionReason: $rejectionReason, createdAt: $createdAt, sellerResponseDeadline: $sellerResponseDeadline, resolvedAt: $resolvedAt)';
  }
}

/// @nodoc
abstract mixin class $CancellationRequestModelCopyWith<$Res> {
  factory $CancellationRequestModelCopyWith(CancellationRequestModel value,
          $Res Function(CancellationRequestModel) _then) =
      _$CancellationRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'status') String statusCode,
      @StringJson() String reason,
      @StringOrNullJson() String? note,
      @StringOrNullJson()
      @JsonKey(name: 'rejection_reason')
      String? rejectionReason,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'seller_response_deadline')
      DateTime? sellerResponseDeadline,
      @ServerDateTimeJson()
      @JsonKey(name: 'resolved_at')
      DateTime? resolvedAt});
}

/// @nodoc
class _$CancellationRequestModelCopyWithImpl<$Res>
    implements $CancellationRequestModelCopyWith<$Res> {
  _$CancellationRequestModelCopyWithImpl(this._self, this._then);

  final CancellationRequestModel _self;
  final $Res Function(CancellationRequestModel) _then;

  /// Create a copy of CancellationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statusCode = null,
    Object? reason = null,
    Object? note = freezed,
    Object? rejectionReason = freezed,
    Object? createdAt = freezed,
    Object? sellerResponseDeadline = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _self.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sellerResponseDeadline: freezed == sellerResponseDeadline
          ? _self.sellerResponseDeadline
          : sellerResponseDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _self.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CancellationRequestModel].
extension CancellationRequestModelPatterns on CancellationRequestModel {
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
    TResult Function(_CancellationRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CancellationRequestModel() when $default != null:
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
    TResult Function(_CancellationRequestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CancellationRequestModel():
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
    TResult? Function(_CancellationRequestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CancellationRequestModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @StringJson() String reason,
            @StringOrNullJson() String? note,
            @StringOrNullJson()
            @JsonKey(name: 'rejection_reason')
            String? rejectionReason,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'seller_response_deadline')
            DateTime? sellerResponseDeadline,
            @ServerDateTimeJson()
            @JsonKey(name: 'resolved_at')
            DateTime? resolvedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CancellationRequestModel() when $default != null:
        return $default(
            _that.id,
            _that.statusCode,
            _that.reason,
            _that.note,
            _that.rejectionReason,
            _that.createdAt,
            _that.sellerResponseDeadline,
            _that.resolvedAt);
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
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @StringJson() String reason,
            @StringOrNullJson() String? note,
            @StringOrNullJson()
            @JsonKey(name: 'rejection_reason')
            String? rejectionReason,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'seller_response_deadline')
            DateTime? sellerResponseDeadline,
            @ServerDateTimeJson()
            @JsonKey(name: 'resolved_at')
            DateTime? resolvedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CancellationRequestModel():
        return $default(
            _that.id,
            _that.statusCode,
            _that.reason,
            _that.note,
            _that.rejectionReason,
            _that.createdAt,
            _that.sellerResponseDeadline,
            _that.resolvedAt);
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
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @StringJson() String reason,
            @StringOrNullJson() String? note,
            @StringOrNullJson()
            @JsonKey(name: 'rejection_reason')
            String? rejectionReason,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'seller_response_deadline')
            DateTime? sellerResponseDeadline,
            @ServerDateTimeJson()
            @JsonKey(name: 'resolved_at')
            DateTime? resolvedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CancellationRequestModel() when $default != null:
        return $default(
            _that.id,
            _that.statusCode,
            _that.reason,
            _that.note,
            _that.rejectionReason,
            _that.createdAt,
            _that.sellerResponseDeadline,
            _that.resolvedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CancellationRequestModel extends CancellationRequestModel {
  const _CancellationRequestModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'status') this.statusCode = 'pending',
      @StringJson() this.reason = '',
      @StringOrNullJson() this.note,
      @StringOrNullJson()
      @JsonKey(name: 'rejection_reason')
      this.rejectionReason,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'seller_response_deadline')
      this.sellerResponseDeadline,
      @ServerDateTimeJson() @JsonKey(name: 'resolved_at') this.resolvedAt})
      : super._();
  factory _CancellationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CancellationRequestModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringJson()
  @JsonKey(name: 'status')
  final String statusCode;

  /// Kode [CancellationReason].
  @override
  @JsonKey()
  @StringJson()
  final String reason;
  @override
  @StringOrNullJson()
  final String? note;

  /// Diisi penjual saat menolak.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Batas waktu penjual menjawab (desain: "1x24 jam").
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'seller_response_deadline')
  final DateTime? sellerResponseDeadline;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'resolved_at')
  final DateTime? resolvedAt;

  /// Create a copy of CancellationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CancellationRequestModelCopyWith<_CancellationRequestModel> get copyWith =>
      __$CancellationRequestModelCopyWithImpl<_CancellationRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CancellationRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CancellationRequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sellerResponseDeadline, sellerResponseDeadline) ||
                other.sellerResponseDeadline == sellerResponseDeadline) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, statusCode, reason, note,
      rejectionReason, createdAt, sellerResponseDeadline, resolvedAt);

  @override
  String toString() {
    return 'CancellationRequestModel(id: $id, statusCode: $statusCode, reason: $reason, note: $note, rejectionReason: $rejectionReason, createdAt: $createdAt, sellerResponseDeadline: $sellerResponseDeadline, resolvedAt: $resolvedAt)';
  }
}

/// @nodoc
abstract mixin class _$CancellationRequestModelCopyWith<$Res>
    implements $CancellationRequestModelCopyWith<$Res> {
  factory _$CancellationRequestModelCopyWith(_CancellationRequestModel value,
          $Res Function(_CancellationRequestModel) _then) =
      __$CancellationRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'status') String statusCode,
      @StringJson() String reason,
      @StringOrNullJson() String? note,
      @StringOrNullJson()
      @JsonKey(name: 'rejection_reason')
      String? rejectionReason,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'seller_response_deadline')
      DateTime? sellerResponseDeadline,
      @ServerDateTimeJson()
      @JsonKey(name: 'resolved_at')
      DateTime? resolvedAt});
}

/// @nodoc
class __$CancellationRequestModelCopyWithImpl<$Res>
    implements _$CancellationRequestModelCopyWith<$Res> {
  __$CancellationRequestModelCopyWithImpl(this._self, this._then);

  final _CancellationRequestModel _self;
  final $Res Function(_CancellationRequestModel) _then;

  /// Create a copy of CancellationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? statusCode = null,
    Object? reason = null,
    Object? note = freezed,
    Object? rejectionReason = freezed,
    Object? createdAt = freezed,
    Object? sellerResponseDeadline = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(_CancellationRequestModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _self.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sellerResponseDeadline: freezed == sellerResponseDeadline
          ? _self.sellerResponseDeadline
          : sellerResponseDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _self.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$InsurancePolicyModel {
  @IntJson()
  int get id;

  /// `basic` atau `secure_plus`.
  @StringJson()
  String get tier;
  @DoubleJson()
  @JsonKey(name: 'premium_amount')
  double get premiumAmount;
  @DoubleOrNullJson()
  @JsonKey(name: 'coverage_amount')
  double? get coverageAmount;

  /// `active`, `claimed`, `expired`. Balasan opt-in tidak membawanya —
  /// polis yang baru dibuat selalu `active` (default kolom).
  @StringJson()
  String get status;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of InsurancePolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InsurancePolicyModelCopyWith<InsurancePolicyModel> get copyWith =>
      _$InsurancePolicyModelCopyWithImpl<InsurancePolicyModel>(
          this as InsurancePolicyModel, _$identity);

  /// Serializes this InsurancePolicyModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InsurancePolicyModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.premiumAmount, premiumAmount) ||
                other.premiumAmount == premiumAmount) &&
            (identical(other.coverageAmount, coverageAmount) ||
                other.coverageAmount == coverageAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tier, premiumAmount, coverageAmount, status, createdAt);

  @override
  String toString() {
    return 'InsurancePolicyModel(id: $id, tier: $tier, premiumAmount: $premiumAmount, coverageAmount: $coverageAmount, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $InsurancePolicyModelCopyWith<$Res> {
  factory $InsurancePolicyModelCopyWith(InsurancePolicyModel value,
          $Res Function(InsurancePolicyModel) _then) =
      _$InsurancePolicyModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String tier,
      @DoubleJson() @JsonKey(name: 'premium_amount') double premiumAmount,
      @DoubleOrNullJson()
      @JsonKey(name: 'coverage_amount')
      double? coverageAmount,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$InsurancePolicyModelCopyWithImpl<$Res>
    implements $InsurancePolicyModelCopyWith<$Res> {
  _$InsurancePolicyModelCopyWithImpl(this._self, this._then);

  final InsurancePolicyModel _self;
  final $Res Function(InsurancePolicyModel) _then;

  /// Create a copy of InsurancePolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tier = null,
    Object? premiumAmount = null,
    Object? coverageAmount = freezed,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      premiumAmount: null == premiumAmount
          ? _self.premiumAmount
          : premiumAmount // ignore: cast_nullable_to_non_nullable
              as double,
      coverageAmount: freezed == coverageAmount
          ? _self.coverageAmount
          : coverageAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [InsurancePolicyModel].
extension InsurancePolicyModelPatterns on InsurancePolicyModel {
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
    TResult Function(_InsurancePolicyModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyModel() when $default != null:
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
    TResult Function(_InsurancePolicyModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyModel():
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
    TResult? Function(_InsurancePolicyModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyModel() when $default != null:
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
            @StringJson() String tier,
            @DoubleJson() @JsonKey(name: 'premium_amount') double premiumAmount,
            @DoubleOrNullJson()
            @JsonKey(name: 'coverage_amount')
            double? coverageAmount,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyModel() when $default != null:
        return $default(_that.id, _that.tier, _that.premiumAmount,
            _that.coverageAmount, _that.status, _that.createdAt);
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
            @StringJson() String tier,
            @DoubleJson() @JsonKey(name: 'premium_amount') double premiumAmount,
            @DoubleOrNullJson()
            @JsonKey(name: 'coverage_amount')
            double? coverageAmount,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyModel():
        return $default(_that.id, _that.tier, _that.premiumAmount,
            _that.coverageAmount, _that.status, _that.createdAt);
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
            @StringJson() String tier,
            @DoubleJson() @JsonKey(name: 'premium_amount') double premiumAmount,
            @DoubleOrNullJson()
            @JsonKey(name: 'coverage_amount')
            double? coverageAmount,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InsurancePolicyModel() when $default != null:
        return $default(_that.id, _that.tier, _that.premiumAmount,
            _that.coverageAmount, _that.status, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _InsurancePolicyModel extends InsurancePolicyModel {
  const _InsurancePolicyModel(
      {@IntJson() this.id = 0,
      @StringJson() this.tier = 'basic',
      @DoubleJson() @JsonKey(name: 'premium_amount') this.premiumAmount = 0,
      @DoubleOrNullJson() @JsonKey(name: 'coverage_amount') this.coverageAmount,
      @StringJson() this.status = 'active',
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _InsurancePolicyModel.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int id;

  /// `basic` atau `secure_plus`.
  @override
  @JsonKey()
  @StringJson()
  final String tier;
  @override
  @DoubleJson()
  @JsonKey(name: 'premium_amount')
  final double premiumAmount;
  @override
  @DoubleOrNullJson()
  @JsonKey(name: 'coverage_amount')
  final double? coverageAmount;

  /// `active`, `claimed`, `expired`. Balasan opt-in tidak membawanya —
  /// polis yang baru dibuat selalu `active` (default kolom).
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of InsurancePolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InsurancePolicyModelCopyWith<_InsurancePolicyModel> get copyWith =>
      __$InsurancePolicyModelCopyWithImpl<_InsurancePolicyModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InsurancePolicyModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InsurancePolicyModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.premiumAmount, premiumAmount) ||
                other.premiumAmount == premiumAmount) &&
            (identical(other.coverageAmount, coverageAmount) ||
                other.coverageAmount == coverageAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tier, premiumAmount, coverageAmount, status, createdAt);

  @override
  String toString() {
    return 'InsurancePolicyModel(id: $id, tier: $tier, premiumAmount: $premiumAmount, coverageAmount: $coverageAmount, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$InsurancePolicyModelCopyWith<$Res>
    implements $InsurancePolicyModelCopyWith<$Res> {
  factory _$InsurancePolicyModelCopyWith(_InsurancePolicyModel value,
          $Res Function(_InsurancePolicyModel) _then) =
      __$InsurancePolicyModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String tier,
      @DoubleJson() @JsonKey(name: 'premium_amount') double premiumAmount,
      @DoubleOrNullJson()
      @JsonKey(name: 'coverage_amount')
      double? coverageAmount,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$InsurancePolicyModelCopyWithImpl<$Res>
    implements _$InsurancePolicyModelCopyWith<$Res> {
  __$InsurancePolicyModelCopyWithImpl(this._self, this._then);

  final _InsurancePolicyModel _self;
  final $Res Function(_InsurancePolicyModel) _then;

  /// Create a copy of InsurancePolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? tier = null,
    Object? premiumAmount = null,
    Object? coverageAmount = freezed,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_InsurancePolicyModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      premiumAmount: null == premiumAmount
          ? _self.premiumAmount
          : premiumAmount // ignore: cast_nullable_to_non_nullable
              as double,
      coverageAmount: freezed == coverageAmount
          ? _self.coverageAmount
          : coverageAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$MediaUploadModel {
  @StringJson()
  String get url;
  @StringJson()
  @JsonKey(name: 'file_name')
  String get fileName;
  @DoubleJson()
  @JsonKey(name: 'file_size_kb')
  double get fileSizeKb;
  @StringJson()
  @JsonKey(name: 'mime_type')
  String get mimeType;

  /// Create a copy of MediaUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaUploadModelCopyWith<MediaUploadModel> get copyWith =>
      _$MediaUploadModelCopyWithImpl<MediaUploadModel>(
          this as MediaUploadModel, _$identity);

  /// Serializes this MediaUploadModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaUploadModel &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSizeKb, fileSizeKb) ||
                other.fileSizeKb == fileSizeKb) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, url, fileName, fileSizeKb, mimeType);

  @override
  String toString() {
    return 'MediaUploadModel(url: $url, fileName: $fileName, fileSizeKb: $fileSizeKb, mimeType: $mimeType)';
  }
}

/// @nodoc
abstract mixin class $MediaUploadModelCopyWith<$Res> {
  factory $MediaUploadModelCopyWith(
          MediaUploadModel value, $Res Function(MediaUploadModel) _then) =
      _$MediaUploadModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() String url,
      @StringJson() @JsonKey(name: 'file_name') String fileName,
      @DoubleJson() @JsonKey(name: 'file_size_kb') double fileSizeKb,
      @StringJson() @JsonKey(name: 'mime_type') String mimeType});
}

/// @nodoc
class _$MediaUploadModelCopyWithImpl<$Res>
    implements $MediaUploadModelCopyWith<$Res> {
  _$MediaUploadModelCopyWithImpl(this._self, this._then);

  final MediaUploadModel _self;
  final $Res Function(MediaUploadModel) _then;

  /// Create a copy of MediaUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? fileName = null,
    Object? fileSizeKb = null,
    Object? mimeType = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeKb: null == fileSizeKb
          ? _self.fileSizeKb
          : fileSizeKb // ignore: cast_nullable_to_non_nullable
              as double,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaUploadModel].
extension MediaUploadModelPatterns on MediaUploadModel {
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
    TResult Function(_MediaUploadModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaUploadModel() when $default != null:
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
    TResult Function(_MediaUploadModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaUploadModel():
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
    TResult? Function(_MediaUploadModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaUploadModel() when $default != null:
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
            @StringJson() String url,
            @StringJson() @JsonKey(name: 'file_name') String fileName,
            @DoubleJson() @JsonKey(name: 'file_size_kb') double fileSizeKb,
            @StringJson() @JsonKey(name: 'mime_type') String mimeType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaUploadModel() when $default != null:
        return $default(
            _that.url, _that.fileName, _that.fileSizeKb, _that.mimeType);
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
            @StringJson() String url,
            @StringJson() @JsonKey(name: 'file_name') String fileName,
            @DoubleJson() @JsonKey(name: 'file_size_kb') double fileSizeKb,
            @StringJson() @JsonKey(name: 'mime_type') String mimeType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaUploadModel():
        return $default(
            _that.url, _that.fileName, _that.fileSizeKb, _that.mimeType);
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
            @StringJson() String url,
            @StringJson() @JsonKey(name: 'file_name') String fileName,
            @DoubleJson() @JsonKey(name: 'file_size_kb') double fileSizeKb,
            @StringJson() @JsonKey(name: 'mime_type') String mimeType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaUploadModel() when $default != null:
        return $default(
            _that.url, _that.fileName, _that.fileSizeKb, _that.mimeType);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MediaUploadModel extends MediaUploadModel {
  const _MediaUploadModel(
      {@StringJson() this.url = '',
      @StringJson() @JsonKey(name: 'file_name') this.fileName = '',
      @DoubleJson() @JsonKey(name: 'file_size_kb') this.fileSizeKb = 0,
      @StringJson() @JsonKey(name: 'mime_type') this.mimeType = ''})
      : super._();
  factory _MediaUploadModel.fromJson(Map<String, dynamic> json) =>
      _$MediaUploadModelFromJson(json);

  @override
  @JsonKey()
  @StringJson()
  final String url;
  @override
  @StringJson()
  @JsonKey(name: 'file_name')
  final String fileName;
  @override
  @DoubleJson()
  @JsonKey(name: 'file_size_kb')
  final double fileSizeKb;
  @override
  @StringJson()
  @JsonKey(name: 'mime_type')
  final String mimeType;

  /// Create a copy of MediaUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaUploadModelCopyWith<_MediaUploadModel> get copyWith =>
      __$MediaUploadModelCopyWithImpl<_MediaUploadModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaUploadModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaUploadModel &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSizeKb, fileSizeKb) ||
                other.fileSizeKb == fileSizeKb) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, url, fileName, fileSizeKb, mimeType);

  @override
  String toString() {
    return 'MediaUploadModel(url: $url, fileName: $fileName, fileSizeKb: $fileSizeKb, mimeType: $mimeType)';
  }
}

/// @nodoc
abstract mixin class _$MediaUploadModelCopyWith<$Res>
    implements $MediaUploadModelCopyWith<$Res> {
  factory _$MediaUploadModelCopyWith(
          _MediaUploadModel value, $Res Function(_MediaUploadModel) _then) =
      __$MediaUploadModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() String url,
      @StringJson() @JsonKey(name: 'file_name') String fileName,
      @DoubleJson() @JsonKey(name: 'file_size_kb') double fileSizeKb,
      @StringJson() @JsonKey(name: 'mime_type') String mimeType});
}

/// @nodoc
class __$MediaUploadModelCopyWithImpl<$Res>
    implements _$MediaUploadModelCopyWith<$Res> {
  __$MediaUploadModelCopyWithImpl(this._self, this._then);

  final _MediaUploadModel _self;
  final $Res Function(_MediaUploadModel) _then;

  /// Create a copy of MediaUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? fileName = null,
    Object? fileSizeKb = null,
    Object? mimeType = null,
  }) {
    return _then(_MediaUploadModel(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeKb: null == fileSizeKb
          ? _self.fileSizeKb
          : fileSizeKb // ignore: cast_nullable_to_non_nullable
              as double,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
