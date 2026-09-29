import 'dart:convert';

import '../utils/local_network.dart';

/// Mengingat **transaksi pembayaran milik tiap pesanan**, di perangkat.
///
/// 🔴 `GET /orders` maupun `GET /orders/{id}` **tidak membawa
/// `payment_transaction_id`**, dan tidak ada endpoint yang memetakan pesanan
/// ke transaksinya — padahal satu-satunya layar yang bisa membayar
/// (`PaymentScreen`) butuh id itu. Satu-satunya momen aplikasi mengetahuinya
/// adalah balasan `POST /checkout/sessions/{id}/confirm`
/// (`{order_ids, payment_transaction_id}`). Kelas ini menyimpan pasangan itu
/// supaya pesanan `pending` bisa dibayar lagi dari detail pesanan.
///
/// Batasnya jelas dan disengaja: pesanan yang dibuat di **perangkat lain**
/// (atau sebelum app diinstal ulang) tidak punya tautan. Kontrak yang
/// diusulkan ke backend adalah `payment_transaction_id` di `GET /orders/{id}`
/// — `OrderModel.paymentTransactionId` sudah membacanya, dan field server
/// selalu menang atas tautan lokal.
abstract final class OrderPaymentLinkStore {
  static const _key = 'orderPaymentLinks';

  /// Menyimpan tautan untuk semua pesanan dari satu checkout — keranjang
  /// multi-toko pecah jadi beberapa pesanan yang berbagi satu transaksi.
  static Future<void> save(Iterable<int> orderIds, int paymentTransactionId) async {
    final links = _read();
    for (final id in orderIds) {
      links['$id'] = paymentTransactionId;
    }
    await CachedHelper.saveData(_key, jsonEncode(links));
  }

  static int? transactionFor(int orderId) => _read()['$orderId'];

  static Map<String, int> _read() {
    final raw = CachedHelper.getData(_key);
    if (raw is! String || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      return {
        for (final entry in decoded.entries)
          if (entry.value is int) '${entry.key}': entry.value as int,
      };
    } catch (_) {
      return {};
    }
  }
}
