import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';

/// Tiket Xpedia 911.
abstract class SupportRepository {
  Future<DataState<List<SupportTicketModel>>> fetchTickets({int page});

  Future<DataState<SupportTicketModel>> fetchTicket(int id);

  /// Membuat tiket lalu mengembalikan tiket hasil baca ulang.
  Future<DataState<SupportTicketModel>> createTicket({
    required SupportCategory category,
    required String subject,
    required String description,
    int? relatedOrderId,
  });

  Future<DataState<List<SupportMessageModel>>> fetchMessages(int ticketId);

  /// Mengirim pesan lalu mengembalikan percakapan hasil baca ulang.
  Future<DataState<List<SupportMessageModel>>> sendMessage(
      int ticketId, String message);
}
