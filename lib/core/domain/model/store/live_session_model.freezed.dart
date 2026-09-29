// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveSessionModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'store_id')
  int get storeId;
  @StringJson()
  @JsonKey(name: 'store_name')
  String get storeName;
  @StringJson()
  String get title;
  @StringOrNullJson()
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;

  /// `scheduled` / `live` / `ended` / `cancelled` (ENUM `live_sessions.status`).
  @StringJson()
  String get status;
  @IntJson()
  @JsonKey(name: 'viewer_count')
  int get viewerCount;
  @ServerDateTimeJson()
  @JsonKey(name: 'started_at')
  DateTime? get startedAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'scheduled_at')
  DateTime? get scheduledAt;

  /// Label promo singkat dari penjual ("Diskon 50%"). Usulan kolom baru.
  @StringOrNullJson()
  @JsonKey(name: 'promo_label')
  String? get promoLabel;

  /// Unit terjual selama sesi. ⚠️ Atribusi order ke sesi live **belum
  /// dilacak** backend (`Live_model::update_session_metrics`), jadi angka ini
  /// butuh pekerjaan backend tersendiri.
  @IntJson()
  @JsonKey(name: 'sold_count')
  int get soldCount;

  /// Create a copy of LiveSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LiveSessionModelCopyWith<LiveSessionModel> get copyWith =>
      _$LiveSessionModelCopyWithImpl<LiveSessionModel>(
          this as LiveSessionModel, _$identity);

  /// Serializes this LiveSessionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LiveSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.viewerCount, viewerCount) ||
                other.viewerCount == viewerCount) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.promoLabel, promoLabel) ||
                other.promoLabel == promoLabel) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      storeName,
      title,
      thumbnailUrl,
      status,
      viewerCount,
      startedAt,
      scheduledAt,
      promoLabel,
      soldCount);

  @override
  String toString() {
    return 'LiveSessionModel(id: $id, storeId: $storeId, storeName: $storeName, title: $title, thumbnailUrl: $thumbnailUrl, status: $status, viewerCount: $viewerCount, startedAt: $startedAt, scheduledAt: $scheduledAt, promoLabel: $promoLabel, soldCount: $soldCount)';
  }
}

/// @nodoc
abstract mixin class $LiveSessionModelCopyWith<$Res> {
  factory $LiveSessionModelCopyWith(
          LiveSessionModel value, $Res Function(LiveSessionModel) _then) =
      _$LiveSessionModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() @JsonKey(name: 'store_name') String storeName,
      @StringJson() String title,
      @StringOrNullJson() @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @StringJson() String status,
      @IntJson() @JsonKey(name: 'viewer_count') int viewerCount,
      @ServerDateTimeJson() @JsonKey(name: 'started_at') DateTime? startedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'scheduled_at')
      DateTime? scheduledAt,
      @StringOrNullJson() @JsonKey(name: 'promo_label') String? promoLabel,
      @IntJson() @JsonKey(name: 'sold_count') int soldCount});
}

