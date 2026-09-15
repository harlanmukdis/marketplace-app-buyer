// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'user_id')
  int get userId;

  /// Server mengisi `'Rumah'` kalau tidak dikirim.
  @StringJson()
  String get label;
  @StringJson()
  @JsonKey(name: 'recipient_name')
  String get recipientName;
  @StringJson()
  String get phone;

  /// Alamat lengkap satu baris. **Bukan** `address_line`.
  @StringJson()
  @JsonKey(name: 'full_address')
  String get fullAddress;
  @StringJson()
  String get city;
  @StringJson()
  String get province;
  @StringJson()
  @JsonKey(name: 'postal_code')
  String get postalCode;
  @DoubleOrNullJson()
  double? get latitude;
  @DoubleOrNullJson()
  double? get longitude;

  /// Dikirim sebagai `"0"`/`"1"`.
  ///
  /// ⚠️ **Boleh lebih dari satu alamat bertanda primary.** Sudah diuji:
  /// menyetel `is_primary: 1` pada alamat kedua **tidak** melepas tanda pada
  /// alamat pertama. Jangan mengandalkan keunikannya — pakai
  /// [primaryAddressOf] yang memilih satu secara deterministik.
  @BoolJson()
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<AddressModel> get copyWith =>
      _$AddressModelCopyWithImpl<AddressModel>(
          this as AddressModel, _$identity);

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddressModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      label,
      recipientName,
      phone,
      fullAddress,
      city,
      province,
      postalCode,
      latitude,
      longitude,
      isPrimary,
      createdAt);

  @override
  String toString() {
    return 'AddressModel(id: $id, userId: $userId, label: $label, recipientName: $recipientName, phone: $phone, fullAddress: $fullAddress, city: $city, province: $province, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, isPrimary: $isPrimary, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
          AddressModel value, $Res Function(AddressModel) _then) =
      _$AddressModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'user_id') int userId,
      @StringJson() String label,
      @StringJson() @JsonKey(name: 'recipient_name') String recipientName,
      @StringJson() String phone,
      @StringJson() @JsonKey(name: 'full_address') String fullAddress,
      @StringJson() String city,
      @StringJson() String province,
      @StringJson() @JsonKey(name: 'postal_code') String postalCode,
      @DoubleOrNullJson() double? latitude,
      @DoubleOrNullJson() double? longitude,
      @BoolJson() @JsonKey(name: 'is_primary') bool isPrimary,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$AddressModelCopyWithImpl<$Res> implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._self, this._then);

  final AddressModel _self;
  final $Res Function(AddressModel) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? label = null,
    Object? recipientName = null,
    Object? phone = null,
    Object? fullAddress = null,
    Object? city = null,
    Object? province = null,
    Object? postalCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isPrimary = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      recipientName: null == recipientName
          ? _self.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      fullAddress: null == fullAddress
          ? _self.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _self.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AddressModel].
