// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogHomeState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CatalogHomeState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CatalogHomeState()';
  }
}

/// @nodoc
class $CatalogHomeStateCopyWith<$Res> {
  $CatalogHomeStateCopyWith(
      CatalogHomeState _, $Res Function(CatalogHomeState) __);
}

/// Adds pattern-matching-related methods to [CatalogHomeState].
extension CatalogHomeStatePatterns on CatalogHomeState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogInitial value)? initial,
    TResult Function(CatalogLoading value)? loading,
    TResult Function(CatalogLoaded value)? loaded,
    TResult Function(CatalogEmpty value)? empty,
    TResult Function(CatalogError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CatalogInitial() when initial != null:
        return initial(_that);
      case CatalogLoading() when loading != null:
        return loading(_that);
      case CatalogLoaded() when loaded != null:
        return loaded(_that);
      case CatalogEmpty() when empty != null:
        return empty(_that);
      case CatalogError() when error != null:
        return error(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogInitial value) initial,
    required TResult Function(CatalogLoading value) loading,
    required TResult Function(CatalogLoaded value) loaded,
    required TResult Function(CatalogEmpty value) empty,
    required TResult Function(CatalogError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case CatalogInitial():
        return initial(_that);
      case CatalogLoading():
        return loading(_that);
      case CatalogLoaded():
        return loaded(_that);
      case CatalogEmpty():
        return empty(_that);
      case CatalogError():
        return error(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogInitial value)? initial,
    TResult? Function(CatalogLoading value)? loading,
    TResult? Function(CatalogLoaded value)? loaded,
    TResult? Function(CatalogEmpty value)? empty,
    TResult? Function(CatalogError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CatalogInitial() when initial != null:
        return initial(_that);
      case CatalogLoading() when loading != null:
        return loading(_that);
      case CatalogLoaded() when loaded != null:
        return loaded(_that);
      case CatalogEmpty() when empty != null:
        return empty(_that);
      case CatalogError() when error != null:
        return error(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ProductModel> products,
            List<CategoryModel> categories,
            ProductFacets facets,
            int page,
            bool hasMore,
            int? total,
            bool isLoadingMore,
            DataError? loadMoreError,
            CatalogQuery? query)?
        loaded,
    TResult Function(List<CategoryModel> categories, CatalogQuery? query)?
        empty,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CatalogInitial() when initial != null:
        return initial();
      case CatalogLoading() when loading != null:
        return loading();
      case CatalogLoaded() when loaded != null:
        return loaded(
            _that.products,
            _that.categories,
            _that.facets,
            _that.page,
            _that.hasMore,
            _that.total,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.query);
      case CatalogEmpty() when empty != null:
        return empty(_that.categories, _that.query);
      case CatalogError() when error != null:
        return error(_that.error);
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
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ProductModel> products,
            List<CategoryModel> categories,
            ProductFacets facets,
            int page,
            bool hasMore,
            int? total,
            bool isLoadingMore,
            DataError? loadMoreError,
            CatalogQuery? query)
        loaded,
    required TResult Function(
            List<CategoryModel> categories, CatalogQuery? query)
        empty,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case CatalogInitial():
        return initial();
      case CatalogLoading():
        return loading();
      case CatalogLoaded():
        return loaded(
            _that.products,
            _that.categories,
            _that.facets,
            _that.page,
            _that.hasMore,
            _that.total,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.query);
      case CatalogEmpty():
        return empty(_that.categories, _that.query);
      case CatalogError():
        return error(_that.error);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ProductModel> products,
            List<CategoryModel> categories,
            ProductFacets facets,
            int page,
            bool hasMore,
            int? total,
            bool isLoadingMore,
            DataError? loadMoreError,
            CatalogQuery? query)?
        loaded,
    TResult? Function(List<CategoryModel> categories, CatalogQuery? query)?
        empty,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CatalogInitial() when initial != null:
        return initial();
      case CatalogLoading() when loading != null:
        return loading();
      case CatalogLoaded() when loaded != null:
        return loaded(
            _that.products,
            _that.categories,
            _that.facets,
            _that.page,
            _that.hasMore,
            _that.total,
            _that.isLoadingMore,
            _that.loadMoreError,
            _that.query);
      case CatalogEmpty() when empty != null:
        return empty(_that.categories, _that.query);
      case CatalogError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class CatalogInitial implements CatalogHomeState {
  const CatalogInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CatalogInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CatalogHomeState.initial()';
  }
}

/// @nodoc

class CatalogLoading implements CatalogHomeState {
  const CatalogLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CatalogLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CatalogHomeState.loading()';
  }
}

/// @nodoc

