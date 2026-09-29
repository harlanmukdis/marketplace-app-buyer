// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportTicketModel _$SupportTicketModelFromJson(Map<String, dynamic> json) =>
    _SupportTicketModel(
      id: const IntJson().fromJson(json['id']),
      ticketNumber: json['ticket_number'] == null
          ? ''
          : const StringJson().fromJson(json['ticket_number']),
      category: json['category'] == null
          ? ''
          : const StringJson().fromJson(json['category']),
      subject: json['subject'] == null
          ? ''
          : const StringJson().fromJson(json['subject']),
      description: const StringOrNullJson().fromJson(json['description']),
      relatedOrderId: const IntOrNullJson().fromJson(json['related_order_id']),
      status: json['status'] == null
          ? 'open'
          : const StringJson().fromJson(json['status']),
      resolvedAt: const ServerDateTimeJson().fromJson(json['resolved_at']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$SupportTicketModelToJson(_SupportTicketModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'ticket_number': const StringJson().toJson(instance.ticketNumber),
      'category': const StringJson().toJson(instance.category),
      'subject': const StringJson().toJson(instance.subject),
      'description': const StringOrNullJson().toJson(instance.description),
      'related_order_id': const IntOrNullJson().toJson(instance.relatedOrderId),
      'status': const StringJson().toJson(instance.status),
      'resolved_at': const ServerDateTimeJson().toJson(instance.resolvedAt),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };

_SupportMessageModel _$SupportMessageModelFromJson(Map<String, dynamic> json) =>
    _SupportMessageModel(
      id: const IntJson().fromJson(json['id']),
      senderUserId: json['sender_user_id'] == null
          ? 0
          : const IntJson().fromJson(json['sender_user_id']),
      isAdminReply: json['is_admin_reply'] == null
          ? false
          : const BoolJson().fromJson(json['is_admin_reply']),
      message: json['message'] == null
          ? ''
          : const StringJson().fromJson(json['message']),
      attachmentUrl: const StringOrNullJson().fromJson(json['attachment_url']),
      createdAt: const ServerDateTimeJson().fromJson(json['created_at']),
    );

Map<String, dynamic> _$SupportMessageModelToJson(
        _SupportMessageModel instance) =>
    <String, dynamic>{
      'id': const IntJson().toJson(instance.id),
      'sender_user_id': const IntJson().toJson(instance.senderUserId),
      'is_admin_reply': const BoolJson().toJson(instance.isAdminReply),
      'message': const StringJson().toJson(instance.message),
      'attachment_url': const StringOrNullJson().toJson(instance.attachmentUrl),
      'created_at': const ServerDateTimeJson().toJson(instance.createdAt),
    };
