// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'store_id')
  int get storeId;
  @StringJson()
  String get name;
  @StringJson()
  String get slug;
  @StringOrNullJson()
  String? get description;

  /// `physical` / `digital` / `service`.
  @StringJson()
  @JsonKey(name: 'product_type')
  String get productType;
  @DoubleJson()
  @JsonKey(name: 'base_price')
  double get basePrice;

  /// Harga coret, **independen dari flash sale**. `null` = tidak ada diskon.
  @DoubleOrNullJson()
  @JsonKey(name: 'compare_at_price')
  double? get compareAtPrice;
  @IntOrNullJson()
  @JsonKey(name: 'weight_grams')
  int? get weightGrams;
  @StringJson()
  String get status;
  @IntJson()
  @JsonKey(name: 'sold_count')
  int get soldCount;
  @IntJson()
  @JsonKey(name: 'view_count')
  int get viewCount;
  @DoubleJson()
  @JsonKey(name: 'rating_avg')
  double get ratingAvg;
  @IntJson()
  @JsonKey(name: 'rating_count')
  int get ratingCount;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Total `quantity_available` (on_hand − reserved) lintas gudang.
  ///
  /// Datang sebagai **integer asli**, bukan string — berbeda dari mayoritas
  /// field lain. Hanya ada di detail; `null` di listing.
  @IntOrNullJson()
  int? get stock;

  /// Hanya ada kalau produk sedang ikut flash sale aktif.
  ///
  /// Di JSON key-nya **absen sama sekali**, bukan `null`. Untuk Dart keduanya
  /// sama-sama jadi `null`, jadi cukup periksa null — tapi jangan menulis
  /// kode yang mengandalkan key-nya selalu ada.
  @JsonKey(name: 'flash_sale')
  FlashSaleModel? get flashSale;

  /// Gambar utama **versi listing**, satu URL datar.
  ///
  /// Ditambahkan backend pada commit `db8a626` ("Add image_url to GET
  /// /products listing (was always missing)"). Sebelumnya `GET /products`
  /// tidak membawa gambar sama sekali, sehingga setiap kartu produk terpaksa
  /// memakai placeholder — satu-satunya alternatifnya menembak detail per
  /// kartu (N+1).
  ///
  /// ⚠️ Hanya ada di **listing**; `GET /products/{id}` tidak mengirimkannya
  /// dan memakai [images] sebagai gantinya. Pakai [primaryImageUrl] yang
  /// menyerap keduanya, jangan field ini langsung.
  @StringOrNullJson()
  @JsonKey(name: 'image_url')
  String? get listingImageUrl;

  /// Label kartu produk, dihitung **server** (commit `7328161`).
  ///
  /// Subset dari `["new", "best_seller", "hot", "sale"]`, dan ada di
  /// **listing maupun detail**. Nilainya diturunkan dari field yang sudah
  /// ada di baris yang sama (`created_at`, `sold_count`, `view_count`,
  /// `compare_at_price`, `flash_sale`) tanpa query tambahan.
  ///
  /// Sengaja dihitung server supaya web dan mobile tidak menurunkan ambang
  /// yang sama sendiri-sendiri lalu menampilkan label yang berbeda untuk
  /// produk yang sama. **Jangan menghitung ulang di sini** — pakai
  /// [badgeLabels] apa adanya.
  ///
  /// ⚠️ Tetap `List<String>` mentah, bukan enum: kolomnya bebas di server
  /// dan ambangnya akan pindah ke `admin_settings`, jadi nilai baru bisa
  /// muncul kapan saja. [badgeLabels] membuang yang tidak dikenal.
  List<String> get badges;

  /// Mode pemenuhan yang dipilih penjual (backend v1.6+, blueprint Seller
  /// Ch.1): `ready_stock`, `infinite`, `pre_order`, `custom_order`,
  /// `discontinued`. Ada di **listing maupun detail**. Pakai [stockMode],
  /// jangan string ini langsung.
  @StringJson()
  @JsonKey(name: 'fulfillment_mode')
  String get fulfillmentMode;

  /// Lama pengerjaan dalam hari — wajib untuk `pre_order`/`custom_order`,
  /// `null` untuk mode lain.
  @IntOrNullJson()
  @JsonKey(name: 'fulfillment_lead_time_days')
  int? get fulfillmentLeadTimeDays;

  /// Ketersediaan hasil hitungan server, **hanya di detail**:
  /// [fulfillmentMode] ditambah `low_stock`/`out_of_stock` yang diturunkan
  /// dari stok live (`<= 10` dianggap menipis). `null` di listing.
  @StringOrNullJson()
  String? get availability;
  List<ProductVariantModel> get variants;
  List<ProductImageModel> get images;
  List<CourierModel> get couriers;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductModelCopyWith<ProductModel> get copyWith =>
      _$ProductModelCopyWithImpl<ProductModel>(
          this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.flashSale, flashSale) ||
                other.flashSale == flashSale) &&
            (identical(other.listingImageUrl, listingImageUrl) ||
                other.listingImageUrl == listingImageUrl) &&
            const DeepCollectionEquality().equals(other.badges, badges) &&
            (identical(other.fulfillmentMode, fulfillmentMode) ||
                other.fulfillmentMode == fulfillmentMode) &&
            (identical(
                    other.fulfillmentLeadTimeDays, fulfillmentLeadTimeDays) ||
                other.fulfillmentLeadTimeDays == fulfillmentLeadTimeDays) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            const DeepCollectionEquality().equals(other.variants, variants) &&
            const DeepCollectionEquality().equals(other.images, images) &&
            const DeepCollectionEquality().equals(other.couriers, couriers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        storeId,
        name,
        slug,
        description,
        productType,
        basePrice,
        compareAtPrice,
        weightGrams,
        status,
        soldCount,
        viewCount,
        ratingAvg,
        ratingCount,
        createdAt,
        stock,
        flashSale,
        listingImageUrl,
        const DeepCollectionEquality().hash(badges),
        fulfillmentMode,
        fulfillmentLeadTimeDays,
        availability,
        const DeepCollectionEquality().hash(variants),
        const DeepCollectionEquality().hash(images),
        const DeepCollectionEquality().hash(couriers)
      ]);

  @override
  String toString() {
    return 'ProductModel(id: $id, storeId: $storeId, name: $name, slug: $slug, description: $description, productType: $productType, basePrice: $basePrice, compareAtPrice: $compareAtPrice, weightGrams: $weightGrams, status: $status, soldCount: $soldCount, viewCount: $viewCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, createdAt: $createdAt, stock: $stock, flashSale: $flashSale, listingImageUrl: $listingImageUrl, badges: $badges, fulfillmentMode: $fulfillmentMode, fulfillmentLeadTimeDays: $fulfillmentLeadTimeDays, availability: $availability, variants: $variants, images: $images, couriers: $couriers)';
  }
}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) _then) =
      _$ProductModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() String name,
      @StringJson() String slug,
      @StringOrNullJson() String? description,
      @StringJson() @JsonKey(name: 'product_type') String productType,
      @DoubleJson() @JsonKey(name: 'base_price') double basePrice,
      @DoubleOrNullJson()
      @JsonKey(name: 'compare_at_price')
      double? compareAtPrice,
      @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
      @StringJson() String status,
      @IntJson() @JsonKey(name: 'sold_count') int soldCount,
      @IntJson() @JsonKey(name: 'view_count') int viewCount,
      @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
      @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @IntOrNullJson() int? stock,
      @JsonKey(name: 'flash_sale') FlashSaleModel? flashSale,
      @StringOrNullJson() @JsonKey(name: 'image_url') String? listingImageUrl,
      List<String> badges,
      @StringJson() @JsonKey(name: 'fulfillment_mode') String fulfillmentMode,
      @IntOrNullJson()
      @JsonKey(name: 'fulfillment_lead_time_days')
      int? fulfillmentLeadTimeDays,
      @StringOrNullJson() String? availability,
      List<ProductVariantModel> variants,
      List<ProductImageModel> images,
      List<CourierModel> couriers});

  $FlashSaleModelCopyWith<$Res>? get flashSale;
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res> implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? productType = null,
    Object? basePrice = null,
    Object? compareAtPrice = freezed,
    Object? weightGrams = freezed,
    Object? status = null,
    Object? soldCount = null,
    Object? viewCount = null,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? createdAt = freezed,
    Object? stock = freezed,
    Object? flashSale = freezed,
    Object? listingImageUrl = freezed,
    Object? badges = null,
    Object? fulfillmentMode = null,
    Object? fulfillmentLeadTimeDays = freezed,
    Object? availability = freezed,
    Object? variants = null,
    Object? images = null,
    Object? couriers = null,
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
      productType: null == productType
          ? _self.productType
          : productType // ignore: cast_nullable_to_non_nullable
              as String,
      basePrice: null == basePrice
          ? _self.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _self.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      weightGrams: freezed == weightGrams
          ? _self.weightGrams
          : weightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      soldCount: null == soldCount
          ? _self.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _self.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      ratingAvg: null == ratingAvg
          ? _self.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stock: freezed == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      flashSale: freezed == flashSale
          ? _self.flashSale
          : flashSale // ignore: cast_nullable_to_non_nullable
              as FlashSaleModel?,
      listingImageUrl: freezed == listingImageUrl
          ? _self.listingImageUrl
          : listingImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      badges: null == badges
          ? _self.badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fulfillmentMode: null == fulfillmentMode
          ? _self.fulfillmentMode
          : fulfillmentMode // ignore: cast_nullable_to_non_nullable
              as String,
      fulfillmentLeadTimeDays: freezed == fulfillmentLeadTimeDays
          ? _self.fulfillmentLeadTimeDays
          : fulfillmentLeadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      availability: freezed == availability
          ? _self.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as String?,
      variants: null == variants
          ? _self.variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      images: null == images
          ? _self.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImageModel>,
      couriers: null == couriers
          ? _self.couriers
          : couriers // ignore: cast_nullable_to_non_nullable
              as List<CourierModel>,
    ));
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlashSaleModelCopyWith<$Res>? get flashSale {
    if (_self.flashSale == null) {
      return null;
    }

    return $FlashSaleModelCopyWith<$Res>(_self.flashSale!, (value) {
      return _then(_self.copyWith(flashSale: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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
    TResult Function(_ProductModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
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
    TResult Function(_ProductModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel():
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
    TResult? Function(_ProductModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
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
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() String? description,
            @StringJson() @JsonKey(name: 'product_type') String productType,
            @DoubleJson() @JsonKey(name: 'base_price') double basePrice,
            @DoubleOrNullJson()
            @JsonKey(name: 'compare_at_price')
            double? compareAtPrice,
            @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
            @StringJson() String status,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount,
            @IntJson() @JsonKey(name: 'view_count') int viewCount,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @IntOrNullJson() int? stock,
            @JsonKey(name: 'flash_sale') FlashSaleModel? flashSale,
            @StringOrNullJson()
            @JsonKey(name: 'image_url')
            String? listingImageUrl,
            List<String> badges,
            @StringJson()
            @JsonKey(name: 'fulfillment_mode')
            String fulfillmentMode,
            @IntOrNullJson()
            @JsonKey(name: 'fulfillment_lead_time_days')
            int? fulfillmentLeadTimeDays,
            @StringOrNullJson() String? availability,
            List<ProductVariantModel> variants,
            List<ProductImageModel> images,
            List<CourierModel> couriers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.name,
            _that.slug,
            _that.description,
            _that.productType,
            _that.basePrice,
            _that.compareAtPrice,
            _that.weightGrams,
            _that.status,
            _that.soldCount,
            _that.viewCount,
            _that.ratingAvg,
            _that.ratingCount,
            _that.createdAt,
            _that.stock,
            _that.flashSale,
            _that.listingImageUrl,
            _that.badges,
            _that.fulfillmentMode,
            _that.fulfillmentLeadTimeDays,
            _that.availability,
            _that.variants,
            _that.images,
            _that.couriers);
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
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() String? description,
            @StringJson() @JsonKey(name: 'product_type') String productType,
            @DoubleJson() @JsonKey(name: 'base_price') double basePrice,
            @DoubleOrNullJson()
            @JsonKey(name: 'compare_at_price')
            double? compareAtPrice,
            @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
            @StringJson() String status,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount,
            @IntJson() @JsonKey(name: 'view_count') int viewCount,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @IntOrNullJson() int? stock,
            @JsonKey(name: 'flash_sale') FlashSaleModel? flashSale,
            @StringOrNullJson()
            @JsonKey(name: 'image_url')
            String? listingImageUrl,
            List<String> badges,
            @StringJson()
            @JsonKey(name: 'fulfillment_mode')
            String fulfillmentMode,
            @IntOrNullJson()
            @JsonKey(name: 'fulfillment_lead_time_days')
            int? fulfillmentLeadTimeDays,
            @StringOrNullJson() String? availability,
            List<ProductVariantModel> variants,
            List<ProductImageModel> images,
            List<CourierModel> couriers)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel():
        return $default(
            _that.id,
            _that.storeId,
            _that.name,
            _that.slug,
            _that.description,
            _that.productType,
            _that.basePrice,
            _that.compareAtPrice,
            _that.weightGrams,
            _that.status,
            _that.soldCount,
            _that.viewCount,
            _that.ratingAvg,
            _that.ratingCount,
            _that.createdAt,
            _that.stock,
            _that.flashSale,
            _that.listingImageUrl,
            _that.badges,
            _that.fulfillmentMode,
            _that.fulfillmentLeadTimeDays,
            _that.availability,
            _that.variants,
            _that.images,
            _that.couriers);
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
            @StringJson() String name,
            @StringJson() String slug,
            @StringOrNullJson() String? description,
            @StringJson() @JsonKey(name: 'product_type') String productType,
            @DoubleJson() @JsonKey(name: 'base_price') double basePrice,
            @DoubleOrNullJson()
            @JsonKey(name: 'compare_at_price')
            double? compareAtPrice,
            @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
            @StringJson() String status,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount,
            @IntJson() @JsonKey(name: 'view_count') int viewCount,
            @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
            @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @IntOrNullJson() int? stock,
            @JsonKey(name: 'flash_sale') FlashSaleModel? flashSale,
            @StringOrNullJson()
            @JsonKey(name: 'image_url')
            String? listingImageUrl,
            List<String> badges,
            @StringJson()
            @JsonKey(name: 'fulfillment_mode')
            String fulfillmentMode,
            @IntOrNullJson()
            @JsonKey(name: 'fulfillment_lead_time_days')
            int? fulfillmentLeadTimeDays,
            @StringOrNullJson() String? availability,
            List<ProductVariantModel> variants,
            List<ProductImageModel> images,
            List<CourierModel> couriers)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.name,
            _that.slug,
            _that.description,
            _that.productType,
            _that.basePrice,
            _that.compareAtPrice,
            _that.weightGrams,
            _that.status,
            _that.soldCount,
            _that.viewCount,
            _that.ratingAvg,
            _that.ratingCount,
            _that.createdAt,
            _that.stock,
            _that.flashSale,
            _that.listingImageUrl,
            _that.badges,
            _that.fulfillmentMode,
            _that.fulfillmentLeadTimeDays,
            _that.availability,
            _that.variants,
            _that.images,
            _that.couriers);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductModel extends ProductModel {
  const _ProductModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'store_id') this.storeId = 0,
      @StringJson() this.name = '',
      @StringJson() this.slug = '',
      @StringOrNullJson() this.description,
      @StringJson()
      @JsonKey(name: 'product_type')
      this.productType = 'physical',
      @DoubleJson() @JsonKey(name: 'base_price') this.basePrice = 0,
      @DoubleOrNullJson()
      @JsonKey(name: 'compare_at_price')
      this.compareAtPrice,
      @IntOrNullJson() @JsonKey(name: 'weight_grams') this.weightGrams,
      @StringJson() this.status = 'active',
      @IntJson() @JsonKey(name: 'sold_count') this.soldCount = 0,
      @IntJson() @JsonKey(name: 'view_count') this.viewCount = 0,
      @DoubleJson() @JsonKey(name: 'rating_avg') this.ratingAvg = 0,
      @IntJson() @JsonKey(name: 'rating_count') this.ratingCount = 0,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      @IntOrNullJson() this.stock,
      @JsonKey(name: 'flash_sale') this.flashSale,
      @StringOrNullJson() @JsonKey(name: 'image_url') this.listingImageUrl,
      final List<String> badges = const <String>[],
      @StringJson()
      @JsonKey(name: 'fulfillment_mode')
      this.fulfillmentMode = 'ready_stock',
      @IntOrNullJson()
      @JsonKey(name: 'fulfillment_lead_time_days')
      this.fulfillmentLeadTimeDays,
      @StringOrNullJson() this.availability,
      final List<ProductVariantModel> variants = const <ProductVariantModel>[],
      final List<ProductImageModel> images = const <ProductImageModel>[],
      final List<CourierModel> couriers = const <CourierModel>[]})
      : _badges = badges,
        _variants = variants,
        _images = images,
        _couriers = couriers,
        super._();
  factory _ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'store_id')
  final int storeId;
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

  /// `physical` / `digital` / `service`.
  @override
  @StringJson()
  @JsonKey(name: 'product_type')
  final String productType;
  @override
  @DoubleJson()
  @JsonKey(name: 'base_price')
  final double basePrice;

  /// Harga coret, **independen dari flash sale**. `null` = tidak ada diskon.
  @override
  @DoubleOrNullJson()
  @JsonKey(name: 'compare_at_price')
  final double? compareAtPrice;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'weight_grams')
  final int? weightGrams;
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @IntJson()
  @JsonKey(name: 'sold_count')
  final int soldCount;
  @override
  @IntJson()
  @JsonKey(name: 'view_count')
  final int viewCount;
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
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Total `quantity_available` (on_hand − reserved) lintas gudang.
  ///
  /// Datang sebagai **integer asli**, bukan string — berbeda dari mayoritas
  /// field lain. Hanya ada di detail; `null` di listing.
  @override
  @IntOrNullJson()
  final int? stock;

  /// Hanya ada kalau produk sedang ikut flash sale aktif.
  ///
  /// Di JSON key-nya **absen sama sekali**, bukan `null`. Untuk Dart keduanya
  /// sama-sama jadi `null`, jadi cukup periksa null — tapi jangan menulis
  /// kode yang mengandalkan key-nya selalu ada.
  @override
  @JsonKey(name: 'flash_sale')
  final FlashSaleModel? flashSale;

  /// Gambar utama **versi listing**, satu URL datar.
  ///
  /// Ditambahkan backend pada commit `db8a626` ("Add image_url to GET
  /// /products listing (was always missing)"). Sebelumnya `GET /products`
  /// tidak membawa gambar sama sekali, sehingga setiap kartu produk terpaksa
  /// memakai placeholder — satu-satunya alternatifnya menembak detail per
  /// kartu (N+1).
  ///
  /// ⚠️ Hanya ada di **listing**; `GET /products/{id}` tidak mengirimkannya
  /// dan memakai [images] sebagai gantinya. Pakai [primaryImageUrl] yang
  /// menyerap keduanya, jangan field ini langsung.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'image_url')
  final String? listingImageUrl;

  /// Label kartu produk, dihitung **server** (commit `7328161`).
  ///
  /// Subset dari `["new", "best_seller", "hot", "sale"]`, dan ada di
  /// **listing maupun detail**. Nilainya diturunkan dari field yang sudah
  /// ada di baris yang sama (`created_at`, `sold_count`, `view_count`,
  /// `compare_at_price`, `flash_sale`) tanpa query tambahan.
  ///
  /// Sengaja dihitung server supaya web dan mobile tidak menurunkan ambang
  /// yang sama sendiri-sendiri lalu menampilkan label yang berbeda untuk
  /// produk yang sama. **Jangan menghitung ulang di sini** — pakai
  /// [badgeLabels] apa adanya.
  ///
  /// ⚠️ Tetap `List<String>` mentah, bukan enum: kolomnya bebas di server
  /// dan ambangnya akan pindah ke `admin_settings`, jadi nilai baru bisa
  /// muncul kapan saja. [badgeLabels] membuang yang tidak dikenal.
  final List<String> _badges;

  /// Label kartu produk, dihitung **server** (commit `7328161`).
  ///
  /// Subset dari `["new", "best_seller", "hot", "sale"]`, dan ada di
  /// **listing maupun detail**. Nilainya diturunkan dari field yang sudah
  /// ada di baris yang sama (`created_at`, `sold_count`, `view_count`,
  /// `compare_at_price`, `flash_sale`) tanpa query tambahan.
  ///
  /// Sengaja dihitung server supaya web dan mobile tidak menurunkan ambang
  /// yang sama sendiri-sendiri lalu menampilkan label yang berbeda untuk
  /// produk yang sama. **Jangan menghitung ulang di sini** — pakai
  /// [badgeLabels] apa adanya.
  ///
  /// ⚠️ Tetap `List<String>` mentah, bukan enum: kolomnya bebas di server
  /// dan ambangnya akan pindah ke `admin_settings`, jadi nilai baru bisa
  /// muncul kapan saja. [badgeLabels] membuang yang tidak dikenal.
  @override
  @JsonKey()
  List<String> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  /// Mode pemenuhan yang dipilih penjual (backend v1.6+, blueprint Seller
  /// Ch.1): `ready_stock`, `infinite`, `pre_order`, `custom_order`,
  /// `discontinued`. Ada di **listing maupun detail**. Pakai [stockMode],
  /// jangan string ini langsung.
  @override
  @StringJson()
  @JsonKey(name: 'fulfillment_mode')
  final String fulfillmentMode;

  /// Lama pengerjaan dalam hari — wajib untuk `pre_order`/`custom_order`,
  /// `null` untuk mode lain.
  @override
  @IntOrNullJson()
  @JsonKey(name: 'fulfillment_lead_time_days')
  final int? fulfillmentLeadTimeDays;

  /// Ketersediaan hasil hitungan server, **hanya di detail**:
  /// [fulfillmentMode] ditambah `low_stock`/`out_of_stock` yang diturunkan
  /// dari stok live (`<= 10` dianggap menipis). `null` di listing.
  @override
  @StringOrNullJson()
  final String? availability;
  final List<ProductVariantModel> _variants;
  @override
  @JsonKey()
  List<ProductVariantModel> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

  final List<ProductImageModel> _images;
  @override
  @JsonKey()
  List<ProductImageModel> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<CourierModel> _couriers;
  @override
  @JsonKey()
  List<CourierModel> get couriers {
    if (_couriers is EqualUnmodifiableListView) return _couriers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_couriers);
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductModelCopyWith<_ProductModel> get copyWith =>
      __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.compareAtPrice, compareAtPrice) ||
                other.compareAtPrice == compareAtPrice) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.flashSale, flashSale) ||
                other.flashSale == flashSale) &&
            (identical(other.listingImageUrl, listingImageUrl) ||
                other.listingImageUrl == listingImageUrl) &&
            const DeepCollectionEquality().equals(other._badges, _badges) &&
            (identical(other.fulfillmentMode, fulfillmentMode) ||
                other.fulfillmentMode == fulfillmentMode) &&
            (identical(
                    other.fulfillmentLeadTimeDays, fulfillmentLeadTimeDays) ||
                other.fulfillmentLeadTimeDays == fulfillmentLeadTimeDays) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._couriers, _couriers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        storeId,
        name,
        slug,
        description,
        productType,
        basePrice,
        compareAtPrice,
        weightGrams,
        status,
        soldCount,
        viewCount,
        ratingAvg,
        ratingCount,
        createdAt,
        stock,
        flashSale,
        listingImageUrl,
        const DeepCollectionEquality().hash(_badges),
        fulfillmentMode,
        fulfillmentLeadTimeDays,
        availability,
        const DeepCollectionEquality().hash(_variants),
        const DeepCollectionEquality().hash(_images),
        const DeepCollectionEquality().hash(_couriers)
      ]);

  @override
  String toString() {
    return 'ProductModel(id: $id, storeId: $storeId, name: $name, slug: $slug, description: $description, productType: $productType, basePrice: $basePrice, compareAtPrice: $compareAtPrice, weightGrams: $weightGrams, status: $status, soldCount: $soldCount, viewCount: $viewCount, ratingAvg: $ratingAvg, ratingCount: $ratingCount, createdAt: $createdAt, stock: $stock, flashSale: $flashSale, listingImageUrl: $listingImageUrl, badges: $badges, fulfillmentMode: $fulfillmentMode, fulfillmentLeadTimeDays: $fulfillmentLeadTimeDays, availability: $availability, variants: $variants, images: $images, couriers: $couriers)';
  }
}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(
          _ProductModel value, $Res Function(_ProductModel) _then) =
      __$ProductModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() String name,
      @StringJson() String slug,
      @StringOrNullJson() String? description,
      @StringJson() @JsonKey(name: 'product_type') String productType,
      @DoubleJson() @JsonKey(name: 'base_price') double basePrice,
      @DoubleOrNullJson()
      @JsonKey(name: 'compare_at_price')
      double? compareAtPrice,
      @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
      @StringJson() String status,
      @IntJson() @JsonKey(name: 'sold_count') int soldCount,
      @IntJson() @JsonKey(name: 'view_count') int viewCount,
      @DoubleJson() @JsonKey(name: 'rating_avg') double ratingAvg,
      @IntJson() @JsonKey(name: 'rating_count') int ratingCount,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @IntOrNullJson() int? stock,
      @JsonKey(name: 'flash_sale') FlashSaleModel? flashSale,
      @StringOrNullJson() @JsonKey(name: 'image_url') String? listingImageUrl,
      List<String> badges,
      @StringJson() @JsonKey(name: 'fulfillment_mode') String fulfillmentMode,
      @IntOrNullJson()
      @JsonKey(name: 'fulfillment_lead_time_days')
      int? fulfillmentLeadTimeDays,
      @StringOrNullJson() String? availability,
      List<ProductVariantModel> variants,
      List<ProductImageModel> images,
      List<CourierModel> couriers});

  @override
  $FlashSaleModelCopyWith<$Res>? get flashSale;
}

