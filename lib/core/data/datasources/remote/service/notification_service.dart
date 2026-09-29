import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';

/// Panggilan HTTP untuk `/me/notifications*`.
///
/// ## 🔴 Kotak masuk ini praktis selalu kosong, dan itu bukan bug aplikasi
///
/// Sudah ditelusuri ke seluruh kode backend: **satu-satunya tempat yang pernah
/// menulis ke tabel `notifications` adalah undangan staf toko**
/// (`store_staff/controllers/Staff.php`). Tidak ada satu pun notifikasi yang
/// terbit dari pesanan, pembayaran, pengiriman, chat, atau voucher — padahal
/// `notification_templates` sendiri mencantumkan `order_paid`, `order_shipped`,
/// `voucher_expiring`, dan `chat_new_message` sebagai niatnya.
///
/// Jadi seorang pembeli biasa **tidak akan pernah** menerima notifikasi sampai
/// backend memasang pemanggilan `Notification_model->create()` di alur-alur
/// itu. Layarnya tetap dibangun — endpointnya nyata, bentuknya sudah dipatok
/// test, dan fiturnya hidup begitu backend menyambungkannya — tapi keadaan
/// kosong adalah **kasus normalnya**, bukan sudut yang jarang terjadi.
///
/// ## ⚠️ Tidak ada endpoint jumlah belum dibaca
///
/// Tidak ada `GET /me/notifications/unread-count` atau sejenisnya, dan
/// responsnya tidak membawa `meta`. Jumlah belum dibaca hanya bisa dihitung
/// dari halaman yang sudah dimuat — lihat `NotificationCubit`.
class NotificationService {
  NotificationService(this._dio);

  final Dio _dio;

  /// Ukuran halaman yang **dipatok server**.
  ///
  /// Controllernya memanggil `list_for_user($userId, $page)` — persis dua
  /// parameter — sehingga `$perPage` selalu memakai nilai default modelnya.
  /// `?per_page=` yang dikirim aplikasi diabaikan diam-diam.
  static const int serverPageSize = 20;

  /// `GET /me/notifications` — halaman notifikasi, terbaru lebih dulu.
  ///
  /// ⚠️ **Tanpa `meta`.** Tidak ada `total`, jadi keberadaan halaman
  /// berikutnya hanya bisa disimpulkan dari "halaman ini terisi penuh".
  /// Sengaja tidak menerima `perPage`: parameter itu tidak akan berpengaruh,
  /// dan menyediakannya hanya membuat pemanggil mengira bisa mengaturnya.
  Future<ApiEnvelope<List<NotificationModel>>> fetchNotifications({
    int page = 1,
  }) async {
    const context = 'GET /me/notifications';
    try {
      final response = await _dio.get<dynamic>(
        '/me/notifications',
        queryParameters: {'page': page},
      );
      return parseEnvelopeList(response, NotificationModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/notifications/{id}/read` — menandai satu notifikasi terbaca.
  ///
  /// ⚠️ **Balasan sukses bukan bukti sesuatu berubah.** Modelnya menjalankan
  /// `UPDATE … WHERE id = ? AND user_id = ?` tanpa memeriksa jumlah baris
  /// terpengaruh, jadi id yang tidak ada — atau milik user lain — tetap
  /// dibalas `200` dengan `data: null`. Diuji ke server dengan keduanya.
  ///
  /// Karena itu pemanggil tidak boleh menyimpulkan apa pun dari statusnya
  /// selain "tidak ada kesalahan jaringan".
  Future<ApiEnvelope<void>> markRead(int id) async {
    const context = 'POST /me/notifications/{id}/read';
    try {
      final response = await _dio.post<dynamic>('/me/notifications/$id/read');
      return parseEnvelope(response, (_) {}, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/notifications/read-all` — menandai **seluruh** notifikasi
  /// terbaca, termasuk yang ada di halaman yang belum dimuat aplikasi.
  Future<ApiEnvelope<void>> markAllRead() async {
    const context = 'POST /me/notifications/read-all';
    try {
      final response = await _dio.post<dynamic>('/me/notifications/read-all');
      return parseEnvelope(response, (_) {}, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
