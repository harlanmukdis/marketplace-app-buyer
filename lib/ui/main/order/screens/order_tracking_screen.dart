import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Lacak Paket (desain §3.17 `lacak_paket_jne_reguler` + b32).
///
/// Linimasa "Detail Perjalanan" dibaca dari `tracking_history`. ⚠️ Kolom itu
/// **belum pernah ditulis backend**; field-nya diusulkan dan di build debug
/// disisipkan mock ke respons `GET /orders/{id}/tracking` yang sungguhan
/// (ditandai `SimulatedBadge`). Tanpa riwayat kurir, linimasa jatuh ke
/// riwayat status pesanan plus dua stempel waktu pengiriman (`shipped_at`,
/// `delivered_at`) — dan layarnya mengatakannya terus terang.
///
/// Dihilangkan dari desain: peta dan pin kurir (tidak ada data lokasi),
/// nama/telepon kurir, estimasi tiba, tombol "Hubungi JNE", dan baris
/// "Data pelacakan disinkronkan langsung via API resmi" (tidak benar).
///
/// Memakai [OrderDetailCubit] yang sama dengan detail: cubit itu sudah
/// memuat `GET /orders/{id}/tracking` untuk pesanan yang sudah dikirim,
/// beserta status Secure+.
class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderDetailCubit(orderId)..load(),
      child: Scaffold(
        backgroundColor: XpColors.canvas,
        appBar: const XpStackAppBar(title: 'Lacak Paket', actions: [SupportActionButton()]),
        body: BlocConsumer<OrderDetailCubit, OrderDetailState>(
          listenWhen: (previous, current) =>
              previous is! OrderDetailLoaded && current is OrderDetailLoaded,
          listener: (context, state) => context
              .read<StoreDirectoryCubit>()
              .ensure([(state as OrderDetailLoaded).order.storeId]),
          builder: (context, state) => switch (state) {
            OrderDetailLoading() => const Center(child: CircularProgressIndicator()),
            OrderDetailError(:final error) => OrderLoadError(
                error: error,
                onRetry: () => OrderDetailCubit.get(context).load(),
              ),
            OrderDetailLoaded() => _Loaded(state: state),
          },
        ),
      ),
    );
  }
}

class _Loaded extends StatefulWidget {
  const _Loaded({required this.state});

  final OrderDetailLoaded state;

  @override
  State<_Loaded> createState() => _LoadedState();
}

class _LoadedState extends State<_Loaded> {
  /// Linimasa bisa dilipat jadi peristiwa terbaru saja (ikon `expand_less`
  /// di desain).
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final order = state.order;
    final tracking = state.tracking;
    final courierHistory = tracking?.trackingHistory ?? const <TrackingEventModel>[];
    final hasCourierHistory = courierHistory.isNotEmpty;
    final allEvents = _events(order, tracking);
    final events = _collapsed ? allEvents.take(1).toList() : allEvents;
    final delivered = tracking?.deliveredAt != null ||
        order.status == OrderStatus.delivered ||
        order.status == OrderStatus.completed;

