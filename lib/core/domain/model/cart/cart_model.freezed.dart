// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItemModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'cart_id')
  int get cartId;
  @IntJson()
  @JsonKey(name: 'store_id')
  int get storeId;

  /// Baris keranjang selalu merujuk **varian**, bukan produk.
  @IntJson()
  @JsonKey(name: 'product_variant_id')
  int get productVariantId;
  @IntOrNullJson()
  @JsonKey(name: 'warehouse_id')
  int? get warehouseId;

  /// ⚠️ **Server tidak memvalidasi nilai ini sama sekali.** Sudah diuji:
  /// `PATCH` dengan `quantity: 99999` pada varian berstok 150 dibalas `200`
  /// dan benar-benar tersimpan; `0` juga diterima. Pembatasan terhadap stok
  /// **harus dilakukan aplikasi** sebelum mengirim, kalau tidak user baru
  /// tahu keranjangnya mustahil saat checkout gagal.
  @IntJson()
  int get quantity;

  /// Hanya baris ber-`is_selected` yang dihitung `GET /cart/summary` dan
  /// yang ikut ke checkout.
  @BoolJson()
  @JsonKey(name: 'is_selected')
  bool get isSelected;
  @StringOrNullJson()
  String? get sku;

  /// Harga satuan saat baris dibuat, string berdesimal (`"75000.00"`).
  @DoubleJson()
  double get price;

  /// Dikirim sebagai string berisi JSON, sama seperti di varian produk.
  @JsonMapJson()
  @JsonKey(name: 'variant_options')
  Map<String, dynamic>? get variantOptions;
  @StringJson()
  @JsonKey(name: 'product_name')
  String get productName;
  @StringJson()
  @JsonKey(name: 'store_name')
  String get storeName;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CartItemModelCopyWith<CartItemModel> get copyWith =>
      _$CartItemModelCopyWithImpl<CartItemModel>(
          this as CartItemModel, _$identity);

  /// Serializes this CartItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CartItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.productVariantId, productVariantId) ||
                other.productVariantId == productVariantId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality()
                .equals(other.variantOptions, variantOptions) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cartId,
      storeId,
      productVariantId,
      warehouseId,
      quantity,
      isSelected,
      sku,
      price,
      const DeepCollectionEquality().hash(variantOptions),
      productName,
      storeName,
      createdAt);

  @override
  String toString() {
    return 'CartItemModel(id: $id, cartId: $cartId, storeId: $storeId, productVariantId: $productVariantId, warehouseId: $warehouseId, quantity: $quantity, isSelected: $isSelected, sku: $sku, price: $price, variantOptions: $variantOptions, productName: $productName, storeName: $storeName, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CartItemModelCopyWith<$Res> {
  factory $CartItemModelCopyWith(
          CartItemModel value, $Res Function(CartItemModel) _then) =
      _$CartItemModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'cart_id') int cartId,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @IntJson() @JsonKey(name: 'product_variant_id') int productVariantId,
      @IntOrNullJson() @JsonKey(name: 'warehouse_id') int? warehouseId,
      @IntJson() int quantity,
      @BoolJson() @JsonKey(name: 'is_selected') bool isSelected,
      @StringOrNullJson() String? sku,
      @DoubleJson() double price,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      Map<String, dynamic>? variantOptions,
      @StringJson() @JsonKey(name: 'product_name') String productName,
      @StringJson() @JsonKey(name: 'store_name') String storeName,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$CartItemModelCopyWithImpl<$Res>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._self, this._then);

  final CartItemModel _self;
  final $Res Function(CartItemModel) _then;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cartId = null,
    Object? storeId = null,
    Object? productVariantId = null,
    Object? warehouseId = freezed,
    Object? quantity = null,
    Object? isSelected = null,
    Object? sku = freezed,
    Object? price = null,
    Object? variantOptions = freezed,
    Object? productName = null,
    Object? storeName = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cartId: null == cartId
          ? _self.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      productVariantId: null == productVariantId
          ? _self.productVariantId
          : productVariantId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseId: freezed == warehouseId
          ? _self.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int?,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      sku: freezed == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      variantOptions: freezed == variantOptions
          ? _self.variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CartItemModel].
