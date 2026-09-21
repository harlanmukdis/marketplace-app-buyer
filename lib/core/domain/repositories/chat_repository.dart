import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';

/// Percakapan pembeli↔toko.
///
/// Tidak ada method polling: endpoint `/poll` menahan koneksi sampai 25 detik
/// dan membekukan seluruh API yang single-threaded — lihat `ChatService`.
abstract class ChatRepository {
  Future<DataState<List<ChatConversationModel>>> fetchConversations();

  /// Membuka percakapan dengan satu toko, atau mengembalikan yang sudah ada.
  Future<DataState<int>> openConversation({required int storeId});

  Future<DataState<List<ChatMessageModel>>> fetchMessages(
    int conversationId, {
    int page,
  });

  /// Mengirim pesan, lalu mengembalikan **halaman pertama hasil baca ulang**.
  ///
  /// Balasan `POST` hanya berisi id, jadi pesan yang baru terkirim tidak bisa
  /// dirender dari situ — ia tidak membawa `created_at` maupun
  /// `sender_user_id`. Repository yang menanggung baca-ulangnya supaya tidak
  /// ada layar yang lupa.
  Future<DataState<List<ChatMessageModel>>> sendMessage(
    int conversationId, {
    required String content,
  });

  Future<DataState<void>> markRead(int conversationId);
}
