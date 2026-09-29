// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreModel {
  @IntJson()
  int get id;
  @StringJson()
  String get name;
  @StringJson()
  String get slug;
  @StringOrNullJson()
  String? get description;
  @StringOrNullJson()
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @StringOrNullJson()
  @JsonKey(name: 'banner_url')
  String? get bannerUrl;
  @DoubleJson()
  @JsonKey(name: 'rating_avg')
  double get ratingAvg;
  @IntJson()
  @JsonKey(name: 'rating_count')
  int get ratingCount;
  @IntJson()
  @JsonKey(name: 'follower_count')
  int get followerCount;
  @ServerDateTimeJson()
  @JsonKey(name: 'opened_at')
  DateTime? get openedAt;

  /// `unverified`, `verified_individual`, `verified_company`,
  /// `official_store`, `managed_by_xpedia` (blueprint Seller Ch.2).
  @StringJson()
  @JsonKey(name: 'primary_status')
  String get primaryStatus;

  /// Xpedia Signature — lencana yang **diberikan**, tidak pernah dibeli.
  @BoolJson()
  @JsonKey(name: 'has_signature_badge')
  bool get hasSignatureBadge;
  @BoolJson()
  @JsonKey(name: 'is_following')
  bool get isFollowing;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoreModelCopyWith<StoreModel> get copyWith =>
      _$StoreModelCopyWithImpl<StoreModel>(this as StoreModel, _$identity);

  /// Serializes this StoreModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.openedAt, openedAt) ||
                other.openedAt == openedAt) &&
            (identical(other.primaryStatus, primaryStatus) ||
                other.primaryStatus == primaryStatus) &&
            (identical(other.hasSignatureBadge, hasSignatureBadge) ||
                other.hasSignatureBadge == hasSignatureBadge) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      description,
      logoUrl,
      bannerUrl,
      ratingAvg,
      ratingCount,
      followerCount,
      openedAt,
      primaryStatus,
      hasSignatureBadge,
      isFollowing);

  @override
  String toString() {
    return 'StoreModel(id: $id, name: $name, slug: $slug, description: $description, logoUrl: $logoUrl, bannerUrl: $bannerUrl, ratingAvg: $ratingAvg, ratingCount: $ratingCount, followerCount: $followerCount, openedAt: $openedAt, primaryStatus: $primaryStatus, hasSignatureBadge: $hasSignatureBadge, isFollowing: $isFollowing)';
  }
}

/// @nodoc
abstract mixin class $StoreModelCopyWith<$Res> {
  factory $StoreModelCopyWith(
          StoreModel value, $Res Function(StoreModel) _then) =
      _$StoreModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String name,
      @StringJson() String slug,
      @StringOrNullJson() String? description,
      @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
      @StringOrNullJson() @JsonKey(name: 'banner_url') String? bannerUrl,
      @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
      @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
      @IntJson() @JsonKey(name: 'follower_count') int followerCount,
      @ServerDateTimeJson() @JsonKey(name: 'opened_at') DateTime? openedAt,
      @StringJson() @JsonKey(name: 'primary_status') String primaryStatus,
      @BoolJson() @JsonKey(name: 'has_signature_badge') bool hasSignatureBadge,
      @BoolJson() @JsonKey(name: 'is_following') bool isFollowing});
}

/// @nodoc
class _$StoreModelCopyWithImpl<$Res> implements $StoreModelCopyWith<$Res> {
  _$StoreModelCopyWithImpl(this._self, this._then);

