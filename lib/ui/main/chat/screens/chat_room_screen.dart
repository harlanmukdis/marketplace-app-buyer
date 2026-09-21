import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_room_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Satu ruang percakapan dengan toko.
///
/// ⚠️ **Menyegarkan diri dengan membaca ulang berkala, bukan long-polling.**
/// `GET .../poll` menahan koneksi sampai 25 detik, dan API dijalankan dengan
/// `php -S` yang single-threaded — satu layar ini terbuka akan membekukan
/// seluruh aplikasi. Lihat `ChatRoomCubit`.
class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    this.storeName,
  });

  final int conversationId;

  /// Dikirim lewat `extra` dari daftar percakapan supaya judulnya langsung
  /// benar. `null` kalau ruang dibuka langsung dari halaman produk — tidak
  /// ada endpoint untuk menukar id percakapan jadi nama toko.
  final String? storeName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatRoomCubit(conversationId)..load(),
      child: _ChatRoomBody(storeName: storeName),
    );
  }
}

class _ChatRoomBody extends StatefulWidget {
  const _ChatRoomBody({this.storeName});

  final String? storeName;

  @override
  State<_ChatRoomBody> createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<_ChatRoomBody> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    ChatRoomCubit.get(context).send(text);
    _input.clear();
  }

  /// Menggulir ke pesan terbaru.
  ///
  /// Ditunda satu frame: saat listener dipanggil, daftar barunya belum
  /// selesai dipasang sehingga `maxScrollExtent` masih nilai lama.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, widget.storeName ?? 'Chat'),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
              listenWhen: (previous, current) =>
                  current is ChatRoomReady &&
                  (current.actionError != null ||
                      (previous is! ChatRoomReady ||
                          previous.messages.length !=
                              current.messages.length)),
              listener: (context, state) {
                final ready = state as ChatRoomReady;
                final error = ready.actionError;
                if (error != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(errorMessageFor(context, error))),
                    );
                  ChatRoomCubit.get(context).clearActionError();
                  return;
                }
                _scrollToBottom();
              },
              builder: (context, state) {
                return switch (state) {
                  ChatRoomLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  ChatRoomError(:final error) => _ErrorView(
                      message: errorMessageFor(context, error),
                      onRetry: () => ChatRoomCubit.get(context).load(),
                    ),
                  ChatRoomReady(:final messages) => messages.isEmpty
                      ? const _EmptyRoom()
                      : _MessageList(
                          messages: messages,
                          myUserId: ChatRoomCubit.get(context).myUserId,
                          controller: _scroll,
                        ),
                };
              },
            ),
          ),
          _Composer(controller: _input, onSend: _send),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messages,
    required this.myUserId,
    required this.controller,
  });

  final List<ChatMessageModel> messages;
  final int? myUserId;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => ChatRoomCubit.get(context).refresh(),
      child: ListView.builder(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) => _Bubble(
          message: messages[index],
          mine: messages[index].isMine(myUserId),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});

  final ChatMessageModel message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final primary = dark ? kDarkPrimaryColor : kLightPrimaryColor;
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: context.screenWidth * 0.75,
              ),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: mine
                    ? primary.withValues(alpha: 0.12)
                    : (dark ? kBlackColor : const Color(0xffF3F4F6)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.displayText,
                    style: AppStyles.styleRegular14(context).copyWith(
                      color: dark ? kDarkSecondColor : kLightSecondColor,
                    ),
                  ),
                  4.sbh,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatServerDateTime(message.createdAt),
                        style: AppStyles.styleRegular11(context)
                            .copyWith(color: muted),
                      ),
                      // Tanda terbaca hanya untuk pesan sendiri: `read_at`
                      // diisi saat LAWAN membuka percakapan, dan server tidak
                      // pernah menandai pesan sendiri sebagai terbaca.
                      if (mine) ...[
                        4.sbw,
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 13,
                          color: message.isRead ? primary : muted,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return SafeArea(
      child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
        builder: (context, state) {
          final sending = state is ChatRoomReady && state.isSending;
          final ready = state is ChatRoomReady;

          return Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: ready && !sending,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan…',
                      filled: true,
                      fillColor:
                          dark ? kBlackColor : const Color(0xffF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                8.sbw,
                IconButton.filled(
                  onPressed: ready && !sending ? onSend : null,
                  icon: sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyRoom extends StatelessWidget {
  const _EmptyRoom();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: muted),
            16.sbh,
            Text(
              'Belum ada pesan.',
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            8.sbh,
            Text(
              'Tulis pertanyaanmu ke penjual di bawah.',
              textAlign: TextAlign.center,
              style: AppStyles.styleRegular12(context).copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
            16.sbh,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            16.sbh,
            FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}