extension CartItemModelPatterns on CartItemModel {
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
    TResult Function(_CartItemModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CartItemModel() when $default != null:
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
    TResult Function(_CartItemModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartItemModel():
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
    TResult? Function(_CartItemModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartItemModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'cart_id') int cartId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @IntJson()
            @JsonKey(name: 'product_variant_id')
            int productVariantId,
            @IntOrNullJson() @JsonKey(name: 'warehouse_id') int? warehouseId,
            @IntJson() int quantity,
            @BoolJson() @JsonKey(name: 'is_selected') bool isSelected,
            @StringOrNullJson() String? sku,
            @DoubleJson() double price,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @StringJson() @JsonKey(name: 'product_name') String productName,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CartItemModel() when $default != null:
        return $default(
            _that.id,
            _that.cartId,
            _that.storeId,
            _that.productVariantId,
            _that.warehouseId,
            _that.quantity,
            _that.isSelected,
            _that.sku,
            _that.price,
            _that.variantOptions,
            _that.productName,
            _that.storeName,
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
            @IntJson() @JsonKey(name: 'cart_id') int cartId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @IntJson()
            @JsonKey(name: 'product_variant_id')
            int productVariantId,
            @IntOrNullJson() @JsonKey(name: 'warehouse_id') int? warehouseId,
            @IntJson() int quantity,
            @BoolJson() @JsonKey(name: 'is_selected') bool isSelected,
            @StringOrNullJson() String? sku,
            @DoubleJson() double price,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @StringJson() @JsonKey(name: 'product_name') String productName,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartItemModel():
        return $default(
            _that.id,
            _that.cartId,
            _that.storeId,
            _that.productVariantId,
            _that.warehouseId,
            _that.quantity,
            _that.isSelected,
            _that.sku,
            _that.price,
            _that.variantOptions,
            _that.productName,
            _that.storeName,
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
            @IntJson() @JsonKey(name: 'cart_id') int cartId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @IntJson()
            @JsonKey(name: 'product_variant_id')
            int productVariantId,
            @IntOrNullJson() @JsonKey(name: 'warehouse_id') int? warehouseId,
            @IntJson() int quantity,
            @BoolJson() @JsonKey(name: 'is_selected') bool isSelected,
            @StringOrNullJson() String? sku,
            @DoubleJson() double price,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @StringJson() @JsonKey(name: 'product_name') String productName,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartItemModel() when $default != null:
        return $default(
            _that.id,
            _that.cartId,
            _that.storeId,
            _that.productVariantId,
            _that.warehouseId,
            _that.quantity,
            _that.isSelected,
            _that.sku,
            _that.price,
            _that.variantOptions,
            _that.productName,
            _that.storeName,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CartItemModel extends CartItemModel {
  const _CartItemModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'cart_id') this.cartId = 0,
      @IntJson() @JsonKey(name: 'store_id') this.storeId = 0,
      @IntJson() @JsonKey(name: 'product_variant_id') this.productVariantId = 0,
      @IntOrNullJson() @JsonKey(name: 'warehouse_id') this.warehouseId,
      @IntJson() this.quantity = 1,
      @BoolJson() @JsonKey(name: 'is_selected') this.isSelected = true,
      @StringOrNullJson() this.sku,
      @DoubleJson() this.price = 0,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      final Map<String, dynamic>? variantOptions,
      @StringJson() @JsonKey(name: 'product_name') this.productName = '',
      @StringJson() @JsonKey(name: 'store_name') this.storeName = '',
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : _variantOptions = variantOptions,
        super._();
  factory _CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'cart_id')
  final int cartId;
  @override
  @IntJson()
  @JsonKey(name: 'store_id')
  final int storeId;

  /// Baris keranjang selalu merujuk **varian**, bukan produk.
  @override
  @IntJson()
  @JsonKey(name: 'product_variant_id')
  final int productVariantId;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'warehouse_id')
  final int? warehouseId;

  /// ⚠️ **Server tidak memvalidasi nilai ini sama sekali.** Sudah diuji:
  /// `PATCH` dengan `quantity: 99999` pada varian berstok 150 dibalas `200`
  /// dan benar-benar tersimpan; `0` juga diterima. Pembatasan terhadap stok
  /// **harus dilakukan aplikasi** sebelum mengirim, kalau tidak user baru
  /// tahu keranjangnya mustahil saat checkout gagal.
  @override
  @JsonKey()
  @IntJson()
  final int quantity;

  /// Hanya baris ber-`is_selected` yang dihitung `GET /cart/summary` dan
  /// yang ikut ke checkout.
  @override
  @BoolJson()
  @JsonKey(name: 'is_selected')
  final bool isSelected;
  @override
  @StringOrNullJson()
  final String? sku;

  /// Harga satuan saat baris dibuat, string berdesimal (`"75000.00"`).
  @override
  @JsonKey()
  @DoubleJson()
  final double price;

  /// Dikirim sebagai string berisi JSON, sama seperti di varian produk.
  final Map<String, dynamic>? _variantOptions;

  /// Dikirim sebagai string berisi JSON, sama seperti di varian produk.
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
  @StringJson()
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @StringJson()
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CartItemModelCopyWith<_CartItemModel> get copyWith =>
      __$CartItemModelCopyWithImpl<_CartItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CartItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CartItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.productVariantId, productVariantId) ||
                other.productVariantId == productVariantId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality()
                .equals(other._variantOptions, _variantOptions) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cartId,
      storeId,
      productVariantId,
      warehouseId,
      quantity,
      isSelected,
      sku,
      price,
      const DeepCollectionEquality().hash(_variantOptions),
      productName,
      storeName,
      createdAt);

  @override
  String toString() {
    return 'CartItemModel(id: $id, cartId: $cartId, storeId: $storeId, productVariantId: $productVariantId, warehouseId: $warehouseId, quantity: $quantity, isSelected: $isSelected, sku: $sku, price: $price, variantOptions: $variantOptions, productName: $productName, storeName: $storeName, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CartItemModelCopyWith<$Res>
    implements $CartItemModelCopyWith<$Res> {
  factory _$CartItemModelCopyWith(
          _CartItemModel value, $Res Function(_CartItemModel) _then) =
      __$CartItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'cart_id') int cartId,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @IntJson() @JsonKey(name: 'product_variant_id') int productVariantId,
      @IntOrNullJson() @JsonKey(name: 'warehouse_id') int? warehouseId,
      @IntJson() int quantity,
      @BoolJson() @JsonKey(name: 'is_selected') bool isSelected,
      @StringOrNullJson() String? sku,
      @DoubleJson() double price,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      Map<String, dynamic>? variantOptions,
      @StringJson() @JsonKey(name: 'product_name') String productName,
      @StringJson() @JsonKey(name: 'store_name') String storeName,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$CartItemModelCopyWithImpl<$Res>
    implements _$CartItemModelCopyWith<$Res> {
  __$CartItemModelCopyWithImpl(this._self, this._then);

  final _CartItemModel _self;
  final $Res Function(_CartItemModel) _then;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? cartId = null,
    Object? storeId = null,
    Object? productVariantId = null,
    Object? warehouseId = freezed,
    Object? quantity = null,
    Object? isSelected = null,
    Object? sku = freezed,
    Object? price = null,
    Object? variantOptions = freezed,
    Object? productName = null,
    Object? storeName = null,
    Object? createdAt = freezed,
  }) {
    return _then(_CartItemModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cartId: null == cartId
          ? _self.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      productVariantId: null == productVariantId
          ? _self.productVariantId
          : productVariantId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseId: freezed == warehouseId
          ? _self.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int?,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _self.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      sku: freezed == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      variantOptions: freezed == variantOptions
          ? _self._variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$CartStoreGroup {
  @StringJson()
  @JsonKey(name: 'store_name')
  String get storeName;
  List<CartItemModel> get items;

  /// Create a copy of CartStoreGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CartStoreGroupCopyWith<CartStoreGroup> get copyWith =>
      _$CartStoreGroupCopyWithImpl<CartStoreGroup>(
          this as CartStoreGroup, _$identity);

  /// Serializes this CartStoreGroup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CartStoreGroup &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, storeName, const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'CartStoreGroup(storeName: $storeName, items: $items)';
  }
}

/// @nodoc
abstract mixin class $CartStoreGroupCopyWith<$Res> {
  factory $CartStoreGroupCopyWith(
          CartStoreGroup value, $Res Function(CartStoreGroup) _then) =
      _$CartStoreGroupCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'store_name') String storeName,
      List<CartItemModel> items});
}

