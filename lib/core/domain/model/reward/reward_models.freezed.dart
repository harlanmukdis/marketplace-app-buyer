// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewardBalanceModel {
  @IntJson()
  int get id;
  @IntJson()
  int get balance;
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of RewardBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RewardBalanceModelCopyWith<RewardBalanceModel> get copyWith =>
      _$RewardBalanceModelCopyWithImpl<RewardBalanceModel>(
          this as RewardBalanceModel, _$identity);

  /// Serializes this RewardBalanceModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RewardBalanceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, balance, updatedAt);

  @override
  String toString() {
    return 'RewardBalanceModel(id: $id, balance: $balance, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $RewardBalanceModelCopyWith<$Res> {
  factory $RewardBalanceModelCopyWith(
          RewardBalanceModel value, $Res Function(RewardBalanceModel) _then) =
      _$RewardBalanceModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() int balance,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$RewardBalanceModelCopyWithImpl<$Res>
    implements $RewardBalanceModelCopyWith<$Res> {
  _$RewardBalanceModelCopyWithImpl(this._self, this._then);

  final RewardBalanceModel _self;
  final $Res Function(RewardBalanceModel) _then;

  /// Create a copy of RewardBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? balance = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RewardBalanceModel].
extension RewardBalanceModelPatterns on RewardBalanceModel {
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
    TResult Function(_RewardBalanceModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RewardBalanceModel() when $default != null:
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
    TResult Function(_RewardBalanceModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBalanceModel():
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
    TResult? Function(_RewardBalanceModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBalanceModel() when $default != null:
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
            @IntJson() int balance,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RewardBalanceModel() when $default != null:
        return $default(_that.id, _that.balance, _that.updatedAt);
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
            @IntJson() int balance,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBalanceModel():
        return $default(_that.id, _that.balance, _that.updatedAt);
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
            @IntJson() int balance,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBalanceModel() when $default != null:
        return $default(_that.id, _that.balance, _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RewardBalanceModel extends RewardBalanceModel {
  const _RewardBalanceModel(
      {@IntJson() this.id = 0,
      @IntJson() this.balance = 0,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();
  factory _RewardBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$RewardBalanceModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int id;
  @override
  @JsonKey()
  @IntJson()
  final int balance;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Create a copy of RewardBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RewardBalanceModelCopyWith<_RewardBalanceModel> get copyWith =>
      __$RewardBalanceModelCopyWithImpl<_RewardBalanceModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RewardBalanceModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RewardBalanceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, balance, updatedAt);

  @override
  String toString() {
    return 'RewardBalanceModel(id: $id, balance: $balance, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$RewardBalanceModelCopyWith<$Res>
    implements $RewardBalanceModelCopyWith<$Res> {
  factory _$RewardBalanceModelCopyWith(
          _RewardBalanceModel value, $Res Function(_RewardBalanceModel) _then) =
      __$RewardBalanceModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() int balance,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$RewardBalanceModelCopyWithImpl<$Res>
    implements _$RewardBalanceModelCopyWith<$Res> {
  __$RewardBalanceModelCopyWithImpl(this._self, this._then);

  final _RewardBalanceModel _self;
  final $Res Function(_RewardBalanceModel) _then;

  /// Create a copy of RewardBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? balance = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_RewardBalanceModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$LoyaltyTierModel {
  @IntJson()
  int get id;

  /// `bronze` / `silver` / `gold` / `platinum`.
  @StringJson()
  String get code;
  @StringJson()
  String get name;
  @IntJson()
  @JsonKey(name: 'min_points')
  int get minPoints;

  /// Kolom `JSON` di database.
  ///
  /// ⚠️ **`null` untuk keempat tier yang di-seed**, jadi bentuk isinya belum
  /// pernah teramati. Dibaca lewat [JsonMapJson] supaya string berisi JSON
  /// maupun objek sungguhan sama-sama terserap — pola yang sama dengan
  /// kolom JSON lain di API ini.
  @JsonMapJson()
  Map<String, dynamic>? get benefits;

  /// Create a copy of LoyaltyTierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoyaltyTierModelCopyWith<LoyaltyTierModel> get copyWith =>
      _$LoyaltyTierModelCopyWithImpl<LoyaltyTierModel>(
          this as LoyaltyTierModel, _$identity);

  /// Serializes this LoyaltyTierModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoyaltyTierModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.minPoints, minPoints) ||
                other.minPoints == minPoints) &&
            const DeepCollectionEquality().equals(other.benefits, benefits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, minPoints,
      const DeepCollectionEquality().hash(benefits));

  @override
  String toString() {
    return 'LoyaltyTierModel(id: $id, code: $code, name: $name, minPoints: $minPoints, benefits: $benefits)';
  }
}

/// @nodoc
abstract mixin class $LoyaltyTierModelCopyWith<$Res> {
  factory $LoyaltyTierModelCopyWith(
          LoyaltyTierModel value, $Res Function(LoyaltyTierModel) _then) =
      _$LoyaltyTierModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String code,
      @StringJson() String name,
      @IntJson() @JsonKey(name: 'min_points') int minPoints,
      @JsonMapJson() Map<String, dynamic>? benefits});
}

/// @nodoc
class _$LoyaltyTierModelCopyWithImpl<$Res>
    implements $LoyaltyTierModelCopyWith<$Res> {
  _$LoyaltyTierModelCopyWithImpl(this._self, this._then);

  final LoyaltyTierModel _self;
  final $Res Function(LoyaltyTierModel) _then;

  /// Create a copy of LoyaltyTierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? minPoints = null,
    Object? benefits = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      minPoints: null == minPoints
          ? _self.minPoints
          : minPoints // ignore: cast_nullable_to_non_nullable
              as int,
      benefits: freezed == benefits
          ? _self.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LoyaltyTierModel].
extension LoyaltyTierModelPatterns on LoyaltyTierModel {
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
    TResult Function(_LoyaltyTierModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoyaltyTierModel() when $default != null:
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
    TResult Function(_LoyaltyTierModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyTierModel():
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
    TResult? Function(_LoyaltyTierModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyTierModel() when $default != null:
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
            @StringJson() String code,
            @StringJson() String name,
            @IntJson() @JsonKey(name: 'min_points') int minPoints,
            @JsonMapJson() Map<String, dynamic>? benefits)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoyaltyTierModel() when $default != null:
        return $default(
            _that.id, _that.code, _that.name, _that.minPoints, _that.benefits);
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
            @StringJson() String code,
            @StringJson() String name,
            @IntJson() @JsonKey(name: 'min_points') int minPoints,
            @JsonMapJson() Map<String, dynamic>? benefits)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyTierModel():
        return $default(
            _that.id, _that.code, _that.name, _that.minPoints, _that.benefits);
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
            @StringJson() String code,
            @StringJson() String name,
            @IntJson() @JsonKey(name: 'min_points') int minPoints,
            @JsonMapJson() Map<String, dynamic>? benefits)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyTierModel() when $default != null:
        return $default(
            _that.id, _that.code, _that.name, _that.minPoints, _that.benefits);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LoyaltyTierModel extends LoyaltyTierModel {
  const _LoyaltyTierModel(
      {@IntJson() this.id = 0,
      @StringJson() this.code = '',
      @StringJson() this.name = '',
      @IntJson() @JsonKey(name: 'min_points') this.minPoints = 0,
      @JsonMapJson() final Map<String, dynamic>? benefits})
      : _benefits = benefits,
        super._();
  factory _LoyaltyTierModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyTierModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int id;

  /// `bronze` / `silver` / `gold` / `platinum`.
  @override
  @JsonKey()
  @StringJson()
  final String code;
  @override
  @JsonKey()
  @StringJson()
  final String name;
  @override
  @IntJson()
  @JsonKey(name: 'min_points')
  final int minPoints;

  /// Kolom `JSON` di database.
  ///
  /// ⚠️ **`null` untuk keempat tier yang di-seed**, jadi bentuk isinya belum
  /// pernah teramati. Dibaca lewat [JsonMapJson] supaya string berisi JSON
  /// maupun objek sungguhan sama-sama terserap — pola yang sama dengan
  /// kolom JSON lain di API ini.
  final Map<String, dynamic>? _benefits;

  /// Kolom `JSON` di database.
  ///
  /// ⚠️ **`null` untuk keempat tier yang di-seed**, jadi bentuk isinya belum
  /// pernah teramati. Dibaca lewat [JsonMapJson] supaya string berisi JSON
  /// maupun objek sungguhan sama-sama terserap — pola yang sama dengan
  /// kolom JSON lain di API ini.
  @override
  @JsonMapJson()
  Map<String, dynamic>? get benefits {
    final value = _benefits;
    if (value == null) return null;
    if (_benefits is EqualUnmodifiableMapView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of LoyaltyTierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoyaltyTierModelCopyWith<_LoyaltyTierModel> get copyWith =>
      __$LoyaltyTierModelCopyWithImpl<_LoyaltyTierModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoyaltyTierModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoyaltyTierModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.minPoints, minPoints) ||
                other.minPoints == minPoints) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, minPoints,
      const DeepCollectionEquality().hash(_benefits));

  @override
  String toString() {
    return 'LoyaltyTierModel(id: $id, code: $code, name: $name, minPoints: $minPoints, benefits: $benefits)';
  }
}

/// @nodoc
abstract mixin class _$LoyaltyTierModelCopyWith<$Res>
    implements $LoyaltyTierModelCopyWith<$Res> {
  factory _$LoyaltyTierModelCopyWith(
          _LoyaltyTierModel value, $Res Function(_LoyaltyTierModel) _then) =
      __$LoyaltyTierModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String code,
      @StringJson() String name,
      @IntJson() @JsonKey(name: 'min_points') int minPoints,
      @JsonMapJson() Map<String, dynamic>? benefits});
}

/// @nodoc
class __$LoyaltyTierModelCopyWithImpl<$Res>
    implements _$LoyaltyTierModelCopyWith<$Res> {
  __$LoyaltyTierModelCopyWithImpl(this._self, this._then);

  final _LoyaltyTierModel _self;
  final $Res Function(_LoyaltyTierModel) _then;

  /// Create a copy of LoyaltyTierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? minPoints = null,
    Object? benefits = freezed,
  }) {
    return _then(_LoyaltyTierModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      minPoints: null == minPoints
          ? _self.minPoints
          : minPoints // ignore: cast_nullable_to_non_nullable
              as int,
      benefits: freezed == benefits
          ? _self._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
mixin _$LoyaltyMembershipModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'loyalty_tier_id')
  int get tierId;

  /// Poin yang dihitung untuk **naik tingkat**, terpisah dari saldo poin
  /// yang bisa ditukar (`user_points.balance`). Keduanya bisa berbeda karena
  /// menukar poin tidak menurunkan tingkat.
  @IntJson()
  @JsonKey(name: 'tier_points')
  int get tierPoints;

  /// Masa berlaku tingkat, satu tahun sejak keanggotaan dibuat.
  ///
  /// Dulu field ini dikirim dalam UTC sementara [updatedAt] dalam WIB —
  /// pola yang sama dengan `expires_at` di checkout. Backend menyeragamkan
  /// zona waktunya di commit `93c6a14`, dan sudah diverifikasi ulang:
  /// selisihnya kini tepat satu tahun.
  @ServerDateTimeJson()
  @JsonKey(name: 'tier_valid_until')
  DateTime? get validUntil;
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Tingkat saat ini, sudah disisipkan server.
  LoyaltyTierModel? get tier;

  /// Create a copy of LoyaltyMembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoyaltyMembershipModelCopyWith<LoyaltyMembershipModel> get copyWith =>
      _$LoyaltyMembershipModelCopyWithImpl<LoyaltyMembershipModel>(
          this as LoyaltyMembershipModel, _$identity);

  /// Serializes this LoyaltyMembershipModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoyaltyMembershipModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tierId, tierId) || other.tierId == tierId) &&
            (identical(other.tierPoints, tierPoints) ||
                other.tierPoints == tierPoints) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tierId, tierPoints, validUntil, updatedAt, tier);

  @override
  String toString() {
    return 'LoyaltyMembershipModel(id: $id, tierId: $tierId, tierPoints: $tierPoints, validUntil: $validUntil, updatedAt: $updatedAt, tier: $tier)';
  }
}

/// @nodoc
abstract mixin class $LoyaltyMembershipModelCopyWith<$Res> {
  factory $LoyaltyMembershipModelCopyWith(LoyaltyMembershipModel value,
          $Res Function(LoyaltyMembershipModel) _then) =
      _$LoyaltyMembershipModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'loyalty_tier_id') int tierId,
      @IntJson() @JsonKey(name: 'tier_points') int tierPoints,
      @ServerDateTimeJson()
      @JsonKey(name: 'tier_valid_until')
      DateTime? validUntil,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      LoyaltyTierModel? tier});

  $LoyaltyTierModelCopyWith<$Res>? get tier;
}

/// @nodoc
class _$LoyaltyMembershipModelCopyWithImpl<$Res>
    implements $LoyaltyMembershipModelCopyWith<$Res> {
  _$LoyaltyMembershipModelCopyWithImpl(this._self, this._then);

  final LoyaltyMembershipModel _self;
  final $Res Function(LoyaltyMembershipModel) _then;

  /// Create a copy of LoyaltyMembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tierId = null,
    Object? tierPoints = null,
    Object? validUntil = freezed,
    Object? updatedAt = freezed,
    Object? tier = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tierId: null == tierId
          ? _self.tierId
          : tierId // ignore: cast_nullable_to_non_nullable
              as int,
      tierPoints: null == tierPoints
          ? _self.tierPoints
          : tierPoints // ignore: cast_nullable_to_non_nullable
              as int,
      validUntil: freezed == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tier: freezed == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as LoyaltyTierModel?,
    ));
  }

  /// Create a copy of LoyaltyMembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoyaltyTierModelCopyWith<$Res>? get tier {
    if (_self.tier == null) {
      return null;
    }

    return $LoyaltyTierModelCopyWith<$Res>(_self.tier!, (value) {
      return _then(_self.copyWith(tier: value));
    });
  }
}

