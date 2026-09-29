// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginSessionModel {
  @IntJson()
  int get id;
  @StringOrNullJson()
  @JsonKey(name: 'device_id')
  String? get deviceId;
  @StringOrNullJson()
  @JsonKey(name: 'ip_address')
  String? get ipAddress;
  @StringOrNullJson()
  @JsonKey(name: 'user_agent')
  String? get userAgent;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;

  /// **Field usulan** (belum dikirim server). Kalau kelak ada, nilainya
  /// menang atas tebakan [groupLoginSessions].
  @JsonKey(name: 'is_current', fromJson: _boolOrNull)
  bool? get isCurrent;

  /// Create a copy of LoginSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginSessionModelCopyWith<LoginSessionModel> get copyWith =>
      _$LoginSessionModelCopyWithImpl<LoginSessionModel>(
          this as LoginSessionModel, _$identity);

  /// Serializes this LoginSessionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, deviceId, ipAddress,
      userAgent, createdAt, expiresAt, isCurrent);

  @override
  String toString() {
    return 'LoginSessionModel(id: $id, deviceId: $deviceId, ipAddress: $ipAddress, userAgent: $userAgent, createdAt: $createdAt, expiresAt: $expiresAt, isCurrent: $isCurrent)';
  }
}

/// @nodoc
abstract mixin class $LoginSessionModelCopyWith<$Res> {
  factory $LoginSessionModelCopyWith(
          LoginSessionModel value, $Res Function(LoginSessionModel) _then) =
      _$LoginSessionModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringOrNullJson() @JsonKey(name: 'device_id') String? deviceId,
      @StringOrNullJson() @JsonKey(name: 'ip_address') String? ipAddress,
      @StringOrNullJson() @JsonKey(name: 'user_agent') String? userAgent,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'is_current', fromJson: _boolOrNull) bool? isCurrent});
}

/// @nodoc
class _$LoginSessionModelCopyWithImpl<$Res>
    implements $LoginSessionModelCopyWith<$Res> {
  _$LoginSessionModelCopyWithImpl(this._self, this._then);

  final LoginSessionModel _self;
  final $Res Function(LoginSessionModel) _then;

  /// Create a copy of LoginSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
    Object? isCurrent = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _self.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: freezed == isCurrent
          ? _self.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LoginSessionModel].
