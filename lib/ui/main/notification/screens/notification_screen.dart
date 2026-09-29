import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/notification/cubit/notification_cubit.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Kotak masuk notifikasi.
///
/// ⚠️ **Keadaan kosong masih kasus yang paling sering.** Satu-satunya
/// notifikasi yang kini terbit untuk pembeli adalah
/// [_securePlusShippedType] — kode segel paket Secure+ — jadi layar ini
/// dirancang agar kosong pun tetap menjelaskan dirinya, bukan menampilkan
/// daftar hampa yang terlihat seperti gagal memuat.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit()..load(),
      child: const _NotificationBody(),
    );
  }
}

/// `type` notifikasi "paket Secure+ dikirim" (`Order_model::ship()`), dengan
/// `data = {order_id, seal_code}`.
///
/// Ditangani di layar, bukan lewat `NotificationKind`: golongan itu hanya
/// memilih ikon (dan sudah memetakannya ke `shipment` karena mengandung
/// "ship"), sedangkan notifikasi ini membawa **kode segel yang wajib
/// dimasukkan pembeli saat konfirmasi terima** — ia butuh kartunya sendiri.
const String _securePlusShippedType = 'order_shipped_secure_plus';

class _NotificationBody extends StatefulWidget {
  const _NotificationBody();

  @override
  State<_NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<_NotificationBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      NotificationCubit.get(context).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: XpStackAppBar(
        title: 'Notifikasi',
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is! NotificationLoaded || state.unreadCount == 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: state.isSubmitting
                    ? null
                    : () => NotificationCubit.get(context).markAllRead(),
                child: const Text('Tandai semua'),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listenWhen: (previous, current) =>
            current is NotificationLoaded && current.actionError != null,
        listener: (context, state) {
          final error = (state as NotificationLoaded).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessageFor(context, error))),
            );
          NotificationCubit.get(context).clearActionError();
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => NotificationCubit.get(context).refresh(),
            child: switch (state) {
              NotificationLoading() =>
                const Center(child: CircularProgressIndicator()),
              NotificationError(:final error) => _Scrollable(
                  child: XpEmptyState(
                    icon: Icons.cloud_off_rounded,
                    title: 'Notifikasi gagal dimuat',
                    message: errorMessageFor(context, error),
                    actionLabel: 'Coba Lagi',
                    onAction: () => NotificationCubit.get(context).refresh(),
                  ),
                ),
              NotificationEmpty() => _Scrollable(
                  child: XpEmptyState(
                    icon: Icons.notifications_none,
                    title: 'Belum ada notifikasi',
                    message: 'Kabar penting tentang pesananmu akan muncul '
                        'di sini.',
                    actionLabel: 'Mulai Belanja',
                    onAction: () => context.go(AppRoutes.homeLayout),
                  ),
                ),
              NotificationLoaded() =>
                _List(state: state, controller: _scrollController),
            },
          );
        },
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.state, required this.controller});

  final NotificationLoaded state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return _UnreadHeader(state: state);
        if (index == state.notifications.length + 1) return _footer(context);
        final notification = state.notifications[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: notification.typeCode == _securePlusShippedType
              ? _SealCodeCard(notification: notification)
              : _NotificationTile(notification: notification),
        );
      },
    );
  }

  Widget _footer(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final error = state.loadMoreError;
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: TextButton.icon(
            onPressed: () => NotificationCubit.get(context).loadMore(),
            icon: const Icon(Icons.refresh),
            label: Text(errorMessageFor(context, error)),
          ),
        ),
      );
    }
    return const SizedBox(height: 16);
  }
}

class _UnreadHeader extends StatelessWidget {
  const _UnreadHeader({required this.state});

  final NotificationLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.unreadCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        // `unreadLabel` menambahkan "+" selama masih ada halaman yang belum
        // dimuat: tidak ada endpoint penghitung di backend, jadi angkanya
        // hanya batas bawah dan tidak boleh ditampilkan seolah pasti.
        '${state.unreadLabel} belum dibaca',
        style: XpText.labelL(context).copyWith(color: XpColors.primary),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final unread = notification.isUnread;

