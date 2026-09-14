import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/category_model.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_facets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'catalog_home_cubit.freezed.dart';
part 'catalog_home_state.dart';

/// Katalog: daftar produk, pencarian, filter kategori, dan paginasi.
///
/// Pencarian di sini memakai `GET /products?q=`, **bukan** `/search/products`.
/// Endpoint search butuh Elasticsearch di 9200 dan membalas `503` selama ES
/// mati, yang merupakan keadaan normal di dev — sementara `?q=` berbasis MySQL
/// selalu tersedia dan sekaligus mengembalikan `meta.facets`.
class CatalogHomeCubit extends Cubit<CatalogHomeState> {
  CatalogHomeCubit()
      : _repository = injector<CatalogRepository>(),
        super(const CatalogHomeState.initial());

  static CatalogHomeCubit get(BuildContext context) => BlocProvider.of(context);

  final CatalogRepository _repository;

  /// Berapa item per halaman. Server memotong di 100.
  static const int pageSize = 20;

  /// Kategori disimpan di cubit, bukan hanya di state, supaya tidak diambil
  /// ulang setiap kali filter berubah — isinya tidak bergantung pada filter.
  List<CategoryModel> _categories = const [];

  /// Memuat layar pertama kali: kategori dan produk bersamaan.
  ///
  /// Keduanya ditembak paralel karena tidak saling bergantung. Kegagalan
  /// kategori **tidak** menggagalkan layar — produk tetap ditampilkan tanpa
  /// baris kategori, karena katalog masih berguna tanpa filter.
  Future<void> load({CatalogQuery? query}) async {
    emit(const CatalogHomeState.loading());

    final results = await Future.wait([
      _repository.fetchCategories(),
      _repository.fetchProducts(
        query: query?.text,
        categoryId: query?.categoryId,
        minRating: query?.minRating,
        minPrice: query?.minPrice,
        maxPrice: query?.maxPrice,
        sort: query?.sort ?? ProductSort.latest,
        page: 1,
        perPage: pageSize,
      ),
    ]);

    if (isClosed) return;

    final categoryState = results[0] as DataState<List<CategoryModel>>;
    final productState = results[1] as DataState<List<ProductModel>>;

    _categories = switch (categoryState) {
      DataSuccess(:final data) => data,
      // Kategori gagal atau kosong: pertahankan yang sudah ada (kalau ini
      // pemuatan ulang) daripada mengosongkan baris kategori.
      _ => _categories,
    };

    emit(_toState(productState, query: query, page: 1));
  }

  /// Mengubah filter lalu memuat ulang dari halaman pertama.
  Future<void> applyQuery(CatalogQuery query) => load(query: query);

  /// Mencari teks bebas. String kosong berarti kembali ke listing biasa.
  Future<void> search(String text) {
    final current = _currentQuery ?? const CatalogQuery();
    return load(query: current.copyWith(text: text.trim().isEmpty ? null : text));
  }

  /// Memilih kategori. `null` melepas filter kategori.
  Future<void> selectCategory(int? categoryId) {
    final current = _currentQuery ?? const CatalogQuery();
    return load(query: current.copyWith(categoryId: categoryId));
  }

  Future<void> changeSort(ProductSort sort) {
    final current = _currentQuery ?? const CatalogQuery();
    return load(query: current.copyWith(sort: sort));
  }

  /// Menghapus seluruh filter dan kembali ke listing default.
  Future<void> clearFilters() => load(query: const CatalogQuery());

  /// Memuat ulang permintaan terakhir — untuk tombol "coba lagi" dan
  /// pull-to-refresh.
  Future<void> retry() => load(query: _currentQuery);

  /// Menambah halaman berikutnya ke daftar yang sudah tampil.
  ///
  /// Aman dipanggil berulang: permintaan diabaikan kalau tidak ada halaman
  /// lagi, atau kalau satu permintaan tambah-halaman sedang berjalan —
  /// listener scroll biasanya memicu ini beberapa kali beruntun.
  Future<void> loadMore() async {
    final current = state;
    if (current is! CatalogLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final nextPage = current.page + 1;
    final query = current.query;
    final result = await _repository.fetchProducts(
      query: query?.text,
      categoryId: query?.categoryId,
      minRating: query?.minRating,
      minPrice: query?.minPrice,
      maxPrice: query?.maxPrice,
      sort: query?.sort ?? ProductSort.latest,
      page: nextPage,
      perPage: pageSize,
    );

    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data, :final meta):
        final merged = [...current.products, ...data];
        emit(current.copyWith(
          products: merged,
          page: nextPage,
          hasMore: _hasMore(meta, merged.length),
          isLoadingMore: false,
        ));
      case DataEmpty():
        // Halaman berikutnya ternyata kosong — berarti sudah habis.
        emit(current.copyWith(hasMore: false, isLoadingMore: false));
      case DataFailed(:final error):
        // Daftar yang sudah tampil dipertahankan; hanya kaki daftar yang
        // menandakan gagal, supaya user tidak kehilangan posisi gulir.
        emit(current.copyWith(isLoadingMore: false, loadMoreError: error));
      case DataLoading():
        break;
    }
  }

  CatalogQuery? get _currentQuery => switch (state) {
        CatalogLoaded(:final query) => query,
        CatalogEmpty(:final query) => query,
        _ => null,
      };

  CatalogHomeState _toState(
    DataState<List<ProductModel>> result, {
    required CatalogQuery? query,
    required int page,
  }) {
    return switch (result) {
      DataSuccess(:final data, :final meta) => CatalogHomeState.loaded(
          products: data,
          categories: _categories,
          facets: ProductFacets.fromMeta(meta),
          page: page,
          hasMore: _hasMore(meta, data.length),
          query: query,
        ),
      DataEmpty() => CatalogHomeState.empty(
          categories: _categories,
          query: query,
        ),
      DataFailed(:final error) => CatalogHomeState.error(error),
      DataLoading() => const CatalogHomeState.loading(),
    };
  }

  /// Menghitung apakah masih ada halaman berikutnya dari `meta.total`.
  ///
  /// Kalau `total` tidak dikirim, dianggap habis — lebih baik kehilangan satu
  /// halaman daripada menembak permintaan tanpa akhir.
  bool _hasMore(Map<String, dynamic> meta, int loadedCount) {
    final total = asInt(meta['total'], fallback: -1);
    if (total < 0) return false;
    return loadedCount < total;
  }
}