  final StoreModel _self;
  final $Res Function(StoreModel) _then;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? bannerUrl = freezed,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? followerCount = null,
    Object? openedAt = freezed,
    Object? primaryStatus = null,
    Object? hasSignatureBadge = null,
    Object? isFollowing = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerUrl: freezed == bannerUrl
          ? _self.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ratingAvg: null == ratingAvg
          ? _self.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      followerCount: null == followerCount
          ? _self.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      openedAt: freezed == openedAt
          ? _self.openedAt
          : openedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      primaryStatus: null == primaryStatus
          ? _self.primaryStatus
          : primaryStatus // ignore: cast_nullable_to_non_nullable
              as String,
      hasSignatureBadge: null == hasSignatureBadge
          ? _self.hasSignatureBadge
          : hasSignatureBadge // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowing: null == isFollowing
          ? _self.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [StoreModel].
extension StoreModelPatterns on StoreModel {
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
    TResult Function(_StoreModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StoreModel() when $default != null:
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
    TResult Function(_StoreModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreModel():
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
    TResult? Function(_StoreModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreModel() when $default != null:
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
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() String? description,
            @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
            @StringOrNullJson() @JsonKey(name: 'banner_url') String? bannerUrl,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @IntJson() @JsonKey(name: 'follower_count') int followerCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'opened_at')
            DateTime? openedAt,
            @StringJson() @JsonKey(name: 'primary_status') String primaryStatus,
            @BoolJson()
            @JsonKey(name: 'has_signature_badge')
            bool hasSignatureBadge,
            @BoolJson() @JsonKey(name: 'is_following') bool isFollowing)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StoreModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.description,
            _that.logoUrl,
            _that.bannerUrl,
            _that.ratingAvg,
            _that.ratingCount,
            _that.followerCount,
            _that.openedAt,
            _that.primaryStatus,
            _that.hasSignatureBadge,
            _that.isFollowing);
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
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() String? description,
            @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
            @StringOrNullJson() @JsonKey(name: 'banner_url') String? bannerUrl,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @IntJson() @JsonKey(name: 'follower_count') int followerCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'opened_at')
            DateTime? openedAt,
            @StringJson() @JsonKey(name: 'primary_status') String primaryStatus,
            @BoolJson()
            @JsonKey(name: 'has_signature_badge')
            bool hasSignatureBadge,
            @BoolJson() @JsonKey(name: 'is_following') bool isFollowing)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreModel():
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.description,
            _that.logoUrl,
            _that.bannerUrl,
            _that.ratingAvg,
            _that.ratingCount,
            _that.followerCount,
            _that.openedAt,
            _that.primaryStatus,
            _that.hasSignatureBadge,
            _that.isFollowing);
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
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() String? description,
            @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
            @StringOrNullJson() @JsonKey(name: 'banner_url') String? bannerUrl,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @IntJson() @JsonKey(name: 'follower_count') int followerCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'opened_at')
            DateTime? openedAt,
            @StringJson() @JsonKey(name: 'primary_status') String primaryStatus,
            @BoolJson()
            @JsonKey(name: 'has_signature_badge')
            bool hasSignatureBadge,
            @BoolJson() @JsonKey(name: 'is_following') bool isFollowing)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.description,
            _that.logoUrl,
            _that.bannerUrl,
            _that.ratingAvg,
            _that.ratingCount,
            _that.followerCount,
            _that.openedAt,
            _that.primaryStatus,
            _that.hasSignatureBadge,
            _that.isFollowing);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StoreModel extends StoreModel {
  const _StoreModel(
      {@IntJson() required this.id,
      @StringJson() this.name = '',
      @StringJson() this.slug = '',
      @StringOrNullJson() this.description,
      @StringOrNullJson() @JsonKey(name: 'logo_url') this.logoUrl,
      @StringOrNullJson() @JsonKey(name: 'banner_url') this.bannerUrl,
      @DoubleJson() @JsonKey(name: 'rating_avg') this.ratingAvg = 0,
      @IntJson() @JsonKey(name: 'rating_count') this.ratingCount = 0,
      @IntJson() @JsonKey(name: 'follower_count') this.followerCount = 0,
      @ServerDateTimeJson() @JsonKey(name: 'opened_at') this.openedAt,
      @StringJson()
      @JsonKey(name: 'primary_status')
      this.primaryStatus = 'unverified',
      @BoolJson()
      @JsonKey(name: 'has_signature_badge')
      this.hasSignatureBadge = false,
      @BoolJson() @JsonKey(name: 'is_following') this.isFollowing = false})
      : super._();
  factory _StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @JsonKey()
  @StringJson()
  final String name;
  @override
  @JsonKey()
  @StringJson()
  final String slug;
  @override
  @StringOrNullJson()
  final String? description;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'banner_url')
  final String? bannerUrl;
  @override
  @DoubleJson()
  @JsonKey(name: 'rating_avg')
  final double ratingAvg;
  @override
  @IntJson()
  @JsonKey(name: 'rating_count')
  final int ratingCount;
  @override
  @IntJson()
  @JsonKey(name: 'follower_count')
  final int followerCount;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'opened_at')
  final DateTime? openedAt;

  /// `unverified`, `verified_individual`, `verified_company`,
  /// `official_store`, `managed_by_xpedia` (blueprint Seller Ch.2).
  @override
  @StringJson()
  @JsonKey(name: 'primary_status')
  final String primaryStatus;

  /// Xpedia Signature — lencana yang **diberikan**, tidak pernah dibeli.
  @override
  @BoolJson()
  @JsonKey(name: 'has_signature_badge')
  final bool hasSignatureBadge;
  @override
  @BoolJson()
  @JsonKey(name: 'is_following')
  final bool isFollowing;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StoreModelCopyWith<_StoreModel> get copyWith =>
      __$StoreModelCopyWithImpl<_StoreModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StoreModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.openedAt, openedAt) ||
                other.openedAt == openedAt) &&
            (identical(other.primaryStatus, primaryStatus) ||
                other.primaryStatus == primaryStatus) &&
            (identical(other.hasSignatureBadge, hasSignatureBadge) ||
                other.hasSignatureBadge == hasSignatureBadge) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      description,
      logoUrl,
      bannerUrl,
      ratingAvg,
      ratingCount,
      followerCount,
      openedAt,
      primaryStatus,
      hasSignatureBadge,
      isFollowing);

  @override
  String toString() {
    return 'StoreModel(id: $id, name: $name, slug: $slug, description: $description, logoUrl: $logoUrl, bannerUrl: $bannerUrl, ratingAvg: $ratingAvg, ratingCount: $ratingCount, followerCount: $followerCount, openedAt: $openedAt, primaryStatus: $primaryStatus, hasSignatureBadge: $hasSignatureBadge, isFollowing: $isFollowing)';
  }
}

