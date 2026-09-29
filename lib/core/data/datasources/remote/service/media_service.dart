import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';

/// `POST /media/upload` — unggah berkas generik (**ada di backend**).
///
/// Kontraknya dibaca dari `media/controllers/Media.php`, bukan dari dokumen:
///
/// * multipart, nama field **`file`**, opsional `context`
///   (`product_photo` diberi watermark; nilai lain tidak);
/// * tipe yang diterima `jpg|jpeg|png|gif|webp|pdf|mp4|mov|webm`, maks
///   **20 MB** (`MAX_SIZE_KB = 20480`, dinaikkan untuk video Secure+);
/// * gagal → `422 UPLOAD_FAILED` dengan pesan pustaka upload CodeIgniter;
/// * sukses → `201 {url, file_name, file_size_kb, mime_type}`.
///
/// ⚠️ `url` dirakit dari `$config['base_url']` yang masih
/// `http://localhost:8080/marketplace-api/` — host-nya salah sampai backend
/// menyetelnya. Lihat [MediaUploadModel].
class MediaService {
  MediaService(this._dio);

  final Dio _dio;

  /// Batas server. Batas yang ditawarkan aplikasi lebih ketat (10 MB per
  /// berkas, desain §3.16) — lihat pemakainya.
  static const int serverMaxBytes = 20 * 1024 * 1024;

  /// Unggahan lambat di jaringan seluler melewati `sendTimeout` 30 detik
  /// bawaan klien, jadi dilonggarkan khusus untuk panggilan ini.
  static const Duration uploadTimeout = Duration(minutes: 3);

  Future<ApiEnvelope<MediaUploadModel>> upload({
    required List<int> bytes,
    required String fileName,
    String? mimeType,
    String? context,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    const label = 'POST /media/upload';
    try {
      final form = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: mimeType == null ? null : DioMediaType.parse(mimeType),
        ),
        if (context != null) 'context': context,
      });
      final response = await _dio.post<dynamic>(
        '/media/upload',
        data: form,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          sendTimeout: _dio.options.sendTimeout == null ? null : uploadTimeout,
          receiveTimeout: uploadTimeout,
        ),
      );
      return parseEnvelope(
        response,
        (raw) =>
            MediaUploadModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: label,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: label);
    }
  }
}