extension LoginSessionModelPatterns on LoginSessionModel {
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
    TResult Function(_LoginSessionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginSessionModel() when $default != null:
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
    TResult Function(_LoginSessionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginSessionModel():
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
    TResult? Function(_LoginSessionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginSessionModel() when $default != null:
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
            @StringOrNullJson() @JsonKey(name: 'device_id') String? deviceId,
            @StringOrNullJson() @JsonKey(name: 'ip_address') String? ipAddress,
            @StringOrNullJson() @JsonKey(name: 'user_agent') String? userAgent,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt,
            @JsonKey(name: 'is_current', fromJson: _boolOrNull)
            bool? isCurrent)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LoginSessionModel() when $default != null:
        return $default(_that.id, _that.deviceId, _that.ipAddress,
            _that.userAgent, _that.createdAt, _that.expiresAt, _that.isCurrent);
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
            @StringOrNullJson() @JsonKey(name: 'device_id') String? deviceId,
            @StringOrNullJson() @JsonKey(name: 'ip_address') String? ipAddress,
            @StringOrNullJson() @JsonKey(name: 'user_agent') String? userAgent,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt,
            @JsonKey(name: 'is_current', fromJson: _boolOrNull) bool? isCurrent)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginSessionModel():
        return $default(_that.id, _that.deviceId, _that.ipAddress,
            _that.userAgent, _that.createdAt, _that.expiresAt, _that.isCurrent);
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
            @StringOrNullJson() @JsonKey(name: 'device_id') String? deviceId,
            @StringOrNullJson() @JsonKey(name: 'ip_address') String? ipAddress,
            @StringOrNullJson() @JsonKey(name: 'user_agent') String? userAgent,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'expires_at')
            DateTime? expiresAt,
            @JsonKey(name: 'is_current', fromJson: _boolOrNull)
            bool? isCurrent)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LoginSessionModel() when $default != null:
        return $default(_that.id, _that.deviceId, _that.ipAddress,
            _that.userAgent, _that.createdAt, _that.expiresAt, _that.isCurrent);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LoginSessionModel implements LoginSessionModel {
  const _LoginSessionModel(
      {@IntJson() required this.id,
      @StringOrNullJson() @JsonKey(name: 'device_id') this.deviceId,
      @StringOrNullJson() @JsonKey(name: 'ip_address') this.ipAddress,
      @StringOrNullJson() @JsonKey(name: 'user_agent') this.userAgent,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'expires_at') this.expiresAt,
      @JsonKey(name: 'is_current', fromJson: _boolOrNull) this.isCurrent});
  factory _LoginSessionModel.fromJson(Map<String, dynamic> json) =>
      _$LoginSessionModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'ip_address')
  final String? ipAddress;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'user_agent')
  final String? userAgent;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  /// **Field usulan** (belum dikirim server). Kalau kelak ada, nilainya
  /// menang atas tebakan [groupLoginSessions].
  @override
  @JsonKey(name: 'is_current', fromJson: _boolOrNull)
  final bool? isCurrent;

  /// Create a copy of LoginSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginSessionModelCopyWith<_LoginSessionModel> get copyWith =>
      __$LoginSessionModelCopyWithImpl<_LoginSessionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoginSessionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, deviceId, ipAddress,
      userAgent, createdAt, expiresAt, isCurrent);

  @override
  String toString() {
    return 'LoginSessionModel(id: $id, deviceId: $deviceId, ipAddress: $ipAddress, userAgent: $userAgent, createdAt: $createdAt, expiresAt: $expiresAt, isCurrent: $isCurrent)';
  }
}

/// @nodoc
abstract mixin class _$LoginSessionModelCopyWith<$Res>
    implements $LoginSessionModelCopyWith<$Res> {
  factory _$LoginSessionModelCopyWith(
          _LoginSessionModel value, $Res Function(_LoginSessionModel) _then) =
      __$LoginSessionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringOrNullJson() @JsonKey(name: 'device_id') String? deviceId,
      @StringOrNullJson() @JsonKey(name: 'ip_address') String? ipAddress,
      @StringOrNullJson() @JsonKey(name: 'user_agent') String? userAgent,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'is_current', fromJson: _boolOrNull) bool? isCurrent});
}

/// @nodoc
class __$LoginSessionModelCopyWithImpl<$Res>
    implements _$LoginSessionModelCopyWith<$Res> {
  __$LoginSessionModelCopyWithImpl(this._self, this._then);

  final _LoginSessionModel _self;
  final $Res Function(_LoginSessionModel) _then;

  /// Create a copy of LoginSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? deviceId = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
    Object? isCurrent = freezed,
  }) {
    return _then(_LoginSessionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _self.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: freezed == isCurrent
          ? _self.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
mixin _$IdentityVerificationModel {
  @StringJson()
  String get status;

  /// Hanya 4 digit terakhir yang terlihat (`************3456`). NIK utuh
  /// tidak pernah dikirim balik.
  @StringOrNullJson()
  @JsonKey(name: 'id_card_number_masked')
  String? get idCardNumberMasked;
  @StringOrNullJson()
  @JsonKey(name: 'full_name')
  String? get fullName;
  @StringOrNullJson()
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;
  @ServerDateTimeJson()
  @JsonKey(name: 'submitted_at')
  DateTime? get submittedAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;

  /// Create a copy of IdentityVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IdentityVerificationModelCopyWith<IdentityVerificationModel> get copyWith =>
      _$IdentityVerificationModelCopyWithImpl<IdentityVerificationModel>(
          this as IdentityVerificationModel, _$identity);

  /// Serializes this IdentityVerificationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IdentityVerificationModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.idCardNumberMasked, idCardNumberMasked) ||
                other.idCardNumberMasked == idCardNumberMasked) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, idCardNumberMasked,
      fullName, rejectionReason, submittedAt, verifiedAt);

  @override
  String toString() {
    return 'IdentityVerificationModel(status: $status, idCardNumberMasked: $idCardNumberMasked, fullName: $fullName, rejectionReason: $rejectionReason, submittedAt: $submittedAt, verifiedAt: $verifiedAt)';
  }
}

