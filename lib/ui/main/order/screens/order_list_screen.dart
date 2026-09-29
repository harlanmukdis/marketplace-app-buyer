import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_list_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// "Pesanan Saya" (desain §3.12 `pesanan_saya_xpedia_buyer_2`).
///
/// Yang sengaja tidak dibangun dari desain:
/// - **kolom cari pesanan** dan tombol filter — tidak ada endpoint pencarian
///   pesanan, dan `GET /orders` mengabaikan parameter apa pun selain `page`;
/// - **angka di tiap tab** — tanpa `meta.total`, angkanya hanya batas bawah
///   dari halaman yang sudah dimuat (lihat [OrderListCubit]);
/// - **foto & nama barang di kartu** — daftar pesanan tidak membawa `items`;
/// - kartu "Buyer Shield" — merek perlindungan yang tidak ada di daftar
///   merek resmi, dan tanpa ketentuan yang benar-benar ditegakkan server.
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key, this.onLogoTap});

  /// Diisi saat layar ini jadi tab di `HomeLayout`: app bar memakai logo
  /// sebagai tombol Beranda dan tanpa tombol kembali.
  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderListCubit()..load(),
      child: _OrderListBody(onLogoTap: onLogoTap),
    );
  }
}

class _OrderListBody extends StatefulWidget {
  const _OrderListBody({required this.onLogoTap});

  final VoidCallback? onLogoTap;

  @override
  State<_OrderListBody> createState() => _OrderListBodyState();
}

class _OrderListBodyState extends State<_OrderListBody> {
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

