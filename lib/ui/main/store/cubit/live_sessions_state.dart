part of 'live_sessions_cubit.dart';

@freezed
sealed class LiveSessionsState with _$LiveSessionsState {
  const LiveSessionsState._();

  const factory LiveSessionsState.loading() = LiveSessionsLoading;

  const factory LiveSessionsState.loaded({
    required List<LiveSessionModel> sessions,

    /// `meta` amplop — `meta.mock` menandai data simulasi (`SimulatedBadge`).
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
  }) = LiveSessionsLoaded;

  const factory LiveSessionsState.empty({
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
  }) = LiveSessionsEmpty;

  /// Gagal — termasuk **rute belum ada** (404 HTML) saat mock dimatikan.
  const factory LiveSessionsState.unavailable(DataError error) = LiveSessionsUnavailable;

  List<LiveSessionModel> get live => switch (this) {
        LiveSessionsLoaded(:final sessions) => sessions.where((s) => s.isLive).toList(),
        _ => const [],
      };

  List<LiveSessionModel> get scheduled => switch (this) {
        LiveSessionsLoaded(:final sessions) => sessions.where((s) => s.isScheduled).toList(),
        _ => const [],
      };
}