class CatalogLoaded implements CatalogHomeState {
  const CatalogLoaded(
      {required final List<ProductModel> products,
      final List<CategoryModel> categories = const <CategoryModel>[],
      this.facets = ProductFacets.empty,
      this.page = 1,
      this.hasMore = false,
      this.total,
      this.isLoadingMore = false,
      this.loadMoreError,
      this.query})
      : _products = products,
        _categories = categories;

  final List<ProductModel> _products;
  List<ProductModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  /// Pohon kategori. Bisa kosong kalau `GET /categories` gagal sementara
  /// produk berhasil dimuat — kegagalan salah satunya tidak boleh
  /// mengosongkan seluruh layar.
  final List<CategoryModel> _categories;

  /// Pohon kategori. Bisa kosong kalau `GET /categories` gagal sementara
  /// produk berhasil dimuat — kegagalan salah satunya tidak boleh
  /// mengosongkan seluruh layar.
  @JsonKey()
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @JsonKey()
  final ProductFacets facets;
  @JsonKey()
  final int page;

  /// Masih ada halaman berikutnya, dihitung dari `meta.total`.
  @JsonKey()
  final bool hasMore;

  /// `meta.total` apa adanya — jumlah produk yang cocok, untuk label
  /// "1.238 produk" di hasil pencarian. `null` kalau server tidak
  /// mengirimnya.
  final int? total;

  /// Sedang menambah halaman berikutnya di bawah daftar yang sudah tampil.
  @JsonKey()
  final bool isLoadingMore;

  /// Gagal memuat halaman berikutnya. Daftar yang sudah ada tetap tampil;
  /// layar cukup menampilkan tombol "coba lagi" di kaki daftar.
  final DataError? loadMoreError;
  final CatalogQuery? query;

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CatalogLoadedCopyWith<CatalogLoaded> get copyWith =>
      _$CatalogLoadedCopyWithImpl<CatalogLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CatalogLoaded &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.facets, facets) || other.facets == facets) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.loadMoreError, loadMoreError) ||
                other.loadMoreError == loadMoreError) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(_categories),
      facets,
      page,
      hasMore,
      total,
      isLoadingMore,
      loadMoreError,
      query);

  @override
  String toString() {
    return 'CatalogHomeState.loaded(products: $products, categories: $categories, facets: $facets, page: $page, hasMore: $hasMore, total: $total, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError, query: $query)';
  }
}

/// @nodoc
abstract mixin class $CatalogLoadedCopyWith<$Res>
    implements $CatalogHomeStateCopyWith<$Res> {
  factory $CatalogLoadedCopyWith(
          CatalogLoaded value, $Res Function(CatalogLoaded) _then) =
      _$CatalogLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<ProductModel> products,
      List<CategoryModel> categories,
      ProductFacets facets,
      int page,
      bool hasMore,
      int? total,
      bool isLoadingMore,
      DataError? loadMoreError,
      CatalogQuery? query});

  $CatalogQueryCopyWith<$Res>? get query;
}

/// @nodoc
class _$CatalogLoadedCopyWithImpl<$Res>
    implements $CatalogLoadedCopyWith<$Res> {
  _$CatalogLoadedCopyWithImpl(this._self, this._then);

  final CatalogLoaded _self;
  final $Res Function(CatalogLoaded) _then;

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? products = null,
    Object? categories = null,
    Object? facets = null,
    Object? page = null,
    Object? hasMore = null,
    Object? total = freezed,
    Object? isLoadingMore = null,
    Object? loadMoreError = freezed,
    Object? query = freezed,
  }) {
    return _then(CatalogLoaded(
      products: null == products
          ? _self._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
      facets: null == facets
          ? _self.facets
          : facets // ignore: cast_nullable_to_non_nullable
              as ProductFacets,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      loadMoreError: freezed == loadMoreError
          ? _self.loadMoreError
          : loadMoreError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      query: freezed == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as CatalogQuery?,
    ));
  }

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CatalogQueryCopyWith<$Res>? get query {
    if (_self.query == null) {
      return null;
    }

    return $CatalogQueryCopyWith<$Res>(_self.query!, (value) {
      return _then(_self.copyWith(query: value));
    });
  }
}

/// @nodoc

class CatalogEmpty implements CatalogHomeState {
  const CatalogEmpty(
      {final List<CategoryModel> categories = const <CategoryModel>[],
      this.query})
      : _categories = categories;

  final List<CategoryModel> _categories;
  @JsonKey()
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final CatalogQuery? query;

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CatalogEmptyCopyWith<CatalogEmpty> get copyWith =>
      _$CatalogEmptyCopyWithImpl<CatalogEmpty>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CatalogEmpty &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_categories), query);

  @override
  String toString() {
    return 'CatalogHomeState.empty(categories: $categories, query: $query)';
  }
}