/// @nodoc
class _$CartStoreGroupCopyWithImpl<$Res>
    implements $CartStoreGroupCopyWith<$Res> {
  _$CartStoreGroupCopyWithImpl(this._self, this._then);

  final CartStoreGroup _self;
  final $Res Function(CartStoreGroup) _then;

  /// Create a copy of CartStoreGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeName = null,
    Object? items = null,
  }) {
    return _then(_self.copyWith(
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItemModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CartStoreGroup].
extension CartStoreGroupPatterns on CartStoreGroup {
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
    TResult Function(_CartStoreGroup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CartStoreGroup() when $default != null:
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
    TResult Function(_CartStoreGroup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartStoreGroup():
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
    TResult? Function(_CartStoreGroup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartStoreGroup() when $default != null:
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
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            List<CartItemModel> items)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CartStoreGroup() when $default != null:
        return $default(_that.storeName, _that.items);
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
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            List<CartItemModel> items)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartStoreGroup():
        return $default(_that.storeName, _that.items);
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
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            List<CartItemModel> items)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartStoreGroup() when $default != null:
        return $default(_that.storeName, _that.items);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CartStoreGroup extends CartStoreGroup {
  const _CartStoreGroup(
      {@StringJson() @JsonKey(name: 'store_name') this.storeName = '',
      final List<CartItemModel> items = const <CartItemModel>[]})
      : _items = items,
        super._();
  factory _CartStoreGroup.fromJson(Map<String, dynamic> json) =>
      _$CartStoreGroupFromJson(json);

  @override
  @StringJson()
  @JsonKey(name: 'store_name')
  final String storeName;
  final List<CartItemModel> _items;
  @override
  @JsonKey()
  List<CartItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of CartStoreGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CartStoreGroupCopyWith<_CartStoreGroup> get copyWith =>
      __$CartStoreGroupCopyWithImpl<_CartStoreGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CartStoreGroupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CartStoreGroup &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, storeName, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'CartStoreGroup(storeName: $storeName, items: $items)';
  }
}

/// @nodoc
abstract mixin class _$CartStoreGroupCopyWith<$Res>
    implements $CartStoreGroupCopyWith<$Res> {
  factory _$CartStoreGroupCopyWith(
          _CartStoreGroup value, $Res Function(_CartStoreGroup) _then) =
      __$CartStoreGroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() @JsonKey(name: 'store_name') String storeName,
      List<CartItemModel> items});
}

