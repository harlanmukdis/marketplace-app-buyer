import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_cancellation_card.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Batalkan Pesanan (§3.14 `batalkan_pesanan_belum_cetak_resi`) **dan**
/// Ajukan Pembatalan (§3.15 `ajukan_permohonan_pembatalan`).
///
/// Dua tahap pembatalan, dipisah tegas oleh resi (aturan desain 7):
///
/// * **`pending` | `paid`** — pembatalan langsung lewat
///   `POST /orders/{id}/cancel` (endpoint sungguhan).
/// * **`packed` | `shipped`** — permohonan yang ditinjau penjual lewat
///   `POST /orders/{id}/cancellation-request`. ⚠️ Endpoint itu **diusulkan**
///   (docs/22 #3) dan dijawab mock di build debug; kalau rutenya tidak ada
///   (mock dimatikan), layar kembali ke penjelasan + Xpedia 911.
///
/// Tanpa unggah bukti di kedua tahap — sesuai desain.
///
/// Mengembalikan `true` lewat `pop` kalau pesanan dibatalkan atau
/// permohonannya terkirim, supaya detail memuat ulang.
class OrderCancelScreen extends StatelessWidget {
  const OrderCancelScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderDetailCubit(orderId)..load(),
      child: const _CancelBody(),
    );
  }
}

/// Alasan pembatalan langsung (§3.14). `Lainnya` mengandalkan catatan
/// tambahan. Permohonan sesudah resi memakai [CancellationReason] (§3.15),
/// karena daftarnya berbeda dan dikirim sebagai kode.
const _reasons = [
  'Salah pilih produk',
  'Ingin ubah pesanan',
  'Alamat salah',
  'Tidak jadi membeli',
  'Lainnya',
];

class _CancelBody extends StatefulWidget {
  const _CancelBody();

  @override
  State<_CancelBody> createState() => _CancelBodyState();
}

class _CancelBodyState extends State<_CancelBody> {
  static const _maxNote = 500;

  final _note = TextEditingController();
  String _reason = _reasons.first;
  CancellationReason _requestReason = CancellationReason.wrongAddress;
  bool _submitted = false;

  /// Permohonan yang baru terkirim di layar ini — dipakai untuk menandai
  /// "Simulasi" pada hasil mutasi mock dan untuk menutup layar sekali saja.
  bool _requestSent = false;

