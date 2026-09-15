import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';

/// Kotak masuk notifikasi pembeli.
///
/// ⚠️ Backend belum menerbitkan notifikasi apa pun untuk pembeli — lihat
/// `NotificationService` untuk penelusurannya. Antarmuka ini tetap dibuat
/// karena endpointnya nyata dan bentuknya sudah dipatok test.
abstract class NotificationRepository {
  /// Satu halaman notifikasi. Ukuran halaman dipatok server dan tidak bisa
  /// diatur pemanggil.
  Future<DataState<List<NotificationModel>>> fetchNotifications({int page});

  /// Menandai satu notifikasi terbaca.
  ///
  /// ⚠️ Sukses **tidak** berarti barisnya berubah: server membalas `200`
  /// bahkan untuk id yang tidak ada atau milik orang lain. Pemanggil yang
  /// memperbarui tampilannya sendiri harus sadar akan itu.
  Future<DataState<void>> markRead(int id);

  /// Menandai seluruh notifikasi terbaca, termasuk yang belum dimuat.
  Future<DataState<void>> markAllRead();
}