/// @nodoc
abstract mixin class _$StoreModelCopyWith<$Res>
    implements $StoreModelCopyWith<$Res> {
  factory _$StoreModelCopyWith(
          _StoreModel value, $Res Function(_StoreModel) _then) =
      __$StoreModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String name,
      @StringJson() String slug,
      @StringOrNullJson() String? description,
      @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
      @StringOrNullJson() @JsonKey(name: 'banner_url') String? bannerUrl,
      @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
      @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
      @IntJson() @JsonKey(name: 'follower_count') int followerCount,
      @ServerDateTimeJson() @JsonKey(name: 'opened_at') DateTime? openedAt,
      @StringJson() @JsonKey(name: 'primary_status') String primaryStatus,
      @BoolJson() @JsonKey(name: 'has_signature_badge') bool hasSignatureBadge,
      @BoolJson() @JsonKey(name: 'is_following') bool isFollowing});
}

/// @nodoc
class __$StoreModelCopyWithImpl<$Res> implements _$StoreModelCopyWith<$Res> {
  __$StoreModelCopyWithImpl(this._self, this._then);

  final _StoreModel _self;
  final $Res Function(_StoreModel) _then;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? bannerUrl = freezed,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? followerCount = null,
    Object? openedAt = freezed,
    Object? primaryStatus = null,
    Object? hasSignatureBadge = null,
    Object? isFollowing = null,
  }) {
    return _then(_StoreModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerUrl: freezed == bannerUrl
          ? _self.bannerUrl
          : bannerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ratingAvg: null == ratingAvg
          ? _self.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      followerCount: null == followerCount
          ? _self.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      openedAt: freezed == openedAt
          ? _self.openedAt
          : openedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      primaryStatus: null == primaryStatus
          ? _self.primaryStatus
          : primaryStatus // ignore: cast_nullable_to_non_nullable
              as String,
      hasSignatureBadge: null == hasSignatureBadge
          ? _self.hasSignatureBadge
          : hasSignatureBadge // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowing: null == isFollowing
          ? _self.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$FollowedStoreModel {
  @IntJson()
  int get id;
  @StringJson()
  String get name;
  @StringOrNullJson()
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @DoubleJson()
  @JsonKey(name: 'rating_avg')
  double get ratingAvg;
  @IntJson()
  @JsonKey(name: 'rating_count')
  int get ratingCount;
  @ServerDateTimeJson()
  @JsonKey(name: 'followed_at')
  DateTime? get followedAt;

  /// Create a copy of FollowedStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FollowedStoreModelCopyWith<FollowedStoreModel> get copyWith =>
      _$FollowedStoreModelCopyWithImpl<FollowedStoreModel>(
          this as FollowedStoreModel, _$identity);

  /// Serializes this FollowedStoreModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FollowedStoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.followedAt, followedAt) ||
                other.followedAt == followedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, logoUrl, ratingAvg, ratingCount, followedAt);

  @override
  String toString() {
    return 'FollowedStoreModel(id: $id, name: $name, logoUrl: $logoUrl, ratingAvg: $ratingAvg, ratingCount: $ratingCount, followedAt: $followedAt)';
  }
}

/// @nodoc
abstract mixin class $FollowedStoreModelCopyWith<$Res> {
  factory $FollowedStoreModelCopyWith(
          FollowedStoreModel value, $Res Function(FollowedStoreModel) _then) =
      _$FollowedStoreModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String name,
      @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
      @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
      @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
      @ServerDateTimeJson()
      @JsonKey(name: 'followed_at')
      DateTime? followedAt});
}

