import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';

/// Panggilan HTTP untuk `/wishlist*`.
///
/// Perilaku server yang membentuk lapisan ini:
///
/// * `POST /wishlist/items` membalas `201` dengan **`data: null`** — tidak ada
///   id yang dikembalikan, jadi pemanggil harus membaca ulang daftarnya.
/// * Menambahkan produk yang **sudah ada tidak menggandakan** barisnya; tetap
///   dibalas `201`. Jadi tombol "simpan" aman ditekan berkali-kali.
/// * `DELETE` untuk produk yang tidak ada di wishlist tetap dibalas `200`.
///
/// Satu-satunya validasi sungguhan: produk yang tidak ada dibalas
/// `404 PRODUCT_NOT_FOUND`.
class WishlistService {
  WishlistService(this._dio);

  final Dio _dio;

  Future<ApiEnvelope<List<WishlistItemModel>>> fetch() async {
    const context = 'GET /wishlist';
    try {
      final response = await _dio.get<dynamic>('/wishlist');
      return parseEnvelopeList(response, WishlistItemModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<dynamic>> add(int productId) async {
    const context = 'POST /wishlist/items';
    try {
      final response = await _dio.post<dynamic>(
        '/wishlist/items',
        data: {'product_id': productId},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `DELETE /wishlist/items/{productId}`.
  ///
  /// ⚠️ **Parameternya id PRODUK, bukan `wishlist_item_id`.** Sudah diuji
  /// dengan keduanya sengaja berbeda: menghapus `3` membuang baris ber-
  /// `product_id: 3` (yang `wishlist_item_id`-nya 2). Mengirim
  /// `wishlist_item_id` akan membuang produk yang salah — dan tetap dibalas
  /// `200`, jadi kesalahannya tidak terlihat.
  Future<ApiEnvelope<dynamic>> remove(int productId) async {
    final context = 'DELETE /wishlist/items/$productId';
    try {
      final response = await _dio.delete<dynamic>('/wishlist/items/$productId');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
