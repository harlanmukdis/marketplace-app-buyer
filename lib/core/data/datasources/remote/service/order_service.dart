import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';

/// Panggilan HTTP untuk `/orders*` **sisi pembeli**.
///
/// ⚠️ **Endpoint sisi penjual sengaja tidak ada di sini**:
/// `/orders/{id}/pack|ship|custom-confirm|partial-fulfillment/propose` dan `/stores/{id}/orders` semuanya dijawab
/// `403 PERMISSION_DENIED` untuk token buyer. Menambahkannya berarti alur yang
/// salah sisi sedang dibangun.
///
/// ⚠️ **`GET /orders` hanya menerima `page`.** Controllernya meneruskan
/// persis satu parameter ke model (`list_for_buyer($userId, $page)`), jadi:
///
/// * **`?status=` diabaikan** — meminta `completed` tetap mengembalikan
///   pesanan `pending` dan `cancelled`. (Sisi penjual, `list_for_store`,
///   memang mendukungnya; sisi pembeli tidak.) Karena itu [fetchOrders] tidak
///   punya parameter status: menyediakannya berarti menawarkan filter yang
///   diam-diam tidak bekerja.
/// * **`?per_page=` diabaikan** — ukuran halaman dipatok [serverPageSize] di
///   server.
/// * **`meta` tidak dikirim sama sekali** — tidak ada `total`. Adanya halaman
///   berikutnya hanya bisa **disimpulkan** dari jumlah item yang kembali.
class OrderService {
  OrderService(this._dio);

  final Dio _dio;

  /// Ukuran halaman yang dipakai server (`list_for_buyer`, default 20) dan
  /// **tidak bisa diubah klien**. Dipakai untuk menebak adanya halaman
  /// berikutnya.
  static const int serverPageSize = 20;

