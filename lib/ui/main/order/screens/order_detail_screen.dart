import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_cancellation_card.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Detail pesanan (desain §3.13 `detail_pesanan_selesai_xpedia_buyer` + b25).
///
/// **"Bayar Sekarang"** untuk pesanan `pending` memakai
/// `OrderModel.payableTransactionId`: field server yang diusulkan
/// (`payment_transaction_id`, belum dikirim `GET /orders/{id}`) atau tautan
/// yang diingat perangkat sejak checkout (`OrderPaymentLinkStore`). Pesanan
/// dari perangkat lain tidak punya keduanya, jadi yang tampil tetap tenggat
/// bayarnya.
///
/// Dua seksi berasal dari **kontrak yang diusulkan** (di-mock di debug,
/// ditandai `SimulatedBadge`): status permohonan pembatalan sesudah resi
/// (docs/22 #3) dan status polis Secure+ (`GET /orders/{id}/insurance`).
/// Opt-in Secure+ sendiri memakai endpoint sungguhan.
///
/// Dihilangkan dari desain karena datanya tidak ada di API:
/// - **metode pembayaran** ("Lunas (Xpedia Wallet)") — tidak tercatat di
///   order;
/// - **"Beli Lagi"** — baris pesanan hanya membawa `product_variant_id`,
///   tanpa jalan kembali ke produk;
/// - foto barang, SKU, dan chip stok di tiap barang.
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderDetailCubit(orderId)..load(),
      child: const _OrderDetailBody(),
    );
  }
}

class _OrderDetailBody extends StatefulWidget {
  const _OrderDetailBody();

  @override
  State<_OrderDetailBody> createState() => _OrderDetailBodyState();
}

class _OrderDetailBodyState extends State<_OrderDetailBody> {
  /// Kode segel yang terakhir dicoba. Membedakan "server minta kode" (belum
  /// pernah mengirim) dari "kodenya salah" (sudah mengirim).
  String? _lastSealCode;

