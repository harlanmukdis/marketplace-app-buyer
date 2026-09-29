import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';

/// Panggilan HTTP untuk `/checkout/sessions*`.
///
/// **Id sesi adalah UUID string**, bukan integer — rutenya `(:any)`.
///
/// ✅ **`PATCH /checkout/sessions/{id}/address` sudah diperbaiki backend**
/// (commit `8235c33`, dan kepemilikan alamat divalidasi di `28adce7`).
///
/// Dulu endpoint ini selalu membalas 500: controllernya membaca body dengan
/// `$this->post('address_id')` pada rute PATCH, sehingga nilainya selalu
/// `null` dan server menjalankan `UPDATE … SET shipping_address_id = NULL`
/// yang ditolak foreign key. Karena itu aplikasi dulu mengganti alamat dengan
/// **membatalkan sesi lalu membuat sesi baru** — cara yang bekerja tapi
/// melepas lalu mengambil ulang reservasi stok, sehingga user bisa kehilangan
/// barangnya ke pembeli lain hanya karena salah pilih alamat.
///
/// Sekarang [changeAddress] mengubahnya **di tempat**: diuji ke server,
/// `shipping_address_id` benar-benar berubah dan statusnya tetap
/// `stock_reserved`.
///
/// ⚠️ **`Idempotency-Key` belum diimplementasikan backend**, jadi mengulang
/// [confirm] secara otomatis berisiko menggandakan order. Jangan pasang retry
/// pada endpoint ini.
class CheckoutService {
  CheckoutService(this._dio);

  final Dio _dio;