/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? productType = null,
    Object? basePrice = null,
    Object? compareAtPrice = freezed,
    Object? weightGrams = freezed,
    Object? status = null,
    Object? soldCount = null,
    Object? viewCount = null,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? createdAt = freezed,
    Object? stock = freezed,
    Object? flashSale = freezed,
    Object? listingImageUrl = freezed,
    Object? badges = null,
    Object? fulfillmentMode = null,
    Object? fulfillmentLeadTimeDays = freezed,
    Object? availability = freezed,
    Object? variants = null,
    Object? images = null,
    Object? couriers = null,
  }) {
    return _then(_ProductModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
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
      productType: null == productType
          ? _self.productType
          : productType // ignore: cast_nullable_to_non_nullable
              as String,
      basePrice: null == basePrice
          ? _self.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      compareAtPrice: freezed == compareAtPrice
          ? _self.compareAtPrice
          : compareAtPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      weightGrams: freezed == weightGrams
          ? _self.weightGrams
          : weightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      soldCount: null == soldCount
          ? _self.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _self.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      ratingAvg: null == ratingAvg
          ? _self.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stock: freezed == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      flashSale: freezed == flashSale
          ? _self.flashSale
          : flashSale // ignore: cast_nullable_to_non_nullable
              as FlashSaleModel?,
      listingImageUrl: freezed == listingImageUrl
          ? _self.listingImageUrl
          : listingImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      badges: null == badges
          ? _self._badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fulfillmentMode: null == fulfillmentMode
          ? _self.fulfillmentMode
          : fulfillmentMode // ignore: cast_nullable_to_non_nullable
              as String,
      fulfillmentLeadTimeDays: freezed == fulfillmentLeadTimeDays
          ? _self.fulfillmentLeadTimeDays
          : fulfillmentLeadTimeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      availability: freezed == availability
          ? _self.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as String?,
      variants: null == variants
          ? _self._variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImageModel>,
      couriers: null == couriers
          ? _self._couriers
          : couriers // ignore: cast_nullable_to_non_nullable
              as List<CourierModel>,
    ));
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlashSaleModelCopyWith<$Res>? get flashSale {
    if (_self.flashSale == null) {
      return null;
    }

    return $FlashSaleModelCopyWith<$Res>(_self.flashSale!, (value) {
      return _then(_self.copyWith(flashSale: value));
    });
  }
}

