import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

/// Panggilan HTTP untuk `/cart*`.
///
/// **Tiga perilaku server yang membentuk seluruh desain lapisan ini**, semuanya
/// sudah diuji langsung:
///
/// 1. `PATCH` dan `DELETE` membalas `data: null`. Tidak ada keranjang hasil
///    perubahan yang bisa dipakai, jadi pemanggil **wajib membaca ulang**
///    [fetchCart]. Repository yang melakukannya, bukan layar.
/// 2. Mutasi terhadap baris yang **tidak ada pun dibalas `200`** — `PATCH`
///    maupun `DELETE` ke `/cart/items/999` sukses tanpa efek. Jadi status
///    sukses **bukan bukti** sesuatu berubah; hanya hasil baca ulang yang
///    membuktikannya.
/// 3. `POST /cart/items` dengan varian yang sudah ada **menggabungkan**
///    kuantitas ke baris lama dan mengembalikan id baris itu — bukan membuat
///    baris baru. Id balasannya kadang number, kadang string.
///
/// ⚠️ **Tidak ada validasi kuantitas sama sekali di server.** `quantity: 99999`
/// untuk varian berstok 150 dibalas `200` dan tersimpan apa adanya; `0` juga
/// diterima. Pembatasan terhadap stok adalah tanggung jawab aplikasi —
/// lihat `CartCubit`.
class CartService {
  CartService(this._dio);

  final Dio _dio;

  /// `GET /cart` — daftar grup per toko.
  Future<ApiEnvelope<List<CartStoreGroup>>> fetchCart() async {
    const context = 'GET /cart';
    try {
      final response = await _dio.get<dynamic>('/cart');
      return parseEnvelopeList(response, CartStoreGroup.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /cart/summary` — subtotal dan jumlah baris **terpilih**.
  Future<ApiEnvelope<CartSummaryModel>> fetchSummary() async {
    const context = 'GET /cart/summary';
    try {
      final response = await _dio.get<dynamic>('/cart/summary');
      return parseEnvelope(
        response,
        (raw) => raw == null
            ? const CartSummaryModel()
            : CartSummaryModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /cart/items` — menambah varian ke keranjang.
  ///
  /// Mengembalikan id baris keranjang. Kalau varian sudah ada di keranjang,
  /// yang dikembalikan adalah id baris **lama** yang kuantitasnya bertambah.
  ///
  /// Varian yang tidak ada dibalas `404 VARIANT_NOT_FOUND` — ini satu-satunya
  /// validasi yang benar-benar dilakukan endpoint ini.
  Future<ApiEnvelope<int>> addItem({
    required int productVariantId,
    required int quantity,
  }) async {
    const context = 'POST /cart/items';
    try {
      final response = await _dio.post<dynamic>(
        '/cart/items',
        data: {
          'product_variant_id': productVariantId,
          'quantity': quantity,
        },
      );
      return parseEnvelope(
        response,
        // `id` kadang number kadang string, tergantung baris baru atau
        // digabung ke yang lama.
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `PATCH /cart/items/{id}` — ubah kuantitas dan/atau centang.
  ///
  /// Balasannya `data: null`; pemanggil harus membaca ulang keranjang.
  Future<ApiEnvelope<dynamic>> updateItem(
    int itemId, {
    int? quantity,
    bool? isSelected,
  }) async {
    final context = 'PATCH /cart/items/$itemId';
    try {
      final response = await _dio.patch<dynamic>(
        '/cart/items/$itemId',
        data: {
          if (quantity != null) 'quantity': quantity,
          // Server memakai tinyint; kirim 1/0, bukan true/false.
          if (isSelected != null) 'is_selected': isSelected ? 1 : 0,
        },
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `DELETE /cart/items/{id}`.
  ///
  /// Id yang tidak ada juga dibalas `200`, jadi sukses di sini tidak menjamin
  /// ada yang terhapus.
  Future<ApiEnvelope<dynamic>> removeItem(int itemId) async {
    final context = 'DELETE /cart/items/$itemId';
    try {
      final response = await _dio.delete<dynamic>('/cart/items/$itemId');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /cart/apply-voucher` — pratinjau diskon untuk keranjang.
  ///
  /// Kode yang tidak berlaku dibalas `422 VOUCHER_INVALID`.
  ///
  /// ⚠️ **Tidak ada endpoint untuk melepas voucher.** `docs/03` menyebut
  /// `DELETE /cart/vouchers/{code}`, tapi rute itu tidak terdaftar. Jangan
  /// menyediakan tombol "lepas voucher" yang tidak punya endpoint.
  Future<ApiEnvelope<dynamic>> applyVoucher(String code) async {
    const context = 'POST /cart/apply-voucher';
    try {
      final response = await _dio.post<dynamic>(
        '/cart/apply-voucher',
        data: {'code': code},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