  Future<void> _onActionError(BuildContext context, DataError error) async {
    final cubit = OrderDetailCubit.get(context);
    cubit.clearActionError();

    if (error.code == ApiErrorCode.invalidSealCode) {
      final code = await showDialog<String>(
        context: context,
        builder: (_) => _SealCodeDialog(wrongCode: _lastSealCode != null),
      );
      if (code == null || !mounted) return;
      _lastSealCode = code;
      await cubit.confirmDelivery(sealCode: code);
      return;
    }
    if (context.mounted) showOrderSnack(context, orderErrorMessage(context, error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Detail Pesanan', actions: [SupportActionButton()]),
      body: BlocConsumer<OrderDetailCubit, OrderDetailState>(
        listenWhen: (previous, current) =>
            (current is OrderDetailLoaded && current.actionError != null) ||
            (previous is! OrderDetailLoaded && current is OrderDetailLoaded),
        listener: (context, state) {
          final loaded = state as OrderDetailLoaded;
          context.read<StoreDirectoryCubit>().ensure([loaded.order.storeId]);
          final error = loaded.actionError;
          if (error != null) _onActionError(context, error);
        },
        builder: (context, state) => switch (state) {
          OrderDetailLoading() => const Center(child: CircularProgressIndicator()),
          OrderDetailError(:final error) => OrderLoadError(
              error: error,
              onRetry: () => OrderDetailCubit.get(context).load(),
            ),
          OrderDetailLoaded() => _Loaded(state: state),
        },
      ),
      bottomNavigationBar: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state is! OrderDetailLoaded) return const SizedBox.shrink();
          return _ActionBar(state: state);
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final OrderDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final cubit = OrderDetailCubit.get(context);
    final courier = courierLabelOf(order.courierCode, order.courierService);
    final resi = order.trackingNumber ?? state.tracking?.awbNumber;
    final canTrack =
        order.status == OrderStatus.shipped || order.status == OrderStatus.delivered;

    return RefreshIndicator(
      onRefresh: cubit.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          _StatusBanner(order: order),
          if (_showsTimeline(order))
            OrderSection(child: _StageTimeline(order: order)),
          if (state.cancellationRequest != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: CancellationRequestCard(
                request: state.cancellationRequest!,
                meta: state.cancellationMeta,
              ),
            ),
          if (order.awaitsPartialDecision) _PartialFulfillmentCard(state: state),
          if (order.hasInvoice)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: XpBanner(
                icon: Icons.receipt_long_outlined,
                title: 'Invoice Pesanan',
                message: 'Bukti transaksi resmi untuk pesanan yang sudah selesai.',
                trailing: const XpPill(label: 'Lunas', tone: XpOrderTones.completed),
                onTap: () => context.push(AppRoutes.orderInvoicePath(order.id)),
              ),
            ),
          OrderSection(
            child: Column(
              children: [
                _IdentifierRow(
                  label: 'Nomor Pesanan',
                  value: order.orderNumber,
                  onCopy: () => copyWithToast(
                      context, order.orderNumber, 'Nomor pesanan tersalin'),
                ),
                _IdentifierRow(
                  label: 'Tanggal Pembelian',
                  value: formatServerDateTime(order.createdAt),
                ),
                _IdentifierRow(label: 'Status Pembayaran', value: _paymentLabel(order)),
              ],
            ),
          ),
          OrderSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OrderStoreName(
                        storeId: order.storeId,
                        onTap: () => context.push(AppRoutes.storePath(order.storeId)),
                      ),
                    ),
                    OrderChatStoreButton(storeId: order.storeId),
                  ],
                ),
                const Divider(height: 16),
                for (final item in order.items)
                  OrderItemTile(
                    item: item,
                    dimmed: !item.isAvailable,
                    trailing: order.isCompleted
                        ? OutlinedButton.icon(
                            onPressed: () =>
                                context.push(AppRoutes.orderReviewPath(order.id, item.id)),
                            icon: const Icon(Icons.star_outline, size: 18),
                            label: const Text('Beri Ulasan'),
                          )
                        : null,
                  ),
              ],
            ),
          ),
          OrderSection(
            title: 'Informasi Pengiriman',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: XpColors.sunken,
                    borderRadius: BorderRadius.circular(XpRadius.m),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, color: XpColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(courier ?? 'Kurir belum dipilih',
                                style: XpText.titleM(context)),
                            Text(
                              // Resi baru terisi setelah penjual menyerahkan
                              // paket ke kurir.
                              resi == null ? 'Resi belum dibuat penjual' : 'Resi: $resi',
                              style: XpText.bodyS(context)
                                  .copyWith(color: XpColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (resi != null)
                        TextButton(
                          onPressed: () =>
                              copyWithToast(context, resi, 'Nomor resi berhasil disalin'),
                          child: const Text('Salin'),
                        ),
                    ],
                  ),
                ),
                if (canTrack) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.orderTrackingPath(order.id)),
                      icon: const Icon(Icons.location_on_outlined, size: 18),
                      label: const Text('Lacak Paket'),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                OrderAddressBlock(address: order.shippingAddress),
              ],
            ),
          ),
          if (state.evidence.isNotEmpty) _EvidenceSection(evidence: state.evidence),
          if (order.refund != null) _RefundSection(refund: order.refund!),
          // Dekat rincian pembayaran, seperti baris Secure+ di desain b25.
          _SecurePlusSection(state: state),
          OrderSection(
            title: 'Rincian Pembayaran',
            child: OrderCostSummary(
              subtotal: order.subtotal,
              shippingCost: order.shippingCost,
              discountTotal: order.discountTotal,
              grandTotal: order.grandTotal,
              itemCount: order.items.isEmpty ? null : order.totalQuantity,
            ),
          ),
          if (order.statusHistory.isNotEmpty)
            OrderSection(
              title: 'Riwayat Status',
              child: Column(
                children: [
                  for (final entry in order.statusHistory.reversed)
                    XpKeyValueRow(
                      label: entry.label,
                      value: shortServerDateTime(entry.createdAt),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OrderSupportButton(orderId: order.id),
          ),
        ],
      ),
    );
  }

  static bool _showsTimeline(OrderModel order) => switch (order.status) {
        OrderStatus.cancelled ||
        OrderStatus.refundRequested ||
        OrderStatus.refundApproved ||
        OrderStatus.refundRejected ||
        OrderStatus.unknown =>
          false,
        _ => true,
      };

  static String _paymentLabel(OrderModel order) {
    if (order.isPending) {
      return order.awaitsPayment ? 'Menunggu pembayaran' : 'Tidak dibayar';
    }
    if (order.isCancelled) {
      return orderWasPaid(order) ? 'Lunas, dikembalikan' : 'Tidak dibayar';
    }
    return 'Lunas';
  }
}