/// @nodoc
mixin _$ProductVariantModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'product_id')
  int get productId;
  @StringOrNullJson()
  String? get sku;

  /// Opsi varian, mis. `{"warna": "Hitam"}`.
  ///
  /// Server mengirimnya sebagai **string berisi JSON** (`'{"warna":"Hitam"}'`),
  /// bukan objek — karena itu [JsonMapJson], bukan Map biasa.
  @JsonMapJson()
  @JsonKey(name: 'variant_options')
  Map<String, dynamic>? get variantOptions;
  @DoubleJson()
  double get price;
  @IntOrNullJson()
  @JsonKey(name: 'weight_grams')
  int? get weightGrams;
  @StringOrNullJson()
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @BoolJson()
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Stok varian ini lintas gudang — **integer asli**, seperti
  /// `ProductModel.stock`.
  @IntOrNullJson()
  int? get stock;

  /// Lokasi gudang yang akan mengirim varian ini — ditambahkan backend pada
  /// 15 September 2026 bersama endpoint `shipping-estimate`.
  ///
  /// Dipakai menampilkan "Dikirim dari …" di halaman detail tanpa memanggil
  /// endpoint apa pun. `null` untuk varian yang tidak punya stok di gudang
  /// mana pun.
  ///
  /// ⚠️ Belum terdokumentasi di `docs/18-frontend-integration-guide.md` §8
  /// walau servernya sudah mengirimkannya.
  @StringOrNullJson()
  @JsonKey(name: 'warehouse_city')
  String? get warehouseCity;
  @StringOrNullJson()
  @JsonKey(name: 'warehouse_province')
  String? get warehouseProvince;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductVariantModelCopyWith<ProductVariantModel> get copyWith =>
      _$ProductVariantModelCopyWithImpl<ProductVariantModel>(
          this as ProductVariantModel, _$identity);

  /// Serializes this ProductVariantModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductVariantModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            const DeepCollectionEquality()
                .equals(other.variantOptions, variantOptions) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.warehouseCity, warehouseCity) ||
                other.warehouseCity == warehouseCity) &&
            (identical(other.warehouseProvince, warehouseProvince) ||
                other.warehouseProvince == warehouseProvince));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      sku,
      const DeepCollectionEquality().hash(variantOptions),
      price,
      weightGrams,
      imageUrl,
      isActive,
      stock,
      warehouseCity,
      warehouseProvince);

  @override
  String toString() {
    return 'ProductVariantModel(id: $id, productId: $productId, sku: $sku, variantOptions: $variantOptions, price: $price, weightGrams: $weightGrams, imageUrl: $imageUrl, isActive: $isActive, stock: $stock, warehouseCity: $warehouseCity, warehouseProvince: $warehouseProvince)';
  }
}