/// Adds pattern-matching-related methods to [LoyaltyMembershipModel].
extension LoyaltyMembershipModelPatterns on LoyaltyMembershipModel {
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
    TResult Function(_LoyaltyMembershipModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoyaltyMembershipModel() when $default != null:
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
    TResult Function(_LoyaltyMembershipModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyMembershipModel():
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
    TResult? Function(_LoyaltyMembershipModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyMembershipModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'loyalty_tier_id') int tierId,
            @IntJson() @JsonKey(name: 'tier_points') int tierPoints,
            @ServerDateTimeJson()
            @JsonKey(name: 'tier_valid_until')
            DateTime? validUntil,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            LoyaltyTierModel? tier)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoyaltyMembershipModel() when $default != null:
        return $default(_that.id, _that.tierId, _that.tierPoints,
            _that.validUntil, _that.updatedAt, _that.tier);
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
            @IntJson() @JsonKey(name: 'loyalty_tier_id') int tierId,
            @IntJson() @JsonKey(name: 'tier_points') int tierPoints,
            @ServerDateTimeJson()
            @JsonKey(name: 'tier_valid_until')
            DateTime? validUntil,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            LoyaltyTierModel? tier)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyMembershipModel():
        return $default(_that.id, _that.tierId, _that.tierPoints,
            _that.validUntil, _that.updatedAt, _that.tier);
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
            @IntJson() @JsonKey(name: 'loyalty_tier_id') int tierId,
            @IntJson() @JsonKey(name: 'tier_points') int tierPoints,
            @ServerDateTimeJson()
            @JsonKey(name: 'tier_valid_until')
            DateTime? validUntil,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            LoyaltyTierModel? tier)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoyaltyMembershipModel() when $default != null:
        return $default(_that.id, _that.tierId, _that.tierPoints,
            _that.validUntil, _that.updatedAt, _that.tier);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LoyaltyMembershipModel extends LoyaltyMembershipModel {
  const _LoyaltyMembershipModel(
      {@IntJson() this.id = 0,
      @IntJson() @JsonKey(name: 'loyalty_tier_id') this.tierId = 0,
      @IntJson() @JsonKey(name: 'tier_points') this.tierPoints = 0,
      @ServerDateTimeJson() @JsonKey(name: 'tier_valid_until') this.validUntil,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') this.updatedAt,
      this.tier})
      : super._();
  factory _LoyaltyMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyMembershipModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'loyalty_tier_id')
  final int tierId;

  /// Poin yang dihitung untuk **naik tingkat**, terpisah dari saldo poin
  /// yang bisa ditukar (`user_points.balance`). Keduanya bisa berbeda karena
  /// menukar poin tidak menurunkan tingkat.
  @override
  @IntJson()
  @JsonKey(name: 'tier_points')
  final int tierPoints;

  /// Masa berlaku tingkat, satu tahun sejak keanggotaan dibuat.
  ///
  /// Dulu field ini dikirim dalam UTC sementara [updatedAt] dalam WIB —
  /// pola yang sama dengan `expires_at` di checkout. Backend menyeragamkan
  /// zona waktunya di commit `93c6a14`, dan sudah diverifikasi ulang:
  /// selisihnya kini tepat satu tahun.
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'tier_valid_until')
  final DateTime? validUntil;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Tingkat saat ini, sudah disisipkan server.
  @override
  final LoyaltyTierModel? tier;

  /// Create a copy of LoyaltyMembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoyaltyMembershipModelCopyWith<_LoyaltyMembershipModel> get copyWith =>
      __$LoyaltyMembershipModelCopyWithImpl<_LoyaltyMembershipModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoyaltyMembershipModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoyaltyMembershipModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tierId, tierId) || other.tierId == tierId) &&
            (identical(other.tierPoints, tierPoints) ||
                other.tierPoints == tierPoints) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tierId, tierPoints, validUntil, updatedAt, tier);

  @override
  String toString() {
    return 'LoyaltyMembershipModel(id: $id, tierId: $tierId, tierPoints: $tierPoints, validUntil: $validUntil, updatedAt: $updatedAt, tier: $tier)';
  }
}

