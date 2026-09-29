part of 'support_new_ticket_cubit.dart';

@freezed
abstract class SupportNewTicketState with _$SupportNewTicketState {
  const factory SupportNewTicketState({
    SupportCategory? category,
    @Default(false) bool isSubmitting,
    DataError? error,

    /// Tiket yang baru dibuat (hasil baca ulang). Layar mengganti rutenya ke
    /// halaman tiket ini.
    SupportTicketModel? created,
  }) = _SupportNewTicketState;
}
