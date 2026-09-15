// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletModel {
  @IntJson()
  int get id;
  @DoubleJson()
  double get balance;

  /// Saldo yang ditahan (mis. penarikan yang sedang diproses). Tidak bisa
  /// dipakai membayar.
  @DoubleJson()
  @JsonKey(name: 'held_balance')
  double get heldBalance;
  @StringJson()
  String get status;
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  List<WalletTransactionModel> get transactions;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalletModelCopyWith<WalletModel> get copyWith =>
      _$WalletModelCopyWithImpl<WalletModel>(this as WalletModel, _$identity);

  /// Serializes this WalletModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalletModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.heldBalance, heldBalance) ||
                other.heldBalance == heldBalance) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other.transactions, transactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, balance, heldBalance, status,
      updatedAt, const DeepCollectionEquality().hash(transactions));

  @override
  String toString() {
    return 'WalletModel(id: $id, balance: $balance, heldBalance: $heldBalance, status: $status, updatedAt: $updatedAt, transactions: $transactions)';
  }
}

/// @nodoc
abstract mixin class $WalletModelCopyWith<$Res> {
  factory $WalletModelCopyWith(
          WalletModel value, $Res Function(WalletModel) _then) =
      _$WalletModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @DoubleJson() double balance,
      @DoubleJson() @JsonKey(name: 'held_balance') double heldBalance,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<WalletTransactionModel> transactions});
}

/// @nodoc
class _$WalletModelCopyWithImpl<$Res> implements $WalletModelCopyWith<$Res> {
  _$WalletModelCopyWithImpl(this._self, this._then);

  final WalletModel _self;
  final $Res Function(WalletModel) _then;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? balance = null,
    Object? heldBalance = null,
    Object? status = null,
    Object? updatedAt = freezed,
    Object? transactions = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      heldBalance: null == heldBalance
          ? _self.heldBalance
          : heldBalance // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactions: null == transactions
          ? _self.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<WalletTransactionModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WalletModel].
extension WalletModelPatterns on WalletModel {
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
    TResult Function(_WalletModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalletModel() when $default != null:
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
    TResult Function(_WalletModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletModel():
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
    TResult? Function(_WalletModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletModel() when $default != null:
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
            @DoubleJson() double balance,
            @DoubleJson() @JsonKey(name: 'held_balance') double heldBalance,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            List<WalletTransactionModel> transactions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalletModel() when $default != null:
        return $default(_that.id, _that.balance, _that.heldBalance,
            _that.status, _that.updatedAt, _that.transactions);
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
            @DoubleJson() double balance,
            @DoubleJson() @JsonKey(name: 'held_balance') double heldBalance,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            List<WalletTransactionModel> transactions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletModel():
        return $default(_that.id, _that.balance, _that.heldBalance,
            _that.status, _that.updatedAt, _that.transactions);
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
            @DoubleJson() double balance,
            @DoubleJson() @JsonKey(name: 'held_balance') double heldBalance,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            List<WalletTransactionModel> transactions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletModel() when $default != null:
        return $default(_that.id, _that.balance, _that.heldBalance,
            _that.status, _that.updatedAt, _that.transactions);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WalletModel extends WalletModel {
  const _WalletModel(
      {@IntJson() this.id = 0,
      @DoubleJson() this.balance = 0,
      @DoubleJson() @JsonKey(name: 'held_balance') this.heldBalance = 0,
      @StringJson() this.status = 'active',
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') this.updatedAt,
      final List<WalletTransactionModel> transactions =
          const <WalletTransactionModel>[]})
      : _transactions = transactions,
        super._();
  factory _WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  @override
  @JsonKey()
  @IntJson()
  final int id;
  @override
  @JsonKey()
  @DoubleJson()
  final double balance;

  /// Saldo yang ditahan (mis. penarikan yang sedang diproses). Tidak bisa
  /// dipakai membayar.
  @override
  @DoubleJson()
  @JsonKey(name: 'held_balance')
  final double heldBalance;
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<WalletTransactionModel> _transactions;
  @override
  @JsonKey()
  List<WalletTransactionModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalletModelCopyWith<_WalletModel> get copyWith =>
      __$WalletModelCopyWithImpl<_WalletModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalletModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalletModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.heldBalance, heldBalance) ||
                other.heldBalance == heldBalance) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, balance, heldBalance, status,
      updatedAt, const DeepCollectionEquality().hash(_transactions));

  @override
  String toString() {
    return 'WalletModel(id: $id, balance: $balance, heldBalance: $heldBalance, status: $status, updatedAt: $updatedAt, transactions: $transactions)';
  }
}

/// @nodoc
abstract mixin class _$WalletModelCopyWith<$Res>
    implements $WalletModelCopyWith<$Res> {
  factory _$WalletModelCopyWith(
          _WalletModel value, $Res Function(_WalletModel) _then) =
      __$WalletModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @DoubleJson() double balance,
      @DoubleJson() @JsonKey(name: 'held_balance') double heldBalance,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<WalletTransactionModel> transactions});
}