/// @nodoc
abstract mixin class _$LoyaltyMembershipModelCopyWith<$Res>
    implements $LoyaltyMembershipModelCopyWith<$Res> {
  factory _$LoyaltyMembershipModelCopyWith(_LoyaltyMembershipModel value,
          $Res Function(_LoyaltyMembershipModel) _then) =
      __$LoyaltyMembershipModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'loyalty_tier_id') int tierId,
      @IntJson() @JsonKey(name: 'tier_points') int tierPoints,
      @ServerDateTimeJson()
      @JsonKey(name: 'tier_valid_until')
      DateTime? validUntil,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      LoyaltyTierModel? tier});

  @override
  $LoyaltyTierModelCopyWith<$Res>? get tier;
}

/// @nodoc
class __$LoyaltyMembershipModelCopyWithImpl<$Res>
    implements _$LoyaltyMembershipModelCopyWith<$Res> {
  __$LoyaltyMembershipModelCopyWithImpl(this._self, this._then);

  final _LoyaltyMembershipModel _self;
  final $Res Function(_LoyaltyMembershipModel) _then;

  /// Create a copy of LoyaltyMembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? tierId = null,
    Object? tierPoints = null,
    Object? validUntil = freezed,
    Object? updatedAt = freezed,
    Object? tier = freezed,
  }) {
    return _then(_LoyaltyMembershipModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tierId: null == tierId
          ? _self.tierId
          : tierId // ignore: cast_nullable_to_non_nullable
              as int,
      tierPoints: null == tierPoints
          ? _self.tierPoints
          : tierPoints // ignore: cast_nullable_to_non_nullable
              as int,
      validUntil: freezed == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tier: freezed == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as LoyaltyTierModel?,
    ));
  }

  /// Create a copy of LoyaltyMembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoyaltyTierModelCopyWith<$Res>? get tier {
    if (_self.tier == null) {
      return null;
    }

    return $LoyaltyTierModelCopyWith<$Res>(_self.tier!, (value) {
      return _then(_self.copyWith(tier: value));
    });
  }
}

