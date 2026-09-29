import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_invoice_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/invoice_pdf.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_masking.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Invoice pesanan (desain b33 "Final Invoice", diadaptasi ke 390dp).
///
/// **"Download Invoice (.PDF)"** membuat PDF A4 **di perangkat** dari JSON
/// invoice (`invoice_pdf.dart`) lalu membagikannya lewat `printing` — backend
/// hanya mengirim JSON (docs/22 #6).
///
/// Data pembeli **disensor di klien** (`order_masking.dart`) karena server
/// mengirimnya utuh; field `shipping_address_masked` diusulkan ke backend.
///
/// Dihilangkan dari desain: metode pembayaran dan metode/estimasi pengiriman
/// (tidak ada di respons invoice), SKU, QR "lihat detail pesanan", dan
/// catatan PPN.
/// Membagikan/menyimpan PDF. Diganti test supaya tidak memanggil plugin.
typedef InvoicePdfSharer = Future<void> Function(Uint8List bytes, String fileName);

Future<void> _sharePdf(Uint8List bytes, String fileName) =>
    Printing.sharePdf(bytes: bytes, filename: fileName);

class OrderInvoiceScreen extends StatelessWidget {
  const OrderInvoiceScreen({super.key, required this.orderId, this.sharePdf});

  final int orderId;
  final InvoicePdfSharer? sharePdf;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderInvoiceCubit(orderId)..load(),
      child: Scaffold(
        backgroundColor: XpColors.canvas,
        appBar: const XpStackAppBar(title: 'Invoice'),
        body: BlocBuilder<OrderInvoiceCubit, OrderInvoiceState>(
          builder: (context, state) => switch (state) {
            OrderInvoiceLoading() => const Center(child: CircularProgressIndicator()),
            OrderInvoiceUnavailable() => const XpEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Invoice belum tersedia',
                message: 'Invoice terbit setelah pesanan selesai. Pesanan yang '
                    'dibatalkan tidak mendapat invoice.',
              ),
            OrderInvoiceError(:final error) => OrderLoadError(
                error: error,
                onRetry: () => context.read<OrderInvoiceCubit>().load(),
              ),
            OrderInvoiceLoaded(:final invoice) => _Invoice(invoice: invoice),
          },
        ),
        bottomNavigationBar: BlocBuilder<OrderInvoiceCubit, OrderInvoiceState>(
          builder: (context, state) => state is OrderInvoiceLoaded
              ? XpBottomBar(
                  child: _DownloadButton(invoice: state.invoice, share: sharePdf ?? _sharePdf),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _Invoice extends StatelessWidget {
  const _Invoice({required this.invoice});

  final OrderInvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final itemCount = invoice.items.fold<int>(0, (sum, i) => sum + i.quantity);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        XpCard(
          color: XpColors.primarySubtle,
          borderColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('INVOICE',
                        style: XpText.headingL(context).copyWith(color: XpColors.navy)),
                  ),
                  const XpPill(label: 'Lunas', tone: XpOrderTones.completed, large: true),
                ],
              ),
              Text('Bukti Transaksi Pembelian di Xpedia',
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              const SizedBox(height: 12),
              _Meta(
                label: 'No. Invoice',
                value: invoice.invoiceNumber,
                onCopy: () =>
                    copyWithToast(context, invoice.invoiceNumber, 'Nomor invoice tersalin'),
              ),
              _Meta(label: 'Tanggal Terbit', value: formatServerDateTime(invoice.generatedAt)),
              _Meta(label: 'No. Pesanan', value: invoice.orderNumber),
              _Meta(label: 'Tanggal Pesanan', value: formatServerDateTime(invoice.orderDate)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Penjual', style: XpText.titleM(context)),
              const SizedBox(height: 4),
              Text(invoice.store?.name ?? '-', style: XpText.bodyM(context)),
              const Divider(height: 24),
              Text('Informasi Pembeli', style: XpText.titleM(context)),
              const SizedBox(height: 4),
              _MaskedAddress(address: invoice.shippingAddress),
            ],
          ),
        ),
        const SizedBox(height: 12),
        XpCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rincian Produk', style: XpText.titleM(context)),
              const SizedBox(height: 4),
              for (final item in invoice.items) OrderItemTile(item: item),
              const Divider(height: 24),
              OrderCostSummary(
                subtotal: invoice.subtotal,
                shippingCost: invoice.shippingCost,
                discountTotal: invoice.discountTotal,
                grandTotal: invoice.grandTotal,
                itemCount: invoice.items.isEmpty ? null : itemCount,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Terima kasih telah berbelanja di Xpedia. Simpan invoice ini sebagai bukti '
          'pembelian yang sah.',
          textAlign: TextAlign.center,
          style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value, this.onCopy});

  final String label;
  final String value;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 32),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: XpText.bodyM(context).copyWith(fontWeight: FontWeight.w600)),
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

/// Pembeli & alamat tujuan dalam bentuk tersensor — sama persis dengan yang
/// tercetak di PDF, supaya layar tidak menampilkan lebih banyak daripada
/// dokumen yang dibagikan.
class _MaskedAddress extends StatelessWidget {
  const _MaskedAddress({required this.address});

  final OrderShippingAddress? address;

  @override
  Widget build(BuildContext context) {
    final a = address;
    if (a == null) {
      return Text('Alamat tujuan sudah tidak tersedia.',
          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary));
    }
    final region = [a.city, a.province, a.postalCode]
        .whereType<String>()
        .where((v) => v.isNotEmpty)
        .join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          [maskName(a.recipientName), maskPhone(a.phone)].where((v) => v.isNotEmpty).join(' · '),
          style: XpText.bodyM(context),
        ),
        const SizedBox(height: 2),
        Text(
          [maskStreet(a.fullAddress), region].where((v) => v.isNotEmpty).join(', '),
          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text('Data pribadi disamarkan untuk melindungi privasimu.',
            style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
      ],
    );
  }
}

class _DownloadButton extends StatefulWidget {
  const _DownloadButton({required this.invoice, required this.share});

  final OrderInvoiceModel invoice;
  final InvoicePdfSharer share;

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _busy = false;

  Future<void> _download() async {
    setState(() => _busy = true);
    try {
      final bytes = await buildInvoicePdf(widget.invoice);
      await widget.share(bytes, invoicePdfFileName(widget.invoice));
    } catch (_) {
      // Pembuatan PDF sepenuhnya lokal; kegagalan di sini (font/berbagi tidak
      // tersedia di platform) tidak punya kode server untuk dipetakan.
      if (mounted) showOrderSnack(context, 'Invoice PDF gagal dibuat. Coba lagi.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      onPressed: _busy ? null : _download,
      icon: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.file_download_outlined, size: 20),
      label: Text(_busy ? 'Menyiapkan PDF...' : 'Download Invoice (.PDF)'),
    );
  }
}