  /// Gulir tak berujung hanya di "Semua". Di tab lain, satu halaman bisa
  /// tidak menambah satu baris pun, jadi pemuatan diserahkan ke pemuatan
  /// otomatis cubit dan tombol "Muat lebih banyak".
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = OrderListCubit.get(context);
    if (cubit.filter != OrderListFilter.all) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) cubit.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    const actions = [SupportActionButton(), CartActionButton()];
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: widget.onLogoTap != null
          ? XpTabAppBar(title: 'Pesanan Saya', onLogoTap: widget.onLogoTap, actions: actions)
          : const XpStackAppBar(title: 'Pesanan Saya', actions: actions),
      body: BlocConsumer<OrderListCubit, OrderListState>(
        listenWhen: (previous, current) => current is OrderListLoaded,
        listener: (context, state) {
          final orders = (state as OrderListLoaded).orders;
          context.read<StoreDirectoryCubit>().ensure(orders.map((o) => o.storeId));
        },
        builder: (context, state) {
          final cubit = OrderListCubit.get(context);
          return Column(
            children: [
              _StatusTabs(
                selected: cubit.filter,
                onSelected: cubit.setFilter,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: cubit.refresh,
                  child: switch (state) {
                    OrderListLoading() => const Center(child: CircularProgressIndicator()),
                    OrderListError(:final error) => _Scrollable(
                        child: XpEmptyState(
                          icon: Icons.cloud_off_outlined,
                          title: 'Gagal memuat pesanan',
                          message: errorMessageFor(context, error),
                          actionLabel: 'Coba Lagi',
                          onAction: cubit.refresh,
                        ),
                      ),
                    OrderListEmpty() => _Scrollable(
                        child: XpEmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: 'Belum ada pesanan',
                          message: 'Pesanan yang kamu buat akan muncul di sini.',
                          actionLabel: 'Mulai Belanja',
                          onAction: () => context.go(AppRoutes.homeLayout),
                        ),
                      ),
                    OrderListLoaded() => _List(state: state, controller: _scrollController),
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Tab status berbentuk pil (§2.4 "Order status tabs").
class _StatusTabs extends StatelessWidget {
  const _StatusTabs({required this.selected, required this.onSelected});

  final OrderListFilter selected;
  final ValueChanged<OrderListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XpColors.surface,
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: OrderListFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = OrderListFilter.values[index];
          final active = filter == selected;
          return Semantics(
            selected: active,
            button: true,
            child: InkWell(
              onTap: () => onSelected(filter),
              borderRadius: BorderRadius.circular(XpRadius.full),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? XpColors.primary : XpColors.surface,
                  borderRadius: BorderRadius.circular(XpRadius.full),
                  border: Border.all(
                      color: active ? XpColors.primary : XpColors.borderSubtle),
                ),
                child: Text(
                  filter.label,
                  style: XpText.labelM(context).copyWith(
                    color: active ? Colors.white : XpColors.textSecondary,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.state, required this.controller});

  final OrderListLoaded state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final orders = state.visibleOrders;
    if (orders.isEmpty && !state.hasMore && !state.isLoadingMore) {
      return _Scrollable(
        child: XpEmptyState(
          icon: Icons.inventory_2_outlined,
          title: 'Tidak ada pesanan "${state.filter.label}"',
          message: 'Pesanan dengan status ini akan muncul di sini.',
          actionLabel: 'Lihat Semua Pesanan',
          onAction: () => OrderListCubit.get(context).setFilter(OrderListFilter.all),
        ),
      );
    }
    return ListView.separated(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: orders.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == orders.length) return _footer(context, orders.isEmpty);
        return _OrderCard(order: orders[index]);
      },
    );
  }

  Widget _footer(BuildContext context, bool nothingYet) {
    final cubit = OrderListCubit.get(context);
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final error = state.loadMoreError;
    if (error != null) {
      return Center(
        child: TextButton.icon(
          onPressed: cubit.showMore,
          icon: const Icon(Icons.refresh),
          label: Text(errorMessageFor(context, error)),
        ),
      );
    }
    if (!state.hasMore) return const SizedBox(height: 8);
    return Column(
      children: [
        if (nothingYet)
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              'Belum ada pesanan "${state.filter.label}" di ${state.orders.length} '
              'pesanan terbarumu.',
              textAlign: TextAlign.center,
              style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
            ),
          ),
        OutlinedButton(onPressed: cubit.showMore, child: const Text('Muat lebih banyak')),
      ],
    );
  }
}

/// Kartu pesanan, dengan kaki bergaya `_2`: total di baris pertama, tombol
/// di baris kedua rata kanan.
class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    void openDetail() => context.push(AppRoutes.orderDetailPath(order.id));
    return XpCard(
      onTap: openDetail,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderStoreName(storeId: order.storeId),
                    const SizedBox(height: 2),
                    Text(
                      '${order.orderNumber} • ${formatServerDate(order.createdAt)}',
                      style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OrderStatusPill(order: order),
            ],
          ),
          const Divider(height: 20),
          _ContextStrip(order: order),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(child: OrderSupportButton(orderId: order.id, compact: true)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order.isCompleted ? 'Total Pembayaran' : 'Total Pesanan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XpText.caption(context).copyWith(color: XpColors.textSecondary),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(formatRupiah(order.grandTotal), style: XpText.priceM(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Footer kolom ala `pesanan_saya_xpedia_buyer_2`: tombol aksi berbagi
          // lebar rata dalam satu baris — versi `_1` yang memuat total dan
          // tombol di satu baris meluap ("Rp 16…"). Xpedia 911 pindah ke baris
          // total supaya label tombol tidak terbungkus dua baris.
          Row(
            children: [
              for (final (i, action) in _actions(context, openDetail).indexed) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: action),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Aksi per status. Semua yang butuh data yang tidak ada di daftar
  /// (id baris untuk ulasan) diarahkan ke detail.
  ///
  /// "Bayar Sekarang" langsung membuka layar pembayaran kalau id transaksinya
  /// diketahui (`OrderModel.payableTransactionId`: field server yang
  /// diusulkan, atau tautan lokal sejak checkout); selain itu ke detail, yang
  /// menjelaskan tenggatnya.
  List<Widget> _actions(BuildContext context, VoidCallback openDetail) {
    if (order.awaitsPayment) {
      final txId = order.payableTransactionId;
      return [
        OutlinedButton(
          onPressed: () => context.push(AppRoutes.orderCancelPath(order.id)),
          child: const Text('Batalkan'),
        ),
        FilledButton(
          onPressed: txId == null ? openDetail : () => context.push(AppRoutes.paymentPath(txId)),
          child: const Text('Bayar Sekarang'),
        ),
      ];
    }
    switch (order.status) {
      case OrderStatus.paid:
      case OrderStatus.processed:
      case OrderStatus.packed:
        return [
          if (order.canCancel)
            OutlinedButton(
              onPressed: () => context.push(AppRoutes.orderCancelPath(order.id)),
              child: const Text('Batalkan Pesanan'),
            ),
          FilledButton.tonal(onPressed: openDetail, child: const Text('Rincian')),
        ];
      case OrderStatus.shipped:
        return [
          OutlinedButton(onPressed: openDetail, child: const Text('Rincian')),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.orderTrackingPath(order.id)),
            icon: const Icon(Icons.location_on_outlined, size: 18),
            label: const Text('Lacak Paket'),
          ),
        ];
      case OrderStatus.completed:
        return [
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.orderInvoicePath(order.id)),
            icon: const Icon(Icons.receipt_long_outlined, size: 18),
            label: const Text('Invoice'),
          ),
          FilledButton(onPressed: openDetail, child: const Text('Beri Ulasan')),
        ];
      default:
        return [OutlinedButton(onPressed: openDetail, child: const Text('Lihat Detail'))];
    }
  }
}

