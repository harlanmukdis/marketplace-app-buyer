import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';

/// Toko dari sisi pembeli.
abstract class StoreRepository {
  Future<DataState<StoreModel>> fetchStore(int id);

  Future<DataState<StorePerformanceModel>> fetchPerformance(int id);

  /// Mengikuti atau berhenti mengikuti, lalu mengembalikan toko hasil baca
  /// ulang — `follower_count` dan `is_following` berubah di server.
  Future<DataState<StoreModel>> setFollowing(int id, {required bool follow});

  Future<DataState<List<FollowedStoreModel>>> fetchFollowing({int page});
}
