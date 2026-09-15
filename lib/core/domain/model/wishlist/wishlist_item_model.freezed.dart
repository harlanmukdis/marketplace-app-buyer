// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishlistItemModel {
  @IntJson()
  @JsonKey(name: 'wishlist_item_id')
  int get wishlistItemId;

  /// Id produk — **ini** yang dipakai untuk menghapus dan membuka detail.
  @IntJson()
  @JsonKey(name: 'product_id')
  int get productId;
  @StringJson()
  String get name;
  @StringJson()
  String get slug;

  /// Harga terendah di antara varian produk.
  @DoubleJson()
  @JsonKey(name: 'min_price')
  double get minPrice;
  @StringOrNullJson()
  @JsonKey(name: 'image_url')
  String? get imageUrl;

  /// Status produknya, bukan status baris wishlist. Produk yang sudah tidak
  /// `active` tetap tampil di wishlist — layar yang menandainya.
  @StringJson()
  @JsonKey(name: 'product_status')
  String get productStatus;
  @ServerDateTimeJson()
  @JsonKey(name: 'added_at')
  DateTime? get addedAt;

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WishlistItemModelCopyWith<WishlistItemModel> get copyWith =>
      _$WishlistItemModelCopyWithImpl<WishlistItemModel>(
          this as WishlistItemModel, _$identity);

  /// Serializes this WishlistItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WishlistItemModel &&
            (identical(other.wishlistItemId, wishlistItemId) ||
                other.wishlistItemId == wishlistItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.productStatus, productStatus) ||
                other.productStatus == productStatus) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wishlistItemId, productId, name,
      slug, minPrice, imageUrl, productStatus, addedAt);

  @override
  String toString() {
    return 'WishlistItemModel(wishlistItemId: $wishlistItemId, productId: $productId, name: $name, slug: $slug, minPrice: $minPrice, imageUrl: $imageUrl, productStatus: $productStatus, addedAt: $addedAt)';
  }
}

/// @nodoc
abstract mixin class $WishlistItemModelCopyWith<$Res> {
  factory $WishlistItemModelCopyWith(
          WishlistItemModel value, $Res Function(WishlistItemModel) _then) =
      _$WishlistItemModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() @JsonKey(name: 'wishlist_item_id') int wishlistItemId,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @StringJson() String name,
      @StringJson() String slug,
      @DoubleJson() @JsonKey(name: 'min_price') double minPrice,
      @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
      @StringJson() @JsonKey(name: 'product_status') String productStatus,
      @ServerDateTimeJson() @JsonKey(name: 'added_at') DateTime? addedAt});
}