/// @nodoc
abstract mixin class $ProductVariantModelCopyWith<$Res> {
  factory $ProductVariantModelCopyWith(
          ProductVariantModel value, $Res Function(ProductVariantModel) _then) =
      _$ProductVariantModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @StringOrNullJson() String? sku,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      Map<String, dynamic>? variantOptions,
      @DoubleJson() double price,
      @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
      @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
      @BoolJson() @JsonKey(name: 'is_active') bool isActive,
      @IntOrNullJson() int? stock,
      @StringOrNullJson()
      @JsonKey(name: 'warehouse_city')
      String? warehouseCity,
      @StringOrNullJson()
      @JsonKey(name: 'warehouse_province')
      String? warehouseProvince});
}

/// @nodoc
class _$ProductVariantModelCopyWithImpl<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  _$ProductVariantModelCopyWithImpl(this._self, this._then);

  final ProductVariantModel _self;
  final $Res Function(ProductVariantModel) _then;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? sku = freezed,
    Object? variantOptions = freezed,
    Object? price = null,
    Object? weightGrams = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? stock = freezed,
    Object? warehouseCity = freezed,
    Object? warehouseProvince = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      sku: freezed == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantOptions: freezed == variantOptions
          ? _self.variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      weightGrams: freezed == weightGrams
          ? _self.weightGrams
          : weightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      stock: freezed == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      warehouseCity: freezed == warehouseCity
          ? _self.warehouseCity
          : warehouseCity // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseProvince: freezed == warehouseProvince
          ? _self.warehouseProvince
          : warehouseProvince // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductVariantModel].