    return RefreshIndicator(
      onRefresh: OrderDetailCubit.get(context).load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _CourierCard(
            order: order,
            tracking: tracking,
            securePlus: (state.insurance?.isSecurePlus ?? false) && state.insurance!.isActive,
          ),
          const SizedBox(height: 16),
          XpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.route_outlined, size: 20, color: XpColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(hasCourierHistory ? 'Detail Perjalanan' : 'Riwayat Pesanan',
                          style: XpText.titleL(context)),
                    ),
                    if (hasCourierHistory) SimulatedBadge(meta: state.trackingMeta),
                    if (allEvents.length > 1)
                      IconButton(
                        tooltip: _collapsed ? 'Tampilkan semua' : 'Ringkas',
                        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                        onPressed: () => setState(() => _collapsed = !_collapsed),
                        icon: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
                      ),
                  ],
                ),
                if (!hasCourierHistory) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Riwayat perjalanan dari kurir belum tersedia. Yang tampil di sini '
                    'adalah perubahan status pesanan dan waktu serah terima paket.',
                    style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                  ),
                ],
                const SizedBox(height: 16),
                for (var i = 0; i < events.length; i++)
                  _EventRow(
                    event: events[i],
                    current: i == 0,
                    delivered: delivered,
                    isLast: i == events.length - 1,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          XpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alamat Pengiriman Tujuan', style: XpText.titleM(context)),
                const SizedBox(height: 8),
                OrderAddressBlock(address: order.shippingAddress),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: OrderStoreName(storeId: order.storeId)),
              OrderChatStoreButton(storeId: order.storeId),
            ],
          ),
          const SizedBox(height: 16),
          OrderSupportButton(orderId: order.id),
        ],
      ),
    );
  }

  /// Peristiwa terbaru di atas.
  ///
  /// Dengan riwayat kurir: peristiwa kurir **menggantikan** riwayat status
  /// sejak paket dikirim (keduanya menceritakan hal yang sama), sedangkan
  /// tahap sebelum kirim — dibuat, dibayar, dikemas — tetap dari riwayat
  /// status, seperti linimasa di desain yang dimulai dari "Pesanan telah
  /// dibuat".
  ///
  /// Tanpa riwayat kurir: stempel pengiriman hanya ditambahkan kalau riwayat
  /// status belum mencatat hal yang sama, supaya tidak tampil dobel.
  static List<_Event> _events(OrderModel order, OrderTrackingModel? tracking) {
    final courier = tracking?.trackingHistory ?? const <TrackingEventModel>[];
    if (courier.isNotEmpty) {
      const beforeShipping = {
        OrderStatus.paid,
        OrderStatus.processed,
        OrderStatus.packed,
      };
      final events = <_Event>[
        if (order.createdAt != null)
          _Event('Pesanan dibuat', order.createdAt!, Icons.receipt_long_outlined),
        for (final h in order.statusHistory)
          if (h.createdAt != null && beforeShipping.contains(h.status))
            _Event(_historyTitle(h), h.createdAt!, _historyIcon(h.status)),
        for (final e in courier)
          if (e.occurredAt != null)
            _Event(e.description, e.occurredAt!, _courierIcon(e.status), location: e.location),
      ];
      events.sort((a, b) => b.at.compareTo(a.at));
      return events;
    }
    final events = <_Event>[
      if (order.createdAt != null)
        _Event('Pesanan dibuat', order.createdAt!, Icons.receipt_long_outlined),
      for (final h in order.statusHistory)
        if (h.createdAt != null) _Event(_historyTitle(h), h.createdAt!, _historyIcon(h.status)),
    ];
    bool has(OrderStatus s) => order.statusHistory.any((h) => h.status == s);
    final shippedAt = tracking?.shippedAt;
    if (shippedAt != null && !has(OrderStatus.shipped)) {
      events.add(_Event('Paket diserahkan ke kurir', shippedAt, Icons.local_shipping_outlined));
    }
    final deliveredAt = tracking?.deliveredAt;
    if (deliveredAt != null && !has(OrderStatus.delivered)) {
      events.add(_Event('Paket sampai tujuan', deliveredAt, Icons.inventory_outlined));
    }
    events.sort((a, b) => b.at.compareTo(a.at));
    return events;
  }

  static String _historyTitle(OrderStatusHistoryModel h) => switch (h.status) {
        OrderStatus.paid => 'Pembayaran berhasil',
        OrderStatus.processed || OrderStatus.packed => 'Pesanan dikemas penjual',
        OrderStatus.shipped => 'Paket diserahkan ke kurir',
        OrderStatus.delivered => 'Paket diterima',
        OrderStatus.completed => 'Pesanan selesai',
        OrderStatus.cancelled => 'Pesanan dibatalkan',
        _ => h.label,
      };

  static IconData _historyIcon(OrderStatus s) => switch (s) {
        OrderStatus.paid => Icons.payments_outlined,
        OrderStatus.processed || OrderStatus.packed => Icons.inventory_2_outlined,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.delivered => Icons.inventory_outlined,
        OrderStatus.completed => Icons.check_circle_outline,
        OrderStatus.cancelled => Icons.cancel_outlined,
        _ => Icons.circle_outlined,
      };

  static IconData _courierIcon(String status) => switch (status) {
        'picked_up' => Icons.inventory_2_outlined,
        'delivered' => Icons.home_outlined,
        'returned' => Icons.assignment_return_outlined,
        _ => Icons.local_shipping_outlined,
      };
}

