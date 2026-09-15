import 'package:marketplace_app_member/core/data/datasources/remote/service/notification_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl
    with RepositoryGuard
    implements NotificationRepository {
  NotificationRepositoryImpl(this._service);

  final NotificationService _service;

  /// Kotak masuk kosong dikembalikan sebagai [DataEmpty], bukan
  /// [DataSuccess] berisi list kosong.
  ///
  /// Di domain ini bedanya bukan kosmetik: kosong adalah **keadaan normal**
  /// (backend belum menerbitkan notifikasi apa pun untuk pembeli), jadi layar
  /// harus bisa membedakannya dari gagal memuat tanpa memeriksa panjang list
  /// sendiri.
  @override
  Future<DataState<List<NotificationModel>>> fetchNotifications({
    int page = 1,
  }) =>
      guardList(() => _service.fetchNotifications(page: page));

  @override
  Future<DataState<void>> markRead(int id) =>
      guardVoid(() => _service.markRead(id));

  @override
  Future<DataState<void>> markAllRead() => guardVoid(_service.markAllRead);
}