extension AddressModelPatterns on AddressModel {
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
    TResult Function(_AddressModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddressModel() when $default != null:
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
    TResult Function(_AddressModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressModel():
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
    TResult? Function(_AddressModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @StringJson() String label,
            @StringJson() @JsonKey(name: 'recipient_name') String recipientName,
            @StringJson() String phone,
            @StringJson() @JsonKey(name: 'full_address') String fullAddress,
            @StringJson() String city,
            @StringJson() String province,
            @StringJson() @JsonKey(name: 'postal_code') String postalCode,
            @DoubleOrNullJson() double? latitude,
            @DoubleOrNullJson() double? longitude,
            @BoolJson() @JsonKey(name: 'is_primary') bool isPrimary,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddressModel() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.label,
            _that.recipientName,
            _that.phone,
            _that.fullAddress,
            _that.city,
            _that.province,
            _that.postalCode,
            _that.latitude,
            _that.longitude,
            _that.isPrimary,
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
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @StringJson() String label,
            @StringJson() @JsonKey(name: 'recipient_name') String recipientName,
            @StringJson() String phone,
            @StringJson() @JsonKey(name: 'full_address') String fullAddress,
            @StringJson() String city,
            @StringJson() String province,
            @StringJson() @JsonKey(name: 'postal_code') String postalCode,
            @DoubleOrNullJson() double? latitude,
            @DoubleOrNullJson() double? longitude,
            @BoolJson() @JsonKey(name: 'is_primary') bool isPrimary,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressModel():
        return $default(
            _that.id,
            _that.userId,
            _that.label,
            _that.recipientName,
            _that.phone,
            _that.fullAddress,
            _that.city,
            _that.province,
            _that.postalCode,
            _that.latitude,
            _that.longitude,
            _that.isPrimary,
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
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @StringJson() String label,
            @StringJson() @JsonKey(name: 'recipient_name') String recipientName,
            @StringJson() String phone,
            @StringJson() @JsonKey(name: 'full_address') String fullAddress,
            @StringJson() String city,
            @StringJson() String province,
            @StringJson() @JsonKey(name: 'postal_code') String postalCode,
            @DoubleOrNullJson() double? latitude,
            @DoubleOrNullJson() double? longitude,
            @BoolJson() @JsonKey(name: 'is_primary') bool isPrimary,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddressModel() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.label,
            _that.recipientName,
            _that.phone,
            _that.fullAddress,
            _that.city,
            _that.province,
            _that.postalCode,
            _that.latitude,
            _that.longitude,
            _that.isPrimary,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AddressModel extends AddressModel {
  const _AddressModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'user_id') this.userId = 0,
      @StringJson() this.label = '',
      @StringJson() @JsonKey(name: 'recipient_name') this.recipientName = '',
      @StringJson() this.phone = '',
      @StringJson() @JsonKey(name: 'full_address') this.fullAddress = '',
      @StringJson() this.city = '',
      @StringJson() this.province = '',
      @StringJson() @JsonKey(name: 'postal_code') this.postalCode = '',
      @DoubleOrNullJson() this.latitude,
      @DoubleOrNullJson() this.longitude,
      @BoolJson() @JsonKey(name: 'is_primary') this.isPrimary = false,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'user_id')
  final int userId;

  /// Server mengisi `'Rumah'` kalau tidak dikirim.
  @override
  @JsonKey()
  @StringJson()
  final String label;
  @override
  @StringJson()
  @JsonKey(name: 'recipient_name')
  final String recipientName;
  @override
  @JsonKey()
  @StringJson()
  final String phone;

  /// Alamat lengkap satu baris. **Bukan** `address_line`.
  @override
  @StringJson()
  @JsonKey(name: 'full_address')
  final String fullAddress;
  @override
  @JsonKey()
  @StringJson()
  final String city;
  @override
  @JsonKey()
  @StringJson()
  final String province;
  @override
  @StringJson()
  @JsonKey(name: 'postal_code')
  final String postalCode;
  @override
  @DoubleOrNullJson()
  final double? latitude;
  @override
  @DoubleOrNullJson()
  final double? longitude;

  /// Dikirim sebagai `"0"`/`"1"`.
  ///
  /// ⚠️ **Boleh lebih dari satu alamat bertanda primary.** Sudah diuji:
  /// menyetel `is_primary: 1` pada alamat kedua **tidak** melepas tanda pada
  /// alamat pertama. Jangan mengandalkan keunikannya — pakai
  /// [primaryAddressOf] yang memilih satu secara deterministik.
  @override
  @BoolJson()
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddressModelCopyWith<_AddressModel> get copyWith =>
      __$AddressModelCopyWithImpl<_AddressModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AddressModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddressModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      label,
      recipientName,
      phone,
      fullAddress,
      city,
      province,
      postalCode,
      latitude,
      longitude,
      isPrimary,
      createdAt);

  @override
  String toString() {
    return 'AddressModel(id: $id, userId: $userId, label: $label, recipientName: $recipientName, phone: $phone, fullAddress: $fullAddress, city: $city, province: $province, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, isPrimary: $isPrimary, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AddressModelCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$AddressModelCopyWith(
          _AddressModel value, $Res Function(_AddressModel) _then) =
      __$AddressModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'user_id') int userId,
      @StringJson() String label,
      @StringJson() @JsonKey(name: 'recipient_name') String recipientName,
      @StringJson() String phone,
      @StringJson() @JsonKey(name: 'full_address') String fullAddress,
      @StringJson() String city,
      @StringJson() String province,
      @StringJson() @JsonKey(name: 'postal_code') String postalCode,
      @DoubleOrNullJson() double? latitude,
      @DoubleOrNullJson() double? longitude,
      @BoolJson() @JsonKey(name: 'is_primary') bool isPrimary,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$AddressModelCopyWithImpl<$Res>
    implements _$AddressModelCopyWith<$Res> {
  __$AddressModelCopyWithImpl(this._self, this._then);

  final _AddressModel _self;
  final $Res Function(_AddressModel) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? label = null,
    Object? recipientName = null,
    Object? phone = null,
    Object? fullAddress = null,
    Object? city = null,
    Object? province = null,
    Object? postalCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isPrimary = null,
    Object? createdAt = freezed,
  }) {
    return _then(_AddressModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      recipientName: null == recipientName
          ? _self.recipientName
          : recipientName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      fullAddress: null == fullAddress
          ? _self.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _self.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _self.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