/// @nodoc
class _$WishlistItemModelCopyWithImpl<$Res>
    implements $WishlistItemModelCopyWith<$Res> {
  _$WishlistItemModelCopyWithImpl(this._self, this._then);

  final WishlistItemModel _self;
  final $Res Function(WishlistItemModel) _then;

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wishlistItemId = null,
    Object? productId = null,
    Object? name = null,
    Object? slug = null,
    Object? minPrice = null,
    Object? imageUrl = freezed,
    Object? productStatus = null,
    Object? addedAt = freezed,
  }) {
    return _then(_self.copyWith(
      wishlistItemId: null == wishlistItemId
          ? _self.wishlistItemId
          : wishlistItemId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      minPrice: null == minPrice
          ? _self.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productStatus: null == productStatus
          ? _self.productStatus
          : productStatus // ignore: cast_nullable_to_non_nullable
              as String,
      addedAt: freezed == addedAt
          ? _self.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [WishlistItemModel].
extension WishlistItemModelPatterns on WishlistItemModel {
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
    TResult Function(_WishlistItemModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WishlistItemModel() when $default != null:
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
    TResult Function(_WishlistItemModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WishlistItemModel():
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
    TResult? Function(_WishlistItemModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WishlistItemModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'wishlist_item_id') int wishlistItemId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @StringJson() String name,
            @StringJson() String slug,
            @DoubleJson() @JsonKey(name: 'min_price') double minPrice,
            @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
            @StringJson() @JsonKey(name: 'product_status') String productStatus,
            @ServerDateTimeJson() @JsonKey(name: 'added_at') DateTime? addedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WishlistItemModel() when $default != null:
        return $default(
            _that.wishlistItemId,
            _that.productId,
            _that.name,
            _that.slug,
            _that.minPrice,
            _that.imageUrl,
            _that.productStatus,
            _that.addedAt);
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
            @IntJson() @JsonKey(name: 'wishlist_item_id') int wishlistItemId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @StringJson() String name,
            @StringJson() String slug,
            @DoubleJson() @JsonKey(name: 'min_price') double minPrice,
            @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
            @StringJson() @JsonKey(name: 'product_status') String productStatus,
            @ServerDateTimeJson() @JsonKey(name: 'added_at') DateTime? addedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WishlistItemModel():
        return $default(
            _that.wishlistItemId,
            _that.productId,
            _that.name,
            _that.slug,
            _that.minPrice,
            _that.imageUrl,
            _that.productStatus,
            _that.addedAt);
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
            @IntJson() @JsonKey(name: 'wishlist_item_id') int wishlistItemId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @StringJson() String name,
            @StringJson() String slug,
            @DoubleJson() @JsonKey(name: 'min_price') double minPrice,
            @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
            @StringJson() @JsonKey(name: 'product_status') String productStatus,
            @ServerDateTimeJson() @JsonKey(name: 'added_at') DateTime? addedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WishlistItemModel() when $default != null:
        return $default(
            _that.wishlistItemId,
            _that.productId,
            _that.name,
            _that.slug,
            _that.minPrice,
            _that.imageUrl,
            _that.productStatus,
            _that.addedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WishlistItemModel extends WishlistItemModel {
  const _WishlistItemModel(
      {@IntJson() @JsonKey(name: 'wishlist_item_id') this.wishlistItemId = 0,
      @IntJson() @JsonKey(name: 'product_id') required this.productId,
      @StringJson() this.name = '',
      @StringJson() this.slug = '',
      @DoubleJson() @JsonKey(name: 'min_price') this.minPrice = 0,
      @StringOrNullJson() @JsonKey(name: 'image_url') this.imageUrl,
      @StringJson()
      @JsonKey(name: 'product_status')
      this.productStatus = 'active',
      @ServerDateTimeJson() @JsonKey(name: 'added_at') this.addedAt})
      : super._();
  factory _WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);

  @override
  @IntJson()
  @JsonKey(name: 'wishlist_item_id')
  final int wishlistItemId;

  /// Id produk — **ini** yang dipakai untuk menghapus dan membuka detail.
  @override
  @IntJson()
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  @JsonKey()
  @StringJson()
  final String name;
  @override
  @JsonKey()
  @StringJson()
  final String slug;

  /// Harga terendah di antara varian produk.
  @override
  @DoubleJson()
  @JsonKey(name: 'min_price')
  final double minPrice;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  /// Status produknya, bukan status baris wishlist. Produk yang sudah tidak
  /// `active` tetap tampil di wishlist — layar yang menandainya.
  @override
  @StringJson()
  @JsonKey(name: 'product_status')
  final String productStatus;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'added_at')
  final DateTime? addedAt;

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WishlistItemModelCopyWith<_WishlistItemModel> get copyWith =>
      __$WishlistItemModelCopyWithImpl<_WishlistItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WishlistItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WishlistItemModel &&
            (identical(other.wishlistItemId, wishlistItemId) ||
                other.wishlistItemId == wishlistItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.productStatus, productStatus) ||
                other.productStatus == productStatus) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wishlistItemId, productId, name,
      slug, minPrice, imageUrl, productStatus, addedAt);

  @override
  String toString() {
    return 'WishlistItemModel(wishlistItemId: $wishlistItemId, productId: $productId, name: $name, slug: $slug, minPrice: $minPrice, imageUrl: $imageUrl, productStatus: $productStatus, addedAt: $addedAt)';
  }
}

/// @nodoc
abstract mixin class _$WishlistItemModelCopyWith<$Res>
    implements $WishlistItemModelCopyWith<$Res> {
  factory _$WishlistItemModelCopyWith(
          _WishlistItemModel value, $Res Function(_WishlistItemModel) _then) =
      __$WishlistItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() @JsonKey(name: 'wishlist_item_id') int wishlistItemId,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @StringJson() String name,
      @StringJson() String slug,
      @DoubleJson() @JsonKey(name: 'min_price') double minPrice,
      @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
      @StringJson() @JsonKey(name: 'product_status') String productStatus,
      @ServerDateTimeJson() @JsonKey(name: 'added_at') DateTime? addedAt});
}

/// @nodoc
class __$WishlistItemModelCopyWithImpl<$Res>
    implements _$WishlistItemModelCopyWith<$Res> {
  __$WishlistItemModelCopyWithImpl(this._self, this._then);

  final _WishlistItemModel _self;
  final $Res Function(_WishlistItemModel) _then;

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? wishlistItemId = null,
    Object? productId = null,
    Object? name = null,
    Object? slug = null,
    Object? minPrice = null,
    Object? imageUrl = freezed,
    Object? productStatus = null,
    Object? addedAt = freezed,
  }) {
    return _then(_WishlistItemModel(
      wishlistItemId: null == wishlistItemId
          ? _self.wishlistItemId
          : wishlistItemId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      minPrice: null == minPrice
          ? _self.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productStatus: null == productStatus
          ? _self.productStatus
          : productStatus // ignore: cast_nullable_to_non_nullable
              as String,
      addedAt: freezed == addedAt
          ? _self.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