/// Strip konteks di bawah kepala kartu, hanya dari data yang benar-benar
/// dimuat daftar. Estimasi kirim ("sebelum 16 Mar, 18:00") tidak ada di API,
/// jadi tidak ditulis.
class _ContextStrip extends StatelessWidget {
  const _ContextStrip({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final (icon, text, bg) = switch (order) {
      _ when order.awaitsPayment => (
          Icons.schedule,
          // Waktu absolut, bukan hitung mundur — lihat `formatCountdown`.
          formatServerDeadline(order.paymentDeadline, prefix: 'Bayar sebelum'),
          XpColors.warningSubtle,
        ),
      _ when order.awaitsSellerConfirmation => (
          Icons.hourglass_top,
          'Menunggu konfirmasi penjual untuk pesanan custom.',
          XpColors.warningSubtle,
        ),
      _ when order.awaitsPartialDecision => (
          Icons.rule,
          'Penjual mengusulkan kirim sebagian. Buka rincian untuk memilih.',
          XpColors.warningSubtle,
        ),
      _ => switch (order.status) {
          OrderStatus.pending => (
              Icons.timer_off_outlined,
              'Batas waktu pembayaran sudah lewat.',
              XpColors.sunken,
            ),
          OrderStatus.paid || OrderStatus.processed || OrderStatus.packed => (
              Icons.inventory_2_outlined,
              'Penjual sedang menyiapkan pesananmu.',
              XpColors.warningSubtle,
            ),
          OrderStatus.shipped => (
              Icons.local_shipping_outlined,
              [
                courierLabelOf(order.courierCode, order.courierService),
                order.trackingNumber,
              ].whereType<String>().join(' • '),
              XpColors.sunken,
            ),
          OrderStatus.delivered => (
              Icons.inventory_outlined,
              'Paket sudah sampai. Konfirmasi di rincian pesanan.',
              XpColors.sunken,
            ),
          OrderStatus.completed => (
              Icons.check_circle_outline,
              'Pesanan selesai.',
              XpColors.sunken,
            ),
          _ => (Icons.info_outline, order.statusLabel, XpColors.sunken),
        },
    };
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(XpRadius.m),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: XpColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: XpText.bodyS(context))),
        ],
      ),
    );
  }
}

/// Membungkus pesan agar tetap bisa ditarik untuk refresh.
class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: constraints.maxHeight, child: child),
      ),
    );
  }
}