/// @nodoc
abstract mixin class $IdentityVerificationModelCopyWith<$Res> {
  factory $IdentityVerificationModelCopyWith(IdentityVerificationModel value,
          $Res Function(IdentityVerificationModel) _then) =
      _$IdentityVerificationModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() String status,
      @StringOrNullJson()
      @JsonKey(name: 'id_card_number_masked')
      String? idCardNumberMasked,
      @StringOrNullJson() @JsonKey(name: 'full_name') String? fullName,
      @StringOrNullJson()
      @JsonKey(name: 'rejection_reason')
      String? rejectionReason,
      @ServerDateTimeJson()
      @JsonKey(name: 'submitted_at')
      DateTime? submittedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'verified_at')
      DateTime? verifiedAt});
}

/// @nodoc
class _$IdentityVerificationModelCopyWithImpl<$Res>
    implements $IdentityVerificationModelCopyWith<$Res> {
  _$IdentityVerificationModelCopyWithImpl(this._self, this._then);

  final IdentityVerificationModel _self;
  final $Res Function(IdentityVerificationModel) _then;

  /// Create a copy of IdentityVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? idCardNumberMasked = freezed,
    Object? fullName = freezed,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      idCardNumberMasked: freezed == idCardNumberMasked
          ? _self.idCardNumberMasked
          : idCardNumberMasked // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _self.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: freezed == submittedAt
          ? _self.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _self.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [IdentityVerificationModel].
extension IdentityVerificationModelPatterns on IdentityVerificationModel {
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
    TResult Function(_IdentityVerificationModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IdentityVerificationModel() when $default != null:
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
    TResult Function(_IdentityVerificationModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IdentityVerificationModel():
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
    TResult? Function(_IdentityVerificationModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IdentityVerificationModel() when $default != null:
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
            @StringOrNullJson()
            @JsonKey(name: 'id_card_number_masked')
            String? idCardNumberMasked,
            @StringOrNullJson() @JsonKey(name: 'full_name') String? fullName,
            @StringOrNullJson()
            @JsonKey(name: 'rejection_reason')
            String? rejectionReason,
            @ServerDateTimeJson()
            @JsonKey(name: 'submitted_at')
            DateTime? submittedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'verified_at')
            DateTime? verifiedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IdentityVerificationModel() when $default != null:
        return $default(_that.status, _that.idCardNumberMasked, _that.fullName,
            _that.rejectionReason, _that.submittedAt, _that.verifiedAt);
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
            @StringOrNullJson()
            @JsonKey(name: 'id_card_number_masked')
            String? idCardNumberMasked,
            @StringOrNullJson() @JsonKey(name: 'full_name') String? fullName,
            @StringOrNullJson()
            @JsonKey(name: 'rejection_reason')
            String? rejectionReason,
            @ServerDateTimeJson()
            @JsonKey(name: 'submitted_at')
            DateTime? submittedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'verified_at')
            DateTime? verifiedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IdentityVerificationModel():
        return $default(_that.status, _that.idCardNumberMasked, _that.fullName,
            _that.rejectionReason, _that.submittedAt, _that.verifiedAt);
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
            @StringOrNullJson()
            @JsonKey(name: 'id_card_number_masked')
            String? idCardNumberMasked,
            @StringOrNullJson() @JsonKey(name: 'full_name') String? fullName,
            @StringOrNullJson()
            @JsonKey(name: 'rejection_reason')
            String? rejectionReason,
            @ServerDateTimeJson()
            @JsonKey(name: 'submitted_at')
            DateTime? submittedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'verified_at')
            DateTime? verifiedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IdentityVerificationModel() when $default != null:
        return $default(_that.status, _that.idCardNumberMasked, _that.fullName,
            _that.rejectionReason, _that.submittedAt, _that.verifiedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IdentityVerificationModel extends IdentityVerificationModel {
  const _IdentityVerificationModel(
      {@StringJson() this.status = 'none',
      @StringOrNullJson()
      @JsonKey(name: 'id_card_number_masked')
      this.idCardNumberMasked,
      @StringOrNullJson() @JsonKey(name: 'full_name') this.fullName,
      @StringOrNullJson()
      @JsonKey(name: 'rejection_reason')
      this.rejectionReason,
      @ServerDateTimeJson() @JsonKey(name: 'submitted_at') this.submittedAt,
      @ServerDateTimeJson() @JsonKey(name: 'verified_at') this.verifiedAt})
      : super._();
  factory _IdentityVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$IdentityVerificationModelFromJson(json);

  @override
  @JsonKey()
  @StringJson()
  final String status;

  /// Hanya 4 digit terakhir yang terlihat (`************3456`). NIK utuh
  /// tidak pernah dikirim balik.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'id_card_number_masked')
  final String? idCardNumberMasked;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'submitted_at')
  final DateTime? submittedAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;

  /// Create a copy of IdentityVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IdentityVerificationModelCopyWith<_IdentityVerificationModel>
      get copyWith =>
          __$IdentityVerificationModelCopyWithImpl<_IdentityVerificationModel>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IdentityVerificationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IdentityVerificationModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.idCardNumberMasked, idCardNumberMasked) ||
                other.idCardNumberMasked == idCardNumberMasked) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, idCardNumberMasked,
      fullName, rejectionReason, submittedAt, verifiedAt);

  @override
  String toString() {
    return 'IdentityVerificationModel(status: $status, idCardNumberMasked: $idCardNumberMasked, fullName: $fullName, rejectionReason: $rejectionReason, submittedAt: $submittedAt, verifiedAt: $verifiedAt)';
  }
}

