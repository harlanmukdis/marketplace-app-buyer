import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/complaint_evidence_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/evidence_upload_zone.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Ajukan Komplain / Refund (desain §3.16 `ajukan_komplain_refund`).
///
/// Bukti foto/video diunggah lewat `POST /media/upload` (**sungguhan**) lalu
/// URL-nya ikut dikirim ke `POST /orders/{id}/refund-request` sebagai field
/// **yang diusulkan** `evidence_urls` (docs/22 #5). ⚠️ Controller-nya hari ini
/// hanya membaca `reason` dan `amount`, jadi bukti yang sudah terunggah
/// **belum tersimpan pada komplain** sampai backend membacanya.
///
/// Bukti **opsional**: desain menandainya "*Wajib disertakan", sedangkan
/// aturan desain 7 hanya "diizinkan" — keputusan produk yang belum diambil,
/// jadi yang lebih longgar dipilih. Jenis masalah dan penjelasan digabung jadi
/// satu teks `reason` ("Barang rusak: …"), karena server hanya menyimpan itu.
///
/// Endpointnya tanpa gerbang status — ia memindahkan status apa pun ke
/// `refund_requested` — jadi layar ini hanya membuka formulir untuk
/// `OrderModel.canRequestRefund`.
///
/// Mengembalikan `true` lewat `pop` kalau komplain terkirim.
class OrderComplaintScreen extends StatelessWidget {
  const OrderComplaintScreen({super.key, required this.orderId, this.pickEvidence});

  final int orderId;

  /// Pemilih berkas; `null` = galeri perangkat. Diganti di test.
  final EvidencePicker? pickEvidence;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OrderDetailCubit(orderId)..load()),
        BlocProvider(create: (_) => ComplaintEvidenceCubit()),
      ],
      child: _ComplaintBody(pick: pickEvidence ?? pickEvidenceFromGallery),
    );
  }
}

const _issues = <(String, IconData)>[
  ('Barang rusak', Icons.broken_image_outlined),
  ('Barang tidak sesuai', Icons.rule),
  ('Salah produk', Icons.swap_horiz),
  ('Kurang item', Icons.remove_shopping_cart_outlined),
  ('Lainnya', Icons.more_horiz),
];

class _ComplaintBody extends StatefulWidget {
  const _ComplaintBody({required this.pick});

  final EvidencePicker pick;

  @override
  State<_ComplaintBody> createState() => _ComplaintBodyState();
}

class _ComplaintBodyState extends State<_ComplaintBody> {
  static const _maxText = 500;

  final _text = TextEditingController();
  String _issue = _issues.first.$1;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _valid => _text.text.trim().isNotEmpty;

