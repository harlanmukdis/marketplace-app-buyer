import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/chat/chat_room_context.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_room_cubit.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_share_cubit.dart';
import 'package:marketplace_app_member/ui/main/chat/widgets/chat_share_widgets.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Satu ruang percakapan dengan toko (desain `chat_toko_markas_bangunan`).
///
/// ⚠️ **Menyegarkan diri dengan membaca ulang berkala, bukan long-polling.**
/// `GET .../poll` menahan koneksi sampai 25 detik, dan API dijalankan dengan
/// `php -S` yang single-threaded — satu layar ini terbuka akan membekukan
/// seluruh aplikasi. Lihat `ChatRoomCubit`.
///
/// **Berbagi produk & pesanan** (`product_share` / `order_share`, endpoint
/// sungguhan):
///
/// * dibuka dari halaman produk → kartu "Tanyakan produk ini" disematkan di
///   atas percakapan (konteksnya dititipkan lewat [ChatRoomContext]);
/// * tombol `+` → laci lampiran → daftar pesanan pembeli **dari toko ini**
///   (disaring di aplikasi; `GET /orders` tidak bisa disaring per toko);
/// * gelembung bagikan dirender sebagai kartu yang bisa diketuk ke detail
///   produk/pesanan.
///
/// Unsur desain yang **sengaja tidak dibuat** karena tidak ada datanya:
/// status online & waktu balas toko di sub-header, chip balasan cepat, lampiran
/// foto (butuh unggah media ke chat) dan voucher. Pesan tidak bisa diubah
/// atau dihapus, jadi tidak ada menu untuk itu.
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatRoomCubit(conversationId)..load()),
        BlocProvider(
          create: (_) => ChatShareCubit(
            conversationId,
            context: ChatRoomContext.take(conversationId),
          )..start(),
        ),
      ],
      child: _ChatRoomBody(storeName: storeName),
    );
  }
}

/// Kode penolakan filter konten chat (`422`): pesan memuat nomor HP, email,
/// atau tautan, dan **tidak disimpan** di server.
const String _contentBlockedCode = 'CHAT_CONTENT_BLOCKED';

class _ChatRoomBody extends StatefulWidget {
  const _ChatRoomBody({this.storeName});

  final String? storeName;

  @override
  State<_ChatRoomBody> createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<_ChatRoomBody> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  /// Kegagalan kirim terakhir, ditampilkan menempel di atas kolom ketik.
  ///
  /// Bukan SnackBar: SnackBar melayang tepat di atas kolom ketik dan
  /// menutupi teks yang baru dikembalikan ke sana — padahal teks itulah yang
  /// perlu user perbaiki.
  String? _sendError;