/// @nodoc
class _$FollowedStoreModelCopyWithImpl<$Res>
    implements $FollowedStoreModelCopyWith<$Res> {
  _$FollowedStoreModelCopyWithImpl(this._self, this._then);

  final FollowedStoreModel _self;
  final $Res Function(FollowedStoreModel) _then;

  /// Create a copy of FollowedStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? followedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ratingAvg: null == ratingAvg
          ? _self.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      followedAt: freezed == followedAt
          ? _self.followedAt
          : followedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FollowedStoreModel].
extension FollowedStoreModelPatterns on FollowedStoreModel {
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
    TResult Function(_FollowedStoreModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FollowedStoreModel() when $default != null:
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
    TResult Function(_FollowedStoreModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FollowedStoreModel():
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
    TResult? Function(_FollowedStoreModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FollowedStoreModel() when $default != null:
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
            @StringJson() String name,
            @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'followed_at')
            DateTime? followedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FollowedStoreModel() when $default != null:
        return $default(_that.id, _that.name, _that.logoUrl, _that.ratingAvg,
            _that.ratingCount, _that.followedAt);
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
            @StringJson() String name,
            @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'followed_at')
            DateTime? followedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FollowedStoreModel():
        return $default(_that.id, _that.name, _that.logoUrl, _that.ratingAvg,
            _that.ratingCount, _that.followedAt);
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
            @StringJson() String name,
            @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'followed_at')
            DateTime? followedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FollowedStoreModel() when $default != null:
        return $default(_that.id, _that.name, _that.logoUrl, _that.ratingAvg,
            _that.ratingCount, _that.followedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FollowedStoreModel implements FollowedStoreModel {
  const _FollowedStoreModel(
      {@IntJson() required this.id,
      @StringJson() this.name = '',
      @StringOrNullJson() @JsonKey(name: 'logo_url') this.logoUrl,
      @DoubleJson() @JsonKey(name: 'rating_avg') this.ratingAvg = 0,
      @IntJson() @JsonKey(name: 'rating_count') this.ratingCount = 0,
      @ServerDateTimeJson() @JsonKey(name: 'followed_at') this.followedAt});
  factory _FollowedStoreModel.fromJson(Map<String, dynamic> json) =>
      _$FollowedStoreModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @JsonKey()
  @StringJson()
  final String name;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  @DoubleJson()
  @JsonKey(name: 'rating_avg')
  final double ratingAvg;
  @override
  @IntJson()
  @JsonKey(name: 'rating_count')
  final int ratingCount;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'followed_at')
  final DateTime? followedAt;

  /// Create a copy of FollowedStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FollowedStoreModelCopyWith<_FollowedStoreModel> get copyWith =>
      __$FollowedStoreModelCopyWithImpl<_FollowedStoreModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FollowedStoreModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FollowedStoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.followedAt, followedAt) ||
                other.followedAt == followedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, logoUrl, ratingAvg, ratingCount, followedAt);

  @override
  String toString() {
    return 'FollowedStoreModel(id: $id, name: $name, logoUrl: $logoUrl, ratingAvg: $ratingAvg, ratingCount: $ratingCount, followedAt: $followedAt)';
  }
}

/// @nodoc
abstract mixin class _$FollowedStoreModelCopyWith<$Res>
    implements $FollowedStoreModelCopyWith<$Res> {
  factory _$FollowedStoreModelCopyWith(
          _FollowedStoreModel value, $Res Function(_FollowedStoreModel) _then) =
      __$FollowedStoreModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() String name,
      @StringOrNullJson() @JsonKey(name: 'logo_url') String? logoUrl,
      @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
      @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
      @ServerDateTimeJson()
      @JsonKey(name: 'followed_at')
      DateTime? followedAt});
}

/// @nodoc
class __$FollowedStoreModelCopyWithImpl<$Res>
    implements _$FollowedStoreModelCopyWith<$Res> {
  __$FollowedStoreModelCopyWithImpl(this._self, this._then);

  final _FollowedStoreModel _self;
  final $Res Function(_FollowedStoreModel) _then;

  /// Create a copy of FollowedStoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? followedAt = freezed,
  }) {
    return _then(_FollowedStoreModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ratingAvg: null == ratingAvg
          ? _self.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      followedAt: freezed == followedAt
          ? _self.followedAt
          : followedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