extension ProductVariantModelPatterns on ProductVariantModel {
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
    TResult Function(_ProductVariantModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
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
    TResult Function(_ProductVariantModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel():
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
    TResult? Function(_ProductVariantModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @StringOrNullJson() String? sku,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @DoubleJson() double price,
            @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
            @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive,
            @IntOrNullJson() int? stock,
            @StringOrNullJson()
            @JsonKey(name: 'warehouse_city')
            String? warehouseCity,
            @StringOrNullJson()
            @JsonKey(name: 'warehouse_province')
            String? warehouseProvince)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
        return $default(
            _that.id,
            _that.productId,
            _that.sku,
            _that.variantOptions,
            _that.price,
            _that.weightGrams,
            _that.imageUrl,
            _that.isActive,
            _that.stock,
            _that.warehouseCity,
            _that.warehouseProvince);
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
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @StringOrNullJson() String? sku,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @DoubleJson() double price,
            @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
            @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive,
            @IntOrNullJson() int? stock,
            @StringOrNullJson()
            @JsonKey(name: 'warehouse_city')
            String? warehouseCity,
            @StringOrNullJson()
            @JsonKey(name: 'warehouse_province')
            String? warehouseProvince)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel():
        return $default(
            _that.id,
            _that.productId,
            _that.sku,
            _that.variantOptions,
            _that.price,
            _that.weightGrams,
            _that.imageUrl,
            _that.isActive,
            _that.stock,
            _that.warehouseCity,
            _that.warehouseProvince);
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
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @StringOrNullJson() String? sku,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @DoubleJson() double price,
            @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
            @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive,
            @IntOrNullJson() int? stock,
            @StringOrNullJson()
            @JsonKey(name: 'warehouse_city')
            String? warehouseCity,
            @StringOrNullJson()
            @JsonKey(name: 'warehouse_province')
            String? warehouseProvince)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
        return $default(
            _that.id,
            _that.productId,
            _that.sku,
            _that.variantOptions,
            _that.price,
            _that.weightGrams,
            _that.imageUrl,
            _that.isActive,
            _that.stock,
            _that.warehouseCity,
            _that.warehouseProvince);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductVariantModel extends ProductVariantModel {
  const _ProductVariantModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'product_id') this.productId = 0,
      @StringOrNullJson() this.sku,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      final Map<String, dynamic>? variantOptions,
      @DoubleJson() this.price = 0,
      @IntOrNullJson() @JsonKey(name: 'weight_grams') this.weightGrams,
      @StringOrNullJson() @JsonKey(name: 'image_url') this.imageUrl,
      @BoolJson() @JsonKey(name: 'is_active') this.isActive = true,
      @IntOrNullJson() this.stock,
      @StringOrNullJson() @JsonKey(name: 'warehouse_city') this.warehouseCity,
      @StringOrNullJson()
      @JsonKey(name: 'warehouse_province')
      this.warehouseProvince})
      : _variantOptions = variantOptions,
        super._();
  factory _ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  @StringOrNullJson()
  final String? sku;

  /// Opsi varian, mis. `{"warna": "Hitam"}`.
  ///
  /// Server mengirimnya sebagai **string berisi JSON** (`'{"warna":"Hitam"}'`),
  /// bukan objek — karena itu [JsonMapJson], bukan Map biasa.
  final Map<String, dynamic>? _variantOptions;

  /// Opsi varian, mis. `{"warna": "Hitam"}`.
  ///
  /// Server mengirimnya sebagai **string berisi JSON** (`'{"warna":"Hitam"}'`),
  /// bukan objek — karena itu [JsonMapJson], bukan Map biasa.
  @override
  @JsonMapJson()
  @JsonKey(name: 'variant_options')
  Map<String, dynamic>? get variantOptions {
    final value = _variantOptions;
    if (value == null) return null;
    if (_variantOptions is EqualUnmodifiableMapView) return _variantOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  @DoubleJson()
  final double price;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'weight_grams')
  final int? weightGrams;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @BoolJson()
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Stok varian ini lintas gudang — **integer asli**, seperti
  /// `ProductModel.stock`.
  @override
  @IntOrNullJson()
  final int? stock;

  /// Lokasi gudang yang akan mengirim varian ini — ditambahkan backend pada
  /// 15 September 2026 bersama endpoint `shipping-estimate`.
  ///
  /// Dipakai menampilkan "Dikirim dari …" di halaman detail tanpa memanggil
  /// endpoint apa pun. `null` untuk varian yang tidak punya stok di gudang
  /// mana pun.
  ///
  /// ⚠️ Belum terdokumentasi di `docs/18-frontend-integration-guide.md` §8
  /// walau servernya sudah mengirimkannya.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'warehouse_city')
  final String? warehouseCity;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'warehouse_province')
  final String? warehouseProvince;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductVariantModelCopyWith<_ProductVariantModel> get copyWith =>
      __$ProductVariantModelCopyWithImpl<_ProductVariantModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductVariantModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductVariantModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            const DeepCollectionEquality()
                .equals(other._variantOptions, _variantOptions) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.warehouseCity, warehouseCity) ||
                other.warehouseCity == warehouseCity) &&
            (identical(other.warehouseProvince, warehouseProvince) ||
                other.warehouseProvince == warehouseProvince));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      sku,
      const DeepCollectionEquality().hash(_variantOptions),
      price,
      weightGrams,
      imageUrl,
      isActive,
      stock,
      warehouseCity,
      warehouseProvince);

  @override
  String toString() {
    return 'ProductVariantModel(id: $id, productId: $productId, sku: $sku, variantOptions: $variantOptions, price: $price, weightGrams: $weightGrams, imageUrl: $imageUrl, isActive: $isActive, stock: $stock, warehouseCity: $warehouseCity, warehouseProvince: $warehouseProvince)';
  }
}

