import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_list_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Daftar percakapan dengan toko.
///
/// ⚠️ **Tidak ada lencana "belum dibaca".** Kolom `buyer_unread_count` ada di
/// skema tapi tidak ada kode backend yang pernah mengisinya — ia permanen
/// `0`. Menghitungnya sendiri berarti menembak `/messages` untuk tiap baris.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatListCubit()..load(),
      child: const _ChatListBody(),
    );
  }
}

class _ChatListBody extends StatelessWidget {
  const _ChatListBody();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, 'Chat'),
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
                  child: _Message(
                    icon: Icons.cloud_off_rounded,
                    title: errorMessageFor(context, error),
                    actionLabel: 'Coba lagi',
                    onAction: () => ChatListCubit.get(context).refresh(),
                  ),
                ),
              ChatListEmpty() => const _Scrollable(
                  child: _Message(
                    icon: Icons.chat_bubble_outline,
                    title: 'Belum ada percakapan.',
                    subtitle:
                        'Mulai chat dari halaman produk untuk bertanya ke '
                        'penjual.',
                  ),
                ),
              ChatListLoaded(:final conversations) => ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsetsDirectional.all(16),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) =>
                      _ConversationTile(conversation: conversations[index]),
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
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;
    final primary = dark ? kDarkPrimaryColor : kLightPrimaryColor;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.chatRoomPath(conversation.id),
          extra: conversation.storeName,
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsetsDirectional.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: dark ? kDarkThirdColor : kBorderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: primary.withValues(alpha: 0.12),
                child: Icon(Icons.storefront_outlined, size: 20,
                    color: primary),
              ),
              12.sbw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.storeName,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.styleMedium14(context).copyWith(
                        color: dark ? kDarkSecondColor : kLightSecondColor,
                      ),
                    ),
                    2.sbh,
                    Text(
                      // Isi pesan terakhir tidak ikut di daftar percakapan —
                      // responsnya hanya kolom tabel `chat_conversations`.
                      conversation.isEmpty
                          ? 'Belum ada pesan'
                          : 'Terakhir ${formatServerDateTime(conversation.lastMessageAt)}',
                      style: AppStyles.styleRegular11(context)
                          .copyWith(color: muted),
                    ),
                  ],
                ),
              ),
              Icon(
                isLanguageRTL()
                    ? Icons.keyboard_arrow_left_outlined
                    : Icons.keyboard_arrow_right_outlined,
                color: muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
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

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 32,
          vertical: 64,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: muted),
            16.sbh,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            if (subtitle != null) ...[
              8.sbh,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppStyles.styleRegular12(context).copyWith(color: muted),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              16.sbh,
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