/// Banner status paling atas. Isinya hanya yang bisa dipastikan dari
/// status dan stempel waktu — tidak ada "estimasi tiba" karena server tidak
/// mengirimnya.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final p = orderStatusPresentation(order);
    final (icon, message) = _content();
    return Container(
      width: double.infinity,
      color: p.tone.background,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: p.tone.foreground, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.label,
                    style: XpText.titleL(context).copyWith(color: p.tone.foreground)),
                if (message != null) ...[
                  const SizedBox(height: 2),
                  Text(message, style: XpText.bodyS(context)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _completedMessage() {
    final at = order.statusHistory
        .where((h) => h.status == OrderStatus.completed)
        .map((h) => h.createdAt)
        .whereType<DateTime>()
        .firstOrNull;
    return at == null
        ? 'Pesanan selesai. Dana telah diteruskan ke penjual.'
        : 'Pesanan selesai pada ${formatServerDateTime(at)}. Dana telah diteruskan ke penjual.';
  }

  (IconData, String?) _content() {
    if (order.awaitsSellerConfirmation) {
      // SLA 48 jam dijalankan worker backend
      // (`order_custom_confirmation_sla_worker.php`), bukan dihitung di sini.
      return (
        Icons.hourglass_top,
        'Pesanan custom ini menunggu konfirmasi penjual, maksimal 48 jam sejak '
            'pembayaran. Jika tidak dikonfirmasi, pesanan dibatalkan otomatis dan '
            'dana kembali penuh ke Xpedia Wallet.',
      );
    }
    return switch (order.status) {
      OrderStatus.pending => order.awaitsPayment
          ? (
              Icons.schedule,
              order.payableTransactionId != null
                  ? '${formatServerDeadline(order.paymentDeadline, prefix: 'Selesaikan pembayaran sebelum')}.'
                  // Tanpa id transaksi (pesanan dari perangkat lain) layar
                  // pembayaran tidak bisa dibuka dari sini.
                  : '${formatServerDeadline(order.paymentDeadline, prefix: 'Selesaikan pembayaran sebelum')}. '
                      'Gunakan instruksi pembayaran yang kamu terima saat checkout.',
            )
          : (Icons.timer_off_outlined, 'Batas waktu pembayaran sudah lewat.'),
      OrderStatus.paid => (Icons.check, 'Pembayaran diterima. Menunggu penjual memproses.'),
      OrderStatus.processed ||
      OrderStatus.packed =>
        (Icons.inventory_2_outlined, 'Penjual sedang menyiapkan pesananmu.'),
      OrderStatus.shipped => (
          Icons.local_shipping_outlined,
          'Paket dalam perjalanan. Tekan "Pesanan Diterima" setelah paket sampai.',
        ),
      OrderStatus.delivered => (
          Icons.inventory_outlined,
          'Paket sudah diterima. Selesaikan pesanan jika semuanya sesuai, atau '
              'ajukan komplain jika ada masalah.',
        ),
      OrderStatus.completed => (Icons.check, _completedMessage()),
      OrderStatus.cancelled => (
          Icons.close,
          orderWasPaid(order)
              ? 'Pesanan dibatalkan. Dana dikembalikan ke Xpedia Wallet.'
              : 'Pesanan dibatalkan sebelum dibayar.',
        ),
      OrderStatus.refundRequested =>
        (Icons.assignment_return_outlined, 'Komplainmu sedang ditinjau.'),
      OrderStatus.refundApproved =>
        (Icons.check, 'Komplain disetujui. Dana dikembalikan ke Xpedia Wallet.'),
      OrderStatus.refundRejected => (Icons.close, 'Komplain tidak disetujui.'),
      OrderStatus.unknown => (Icons.info_outline, null),
    };
  }
}

/// Linimasa horizontal 5 tahap (6 untuk custom order), §2.4.
///
/// Tahap dibaca dari **status saat ini**, bukan dari `status_history`:
/// riwayat bisa melompati tahap (`processed` tidak pernah lagi ditulis
/// server sejak rute `accept` dihapus), sedangkan status selalu ada.
class _StageTimeline extends StatelessWidget {
  const _StageTimeline({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final custom = order.requiresCustomConfirmation;
    final stages = <(String, IconData)>[
      ('Dibayar', Icons.payments_outlined),
      if (custom) ('Menunggu Konfirmasi', Icons.hourglass_top),
      ('Diproses', Icons.inventory_2_outlined),
      ('Dikirim', Icons.local_shipping_outlined),
      ('Diterima', Icons.inventory_outlined),
      ('Selesai', Icons.check_circle_outline),
    ];
    final current = _currentIndex(custom);
    final dates = _dates(custom, stages.length);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stages.length; i++)
          Expanded(
            child: _Stage(
              label: stages[i].$1,
              icon: stages[i].$2,
              done: i < current || (i == current && order.isCompleted),
              active: i == current && !order.isCompleted,
              leftDone: i > 0 && i <= current,
              rightDone: i < current,
              isFirst: i == 0,
              isLast: i == stages.length - 1,
              date: dates[i],
            ),
          ),
      ],
    );
  }

  /// Indeks tahap yang sedang berjalan.
  int _currentIndex(bool custom) {
    final offset = custom ? 1 : 0;
    return switch (order.status) {
      OrderStatus.pending => 0,
      OrderStatus.paid => order.awaitsSellerConfirmation ? 1 : 1 + offset,
      OrderStatus.processed || OrderStatus.packed => 1 + offset,
      OrderStatus.shipped => 2 + offset,
      OrderStatus.delivered => 3 + offset,
      OrderStatus.completed => 4 + offset,
      _ => 0,
    };
  }

  List<String> _dates(bool custom, int length) {
    DateTime? at(Set<OrderStatus> statuses) => order.statusHistory
        .where((h) => statuses.contains(h.status))
        .map((h) => h.createdAt)
        .whereType<DateTime>()
        .firstOrNull;
    return [
      shortServerDateTime(at({OrderStatus.paid})),
      if (custom) shortServerDateTime(order.customConfirmedAt),
      shortServerDateTime(at({OrderStatus.processed, OrderStatus.packed})),
      shortServerDateTime(at({OrderStatus.shipped})),
      shortServerDateTime(at({OrderStatus.delivered})),
      shortServerDateTime(at({OrderStatus.completed})),
    ].take(length).toList();
  }
}