/// @nodoc
class __$CartStoreGroupCopyWithImpl<$Res>
    implements _$CartStoreGroupCopyWith<$Res> {
  __$CartStoreGroupCopyWithImpl(this._self, this._then);

  final _CartStoreGroup _self;
  final $Res Function(_CartStoreGroup) _then;

  /// Create a copy of CartStoreGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? storeName = null,
    Object? items = null,
  }) {
    return _then(_CartStoreGroup(
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItemModel>,
    ));
  }
}

/// @nodoc
mixin _$AppliedVoucherModel {
  @StringJson()
  String get code;

  /// `shipping` / `platform` / `store` — slot penumpukan, diturunkan server
  /// dari `discount_type` dan `store_id`, bukan kolom tersendiri.
  @StringJson()
  String get category;

  /// `null` untuk voucher platform.
  @IntOrNullJson()
  @JsonKey(name: 'store_id')
  int? get storeId;

  /// `percentage` / `fixed` / `free_shipping` / `cashback`.
  @StringJson()
  @JsonKey(name: 'discount_type')
  String get discountType;
  @DoubleJson()
  @JsonKey(name: 'discount_value')
  double get discountValue;
  @DoubleOrNullJson()
  @JsonKey(name: 'max_discount')
  double? get maxDiscount;

  /// Potongan rupiah yang benar-benar berlaku. `null` untuk ongkir, `0`
  /// untuk cashback — lihat catatan kelas.
  @DoubleOrNullJson()
  @JsonKey(name: 'discount_amount')
  double? get discountAmount;

  /// Hanya di `GET /cart/recommended-vouchers`: id voucher dan **perkiraan**
  /// nilai rupiahnya (`estimate_voucher_value`). Untuk voucher ongkir
  /// nilainya `discount_value` — potensi, bukan potongan pasti — jadi
  /// jangan ditulis sebagai "hemat" di kartu rekomendasi ongkir.
  @IntOrNullJson()
  @JsonKey(name: 'voucher_id')
  int? get voucherId;
  @DoubleOrNullJson()
  @JsonKey(name: 'value')
  double? get estimatedValue;

  /// Create a copy of AppliedVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppliedVoucherModelCopyWith<AppliedVoucherModel> get copyWith =>
      _$AppliedVoucherModelCopyWithImpl<AppliedVoucherModel>(
          this as AppliedVoucherModel, _$identity);

  /// Serializes this AppliedVoucherModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppliedVoucherModel &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.maxDiscount, maxDiscount) ||
                other.maxDiscount == maxDiscount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.voucherId, voucherId) ||
                other.voucherId == voucherId) &&
            (identical(other.estimatedValue, estimatedValue) ||
                other.estimatedValue == estimatedValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      category,
      storeId,
      discountType,
      discountValue,
      maxDiscount,
      discountAmount,
      voucherId,
      estimatedValue);

  @override
  String toString() {
    return 'AppliedVoucherModel(code: $code, category: $category, storeId: $storeId, discountType: $discountType, discountValue: $discountValue, maxDiscount: $maxDiscount, discountAmount: $discountAmount, voucherId: $voucherId, estimatedValue: $estimatedValue)';
  }
}

