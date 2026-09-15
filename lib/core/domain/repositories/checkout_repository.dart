import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';

/// Pilihan kurir untuk satu toko.
typedef CourierChoice = ({String courierCode, String serviceCode});

/// Seluruh keadaan checkout yang dibutuhkan layar dalam satu objek.
///
/// Digabung karena layar checkout selalu perlu ketiganya bersamaan: sesi
/// (untuk total dan tenggat), opsi kurir per toko, dan pilihan yang sedang
/// aktif. Menyerahkan penggabungan ke cubit membuat ketiganya gampang tampil
/// tidak sinkron — mis. total sudah berubah tapi ongkir yang tampil masih yang
/// lama.
class CheckoutSnapshot {
  const CheckoutSnapshot({
    required this.session,
    this.shippingOptions = const {},
  });

  final CheckoutSessionModel session;

  /// Opsi pengiriman **per `store_id`**, sesuai bentuk map dari server.
  final Map<String, List<ShippingOptionModel>> shippingOptions;

  /// Toko yang punya barang di sesi ini, urut supaya tampilannya stabil.
  List<String> get storeIds => session.storeIds.toList()..sort();

  /// Pilihan kurir yang sedang aktif untuk sebuah toko, dibaca dari
  /// `selected_couriers` milik sesi.
  ShippingOptionModel? selectedFor(String storeId) {
    final raw = session.selectedCouriers?[storeId];
    if (raw is! Map) return null;
    return ShippingOptionModel.fromJson(Map<String, dynamic>.from(raw));
  }

  /// Total ongkir dari kurir yang sudah dipilih.
  double get shippingTotal {
    var total = 0.0;
    for (final storeId in storeIds) {
      total += selectedFor(storeId)?.cost ?? 0;
    }
    return total;
  }
}

/// Alur checkout.
///
/// Catatan penting yang membentuk antarmuka ini: **tidak ada method untuk
/// mengganti alamat pada sesi berjalan.** `PATCH /checkout/sessions/{id}/address`
/// rusak di server dan selalu membalas 500 — lihat `CheckoutService`. Ganti
/// alamat dilakukan dengan [cancelSession] lalu [startSession] lagi.
abstract class CheckoutRepository {
  /// Membuat sesi dari baris keranjang yang tercentang, lalu langsung memuat
  /// detail dan opsi kirimnya.
  Future<DataState<CheckoutSnapshot>> startSession({
    required int addressId,
    String? voucherCode,
  });

  Future<DataState<CheckoutSnapshot>> refresh(String sessionId);

  /// Memilih kurir untuk sebagian atau seluruh toko.
  Future<DataState<CheckoutSnapshot>> setShipping(
    String sessionId,
    Map<String, CourierChoice> selection,
  );

  /// Mengonfirmasi sesi → order terbentuk.
  ///
  /// ⚠️ Jangan pernah mengulang panggilan ini secara otomatis: backend belum
  /// menangani `Idempotency-Key`, jadi pengulangan berisiko menggandakan
  /// order.
  Future<DataState<CheckoutConfirmResult>> confirm(
    String sessionId, {
    required String paymentMethod,
  });

  /// Membatalkan sesi dan melepas reservasi stok.
  Future<DataState<void>> cancelSession(String sessionId);
}
