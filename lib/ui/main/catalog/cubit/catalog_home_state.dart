part of 'catalog_home_cubit.dart';

/// Status layar katalog (home + pencarian + filter kategori).
///
/// Union `freezed`, bukan marker state: daftar produk, kategori, facet, dan
/// posisi paginasi semuanya bagian dari status itu sendiri.
///
/// [CatalogLoaded] sengaja membawa **semuanya sekaligus**, termasuk
/// [CatalogLoaded.isLoadingMore]. Alternatifnya — memancarkan `loading()` saat
/// memuat halaman berikutnya — akan mengosongkan layar yang sedang dibaca user
/// setiap kali ia menggulir ke bawah.
@freezed
sealed class CatalogHomeState with _$CatalogHomeState {
  const factory CatalogHomeState.initial() = CatalogInitial;

  /// Pemuatan pertama, layar masih kosong.
  const factory CatalogHomeState.loading() = CatalogLoading;

  const factory CatalogHomeState.loaded({
    required List<ProductModel> products,

    /// Pohon kategori. Bisa kosong kalau `GET /categories` gagal sementara
    /// produk berhasil dimuat — kegagalan salah satunya tidak boleh
    /// mengosongkan seluruh layar.
    @Default(<CategoryModel>[]) List<CategoryModel> categories,
    @Default(ProductFacets.empty) ProductFacets facets,
    @Default(1) int page,

    /// Masih ada halaman berikutnya, dihitung dari `meta.total`.
    @Default(false) bool hasMore,

    /// `meta.total` apa adanya — jumlah produk yang cocok, untuk label
    /// "1.238 produk" di hasil pencarian. `null` kalau server tidak
    /// mengirimnya.
    int? total,

    /// Sedang menambah halaman berikutnya di bawah daftar yang sudah tampil.
    @Default(false) bool isLoadingMore,

    /// Gagal memuat halaman berikutnya. Daftar yang sudah ada tetap tampil;
    /// layar cukup menampilkan tombol "coba lagi" di kaki daftar.
    DataError? loadMoreError,
    CatalogQuery? query,
  }) = CatalogLoaded;

  /// Permintaan berhasil tapi tidak ada produk yang cocok.
  ///
  /// Dibedakan dari [CatalogError] supaya layar bisa menawarkan "hapus filter"
  /// alih-alih "coba lagi" — dua jalan keluar yang berbeda.
  const factory CatalogHomeState.empty({
    @Default(<CategoryModel>[]) List<CategoryModel> categories,
    CatalogQuery? query,
  }) = CatalogEmpty;

  const factory CatalogHomeState.error(DataError error) = CatalogError;
}

/// Kumpulan filter yang sedang aktif.
///
/// Disimpan sebagai satu objek supaya memuat halaman berikutnya tidak perlu
/// mengoper ulang delapan argumen — dan supaya "ulangi permintaan terakhir"
/// setelah gagal benar-benar mengulang permintaan yang sama.
@freezed
abstract class CatalogQuery with _$CatalogQuery {
  const CatalogQuery._();

  const factory CatalogQuery({
    String? text,
    int? categoryId,
    int? minRating,
    double? minPrice,
    double? maxPrice,

    /// Urutan bawaan `recommended`: blueprint melarang kontrol urutan di sisi
    /// pembeli, jadi peringkat sepenuhnya milik server.
    @Default(ProductSort.recommended) ProductSort sort,

    /// Tujuan kirim (kota/provinsi alamat utama). Server membuang produk yang
    /// tidak bisa dikirim ke sana, jadi hasil yang tampil memang bisa dibeli.
    String? destCity,
    String? destProvince,
  }) = _CatalogQuery;

  /// Ada filter aktif selain urutan default.
  bool get hasFilter =>
      (text != null && text!.trim().isNotEmpty) ||
      categoryId != null ||
      minRating != null ||
      minPrice != null ||
      maxPrice != null;

  bool get isSearching => text != null && text!.trim().isNotEmpty;
}
