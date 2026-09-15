import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wishlist_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl(this._service);

  final WishlistService _service;

  @override
  Future<DataState<List<WishlistItemModel>>> fetch() => _readBack();

  @override
  Future<DataState<List<WishlistItemModel>>> add(int productId) =>
      _mutateThenRead(() => _service.add(productId));

  @override
  Future<DataState<List<WishlistItemModel>>> remove(int productId) =>
      _mutateThenRead(() => _service.remove(productId));

  Future<DataState<List<WishlistItemModel>>> _mutateThenRead(
    Future<Object?> Function() mutate,
  ) async {
    try {
      await mutate();
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return _readBack();
  }

  Future<DataState<List<WishlistItemModel>>> _readBack() async {
    try {
      final env = await _service.fetch();
      // Wishlist kosong dikembalikan sebagai DataSuccess berisi list kosong,
      // bukan DataEmpty: layarnya menampilkan ajakan menjelajah, bukan
      // keadaan kosong yang perlu dibedakan dari gagal.
      return DataSuccess(env.data, meta: env.meta, statusCode: env.statusCode);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
  }
}
