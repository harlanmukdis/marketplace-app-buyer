part of 'support_ticket_cubit.dart';

@freezed
sealed class SupportTicketState with _$SupportTicketState {
  const factory SupportTicketState.loading() = SupportTicketLoading;

  const factory SupportTicketState.ready({
    required SupportTicketModel ticket,
    @Default(<SupportMessageModel>[]) List<SupportMessageModel> messages,

    /// Percakapan gagal dimuat, walau tiketnya terbaca.
    DataError? messagesError,
    @Default(false) bool isSending,
    DataError? actionError,
  }) = SupportTicketReady;

  const factory SupportTicketState.error(DataError error) = SupportTicketError;
}
