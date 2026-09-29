import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'store_profile_cubit.freezed.dart';
part 'store_profile_state.dart';

/// Profil toko + transparansi kinerjanya, untuk storefront dan kartu toko di
/// halaman produk.
///
/// Dua endpoint ditembak bersamaan: `GET /stores/{id}` dan
/// `GET /stores/{id}/partners-performance`. Hanya yang pertama yang fatal —
/// storefront tanpa baris metrik masih berguna, sama seperti layar reward
/// yang tidak gagal karena satu endpoint sampingan.
///
/// Rating yang ditampilkan diambil dari **performance**, bukan
/// `StoreModel.ratingAvg`: kolom itu diisi form rating toko terpisah,
/// sedangkan blueprint menuntut rata-rata ulasan produk (docs/22 #7).
class StoreProfileCubit extends Cubit<StoreProfileState> {
  StoreProfileCubit(this.storeId)
      : _repository = injector<StoreRepository>(),
        super(const StoreProfileState.loading());

  static StoreProfileCubit get(BuildContext context) => BlocProvider.of(context);

  final int storeId;
  final StoreRepository _repository;

  Future<void> load() async {
    emit(const StoreProfileState.loading());
    // Di-await terpisah supaya kegagalan salah satunya tidak jadi unhandled
    // async error selagi yang lain masih ditunggu.
    final storeFuture = _repository.fetchStore(storeId);
    final performanceFuture = _repository.fetchPerformance(storeId);
    final store = await storeFuture;
    final performance = await performanceFuture;
    if (isClosed) return;

    switch (store) {
      case DataSuccess(:final data):
        emit(StoreProfileState.loaded(
          store: data,
          performance: performance is DataSuccess<StorePerformanceModel>
              ? performance.data
              : null,
          performanceMeta: performance is DataSuccess<StorePerformanceModel>
              ? performance.meta
              : const {},
        ));
      case DataFailed(:final error):
        emit(StoreProfileState.error(error));
      case DataEmpty() || DataLoading():
        emit(const StoreProfileState.error(DataError(
          code: ApiErrorCode.notFound,
          message: 'Toko tidak ditemukan',
          kind: DataErrorKind.api,
        )));
    }
  }

  /// Mengikuti atau berhenti mengikuti, tergantung keadaan sekarang.
  ///
  /// ⚠️ `POST /stores/{id}/follow` **tidak idempoten** — mengikuti toko yang
  /// sudah diikuti dibalas `422`. Karena itu arahnya selalu diturunkan dari
  /// `is_following` hasil baca server terakhir, dan ketukan kedua selagi
  /// yang pertama berjalan diabaikan.
  Future<void> toggleFollow() async {
    final current = state;
    if (current is! StoreProfileLoaded || current.isFollowBusy) return;

    emit(current.copyWith(isFollowBusy: true, actionError: null));
    final result = await _repository.setFollowing(
      storeId,
      follow: !current.store.isFollowing,
    );
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(current.copyWith(store: data, isFollowBusy: false));
      case DataFailed(:final error):
        emit(current.copyWith(isFollowBusy: false, actionError: error));
      case DataEmpty() || DataLoading():
        emit(current.copyWith(isFollowBusy: false));
    }
  }

  void clearActionError() {
    final current = state;
    if (current is StoreProfileLoaded && current.actionError != null) {
      emit(current.copyWith(actionError: null));
    }
  }
}
