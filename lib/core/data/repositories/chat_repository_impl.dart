import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/chat_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl with RepositoryGuard implements ChatRepository {
  ChatRepositoryImpl(this._service);

  final ChatService _service;

  /// Daftar kosong jadi [DataEmpty], supaya layar bisa membedakan "belum
  /// pernah chat" dari "gagal memuat" tanpa memeriksa panjang list sendiri.
  @override
  Future<DataState<List<ChatConversationModel>>> fetchConversations() =>
      guardList(_service.fetchConversations);

  @override
  Future<DataState<int>> openConversation({required int storeId}) =>
      guard(() => _service.openConversation(storeId: storeId));

  /// Memakai `guard`, **bukan** `guardList`: percakapan yang belum berisi
  /// pesan adalah keadaan yang sah dan sering terjadi (barisnya dibuat lebih
  /// dulu oleh `POST /chat/conversations`), jadi ia tidak boleh tampil
  /// sebagai `DataEmpty` yang bersaing arti dengan "halaman terakhir habis".
  @override
  Future<DataState<List<ChatMessageModel>>> fetchMessages(
    int conversationId, {
    int page = 1,
  }) =>
      guard(() => _service.fetchMessages(conversationId, page: page));

  @override
  Future<DataState<List<ChatMessageModel>>> sendMessage(
    int conversationId, {
    required String content,
  }) async {
    try {
      await _service.sendMessage(conversationId, content: content);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    // Balasan POST hanya `{id}` — tanpa `created_at` maupun `sender_user_id`,
    // jadi pesannya tidak bisa dirender dari situ.
    return guard(() => _service.fetchMessages(conversationId));
  }

  @override
  Future<DataState<List<ChatMessageModel>>> share(
    int conversationId, {
    int? productId,
    int? orderId,
  }) async {
    assert((productId == null) != (orderId == null), 'bagikan tepat satu hal');
    try {
      await _service.sendMessage(
        conversationId,
        type: productId != null
            ? ChatMessageType.productShare
            : ChatMessageType.orderShare,
        sharedProductId: productId,
        sharedOrderId: orderId,
      );
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return guard(() => _service.fetchMessages(conversationId));
  }

  @override
  Future<DataState<void>> markRead(int conversationId) =>
      guardVoid(() => _service.markRead(conversationId));
}
