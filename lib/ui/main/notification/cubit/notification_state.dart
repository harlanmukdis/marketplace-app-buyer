part of 'notification_cubit.dart';

/// Status layar notifikasi.
@freezed
sealed class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState.loading() = NotificationLoading;

  /// Kotak masuk kosong.
  ///
  /// Dipisahkan dari [NotificationLoaded] berisi list kosong karena di domain
  /// ini kosong adalah **keadaan yang wajar dan permanen** selama backend
  /// belum menerbitkan notifikasi untuk pembeli — layarnya harus menjelaskan
  /// itu, bukan menampilkan daftar hampa.
  const factory NotificationState.empty() = NotificationEmpty;

  const factory NotificationState.loaded({
    required List<NotificationModel> notifications,
    @Default(1) int page,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    DataError? loadMoreError,

    /// Sedang menandai semuanya terbaca.
    @Default(false) bool isSubmitting,
    DataError? actionError,
  }) = NotificationLoaded;

  const factory NotificationState.error(DataError error) = NotificationError;
}

extension NotificationLoadedX on NotificationLoaded {
  /// Jumlah notifikasi belum dibaca **di antara yang sudah dimuat**.
  ///
  /// ⚠️ Bukan jumlah sebenarnya kalau [hasMore] masih `true` — tidak ada
  /// endpoint penghitung di backend, jadi angka ini tidak bisa lebih baik dari
  /// halaman yang sudah diambil. Pasangkan selalu dengan
  /// [unreadCountIsPartial] saat menampilkannya.
  int get unreadCount => notifications.where((n) => n.isUnread).length;

  /// `true` kalau [unreadCount] hanyalah batas bawah.
  bool get unreadCountIsPartial => hasMore;

  /// Angka siap tampil: `"3"`, atau `"3+"` selama masih ada halaman yang belum
  /// dimuat.
  String get unreadLabel =>
      unreadCountIsPartial ? '$unreadCount+' : '$unreadCount';
}