class _Stage extends StatelessWidget {
  const _Stage({
    required this.label,
    required this.icon,
    required this.done,
    required this.active,
    required this.leftDone,
    required this.rightDone,
    required this.isFirst,
    required this.isLast,
    required this.date,
  });

  final String label;
  final IconData icon;
  final bool done;
  final bool active;
  final bool leftDone;
  final bool rightDone;
  final bool isFirst;
  final bool isLast;
  final String date;

  @override
  Widget build(BuildContext context) {
    Color line(bool on) => on ? XpColors.success : XpColors.borderSubtle;
    final Color fill = done
        ? XpColors.success
        : active
            ? XpColors.primary
            : XpColors.surface;
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          height: 2, color: isFirst ? Colors.transparent : line(leftDone))),
                  Expanded(
                      child: Container(
                          height: 2, color: isLast ? Colors.transparent : line(rightDone))),
                ],
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: fill,
                  shape: BoxShape.circle,
                  border: done || active ? null : Border.all(color: XpColors.borderDefault),
                  boxShadow: active
                      ? [BoxShadow(color: XpColors.primarySubtle, spreadRadius: 4)]
                      : null,
                ),
                child: Icon(
                  done ? Icons.check : icon,
                  size: 16,
                  color: done || active ? Colors.white : XpColors.textPlaceholder,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: XpText.caption(context).copyWith(
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? XpColors.primary : XpColors.textSecondary,
          ),
        ),
        if (date.isNotEmpty)
          Text(date,
              textAlign: TextAlign.center,
              style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
      ],
    );
  }
}

/// Xpedia Secure+: status polis kalau sudah aktif, atau tawaran
/// mengaktifkannya untuk pesanan yang belum dikemas.
///
/// Teksnya **tidak pernah memakai kata "asuransi"** (aturan copy desain §5) —
/// selalu "perlindungan", walau tabel backend-nya
/// `shipping_insurance_policies`.
///
/// Premi yang ditampilkan adalah **perkiraan** 0,5% dari `grand_total` —
/// rumus fallback yang sama dengan `Insurance::opt_in_post`. Angka resminya
/// dari balasan opt-in, karena server yang menghitungnya.
class _SecurePlusSection extends StatelessWidget {
  const _SecurePlusSection({required this.state});

  final OrderDetailLoaded state;