    return XpCard(
      // Yang belum dibaca diberi latar, bukan hanya titik kecil — ia harus
      // terbaca sekilas tanpa memindai tiap baris.
      color: unread ? XpColors.primarySubtle : null,
      padding: const EdgeInsets.all(12),
      onTap: () => _openNotification(context, notification),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconTile(icon: _iconFor(notification.kind)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: unread
                      ? XpText.titleM(context)
                      : XpText.labelL(context),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.body,
                  style: XpText.bodyS(context)
                      .copyWith(color: XpColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Text(
                  formatServerDateTime(notification.createdAt),
                  style: XpText.caption(context)
                      .copyWith(color: XpColors.textTertiary),
                ),
              ],
            ),
          ),
          if (unread) const _UnreadDot(),
        ],
      ),
    );
  }

  static IconData _iconFor(NotificationKind kind) => switch (kind) {
        NotificationKind.order => Icons.receipt_long_outlined,
        NotificationKind.payment => Icons.payments_outlined,
        NotificationKind.shipment => Icons.local_shipping_outlined,
        NotificationKind.chat => Icons.chat_bubble_outline,
        NotificationKind.promo => Icons.local_offer_outlined,
        NotificationKind.account => Icons.person_outline,
        NotificationKind.other => Icons.notifications_none,
      };
}

/// Kartu kode segel paket Secure+.
///
/// 🔴 **Notifikasi ini saluran resmi kode segel ke pembeli.** Konfirmasi
/// terima pesanan Secure+ menuntut `seal_code` (salah → `INVALID_SEAL_CODE`,
/// dan server membatasi 5 percobaan per 15 menit), sementara detail pesanan
/// tidak membawanya. Karena itu kodenya ditonjolkan dan bisa disalin, bukan
/// hanya terselip di kalimat `body`.
class _SealCodeCard extends StatelessWidget {
  const _SealCodeCard({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final raw = notification.data?['seal_code'];
    final sealCode = raw == null ? '' : '$raw'.trim();
    final orderId = notification.orderId;
    final unread = notification.isUnread;

    return XpCard(
      borderColor: XpColors.primary,
      padding: const EdgeInsets.all(16),
      onTap: () => NotificationCubit.get(context).markRead(notification.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _IconTile(icon: Icons.verified_user_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title.isEmpty
                          ? 'Paket Secure+ dalam perjalanan'
                          : notification.title,
                      style: XpText.titleM(context),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatServerDateTime(notification.createdAt),
                      style: XpText.caption(context)
                          .copyWith(color: XpColors.textTertiary),
                    ),
                  ],
                ),
              ),
              if (unread) const _UnreadDot(),
            ],
          ),
          const SizedBox(height: 12),
          if (sealCode.isEmpty)
            // Tanpa kode, kalimat dari server tetap satu-satunya petunjuk —
            // lebih baik ditampilkan daripada kartu yang kosong.
            Text(
              notification.body,
              style:
                  XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
            )
          else ...[
            Text(
              'Kode segel',
              style: XpText.labelM(context)
                  .copyWith(color: XpColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 4, 4),
              decoration: BoxDecoration(
                color: XpColors.primarySubtle,
                borderRadius: BorderRadius.circular(XpRadius.m),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      sealCode,
                      style: XpText.headingM(context).copyWith(
                        color: XpColors.navy,
                        letterSpacing: 2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  TextButton.icon(
                    style:
                        TextButton.styleFrom(minimumSize: const Size(48, 48)),
                    onPressed: () => _copy(context, sealCode),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Salin'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wajib dimasukkan saat mengonfirmasi paket diterima. Jangan '
              'bagikan kode ini ke siapa pun, termasuk kurir.',
              style:
                  XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
            ),
          ],
          if (orderId != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style:
                    OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: () => _openNotification(context, notification),
                child: const Text('Lihat Pesanan'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _copy(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    NotificationCubit.get(context).markRead(notification.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Kode segel disalin.')));
  }
}

/// Menandai terbaca, lalu membuka tujuannya kalau ada.
///
/// Barisnya tetap bisa ditekan walau tanpa tujuan — menekannya adalah cara
/// menandai terbaca satu per satu, dan itu satu-satunya cara selain "tandai
/// semua".
void _openNotification(BuildContext context, NotificationModel notification) {
  NotificationCubit.get(context).markRead(notification.id);

  final orderId = notification.orderId;
  if (orderId != null) {
    context.push(AppRoutes.orderDetailPath(orderId));
    return;
  }
  final productId = notification.productId;
  if (productId != null) {
    context.push(AppRoutes.productDetailPath(productId));
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: XpColors.surface,
        borderRadius: BorderRadius.circular(XpRadius.m),
        border: Border.all(color: XpColors.borderSubtle),
      ),
      child: Icon(icon, size: 20, color: XpColors.primary),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 8, top: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: XpColors.primary, shape: BoxShape.circle),
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
