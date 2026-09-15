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
/// Dipakai dua tempat: layar wishlist sendiri, dan tombol hati di halaman
/// detail produk. Keduanya memakai instance masing-masing — tidak ada provider
/// global di repo ini — jadi [toggle] selalu membaca ulang dari server
/// daripada mengandalkan keadaan layar lain.
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
      case DataSuccess(:final data):
        emit(WishlistState.ready(items: data));
      case DataEmpty():
        emit(const WishlistState.ready());
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