  @override
  void initState() {
    super.initState();
    _note.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  /// "Salah pilih produk: catatan". Server menyimpan `reason` apa adanya,
  /// jadi alasan dan catatan digabung jadi satu teks.
  String get _reasonText {
    final note = _note.text.trim();
    return note.isEmpty ? _reason : '$_reason: $note';
  }

  Future<void> _submit(OrderModel order) async {
    final cubit = OrderDetailCubit.get(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan pesanan ini?'),
        content: const Text('Pesanan yang sudah dibatalkan tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Kembali'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: XpColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
    if (!(ok ?? false)) return;
    _submitted = true;
    await cubit.cancel(reason: _reasonText);
  }

  /// Lembar konfirmasi §3.15. Mengembalikan `true` kalau user menyetujui.
  Future<void> _submitRequest() async {
    final cubit = OrderDetailCubit.get(context);
    final ok = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      backgroundColor: XpColors.surface,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: XpColors.dangerSubtle, shape: BoxShape.circle),
                child: Icon(Icons.help_outline, color: XpColors.danger),
              ),
              const SizedBox(height: 12),
              Text('Kirim Permohonan?', style: XpText.headingM(sheetContext)),
              const SizedBox(height: 8),
              Text(
                'Penjual akan memiliki waktu 1x24 jam untuk meninjau permohonan '
                'pembatalan ini.',
                textAlign: TextAlign.center,
                style: XpText.bodyM(sheetContext).copyWith(color: XpColors.textSecondary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: XpColors.danger,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () => Navigator.of(sheetContext).pop(true),
                  child: const Text('Ya, Ajukan Pembatalan'),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => Navigator.of(sheetContext).pop(false),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!(ok ?? false) || !mounted) return;
    _requestSent = true;
    await cubit.requestCancellation(_requestReason, note: _note.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailCubit, OrderDetailState>(
      listener: (context, state) {
        if (state is! OrderDetailLoaded) return;
        context.read<StoreDirectoryCubit>().ensure([state.order.storeId]);
        final error = state.actionError;
        if (error != null) {
          _submitted = false;
          _requestSent = false;
          showOrderSnack(context, orderErrorMessage(context, error));
          OrderDetailCubit.get(context).clearActionError();
          return;
        }
        if (_requestSent && !state.isSubmitting && state.cancellationRequest != null) {
          _requestSent = false;
          showOrderSnack(context, 'Permohonan pembatalan berhasil dikirim ke penjual.');
          context.pop(true);
          return;
        }
        if (_submitted && !state.isSubmitting && state.order.isCancelled) {
          _submitted = false;
          final order = state.order;
          showOrderSnack(
            context,
            orderWasPaid(order)
                ? 'Pesanan ${order.orderNumber} berhasil dibatalkan. Dana '
                    '${formatRupiah(order.grandTotal)} dikembalikan ke Xpedia Wallet.'
                : 'Pesanan ${order.orderNumber} berhasil dibatalkan.',
          );
          context.pop(true);
        }
      },
      builder: (context, state) {
        final loaded = state is OrderDetailLoaded ? state : null;
        final canCancel = loaded?.order.canCancel ?? false;
        // Formulir permohonan hanya kalau endpoint-nya ada (atau di-mock) dan
        // belum ada permohonan — satu pesanan satu permohonan.
        final canRequest = loaded != null &&
            loaded.order.canRequestCancellation &&
            loaded.cancellationSupported &&
            loaded.cancellationRequest == null;
        return Scaffold(
          backgroundColor: XpColors.canvas,
          appBar: XpStackAppBar(
              title: canCancel || loaded == null ? 'Batalkan Pesanan' : 'Ajukan Pembatalan'),
          body: switch (state) {
            OrderDetailLoading() => const Center(child: CircularProgressIndicator()),
            OrderDetailError(:final error) => OrderLoadError(
                error: error,
                onRetry: () => OrderDetailCubit.get(context).load(),
              ),
            OrderDetailLoaded(:final order) => canCancel
                ? _form(context, order)
                : canRequest
                    ? _requestForm(context, state)
                    : _Unavailable(state: state),
          },
          bottomNavigationBar: canRequest
              ? XpBottomBar(
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: XpColors.sunken,
                            foregroundColor: XpColors.textPrimary,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () => context.pop(),
                          child: const Text('Kembali'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: XpColors.danger,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: loaded.canAct ? _submitRequest : null,
                          icon: loaded.isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.send, size: 18),
                          label: Text(loaded.isSubmitting ? 'Mengirim...' : 'Kirim Permohonan'),
                        ),
                      ),
                    ],
                  ),
                )
              : canCancel
              ? XpBottomBar(
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: XpColors.sunken,
                            foregroundColor: XpColors.textPrimary,
                            minimumSize: const Size.fromHeight(52),
                          ),
                          onPressed: () => context.pop(),
                          child: const Text('Kembali'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: XpColors.danger,
                            minimumSize: const Size.fromHeight(52),
                          ),
                          onPressed: loaded!.canAct ? () => _submit(loaded.order) : null,
                          icon: loaded.isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.cancel_outlined, size: 18),
                          label: Text(loaded.isSubmitting ? 'Memproses...' : 'Batalkan Pesanan'),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  /// Formulir §3.15 "Ajukan Permohonan Pembatalan" (sesudah resi).
  Widget _requestForm(BuildContext context, OrderDetailLoaded state) {
    final order = state.order;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        XpCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: XpColors.warningSubtle, shape: BoxShape.circle),
                child: const Icon(Icons.assignment_late_outlined, color: XpColors.warning),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Ajukan Permohonan Pembatalan',
                              style: XpText.titleL(context)),
                        ),
                        SimulatedBadge(meta: state.cancellationMeta),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pesanan sudah memasuki proses pengemasan oleh penjual. Pilih '
                      'alasan pembatalan dan berikan catatan jika diperlukan.',
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // "atau mulai memproses" dari desain sengaja dibuang: tahap
        // pembatalan dipisah tegas oleh resi (aturan desain 7).
        const XpBanner(
          icon: Icons.warning_amber_rounded,
          tone: XpBannerTone.warning,
          title: 'Pesanan sudah diproses penjual',
          message: 'Penjual sudah mengemas atau mencetak resi pengiriman pesanan ini. '
              'Pembatalan tidak dapat dilakukan secara langsung, sehingga kamu perlu '
              'mengajukan permohonan. Permohonan ini dapat disetujui atau ditolak '
              'oleh penjual.',
        ),
        const SizedBox(height: 12),
        _OrderSummaryCard(order: order),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Alasan Pembatalan', style: XpText.headingM(context)),
              Text('Pilih salah satu alasan agar penjual memahami kendala kamu',
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              const SizedBox(height: 12),
              for (final reason in CancellationReason.values)
                _ReasonRow(
                  label: reason.label,
                  selected: reason == _requestReason,
                  onTap: () => setState(() => _requestReason = reason),
                ),
              const SizedBox(height: 8),
              Text('Catatan Tambahan (Opsional)', style: XpText.labelL(context)),
              const SizedBox(height: 8),
              TextField(
                controller: _note,
                maxLines: 3,
                maxLength: _maxNote,
                enabled: !state.isSubmitting,
                decoration: const InputDecoration(
                  hintText: 'Tulis alasan pembatalan di sini...',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const XpBanner(
          icon: Icons.info_outline,
          title: 'Permohonan akan ditinjau penjual',
          message: 'Jika disetujui, dana akan dikembalikan ke saldo Xpedia Wallet kamu. '
              'Jika ditolak, pesanan akan tetap diproses dan dikirim oleh penjual.',
        ),
      ],
    );
  }