  String get _title {
    final name = widget.storeName?.trim() ?? '';
    return name.isEmpty ? 'Chat' : name;
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Mengirim isi kolom ketik.
  ///
  /// Kolomnya dikosongkan **seketika** — isinya pindah ke gelembung
  /// "menunggu" — lalu dikembalikan kalau pengiriman gagal. Yang paling
  /// penting `CHAT_CONTENT_BLOCKED`: pesannya tidak tersimpan di server, jadi
  /// tanpa pengembalian ini user kehilangan seluruh ketikannya hanya karena
  /// satu nomor HP di dalamnya.
  Future<void> _send() async {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    final cubit = ChatRoomCubit.get(context);
    if (cubit.state case ChatRoomReady(isSending: true)) return;

    setState(() => _sendError = null);
    _input.clear();
    final sent = await cubit.send(text);
    if (!mounted || sent) return;
    if (_input.text.isEmpty) {
      _input.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
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

  /// Laci lampiran (desain §3.23 no. 6), dipangkas ke yang ada backend-nya:
  /// bagikan pesanan, dan bagikan produk yang sedang ditanyakan kalau ruang
  /// dibuka dari halaman produk.
  Future<void> _openAttachments(BuildContext context) async {
    final share = ChatShareCubit.get(context);
    final room = ChatRoomCubit.get(context);
    final pinned = share.state.pinnedProductId;
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: XpColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(XpRadius.xl)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              ChatAttachTile(
                icon: Icons.receipt_long_outlined,
                label: 'Pesanan',
                background: const Color(0xffE1E8FD),
                foreground: XpColors.navy,
                onTap: () => Navigator.of(sheetContext).pop('order'),
              ),
              if (pinned != null) ...[
                const SizedBox(width: 16),
                ChatAttachTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'Produk Ini',
                  background: XpColors.primarySubtle,
                  foreground: XpColors.primary,
                  onTap: () => Navigator.of(sheetContext).pop('product'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == 'product' && pinned != null) {
      setState(() => _sendError = null);
      await room.share(productId: pinned);
      return;
    }
    if (choice == 'order') {
      share.loadOrderPicker();
      if (!context.mounted) return;
      final orderId = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: XpColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(XpRadius.xl)),
        ),
        builder: (_) => BlocProvider.value(value: share, child: const ChatOrderPickerSheet()),
      );
      if (!mounted || orderId == null) return;
      setState(() => _sendError = null);
      await room.share(orderId: orderId);
    }
  }

  String _messageFor(DataError error) {
    if (error.code == _contentBlockedCode) {
      return 'Pesan tidak terkirim karena memuat nomor HP, email, atau '
          'tautan. Hapus bagian itu lalu kirim lagi.';
    }
    return errorMessageFor(context, error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: XpStackAppBar(
        title: _title,
        actions: [
          IconButton(
            tooltip: 'Xpedia 911',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => context.push(AppRoutes.supportNewPath()),
            icon: Icon(Icons.support_agent,
                size: 24, color: XpColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          const PinnedProductCard(),
          Expanded(
            child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
              listenWhen: (previous, current) =>
                  current is ChatRoomReady &&
                  (current.actionError != null ||
                      previous is! ChatRoomReady ||
                      previous.messages.length != current.messages.length ||
                      previous.pendingText != current.pendingText),
              listener: (context, state) {
                final ready = state as ChatRoomReady;
                final error = ready.actionError;
                if (error != null) {
                  setState(() => _sendError = _messageFor(error));
                  ChatRoomCubit.get(context).clearActionError();
                  return;
                }
                _scrollToBottom();
              },
              builder: (context, state) {
                return switch (state) {
                  ChatRoomLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  ChatRoomError(:final error) => XpEmptyState(
                      icon: Icons.cloud_off_rounded,
                      title: 'Percakapan gagal dimuat',
                      message: errorMessageFor(context, error),
                      actionLabel: 'Coba Lagi',
                      onAction: () => ChatRoomCubit.get(context).load(),
                    ),
                  ChatRoomReady(:final messages, :final pendingText) =>
                    messages.isEmpty && pendingText == null
                        ? const _EmptyRoom()
                        : _MessageList(
                            messages: messages,
                            pendingText: pendingText,
                            myUserId: ChatRoomCubit.get(context).myUserId,
                            storeName: _title,
                            controller: _scroll,
                          ),
                };
              },
            ),
          ),
          const _SafetyNotice(),
          if (_sendError != null) _SendError(message: _sendError!),
          _Composer(
            controller: _input,
            onSend: _send,
            onAttach: () => _openAttachments(context),
            onChanged: () {
              if (_sendError != null) setState(() => _sendError = null);
            },
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messages,
    required this.pendingText,
    required this.myUserId,
    required this.storeName,
    required this.controller,
  });

  final List<ChatMessageModel> messages;
  final String? pendingText;
  final int? myUserId;
  final String storeName;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final pending = pendingText;
    final count = messages.length + (pending == null ? 0 : 1);

    return RefreshIndicator(
      onRefresh: () => ChatRoomCubit.get(context).refresh(),
      child: ListView.builder(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        itemCount: count,
        itemBuilder: (context, index) {
          if (index >= messages.length) {
            return _Bubble(
              text: pending!,
              mine: true,
              time: null,
              delivery: MessageDelivery.pending,
              storeName: storeName,
            );
          }
          final message = messages[index];
          final previous = index == 0 ? null : messages[index - 1];
          final showDate = previous == null ||
              _dayKey(previous.createdAt) != _dayKey(message.createdAt);
          final mine = message.isMine(myUserId);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDate && message.createdAt != null)
                _DateChip(label: formatServerDate(message.createdAt)),
              _Bubble(
                text: message.displayText,
                mine: mine,
                time: message.createdAt,
                // Tanda kirim hanya untuk pesan sendiri: `read_at` diisi saat
                // LAWAN membuka percakapan, dan server tidak pernah menandai
                // pesan sendiri sebagai terbaca.
                delivery: mine ? message.delivery : null,
                storeName: storeName,
                card: _shareCardFor(message),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Kartu untuk pesan bagikan; `null` untuk pesan teks biasa (atau pesan
  /// bagikan lama tanpa id, yang jatuh ke teks penggantinya).
  static Widget? _shareCardFor(ChatMessageModel message) {
    final productId = message.sharedProductId;
    final orderId = message.sharedOrderId;
    if (message.type == ChatMessageType.productShare && productId != null) {
      return SharedProductCard(productId: productId);
    }
    if (message.type == ChatMessageType.orderShare && orderId != null) {
      return SharedOrderCard(orderId: orderId);
    }
    return null;
  }

  /// Kunci hari dalam **jam dinding WIB**, sama dengan seluruh tampilan
  /// waktu server; memakai zona perangkat akan memindahkan pembatas tanggal
  /// bagi user di luar WIB.
  static int? _dayKey(DateTime? instant) {
    if (instant == null) return null;
    final wall = instant.toUtc().add(kServerUtcOffset);
    return wall.year * 10000 + wall.month * 100 + wall.day;
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: XpColors.sunken,
          borderRadius: BorderRadius.circular(XpRadius.full),
        ),
        child: Text(
          label,
          style: XpText.labelS(context).copyWith(color: XpColors.textSecondary),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.text,
    required this.mine,
    required this.time,
    required this.delivery,
    required this.storeName,
    this.card,
  });

  final String text;
  final bool mine;
  final DateTime? time;

  /// Kartu bagikan produk/pesanan, menggantikan gelembung teks.
  final Widget? card;

  /// `null` untuk pesan lawan bicara.
  final MessageDelivery? delivery;
  final String storeName;

  @override
  Widget build(BuildContext context) {
    const big = Radius.circular(XpRadius.xl);
    const small = Radius.circular(2);
    final radius = mine
        ? const BorderRadiusDirectional.only(
            topStart: big, topEnd: small, bottomStart: big, bottomEnd: big)
        : const BorderRadiusDirectional.only(
            topStart: small, topEnd: big, bottomStart: big, bottomEnd: big);

    final bubble = card != null
        ? ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
            child: card,
          )
        : Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: mine ? XpColors.primary : XpColors.surface,
        borderRadius: radius,
        border: mine ? null : Border.all(color: XpColors.borderSubtle),
      ),
      child: Text(
        text,
        style: XpText.bodyM(context).copyWith(
          color: mine ? XpColors.textOnBrand : XpColors.textPrimary,
        ),
      ),
    );

    final meta = Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            delivery == MessageDelivery.pending ? 'Mengirim…' : _clock(time),
            style: XpText.caption(context)
                .copyWith(color: XpColors.textTertiary),
          ),
          if (delivery != null) ...[
            const SizedBox(width: 4),
            _DeliveryTick(delivery: delivery!),
          ],
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine) ...[
            XpInitialAvatar(name: storeName, size: 28),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [bubble, meta],
            ),
          ),
        ],
      ),
    );
  }

  /// Jam `HH:mm WIB`; tanggalnya sudah di chip pembatas hari.
  static String _clock(DateTime? instant) {
    if (instant == null) return '';
    final wall = instant.toUtc().add(kServerUtcOffset);
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(wall.hour)}:${two(wall.minute)} WIB';
  }
}

