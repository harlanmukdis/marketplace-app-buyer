// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentMethodModel {
  @StringJson()
  String get code;
  @StringJson()
  String get name;

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaymentMethodModelCopyWith<PaymentMethodModel> get copyWith =>
      _$PaymentMethodModelCopyWithImpl<PaymentMethodModel>(
          this as PaymentMethodModel, _$identity);

  /// Serializes this PaymentMethodModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaymentMethodModel &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, name);

  @override
  String toString() {
    return 'PaymentMethodModel(code: $code, name: $name)';
  }
}

/// @nodoc
abstract mixin class $PaymentMethodModelCopyWith<$Res> {
  factory $PaymentMethodModelCopyWith(
          PaymentMethodModel value, $Res Function(PaymentMethodModel) _then) =
      _$PaymentMethodModelCopyWithImpl;
  @useResult
  $Res call({@StringJson() String code, @StringJson() String name});
}

/// @nodoc
class _$PaymentMethodModelCopyWithImpl<$Res>
    implements $PaymentMethodModelCopyWith<$Res> {
  _$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final PaymentMethodModel _self;
  final $Res Function(PaymentMethodModel) _then;

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PaymentMethodModel].
extension PaymentMethodModelPatterns on PaymentMethodModel {
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
    TResult Function(_PaymentMethodModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaymentMethodModel() when $default != null:
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
    TResult Function(_PaymentMethodModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentMethodModel():
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
    TResult? Function(_PaymentMethodModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentMethodModel() when $default != null:
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
    TResult Function(@StringJson() String code, @StringJson() String name)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaymentMethodModel() when $default != null:
        return $default(_that.code, _that.name);
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
    TResult Function(@StringJson() String code, @StringJson() String name)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentMethodModel():
        return $default(_that.code, _that.name);
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
    TResult? Function(@StringJson() String code, @StringJson() String name)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentMethodModel() when $default != null:
        return $default(_that.code, _that.name);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PaymentMethodModel implements PaymentMethodModel {
  const _PaymentMethodModel(
      {@StringJson() this.code = '', @StringJson() this.name = ''});
  factory _PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  @override
  @JsonKey()
  @StringJson()
  final String code;
  @override
  @JsonKey()
  @StringJson()
  final String name;

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaymentMethodModelCopyWith<_PaymentMethodModel> get copyWith =>
      __$PaymentMethodModelCopyWithImpl<_PaymentMethodModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PaymentMethodModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaymentMethodModel &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, name);

  @override
  String toString() {
    return 'PaymentMethodModel(code: $code, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$PaymentMethodModelCopyWith<$Res>
    implements $PaymentMethodModelCopyWith<$Res> {
  factory _$PaymentMethodModelCopyWith(
          _PaymentMethodModel value, $Res Function(_PaymentMethodModel) _then) =
      __$PaymentMethodModelCopyWithImpl;
  @override
  @useResult
  $Res call({@StringJson() String code, @StringJson() String name});
}

/// @nodoc
class __$PaymentMethodModelCopyWithImpl<$Res>
    implements _$PaymentMethodModelCopyWith<$Res> {
  __$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final _PaymentMethodModel _self;
  final $Res Function(_PaymentMethodModel) _then;

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? name = null,
  }) {
    return _then(_PaymentMethodModel(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PaymentModel {
  @IntJson()
  int get id;
  @StringOrNullJson()
  @JsonKey(name: 'checkout_session_id')
  String? get checkoutSessionId;
  @StringJson()
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @StringOrNullJson()
  String? get provider;
  @StringOrNullJson()
  @JsonKey(name: 'provider_reference')
  String? get providerReference;
  @DoubleJson()
  double get amount;

  /// `pending` / `paid` / `expired` / `failed`.
  @StringJson()
  String get status;
  @ServerDateTimeJson()
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;

  /// **UTC** — seperti `expires_at` checkout, dan berbeda dari [createdAt]
  /// di respons yang sama.
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expired_at')
  DateTime? get expiredAt;

  /// **Waktu dinding server (WIB).**
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      _$PaymentModelCopyWithImpl<PaymentModel>(
          this as PaymentModel, _$identity);

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaymentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.checkoutSessionId, checkoutSessionId) ||
                other.checkoutSessionId == checkoutSessionId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerReference, providerReference) ||
                other.providerReference == providerReference) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.expiredAt, expiredAt) ||
                other.expiredAt == expiredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      checkoutSessionId,
      paymentMethod,
      provider,
      providerReference,
      amount,
      status,
      paidAt,
      expiredAt,
      createdAt);

  @override
  String toString() {
    return 'PaymentModel(id: $id, checkoutSessionId: $checkoutSessionId, paymentMethod: $paymentMethod, provider: $provider, providerReference: $providerReference, amount: $amount, status: $status, paidAt: $paidAt, expiredAt: $expiredAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) _then) =
      _$PaymentModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringOrNullJson()
      @JsonKey(name: 'checkout_session_id')
      String? checkoutSessionId,
      @StringJson() @JsonKey(name: 'payment_method') String paymentMethod,
      @StringOrNullJson() String? provider,
      @StringOrNullJson()
      @JsonKey(name: 'provider_reference')
      String? providerReference,
      @DoubleJson() double amount,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'paid_at') DateTime? paidAt,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expired_at') DateTime? expiredAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res> implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._self, this._then);

  final PaymentModel _self;
  final $Res Function(PaymentModel) _then;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? checkoutSessionId = freezed,
    Object? paymentMethod = null,
    Object? provider = freezed,
    Object? providerReference = freezed,
    Object? amount = null,
    Object? status = null,
    Object? paidAt = freezed,
    Object? expiredAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      checkoutSessionId: freezed == checkoutSessionId
          ? _self.checkoutSessionId
          : checkoutSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      provider: freezed == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerReference: freezed == providerReference
          ? _self.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAt: freezed == paidAt
          ? _self.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiredAt: freezed == expiredAt
          ? _self.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PaymentModel].
extension PaymentModelPatterns on PaymentModel {
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
    TResult Function(_PaymentModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaymentModel() when $default != null:
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
    TResult Function(_PaymentModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentModel():
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
    TResult? Function(_PaymentModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentModel() when $default != null:
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
            @JsonKey(name: 'checkout_session_id')
            String? checkoutSessionId,
            @StringJson() @JsonKey(name: 'payment_method') String paymentMethod,
            @StringOrNullJson() String? provider,
            @StringOrNullJson()
            @JsonKey(name: 'provider_reference')
            String? providerReference,
            @DoubleJson() double amount,
            @StringJson() String status,
            @ServerDateTimeJson() @JsonKey(name: 'paid_at') DateTime? paidAt,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expired_at')
            DateTime? expiredAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaymentModel() when $default != null:
        return $default(
            _that.id,
            _that.checkoutSessionId,
            _that.paymentMethod,
            _that.provider,
            _that.providerReference,
            _that.amount,
            _that.status,
            _that.paidAt,
            _that.expiredAt,
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
            @JsonKey(name: 'checkout_session_id')
            String? checkoutSessionId,
            @StringJson() @JsonKey(name: 'payment_method') String paymentMethod,
            @StringOrNullJson() String? provider,
            @StringOrNullJson()
            @JsonKey(name: 'provider_reference')
            String? providerReference,
            @DoubleJson() double amount,
            @StringJson() String status,
            @ServerDateTimeJson() @JsonKey(name: 'paid_at') DateTime? paidAt,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expired_at')
            DateTime? expiredAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentModel():
        return $default(
            _that.id,
            _that.checkoutSessionId,
            _that.paymentMethod,
            _that.provider,
            _that.providerReference,
            _that.amount,
            _that.status,
            _that.paidAt,
            _that.expiredAt,
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
            @JsonKey(name: 'checkout_session_id')
            String? checkoutSessionId,
            @StringJson() @JsonKey(name: 'payment_method') String paymentMethod,
            @StringOrNullJson() String? provider,
            @StringOrNullJson()
            @JsonKey(name: 'provider_reference')
            String? providerReference,
            @DoubleJson() double amount,
            @StringJson() String status,
            @ServerDateTimeJson() @JsonKey(name: 'paid_at') DateTime? paidAt,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expired_at')
            DateTime? expiredAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentModel() when $default != null:
        return $default(
            _that.id,
            _that.checkoutSessionId,
            _that.paymentMethod,
            _that.provider,
            _that.providerReference,
            _that.amount,
            _that.status,
            _that.paidAt,
            _that.expiredAt,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PaymentModel extends PaymentModel {
  const _PaymentModel(
      {@IntJson() required this.id,
      @StringOrNullJson()
      @JsonKey(name: 'checkout_session_id')
      this.checkoutSessionId,
      @StringJson() @JsonKey(name: 'payment_method') this.paymentMethod = '',
      @StringOrNullJson() this.provider,
      @StringOrNullJson()
      @JsonKey(name: 'provider_reference')
      this.providerReference,
      @DoubleJson() this.amount = 0,
      @StringJson() this.status = '',
      @ServerDateTimeJson() @JsonKey(name: 'paid_at') this.paidAt,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expired_at') this.expiredAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'checkout_session_id')
  final String? checkoutSessionId;
  @override
  @StringJson()
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @StringOrNullJson()
  final String? provider;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'provider_reference')
  final String? providerReference;
  @override
  @JsonKey()
  @DoubleJson()
  final double amount;

  /// `pending` / `paid` / `expired` / `failed`.
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;

  /// **UTC** — seperti `expires_at` checkout, dan berbeda dari [createdAt]
  /// di respons yang sama.
  @override
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expired_at')
  final DateTime? expiredAt;

  /// **Waktu dinding server (WIB).**
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaymentModelCopyWith<_PaymentModel> get copyWith =>
      __$PaymentModelCopyWithImpl<_PaymentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PaymentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaymentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.checkoutSessionId, checkoutSessionId) ||
                other.checkoutSessionId == checkoutSessionId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerReference, providerReference) ||
                other.providerReference == providerReference) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.expiredAt, expiredAt) ||
                other.expiredAt == expiredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      checkoutSessionId,
      paymentMethod,
      provider,
      providerReference,
      amount,
      status,
      paidAt,
      expiredAt,
      createdAt);

  @override
  String toString() {
    return 'PaymentModel(id: $id, checkoutSessionId: $checkoutSessionId, paymentMethod: $paymentMethod, provider: $provider, providerReference: $providerReference, amount: $amount, status: $status, paidAt: $paidAt, expiredAt: $expiredAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$PaymentModelCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$PaymentModelCopyWith(
          _PaymentModel value, $Res Function(_PaymentModel) _then) =
      __$PaymentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringOrNullJson()
      @JsonKey(name: 'checkout_session_id')
      String? checkoutSessionId,
      @StringJson() @JsonKey(name: 'payment_method') String paymentMethod,
      @StringOrNullJson() String? provider,
      @StringOrNullJson()
      @JsonKey(name: 'provider_reference')
      String? providerReference,
      @DoubleJson() double amount,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'paid_at') DateTime? paidAt,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expired_at') DateTime? expiredAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$PaymentModelCopyWithImpl<$Res>
    implements _$PaymentModelCopyWith<$Res> {
  __$PaymentModelCopyWithImpl(this._self, this._then);

  final _PaymentModel _self;
  final $Res Function(_PaymentModel) _then;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? checkoutSessionId = freezed,
    Object? paymentMethod = null,
    Object? provider = freezed,
    Object? providerReference = freezed,
    Object? amount = null,
    Object? status = null,
    Object? paidAt = freezed,
    Object? expiredAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_PaymentModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      checkoutSessionId: freezed == checkoutSessionId
          ? _self.checkoutSessionId
          : checkoutSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      provider: freezed == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerReference: freezed == providerReference
          ? _self.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAt: freezed == paidAt
          ? _self.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiredAt: freezed == expiredAt
          ? _self.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$PaymentInstructionModel {
  @StringOrNullJson()
  @JsonKey(name: 'qr_string')
  String? get qrString;
  @StringOrNullJson()
  @JsonKey(name: 'va_number')
  String? get vaNumber;
  @StringOrNullJson()
  String? get bank;

  /// **UTC.**
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;

  /// Create a copy of PaymentInstructionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaymentInstructionModelCopyWith<PaymentInstructionModel> get copyWith =>
      _$PaymentInstructionModelCopyWithImpl<PaymentInstructionModel>(
          this as PaymentInstructionModel, _$identity);

  /// Serializes this PaymentInstructionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaymentInstructionModel &&
            (identical(other.qrString, qrString) ||
                other.qrString == qrString) &&
            (identical(other.vaNumber, vaNumber) ||
                other.vaNumber == vaNumber) &&
            (identical(other.bank, bank) || other.bank == bank) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, qrString, vaNumber, bank, expiresAt);

  @override
  String toString() {
    return 'PaymentInstructionModel(qrString: $qrString, vaNumber: $vaNumber, bank: $bank, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class $PaymentInstructionModelCopyWith<$Res> {
  factory $PaymentInstructionModelCopyWith(PaymentInstructionModel value,
          $Res Function(PaymentInstructionModel) _then) =
      _$PaymentInstructionModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringOrNullJson() @JsonKey(name: 'qr_string') String? qrString,
      @StringOrNullJson() @JsonKey(name: 'va_number') String? vaNumber,
      @StringOrNullJson() String? bank,
      @ServerUtcDateTimeJson()
      @JsonKey(name: 'expires_at')
      DateTime? expiresAt});
}

/// @nodoc
class _$PaymentInstructionModelCopyWithImpl<$Res>
    implements $PaymentInstructionModelCopyWith<$Res> {
  _$PaymentInstructionModelCopyWithImpl(this._self, this._then);

  final PaymentInstructionModel _self;
  final $Res Function(PaymentInstructionModel) _then;

  /// Create a copy of PaymentInstructionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrString = freezed,
    Object? vaNumber = freezed,
    Object? bank = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_self.copyWith(
      qrString: freezed == qrString
          ? _self.qrString
          : qrString // ignore: cast_nullable_to_non_nullable
              as String?,
      vaNumber: freezed == vaNumber
          ? _self.vaNumber
          : vaNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bank: freezed == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PaymentInstructionModel].
extension PaymentInstructionModelPatterns on PaymentInstructionModel {
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
    TResult Function(_PaymentInstructionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaymentInstructionModel() when $default != null:
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
    TResult Function(_PaymentInstructionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentInstructionModel():
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
    TResult? Function(_PaymentInstructionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentInstructionModel() when $default != null:
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
            @StringOrNullJson() @JsonKey(name: 'qr_string') String? qrString,
            @StringOrNullJson() @JsonKey(name: 'va_number') String? vaNumber,
            @StringOrNullJson() String? bank,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaymentInstructionModel() when $default != null:
        return $default(
            _that.qrString, _that.vaNumber, _that.bank, _that.expiresAt);
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
            @StringOrNullJson() @JsonKey(name: 'qr_string') String? qrString,
            @StringOrNullJson() @JsonKey(name: 'va_number') String? vaNumber,
            @StringOrNullJson() String? bank,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentInstructionModel():
        return $default(
            _that.qrString, _that.vaNumber, _that.bank, _that.expiresAt);
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
            @StringOrNullJson() @JsonKey(name: 'qr_string') String? qrString,
            @StringOrNullJson() @JsonKey(name: 'va_number') String? vaNumber,
            @StringOrNullJson() String? bank,
            @ServerUtcDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaymentInstructionModel() when $default != null:
        return $default(
            _that.qrString, _that.vaNumber, _that.bank, _that.expiresAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PaymentInstructionModel extends PaymentInstructionModel {
  const _PaymentInstructionModel(
      {@StringOrNullJson() @JsonKey(name: 'qr_string') this.qrString,
      @StringOrNullJson() @JsonKey(name: 'va_number') this.vaNumber,
      @StringOrNullJson() this.bank,
      @ServerUtcDateTimeJson() @JsonKey(name: 'expires_at') this.expiresAt})
      : super._();
  factory _PaymentInstructionModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInstructionModelFromJson(json);

  @override
  @StringOrNullJson()
  @JsonKey(name: 'qr_string')
  final String? qrString;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'va_number')
  final String? vaNumber;
  @override
  @StringOrNullJson()
  final String? bank;

  /// **UTC.**
  @override
  @ServerUtcDateTimeJson()
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  /// Create a copy of PaymentInstructionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaymentInstructionModelCopyWith<_PaymentInstructionModel> get copyWith =>
      __$PaymentInstructionModelCopyWithImpl<_PaymentInstructionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PaymentInstructionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaymentInstructionModel &&
            (identical(other.qrString, qrString) ||
                other.qrString == qrString) &&
            (identical(other.vaNumber, vaNumber) ||
                other.vaNumber == vaNumber) &&
            (identical(other.bank, bank) || other.bank == bank) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, qrString, vaNumber, bank, expiresAt);

  @override
  String toString() {
    return 'PaymentInstructionModel(qrString: $qrString, vaNumber: $vaNumber, bank: $bank, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class _$PaymentInstructionModelCopyWith<$Res>
    implements $PaymentInstructionModelCopyWith<$Res> {
  factory _$PaymentInstructionModelCopyWith(_PaymentInstructionModel value,
          $Res Function(_PaymentInstructionModel) _then) =
      __$PaymentInstructionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringOrNullJson() @JsonKey(name: 'qr_string') String? qrString,
      @StringOrNullJson() @JsonKey(name: 'va_number') String? vaNumber,
      @StringOrNullJson() String? bank,
      @ServerUtcDateTimeJson()
      @JsonKey(name: 'expires_at')
      DateTime? expiresAt});
}

/// @nodoc
class __$PaymentInstructionModelCopyWithImpl<$Res>
    implements _$PaymentInstructionModelCopyWith<$Res> {
  __$PaymentInstructionModelCopyWithImpl(this._self, this._then);

  final _PaymentInstructionModel _self;
  final $Res Function(_PaymentInstructionModel) _then;

  /// Create a copy of PaymentInstructionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? qrString = freezed,
    Object? vaNumber = freezed,
    Object? bank = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_PaymentInstructionModel(
      qrString: freezed == qrString
          ? _self.qrString
          : qrString // ignore: cast_nullable_to_non_nullable
              as String?,
      vaNumber: freezed == vaNumber
          ? _self.vaNumber
          : vaNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bank: freezed == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
