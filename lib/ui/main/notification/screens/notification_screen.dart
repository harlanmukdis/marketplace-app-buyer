import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/domain/model/notification/notification_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/notification/cubit/notification_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Kotak masuk notifikasi.
///
/// ⚠️ **Keadaan kosong adalah kasus normalnya.** Backend belum menerbitkan
/// notifikasi apa pun untuk pembeli (lihat `NotificationService`), jadi layar
/// ini dirancang agar kosong pun tetap menjelaskan dirinya — bukan menampilkan
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
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(
        context,
        'Notifikasi',
        action: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is! NotificationLoaded || state.unreadCount == 0) {
              return const SizedBox.shrink();
            }
            return TextButton(
              onPressed: state.isSubmitting
                  ? null
                  : () => NotificationCubit.get(context).markAllRead(),
              child: const Text('Tandai semua'),
            );
          },
        ),
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
                  child: _Message(
                    icon: Icons.cloud_off_rounded,
                    title: errorMessageFor(context, error),
                    actionLabel: 'Coba lagi',
                    onAction: () => NotificationCubit.get(context).refresh(),
                  ),
                ),
              NotificationEmpty() => const _Scrollable(child: _EmptyInbox()),
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
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: state.notifications.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return _UnreadHeader(state: state);
        if (index == state.notifications.length + 1) return _footer(context);
        return _NotificationTile(notification: state.notifications[index - 1]);
      },
    );
  }

  Widget _footer(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final error = state.loadMoreError;
    if (error != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
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
    final dark = isAppDarkMode();

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: Text(
        // `unreadLabel` menambahkan "+" selama masih ada halaman yang belum
        // dimuat: tidak ada endpoint penghitung di backend, jadi angkanya
        // hanya batas bawah dan tidak boleh ditampilkan seolah pasti.
        '${state.unreadLabel} belum dibaca',
        style: AppStyles.styleMedium14(context).copyWith(
          color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final unread = notification.isUnread;
    final primary = dark ? kDarkPrimaryColor : kLightPrimaryColor;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsetsDirectional.all(12),
          decoration: BoxDecoration(
            // Yang belum dibaca diberi latar, bukan hanya titik kecil —
            // ia harus terbaca sekilas tanpa memindai tiap baris.
            color: unread ? primary.withValues(alpha: 0.06) : null,
            border: Border.all(color: dark ? kDarkThirdColor : kBorderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_iconFor(notification.kind), size: 20, color: primary),
              10.sbw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: (unread
                              ? AppStyles.styleSemiBold14(context)
                              : AppStyles.styleMedium14(context))
                          .copyWith(
                        color: dark ? kDarkSecondColor : kLightSecondColor,
                      ),
                    ),
                    4.sbh,
                    Text(
                      notification.body,
                      style: AppStyles.styleRegular12(context).copyWith(
                        color: dark ? kDarkThirdColor : kLightThirdColor,
                      ),
                    ),
                    6.sbh,
                    Text(
                      formatServerDateTime(notification.createdAt),
                      style: AppStyles.styleRegular11(context).copyWith(
                        color: dark ? kDarkThirdColor : kLightThirdColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (unread)
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 8, top: 4),
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: primary, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menandai terbaca, lalu membuka tujuannya kalau ada.
  ///
  /// Barisnya tetap bisa ditekan walau tanpa tujuan — menekannya adalah cara
  /// menandai terbaca satu per satu, dan itu satu-satunya cara selain "tandai
  /// semua".
  void _open(BuildContext context) {
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

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return const _Message(
      icon: Icons.notifications_none,
      title: 'Belum ada notifikasi.',
      subtitle: 'Kabar tentang pesanan dan promo akan muncul di sini.',
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
