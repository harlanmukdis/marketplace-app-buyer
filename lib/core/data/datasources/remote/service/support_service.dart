import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

/// Xpedia 911 — `/support-tickets*` sisi pengguna.
///
/// `/admin/support-tickets*` sengaja tidak ada di sini (`403` untuk pembeli).
///
/// ⚠️ Bentuk daftar mengikuti `/orders`: **20 per halaman, tanpa `meta`**.
class SupportService {
  SupportService(this._dio);

  final Dio _dio;

  static const int serverPageSize = 20;

  Future<ApiEnvelope<List<SupportTicketModel>>> fetchTickets(
      {int page = 1}) async {
    const context = 'GET /support-tickets';
    try {
      final response = await _dio.get<dynamic>(
        '/support-tickets',
        queryParameters: {'page': page},
      );
      return parseEnvelopeList(response, SupportTicketModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// Tiket milik orang lain maupun yang tidak ada: `404 TICKET_NOT_FOUND`.
  Future<ApiEnvelope<SupportTicketModel>> fetchTicket(int id) async {
    final context = 'GET /support-tickets/$id';
    try {
      final response = await _dio.get<dynamic>('/support-tickets/$id');
      return parseEnvelope(
        response,
        (raw) =>
            SupportTicketModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /support-tickets` → id tiket baru.
  ///
  /// 🔴 [relatedOrderId] **tidak diperiksa kepemilikannya**, dan id pesanan
  /// yang tidak ada meledak jadi **500 HTML** (pelanggaran foreign key).
  /// Aplikasi hanya pernah mengisinya dari pesanan milik user sendiri yang
  /// sedang dibuka — jangan pernah dari input bebas.
  Future<ApiEnvelope<int>> createTicket({
    required SupportCategory category,
    required String subject,
    required String description,
    int? relatedOrderId,
  }) async {
    const context = 'POST /support-tickets';
    try {
      final response = await _dio.post<dynamic>(
        '/support-tickets',
        data: {
          'category': category.code,
          'subject': subject.trim(),
          'description': description.trim(),
          if (relatedOrderId != null) 'related_order_id': relatedOrderId,
        },
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  Future<ApiEnvelope<List<SupportMessageModel>>> fetchMessages(
      int ticketId) async {
    final context = 'GET /support-tickets/$ticketId/messages';
    try {
      final response =
          await _dio.get<dynamic>('/support-tickets/$ticketId/messages');
      return parseEnvelopeList(response, SupportMessageModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// Pesan kosong dan tiket yang sudah selesai/ditutup dibalas `422`. Pesan
  /// pertama dari pengguna memindahkan tiket `open` → `in_progress`.
  Future<ApiEnvelope<dynamic>> sendMessage(int ticketId, String message) async {
    final context = 'POST /support-tickets/$ticketId/messages';
    try {
      final response = await _dio.post<dynamic>(
        '/support-tickets/$ticketId/messages',
        data: {'message': message.trim()},
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
