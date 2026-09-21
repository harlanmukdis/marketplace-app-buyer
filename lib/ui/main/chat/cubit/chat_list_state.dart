part of 'chat_list_cubit.dart';

/// Status daftar percakapan.
@freezed
sealed class ChatListState with _$ChatListState {
  const ChatListState._();

  const factory ChatListState.loading() = ChatListLoading;

  /// Belum pernah chat dengan toko mana pun.
  const factory ChatListState.empty() = ChatListEmpty;

  const factory ChatListState.loaded({
    required List<ChatConversationModel> conversations,
    DataError? actionError,
  }) = ChatListLoaded;

  const factory ChatListState.error(DataError error) = ChatListError;
}