/// @nodoc
abstract mixin class $AppliedVoucherModelCopyWith<$Res> {
  factory $AppliedVoucherModelCopyWith(
          AppliedVoucherModel value, $Res Function(AppliedVoucherModel) _then) =
      _$AppliedVoucherModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringJson() String code,
      @StringJson() String category,
      @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
      @StringJson() @JsonKey(name: 'discount_type') String discountType,
      @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
      @DoubleOrNullJson() @JsonKey(name: 'max_discount') double? maxDiscount,
      @DoubleOrNullJson()
      @JsonKey(name: 'discount_amount')
      double? discountAmount,
      @IntOrNullJson() @JsonKey(name: 'voucher_id') int? voucherId,
      @DoubleOrNullJson() @JsonKey(name: 'value') double? estimatedValue});
}

/// @nodoc
class _$AppliedVoucherModelCopyWithImpl<$Res>
    implements $AppliedVoucherModelCopyWith<$Res> {
  _$AppliedVoucherModelCopyWithImpl(this._self, this._then);

  final AppliedVoucherModel _self;
  final $Res Function(AppliedVoucherModel) _then;

  /// Create a copy of AppliedVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? category = null,
    Object? storeId = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscount = freezed,
    Object? discountAmount = freezed,
    Object? voucherId = freezed,
    Object? estimatedValue = freezed,
  }) {
    return _then(_self.copyWith(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int?,
      discountType: null == discountType
          ? _self.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _self.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscount: freezed == maxDiscount
          ? _self.maxDiscount
          : maxDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      voucherId: freezed == voucherId
          ? _self.voucherId
          : voucherId // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedValue: freezed == estimatedValue
          ? _self.estimatedValue
          : estimatedValue // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppliedVoucherModel].
extension AppliedVoucherModelPatterns on AppliedVoucherModel {
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
    TResult Function(_AppliedVoucherModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppliedVoucherModel() when $default != null:
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
    TResult Function(_AppliedVoucherModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppliedVoucherModel():
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
    TResult? Function(_AppliedVoucherModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppliedVoucherModel() when $default != null:
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
            @StringJson() String code,
            @StringJson() String category,
            @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
            @StringJson() @JsonKey(name: 'discount_type') String discountType,
            @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
            @DoubleOrNullJson()
            @JsonKey(name: 'max_discount')
            double? maxDiscount,
            @DoubleOrNullJson()
            @JsonKey(name: 'discount_amount')
            double? discountAmount,
            @IntOrNullJson() @JsonKey(name: 'voucher_id') int? voucherId,
            @DoubleOrNullJson() @JsonKey(name: 'value') double? estimatedValue)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppliedVoucherModel() when $default != null:
        return $default(
            _that.code,
            _that.category,
            _that.storeId,
            _that.discountType,
            _that.discountValue,
            _that.maxDiscount,
            _that.discountAmount,
            _that.voucherId,
            _that.estimatedValue);
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
            @StringJson() String code,
            @StringJson() String category,
            @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
            @StringJson() @JsonKey(name: 'discount_type') String discountType,
            @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
            @DoubleOrNullJson()
            @JsonKey(name: 'max_discount')
            double? maxDiscount,
            @DoubleOrNullJson()
            @JsonKey(name: 'discount_amount')
            double? discountAmount,
            @IntOrNullJson() @JsonKey(name: 'voucher_id') int? voucherId,
            @DoubleOrNullJson() @JsonKey(name: 'value') double? estimatedValue)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppliedVoucherModel():
        return $default(
            _that.code,
            _that.category,
            _that.storeId,
            _that.discountType,
            _that.discountValue,
            _that.maxDiscount,
            _that.discountAmount,
            _that.voucherId,
            _that.estimatedValue);
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
            @StringJson() String code,
            @StringJson() String category,
            @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
            @StringJson() @JsonKey(name: 'discount_type') String discountType,
            @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
            @DoubleOrNullJson()
            @JsonKey(name: 'max_discount')
            double? maxDiscount,
            @DoubleOrNullJson()
            @JsonKey(name: 'discount_amount')
            double? discountAmount,
            @IntOrNullJson() @JsonKey(name: 'voucher_id') int? voucherId,
            @DoubleOrNullJson() @JsonKey(name: 'value') double? estimatedValue)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppliedVoucherModel() when $default != null:
        return $default(
            _that.code,
            _that.category,
            _that.storeId,
            _that.discountType,
            _that.discountValue,
            _that.maxDiscount,
            _that.discountAmount,
            _that.voucherId,
            _that.estimatedValue);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AppliedVoucherModel extends AppliedVoucherModel {
  const _AppliedVoucherModel(
      {@StringJson() this.code = '',
      @StringJson() this.category = '',
      @IntOrNullJson() @JsonKey(name: 'store_id') this.storeId,
      @StringJson() @JsonKey(name: 'discount_type') this.discountType = '',
      @DoubleJson() @JsonKey(name: 'discount_value') this.discountValue = 0,
      @DoubleOrNullJson() @JsonKey(name: 'max_discount') this.maxDiscount,
      @DoubleOrNullJson() @JsonKey(name: 'discount_amount') this.discountAmount,
      @IntOrNullJson() @JsonKey(name: 'voucher_id') this.voucherId,
      @DoubleOrNullJson() @JsonKey(name: 'value') this.estimatedValue})
      : super._();
  factory _AppliedVoucherModel.fromJson(Map<String, dynamic> json) =>
      _$AppliedVoucherModelFromJson(json);

  @override
  @JsonKey()
  @StringJson()
  final String code;

  /// `shipping` / `platform` / `store` — slot penumpukan, diturunkan server
  /// dari `discount_type` dan `store_id`, bukan kolom tersendiri.
  @override
  @JsonKey()
  @StringJson()
  final String category;

  /// `null` untuk voucher platform.
  @override
  @IntOrNullJson()
  @JsonKey(name: 'store_id')
  final int? storeId;

  /// `percentage` / `fixed` / `free_shipping` / `cashback`.
  @override
  @StringJson()
  @JsonKey(name: 'discount_type')
  final String discountType;
  @override
  @DoubleJson()
  @JsonKey(name: 'discount_value')
  final double discountValue;
  @override
  @DoubleOrNullJson()
  @JsonKey(name: 'max_discount')
  final double? maxDiscount;

  /// Potongan rupiah yang benar-benar berlaku. `null` untuk ongkir, `0`
  /// untuk cashback — lihat catatan kelas.
  @override
  @DoubleOrNullJson()
  @JsonKey(name: 'discount_amount')
  final double? discountAmount;

  /// Hanya di `GET /cart/recommended-vouchers`: id voucher dan **perkiraan**
  /// nilai rupiahnya (`estimate_voucher_value`). Untuk voucher ongkir
  /// nilainya `discount_value` — potensi, bukan potongan pasti — jadi
  /// jangan ditulis sebagai "hemat" di kartu rekomendasi ongkir.
  @override
  @IntOrNullJson()
  @JsonKey(name: 'voucher_id')
  final int? voucherId;
  @override
  @DoubleOrNullJson()
  @JsonKey(name: 'value')
  final double? estimatedValue;

  /// Create a copy of AppliedVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppliedVoucherModelCopyWith<_AppliedVoucherModel> get copyWith =>
      __$AppliedVoucherModelCopyWithImpl<_AppliedVoucherModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppliedVoucherModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppliedVoucherModel &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.maxDiscount, maxDiscount) ||
                other.maxDiscount == maxDiscount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.voucherId, voucherId) ||
                other.voucherId == voucherId) &&
            (identical(other.estimatedValue, estimatedValue) ||
                other.estimatedValue == estimatedValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      category,
      storeId,
      discountType,
      discountValue,
      maxDiscount,
      discountAmount,
      voucherId,
      estimatedValue);

  @override
  String toString() {
    return 'AppliedVoucherModel(code: $code, category: $category, storeId: $storeId, discountType: $discountType, discountValue: $discountValue, maxDiscount: $maxDiscount, discountAmount: $discountAmount, voucherId: $voucherId, estimatedValue: $estimatedValue)';
  }
}

/// @nodoc
abstract mixin class _$AppliedVoucherModelCopyWith<$Res>
    implements $AppliedVoucherModelCopyWith<$Res> {
  factory _$AppliedVoucherModelCopyWith(_AppliedVoucherModel value,
          $Res Function(_AppliedVoucherModel) _then) =
      __$AppliedVoucherModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringJson() String code,
      @StringJson() String category,
      @IntOrNullJson() @JsonKey(name: 'store_id') int? storeId,
      @StringJson() @JsonKey(name: 'discount_type') String discountType,
      @DoubleJson() @JsonKey(name: 'discount_value') double discountValue,
      @DoubleOrNullJson() @JsonKey(name: 'max_discount') double? maxDiscount,
      @DoubleOrNullJson()
      @JsonKey(name: 'discount_amount')
      double? discountAmount,
      @IntOrNullJson() @JsonKey(name: 'voucher_id') int? voucherId,
      @DoubleOrNullJson() @JsonKey(name: 'value') double? estimatedValue});
}

