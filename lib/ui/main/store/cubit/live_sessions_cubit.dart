import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/live_session_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/live_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'live_sessions_cubit.freezed.dart';
part 'live_sessions_state.dart';

/// Sesi live commerce: strip "LIVE NOW" beranda ([LiveSessionsCubit.liveNow])
/// dan tab Live storefront ([LiveSessionsCubit.forStore]).
///
/// 🔶 Datanya dari endpoint **usulan** `GET /live-sessions` (mock di debug).
/// Tanpa mock, server membalas 404 HTML untuk rute itu — cubit memancarkan
/// [LiveSessionsUnavailable], dan beranda menyembunyikan stripnya. Jadi
/// begitu backend membangun rutenya, fitur ini hidup tanpa perubahan kode.
class LiveSessionsCubit extends Cubit<LiveSessionsState> {
  LiveSessionsCubit.liveNow()
      : storeId = null,
        _repository = injector<LiveRepository>(),
        super(const LiveSessionsState.loading());

  LiveSessionsCubit.forStore(int this.storeId)
      : _repository = injector<LiveRepository>(),
        super(const LiveSessionsState.loading());

  static LiveSessionsCubit get(BuildContext context) => BlocProvider.of(context);

  /// `null` = seluruh toko (beranda).
  final int? storeId;
  final LiveRepository _repository;

  Future<void> load() async {
    emit(const LiveSessionsState.loading());
    final id = storeId;
    final result =
        id == null ? await _repository.fetchLiveNow() : await _repository.fetchForStore(id);
    if (isClosed) return;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        // Yang sedang tayang dulu, lalu jadwal terdekat — urutan server
        // belum dijanjikan karena endpoint-nya belum ada.
        final sorted = [...data]..sort((a, b) {
            if (a.isLive != b.isLive) return a.isLive ? -1 : 1;
            final at = a.startedAt ?? a.scheduledAt;
            final bt = b.startedAt ?? b.scheduledAt;
            if (at == null || bt == null) return a.id.compareTo(b.id);
            return a.isLive ? bt.compareTo(at) : at.compareTo(bt);
          });
        emit(LiveSessionsState.loaded(sessions: sorted, meta: meta));
      case DataEmpty(:final meta):
        emit(LiveSessionsState.empty(meta: meta));
      case DataFailed(:final error):
        emit(LiveSessionsState.unavailable(error));
      case DataLoading():
        break;
    }
  }
}
