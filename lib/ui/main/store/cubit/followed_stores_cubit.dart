import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/store_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'followed_stores_cubit.freezed.dart';
part 'followed_stores_state.dart';

/// Toko yang diikuti pembeli: `GET /me/following`.
///
/// Responsnya **tanpa `meta`** dan ukuran halamannya dipatok server
/// ([StoreService.followingPageSize]), jadi adanya halaman berikutnya
/// disimpulkan dari "halaman terakhir terisi penuh" — pola yang sama dengan
/// `/orders` dan notifikasi.
class FollowedStoresCubit extends Cubit<FollowedStoresState> {
  FollowedStoresCubit()
      : _repository = injector<StoreRepository>(),
        super(const FollowedStoresState.loading());

  static FollowedStoresCubit get(BuildContext context) => BlocProvider.of(context);

  final StoreRepository _repository;

  static int get pageSize => StoreService.followingPageSize;

  Future<void> load() async {
    emit(const FollowedStoresState.loading());
    final result = await _repository.fetchFollowing(page: 1);
    if (isClosed) return;
    switch (result) {
      case DataSuccess(:final data):
        emit(FollowedStoresState.loaded(
          stores: data,
          hasMore: data.length >= pageSize,
        ));
      case DataEmpty():
        emit(const FollowedStoresState.loaded(stores: []));
      case DataFailed(:final error):
        emit(FollowedStoresState.error(error));
      case DataLoading():
        break;
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! FollowedStoresLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));
    final next = current.page + 1;
    final result = await _repository.fetchFollowing(page: next);
    if (isClosed) return;
    final latest = state is FollowedStoresLoaded ? state as FollowedStoresLoaded : current;

    switch (result) {
      case DataSuccess(:final data):
        // Baris yang sudah ada dibuang dari halaman baru: berhenti mengikuti
        // di tengah jalan menggeser OFFSET, sehingga satu toko bisa muncul
        // di dua halaman.
        final known = {for (final s in latest.stores) s.id};
        emit(latest.copyWith(
          stores: [...latest.stores, ...data.where((s) => !known.contains(s.id))],
          page: next,
          hasMore: data.length >= pageSize,
          isLoadingMore: false,
        ));
      case DataEmpty():
        emit(latest.copyWith(hasMore: false, isLoadingMore: false));
      case DataFailed(:final error):
        emit(latest.copyWith(isLoadingMore: false, loadMoreError: error));
      case DataLoading():
        break;
    }
  }

  /// Berhenti mengikuti lalu membuang barisnya.
  ///
  /// `DELETE /stores/{id}/follow` dibalas `200` walau belum mengikuti, jadi
  /// ketukan ganda tidak berbahaya — tetap diabaikan supaya tidak menembak
  /// dua kali. Mengembalikan toko hasil baca ulang supaya layar bisa
  /// memperbarui `StoreDirectoryCubit`.
  Future<StoreModel?> unfollow(int storeId) async {
    final current = state;
    if (current is! FollowedStoresLoaded) return null;
    if (current.mutatingIds.contains(storeId)) return null;

    emit(current.copyWith(
      mutatingIds: {...current.mutatingIds, storeId},
      actionError: null,
    ));
    final result = await _repository.setFollowing(storeId, follow: false);
    if (isClosed) return null;
    final latest = state is FollowedStoresLoaded ? state as FollowedStoresLoaded : current;
    final ids = <int>{...latest.mutatingIds}..remove(storeId);

    switch (result) {
      case DataSuccess(:final data):
        emit(latest.copyWith(
          stores: latest.stores.where((s) => s.id != storeId).toList(),
          mutatingIds: ids,
        ));
        return data;
      case DataFailed(:final error):
        emit(latest.copyWith(mutatingIds: ids, actionError: error));
      case DataEmpty() || DataLoading():
        emit(latest.copyWith(mutatingIds: ids));
    }
    return null;
  }

  void clearActionError() {
    final current = state;
    if (current is FollowedStoresLoaded && current.actionError != null) {
      emit(current.copyWith(actionError: null));
    }
  }
}