/// @nodoc
class __$WalletModelCopyWithImpl<$Res> implements _$WalletModelCopyWith<$Res> {
  __$WalletModelCopyWithImpl(this._self, this._then);

  final _WalletModel _self;
  final $Res Function(_WalletModel) _then;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? balance = null,
    Object? heldBalance = null,
    Object? status = null,
    Object? updatedAt = freezed,
    Object? transactions = null,
  }) {
    return _then(_WalletModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      heldBalance: null == heldBalance
          ? _self.heldBalance
          : heldBalance // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactions: null == transactions
          ? _self._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<WalletTransactionModel>,
    ));
  }
}

/// @nodoc
mixin _$WalletTransactionModel {
  @IntJson()
  int get id;

  /// Kode jenis mentah; pakai [type] untuk logika.
  @StringJson()
  @JsonKey(name: 'type')
  String get typeCode;

  /// **Selalu positif.** Arahnya dari [type].
  @DoubleJson()
  double get amount;
  @DoubleJson()
  @JsonKey(name: 'balance_before')
  double get balanceBefore;
  @DoubleJson()
  @JsonKey(name: 'balance_after')
  double get balanceAfter;

  /// `order`, `refund`, `withdrawal_request`, `affiliate_commission`,
  /// `topup_request`, … — penjelas asal mutasi.
  @StringOrNullJson()
  @JsonKey(name: 'reference_type')
  String? get referenceType;
  @IntOrNullJson()
  @JsonKey(name: 'reference_id')
  int? get referenceId;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of WalletTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalletTransactionModelCopyWith<WalletTransactionModel> get copyWith =>
      _$WalletTransactionModelCopyWithImpl<WalletTransactionModel>(
          this as WalletTransactionModel, _$identity);

  /// Serializes this WalletTransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalletTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeCode, typeCode) ||
                other.typeCode == typeCode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, typeCode, amount,
      balanceBefore, balanceAfter, referenceType, referenceId, createdAt);

  @override
  String toString() {
    return 'WalletTransactionModel(id: $id, typeCode: $typeCode, amount: $amount, balanceBefore: $balanceBefore, balanceAfter: $balanceAfter, referenceType: $referenceType, referenceId: $referenceId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $WalletTransactionModelCopyWith<$Res> {
  factory $WalletTransactionModelCopyWith(WalletTransactionModel value,
          $Res Function(WalletTransactionModel) _then) =
      _$WalletTransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'type') String typeCode,
      @DoubleJson() double amount,
      @DoubleJson() @JsonKey(name: 'balance_before') double balanceBefore,
      @DoubleJson() @JsonKey(name: 'balance_after') double balanceAfter,
      @StringOrNullJson()
      @JsonKey(name: 'reference_type')
      String? referenceType,
      @IntOrNullJson() @JsonKey(name: 'reference_id') int? referenceId,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$WalletTransactionModelCopyWithImpl<$Res>
    implements $WalletTransactionModelCopyWith<$Res> {
  _$WalletTransactionModelCopyWithImpl(this._self, this._then);

  final WalletTransactionModel _self;
  final $Res Function(WalletTransactionModel) _then;

  /// Create a copy of WalletTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeCode = null,
    Object? amount = null,
    Object? balanceBefore = null,
    Object? balanceAfter = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      typeCode: null == typeCode
          ? _self.typeCode
          : typeCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceBefore: null == balanceBefore
          ? _self.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _self.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      referenceType: freezed == referenceType
          ? _self.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _self.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [WalletTransactionModel].
extension WalletTransactionModelPatterns on WalletTransactionModel {
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
    TResult Function(_WalletTransactionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalletTransactionModel() when $default != null:
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
    TResult Function(_WalletTransactionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTransactionModel():
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
    TResult? Function(_WalletTransactionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTransactionModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'type') String typeCode,
            @DoubleJson() double amount,
            @DoubleJson() @JsonKey(name: 'balance_before') double balanceBefore,
            @DoubleJson() @JsonKey(name: 'balance_after') double balanceAfter,
            @StringOrNullJson()
            @JsonKey(name: 'reference_type')
            String? referenceType,
            @IntOrNullJson() @JsonKey(name: 'reference_id') int? referenceId,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalletTransactionModel() when $default != null:
        return $default(
            _that.id,
            _that.typeCode,
            _that.amount,
            _that.balanceBefore,
            _that.balanceAfter,
            _that.referenceType,
            _that.referenceId,
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
            @StringJson() @JsonKey(name: 'type') String typeCode,
            @DoubleJson() double amount,
            @DoubleJson() @JsonKey(name: 'balance_before') double balanceBefore,
            @DoubleJson() @JsonKey(name: 'balance_after') double balanceAfter,
            @StringOrNullJson()
            @JsonKey(name: 'reference_type')
            String? referenceType,
            @IntOrNullJson() @JsonKey(name: 'reference_id') int? referenceId,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTransactionModel():
        return $default(
            _that.id,
            _that.typeCode,
            _that.amount,
            _that.balanceBefore,
            _that.balanceAfter,
            _that.referenceType,
            _that.referenceId,
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
            @StringJson() @JsonKey(name: 'type') String typeCode,
            @DoubleJson() double amount,
            @DoubleJson() @JsonKey(name: 'balance_before') double balanceBefore,
            @DoubleJson() @JsonKey(name: 'balance_after') double balanceAfter,
            @StringOrNullJson()
            @JsonKey(name: 'reference_type')
            String? referenceType,
            @IntOrNullJson() @JsonKey(name: 'reference_id') int? referenceId,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTransactionModel() when $default != null:
        return $default(
            _that.id,
            _that.typeCode,
            _that.amount,
            _that.balanceBefore,
            _that.balanceAfter,
            _that.referenceType,
            _that.referenceId,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WalletTransactionModel extends WalletTransactionModel {
  const _WalletTransactionModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'type') this.typeCode = '',
      @DoubleJson() this.amount = 0,
      @DoubleJson() @JsonKey(name: 'balance_before') this.balanceBefore = 0,
      @DoubleJson() @JsonKey(name: 'balance_after') this.balanceAfter = 0,
      @StringOrNullJson() @JsonKey(name: 'reference_type') this.referenceType,
      @IntOrNullJson() @JsonKey(name: 'reference_id') this.referenceId,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionModelFromJson(json);

  @override
  @IntJson()
  final int id;

  /// Kode jenis mentah; pakai [type] untuk logika.
  @override
  @StringJson()
  @JsonKey(name: 'type')
  final String typeCode;

  /// **Selalu positif.** Arahnya dari [type].
  @override
  @JsonKey()
  @DoubleJson()
  final double amount;
  @override
  @DoubleJson()
  @JsonKey(name: 'balance_before')
  final double balanceBefore;
  @override
  @DoubleJson()
  @JsonKey(name: 'balance_after')
  final double balanceAfter;

  /// `order`, `refund`, `withdrawal_request`, `affiliate_commission`,
  /// `topup_request`, … — penjelas asal mutasi.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'reference_type')
  final String? referenceType;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'reference_id')
  final int? referenceId;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of WalletTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalletTransactionModelCopyWith<_WalletTransactionModel> get copyWith =>
      __$WalletTransactionModelCopyWithImpl<_WalletTransactionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalletTransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalletTransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeCode, typeCode) ||
                other.typeCode == typeCode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, typeCode, amount,
      balanceBefore, balanceAfter, referenceType, referenceId, createdAt);

  @override
  String toString() {
    return 'WalletTransactionModel(id: $id, typeCode: $typeCode, amount: $amount, balanceBefore: $balanceBefore, balanceAfter: $balanceAfter, referenceType: $referenceType, referenceId: $referenceId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$WalletTransactionModelCopyWith<$Res>
    implements $WalletTransactionModelCopyWith<$Res> {
  factory _$WalletTransactionModelCopyWith(_WalletTransactionModel value,
          $Res Function(_WalletTransactionModel) _then) =
      __$WalletTransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'type') String typeCode,
      @DoubleJson() double amount,
      @DoubleJson() @JsonKey(name: 'balance_before') double balanceBefore,
      @DoubleJson() @JsonKey(name: 'balance_after') double balanceAfter,
      @StringOrNullJson()
      @JsonKey(name: 'reference_type')
      String? referenceType,
      @IntOrNullJson() @JsonKey(name: 'reference_id') int? referenceId,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$WalletTransactionModelCopyWithImpl<$Res>
    implements _$WalletTransactionModelCopyWith<$Res> {
  __$WalletTransactionModelCopyWithImpl(this._self, this._then);

  final _WalletTransactionModel _self;
  final $Res Function(_WalletTransactionModel) _then;

  /// Create a copy of WalletTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? typeCode = null,
    Object? amount = null,
    Object? balanceBefore = null,
    Object? balanceAfter = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_WalletTransactionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      typeCode: null == typeCode
          ? _self.typeCode
          : typeCode // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceBefore: null == balanceBefore
          ? _self.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _self.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      referenceType: freezed == referenceType
          ? _self.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceId: freezed == referenceId
          ? _self.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$WalletTopupResult {
  @IntJson()
  @JsonKey(name: 'payment_transaction_id')
  int get paymentTransactionId;
  @StringOrNullJson()
  @JsonKey(name: 'topup_reference')
  String? get reference;
  @DoubleJson()
  double get amount;

  /// Create a copy of WalletTopupResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalletTopupResultCopyWith<WalletTopupResult> get copyWith =>
      _$WalletTopupResultCopyWithImpl<WalletTopupResult>(
          this as WalletTopupResult, _$identity);

  /// Serializes this WalletTopupResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalletTopupResult &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paymentTransactionId, reference, amount);

  @override
  String toString() {
    return 'WalletTopupResult(paymentTransactionId: $paymentTransactionId, reference: $reference, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $WalletTopupResultCopyWith<$Res> {
  factory $WalletTopupResultCopyWith(
          WalletTopupResult value, $Res Function(WalletTopupResult) _then) =
      _$WalletTopupResultCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson()
      @JsonKey(name: 'payment_transaction_id')
      int paymentTransactionId,
      @StringOrNullJson() @JsonKey(name: 'topup_reference') String? reference,
      @DoubleJson() double amount});
}

/// @nodoc
class _$WalletTopupResultCopyWithImpl<$Res>
    implements $WalletTopupResultCopyWith<$Res> {
  _$WalletTopupResultCopyWithImpl(this._self, this._then);

  final WalletTopupResult _self;
  final $Res Function(WalletTopupResult) _then;

  /// Create a copy of WalletTopupResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentTransactionId = null,
    Object? reference = freezed,
    Object? amount = null,
  }) {
    return _then(_self.copyWith(
      paymentTransactionId: null == paymentTransactionId
          ? _self.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as int,
      reference: freezed == reference
          ? _self.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [WalletTopupResult].
extension WalletTopupResultPatterns on WalletTopupResult {
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
    TResult Function(_WalletTopupResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalletTopupResult() when $default != null:
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
    TResult Function(_WalletTopupResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTopupResult():
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
    TResult? Function(_WalletTopupResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTopupResult() when $default != null:
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
            @IntJson()
            @JsonKey(name: 'payment_transaction_id')
            int paymentTransactionId,
            @StringOrNullJson()
            @JsonKey(name: 'topup_reference')
            String? reference,
            @DoubleJson() double amount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WalletTopupResult() when $default != null:
        return $default(
            _that.paymentTransactionId, _that.reference, _that.amount);
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
            @IntJson()
            @JsonKey(name: 'payment_transaction_id')
            int paymentTransactionId,
            @StringOrNullJson()
            @JsonKey(name: 'topup_reference')
            String? reference,
            @DoubleJson() double amount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTopupResult():
        return $default(
            _that.paymentTransactionId, _that.reference, _that.amount);
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
            @IntJson()
            @JsonKey(name: 'payment_transaction_id')
            int paymentTransactionId,
            @StringOrNullJson()
            @JsonKey(name: 'topup_reference')
            String? reference,
            @DoubleJson() double amount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WalletTopupResult() when $default != null:
        return $default(
            _that.paymentTransactionId, _that.reference, _that.amount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WalletTopupResult implements WalletTopupResult {
  const _WalletTopupResult(
      {@IntJson()
      @JsonKey(name: 'payment_transaction_id')
      this.paymentTransactionId = 0,
      @StringOrNullJson() @JsonKey(name: 'topup_reference') this.reference,
      @DoubleJson() this.amount = 0});
  factory _WalletTopupResult.fromJson(Map<String, dynamic> json) =>
      _$WalletTopupResultFromJson(json);

  @override
  @IntJson()
  @JsonKey(name: 'payment_transaction_id')
  final int paymentTransactionId;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'topup_reference')
  final String? reference;
  @override
  @JsonKey()
  @DoubleJson()
  final double amount;

  /// Create a copy of WalletTopupResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WalletTopupResultCopyWith<_WalletTopupResult> get copyWith =>
      __$WalletTopupResultCopyWithImpl<_WalletTopupResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WalletTopupResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalletTopupResult &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paymentTransactionId, reference, amount);

  @override
  String toString() {
    return 'WalletTopupResult(paymentTransactionId: $paymentTransactionId, reference: $reference, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$WalletTopupResultCopyWith<$Res>
    implements $WalletTopupResultCopyWith<$Res> {
  factory _$WalletTopupResultCopyWith(
          _WalletTopupResult value, $Res Function(_WalletTopupResult) _then) =
      __$WalletTopupResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson()
      @JsonKey(name: 'payment_transaction_id')
      int paymentTransactionId,
      @StringOrNullJson() @JsonKey(name: 'topup_reference') String? reference,
      @DoubleJson() double amount});
}

/// @nodoc
class __$WalletTopupResultCopyWithImpl<$Res>
    implements _$WalletTopupResultCopyWith<$Res> {
  __$WalletTopupResultCopyWithImpl(this._self, this._then);

  final _WalletTopupResult _self;
  final $Res Function(_WalletTopupResult) _then;

  /// Create a copy of WalletTopupResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? paymentTransactionId = null,
    Object? reference = freezed,
    Object? amount = null,
  }) {
    return _then(_WalletTopupResult(
      paymentTransactionId: null == paymentTransactionId
          ? _self.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as int,
      reference: freezed == reference
          ? _self.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
