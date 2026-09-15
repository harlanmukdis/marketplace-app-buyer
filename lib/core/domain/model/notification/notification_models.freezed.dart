// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {
  @IntJson()
  int get id;

  /// Jenis mentah; pakai [kind] untuk memilih ikon.
  @StringJson()
  @JsonKey(name: 'type')
  String get typeCode;
  @StringJson()
  String get title;
  @StringJson()
  String get body;

  /// Muatan deep-link, mis. `{"order_id": 123}`.
  ///
  /// ⚠️ **Datang sebagai string berisi JSON, bukan objek.** Kolomnya
  /// bertipe `JSON` di MySQL tapi diteruskan apa adanya oleh driver PHP —
  /// jebakan yang sama persis dengan `selected_couriers` di sesi checkout,
  /// dan alasan field ini memakai [JsonMapJson].
  @JsonMapJson()
  Map<String, dynamic>? get data;
  @BoolJson()
  @JsonKey(name: 'is_read')
  bool get isRead;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      _$NotificationModelCopyWithImpl<NotificationModel>(
          this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeCode, typeCode) ||
                other.typeCode == typeCode) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, typeCode, title, body,
      const DeepCollectionEquality().hash(data), isRead, createdAt);

  @override
  String toString() {
    return 'NotificationModel(id: $id, typeCode: $typeCode, title: $title, body: $body, data: $data, isRead: $isRead, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) _then) =
      _$NotificationModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'type') String typeCode,
      @StringJson() String title,
      @StringJson() String body,
      @JsonMapJson() Map<String, dynamic>? data,
      @BoolJson() @JsonKey(name: 'is_read') bool isRead,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeCode = null,
    Object? title = null,
    Object? body = null,
    Object? data = freezed,
    Object? isRead = null,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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
    TResult Function(_NotificationModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
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
    TResult Function(_NotificationModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel():
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
    TResult? Function(_NotificationModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
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
            @StringJson() String title,
            @StringJson() String body,
            @JsonMapJson() Map<String, dynamic>? data,
            @BoolJson() @JsonKey(name: 'is_read') bool isRead,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
        return $default(_that.id, _that.typeCode, _that.title, _that.body,
            _that.data, _that.isRead, _that.createdAt);
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
            @StringJson() String title,
            @StringJson() String body,
            @JsonMapJson() Map<String, dynamic>? data,
            @BoolJson() @JsonKey(name: 'is_read') bool isRead,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel():
        return $default(_that.id, _that.typeCode, _that.title, _that.body,
            _that.data, _that.isRead, _that.createdAt);
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
            @StringJson() String title,
            @StringJson() String body,
            @JsonMapJson() Map<String, dynamic>? data,
            @BoolJson() @JsonKey(name: 'is_read') bool isRead,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationModel() when $default != null:
        return $default(_that.id, _that.typeCode, _that.title, _that.body,
            _that.data, _that.isRead, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationModel extends NotificationModel {
  const _NotificationModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'type') this.typeCode = '',
      @StringJson() this.title = '',
      @StringJson() this.body = '',
      @JsonMapJson() final Map<String, dynamic>? data,
      @BoolJson() @JsonKey(name: 'is_read') this.isRead = false,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : _data = data,
        super._();
  factory _NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  @override
  @IntJson()
  final int id;

  /// Jenis mentah; pakai [kind] untuk memilih ikon.
  @override
  @StringJson()
  @JsonKey(name: 'type')
  final String typeCode;
  @override
  @JsonKey()
  @StringJson()
  final String title;
  @override
  @JsonKey()
  @StringJson()
  final String body;

  /// Muatan deep-link, mis. `{"order_id": 123}`.
  ///
  /// ⚠️ **Datang sebagai string berisi JSON, bukan objek.** Kolomnya
  /// bertipe `JSON` di MySQL tapi diteruskan apa adanya oleh driver PHP —
  /// jebakan yang sama persis dengan `selected_couriers` di sesi checkout,
  /// dan alasan field ini memakai [JsonMapJson].
  final Map<String, dynamic>? _data;

  /// Muatan deep-link, mis. `{"order_id": 123}`.
  ///
  /// ⚠️ **Datang sebagai string berisi JSON, bukan objek.** Kolomnya
  /// bertipe `JSON` di MySQL tapi diteruskan apa adanya oleh driver PHP —
  /// jebakan yang sama persis dengan `selected_couriers` di sesi checkout,
  /// dan alasan field ini memakai [JsonMapJson].
  @override
  @JsonMapJson()
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @BoolJson()
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationModelCopyWith<_NotificationModel> get copyWith =>
      __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeCode, typeCode) ||
                other.typeCode == typeCode) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, typeCode, title, body,
      const DeepCollectionEquality().hash(_data), isRead, createdAt);

  @override
  String toString() {
    return 'NotificationModel(id: $id, typeCode: $typeCode, title: $title, body: $body, data: $data, isRead: $isRead, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(
          _NotificationModel value, $Res Function(_NotificationModel) _then) =
      __$NotificationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'type') String typeCode,
      @StringJson() String title,
      @StringJson() String body,
      @JsonMapJson() Map<String, dynamic>? data,
      @BoolJson() @JsonKey(name: 'is_read') bool isRead,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? typeCode = null,
    Object? title = null,
    Object? body = null,
    Object? data = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_NotificationModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      typeCode: null == typeCode
          ? _self.typeCode
          : typeCode // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