/// @nodoc
class __$AppliedVoucherModelCopyWithImpl<$Res>
    implements _$AppliedVoucherModelCopyWith<$Res> {
  __$AppliedVoucherModelCopyWithImpl(this._self, this._then);

  final _AppliedVoucherModel _self;
  final $Res Function(_AppliedVoucherModel) _then;

  /// Create a copy of AppliedVoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? category = null,
    Object? storeId = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscount = freezed,
    Object? discountAmount = freezed,
    Object? voucherId = freezed,
    Object? estimatedValue = freezed,
  }) {
    return _then(_AppliedVoucherModel(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int?,
      discountType: null == discountType
          ? _self.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _self.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscount: freezed == maxDiscount
          ? _self.maxDiscount
          : maxDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      voucherId: freezed == voucherId
          ? _self.voucherId
          : voucherId // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedValue: freezed == estimatedValue
          ? _self.estimatedValue
          : estimatedValue // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
mixin _$CartSummaryModel {
  @DoubleJson()
  double get subtotal;
  @IntJson()
  @JsonKey(name: 'item_count')
  int get itemCount;

  /// Voucher yang sedang terpasang; `[]` selama belum ada yang dipasang.
  ///
  /// Server **membuang sendiri voucher yang sudah tidak valid** terhadap isi
  /// keranjang saat ini (`list_applied_vouchers` menghapusnya dari
  /// `cart_applied_vouchers`), jadi daftar ini selalu voucher yang benar-benar
  /// masih berlaku — tidak perlu divalidasi ulang di aplikasi.
  List<AppliedVoucherModel> get vouchers;

  /// Total potongan rupiah dari [vouchers].
  ///
  /// ⚠️ **Voucher ongkir dan cashback tidak ikut dijumlah** — keduanya
  /// menyumbang nol di sini. Jadi `discount_amount` nol tidak berarti tidak
  /// ada voucher terpasang.
  @DoubleJson()
  @JsonKey(name: 'discount_amount')
  double get discountAmount;

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CartSummaryModelCopyWith<CartSummaryModel> get copyWith =>
      _$CartSummaryModelCopyWithImpl<CartSummaryModel>(
          this as CartSummaryModel, _$identity);

  /// Serializes this CartSummaryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CartSummaryModel &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            const DeepCollectionEquality().equals(other.vouchers, vouchers) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subtotal, itemCount,
      const DeepCollectionEquality().hash(vouchers), discountAmount);

  @override
  String toString() {
    return 'CartSummaryModel(subtotal: $subtotal, itemCount: $itemCount, vouchers: $vouchers, discountAmount: $discountAmount)';
  }
}

/// @nodoc
abstract mixin class $CartSummaryModelCopyWith<$Res> {
  factory $CartSummaryModelCopyWith(
          CartSummaryModel value, $Res Function(CartSummaryModel) _then) =
      _$CartSummaryModelCopyWithImpl;
  @useResult
  $Res call(
      {@DoubleJson() double subtotal,
      @IntJson() @JsonKey(name: 'item_count') int itemCount,
      List<AppliedVoucherModel> vouchers,
      @DoubleJson() @JsonKey(name: 'discount_amount') double discountAmount});
}

/// @nodoc
class _$CartSummaryModelCopyWithImpl<$Res>
    implements $CartSummaryModelCopyWith<$Res> {
  _$CartSummaryModelCopyWithImpl(this._self, this._then);

  final CartSummaryModel _self;
  final $Res Function(CartSummaryModel) _then;

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? itemCount = null,
    Object? vouchers = null,
    Object? discountAmount = null,
  }) {
    return _then(_self.copyWith(
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      itemCount: null == itemCount
          ? _self.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      vouchers: null == vouchers
          ? _self.vouchers
          : vouchers // ignore: cast_nullable_to_non_nullable
              as List<AppliedVoucherModel>,
      discountAmount: null == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [CartSummaryModel].
extension CartSummaryModelPatterns on CartSummaryModel {
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
    TResult Function(_CartSummaryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CartSummaryModel() when $default != null:
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
    TResult Function(_CartSummaryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartSummaryModel():
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
    TResult? Function(_CartSummaryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartSummaryModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'item_count') int itemCount,
            List<AppliedVoucherModel> vouchers,
            @DoubleJson()
            @JsonKey(name: 'discount_amount')
            double discountAmount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CartSummaryModel() when $default != null:
        return $default(_that.subtotal, _that.itemCount, _that.vouchers,
            _that.discountAmount);
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
            @IntJson() @JsonKey(name: 'item_count') int itemCount,
            List<AppliedVoucherModel> vouchers,
            @DoubleJson()
            @JsonKey(name: 'discount_amount')
            double discountAmount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartSummaryModel():
        return $default(_that.subtotal, _that.itemCount, _that.vouchers,
            _that.discountAmount);
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
            @IntJson() @JsonKey(name: 'item_count') int itemCount,
            List<AppliedVoucherModel> vouchers,
            @DoubleJson()
            @JsonKey(name: 'discount_amount')
            double discountAmount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CartSummaryModel() when $default != null:
        return $default(_that.subtotal, _that.itemCount, _that.vouchers,
            _that.discountAmount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CartSummaryModel extends CartSummaryModel {
  const _CartSummaryModel(
      {@DoubleJson() this.subtotal = 0,
      @IntJson() @JsonKey(name: 'item_count') this.itemCount = 0,
      final List<AppliedVoucherModel> vouchers = const <AppliedVoucherModel>[],
      @DoubleJson() @JsonKey(name: 'discount_amount') this.discountAmount = 0})
      : _vouchers = vouchers,
        super._();
  factory _CartSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryModelFromJson(json);

  @override
  @JsonKey()
  @DoubleJson()
  final double subtotal;
  @override
  @IntJson()
  @JsonKey(name: 'item_count')
  final int itemCount;

  /// Voucher yang sedang terpasang; `[]` selama belum ada yang dipasang.
  ///
  /// Server **membuang sendiri voucher yang sudah tidak valid** terhadap isi
  /// keranjang saat ini (`list_applied_vouchers` menghapusnya dari
  /// `cart_applied_vouchers`), jadi daftar ini selalu voucher yang benar-benar
  /// masih berlaku — tidak perlu divalidasi ulang di aplikasi.
  final List<AppliedVoucherModel> _vouchers;

  /// Voucher yang sedang terpasang; `[]` selama belum ada yang dipasang.
  ///
  /// Server **membuang sendiri voucher yang sudah tidak valid** terhadap isi
  /// keranjang saat ini (`list_applied_vouchers` menghapusnya dari
  /// `cart_applied_vouchers`), jadi daftar ini selalu voucher yang benar-benar
  /// masih berlaku — tidak perlu divalidasi ulang di aplikasi.
  @override
  @JsonKey()
  List<AppliedVoucherModel> get vouchers {
    if (_vouchers is EqualUnmodifiableListView) return _vouchers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vouchers);
  }

  /// Total potongan rupiah dari [vouchers].
  ///
  /// ⚠️ **Voucher ongkir dan cashback tidak ikut dijumlah** — keduanya
  /// menyumbang nol di sini. Jadi `discount_amount` nol tidak berarti tidak
  /// ada voucher terpasang.
  @override
  @DoubleJson()
  @JsonKey(name: 'discount_amount')
  final double discountAmount;

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CartSummaryModelCopyWith<_CartSummaryModel> get copyWith =>
      __$CartSummaryModelCopyWithImpl<_CartSummaryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CartSummaryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CartSummaryModel &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            const DeepCollectionEquality().equals(other._vouchers, _vouchers) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subtotal, itemCount,
      const DeepCollectionEquality().hash(_vouchers), discountAmount);

  @override
  String toString() {
    return 'CartSummaryModel(subtotal: $subtotal, itemCount: $itemCount, vouchers: $vouchers, discountAmount: $discountAmount)';
  }
}

/// @nodoc
abstract mixin class _$CartSummaryModelCopyWith<$Res>
    implements $CartSummaryModelCopyWith<$Res> {
  factory _$CartSummaryModelCopyWith(
          _CartSummaryModel value, $Res Function(_CartSummaryModel) _then) =
      __$CartSummaryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DoubleJson() double subtotal,
      @IntJson() @JsonKey(name: 'item_count') int itemCount,
      List<AppliedVoucherModel> vouchers,
      @DoubleJson() @JsonKey(name: 'discount_amount') double discountAmount});
}

/// @nodoc
class __$CartSummaryModelCopyWithImpl<$Res>
    implements _$CartSummaryModelCopyWith<$Res> {
  __$CartSummaryModelCopyWithImpl(this._self, this._then);

  final _CartSummaryModel _self;
  final $Res Function(_CartSummaryModel) _then;

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? subtotal = null,
    Object? itemCount = null,
    Object? vouchers = null,
    Object? discountAmount = null,
  }) {
    return _then(_CartSummaryModel(
      subtotal: null == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      itemCount: null == itemCount
          ? _self.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      vouchers: null == vouchers
          ? _self._vouchers
          : vouchers // ignore: cast_nullable_to_non_nullable
              as List<AppliedVoucherModel>,
      discountAmount: null == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