/// @nodoc
abstract mixin class $CatalogEmptyCopyWith<$Res>
    implements $CatalogHomeStateCopyWith<$Res> {
  factory $CatalogEmptyCopyWith(
          CatalogEmpty value, $Res Function(CatalogEmpty) _then) =
      _$CatalogEmptyCopyWithImpl;
  @useResult
  $Res call({List<CategoryModel> categories, CatalogQuery? query});

  $CatalogQueryCopyWith<$Res>? get query;
}

/// @nodoc
class _$CatalogEmptyCopyWithImpl<$Res> implements $CatalogEmptyCopyWith<$Res> {
  _$CatalogEmptyCopyWithImpl(this._self, this._then);

  final CatalogEmpty _self;
  final $Res Function(CatalogEmpty) _then;

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
    Object? query = freezed,
  }) {
    return _then(CatalogEmpty(
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
      query: freezed == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as CatalogQuery?,
    ));
  }

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CatalogQueryCopyWith<$Res>? get query {
    if (_self.query == null) {
      return null;
    }

    return $CatalogQueryCopyWith<$Res>(_self.query!, (value) {
      return _then(_self.copyWith(query: value));
    });
  }
}

/// @nodoc

class CatalogError implements CatalogHomeState {
  const CatalogError(this.error);

  final DataError error;

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CatalogErrorCopyWith<CatalogError> get copyWith =>
      _$CatalogErrorCopyWithImpl<CatalogError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CatalogError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'CatalogHomeState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $CatalogErrorCopyWith<$Res>
    implements $CatalogHomeStateCopyWith<$Res> {
  factory $CatalogErrorCopyWith(
          CatalogError value, $Res Function(CatalogError) _then) =
      _$CatalogErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$CatalogErrorCopyWithImpl<$Res> implements $CatalogErrorCopyWith<$Res> {
  _$CatalogErrorCopyWithImpl(this._self, this._then);

  final CatalogError _self;
  final $Res Function(CatalogError) _then;

  /// Create a copy of CatalogHomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(CatalogError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

/// @nodoc
mixin _$CatalogQuery {
  String? get text;
  int? get categoryId;
  int? get minRating;
  double? get minPrice;
  double? get maxPrice;

  /// Urutan bawaan `recommended`: blueprint melarang kontrol urutan di sisi
  /// pembeli, jadi peringkat sepenuhnya milik server.
  ProductSort get sort;

  /// Tujuan kirim (kota/provinsi alamat utama). Server membuang produk yang
  /// tidak bisa dikirim ke sana, jadi hasil yang tampil memang bisa dibeli.
  String? get destCity;
  String? get destProvince;

  /// Create a copy of CatalogQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CatalogQueryCopyWith<CatalogQuery> get copyWith =>
      _$CatalogQueryCopyWithImpl<CatalogQuery>(
          this as CatalogQuery, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CatalogQuery &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.destCity, destCity) ||
                other.destCity == destCity) &&
            (identical(other.destProvince, destProvince) ||
                other.destProvince == destProvince));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, categoryId, minRating,
      minPrice, maxPrice, sort, destCity, destProvince);

  @override
  String toString() {
    return 'CatalogQuery(text: $text, categoryId: $categoryId, minRating: $minRating, minPrice: $minPrice, maxPrice: $maxPrice, sort: $sort, destCity: $destCity, destProvince: $destProvince)';
  }
}

/// @nodoc
abstract mixin class $CatalogQueryCopyWith<$Res> {
  factory $CatalogQueryCopyWith(
          CatalogQuery value, $Res Function(CatalogQuery) _then) =
      _$CatalogQueryCopyWithImpl;
  @useResult
  $Res call(
      {String? text,
      int? categoryId,
      int? minRating,
      double? minPrice,
      double? maxPrice,
      ProductSort sort,
      String? destCity,
      String? destProvince});
}

/// @nodoc
class _$CatalogQueryCopyWithImpl<$Res> implements $CatalogQueryCopyWith<$Res> {
  _$CatalogQueryCopyWithImpl(this._self, this._then);

  final CatalogQuery _self;
  final $Res Function(CatalogQuery) _then;