  static const premiumRate = 0.005;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final policy = state.insurance;
    if (policy != null && policy.isSecurePlus && policy.isActive) {
      return OrderSection(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.verified_user, color: XpColors.signatureGold),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Xpedia Secure+ aktif', style: XpText.titleM(context)),
                  const SizedBox(height: 2),
                  Text(
                    'Penjual wajib merekam foto & video paket sebelum diserahkan ke '
                    'kurir, dan penerimaan dikonfirmasi dengan kode segel yang '
                    'dikirim saat paket berangkat.',
                    style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                  ),
                  if (policy.premiumAmount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Biaya perlindungan ${formatRupiah(policy.premiumAmount)}',
                          style: XpText.caption(context)
                              .copyWith(color: XpColors.textTertiary)),
                    ),
                ],
              ),
            ),
            SimulatedBadge(meta: state.insuranceMeta),
          ],
        ),
      );
    }
    if (!order.canOptInSecurePlus) return const SizedBox.shrink();

    final premium = (order.grandTotal * premiumRate).roundToDouble();
    return OrderSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: XpColors.signatureGold),
              const SizedBox(width: 12),
              Expanded(child: Text('Aktifkan Xpedia Secure+', style: XpText.titleM(context))),
              if (state.insuranceKnown) SimulatedBadge(meta: state.insuranceMeta),
            ],
          ),
          const SizedBox(height: 8),
          for (final line in const [
            'Penjual merekam foto & video paket sebelum diserahkan ke kurir.',
            'Paket dikonfirmasi diterima dengan kode segel yang hanya kamu terima.',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 16, color: XpColors.success),
                  const SizedBox(width: 8),
                  Expanded(child: Text(line, style: XpText.bodyS(context))),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(
            'Biaya perlindungan sekitar ${formatRupiah(premium)} (0,5% dari total pesanan). '
            'Hanya bisa diaktifkan sebelum penjual mengemas pesanan.',
            style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: state.isOptingIn ? null : () => _confirm(context, premium),
              icon: state.isOptingIn
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.verified_user_outlined, size: 18),
              label: const Text('Aktifkan Perlindungan'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context, double premium) async {
    final cubit = OrderDetailCubit.get(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Aktifkan Xpedia Secure+?'),
        content: Text(
          'Biaya perlindungan sekitar ${formatRupiah(premium)}. Setelah aktif, '
          'perlindungan tidak bisa dinonaktifkan, dan penerimaan paket wajib '
          'dikonfirmasi dengan kode segel.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Ya, Aktifkan'),
          ),
        ],
      ),
    );
    if (!(ok ?? false)) return;
    await cubit.optInSecurePlus();
    final latest = cubit.state;
    if (context.mounted &&
        latest is OrderDetailLoaded &&
        (latest.insurance?.isSecurePlus ?? false)) {
      showOrderSnack(context, 'Xpedia Secure+ aktif untuk pesanan ini.');
    }
  }
}

/// Usulan kirim sebagian dari penjual, menunggu jawaban pembeli.
class _PartialFulfillmentCard extends StatelessWidget {
  const _PartialFulfillmentCard({required this.state});

  final OrderDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final unavailable = state.order.items.where((i) => !i.isAvailable).toList();
    return OrderSection(
      title: 'Sebagian barang tidak tersedia',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Penjual tidak bisa mengirim ${unavailable.isEmpty ? 'sebagian barang' : '${unavailable.length} barang'} '
            'di pesanan ini. Pilih salah satu:',
            style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
          ),
          for (final item in unavailable)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('• ${item.productName} (${item.quantity} barang)',
                  style: XpText.bodyS(context)),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: state.canAct
                ? () => _confirm(context, PartialFulfillmentDecision.continuePartial)
                : null,
            child: const Text('Lanjutkan Kirim Sebagian'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: state.canAct
                ? () => _confirm(context, PartialFulfillmentDecision.cancelWhole)
                : null,
            child: const Text('Batalkan Seluruh Pesanan'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context, PartialFulfillmentDecision decision) async {
    final cubit = OrderDetailCubit.get(context);
    final partial = decision == PartialFulfillmentDecision.continuePartial;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(partial ? 'Lanjutkan kirim sebagian?' : 'Batalkan seluruh pesanan?'),
        content: Text(partial
            // Ongkir tidak ikut dikembalikan — `Order_model` hanya
            // mengembalikan subtotal barang yang tidak tersedia.
            ? 'Barang yang tersedia tetap dikirim. Harga barang yang tidak tersedia '
                'dikembalikan ke Xpedia Wallet; ongkos kirim tidak dikembalikan.'
            : 'Seluruh pesanan dibatalkan dan dana dikembalikan penuh ke Xpedia Wallet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Kembali'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(partial ? 'Ya, Lanjutkan' : 'Ya, Batalkan'),
          ),
        ],
      ),
    );
    if (ok ?? false) await cubit.respondPartialFulfillment(decision);
  }
}