/// @nodoc
abstract mixin class _$IdentityVerificationModelCopyWith<$Res>
    implements $IdentityVerificationModelCopyWith<$Res> {
  factory _$IdentityVerificationModelCopyWith(_IdentityVerificationModel value,
          $Res Function(_IdentityVerificationModel) _then) =
      __$IdentityVerificationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() String status,
      @StringOrNullJson()
      @JsonKey(name: 'id_card_number_masked')
      String? idCardNumberMasked,
      @StringOrNullJson() @JsonKey(name: 'full_name') String? fullName,
      @StringOrNullJson()
      @JsonKey(name: 'rejection_reason')
      String? rejectionReason,
      @ServerDateTimeJson()
      @JsonKey(name: 'submitted_at')
      DateTime? submittedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'verified_at')
      DateTime? verifiedAt});
}

/// @nodoc
class __$IdentityVerificationModelCopyWithImpl<$Res>
    implements _$IdentityVerificationModelCopyWith<$Res> {
  __$IdentityVerificationModelCopyWithImpl(this._self, this._then);

  final _IdentityVerificationModel _self;
  final $Res Function(_IdentityVerificationModel) _then;

  /// Create a copy of IdentityVerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? idCardNumberMasked = freezed,
    Object? fullName = freezed,
    Object? rejectionReason = freezed,
    Object? submittedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_IdentityVerificationModel(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      idCardNumberMasked: freezed == idCardNumberMasked
          ? _self.idCardNumberMasked
          : idCardNumberMasked // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _self.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: freezed == submittedAt
          ? _self.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _self.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
