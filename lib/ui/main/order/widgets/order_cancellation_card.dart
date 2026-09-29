import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Kartu status permohonan pembatalan sesudah resi (docs/22 #3), dipakai di
/// detail pesanan dan di layar Ajukan Pembatalan.
///
/// Endpoint-nya masih diusulkan, jadi [meta] dari respons diteruskan ke
/// [SimulatedBadge] — lencananya hilang sendiri begitu data datang dari
/// server sungguhan.
class CancellationRequestCard extends StatelessWidget {
  const CancellationRequestCard({
    super.key,
    required this.request,
    required this.meta,
    this.forceSimulated = false,
  });

  final CancellationRequestModel request;
  final Map<String, dynamic> meta;

  /// Untuk permohonan yang baru dibuat di sesi ini (mutasi mock).
  final bool forceSimulated;

  @override
  Widget build(BuildContext context) {
    final (label, tone, icon, explanation) = switch (request.status) {
      CancellationRequestStatus.pending => (
          'Menunggu Tinjauan Penjual',
          XpOrderTones.processing,
          Icons.hourglass_top,
          request.sellerResponseDeadline == null
              ? 'Penjual akan meninjau permohonan ini. Selama menunggu, pesanan tetap diproses.'
              : 'Penjual menjawab paling lambat ${formatServerDateTime(request.sellerResponseDeadline)}. '
                  'Selama menunggu, pesanan tetap diproses.',
        ),
      CancellationRequestStatus.approved => (
          'Disetujui Penjual',
          XpOrderTones.completed,
          Icons.check_circle_outline,
          'Pesanan dibatalkan dan dana dikembalikan ke saldo Xpedia Wallet kamu.',
        ),
      CancellationRequestStatus.rejected => (
          'Ditolak Penjual',
          XpTone(XpColors.dangerSubtle, XpColors.danger),
          Icons.cancel_outlined,
          'Pesanan tetap diproses dan dikirim oleh penjual.',
        ),
      CancellationRequestStatus.unknown => (
          request.statusCode,
          XpOrderTones.cancelled,
          Icons.info_outline,
          '',
        ),
    };
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_late_outlined, size: 20, color: XpColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(child: Text('Permohonan Pembatalan', style: XpText.titleM(context))),
              SimulatedBadge(meta: meta, force: forceSimulated),
            ],
          ),
          const SizedBox(height: 8),
          XpPill(label: label, tone: tone, icon: icon, large: true),
          const SizedBox(height: 8),
          XpKeyValueRow(label: 'Alasan', value: request.reasonLabel),
          XpKeyValueRow(label: 'Diajukan', value: formatServerDateTime(request.createdAt)),
          if (request.resolvedAt != null)
            XpKeyValueRow(label: 'Dijawab', value: formatServerDateTime(request.resolvedAt)),
          if ((request.note ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('"${request.note}"',
                style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
          ],
          if ((request.rejectionReason ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Alasan penjual: ${request.rejectionReason}',
                style: XpText.bodyS(context).copyWith(color: XpColors.danger)),
          ],
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(explanation, style: XpText.bodyS(context)),
          ],
        ],
      ),
    );
  }
}
