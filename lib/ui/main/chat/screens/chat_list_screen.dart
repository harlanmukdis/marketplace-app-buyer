import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_list_cubit.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Daftar percakapan dengan toko — tab "Chat" di navigasi bawah.
///
/// Tidak ada desain mobile untuk layar ini; bentuknya diturunkan dari panel
/// daftar b42 (inventaris desain §3.22), dengan tiga unsur **sengaja
/// dibuang** karena backend tidak mendukungnya:
///
/// * ⚠️ **Lencana "belum dibaca" dan filter "Belum Dibaca".** Kolom
///   `buyer_unread_count` ada di skema tapi tidak ada kode backend yang
///   pernah mengisinya — ia permanen `0`. Menghitungnya sendiri berarti
///   menembak `/messages` untuk tiap baris.
/// * **Cuplikan pesan terakhir dan thumbnail produk.** Respons daftar hanya
///   kolom `chat_conversations` + nama toko; isi pesan tidak ikut.
/// * **Kolom cari.** Tidak ada endpoint pencarian percakapan, dan menyaring
///   di klien hanya berlaku untuk halaman yang sudah dimuat.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key, this.onLogoTap});

  /// Diisi saat layar ini jadi tab di `HomeLayout`: app bar memakai logo
  /// sebagai tombol Beranda dan tanpa tombol kembali.
  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatListCubit()..load(),
      child: _ChatListBody(onLogoTap: onLogoTap),
    );
  }
}

class _ChatListBody extends StatelessWidget {
  const _ChatListBody({this.onLogoTap});

  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    const actions = [SupportActionButton(), CartActionButton()];

    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: onLogoTap != null
          ? XpTabAppBar(title: 'Chat', onLogoTap: onLogoTap, actions: actions)
          : const XpStackAppBar(title: 'Chat', actions: actions),
      body: BlocConsumer<ChatListCubit, ChatListState>(
        listenWhen: (previous, current) =>
            current is ChatListLoaded && current.actionError != null,
        listener: (context, state) {
          final error = (state as ChatListLoaded).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessageFor(context, error))),
            );
          ChatListCubit.get(context).clearActionError();
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => ChatListCubit.get(context).refresh(),
            child: switch (state) {
              ChatListLoading() =>
                const Center(child: CircularProgressIndicator()),
              ChatListError(:final error) => _Scrollable(
                  child: XpEmptyState(
                    icon: Icons.cloud_off_rounded,
                    title: 'Chat gagal dimuat',
                    message: errorMessageFor(context, error),
                    actionLabel: 'Coba Lagi',
                    onAction: () => ChatListCubit.get(context).refresh(),
                  ),
                ),
              ChatListEmpty() => _Scrollable(
                  child: XpEmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'Belum ada percakapan',
                    message: 'Mulai chat dari halaman produk untuk bertanya '
                        'langsung ke penjual.',
                    actionLabel: 'Mulai Belanja',
                    onAction: onLogoTap ??
                        () => context.go(AppRoutes.homeLayout),
                  ),
                ),
              ChatListLoaded(:final conversations) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: XpColors.surface,
                        border: Border.symmetric(
                          horizontal:
                              BorderSide(color: XpColors.borderSubtle),
                        ),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < conversations.length; i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                indent: 76,
                                color: XpColors.borderSubtle,
                              ),
                            _ConversationTile(conversation: conversations[i]),
                          ],
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: XpBanner(
                        icon: Icons.shield_outlined,
                        title: 'Chat Xpedia aman dan terpercaya',
                        message: 'Jangan bertransaksi di luar Xpedia. Semua '
                            'percakapan tercatat sebagai perlindungan '
                            'untukmu.',
                      ),
                    ),
                  ],
                ),
            },
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final ChatConversationModel conversation;

  @override
  Widget build(BuildContext context) {
    final storeName =
        conversation.storeName.isEmpty ? 'Toko' : conversation.storeName;
    final time = _listTime(conversation.sortedAt);

    return InkWell(
      onTap: () => context.push(
        AppRoutes.chatRoomPath(conversation.id),
        extra: conversation.storeName,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              XpInitialAvatar(name: storeName, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      storeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XpText.titleM(context),
                    ),
                    // Isi pesan terakhir tidak ikut di daftar percakapan —
                    // responsnya hanya kolom tabel `chat_conversations` —
                    // jadi baris kedua hanya muncul untuk ruang yang masih
                    // kosong, alih-alih kalimat pengisi.
                    if (conversation.isEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Belum ada pesan',
                        style: XpText.bodyS(context)
                            .copyWith(color: XpColors.textTertiary),
                      ),
                    ],
                  ],
                ),
              ),
              if (time != null) ...[
                const SizedBox(width: 8),
                Text(
                  time,
                  style: XpText.caption(context)
                      .copyWith(color: XpColors.textTertiary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Waktu ringkas ala daftar chat: jam untuk hari ini, "Kemarin", lalu
  /// tanggal. Dihitung dalam **jam dinding WIB** seperti seluruh tampilan
  /// waktu server — lihat [formatServerDateTime].
  static String? _listTime(DateTime? instant) {
    if (instant == null) return null;
    final wall = instant.toUtc().add(kServerUtcOffset);
    final now = DateTime.now().toUtc().add(kServerUtcOffset);
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(wall.year, wall.month, wall.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) {
      return '${_two(wall.hour)}:${_two(wall.minute)}';
    }
    if (diff == 1) return 'Kemarin';
    return formatServerDate(instant);
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}

class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      ),
    );
  }
}
