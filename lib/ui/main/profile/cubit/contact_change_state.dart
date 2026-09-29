part of 'contact_change_cubit.dart';

@freezed
abstract class ContactChangeState with _$ContactChangeState {
  const ContactChangeState._();

  const factory ContactChangeState({
    required ContactType type,
    String? newValue,

    /// `null` = belum meminta kode; terisi = menunggu kode dimasukkan.
    ContactChangeRequest? request,
    @Default(false) bool isBusy,
    DataError? error,

    /// Kontak baru sudah tersimpan di server.
    @Default(false) bool completed,
  }) = _ContactChangeState;

  bool get awaitingToken => request != null && !completed;
}