  Future<void> _submit() async {
    final evidence = context.read<ComplaintEvidenceCubit>().state;
    if (!evidence.isSettled) return;
    _submitted = true;
    await OrderDetailCubit.get(context).requestRefund(
      '$_issue: ${_text.text.trim()}',
      evidenceUrls: evidence.uploadedUrls,
    );
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
          showOrderSnack(context, orderErrorMessage(context, error));
          OrderDetailCubit.get(context).clearActionError();
          return;
        }
        if (_submitted && !state.isSubmitting &&
            state.order.status == OrderStatus.refundRequested) {
          _submitted = false;
          showOrderSnack(context, 'Komplain pesanan ${state.order.orderNumber} terkirim.');
          context.pop(true);
        }
      },
      builder: (context, state) {
        final loaded = state is OrderDetailLoaded ? state : null;
        final open = loaded?.order.canRequestRefund ?? false;
        // Tombol kirim menunggu semua unggahan selesai (atau dihapus).
        final evidenceSettled =
            context.select<ComplaintEvidenceCubit, bool>((c) => c.state.isSettled);
        return Scaffold(
          backgroundColor: XpColors.canvas,
          appBar: const XpStackAppBar(title: 'Ajukan Komplain / Refund'),
          body: switch (state) {
            OrderDetailLoading() => const Center(child: CircularProgressIndicator()),
            OrderDetailError(:final error) => OrderLoadError(
                error: error,
                onRetry: () => OrderDetailCubit.get(context).load(),
              ),
            OrderDetailLoaded(:final order) => open
                ? _form(context, order)
                : XpEmptyState(
                    icon: Icons.info_outline,
                    title: 'Komplain belum bisa diajukan',
                    message: order.refund != null
                        ? 'Pesanan ini sudah punya pengajuan komplain.'
                        : 'Komplain bisa diajukan setelah paket kamu terima.',
                    actionLabel: 'Hubungi Xpedia 911',
                    onAction: () => context.push(AppRoutes.supportNewPath(orderId: order.id)),
                  ),
          },
          bottomNavigationBar: open
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
                          onPressed: loaded!.canAct && _valid && evidenceSettled ? _submit : null,
                          icon: loaded.isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.send, size: 18),
                          label: const Text('Kirim Komplain'),
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

  Widget _form(BuildContext context, OrderModel order) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        XpCard(
          color: XpColors.dangerSubtle,
          borderColor: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: XpColors.danger, shape: BoxShape.circle),
                child: const Icon(Icons.priority_high, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ajukan Komplain / Refund', style: XpText.titleL(context)),
                    const SizedBox(height: 4),
                    Text(
                      'Sampaikan masalah yang kamu alami dengan pesanan ini jika barang '
                      'rusak, tidak sesuai, kurang, atau tidak seperti di halaman produk.',
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const XpBanner(
          icon: Icons.info_outline,
          title: 'Barang sudah diterima',
          message: 'Kamu tetap bisa mengajukan komplain jika barang yang diterima rusak, '
              'tidak sesuai, kurang item, atau tidak sebagaimana dijelaskan di halaman '
              'produk. Foto atau video bukti diizinkan.',
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Ringkasan Pesanan', style: XpText.titleM(context))),
                  OrderStatusPill(order: order),
                ],
              ),
              const SizedBox(height: 8),
              XpKeyValueRow(label: 'Nomor Pesanan', value: order.orderNumber),
              XpKeyValueRow(
                  label: 'Tanggal Pembelian', value: formatServerDateTime(order.createdAt)),
              const Divider(height: 20),
              OrderStoreName(storeId: order.storeId),
              for (final item in order.items) OrderItemTile(item: item),
              const Divider(height: 20),
              XpKeyValueRow(
                label: 'Total Pembayaran',
                value: formatRupiah(order.grandTotal),
                emphasize: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Alasan', style: XpText.titleL(context)),
              Text('Pilih masalah utama yang sesuai dengan kondisi penerimaan paket.',
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              const SizedBox(height: 12),
              for (final (label, icon) in _issues)
                _IssueRow(
                  label: label,
                  icon: icon,
                  selected: _issue == label,
                  onTap: () => setState(() => _issue = label),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jelaskan Masalah', style: XpText.titleL(context)),
              const SizedBox(height: 8),
              TextField(
                controller: _text,
                maxLines: 4,
                maxLength: _maxText,
                decoration: const InputDecoration(
                  hintText: 'Tulis penjelasan masalah kamu di sini...',
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 16, color: XpColors.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Ceritakan kondisi barang dan kemasan saat dibuka sedetail mungkin.',
                      style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Upload Bukti', style: XpText.titleL(context))),
                  Text('Opsional',
                      style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
                ],
              ),
              const SizedBox(height: 12),
              EvidenceUploadZone(pick: widget.pick),
              const SizedBox(height: 8),
              Text(
                'Upload foto atau video yang menampilkan kondisi barang, kemasan, label, '
                'atau bukti pendukung lainnya. Bukti ini akan membantu mempercepat proses '
                'peninjauan komplain kamu.',
                style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpBanner(
          icon: Icons.account_balance_wallet,
          tone: XpBannerTone.success,
          title: 'Komplain akan ditinjau penjual',
          message: 'Jika disetujui, dana ${formatRupiah(order.grandTotal)} dikembalikan '
              'ke saldo Xpedia Wallet kamu.',
        ),
      ],
    );
  }
}

/// Baris pilihan masalah (§3.16): radio di kiri, ikon masalah di kanan.
class _IssueRow extends StatelessWidget {
  const _IssueRow({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? XpColors.primarySubtle : XpColors.canvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XpRadius.l),
          side: BorderSide(color: selected ? XpColors.primary : Colors.transparent),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(XpRadius.l),
          child: Semantics(
            selected: selected,
            button: true,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      size: 20,
                      color: selected ? XpColors.primary : XpColors.textPlaceholder,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(label, style: XpText.bodyM(context))),
                    Icon(icon, size: 20, color: XpColors.textSecondary),
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
