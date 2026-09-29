import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'order_list_cubit.freezed.dart';
part 'order_list_state.dart';

/// Daftar pesanan pembeli, dengan paginasi.
///
/// ⚠️ **Paginasinya disimpulkan, bukan dibaca.** `GET /orders` tidak mengirim
/// `meta` — tidak ada `total` — dan ukuran halamannya dipatok server. Jadi
/// cubit ini menganggap masih ada halaman berikutnya selama halaman terakhir
/// kembali **terisi penuh** ([OrderService.serverPageSize]). Konsekuensinya:
/// kalau jumlah pesanan kebetulan kelipatan ukuran halaman, akan ada satu
/// permintaan tambahan yang kembali kosong. Itu disengaja — lebih baik satu
/// request sia-sia daripada diam-diam menyembunyikan pesanan.
///
/// ⚠️ **Tab status disaring di aplikasi** karena server mengabaikan
/// `?status=`. Penyaringan sisi klien hanya berlaku pada halaman yang sudah
/// dimuat, sehingga tab yang jarang terisi (mis. "Dibatalkan") bisa tampak
/// kosong padahal pesanannya ada di halaman 3. Karena itu, selama sebuah tab
/// aktif, cubit **terus memuat halaman berikutnya** sampai hasil tersaring
/// mencapai [filterTarget] baris, halaman habis, atau [maxAutoPages] halaman
/// sudah dimuat dalam satu putaran — batas terakhir itu mencegah akun dengan
/// ratusan pesanan menembak puluhan request hanya karena satu tab disentuh.
/// Sisanya diserahkan ke tombol "Muat lebih banyak" ([showMore]).
///
/// Jumlah per tab sengaja **tidak** ditampilkan: tanpa `total` dari server,
/// angkanya hanya batas bawah dari halaman yang kebetulan sudah dimuat.
class OrderListCubit extends Cubit<OrderListState> {
  OrderListCubit()
      : _repository = injector<OrderRepository>(),
        super(const OrderListState.loading());

  static OrderListCubit get(BuildContext context) => BlocProvider.of(context);

  final OrderRepository _repository;

  /// Jumlah baris tersaring yang dikejar pemuatan otomatis.
  static const filterTarget = 10;

  /// Batas halaman yang dimuat otomatis dalam satu putaran penyaringan.
  static const maxAutoPages = 5;

  /// Tab aktif. Disimpan di luar state supaya bertahan melewati `loading`
  /// saat ditarik untuk refresh.
  OrderListFilter _filter = OrderListFilter.all;
  OrderListFilter get filter => _filter;

  bool _filling = false;

  Future<void> load() async {
    emit(const OrderListState.loading());
    final result = await _repository.fetchOrders(page: 1);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(OrderListState.loaded(
          orders: data,
          hasMore: data.length >= OrderService.serverPageSize,
          filter: _filter,
        ));
        await _fill(filterTarget);
      case DataEmpty():
        emit(const OrderListState.empty());
      case DataFailed(:final error):
        emit(OrderListState.error(error));
      case DataLoading():
        break;
    }
  }

  Future<void> refresh() => load();

  /// Mengganti tab, lalu memuat halaman tambahan bila hasilnya masih tipis.
  Future<void> setFilter(OrderListFilter filter) async {
    if (filter == _filter) return;
    _filter = filter;
    final current = state;
    if (current is! OrderListLoaded) {
      // Memancarkan ulang supaya tab ikut tergambar ulang.
      emit(current);
      return;
    }
    emit(current.copyWith(filter: filter));
    await _fill(filterTarget);
  }

  /// Tombol "Muat lebih banyak". Di tab "Semua" cukup satu halaman; di tab
  /// lain satu halaman bisa saja tidak menambah satu baris pun, jadi yang
  /// dikejar adalah [filterTarget] baris **baru**.
  Future<void> showMore() async {
    final current = state;
    if (current is! OrderListLoaded) return;
    if (current.filter == OrderListFilter.all) return loadMore();
    final before = current.visibleOrders.length;
    await loadMore();
    await _fill(before + filterTarget);
  }

  /// Memuat halaman berikutnya selama tab aktif belum punya [target] baris.
  Future<void> _fill(int target) async {
    if (_filling) return;
    _filling = true;
    try {
      var fetched = 0;
      while (!isClosed && fetched < maxAutoPages) {
        final current = state;
        if (current is! OrderListLoaded) return;
        if (current.filter == OrderListFilter.all) return;
        if (!current.hasMore || current.isLoadingMore || current.loadMoreError != null) return;
        if (current.visibleOrders.length >= target) return;
        await loadMore();
        fetched++;
      }
    } finally {
      _filling = false;
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! OrderListLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final nextPage = current.page + 1;
    final result = await _repository.fetchOrders(page: nextPage);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(current.copyWith(
          orders: [...current.orders, ...data],
          page: nextPage,
          hasMore: data.length >= OrderService.serverPageSize,
          isLoadingMore: false,
        ));
      case DataEmpty():
        emit(current.copyWith(hasMore: false, isLoadingMore: false));
      case DataFailed(:final error):
        emit(current.copyWith(isLoadingMore: false, loadMoreError: error));
      case DataLoading():
        break;
    }
  }
}
