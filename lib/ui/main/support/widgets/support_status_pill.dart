import 'package:flutter/widgets.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';

/// Pil status tiket Xpedia 911, memakai ulang palet status pesanan supaya
/// arti warnanya sama di seluruh app: biru menunggu, kuning sedang ditangani,
/// hijau selesai, abu-abu ditutup.
class SupportStatusPill extends StatelessWidget {
  const SupportStatusPill({super.key, required this.ticket});

  final SupportTicketModel ticket;

  @override
  Widget build(BuildContext context) {
    final tone = switch (ticket.status) {
      'open' => XpOrderTones.shipping,
      'in_progress' => XpOrderTones.processing,
      'resolved' => XpOrderTones.completed,
      _ => XpOrderTones.cancelled,
    };
    return XpPill(label: ticket.statusLabel, tone: tone, large: true);
  }
}