/// Bukti serah terima Secure+. Hanya tampil kalau server memang punya isinya.
class _EvidenceSection extends StatelessWidget {
  const _EvidenceSection({required this.evidence});

  final List<ShipmentEvidenceModel> evidence;

  @override
  Widget build(BuildContext context) {
    return OrderSection(
      title: 'Bukti Pengemasan Secure+',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final e in evidence)
            InkWell(
              onTap: e.isVideo ? null : () => _preview(context, e.url),
              borderRadius: BorderRadius.circular(XpRadius.m),
              child: e.isVideo
                  ? Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: XpColors.sunken,
                        borderRadius: BorderRadius.circular(XpRadius.m),
                      ),
                      child: Icon(Icons.videocam_outlined, color: XpColors.textSecondary),
                    )
                  : XpProductImage(url: e.url, size: 72),
            ),
        ],
      ),
    );
  }

  void _preview(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(child: XpProductImage(url: url)),
    );
  }
}

class _RefundSection extends StatelessWidget {
  const _RefundSection({required this.refund});

  final OrderRefundModel refund;

  @override
  Widget build(BuildContext context) {
    final status = switch (refund.status) {
      'pending' => 'Sedang ditinjau penjual',
      // `resolve_refund` langsung mengkredit dompet lalu menandainya
      // `processed`, jadi `approved` praktis hanya sesaat.
      'approved' || 'processed' => 'Disetujui, dana dikembalikan ke Xpedia Wallet',
      'rejected' => 'Ditolak',
      _ => refund.status,
    };
    return OrderSection(
      title: 'Komplain & Refund',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XpKeyValueRow(label: 'Status', value: status),
          if (refund.amount > 0)
            XpKeyValueRow(label: 'Nominal', value: formatRupiah(refund.amount)),
          XpKeyValueRow(label: 'Diajukan', value: formatServerDateTime(refund.createdAt)),
          if ((refund.reason ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(refund.reason!,
                style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}

class _IdentifierRow extends StatelessWidget {
  const _IdentifierRow({required this.label, required this.value, this.onCopy});

  final String label;
  final String value;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 36),
      child: Row(
        children: [
          // Label mengambil lebar alaminya, nilai sisanya — nilai (nomor
          // pesanan, tanggal) lebih penting untuk tetap satu baris daripada
          // labelnya, dan nilai pendek tetap rata kanan.
          Text(label, style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: XpText.bodyM(context).copyWith(fontWeight: FontWeight.w600)),
          ),
          if (onCopy != null)
            IconButton(
              tooltip: 'Salin',
              onPressed: onCopy,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(Icons.content_copy, size: 18, color: XpColors.primary),
            ),
        ],
      ),
    );
  }
}

/// Tombol aksi sesuai status.
///
/// Hanya aksi yang **sah menurut status saat ini** yang ditampilkan. Ini bukan
/// sekadar kerapian: `POST /orders/{id}/complete` membalas halaman HTML
/// berstatus 200 kalau transisinya tidak sah, yang tidak bisa dijelaskan ke
/// user. Menyaring di sini membuat kasus itu tidak pernah terpicu.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.state});

  final OrderDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final cubit = OrderDetailCubit.get(context);
    final actions = <Widget>[];

    Future<void> pushThenReload(String path) async {
      final changed = await context.push<bool>(path);
      if (changed ?? false) await cubit.load();
    }

