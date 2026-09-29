import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';

/// Sesi live commerce yang bisa dilihat pembeli (kontrak usulan).
abstract class LiveRepository {
  /// Sesi yang sedang tayang, untuk strip "LIVE NOW" beranda.
  Future<DataState<List<LiveSessionModel>>> fetchLiveNow({int page});

  /// Sesi tayang **dan** terjadwal milik satu toko, untuk tab Live storefront.
  Future<DataState<List<LiveSessionModel>>> fetchForStore(int storeId);
}
