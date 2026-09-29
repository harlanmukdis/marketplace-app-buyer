import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_masking.dart';
import 'package:marketplace_app_member/util/format_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// PDF "Final Invoice" (desain b33 / §3.18), **dibuat di perangkat** dari
/// JSON `GET /orders/{id}/invoice`.
///
/// Kenapa di klien: backend hanya mengirim JSON (docs/22 #6 — tidak ada PDF),
/// sementara desain menjanjikan "Download Invoice Resmi (.PDF)". Isinya hanya
/// yang ada di respons invoice; yang tidak ada — metode pembayaran, metode &
/// estimasi pengiriman, SKU, QR ke detail pesanan — **tidak ditulis**, bukan
/// dikarang.
///
/// Data pembeli **disensor** ([maskName], [maskPhone], [maskStreet]) karena
/// server mengirimnya utuh; lihat `order_masking.dart`.
class InvoicePdfFonts {
  const InvoicePdfFonts({required this.regular, required this.bold});

  final pw.Font regular;
  final pw.Font bold;

  /// Inter dari aset aplikasi. Font standar PDF (Helvetica) hanya mengenal
  /// Latin-1, sehingga karakter seperti "•" atau "–" di nama produk akan
  /// hilang; Inter sudah dibundel untuk UI, jadi dipakai ulang.
  static Future<InvoicePdfFonts> load() async {
    final regular = await rootBundle.load('assets/fonts/inter/Inter-Regular.ttf');
    final bold = await rootBundle.load('assets/fonts/inter/Inter-Bold.ttf');
    return InvoicePdfFonts(regular: pw.Font.ttf(regular), bold: pw.Font.ttf(bold));
  }
}

/// Nama berkas unduhan, mis. `invoice-INV20260916-000001.pdf`.
String invoicePdfFileName(OrderInvoiceModel invoice) {
  final safe = invoice.invoiceNumber.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '');
  return 'invoice-${safe.isEmpty ? 'xpedia' : safe}.pdf';
}

const _navy = PdfColor.fromInt(0xff0F286C);
const _primary = PdfColor.fromInt(0xff0056FE);
const _primarySubtle = PdfColor.fromInt(0xffEBF2FF);
const _success = PdfColor.fromInt(0xff0C7A44);
const _successSubtle = PdfColor.fromInt(0xffE8F8EF);
const _muted = PdfColor.fromInt(0xff6B7280);
const _border = PdfColor.fromInt(0xffE5E7EB);

