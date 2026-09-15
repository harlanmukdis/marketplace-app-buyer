import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/notification_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/notification_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'notification_cubit.freezed.dart';
part 'notification_state.dart';

/// Kotak masuk notifikasi.
///
/// Tiga keterbatasan server yang membentuk cubit ini:
///
/// **1. Paginasi disimpulkan, bukan dibaca.** `GET /me/notifications` tidak
/// mengirim `meta` sama sekali dan mengabaikan `?per_page=`. Seperti
/// `OrderListCubit`, halaman berikutnya dianggap ada selama halaman terakhir
/// kembali terisi penuh ([NotificationService.serverPageSize]).
///
/// **2. Jumlah belum dibaca hanya bisa dihitung dari yang sudah dimuat.**
/// Tidak ada endpoint penghitung. Karena itu [NotificationLoaded.unreadCount]
/// selalu disertai [NotificationLoaded.unreadCountIsPartial] — layar wajib
/// menandai angkanya sebagai "minimal sekian" selama masih ada halaman yang
/// belum dimuat, alih-alih menampilkannya seolah pasti.
///
/// **3. Menandai terbaca diperbarui di sisi aplikasi, bukan dengan baca
/// ulang.** Endpointnya membalas `data: null`, dan membalas `200` bahkan untuk
/// id yang tidak ada — jadi baca ulang adalah satu-satunya cara memastikan,
/// dan itu berarti satu permintaan penuh plus lompatan posisi gulir setiap
/// kali satu baris disentuh. Yang dilakukan di sini: perbarui optimistis, lalu
/// **kembalikan ke keadaan semula kalau permintaannya gagal**.
///
/// 🔴 **4. Urutan dari server tidak stabil, dan itu terbukti.** Modelnya
/// mengurutkan `ORDER BY created_at DESC` saja, tanpa pemecah seri — sementara
/// `created_at` bertipe `DATETIME` yang resolusinya **satu detik**. Diuji ke
/// server: tiga notifikasi yang terbit dalam detik yang sama kembali
/// **terlama dulu**, kebalikan dari yang dijanjikan.
///
/// Dua akibatnya, dan keduanya ditangani [_merge]:
///
/// * urutan tampil salah untuk notifikasi yang lahir berbarengan — diperbaiki
///   dengan mengurutkan ulang menurut `(createdAt, id)` menurun;
/// * **paginasi bisa menggandakan atau melewatkan baris**, karena
///   `LIMIT`/`OFFSET` di atas urutan yang tidak deterministik tidak menjamin
///   satu baris hanya muncul di satu halaman. Baris berulang dibuang menurut
///   id, sehingga yang tergandakan tidak pernah sampai ke layar.
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit()
      : _repository = injector<NotificationRepository>(),
        super(const NotificationState.loading());

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final NotificationRepository _repository;

  Future<void> load() async {
    emit(const NotificationState.loading());
    final result = await _repository.fetchNotifications(page: 1);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(NotificationState.loaded(
          notifications: _merge(const [], data),
          hasMore: data.length >= NotificationService.serverPageSize,
        ));
      case DataEmpty():
        emit(const NotificationState.empty());
      case DataFailed(:final error):
        emit(NotificationState.error(error));
      case DataLoading():
        break;
    }
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final nextPage = current.page + 1;
    final result = await _repository.fetchNotifications(page: nextPage);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(current.copyWith(
          // Digabung lewat _merge, bukan disambung begitu saja: urutan server
          // tidak deterministik, jadi satu baris bisa muncul di dua halaman.
          notifications: _merge(current.notifications, data),
          page: nextPage,
          hasMore: data.length >= NotificationService.serverPageSize,
          isLoadingMore: false,
        ));
      case DataEmpty():
        emit(current.copyWith(hasMore: false, isLoadingMore: false));
      case DataFailed(:final error):
        emit(current.copyWith(isLoadingMore: false, loadMoreError: error));
      case DataLoading():
        break;
    }
  }

  /// Menandai satu notifikasi terbaca.
  ///
  /// Diperbarui di layar lebih dulu supaya barisnya langsung berubah, lalu
  /// dikembalikan kalau permintaannya gagal. Notifikasi yang sudah terbaca
  /// diabaikan tanpa menyentuh jaringan — menekan baris yang sama dua kali
  /// tidak perlu jadi dua permintaan.
  Future<void> markRead(int id) async {
    final current = state;
    if (current is! NotificationLoaded) return;

    final target =
        current.notifications.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;

    emit(current.copyWith(
      notifications: _withRead(current.notifications, ids: {id}),
      actionError: null,
    ));

    final result = await _repository.markRead(id);
    if (isClosed) return;

    if (result case DataFailed(:final error)) {
      final latest = state;
      if (latest is! NotificationLoaded) return;
      // Kembalikan tanda terbaca — kalau tidak, barisnya terlihat terbaca
      // padahal server masih menganggapnya baru, dan akan "muncul lagi"
      // membingungkan saat berikutnya dimuat.
      emit(latest.copyWith(
        notifications: _withUnread(latest.notifications, ids: {id}),
        actionError: error,
      ));
    }
  }

  /// Menandai seluruh notifikasi terbaca.
  ///
  /// Server menandai **semuanya**, termasuk halaman yang belum dimuat
  /// aplikasi — jadi tidak perlu menyusuri halaman satu per satu.
  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationLoaded || current.isSubmitting) return;
    if (current.unreadCount == 0 && !current.hasMore) return;

    final before = current.notifications;
    emit(current.copyWith(
      notifications: _withRead(before, ids: before.map((n) => n.id).toSet()),
      isSubmitting: true,
      actionError: null,
    ));

    final result = await _repository.markAllRead();
    if (isClosed) return;

    final latest = state;
    if (latest is! NotificationLoaded) return;

    switch (result) {
      case DataFailed(:final error):
        emit(latest.copyWith(
          notifications: before,
          isSubmitting: false,
          actionError: error,
        ));
      case _:
        emit(latest.copyWith(isSubmitting: false));
    }
  }

  void clearActionError() {
    final current = state;
    if (current is! NotificationLoaded || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  /// Menggabungkan halaman baru ke daftar yang sudah ada: buang yang
  /// berulang, lalu urutkan terbaru lebih dulu.
  ///
  /// Keduanya menambal urutan server yang tidak stabil (lihat catatan kelas).
  /// Baris yang sudah ada **dipertahankan**, bukan diganti salinan dari
  /// halaman baru — kalau tidak, tanda "terbaca" yang baru saja diperbarui di
  /// aplikasi akan tertimpa kembali jadi belum terbaca.
  ///
  /// Pengurutannya memakai `id` sebagai pemecah seri, satu-satunya kunci yang
  /// pasti menaik dan pasti unik. Untuk stempel waktu yang berbeda hasilnya
  /// sama persis dengan urutan server; yang berubah hanya notifikasi yang
  /// lahir dalam detik yang sama.
  static List<NotificationModel> _merge(
    List<NotificationModel> existing,
    List<NotificationModel> incoming,
  ) {
    final byId = <int, NotificationModel>{
      for (final n in incoming) n.id: n,
      // Ditulis belakangan supaya menang atas salinan dari halaman baru.
      for (final n in existing) n.id: n,
    };

    return byId.values.toList()
      ..sort((a, b) {
        final at = a.createdAt;
        final bt = b.createdAt;
        if (at != null && bt != null && at != bt) return bt.compareTo(at);
        return b.id.compareTo(a.id);
      });
  }

  static List<NotificationModel> _withRead(
    List<NotificationModel> source, {
    required Set<int> ids,
  }) =>
      [
        for (final n in source)
          ids.contains(n.id) ? n.copyWith(isRead: true) : n,
      ];

  static List<NotificationModel> _withUnread(
    List<NotificationModel> source, {
    required Set<int> ids,
  }) =>
      [
        for (final n in source)
          ids.contains(n.id) ? n.copyWith(isRead: false) : n,
      ];
}
