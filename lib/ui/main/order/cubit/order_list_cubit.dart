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
/// ⚠️ **Tidak ada penyaringan status**, karena server mengabaikannya. Menyaring
/// di sisi klien juga salah: penyaringan hanya akan berlaku pada halaman yang
/// sudah dimuat, sehingga pesanan di halaman berikutnya seolah hilang.
class OrderListCubit extends Cubit<OrderListState> {
  OrderListCubit()
      : _repository = injector<OrderRepository>(),
        super(const OrderListState.loading());

  static OrderListCubit get(BuildContext context) => BlocProvider.of(context);

  final OrderRepository _repository;

  Future<void> load() async {
    emit(const OrderListState.loading());
    final result = await _repository.fetchOrders(page: 1);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(OrderListState.loaded(
          orders: data,
          hasMore: data.length >= OrderService.serverPageSize,
        ));
      case DataEmpty():
        emit(const OrderListState.empty());
      case DataFailed(:final error):
        emit(OrderListState.error(error));
      case DataLoading():
        break;
    }
  }

  Future<void> refresh() => load();

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