  /// `GET /orders` — pesanan milik user login, terbaru dulu.
  ///
  /// Hasilnya **tanpa** `items`, `status_history`, dan `refund`; ketiganya
  /// hanya ada di [fetchOrder].
  Future<ApiEnvelope<List<OrderModel>>> fetchOrders({int page = 1}) async {
    const context = 'GET /orders';
    try {
      final response = await _dio.get<dynamic>(
        '/orders',
        queryParameters: <String, dynamic>{'page': page},
      );
      return parseEnvelopeList(response, OrderModel.fromJson, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /orders/{id}` — detail lengkap.
  ///
  /// Order milik user lain dibalas `403 PERMISSION_DENIED`, bukan `404`.
  Future<ApiEnvelope<OrderModel>> fetchOrder(int id) async {
    final context = 'GET /orders/$id';
    try {
      final response = await _dio.get<dynamic>('/orders/$id');
      return parseEnvelope(
        response,
        (raw) => OrderModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/cancel` — pembeli membatalkan sebelum diproses.
  Future<ApiEnvelope<dynamic>> cancel(int id, {String? reason}) async {
    final context = 'POST /orders/$id/cancel';
    try {
      final response = await _dio.post<dynamic>(
        '/orders/$id/cancel',
        data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/confirm-delivery` — `shipped` → `delivered`.
  ///
  /// Transisi yang tidak sah dibalas `422 VALIDATION_ERROR` dengan rapi.
  ///
  /// 🔴 **Pesanan Secure+ menuntut [sealCode]** — kode segel yang dikirim ke
  /// pembeli lewat notifikasi `order_shipped_secure_plus` saat paket dikirim.
  /// Kode salah/kosong dibalas `422 INVALID_SEAL_CODE`, dan lebih dari 5
  /// percobaan per 15 menit `429 TOO_MANY_REQUESTS` (yang benar pun ikut
  /// dihitung). Pesanan biasa mengabaikan field ini.
  Future<ApiEnvelope<dynamic>> confirmDelivery(int id,
      {String? sealCode}) async {
    final context = 'POST /orders/$id/confirm-delivery';
    try {
      final response = await _dio.post<dynamic>(
        '/orders/$id/confirm-delivery',
        data: {
          if (sealCode != null && sealCode.isNotEmpty) 'seal_code': sealCode
        },
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/complete` — `delivered` → `completed`.
  ///
  /// 🔴 **Endpoint ini tidak menangani transisi tidak sah dengan benar.**
  /// Berbeda dari [confirmDelivery] yang membungkusnya jadi
  /// `422 VALIDATION_ERROR`, controller `complete_post` tidak punya
  /// try/catch — `RuntimeException`-nya lolos dan dirender sebagai **halaman
  /// HTML dengan status `200`**. Dio tidak menganggapnya error (status 2xx),
  /// dan `parseEnvelope` menolaknya sebagai `CLIENT_BAD_RESPONSE`.
  ///
  /// Karena itu pemanggil **wajib memeriksa status order lebih dulu**
  /// (`OrderModel.canComplete`) daripada mengandalkan pesan error server.
  Future<ApiEnvelope<dynamic>> complete(int id) async {
    final context = 'POST /orders/$id/complete';
    try {
      final response = await _dio.post<dynamic>('/orders/$id/complete');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    } on ApiException catch (e) {
      // Menerjemahkan halaman HTML 200 itu jadi kegagalan transisi yang bisa
      // dipahami, alih-alih "respons server bukan objek JSON".
      if (e.error.code == ClientErrorCode.badResponse) {
        throw ApiException(DataError(
          code: ApiErrorCode.invalidTransition,
          message: 'Status pesanan tidak memungkinkan aksi ini',
          statusCode: e.error.statusCode,
          kind: DataErrorKind.api,
        ));
      }
      rethrow;
    }
  }

  /// `GET /orders/{id}/tracking`.
  ///
  /// Membalas `data: null` selama belum ada pengiriman — itu keadaan normal,
  /// bukan error.
  ///
  /// 🔴 Endpoint ini **tidak memeriksa kepemilikan** dan barisnya kini ikut
  /// membawa `delivery_seal_code` — siapa pun yang login bisa membaca kode
  /// segel pesanan orang lain. Sudah dilaporkan; aplikasi sengaja tidak
  /// memodelkan field itu.
  Future<ApiEnvelope<OrderTrackingModel?>> fetchTracking(int id) async {
    final context = 'GET /orders/$id/tracking';
    try {
      final response = await _dio.get<dynamic>('/orders/$id/tracking');
      return parseEnvelope(
        response,
        (raw) => raw == null
            ? null
            : OrderTrackingModel.fromJson(
                Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /orders/{id}/shipment-evidence` — bukti Secure+; `[]` untuk
  /// pesanan biasa atau yang belum dikirim.
  Future<ApiEnvelope<List<ShipmentEvidenceModel>>> fetchShipmentEvidence(
      int id) async {
    final context = 'GET /orders/$id/shipment-evidence';
    try {
      final response = await _dio.get<dynamic>('/orders/$id/shipment-evidence');
      return parseEnvelopeList(response, ShipmentEvidenceModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /orders/{id}/invoice` — hanya untuk pesanan `completed`, selainnya
  /// `422 INVOICE_NOT_AVAILABLE`.
  Future<ApiEnvelope<OrderInvoiceModel>> fetchInvoice(int id) async {
    final context = 'GET /orders/$id/invoice';
    try {
      final response = await _dio.get<dynamic>('/orders/$id/invoice');
      return parseEnvelope(
        response,
        (raw) =>
            OrderInvoiceModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/partial-fulfillment/respond` — jawaban pembeli atas
  /// usulan kirim sebagian. Tanpa usulan yang menunggu → `422
  /// VALIDATION_ERROR`; balasan sukses `data: null`.
  Future<ApiEnvelope<dynamic>> respondPartialFulfillment(
    int id,
    PartialFulfillmentDecision decision,
  ) async {
    final context = 'POST /orders/$id/partial-fulfillment/respond';
    try {
      final response = await _dio.post<dynamic>(
        '/orders/$id/partial-fulfillment/respond',
        data: {'decision': decision.code},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/refund-request` — komplain sesudah barang diterima.
  ///
  /// Sejak backend `0307edf` (docs/22 #5) server **menggerbangi status**:
  /// selain `delivered`/`completed` dibalas `422 VALIDATION_ERROR`.
  /// `OrderModel.canRequestRefund` tetap menjaganya lebih dulu. Tanpa
  /// `amount` server memakai `grand_total`.
  ///
  /// [evidenceUrls] (hasil `POST /media/upload`) dikirim sebagai body
  /// **`evidence`** — itu nama yang dibaca `refund_request_post`, walau
  /// kolom tujuannya bernama `evidence_urls`. 🔴 Nama yang salah tidak
  /// ditolak, hanya **dibuang diam-diam**: versi sebelumnya mengirim
  /// `evidence_urls` dan seluruh bukti foto pembeli hilang. Bandingkan
  /// `POST /orders/{id}/insurance/claims`, yang memang membaca
  /// `evidence_urls`.
  Future<ApiEnvelope<dynamic>> requestRefund(
    int id, {
    required String reason,
    List<String> evidenceUrls = const [],
  }) async {
    final context = 'POST /orders/$id/refund-request';
    try {
      final response = await _dio.post<dynamic>(
        '/orders/$id/refund-request',
        data: {
          'reason': reason,
          if (evidenceUrls.isNotEmpty) 'evidence': evidenceUrls,
        },
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /orders/{id}/cancellation-request` — permohonan pembatalan terakhir,
  /// atau `data: null` kalau belum pernah diajukan.
  ///
  /// ⚠️ **Diusulkan, belum ada di backend** (docs/22 #3) — dijawab mock di
  /// build debug. Tanpa mock, rutenya membalas 404 HTML
  /// (`DataError.isRouteNotFound`), dan pemanggil memperlakukannya sebagai
  /// "fitur belum tersedia", bukan error.
  Future<ApiEnvelope<CancellationRequestModel?>> fetchCancellationRequest(
      int id) async {
    final context = 'GET /orders/$id/cancellation-request';
    try {
      final response =
          await _dio.get<dynamic>('/orders/$id/cancellation-request');
      return parseEnvelope(
        response,
        (raw) => raw is Map
            ? CancellationRequestModel.fromJson(Map<String, dynamic>.from(raw))
            : null,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/cancellation-request` — "Ajukan Pembatalan" sesudah
  /// resi; penjual yang memutuskan.
  ///
  /// ⚠️ **Diusulkan, belum ada di backend.** Status selain `packed`/`shipped`
  /// → `422 CANCELLATION_NOT_ALLOWED`; permohonan yang masih `pending` →
  /// `409 CANCELLATION_REQUEST_EXISTS`.
  ///
  /// Tidak pernah diulang otomatis: tanpa `Idempotency-Key` di backend,
  /// pengulangan bisa membuat dua permohonan.
  Future<ApiEnvelope<CancellationRequestModel>> requestCancellation(
    int id, {
    required CancellationReason reason,
    String? note,
  }) async {
    final context = 'POST /orders/$id/cancellation-request';
    try {
      final response = await _dio.post<dynamic>(
        '/orders/$id/cancellation-request',
        data: {
          'reason': reason.code,
          if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
        },
      );
      return parseEnvelope(
        response,
        (raw) => CancellationRequestModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /orders/{id}/insurance` — polis Secure+ pesanan ini, atau
  /// `data: null`.
  ///
  /// ⚠️ **Diusulkan, belum ada di backend.** Yang ada hanya `opt-in` dan
  /// `claims`; `Insurance_model::find_policy_by_order()` sudah ada tapi tidak
  /// punya rute. Tanpa endpoint ini aplikasi tidak bisa menampilkan
  /// "Secure+ aktif", dan opt-in kedua kali menabrak `UNIQUE (order_id)` di
  /// tabel polis.
  Future<ApiEnvelope<InsurancePolicyModel?>> fetchInsurance(int id) async {
    final context = 'GET /orders/$id/insurance';
    try {
      final response = await _dio.get<dynamic>('/orders/$id/insurance');
      return parseEnvelope(
        response,
        (raw) => raw is Map
            ? InsurancePolicyModel.fromJson(Map<String, dynamic>.from(raw))
            : null,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /orders/{id}/insurance/opt-in {tier: secure_plus}` — **ada di
  /// backend**, membalas `201 {id, premium_amount, tier}`.
  ///
  /// Tiga kejanggalan server yang membentuk pemanggilan ini:
  /// * **Tidak ada gerbang status** — polis bisa dibuat untuk pesanan yang
  ///   sudah dikirim, padahal gerbang Secure+ ditegakkan saat `ship`. Pemanggil
  ///   wajib memeriksa `OrderModel.canOptInSecurePlus`.
  /// * **`premium_amount` diterima dari klien** (fallback 0,5% `grand_total`).
  ///   Aplikasi sengaja **tidak** mengirimnya, supaya angkanya selalu dihitung
  ///   server — dan ini sudah dilaporkan sebagai celah.
  /// * **Opt-in kedua** melanggar `UNIQUE (order_id)` dan jatuh sebagai error
  ///   database, bukan kode yang rapi.
  Future<ApiEnvelope<InsurancePolicyModel>> optInSecurePlus(int id) async {
    final context = 'POST /orders/$id/insurance/opt-in';
    try {
      final response = await _dio.post<dynamic>(
        '/orders/$id/insurance/opt-in',
        data: {'tier': 'secure_plus'},
      );
      return parseEnvelope(
        response,
        (raw) => InsurancePolicyModel.fromJson(
            Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