/// Empat keadaan kirim dari blueprint (design_buyer.md §5 no. 10): menunggu
/// (jam), terkirim (1 centang abu), sampai (2 centang abu), dibaca (2 centang
/// biru).
class _DeliveryTick extends StatelessWidget {
  const _DeliveryTick({required this.delivery});

  final MessageDelivery delivery;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (delivery) {
      MessageDelivery.pending =>
        (Icons.schedule, XpColors.textPlaceholder, 'Mengirim'),
      MessageDelivery.sent => (Icons.done, XpColors.textPlaceholder, 'Terkirim'),
      MessageDelivery.delivered =>
        (Icons.done_all, XpColors.textPlaceholder, 'Sampai'),
      MessageDelivery.read => (Icons.done_all, XpColors.primary, 'Dibaca'),
    };
    return Semantics(
      label: label,
      child: Icon(icon, size: 16, color: color),
    );
  }
}

/// Pengingat keamanan yang selalu tampil di atas kolom ketik.
///
/// Sejalan dengan filter konten server (`CHAT_CONTENT_BLOCKED`): lebih baik
/// user tahu aturannya sebelum mengetik daripada baru tahu saat pesannya
/// ditolak.
class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: XpColors.primarySubtle,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, size: 16, color: XpColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Demi keamanan, jangan bagikan nomor HP, email, atau tautan.',
              style: XpText.caption(context)
                  .copyWith(color: XpColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendError extends StatelessWidget {
  const _SendError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: XpColors.dangerSubtle,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 16, color: XpColors.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: XpText.bodyS(context).copyWith(color: XpColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.onChanged,
    required this.onAttach,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onChanged;
  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: XpColors.surface,
        border: Border(top: BorderSide(color: XpColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
          builder: (context, state) {
            final sending = state is ChatRoomReady && state.isSending;
            final ready = state is ChatRoomReady;

            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Lampirkan',
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    onPressed: ready && !sending ? onAttach : null,
                    icon: Icon(Icons.add_circle_outline, color: XpColors.textSecondary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: ready && !sending,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => onSend(),
                      onChanged: (_) => onChanged(),
                      style: XpText.bodyM(context),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan…',
                        filled: true,
                        fillColor: XpColors.sunken,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(XpRadius.full),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(XpRadius.full),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(XpRadius.full),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(XpRadius.full),
                          borderSide: BorderSide(color: XpColors.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton.filled(
                      tooltip: 'Kirim',
                      style: IconButton.styleFrom(
                        backgroundColor: XpColors.primary,
                        foregroundColor: XpColors.textOnBrand,
                        disabledBackgroundColor: XpColors.sunken,
                        disabledForegroundColor: XpColors.textPlaceholder,
                      ),
                      onPressed: ready && !sending ? onSend : null,
                      icon: const Icon(Icons.send_rounded, size: 20),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyRoom extends StatelessWidget {
  const _EmptyRoom();

  @override
  Widget build(BuildContext context) {
    return const XpEmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'Belum ada pesan.',
      message: 'Tulis pertanyaanmu ke penjual di bawah.',
    );
  }
}