  /// `POST /checkout/sessions` — membuat sesi dari **baris keranjang yang
  /// tercentang**, sekaligus mereservasi stok selama 15 menit.
  ///
  Future<ApiEnvelope<CheckoutSessionCreated>> createSession({
    required int addressId,
    String? voucherCode,
  }) async {
    const context = 'POST /checkout/sessions';
    try {
      final response = await _dio.post<dynamic>(
        '/checkout/sessions',
        data: {
          'address_id': addressId,
          if (voucherCode != null && voucherCode.isNotEmpty)
            'voucher_code': voucherCode,
        },
      );
      return parseEnvelope(
        response,
        (raw) => CheckoutSessionCreated.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `PATCH /checkout/sessions/{id}/address` — mengganti alamat kirim **tanpa
  /// melepas reservasi stok**.
  ///
  /// Balasannya `data: null`, jadi seperti mutasi keranjang, hasilnya harus
  /// dibaca ulang lewat [fetchSession] — repository yang menanggungnya.
  ///
  /// ⚠️ **Satu kode error untuk dua sebab.** Alamat milik orang lain dan
  /// `address_id` yang tidak dikirim sama-sama dibalas `422 VALIDATION_ERROR`
  /// dengan pesan "Alamat tidak ditemukan / bukan milik akun ini" — keduanya
  /// sudah diuji. Aplikasi hanya menawarkan alamat milik user sendiri, jadi
  /// kode itu di praktiknya berarti alamatnya baru saja terhapus.
  Future<ApiEnvelope<void>> changeAddress(
    String sessionId, {
    required int addressId,
  }) async {
    final context = 'PATCH /checkout/sessions/$sessionId/address';
    try {
      final response = await _dio.patch<dynamic>(
        '/checkout/sessions/$sessionId/address',
        data: {'address_id': addressId},
      );
      return parseEnvelope(response, (_) {}, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<CheckoutSessionModel>> fetchSession(String id) async {
    final context = 'GET /checkout/sessions/$id';
    try {
      final response = await _dio.get<dynamic>('/checkout/sessions/$id');
      return parseEnvelope(
        response,
        (raw) => CheckoutSessionModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /checkout/sessions/{id}/shipping-options`.
  ///
  /// ⚠️ Balasannya **map berkunci `store_id` (string)**, bukan list:
  /// `{"1": [ … ], "2": [ … ]}`. Tiap toko punya daftar opsinya sendiri karena
  /// ongkir dihitung dari gudang toko itu ke alamat tujuan.
  Future<ApiEnvelope<Map<String, List<ShippingOptionModel>>>>
      fetchShippingOptions(String id) async {
    final context = 'GET /checkout/sessions/$id/shipping-options';
    try {
      final response =
          await _dio.get<dynamic>('/checkout/sessions/$id/shipping-options');
      return parseEnvelope(
        response,
        (raw) {
          if (raw is! Map) return <String, List<ShippingOptionModel>>{};
          return raw.map((key, value) {
            final options = value is List
                ? value
                    .whereType<Map>()
                    .map((e) => ShippingOptionModel.fromJson(
                        Map<String, dynamic>.from(e)))
                    .toList()
                : <ShippingOptionModel>[];
            return MapEntry(key.toString(), options);
          });
        },
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `PATCH /checkout/sessions/{id}/shipping` — memilih kurir **per toko**.
  ///
  /// Body-nya map berkunci `store_id`, sama seperti bentuk opsinya:
  /// `{"1": {"courier_code": "jnt", "service_code": "ez"}}`.
  ///
  /// Berbeda dari endpoint `/address` yang rusak, yang ini membaca body dengan
  /// benar (`$this->body()` di controller).
  Future<ApiEnvelope<ShippingSelectionResult>> setShipping(
    String id,
    Map<String, ({String courierCode, String serviceCode})> selection,
  ) async {
    final context = 'PATCH /checkout/sessions/$id/shipping';
    try {
      final response = await _dio.patch<dynamic>(
        '/checkout/sessions/$id/shipping',
        data: {
          for (final entry in selection.entries)
            entry.key: {
              'courier_code': entry.value.courierCode,
              'service_code': entry.value.serviceCode,
            },
        },
      );
      return parseEnvelope(
        response,
        (raw) => ShippingSelectionResult.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /checkout/sessions/{id}/confirm` `{pin}` → order terbentuk **dan
  /// sudah dibayar** dari saldo Xpedia Wallet.
  ///
  /// Sejak backend `d9ecb33` (docs/22 #1–#2) checkout **wallet-only**:
  /// `payment_method` tidak lagi dibaca, PIN wajib setiap kali, saldo didebit
  /// dan order lahir berstatus `paid` dalam satu transaksi. Balasannya hanya
  /// `{order_ids, payment_transaction_id}` — tanpa `paid`/`balance_after` yang
  /// dulu diusulkan; `CheckoutRepositoryImpl.confirm` yang melengkapinya.
  ///
  /// Penolakannya (diperiksa ke kode backend):
  ///
  /// * PIN salah, PIN **belum dibuat**, sesi kedaluwarsa, maupun sesi yang
  ///   sudah dikonfirmasi — semuanya `422 CHECKOUT_CONFIRM_FAILED`, yang beda
  ///   hanya `message`. Repository membedakannya dengan membaca ulang sesi.
  /// * Saldo kurang → `422 INSUFFICIENT_BALANCE`, `details` null.
  /// * `429 TOO_MANY_REQUESTS` — 🔴 kuota PIN **5 per 15 menit per user,
  ///   dibagi dengan penarikan, dan percobaan BENAR ikut dihitung**: pembeli
  ///   yang tidak pernah salah PIN pun hanya bisa checkout 5× per 15 menit.
  ///
  /// ⚠️ **Tidak pernah diulang otomatis** — tidak ada `Idempotency-Key`.
  Future<ApiEnvelope<CheckoutConfirmResult>> confirm(
    String id, {
    required String pin,
  }) async {
    final context = 'POST /checkout/sessions/$id/confirm';
    try {
      final response = await _dio.post<dynamic>(
        '/checkout/sessions/$id/confirm',
        data: {'pin': pin},
      );
      return parseEnvelope(
        response,
        (raw) => CheckoutConfirmResult.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /checkout/sessions/{id}/cancel` — melepas reservasi stok.
  ///
  /// Sesudahnya status sesi jadi **`expired`**, bukan `cancelled`.
  Future<ApiEnvelope<dynamic>> cancel(String id) async {
    final context = 'POST /checkout/sessions/$id/cancel';
    try {
      final response =
          await _dio.post<dynamic>('/checkout/sessions/$id/cancel');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