class _Event {
  const _Event(this.title, this.at, this.icon, {this.location});

  final String title;
  final DateTime at;
  final IconData icon;

  /// Hanya untuk peristiwa kurir.
  final String? location;
}

class _CourierCard extends StatelessWidget {
  const _CourierCard({required this.order, required this.tracking, this.securePlus = false});

  final OrderModel order;
  final OrderTrackingModel? tracking;

  /// Polis Secure+ aktif untuk pesanan ini.
  final bool securePlus;

  @override
  Widget build(BuildContext context) {
    final t = tracking;
    final courier = t == null
        ? courierLabelOf(order.courierCode, order.courierService)
        : courierLabelOf(t.courierCode, t.serviceType);
    final awb = t?.awbNumber ?? order.trackingNumber;
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 40,
                decoration: BoxDecoration(
                  color: XpColors.primarySubtle,
                  borderRadius: BorderRadius.circular(XpRadius.m),
                ),
                child: Icon(Icons.local_shipping_outlined, color: XpColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(courier ?? 'Kurir belum dipilih', style: XpText.titleM(context)),
                    if (t?.handoverMethod != null)
                      Text(
                        t!.handoverMethod == 'pickup'
                            ? 'Dijemput kurir'
                            : 'Diantar penjual ke agen',
                        style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                      ),
                  ],
                ),
              ),
              if (t != null)
                XpPill(
                  label: t.statusLabel,
                  tone: t.status == 'delivered'
                      ? XpOrderTones.delivered
                      : t.status == 'returned' || t.status == 'lost'
                          ? XpTone(XpColors.dangerSubtle, XpColors.danger)
                          : XpOrderTones.shipping,
                  large: true,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            decoration: BoxDecoration(
              color: XpColors.sunken,
              borderRadius: BorderRadius.circular(XpRadius.m),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NO. RESI', style: XpText.overline(context)),
                      Text(awb ?? 'Resi belum dibuat penjual',
                          style: XpText.titleM(context)),
                    ],
                  ),
                ),
                if (awb != null)
                  TextButton.icon(
                    onPressed: () => copyWithToast(context, awb, 'Nomor resi berhasil disalin'),
                    icon: const Icon(Icons.content_copy, size: 16),
                    label: const Text('Salin'),
                  )
                else
                  const SizedBox(height: 48),
              ],
            ),
          ),
          if (securePlus) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.verified_user, size: 20, color: XpColors.signatureGold),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Xpedia Secure+ Terproteksi', style: XpText.titleM(context)),
                      Text('Penerimaan dikonfirmasi dengan kode segel dari notifikasi.',
                          style: XpText.caption(context)
                              .copyWith(color: XpColors.textTertiary)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Satu simpul linimasa vertikal (§2.4). Kalau paket sudah diterima,
/// seluruh simpul hijau seperti varian b32.
class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.event,
    required this.current,
    required this.delivered,
    required this.isLast,
  });

  final _Event event;
  final bool current;
  final bool delivered;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Color accent = delivered ? XpColors.success : XpColors.primary;
    final Color nodeBg = delivered
        ? XpColors.success
        : current
            ? XpColors.primary
            : XpColors.primarySubtle;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: nodeBg, shape: BoxShape.circle),
                  child: delivered || current
                      ? Icon(delivered ? Icons.check : event.icon, size: 20, color: Colors.white)
                      : Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: XpColors.borderDefault, shape: BoxShape.circle),
                          ),
                        ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: delivered ? XpColors.success : XpColors.borderSubtle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: XpText.titleM(context)
                          .copyWith(color: current ? accent : XpColors.textPrimary)),
                  Text(
                      [
                        if ((event.location ?? '').isNotEmpty) event.location!,
                        formatServerDateTime(event.at),
                      ].join(' • '),
                      style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