/// @nodoc
class _$LiveSessionModelCopyWithImpl<$Res>
    implements $LiveSessionModelCopyWith<$Res> {
  _$LiveSessionModelCopyWithImpl(this._self, this._then);

  final LiveSessionModel _self;
  final $Res Function(LiveSessionModel) _then;

  /// Create a copy of LiveSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? title = null,
    Object? thumbnailUrl = freezed,
    Object? status = null,
    Object? viewerCount = null,
    Object? startedAt = freezed,
    Object? scheduledAt = freezed,
    Object? promoLabel = freezed,
    Object? soldCount = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      viewerCount: null == viewerCount
          ? _self.viewerCount
          : viewerCount // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledAt: freezed == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      promoLabel: freezed == promoLabel
          ? _self.promoLabel
          : promoLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      soldCount: null == soldCount
          ? _self.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [LiveSessionModel].
extension LiveSessionModelPatterns on LiveSessionModel {
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
    TResult Function(_LiveSessionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LiveSessionModel() when $default != null:
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
    TResult Function(_LiveSessionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LiveSessionModel():
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
    TResult? Function(_LiveSessionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LiveSessionModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @StringJson() String title,
            @StringOrNullJson()
            @JsonKey(name: 'thumbnail_url')
            String? thumbnailUrl,
            @StringJson() String status,
            @IntJson() @JsonKey(name: 'viewer_count') int viewerCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'started_at')
            DateTime? startedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'scheduled_at')
            DateTime? scheduledAt,
            @StringOrNullJson()
            @JsonKey(name: 'promo_label')
            String? promoLabel,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LiveSessionModel() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.storeName,
            _that.title,
            _that.thumbnailUrl,
            _that.status,
            _that.viewerCount,
            _that.startedAt,
            _that.scheduledAt,
            _that.promoLabel,
            _that.soldCount);
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
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @StringJson() String title,
            @StringOrNullJson()
            @JsonKey(name: 'thumbnail_url')
            String? thumbnailUrl,
            @StringJson() String status,
            @IntJson() @JsonKey(name: 'viewer_count') int viewerCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'started_at')
            DateTime? startedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'scheduled_at')
            DateTime? scheduledAt,
            @StringOrNullJson()
            @JsonKey(name: 'promo_label')
            String? promoLabel,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LiveSessionModel():
        return $default(
            _that.id,
            _that.storeId,
            _that.storeName,
            _that.title,
            _that.thumbnailUrl,
            _that.status,
            _that.viewerCount,
            _that.startedAt,
            _that.scheduledAt,
            _that.promoLabel,
            _that.soldCount);
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
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @StringJson() String title,
            @StringOrNullJson()
            @JsonKey(name: 'thumbnail_url')
            String? thumbnailUrl,
            @StringJson() String status,
            @IntJson() @JsonKey(name: 'viewer_count') int viewerCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'started_at')
            DateTime? startedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'scheduled_at')
            DateTime? scheduledAt,
            @StringOrNullJson()
            @JsonKey(name: 'promo_label')
            String? promoLabel,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LiveSessionModel() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.storeName,
            _that.title,
            _that.thumbnailUrl,
            _that.status,
            _that.viewerCount,
            _that.startedAt,
            _that.scheduledAt,
            _that.promoLabel,
            _that.soldCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LiveSessionModel extends LiveSessionModel {
  const _LiveSessionModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'store_id') this.storeId = 0,
      @StringJson() @JsonKey(name: 'store_name') this.storeName = '',
      @StringJson() this.title = '',
      @StringOrNullJson() @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      @StringJson() this.status = 'live',
      @IntJson() @JsonKey(name: 'viewer_count') this.viewerCount = 0,
      @ServerDateTimeJson() @JsonKey(name: 'started_at') this.startedAt,
      @ServerDateTimeJson() @JsonKey(name: 'scheduled_at') this.scheduledAt,
      @StringOrNullJson() @JsonKey(name: 'promo_label') this.promoLabel,
      @IntJson() @JsonKey(name: 'sold_count') this.soldCount = 0})
      : super._();
  factory _LiveSessionModel.fromJson(Map<String, dynamic> json) =>
      _$LiveSessionModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'store_id')
  final int storeId;
  @override
  @StringJson()
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @JsonKey()
  @StringJson()
  final String title;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  /// `scheduled` / `live` / `ended` / `cancelled` (ENUM `live_sessions.status`).
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @IntJson()
  @JsonKey(name: 'viewer_count')
  final int viewerCount;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'scheduled_at')
  final DateTime? scheduledAt;

  /// Label promo singkat dari penjual ("Diskon 50%"). Usulan kolom baru.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'promo_label')
  final String? promoLabel;

  /// Unit terjual selama sesi. ⚠️ Atribusi order ke sesi live **belum
  /// dilacak** backend (`Live_model::update_session_metrics`), jadi angka ini
  /// butuh pekerjaan backend tersendiri.
  @override
  @IntJson()
  @JsonKey(name: 'sold_count')
  final int soldCount;

  /// Create a copy of LiveSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LiveSessionModelCopyWith<_LiveSessionModel> get copyWith =>
      __$LiveSessionModelCopyWithImpl<_LiveSessionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LiveSessionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LiveSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.viewerCount, viewerCount) ||
                other.viewerCount == viewerCount) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.promoLabel, promoLabel) ||
                other.promoLabel == promoLabel) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      storeName,
      title,
      thumbnailUrl,
      status,
      viewerCount,
      startedAt,
      scheduledAt,
      promoLabel,
      soldCount);

  @override
  String toString() {
    return 'LiveSessionModel(id: $id, storeId: $storeId, storeName: $storeName, title: $title, thumbnailUrl: $thumbnailUrl, status: $status, viewerCount: $viewerCount, startedAt: $startedAt, scheduledAt: $scheduledAt, promoLabel: $promoLabel, soldCount: $soldCount)';
  }
}

/// @nodoc
abstract mixin class _$LiveSessionModelCopyWith<$Res>
    implements $LiveSessionModelCopyWith<$Res> {
  factory _$LiveSessionModelCopyWith(
          _LiveSessionModel value, $Res Function(_LiveSessionModel) _then) =
      __$LiveSessionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() @JsonKey(name: 'store_name') String storeName,
      @StringJson() String title,
      @StringOrNullJson() @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @StringJson() String status,
      @IntJson() @JsonKey(name: 'viewer_count') int viewerCount,
      @ServerDateTimeJson() @JsonKey(name: 'started_at') DateTime? startedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'scheduled_at')
      DateTime? scheduledAt,
      @StringOrNullJson() @JsonKey(name: 'promo_label') String? promoLabel,
      @IntJson() @JsonKey(name: 'sold_count') int soldCount});
}

/// @nodoc
class __$LiveSessionModelCopyWithImpl<$Res>
    implements _$LiveSessionModelCopyWith<$Res> {
  __$LiveSessionModelCopyWithImpl(this._self, this._then);

  final _LiveSessionModel _self;
  final $Res Function(_LiveSessionModel) _then;

  /// Create a copy of LiveSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? title = null,
    Object? thumbnailUrl = freezed,
    Object? status = null,
    Object? viewerCount = null,
    Object? startedAt = freezed,
    Object? scheduledAt = freezed,
    Object? promoLabel = freezed,
    Object? soldCount = null,
  }) {
    return _then(_LiveSessionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      viewerCount: null == viewerCount
          ? _self.viewerCount
          : viewerCount // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledAt: freezed == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      promoLabel: freezed == promoLabel
          ? _self.promoLabel
          : promoLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      soldCount: null == soldCount
          ? _self.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
