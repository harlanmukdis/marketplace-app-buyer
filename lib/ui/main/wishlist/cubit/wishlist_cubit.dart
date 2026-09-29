import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/wishlist_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'wishlist_cubit.freezed.dart';
part 'wishlist_state.dart';

/// Wishlist pembeli.
///
/// **Satu instance untuk seluruh app**, disediakan `AppScope` di atas router:
/// hati di kartu beranda, pencarian, detail produk, dan layar wishlist harus
/// menunjukkan keadaan yang sama. Dulu tiap layar memegang instance sendiri,
/// sehingga produk yang disimpan di detail belum tampil tersimpan di beranda.
/// [toggle] tetap membaca ulang dari server sesudah mutasi.
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit()
      : _repository = injector<WishlistRepository>(),
        super(const WishlistState.loading());

  static WishlistCubit get(BuildContext context) => BlocProvider.of(context);

  final WishlistRepository _repository;

  Future<void> load() async {
    emit(const WishlistState.loading());
    final result = await _repository.fetch();
    if (isClosed) return;
    _apply(result);
  }

  /// Menambah atau membuang produk, tergantung isinya sekarang.
  Future<void> toggle(int productId) async {
    final current = state;
    if (current is! WishlistReady) return;
    if (current.mutatingProductIds.contains(productId)) return;

    final wasSaved = current.contains(productId);
    emit(current.copyWith(
      mutatingProductIds: {...current.mutatingProductIds, productId},
      actionError: null,
    ));

    final result = wasSaved
        ? await _repository.remove(productId)
        : await _repository.add(productId);
    if (isClosed) return;
    _apply(result, previous: current, mutatedId: productId);
  }

  Future<void> remove(int productId) async {
    final current = state;
    if (current is! WishlistReady) return;
    if (current.mutatingProductIds.contains(productId)) return;

    emit(current.copyWith(
      mutatingProductIds: {...current.mutatingProductIds, productId},
      actionError: null,
    ));
    final result = await _repository.remove(productId);
    if (isClosed) return;
    _apply(result, previous: current, mutatedId: productId);
  }

  /// Menyalakan/mematikan pantau harga & stok satu produk (docs/22 #13).
  ///
  /// 🔶 Endpoint usulan (`PATCH /wishlist/items/{product_id}`), mock di debug.
  /// Mengembalikan keadaan baru hasil baca ulang, atau `null` kalau gagal —
  /// layar memakainya untuk memilih toast yang benar.
  Future<bool?> setAlert(int productId, {required bool enabled}) async {
    final current = state;
    if (current is! WishlistReady) return null;
    if (current.alertMutatingIds.contains(productId)) return null;

    emit(current.copyWith(
      alertMutatingIds: {...current.alertMutatingIds, productId},
      actionError: null,
    ));
    final result = await _repository.setAlert(productId, enabled: enabled);
    if (isClosed) return null;

    final latest = state is WishlistReady ? state as WishlistReady : current;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        emit(latest.copyWith(
          items: data,
          meta: meta,
          alertMutatingIds: {...latest.alertMutatingIds}..remove(productId),
        ));
        return data.where((i) => i.productId == productId).firstOrNull?.isWatched;
      case DataFailed(:final error):
        emit(latest.copyWith(
          alertMutatingIds: {...latest.alertMutatingIds}..remove(productId),
          actionError: error,
        ));
        return null;
      case DataEmpty(:final meta):
        emit(latest.copyWith(
          items: const [],
          meta: meta,
          alertMutatingIds: {...latest.alertMutatingIds}..remove(productId),
        ));
        return null;
      case DataLoading():
        return null;
    }
  }

  void clearActionError() {
    final current = state;
    if (current is! WishlistReady || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  void _apply(
    DataState<List<WishlistItemModel>> result, {
    WishlistReady? previous,
    int? mutatedId,
  }) {
    switch (result) {
      case DataSuccess(:final data, :final meta):
        emit(WishlistState.ready(items: data, meta: meta));
      case DataEmpty(:final meta):
        emit(WishlistState.ready(meta: meta));
      case DataFailed(:final error):
        if (previous != null) {
          // Gagal menyimpan tidak boleh mengosongkan daftar yang sudah tampil.
          emit(previous.copyWith(
            mutatingProductIds: <int>{...previous.mutatingProductIds}
              ..remove(mutatedId),
            actionError: error,
          ));
        } else {
          emit(WishlistState.error(error));
        }
      case DataLoading():
        break;
    }
  }
}