  Widget _form(BuildContext context, OrderModel order) {
    final paid = order.status == OrderStatus.paid;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        XpCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: XpColors.dangerSubtle, shape: BoxShape.circle),
                child: Icon(Icons.close, color: XpColors.danger),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Batalkan Pesanan', style: XpText.titleL(context)),
                    const SizedBox(height: 4),
                    Text(
                      paid
                          ? 'Karena penjual belum mengemas pesanan ini, kamu dapat '
                              'membatalkannya secara langsung tanpa perlu persetujuan penjual.'
                          : 'Pesanan ini belum dibayar, jadi kamu dapat membatalkannya '
                              'secara langsung.',
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _OrderSummaryCard(order: order),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Alasan Pembatalan', style: XpText.headingM(context)),
              Text('Pilih salah satu alasan paling tepat untuk evaluasi kami',
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              const SizedBox(height: 12),
              for (final reason in _reasons)
                _ReasonRow(
                  label: reason,
                  selected: reason == _reason,
                  onTap: () => setState(() => _reason = reason),
                ),
              const SizedBox(height: 8),
              Text('Catatan Tambahan (Opsional)', style: XpText.labelL(context)),
              const SizedBox(height: 8),
              TextField(
                controller: _note,
                maxLines: 3,
                maxLength: _maxNote,
                decoration: const InputDecoration(
                  hintText: 'Tulis alasan pembatalan di sini...',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (paid)
          XpBanner(
            icon: Icons.account_balance_wallet,
            tone: XpBannerTone.success,
            title: 'Dana kembali 100% ke Xpedia Wallet',
            message: 'Setelah pesanan dibatalkan, dana sebesar '
                '${formatRupiah(order.grandTotal)} dikembalikan ke saldo Xpedia Wallet kamu.',
          )
        else
          const XpBanner(
            icon: Icons.info_outline,
            title: 'Pesanan dibatalkan tanpa biaya',
            message: 'Pesanan ini belum dibayar, jadi tidak ada dana yang perlu dikembalikan.',
          ),
      ],
    );
  }
}

/// Ringkasan pesanan yang sama di kedua tahap pembatalan.
class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(order.orderNumber, style: XpText.titleM(context)),
                  ),
                  OrderStatusPill(order: order),
                ],
              ),
              Text(formatServerDateTime(order.createdAt),
                  style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
              const Divider(height: 20),
              OrderStoreName(storeId: order.storeId),
              const SizedBox(height: 4),
              for (final item in order.items) OrderItemTile(item: item),
              const Divider(height: 20),
              OrderCostSummary(
                subtotal: order.subtotal,
                shippingCost: order.shippingCost,
                discountTotal: order.discountTotal,
                grandTotal: order.grandTotal,
                itemCount: order.items.isEmpty ? null : order.totalQuantity,
              ),
            ],
          ),
        );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? XpColors.primarySubtle : XpColors.canvas,
        borderRadius: BorderRadius.circular(XpRadius.m),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(XpRadius.m),
          child: Semantics(
            selected: selected,
            button: true,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      size: 20,
                      color: selected ? XpColors.primary : XpColors.textPlaceholder,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(label, style: XpText.bodyM(context))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pesanan yang tidak bisa dibatalkan langsung maupun diajukan
/// pembatalannya sekarang.
class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.state});

  final OrderDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final request = state.cancellationRequest;
    if (request != null) {
      // Satu pesanan satu permohonan: yang tampil statusnya, bukan formulir.
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CancellationRequestCard(request: request, meta: state.cancellationMeta),
          const SizedBox(height: 12),
          OrderSupportButton(orderId: order.id),
        ],
      );
    }
    if (order.isCancelled) {
      return const XpEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Pesanan sudah dibatalkan',
        message: 'Tidak ada lagi yang perlu dilakukan untuk pesanan ini.',
      );
    }
    if (!order.canRequestCancellation) {
      return XpEmptyState(
        icon: Icons.info_outline,
        title: 'Pesanan tidak bisa dibatalkan',
        message: order.canRequestRefund
            ? 'Barang sudah diterima. Jika ada masalah, ajukan komplain.'
            : 'Status pesanan ini tidak memungkinkan pembatalan.',
        actionLabel: order.canRequestRefund ? 'Ajukan Komplain' : null,
        onAction: order.canRequestRefund
            ? () => context.push(AppRoutes.orderComplaintPath(order.id))
            : null,
      );
    }
    // Endpoint permohonan belum ada di server dan mock dimatikan: jelaskan
    // saja, tanpa formulir yang pura-pura terkirim.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        XpCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: XpColors.warningSubtle, shape: BoxShape.circle),
                child: const Icon(Icons.assignment_late_outlined, color: XpColors.warning),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pesanan sudah diproses penjual', style: XpText.titleL(context)),
                    const SizedBox(height: 4),
                    Text(
                      'Penjual sudah mengemas pesanan ini, sehingga pembatalan tidak '
                      'dapat dilakukan secara langsung. Pengajuan pembatalan yang '
                      'ditinjau penjual belum tersedia di aplikasi.',
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpBanner(
          icon: Icons.support_agent,
          title: 'Hubungi Xpedia 911',
          message: 'Tim Xpedia 911 dapat membantu meninjau pembatalan pesanan ini.',
          trailing: Icon(Icons.chevron_right, color: XpColors.textTertiary),
          onTap: () => context.push(AppRoutes.supportNewPath(orderId: order.id)),
        ),
      ],
    );
  }
}
