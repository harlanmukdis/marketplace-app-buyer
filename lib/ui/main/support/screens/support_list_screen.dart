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
import 'package:marketplace_app_member/ui/main/support/cubit/support_list_cubit.dart';
import 'package:marketplace_app_member/ui/main/support/widgets/support_status_pill.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Beranda Xpedia 911: ajakan membuat tiket dan daftar tiket milik user.
///
/// Xpedia 911 adalah **satu-satunya** merek layanan pelanggan di app —
/// tidak ada "Help Center" / "Pusat Bantuan" terpisah (design_buyer.md §5).
class SupportListScreen extends StatelessWidget {
  const SupportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportListCubit()..load(),
      child: const _SupportListBody(),
    );
  }
}

class _SupportListBody extends StatelessWidget {
  const _SupportListBody();

  Future<void> _newTicket(BuildContext context) async {
    final cubit = SupportListCubit.get(context);
    await context.push(AppRoutes.supportNewPath());
    await cubit.load();
  }

  Future<void> _openTicket(BuildContext context, int id) async {
    final cubit = SupportListCubit.get(context);
    await context.push(AppRoutes.supportTicketPath(id));
    // Status tiket bisa berubah setelah user membalas (open → in_progress).
    await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Xpedia 911'),
      body: BlocBuilder<SupportListCubit, SupportListState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: SupportListCubit.get(context).load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _Hero(onNewTicket: () => _newTicket(context)),
                const XpSectionHeader(
                  title: 'Tiket Saya',
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 12),
                ),
                ...switch (state) {
                  SupportListLoading() => [
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  SupportListError(:final error) => [
                      XpEmptyState(
                        icon: Icons.cloud_off_rounded,
                        title: 'Tiket belum bisa dimuat',
                        message: accountErrorText(context, error),
                        actionLabel: 'Coba lagi',
                        onAction: SupportListCubit.get(context).load,
                      ),
                    ],
                  SupportListLoaded(:final tickets) when tickets.isEmpty => [
                      // Tanpa tombol: ajakan membuat tiket sudah ada di kartu
                      // atas, dan empty state hanya boleh punya satu aksi.
                      const XpEmptyState(
                        icon: Icons.confirmation_number_outlined,
                        title: 'Belum ada tiket',
                        message: 'Tiket yang kamu buat dan balasan tim Xpedia 911 '
                            'akan muncul di sini.',
                      ),
                    ],
                  SupportListLoaded() => [
                      for (final ticket in state.tickets)
                        _TicketCard(
                          ticket: ticket,
                          onTap: () => _openTicket(context, ticket.id),
                        ),
                      if (state.hasMore || state.loadMoreError != null)
                        Center(
                          child: state.isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(),
                                )
                              : TextButton(
                                  onPressed: SupportListCubit.get(context).loadMore,
                                  child: Text(state.loadMoreError != null
                                      ? 'Gagal memuat. Coba lagi'
                                      : 'Muat lebih banyak'),
                                ),
                        ),
                    ],
                },
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onNewTicket});

  final VoidCallback onNewTicket;

  static const _onNavyMuted = Color(0xffE1E8FD);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XpColors.navy,
        borderRadius: BorderRadius.circular(XpRadius.l),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Xpedia 911',
                        style: XpText.headingM(context)
                            .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    Text('Layanan 24 Jam',
                        style: XpText.labelM(context).copyWith(color: _onNavyMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ada kendala pesanan, pembayaran, wallet, atau akun? Buat tiket dan '
            'tim resmi Xpedia akan membalas di sini.',
            style: XpText.bodyS(context).copyWith(color: _onNavyMuted),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: XpColors.navy,
              ),
              onPressed: onNewTicket,
              icon: Icon(Icons.add_circle, size: 18, color: XpColors.primary),
              label: const Text('Buat Tiket Baru'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final SupportTicketModel ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final category = ticket.categoryValue?.label;
    return XpCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ticket.ticketNumber.isEmpty ? 'Tiket #${ticket.id}' : ticket.ticketNumber,
                  style: XpText.labelM(context).copyWith(color: XpColors.textTertiary),
                ),
              ),
              SupportStatusPill(ticket: ticket),
            ],
          ),
          const SizedBox(height: 8),
          Text(ticket.subject,
              maxLines: 2, overflow: TextOverflow.ellipsis, style: XpText.titleM(context)),
          const SizedBox(height: 4),
          Text(
            [
              if (category != null) category,
              if (ticket.relatedOrderId != null) 'Pesanan #${ticket.relatedOrderId}',
              formatServerDate(ticket.createdAt),
            ].join(' • '),
            style: XpText.caption(context).copyWith(color: XpColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