Future<Uint8List> buildInvoicePdf(OrderInvoiceModel invoice, {InvoicePdfFonts? fonts}) async {
  final f = fonts ?? await InvoicePdfFonts.load();
  final doc = pw.Document(
    title: 'Invoice ${invoice.invoiceNumber}',
    author: 'Xpedia',
    theme: pw.ThemeData.withFont(base: f.regular, bold: f.bold),
  );

  pw.TextStyle t(double size, {bool bold = false, PdfColor? color}) => pw.TextStyle(
        fontSize: size,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: color,
      );

  final address = invoice.shippingAddress;
  final itemCount = invoice.items.fold<int>(0, (sum, i) => sum + i.quantity);

  pw.Widget meta(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(children: [
          pw.SizedBox(width: 110, child: pw.Text(label, style: t(9, color: _muted))),
          pw.Expanded(child: pw.Text(value, style: t(9, bold: true))),
        ]),
      );

  pw.Widget block(String title, List<String> lines) => pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _border),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title, style: t(9, bold: true, color: _navy)),
              pw.SizedBox(height: 4),
              for (final line in lines.where((l) => l.trim().isNotEmpty))
                pw.Text(line, style: t(9)),
            ],
          ),
        ),
      );

  pw.Widget totalRow(String label, String value, {bool emphasize = false, PdfColor? color}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(children: [
          pw.Expanded(child: pw.Text(label, style: t(emphasize ? 11 : 9, bold: emphasize))),
          pw.Text(value,
              style: t(emphasize ? 12 : 9, bold: emphasize, color: color ?? (emphasize ? _primary : null))),
        ]),
      );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text('Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: t(8, color: _muted)),
      ),
      build: (context) => [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('XPEDIA', style: t(22, bold: true, color: _primary)),
                  pw.Text('BEYOND LIMITS', style: t(7, color: _muted)),
                ],
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('INVOICE', style: t(24, bold: true, color: _navy)),
                pw.Text('Bukti Transaksi Pembelian di Xpedia', style: t(9, color: _muted)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: _primarySubtle,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(children: [
                  meta('No. Invoice', invoice.invoiceNumber),
                  meta('Tanggal Terbit', formatServerDateTime(invoice.generatedAt)),
                  meta('No. Pesanan', invoice.orderNumber),
                  meta('Tanggal Pesanan', formatServerDateTime(invoice.orderDate)),
                ]),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: _successSubtle,
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Text('LUNAS', style: t(10, bold: true, color: _success)),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            block('Informasi Pembeli', [
              maskName(address?.recipientName),
              maskPhone(address?.phone),
            ]),
            pw.SizedBox(width: 8),
            block('Informasi Penjual', [invoice.store?.name ?? '-']),
            pw.SizedBox(width: 8),
            block('Alamat Pengiriman', [
              maskStreet(address?.fullAddress),
              [address?.city, address?.province, address?.postalCode]
                  .whereType<String>()
                  .where((v) => v.isNotEmpty)
                  .join(', '),
            ]),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.TableHelper.fromTextArray(
          headers: const ['No.', 'Produk', 'Varian', 'Harga Satuan', 'Qty', 'Subtotal'],
          data: [
            for (final (i, item) in invoice.items.indexed)
              [
                '${i + 1}',
                item.productName,
                item.optionLabel.isEmpty ? '-' : item.optionLabel,
                formatRupiah(item.price),
                '${item.quantity}',
                formatRupiah(item.subtotal),
              ],
          ],
          headerStyle: t(9, bold: true, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: _navy),
          cellStyle: t(9),
          cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          border: const pw.TableBorder(
            horizontalInside: pw.BorderSide(color: _border, width: 0.5),
            bottom: pw.BorderSide(color: _border, width: 0.5),
          ),
          columnWidths: const {
            0: pw.FixedColumnWidth(26),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(1.6),
            3: pw.FlexColumnWidth(1.6),
            4: pw.FixedColumnWidth(30),
            5: pw.FlexColumnWidth(1.6),
          },
          cellAlignments: const {
            0: pw.Alignment.center,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.center,
            5: pw.Alignment.centerRight,
          },
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            pw.Spacer(),
            pw.SizedBox(
              width: 240,
              child: pw.Column(children: [
                totalRow('Subtotal Produk ($itemCount barang)', formatRupiah(invoice.subtotal)),
                totalRow('Ongkos Kirim', formatRupiah(invoice.shippingCost)),
                if (invoice.discountTotal > 0)
                  totalRow('Diskon', '-${formatRupiah(invoice.discountTotal)}', color: _success),
                pw.Divider(color: _border),
                totalRow('Total Pembayaran', formatRupiah(invoice.grandTotal), emphasize: true),
              ]),
            ),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Text('Catatan', style: t(9, bold: true)),
        pw.SizedBox(height: 2),
        pw.Text(
          'Terima kasih telah berbelanja di Xpedia. Dukungan Anda membantu jutaan penjual '
          'lokal untuk terus berkembang. Simpan invoice ini sebagai bukti pembelian yang sah. '
          'Data pribadi pembeli disamarkan untuk melindungi privasi.',
          style: t(8, color: _muted),
        ),
        pw.SizedBox(height: 16),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('Terima Kasih', style: t(14, bold: true, color: _navy)),
        ),
      ],
    ),
  );
  return doc.save();
}
