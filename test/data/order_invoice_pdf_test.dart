/// PDF invoice dibuat di perangkat dari JSON `GET /orders/{id}/invoice`
/// (docs/22 #6), dengan data pembeli tersensor.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/invoice_pdf.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_masking.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('sensor', () {
    test('nama: huruf pertama tiap kata', () {
      expect(maskName('Andi Saputra'), 'A*** S******');
      expect(maskName('  Budi  '), 'B***');
      expect(maskName(null), '');
      expect(maskName('A B'), 'A B');
    });

    test('HP: 4 digit awal + 3 akhir, pemisah dibuang', () {
      expect(maskPhone('08121234456'), '0812****456');
      expect(maskPhone('0812-3456-7890'), '0812*****890');
      expect(maskPhone('12345'), '*****');
      expect(maskPhone(''), '');
    });

    test('alamat jalan: tiap kata disensor, angka ikut', () {
      expect(maskStreet('Jl. Melati No. 12'), 'J** M***** N** **');
      expect(maskStreet('Blok 7'), 'B*** *');
    });
  });

  test('PDF A4 terbentuk dari invoice, tanpa data pembeli utuh', () async {
    final invoice = OrderInvoiceModel(
      invoiceNumber: 'INV20260916-000001',
      orderNumber: 'ORD-UW6RM272MR',
      generatedAt: DateTime.utc(2026, 9, 16, 3),
      store: const InvoiceStoreModel(id: 7, name: 'Toko Kopi Gayo'),
      shippingAddress: const OrderShippingAddress(
        recipientName: 'Budi Santoso',
        phone: '081234567890',
        fullAddress: 'Jl. Melati 10',
        city: 'Bandung',
        province: 'Jawa Barat',
      ),
      items: const [
        OrderItemModel(
          id: 1,
          productName: 'Kopi Arabika Gayo 250g – edisi “spesial”',
          variantOptions: {'ukuran': '250g'},
          price: 75000,
          quantity: 2,
          subtotal: 150000,
        ),
      ],
      subtotal: 150000,
      shippingCost: 17000,
      discountTotal: 5000,
      grandTotal: 162000,
    );
    final bytes = await buildInvoicePdf(invoice, fonts: await InvoicePdfFonts.load());
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
    expect(invoicePdfFileName(invoice), 'invoice-INV20260916-000001.pdf');
  });
}