/// @nodoc
abstract mixin class _$ProductVariantModelCopyWith<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  factory _$ProductVariantModelCopyWith(_ProductVariantModel value,
          $Res Function(_ProductVariantModel) _then) =
      __$ProductVariantModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @StringOrNullJson() String? sku,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      Map<String, dynamic>? variantOptions,
      @DoubleJson() double price,
      @IntOrNullJson() @JsonKey(name: 'weight_grams') int? weightGrams,
      @StringOrNullJson() @JsonKey(name: 'image_url') String? imageUrl,
      @BoolJson() @JsonKey(name: 'is_active') bool isActive,
      @IntOrNullJson() int? stock,
      @StringOrNullJson()
      @JsonKey(name: 'warehouse_city')
      String? warehouseCity,
      @StringOrNullJson()
      @JsonKey(name: 'warehouse_province')
      String? warehouseProvince});
}

/// @nodoc
class __$ProductVariantModelCopyWithImpl<$Res>
    implements _$ProductVariantModelCopyWith<$Res> {
  __$ProductVariantModelCopyWithImpl(this._self, this._then);

  final _ProductVariantModel _self;
  final $Res Function(_ProductVariantModel) _then;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? sku = freezed,
    Object? variantOptions = freezed,
    Object? price = null,
    Object? weightGrams = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? stock = freezed,
    Object? warehouseCity = freezed,
    Object? warehouseProvince = freezed,
  }) {
    return _then(_ProductVariantModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      sku: freezed == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      variantOptions: freezed == variantOptions
          ? _self._variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      weightGrams: freezed == weightGrams
          ? _self.weightGrams
          : weightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      stock: freezed == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      warehouseCity: freezed == warehouseCity
          ? _self.warehouseCity
          : warehouseCity // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseProvince: freezed == warehouseProvince
          ? _self.warehouseProvince
          : warehouseProvince // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$ProductImageModel {
  @IntJson()
  int get id;
  @StringJson()
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @IntJson()
  @JsonKey(name: 'sort_order')
  int get sortOrder;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductImageModelCopyWith<ProductImageModel> get copyWith =>
      _$ProductImageModelCopyWithImpl<ProductImageModel>(
          this as ProductImageModel, _$identity);

  /// Serializes this ProductImageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductImageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageUrl, sortOrder);

  @override
  String toString() {
    return 'ProductImageModel(id: $id, imageUrl: $imageUrl, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $ProductImageModelCopyWith<$Res> {
  factory $ProductImageModelCopyWith(
          ProductImageModel value, $Res Function(ProductImageModel) _then) =
      _$ProductImageModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'image_url') String imageUrl,
      @IntJson() @JsonKey(name: 'sort_order') int sortOrder});
}