/// @nodoc
mixin _$CashbackTransactionModel {
  @IntJson()
  int get id;

  /// `null` untuk cashback yang tidak berasal dari pesanan.
  @IntOrNullJson()
  @JsonKey(name: 'order_id')
  int? get orderId;
  @DoubleJson()
  double get amount;

  /// Kode status mentah; pakai [status] untuk logika.
  @StringJson()
  @JsonKey(name: 'status')
  String get statusCode;
  @ServerDateTimeJson()
  @JsonKey(name: 'credited_at')
  DateTime? get creditedAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of CashbackTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CashbackTransactionModelCopyWith<CashbackTransactionModel> get copyWith =>
      _$CashbackTransactionModelCopyWithImpl<CashbackTransactionModel>(
          this as CashbackTransactionModel, _$identity);

  /// Serializes this CashbackTransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CashbackTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.creditedAt, creditedAt) ||
                other.creditedAt == creditedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orderId, amount, statusCode, creditedAt, createdAt);

  @override
  String toString() {
    return 'CashbackTransactionModel(id: $id, orderId: $orderId, amount: $amount, statusCode: $statusCode, creditedAt: $creditedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CashbackTransactionModelCopyWith<$Res> {
  factory $CashbackTransactionModelCopyWith(CashbackTransactionModel value,
          $Res Function(CashbackTransactionModel) _then) =
      _$CashbackTransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntOrNullJson() @JsonKey(name: 'order_id') int? orderId,
      @DoubleJson() double amount,
      @StringJson() @JsonKey(name: 'status') String statusCode,
      @ServerDateTimeJson() @JsonKey(name: 'credited_at') DateTime? creditedAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$CashbackTransactionModelCopyWithImpl<$Res>
    implements $CashbackTransactionModelCopyWith<$Res> {
  _$CashbackTransactionModelCopyWithImpl(this._self, this._then);

  final CashbackTransactionModel _self;
  final $Res Function(CashbackTransactionModel) _then;

  /// Create a copy of CashbackTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = freezed,
    Object? amount = null,
    Object? statusCode = null,
    Object? creditedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as String,
      creditedAt: freezed == creditedAt
          ? _self.creditedAt
          : creditedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CashbackTransactionModel].
extension CashbackTransactionModelPatterns on CashbackTransactionModel {
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
    TResult Function(_CashbackTransactionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CashbackTransactionModel() when $default != null:
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
    TResult Function(_CashbackTransactionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CashbackTransactionModel():
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
    TResult? Function(_CashbackTransactionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CashbackTransactionModel() when $default != null:
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
            @IntOrNullJson() @JsonKey(name: 'order_id') int? orderId,
            @DoubleJson() double amount,
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @ServerDateTimeJson()
            @JsonKey(name: 'credited_at')
            DateTime? creditedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CashbackTransactionModel() when $default != null:
        return $default(_that.id, _that.orderId, _that.amount, _that.statusCode,
            _that.creditedAt, _that.createdAt);
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
            @IntOrNullJson() @JsonKey(name: 'order_id') int? orderId,
            @DoubleJson() double amount,
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @ServerDateTimeJson()
            @JsonKey(name: 'credited_at')
            DateTime? creditedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CashbackTransactionModel():
        return $default(_that.id, _that.orderId, _that.amount, _that.statusCode,
            _that.creditedAt, _that.createdAt);
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
            @IntOrNullJson() @JsonKey(name: 'order_id') int? orderId,
            @DoubleJson() double amount,
            @StringJson() @JsonKey(name: 'status') String statusCode,
            @ServerDateTimeJson()
            @JsonKey(name: 'credited_at')
            DateTime? creditedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CashbackTransactionModel() when $default != null:
        return $default(_that.id, _that.orderId, _that.amount, _that.statusCode,
            _that.creditedAt, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CashbackTransactionModel extends CashbackTransactionModel {
  const _CashbackTransactionModel(
      {@IntJson() required this.id,
      @IntOrNullJson() @JsonKey(name: 'order_id') this.orderId,
      @DoubleJson() this.amount = 0,
      @StringJson() @JsonKey(name: 'status') this.statusCode = '',
      @ServerDateTimeJson() @JsonKey(name: 'credited_at') this.creditedAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _CashbackTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$CashbackTransactionModelFromJson(json);

  @override
  @IntJson()
  final int id;

  /// `null` untuk cashback yang tidak berasal dari pesanan.
  @override
  @IntOrNullJson()
  @JsonKey(name: 'order_id')
  final int? orderId;
  @override
  @JsonKey()
  @DoubleJson()
  final double amount;

  /// Kode status mentah; pakai [status] untuk logika.
  @override
  @StringJson()
  @JsonKey(name: 'status')
  final String statusCode;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'credited_at')
  final DateTime? creditedAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of CashbackTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CashbackTransactionModelCopyWith<_CashbackTransactionModel> get copyWith =>
      __$CashbackTransactionModelCopyWithImpl<_CashbackTransactionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CashbackTransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CashbackTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.creditedAt, creditedAt) ||
                other.creditedAt == creditedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orderId, amount, statusCode, creditedAt, createdAt);

  @override
  String toString() {
    return 'CashbackTransactionModel(id: $id, orderId: $orderId, amount: $amount, statusCode: $statusCode, creditedAt: $creditedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CashbackTransactionModelCopyWith<$Res>
    implements $CashbackTransactionModelCopyWith<$Res> {
  factory _$CashbackTransactionModelCopyWith(_CashbackTransactionModel value,
          $Res Function(_CashbackTransactionModel) _then) =
      __$CashbackTransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntOrNullJson() @JsonKey(name: 'order_id') int? orderId,
      @DoubleJson() double amount,
      @StringJson() @JsonKey(name: 'status') String statusCode,
      @ServerDateTimeJson() @JsonKey(name: 'credited_at') DateTime? creditedAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$CashbackTransactionModelCopyWithImpl<$Res>
    implements _$CashbackTransactionModelCopyWith<$Res> {
  __$CashbackTransactionModelCopyWithImpl(this._self, this._then);

  final _CashbackTransactionModel _self;
  final $Res Function(_CashbackTransactionModel) _then;

  /// Create a copy of CashbackTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orderId = freezed,
    Object? amount = null,
    Object? statusCode = null,
    Object? creditedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_CashbackTransactionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as String,
      creditedAt: freezed == creditedAt
          ? _self.creditedAt
          : creditedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$RewardBreakdownModel {
  @IntJson()
  int get base;
  @IntJson()
  @JsonKey(name: 'tier_bonus')
  int get tierBonus;
  @IntJson()
  @JsonKey(name: 'payment_method_bonus')
  int get paymentMethodBonus;
  @IntJson()
  @JsonKey(name: 'voucher_cashback')
  int get voucherCashback;

  /// Create a copy of RewardBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RewardBreakdownModelCopyWith<RewardBreakdownModel> get copyWith =>
      _$RewardBreakdownModelCopyWithImpl<RewardBreakdownModel>(
          this as RewardBreakdownModel, _$identity);

  /// Serializes this RewardBreakdownModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RewardBreakdownModel &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.tierBonus, tierBonus) ||
                other.tierBonus == tierBonus) &&
            (identical(other.paymentMethodBonus, paymentMethodBonus) ||
                other.paymentMethodBonus == paymentMethodBonus) &&
            (identical(other.voucherCashback, voucherCashback) ||
                other.voucherCashback == voucherCashback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, base, tierBonus, paymentMethodBonus, voucherCashback);

  @override
  String toString() {
    return 'RewardBreakdownModel(base: $base, tierBonus: $tierBonus, paymentMethodBonus: $paymentMethodBonus, voucherCashback: $voucherCashback)';
  }
}

/// @nodoc
abstract mixin class $RewardBreakdownModelCopyWith<$Res> {
  factory $RewardBreakdownModelCopyWith(RewardBreakdownModel value,
          $Res Function(RewardBreakdownModel) _then) =
      _$RewardBreakdownModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int base,
      @IntJson() @JsonKey(name: 'tier_bonus') int tierBonus,
      @IntJson() @JsonKey(name: 'payment_method_bonus') int paymentMethodBonus,
      @IntJson() @JsonKey(name: 'voucher_cashback') int voucherCashback});
}

/// @nodoc
class _$RewardBreakdownModelCopyWithImpl<$Res>
    implements $RewardBreakdownModelCopyWith<$Res> {
  _$RewardBreakdownModelCopyWithImpl(this._self, this._then);

  final RewardBreakdownModel _self;
  final $Res Function(RewardBreakdownModel) _then;

  /// Create a copy of RewardBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base = null,
    Object? tierBonus = null,
    Object? paymentMethodBonus = null,
    Object? voucherCashback = null,
  }) {
    return _then(_self.copyWith(
      base: null == base
          ? _self.base
          : base // ignore: cast_nullable_to_non_nullable
              as int,
      tierBonus: null == tierBonus
          ? _self.tierBonus
          : tierBonus // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethodBonus: null == paymentMethodBonus
          ? _self.paymentMethodBonus
          : paymentMethodBonus // ignore: cast_nullable_to_non_nullable
              as int,
      voucherCashback: null == voucherCashback
          ? _self.voucherCashback
          : voucherCashback // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [RewardBreakdownModel].
extension RewardBreakdownModelPatterns on RewardBreakdownModel {
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
    TResult Function(_RewardBreakdownModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RewardBreakdownModel() when $default != null:
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
    TResult Function(_RewardBreakdownModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBreakdownModel():
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
    TResult? Function(_RewardBreakdownModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBreakdownModel() when $default != null:
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
            @IntJson() int base,
            @IntJson() @JsonKey(name: 'tier_bonus') int tierBonus,
            @IntJson()
            @JsonKey(name: 'payment_method_bonus')
            int paymentMethodBonus,
            @IntJson() @JsonKey(name: 'voucher_cashback') int voucherCashback)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RewardBreakdownModel() when $default != null:
        return $default(_that.base, _that.tierBonus, _that.paymentMethodBonus,
            _that.voucherCashback);
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
            @IntJson() int base,
            @IntJson() @JsonKey(name: 'tier_bonus') int tierBonus,
            @IntJson()
            @JsonKey(name: 'payment_method_bonus')
            int paymentMethodBonus,
            @IntJson() @JsonKey(name: 'voucher_cashback') int voucherCashback)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBreakdownModel():
        return $default(_that.base, _that.tierBonus, _that.paymentMethodBonus,
            _that.voucherCashback);
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
            @IntJson() int base,
            @IntJson() @JsonKey(name: 'tier_bonus') int tierBonus,
            @IntJson()
            @JsonKey(name: 'payment_method_bonus')
            int paymentMethodBonus,
            @IntJson() @JsonKey(name: 'voucher_cashback') int voucherCashback)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardBreakdownModel() when $default != null:
        return $default(_that.base, _that.tierBonus, _that.paymentMethodBonus,
            _that.voucherCashback);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RewardBreakdownModel extends RewardBreakdownModel {
  const _RewardBreakdownModel(
      {@IntJson() this.base = 0,
      @IntJson() @JsonKey(name: 'tier_bonus') this.tierBonus = 0,
      @IntJson()
      @JsonKey(name: 'payment_method_bonus')
      this.paymentMethodBonus = 0,
      @IntJson() @JsonKey(name: 'voucher_cashback') this.voucherCashback = 0})
      : super._();
  factory _RewardBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$RewardBreakdownModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int base;
  @override
  @IntJson()
  @JsonKey(name: 'tier_bonus')
  final int tierBonus;
  @override
  @IntJson()
  @JsonKey(name: 'payment_method_bonus')
  final int paymentMethodBonus;
  @override
  @IntJson()
  @JsonKey(name: 'voucher_cashback')
  final int voucherCashback;

  /// Create a copy of RewardBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RewardBreakdownModelCopyWith<_RewardBreakdownModel> get copyWith =>
      __$RewardBreakdownModelCopyWithImpl<_RewardBreakdownModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RewardBreakdownModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RewardBreakdownModel &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.tierBonus, tierBonus) ||
                other.tierBonus == tierBonus) &&
            (identical(other.paymentMethodBonus, paymentMethodBonus) ||
                other.paymentMethodBonus == paymentMethodBonus) &&
            (identical(other.voucherCashback, voucherCashback) ||
                other.voucherCashback == voucherCashback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, base, tierBonus, paymentMethodBonus, voucherCashback);

  @override
  String toString() {
    return 'RewardBreakdownModel(base: $base, tierBonus: $tierBonus, paymentMethodBonus: $paymentMethodBonus, voucherCashback: $voucherCashback)';
  }
}

/// @nodoc
abstract mixin class _$RewardBreakdownModelCopyWith<$Res>
    implements $RewardBreakdownModelCopyWith<$Res> {
  factory _$RewardBreakdownModelCopyWith(_RewardBreakdownModel value,
          $Res Function(_RewardBreakdownModel) _then) =
      __$RewardBreakdownModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int base,
      @IntJson() @JsonKey(name: 'tier_bonus') int tierBonus,
      @IntJson() @JsonKey(name: 'payment_method_bonus') int paymentMethodBonus,
      @IntJson() @JsonKey(name: 'voucher_cashback') int voucherCashback});
}

/// @nodoc
class __$RewardBreakdownModelCopyWithImpl<$Res>
    implements _$RewardBreakdownModelCopyWith<$Res> {
  __$RewardBreakdownModelCopyWithImpl(this._self, this._then);

  final _RewardBreakdownModel _self;
  final $Res Function(_RewardBreakdownModel) _then;

  /// Create a copy of RewardBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? base = null,
    Object? tierBonus = null,
    Object? paymentMethodBonus = null,
    Object? voucherCashback = null,
  }) {
    return _then(_RewardBreakdownModel(
      base: null == base
          ? _self.base
          : base // ignore: cast_nullable_to_non_nullable
              as int,
      tierBonus: null == tierBonus
          ? _self.tierBonus
          : tierBonus // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethodBonus: null == paymentMethodBonus
          ? _self.paymentMethodBonus
          : paymentMethodBonus // ignore: cast_nullable_to_non_nullable
              as int,
      voucherCashback: null == voucherCashback
          ? _self.voucherCashback
          : voucherCashback // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$RewardPreviewModel {
  @DoubleJson()
  double get subtotal;
  @IntJson()
  @JsonKey(name: 'estimated_cashback_coins')
  int get estimatedCoins;
  RewardBreakdownModel? get breakdown;

  /// Kode tingkat loyalitas yang dipakai menghitung, mis. `bronze`.
  @StringJson()
  String get tier;

  /// `pending_release` / `released` / `cancelled`.
  @StringJson()
  String get status;

  /// Create a copy of RewardPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RewardPreviewModelCopyWith<RewardPreviewModel> get copyWith =>
      _$RewardPreviewModelCopyWithImpl<RewardPreviewModel>(
          this as RewardPreviewModel, _$identity);

  /// Serializes this RewardPreviewModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RewardPreviewModel &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.estimatedCoins, estimatedCoins) ||
                other.estimatedCoins == estimatedCoins) &&
            (identical(other.breakdown, breakdown) ||
                other.breakdown == breakdown) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, subtotal, estimatedCoins, breakdown, tier, status);

  @override
  String toString() {
    return 'RewardPreviewModel(subtotal: $subtotal, estimatedCoins: $estimatedCoins, breakdown: $breakdown, tier: $tier, status: $status)';
  }
}

/// @nodoc
abstract mixin class $RewardPreviewModelCopyWith<$Res> {
  factory $RewardPreviewModelCopyWith(
          RewardPreviewModel value, $Res Function(RewardPreviewModel) _then) =
      _$RewardPreviewModelCopyWithImpl;
  @useResult
  $Res call(
      {@DoubleJson() double subtotal,
      @IntJson() @JsonKey(name: 'estimated_cashback_coins') int estimatedCoins,
      RewardBreakdownModel? breakdown,
      @StringJson() String tier,
      @StringJson() String status});

  $RewardBreakdownModelCopyWith<$Res>? get breakdown;
}

/// @nodoc
class _$RewardPreviewModelCopyWithImpl<$Res>
    implements $RewardPreviewModelCopyWith<$Res> {
  _$RewardPreviewModelCopyWithImpl(this._self, this._then);

  final RewardPreviewModel _self;
  final $Res Function(RewardPreviewModel) _then;

  /// Create a copy of RewardPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? estimatedCoins = null,
    Object? breakdown = freezed,
    Object? tier = null,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedCoins: null == estimatedCoins
          ? _self.estimatedCoins
          : estimatedCoins // ignore: cast_nullable_to_non_nullable
              as int,
      breakdown: freezed == breakdown
          ? _self.breakdown
          : breakdown // ignore: cast_nullable_to_non_nullable
              as RewardBreakdownModel?,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of RewardPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RewardBreakdownModelCopyWith<$Res>? get breakdown {
    if (_self.breakdown == null) {
      return null;
    }

    return $RewardBreakdownModelCopyWith<$Res>(_self.breakdown!, (value) {
      return _then(_self.copyWith(breakdown: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RewardPreviewModel].
extension RewardPreviewModelPatterns on RewardPreviewModel {
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
    TResult Function(_RewardPreviewModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RewardPreviewModel() when $default != null:
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
    TResult Function(_RewardPreviewModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardPreviewModel():
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
    TResult? Function(_RewardPreviewModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardPreviewModel() when $default != null:
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
            @DoubleJson() double subtotal,
            @IntJson()
            @JsonKey(name: 'estimated_cashback_coins')
            int estimatedCoins,
            RewardBreakdownModel? breakdown,
            @StringJson() String tier,
            @StringJson() String status)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RewardPreviewModel() when $default != null:
        return $default(_that.subtotal, _that.estimatedCoins, _that.breakdown,
            _that.tier, _that.status);
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
            @DoubleJson() double subtotal,
            @IntJson()
            @JsonKey(name: 'estimated_cashback_coins')
            int estimatedCoins,
            RewardBreakdownModel? breakdown,
            @StringJson() String tier,
            @StringJson() String status)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardPreviewModel():
        return $default(_that.subtotal, _that.estimatedCoins, _that.breakdown,
            _that.tier, _that.status);
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
            @DoubleJson() double subtotal,
            @IntJson()
            @JsonKey(name: 'estimated_cashback_coins')
            int estimatedCoins,
            RewardBreakdownModel? breakdown,
            @StringJson() String tier,
            @StringJson() String status)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RewardPreviewModel() when $default != null:
        return $default(_that.subtotal, _that.estimatedCoins, _that.breakdown,
            _that.tier, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RewardPreviewModel extends RewardPreviewModel {
  const _RewardPreviewModel(
      {@DoubleJson() this.subtotal = 0,
      @IntJson()
      @JsonKey(name: 'estimated_cashback_coins')
      this.estimatedCoins = 0,
      this.breakdown,
      @StringJson() this.tier = '',
      @StringJson() this.status = ''})
      : super._();
  factory _RewardPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$RewardPreviewModelFromJson(json);

  @override
  @JsonKey()
  @DoubleJson()
  final double subtotal;
  @override
  @IntJson()
  @JsonKey(name: 'estimated_cashback_coins')
  final int estimatedCoins;
  @override
  final RewardBreakdownModel? breakdown;

  /// Kode tingkat loyalitas yang dipakai menghitung, mis. `bronze`.
  @override
  @JsonKey()
  @StringJson()
  final String tier;

  /// `pending_release` / `released` / `cancelled`.
  @override
  @JsonKey()
  @StringJson()
  final String status;

  /// Create a copy of RewardPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RewardPreviewModelCopyWith<_RewardPreviewModel> get copyWith =>
      __$RewardPreviewModelCopyWithImpl<_RewardPreviewModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RewardPreviewModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RewardPreviewModel &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.estimatedCoins, estimatedCoins) ||
                other.estimatedCoins == estimatedCoins) &&
            (identical(other.breakdown, breakdown) ||
                other.breakdown == breakdown) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, subtotal, estimatedCoins, breakdown, tier, status);

  @override
  String toString() {
    return 'RewardPreviewModel(subtotal: $subtotal, estimatedCoins: $estimatedCoins, breakdown: $breakdown, tier: $tier, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$RewardPreviewModelCopyWith<$Res>
    implements $RewardPreviewModelCopyWith<$Res> {
  factory _$RewardPreviewModelCopyWith(
          _RewardPreviewModel value, $Res Function(_RewardPreviewModel) _then) =
      __$RewardPreviewModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DoubleJson() double subtotal,
      @IntJson() @JsonKey(name: 'estimated_cashback_coins') int estimatedCoins,
      RewardBreakdownModel? breakdown,
      @StringJson() String tier,
      @StringJson() String status});

  @override
  $RewardBreakdownModelCopyWith<$Res>? get breakdown;
}

/// @nodoc
class __$RewardPreviewModelCopyWithImpl<$Res>
    implements _$RewardPreviewModelCopyWith<$Res> {
  __$RewardPreviewModelCopyWithImpl(this._self, this._then);

  final _RewardPreviewModel _self;
  final $Res Function(_RewardPreviewModel) _then;

  /// Create a copy of RewardPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? subtotal = null,
    Object? estimatedCoins = null,
    Object? breakdown = freezed,
    Object? tier = null,
    Object? status = null,
  }) {
    return _then(_RewardPreviewModel(
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedCoins: null == estimatedCoins
          ? _self.estimatedCoins
          : estimatedCoins // ignore: cast_nullable_to_non_nullable
              as int,
      breakdown: freezed == breakdown
          ? _self.breakdown
          : breakdown // ignore: cast_nullable_to_non_nullable
              as RewardBreakdownModel?,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of RewardPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RewardBreakdownModelCopyWith<$Res>? get breakdown {
    if (_self.breakdown == null) {
      return null;
    }

    return $RewardBreakdownModelCopyWith<$Res>(_self.breakdown!, (value) {
      return _then(_self.copyWith(breakdown: value));
    });
  }
}

// dart format on