    if (order.canCancel) {
      actions.add(OutlinedButton(
        onPressed: state.canAct ? () => pushThenReload(AppRoutes.orderCancelPath(order.id)) : null,
        child: const Text('Batalkan Pesanan'),
      ));
    }
    final txId = order.payableTransactionId;
    if (order.awaitsPayment && txId != null) {
      // Kembali dari layar pembayaran selalu memuat ulang: status pesanan
      // bisa berubah jadi `paid` tanpa layar ini tahu.
      actions.add(FilledButton(
        onPressed: state.canAct
            ? () async {
                await context.push<void>(AppRoutes.paymentPath(txId));
                await cubit.load();
              }
            : null,
        child: const Text('Bayar Sekarang'),
      ));
    }
    if (order.canRequestCancellation &&
        state.cancellationSupported &&
        state.cancellationRequest == null) {
      actions.add(OutlinedButton(
        onPressed: state.canAct ? () => pushThenReload(AppRoutes.orderCancelPath(order.id)) : null,
        child: const Text('Ajukan Pembatalan'),
      ));
    }
    if (order.canRequestRefund) {
      actions.add(OutlinedButton(
        onPressed:
            state.canAct ? () => pushThenReload(AppRoutes.orderComplaintPath(order.id)) : null,
        child: const Text('Ajukan Komplain'),
      ));
    }
    if (order.canConfirmDelivery) {
      actions.add(FilledButton(
        onPressed: state.canAct ? () => _confirmDelivery(context) : null,
        child: const Text('Pesanan Diterima'),
      ));
    }
    if (order.canComplete) {
      actions.add(FilledButton(
        onPressed: state.canAct ? () => _confirmComplete(context) : null,
        child: const Text('Selesaikan Pesanan'),
      ));
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return XpBottomBar(
      child: Row(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: actions[i]),
          ],
          if (state.isSubmitting) ...[
            const SizedBox(width: 12),
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelivery(BuildContext context) async {
    final cubit = OrderDetailCubit.get(context);
    final ok = await _ask(
      context,
      title: 'Pesanan sudah diterima?',
      message: 'Pastikan paket sudah sampai di tanganmu dan sesuai pesanan.',
      confirm: 'Ya, Sudah Diterima',
    );
    // Dikirim tanpa kode segel dulu: status Secure+ tidak ikut di detail
    // pesanan, jadi kode baru diminta kalau server membalas
    // INVALID_SEAL_CODE (lihat `_onActionError`).
    if (ok) await cubit.confirmDelivery();
  }

  Future<void> _confirmComplete(BuildContext context) async {
    final cubit = OrderDetailCubit.get(context);
    final ok = await _ask(
      context,
      title: 'Selesaikan pesanan?',
      message: 'Dana akan diteruskan ke penjual. Setelah selesai, komplain '
          'tetap bisa diajukan dari halaman ini.',
      confirm: 'Ya, Selesaikan',
    );
    if (ok) await cubit.complete();
  }

  Future<bool> _ask(
    BuildContext context, {
    required String title,
    required String message,
    required String confirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Meminta kode segel Secure+ (`SEAL-XXXXXXXX`) dari notifikasi pengiriman.
class _SealCodeDialog extends StatefulWidget {
  const _SealCodeDialog({required this.wrongCode});

  /// Kode sebelumnya sudah dikirim dan ditolak.
  final bool wrongCode;

  @override
  State<_SealCodeDialog> createState() => _SealCodeDialogState();
}

class _SealCodeDialogState extends State<_SealCodeDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Kode segel dibuat `generate_readable_code('SEAL', 8)` di backend:
  /// `SEAL-` + 8 karakter dari alfabet tanpa huruf/angka ambigu, total 13
  /// karakter, dan server mencocokkannya **persis**. Pembeli yang hanya
  /// mengetik 8 karakter setelah `SEAL-` dilengkapi prefiksnya di sini.
  String get _normalized {
    final raw = _controller.text.trim().toUpperCase().replaceAll(' ', '');
    if (raw.isEmpty) return raw;
    return raw.startsWith('SEAL-') ? raw : 'SEAL-$raw';
  }

  @override
  Widget build(BuildContext context) {
    final valid = RegExp(r'^SEAL-[A-Z0-9]{8}$').hasMatch(_normalized);
    return AlertDialog(
      title: const Text('Masukkan Kode Segel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.wrongCode
                ? 'Kode segel salah. Periksa lagi kode di notifikasi pengiriman '
                    'pesanan ini (contoh: SEAL-AB23CD45).'
                : 'Pesanan ini dilindungi Secure+. Masukkan kode segel dari '
                    'notifikasi pengiriman (contoh: SEAL-AB23CD45) untuk '
                    'mengonfirmasi penerimaan.',
            style: XpText.bodyS(context).copyWith(
                color: widget.wrongCode ? XpColors.danger : XpColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 13,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(hintText: 'SEAL-XXXXXXXX'),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        FilledButton(
          onPressed: valid ? () => Navigator.of(context).pop(_normalized) : null,
          child: const Text('Konfirmasi'),
        ),
      ],
    );
  }
}