  /// Create a copy of CatalogQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = freezed,
    Object? categoryId = freezed,
    Object? minRating = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? sort = null,
    Object? destCity = freezed,
    Object? destProvince = freezed,
  }) {
    return _then(_self.copyWith(
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      minRating: freezed == minRating
          ? _self.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as int?,
      minPrice: freezed == minPrice
          ? _self.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxPrice: freezed == maxPrice
          ? _self.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as ProductSort,
      destCity: freezed == destCity
          ? _self.destCity
          : destCity // ignore: cast_nullable_to_non_nullable
              as String?,
      destProvince: freezed == destProvince
          ? _self.destProvince
          : destProvince // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CatalogQuery].
extension CatalogQueryPatterns on CatalogQuery {
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
    TResult Function(_CatalogQuery value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CatalogQuery() when $default != null:
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
    TResult Function(_CatalogQuery value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CatalogQuery():
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
    TResult? Function(_CatalogQuery value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CatalogQuery() when $default != null:
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
            String? text,
            int? categoryId,
            int? minRating,
            double? minPrice,
            double? maxPrice,
            ProductSort sort,
            String? destCity,
            String? destProvince)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CatalogQuery() when $default != null:
        return $default(
            _that.text,
            _that.categoryId,
            _that.minRating,
            _that.minPrice,
            _that.maxPrice,
            _that.sort,
            _that.destCity,
            _that.destProvince);
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
            String? text,
            int? categoryId,
            int? minRating,
            double? minPrice,
            double? maxPrice,
            ProductSort sort,
            String? destCity,
            String? destProvince)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CatalogQuery():
        return $default(
            _that.text,
            _that.categoryId,
            _that.minRating,
            _that.minPrice,
            _that.maxPrice,
            _that.sort,
            _that.destCity,
            _that.destProvince);
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
            String? text,
            int? categoryId,
            int? minRating,
            double? minPrice,
            double? maxPrice,
            ProductSort sort,
            String? destCity,
            String? destProvince)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CatalogQuery() when $default != null:
        return $default(
            _that.text,
            _that.categoryId,
            _that.minRating,
            _that.minPrice,
            _that.maxPrice,
            _that.sort,
            _that.destCity,
            _that.destProvince);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CatalogQuery extends CatalogQuery {
  const _CatalogQuery(
      {this.text,
      this.categoryId,
      this.minRating,
      this.minPrice,
      this.maxPrice,
      this.sort = ProductSort.recommended,
      this.destCity,
      this.destProvince})
      : super._();

  @override
  final String? text;
  @override
  final int? categoryId;
  @override
  final int? minRating;
  @override
  final double? minPrice;
  @override
  final double? maxPrice;

  /// Urutan bawaan `recommended`: blueprint melarang kontrol urutan di sisi
  /// pembeli, jadi peringkat sepenuhnya milik server.
  @override
  @JsonKey()
  final ProductSort sort;

  /// Tujuan kirim (kota/provinsi alamat utama). Server membuang produk yang
  /// tidak bisa dikirim ke sana, jadi hasil yang tampil memang bisa dibeli.
  @override
  final String? destCity;
  @override
  final String? destProvince;

  /// Create a copy of CatalogQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CatalogQueryCopyWith<_CatalogQuery> get copyWith =>
      __$CatalogQueryCopyWithImpl<_CatalogQuery>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CatalogQuery &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.destCity, destCity) ||
                other.destCity == destCity) &&
            (identical(other.destProvince, destProvince) ||
                other.destProvince == destProvince));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, categoryId, minRating,
      minPrice, maxPrice, sort, destCity, destProvince);

  @override
  String toString() {
    return 'CatalogQuery(text: $text, categoryId: $categoryId, minRating: $minRating, minPrice: $minPrice, maxPrice: $maxPrice, sort: $sort, destCity: $destCity, destProvince: $destProvince)';
  }
}

/// @nodoc
abstract mixin class _$CatalogQueryCopyWith<$Res>
    implements $CatalogQueryCopyWith<$Res> {
  factory _$CatalogQueryCopyWith(
          _CatalogQuery value, $Res Function(_CatalogQuery) _then) =
      __$CatalogQueryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? text,
      int? categoryId,
      int? minRating,
      double? minPrice,
      double? maxPrice,
      ProductSort sort,
      String? destCity,
      String? destProvince});
}

/// @nodoc
class __$CatalogQueryCopyWithImpl<$Res>
    implements _$CatalogQueryCopyWith<$Res> {
  __$CatalogQueryCopyWithImpl(this._self, this._then);

  final _CatalogQuery _self;
  final $Res Function(_CatalogQuery) _then;

  /// Create a copy of CatalogQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = freezed,
    Object? categoryId = freezed,
    Object? minRating = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? sort = null,
    Object? destCity = freezed,
    Object? destProvince = freezed,
  }) {
    return _then(_CatalogQuery(
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      minRating: freezed == minRating
          ? _self.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as int?,
      minPrice: freezed == minPrice
          ? _self.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxPrice: freezed == maxPrice
          ? _self.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as ProductSort,
      destCity: freezed == destCity
          ? _self.destCity
          : destCity // ignore: cast_nullable_to_non_nullable
              as String?,
      destProvince: freezed == destProvince
          ? _self.destProvince
          : destProvince // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
