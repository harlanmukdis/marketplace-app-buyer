import 'package:dio/dio.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';

/// Unggah berkas lewat `POST /media/upload`. URL hasilnya dipakai sebagai
/// isi field `*_url` di endpoint lain (bukti komplain, foto ulasan).
abstract class MediaRepository {
  /// [onProgress] menerima 0..1. [cancelToken] membatalkan unggahan yang
  /// sedang berjalan (mis. user menghapus berkasnya sebelum selesai).
  Future<DataState<MediaUploadModel>> upload({
    required List<int> bytes,
    required String fileName,
    String? mimeType,
    String? context,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
  });
}
