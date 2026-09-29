import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/support_service.dart';
import 'package:marketplace_app_member/core/data/repositories/repository_guard.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/support_repository.dart';

class SupportRepositoryImpl with RepositoryGuard implements SupportRepository {
  SupportRepositoryImpl(this._service);

  final SupportService _service;

  @override
  Future<DataState<List<SupportTicketModel>>> fetchTickets({int page = 1}) =>
      guardList(() => _service.fetchTickets(page: page));

  @override
  Future<DataState<SupportTicketModel>> fetchTicket(int id) =>
      guard(() => _service.fetchTicket(id));

  @override
  Future<DataState<SupportTicketModel>> createTicket({
    required SupportCategory category,
    required String subject,
    required String description,
    int? relatedOrderId,
  }) async {
    final int id;
    try {
      id = (await _service.createTicket(
        category: category,
        subject: subject,
        description: description,
        relatedOrderId: relatedOrderId,
      ))
          .data;
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return guard(() => _service.fetchTicket(id));
  }

  @override
  Future<DataState<List<SupportMessageModel>>> fetchMessages(int ticketId) =>
      guardList(() => _service.fetchMessages(ticketId));

  @override
  Future<DataState<List<SupportMessageModel>>> sendMessage(
      int ticketId, String message) async {
    try {
      await _service.sendMessage(ticketId, message);
    } on ApiException catch (e) {
      return DataFailed(e.error);
    }
    return guardList(() => _service.fetchMessages(ticketId));
  }
}
