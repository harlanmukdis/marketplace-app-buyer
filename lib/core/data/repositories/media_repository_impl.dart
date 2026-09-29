import 'package:dio/dio.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/media_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/media_repository.dart';

class MediaRepositoryImpl with RepositoryGuard implements MediaRepository {
  MediaRepositoryImpl(this._service);

  final MediaService _service;

  @override
  Future<DataState<MediaUploadModel>> upload({
    required List<int> bytes,
    required String fileName,
    String? mimeType,
    String? context,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
  }) =>
      guard(() => _service.upload(
            bytes: bytes,
            fileName: fileName,
            mimeType: mimeType,
            context: context,
            cancelToken: cancelToken,
            onSendProgress: onProgress == null
                ? null
                : (sent, total) {
                    if (total > 0) {
                      onProgress((sent / total).clamp(0, 1).toDouble());
                    }
                  },
          ));
}
