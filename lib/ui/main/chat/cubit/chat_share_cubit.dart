import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/chat/chat_room_context.dart';

part 'chat_share_cubit.freezed.dart';
part 'chat_share_state.dart';

/// Segala yang dibutuhkan ruang chat untuk **berbagi** produk & pesanan:
///
/// * kartu "Tanyakan produk ini" yang disematkan bila ruang dibuka dari
///   halaman produk ([ChatRoomContext.productId]);
/// * isi kartu gelembung `product_share` / `order_share` — pesan hanya
///   membawa `shared_product_id` / `shared_order_id`, jadi nama, harga,
///   gambar, dan status harus diambil sendiri;
/// * daftar pesanan pembeli **dari toko ini** untuk laci lampiran.
///
/// Dipisah dari `ChatRoomCubit` karena siklusnya berbeda: ruang chat
/// menyegarkan diri tiap lima detik, sedangkan isi kartu cukup diambil sekali
/// per id dan disimpan.
class ChatShareCubit extends Cubit<ChatShareState> {
  ChatShareCubit(this.conversationId, {ChatRoomContext? context})
      : super(ChatShareState(
          storeId: context?.storeId,
          pinnedProductId: context?.productId,
        ));

  static ChatShareCubit get(BuildContext context) => BlocProvider.of(context);

  final int conversationId;

  /// Berapa halaman `GET /orders` yang disisir untuk laci lampiran.
  ///
  /// `GET /orders` tidak bisa disaring per toko (hanya membaca `page`), jadi
  /// penyaringan dilakukan di sini. Tiga halaman = 60 pesanan terbaru —
  /// cukup untuk "pesanan yang sedang ditanyakan", tanpa menyisir seluruh
  /// riwayat di server single-threaded.
  static const int maxOrderPages = 3;

  final Set<int> _productsInFlight = {};
  final Set<int> _ordersInFlight = {};

  /// Memuat kartu produk yang disematkan, kalau ada.
  void start() {
    final pinned = state.pinnedProductId;
    if (pinned != null) unawaited(ensureProduct(pinned));
  }

  void dismissPinned() => emit(state.copyWith(pinnedDismissed: true));

  Future<void> ensureProduct(int id) async {
    if (state.products.containsKey(id) ||
        state.failedProductIds.contains(id) ||
        !_productsInFlight.add(id)) {
      return;
    }
    // `fetchProduct` di-cache per id oleh CatalogService, jadi gelembung yang
    // membagikan produk yang sama tidak menembak ulang.
    final result = await injector<CatalogRepository>().fetchProduct(id);
    _productsInFlight.remove(id);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => state.copyWith(products: {...state.products, id: data}),
      _ => state.copyWith(failedProductIds: {...state.failedProductIds, id}),
    });
  }

  /// Pesanan yang dibagikan **penjual** bisa bukan milik pembeli ini
  /// (`403 PERMISSION_DENIED`) — kartunya jatuh ke nomor id saja.
  Future<void> ensureOrder(int id) async {
    if (state.orders.containsKey(id) ||
        state.failedOrderIds.contains(id) ||
        !_ordersInFlight.add(id)) {
      return;
    }
    final result = await injector<OrderRepository>().fetchOrder(id);
    _ordersInFlight.remove(id);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => state.copyWith(orders: {...state.orders, id: data}),
      _ => state.copyWith(failedOrderIds: {...state.failedOrderIds, id}),
    });
  }

  /// Memuat pesanan pembeli dari toko percakapan ini untuk laci lampiran.
  Future<void> loadOrderPicker() async {
    if (state.pickerStatus == ChatPickerStatus.loading) return;
    emit(state.copyWith(pickerStatus: ChatPickerStatus.loading, pickerError: null));

    final storeId = state.storeId ?? await _resolveStoreId();
    if (isClosed) return;
    if (storeId == null) {
      emit(state.copyWith(
        pickerStatus: ChatPickerStatus.error,
        pickerError: const DataError(
          code: ApiErrorCode.notFound,
          message: 'Percakapan tidak ditemukan',
          kind: DataErrorKind.api,
        ),
      ));
      return;
    }

    final repository = injector<OrderRepository>();
    final found = <OrderModel>[];
    for (var page = 1; page <= maxOrderPages; page++) {
      final result = await repository.fetchOrders(page: page);
      if (isClosed) return;
      switch (result) {
        case DataSuccess(:final data):
          found.addAll(data.where((o) => o.storeId == storeId));
          // Halaman tidak penuh = halaman terakhir (server tidak mengirim
          // `meta`, lihat OrderService).
          if (data.length < OrderService.serverPageSize) page = maxOrderPages;
        case DataEmpty():
          page = maxOrderPages;
        case DataFailed(:final error):
          if (found.isEmpty) {
            emit(state.copyWith(
              storeId: storeId,
              pickerStatus: ChatPickerStatus.error,
              pickerError: error,
            ));
            return;
          }
          page = maxOrderPages;
        case DataLoading():
          break;
      }
    }
    emit(state.copyWith(
      storeId: storeId,
      pickerStatus: ChatPickerStatus.ready,
      pickerOrders: found,
      orders: {...state.orders, for (final o in found) o.id: o},
    ));
  }

  /// Ruang yang dibuka dari daftar percakapan (atau refresh web) tidak
  /// membawa `store_id`; satu-satunya sumbernya daftar percakapan.
  Future<int?> _resolveStoreId() async {
    final result = await injector<ChatRepository>().fetchConversations();
    if (result case DataSuccess(:final data)) {
      for (final c in data) {
        if (c.id == conversationId && c.storeId > 0) return c.storeId;
      }
    }
    return null;
  }
}