/// @nodoc
class _$ProductImageModelCopyWithImpl<$Res>
    implements $ProductImageModelCopyWith<$Res> {
  _$ProductImageModelCopyWithImpl(this._self, this._then);

  final ProductImageModel _self;
  final $Res Function(ProductImageModel) _then;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductImageModel].
extension ProductImageModelPatterns on ProductImageModel {
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
    TResult Function(_ProductImageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
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
    TResult Function(_ProductImageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel():
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
    TResult? Function(_ProductImageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'image_url') String imageUrl,
            @IntJson() @JsonKey(name: 'sort_order') int sortOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
        return $default(_that.id, _that.imageUrl, _that.sortOrder);
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
            @StringJson() @JsonKey(name: 'image_url') String imageUrl,
            @IntJson() @JsonKey(name: 'sort_order') int sortOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel():
        return $default(_that.id, _that.imageUrl, _that.sortOrder);
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
            @StringJson() @JsonKey(name: 'image_url') String imageUrl,
            @IntJson() @JsonKey(name: 'sort_order') int sortOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
        return $default(_that.id, _that.imageUrl, _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductImageModel implements ProductImageModel {
  const _ProductImageModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'image_url') this.imageUrl = '',
      @IntJson() @JsonKey(name: 'sort_order') this.sortOrder = 0});
  factory _ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringJson()
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @IntJson()
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductImageModelCopyWith<_ProductImageModel> get copyWith =>
      __$ProductImageModelCopyWithImpl<_ProductImageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductImageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductImageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageUrl, sortOrder);

  @override
  String toString() {
    return 'ProductImageModel(id: $id, imageUrl: $imageUrl, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$ProductImageModelCopyWith<$Res>
    implements $ProductImageModelCopyWith<$Res> {
  factory _$ProductImageModelCopyWith(
          _ProductImageModel value, $Res Function(_ProductImageModel) _then) =
      __$ProductImageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'image_url') String imageUrl,
      @IntJson() @JsonKey(name: 'sort_order') int sortOrder});
}

