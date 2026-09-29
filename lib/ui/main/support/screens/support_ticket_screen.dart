import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/support/cubit/support_ticket_cubit.dart';
import 'package:marketplace_app_member/ui/main/support/widgets/support_status_pill.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Satu tiket Xpedia 911: kepala tiket, deskripsi, percakapan, kolom balas.
///
/// Tidak ada penyegaran otomatis — balasan admin terlihat lewat tarik untuk
/// menyegarkan. Tidak ada endpoint long-poll untuk tiket, dan menembak ulang
/// berkala di server `php -S` yang single-threaded ikut memperlambat layar
/// lain (lihat catatan `/poll` di domain chat).
class SupportTicketScreen extends StatelessWidget {
  const SupportTicketScreen({super.key, required this.ticketId});

  final int ticketId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportTicketCubit(ticketId)..load(),
      child: const _TicketBody(),
    );
  }
}

class _TicketBody extends StatelessWidget {
  const _TicketBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportTicketCubit, SupportTicketState>(
      listenWhen: (previous, current) =>
          current is SupportTicketReady && current.actionError != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
                accountErrorText(context, (state as SupportTicketReady).actionError!)),
          ));
        SupportTicketCubit.get(context).clearActionError();
      },
      builder: (context, state) {
        final title = switch (state) {
          SupportTicketReady(:final ticket) when ticket.ticketNumber.isNotEmpty =>
            ticket.ticketNumber,
          _ => 'Tiket Xpedia 911',
        };
        return Scaffold(
          backgroundColor: XpColors.canvas,
          appBar: XpStackAppBar(title: title),
          body: switch (state) {
            SupportTicketLoading() => const Center(child: CircularProgressIndicator()),
            SupportTicketError(:final error) => XpEmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Tiket belum bisa dimuat',
                message: accountErrorText(context, error),
                actionLabel: 'Coba lagi',
                onAction: SupportTicketCubit.get(context).load,
              ),
            SupportTicketReady() => _Ready(state: state),
          },
        );
      },
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final SupportTicketReady state;

  @override
  Widget build(BuildContext context) {
    final ticket = state.ticket;
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: SupportTicketCubit.get(context).load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _TicketHeader(ticket: ticket),
                const XpSectionHeader(
                  title: 'Percakapan',
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 12),
                ),
                if (state.messagesError != null)
                  XpBanner(
                    icon: Icons.cloud_off_rounded,
                    tone: XpBannerTone.warning,
                    title: 'Percakapan belum bisa dimuat',
                    message: 'Tarik layar ke bawah untuk mencoba lagi.',
                    onTap: SupportTicketCubit.get(context).load,
                  )
                else if (state.messages.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Belum ada balasan. Tim Xpedia 911 akan membalas tiketmu '
                      'di sini.',
                      textAlign: TextAlign.center,
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                    ),
                  )
                else
                  for (final message in state.messages) _Bubble(message: message),
              ],
            ),
          ),
        ),
        if (ticket.acceptsMessages)
          _Composer(busy: state.isSending)
        else
          XpBottomBar(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Tiket ini sudah ${ticket.statusLabel.toLowerCase()} dan tidak '
                    'menerima balasan.',
                    style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    // `relatedOrderId` di sini berasal dari tiket milik user
                    // sendiri — yang dulu dibuat dari halaman pesanannya.
                    onPressed: () => context.pushReplacement(
                        AppRoutes.supportNewPath(orderId: ticket.relatedOrderId)),
                    child: const Text('Buat Tiket Baru'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TicketHeader extends StatelessWidget {
  const _TicketHeader({required this.ticket});

  final SupportTicketModel ticket;

  @override
  Widget build(BuildContext context) {
    final description = ticket.description?.trim() ?? '';
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ticket.categoryValue?.label ?? 'Tiket',
                  style: XpText.labelM(context).copyWith(color: XpColors.textTertiary),
                ),
              ),
              SupportStatusPill(ticket: ticket),
            ],
          ),
          const SizedBox(height: 8),
          Text(ticket.subject, style: XpText.titleL(context)),
          const SizedBox(height: 2),
          Text(
            'Dibuat ${formatServerDateTime(ticket.createdAt)}',
            style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
          ),
          if (ticket.relatedOrderId != null) ...[
            const SizedBox(height: 12),
            XpBanner(
              icon: Icons.inventory_2_outlined,
              title: 'Terkait pesanan #${ticket.relatedOrderId}',
              trailing: Icon(Icons.chevron_right, size: 20, color: XpColors.primary),
              onTap: () => context.push(AppRoutes.orderDetailPath(ticket.relatedOrderId!)),
            ),
          ],
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: XpColors.borderSubtle),
            const SizedBox(height: 12),
            Text(description, style: XpText.bodyM(context)),
          ],
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final SupportMessageModel message;

  @override
  Widget build(BuildContext context) {
    final fromAdmin = message.isAdminReply;
    final bg = fromAdmin ? XpColors.surface : XpColors.primary;
    final fg = fromAdmin ? XpColors.textPrimary : Colors.white;
    return Align(
      alignment: fromAdmin ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: bg,
            border: fromAdmin ? Border.all(color: XpColors.borderSubtle) : null,
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(XpRadius.l),
              topEnd: const Radius.circular(XpRadius.l),
              bottomStart: Radius.circular(fromAdmin ? XpRadius.xs : XpRadius.l),
              bottomEnd: Radius.circular(fromAdmin ? XpRadius.l : XpRadius.xs),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fromAdmin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.support_agent, size: 14, color: XpColors.primary),
                      const SizedBox(width: 4),
                      Text('Xpedia 911',
                          style: XpText.labelS(context).copyWith(color: XpColors.primary)),
                    ],
                  ),
                ),
              Text(message.message, style: XpText.bodyM(context).copyWith(color: fg)),
              const SizedBox(height: 2),
              Text(
                formatServerDateTime(message.createdAt),
                style: XpText.caption(context).copyWith(
                  color: fromAdmin ? XpColors.textTertiary : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatefulWidget {
  const _Composer({required this.busy});

  final bool busy;

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final sent = await SupportTicketCubit.get(context).send(_controller.text);
    if (sent && mounted) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return XpBottomBar(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !widget.busy,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Tulis balasan…'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'Kirim',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: widget.busy ? null : _send,
            icon: widget.busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