/// @nodoc
class __$ProductImageModelCopyWithImpl<$Res>
    implements _$ProductImageModelCopyWith<$Res> {
  __$ProductImageModelCopyWithImpl(this._self, this._then);

  final _ProductImageModel _self;
  final $Res Function(_ProductImageModel) _then;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
  }) {
    return _then(_ProductImageModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$CourierModel {
  @StringJson()
  String get code;
  @StringJson()
  String get name;
  @BoolJson()
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of CourierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourierModelCopyWith<CourierModel> get copyWith =>
      _$CourierModelCopyWithImpl<CourierModel>(
          this as CourierModel, _$identity);

  /// Serializes this CourierModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourierModel &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, name, isActive);

  @override
  String toString() {
    return 'CourierModel(code: $code, name: $name, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $CourierModelCopyWith<$Res> {
  factory $CourierModelCopyWith(
          CourierModel value, $Res Function(CourierModel) _then) =
      _$CourierModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() String code,
      @StringJson() String name,
      @BoolJson() @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$CourierModelCopyWithImpl<$Res> implements $CourierModelCopyWith<$Res> {
  _$CourierModelCopyWithImpl(this._self, this._then);

  final CourierModel _self;
  final $Res Function(CourierModel) _then;

  /// Create a copy of CourierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? isActive = null,
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
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CourierModel].
extension CourierModelPatterns on CourierModel {
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
    TResult Function(_CourierModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourierModel() when $default != null:
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
    TResult Function(_CourierModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourierModel():
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
    TResult? Function(_CourierModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourierModel() when $default != null:
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
    TResult Function(@StringJson() String code, @StringJson() String name,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CourierModel() when $default != null:
        return $default(_that.code, _that.name, _that.isActive);
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
    TResult Function(@StringJson() String code, @StringJson() String name,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourierModel():
        return $default(_that.code, _that.name, _that.isActive);
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
    TResult? Function(@StringJson() String code, @StringJson() String name,
            @BoolJson() @JsonKey(name: 'is_active') bool isActive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CourierModel() when $default != null:
        return $default(_that.code, _that.name, _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CourierModel implements CourierModel {
  const _CourierModel(
      {@StringJson() this.code = '',
      @StringJson() this.name = '',
      @BoolJson() @JsonKey(name: 'is_active') this.isActive = true});
  factory _CourierModel.fromJson(Map<String, dynamic> json) =>
      _$CourierModelFromJson(json);

  @override
  @JsonKey()
  @StringJson()
  final String code;
  @override
  @JsonKey()
  @StringJson()
  final String name;
  @override
  @BoolJson()
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Create a copy of CourierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourierModelCopyWith<_CourierModel> get copyWith =>
      __$CourierModelCopyWithImpl<_CourierModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourierModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourierModel &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, name, isActive);

  @override
  String toString() {
    return 'CourierModel(code: $code, name: $name, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$CourierModelCopyWith<$Res>
    implements $CourierModelCopyWith<$Res> {
  factory _$CourierModelCopyWith(
          _CourierModel value, $Res Function(_CourierModel) _then) =
      __$CourierModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() String code,
      @StringJson() String name,
      @BoolJson() @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$CourierModelCopyWithImpl<$Res>
    implements _$CourierModelCopyWith<$Res> {
  __$CourierModelCopyWithImpl(this._self, this._then);

  final _CourierModel _self;
  final $Res Function(_CourierModel) _then;

  /// Create a copy of CourierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? isActive = null,
  }) {
    return _then(_CourierModel(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$FlashSaleModel {
  @DoubleJson()
  @JsonKey(name: 'flash_price')
  double get flashPrice;
  @IntJson()
  @JsonKey(name: 'sold_count')
  int get soldCount;
  @IntJson()
  @JsonKey(name: 'stock_quota')
  int get stockQuota;
  @ServerDateTimeJson()
  @JsonKey(name: 'ends_at')
  DateTime? get endsAt;

  /// Create a copy of FlashSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlashSaleModelCopyWith<FlashSaleModel> get copyWith =>
      _$FlashSaleModelCopyWithImpl<FlashSaleModel>(
          this as FlashSaleModel, _$identity);

  /// Serializes this FlashSaleModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlashSaleModel &&
            (identical(other.flashPrice, flashPrice) ||
                other.flashPrice == flashPrice) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount) &&
            (identical(other.stockQuota, stockQuota) ||
                other.stockQuota == stockQuota) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, flashPrice, soldCount, stockQuota, endsAt);

  @override
  String toString() {
    return 'FlashSaleModel(flashPrice: $flashPrice, soldCount: $soldCount, stockQuota: $stockQuota, endsAt: $endsAt)';
  }
}

/// @nodoc
abstract mixin class $FlashSaleModelCopyWith<$Res> {
  factory $FlashSaleModelCopyWith(
          FlashSaleModel value, $Res Function(FlashSaleModel) _then) =
      _$FlashSaleModelCopyWithImpl;
  @useResult
  $Res call(
      {@DoubleJson() @JsonKey(name: 'flash_price') double flashPrice,
      @IntJson() @JsonKey(name: 'sold_count') int soldCount,
      @IntJson() @JsonKey(name: 'stock_quota') int stockQuota,
      @ServerDateTimeJson() @JsonKey(name: 'ends_at') DateTime? endsAt});
}

/// @nodoc
class _$FlashSaleModelCopyWithImpl<$Res>
    implements $FlashSaleModelCopyWith<$Res> {
  _$FlashSaleModelCopyWithImpl(this._self, this._then);

  final FlashSaleModel _self;
  final $Res Function(FlashSaleModel) _then;

  /// Create a copy of FlashSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flashPrice = null,
    Object? soldCount = null,
    Object? stockQuota = null,
    Object? endsAt = freezed,
  }) {
    return _then(_self.copyWith(
      flashPrice: null == flashPrice
          ? _self.flashPrice
          : flashPrice // ignore: cast_nullable_to_non_nullable
              as double,
      soldCount: null == soldCount
          ? _self.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
      stockQuota: null == stockQuota
          ? _self.stockQuota
          : stockQuota // ignore: cast_nullable_to_non_nullable
              as int,
      endsAt: freezed == endsAt
          ? _self.endsAt
          : endsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FlashSaleModel].
extension FlashSaleModelPatterns on FlashSaleModel {
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
    TResult Function(_FlashSaleModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlashSaleModel() when $default != null:
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
    TResult Function(_FlashSaleModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlashSaleModel():
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
    TResult? Function(_FlashSaleModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlashSaleModel() when $default != null:
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
            @DoubleJson() @JsonKey(name: 'flash_price') double flashPrice,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount,
            @IntJson() @JsonKey(name: 'stock_quota') int stockQuota,
            @ServerDateTimeJson() @JsonKey(name: 'ends_at') DateTime? endsAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FlashSaleModel() when $default != null:
        return $default(
            _that.flashPrice, _that.soldCount, _that.stockQuota, _that.endsAt);
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
            @DoubleJson() @JsonKey(name: 'flash_price') double flashPrice,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount,
            @IntJson() @JsonKey(name: 'stock_quota') int stockQuota,
            @ServerDateTimeJson() @JsonKey(name: 'ends_at') DateTime? endsAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlashSaleModel():
        return $default(
            _that.flashPrice, _that.soldCount, _that.stockQuota, _that.endsAt);
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
            @DoubleJson() @JsonKey(name: 'flash_price') double flashPrice,
            @IntJson() @JsonKey(name: 'sold_count') int soldCount,
            @IntJson() @JsonKey(name: 'stock_quota') int stockQuota,
            @ServerDateTimeJson() @JsonKey(name: 'ends_at') DateTime? endsAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FlashSaleModel() when $default != null:
        return $default(
            _that.flashPrice, _that.soldCount, _that.stockQuota, _that.endsAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FlashSaleModel extends FlashSaleModel {
  const _FlashSaleModel(
      {@DoubleJson() @JsonKey(name: 'flash_price') this.flashPrice = 0,
      @IntJson() @JsonKey(name: 'sold_count') this.soldCount = 0,
      @IntJson() @JsonKey(name: 'stock_quota') this.stockQuota = 0,
      @ServerDateTimeJson() @JsonKey(name: 'ends_at') this.endsAt})
      : super._();
  factory _FlashSaleModel.fromJson(Map<String, dynamic> json) =>
      _$FlashSaleModelFromJson(json);

  @override
  @DoubleJson()
  @JsonKey(name: 'flash_price')
  final double flashPrice;
  @override
  @IntJson()
  @JsonKey(name: 'sold_count')
  final int soldCount;
  @override
  @IntJson()
  @JsonKey(name: 'stock_quota')
  final int stockQuota;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'ends_at')
  final DateTime? endsAt;

  /// Create a copy of FlashSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlashSaleModelCopyWith<_FlashSaleModel> get copyWith =>
      __$FlashSaleModelCopyWithImpl<_FlashSaleModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FlashSaleModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlashSaleModel &&
            (identical(other.flashPrice, flashPrice) ||
                other.flashPrice == flashPrice) &&
            (identical(other.soldCount, soldCount) ||
                other.soldCount == soldCount) &&
            (identical(other.stockQuota, stockQuota) ||
                other.stockQuota == stockQuota) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, flashPrice, soldCount, stockQuota, endsAt);

  @override
  String toString() {
    return 'FlashSaleModel(flashPrice: $flashPrice, soldCount: $soldCount, stockQuota: $stockQuota, endsAt: $endsAt)';
  }
}

/// @nodoc
abstract mixin class _$FlashSaleModelCopyWith<$Res>
    implements $FlashSaleModelCopyWith<$Res> {
  factory _$FlashSaleModelCopyWith(
          _FlashSaleModel value, $Res Function(_FlashSaleModel) _then) =
      __$FlashSaleModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DoubleJson() @JsonKey(name: 'flash_price') double flashPrice,
      @IntJson() @JsonKey(name: 'sold_count') int soldCount,
      @IntJson() @JsonKey(name: 'stock_quota') int stockQuota,
      @ServerDateTimeJson() @JsonKey(name: 'ends_at') DateTime? endsAt});
}

/// @nodoc
class __$FlashSaleModelCopyWithImpl<$Res>
    implements _$FlashSaleModelCopyWith<$Res> {
  __$FlashSaleModelCopyWithImpl(this._self, this._then);

  final _FlashSaleModel _self;
  final $Res Function(_FlashSaleModel) _then;

  /// Create a copy of FlashSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? flashPrice = null,
    Object? soldCount = null,
    Object? stockQuota = null,
    Object? endsAt = freezed,
  }) {
    return _then(_FlashSaleModel(
      flashPrice: null == flashPrice
          ? _self.flashPrice
          : flashPrice // ignore: cast_nullable_to_non_nullable
              as double,
      soldCount: null == soldCount
          ? _self.soldCount
          : soldCount // ignore: cast_nullable_to_non_nullable
              as int,
      stockQuota: null == stockQuota
          ? _self.stockQuota
          : stockQuota // ignore: cast_nullable_to_non_nullable
              as int,
      endsAt: freezed == endsAt
          ? _self.endsAt
          : endsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
