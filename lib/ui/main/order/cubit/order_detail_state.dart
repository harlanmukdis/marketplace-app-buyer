part of 'order_detail_cubit.dart';

/// Status halaman detail pesanan.
@freezed
sealed class OrderDetailState with _$OrderDetailState {
  const OrderDetailState._();

  const factory OrderDetailState.loading() = OrderDetailLoading;

  const factory OrderDetailState.loaded({
    required OrderModel order,

    /// Sedang mengirim aksi status (batal / konfirmasi terima / selesai /
    /// ajukan pembatalan / komplain).
    @Default(false) bool isSubmitting,
    DataError? actionError,

    /// Resi & status pengiriman; `null` selama penjual belum membuat resi —
    /// atau kalau permintaannya gagal. Pelengkap, jadi kegagalannya tidak
    /// menggagalkan halaman.
    OrderTrackingModel? tracking,

    /// `meta` respons tracking — membawa `mock_fields: [tracking_history]`
    /// selama riwayat kurir masih disimulasikan.
    @Default(<String, dynamic>{}) Map<String, dynamic> trackingMeta,

    /// Bukti foto/video Secure+; kosong untuk pesanan biasa.
    @Default(<ShipmentEvidenceModel>[]) List<ShipmentEvidenceModel> evidence,

    /// Permohonan pembatalan sesudah resi (docs/22 #3, endpoint diusulkan).
    CancellationRequestModel? cancellationRequest,
    @Default(<String, dynamic>{}) Map<String, dynamic> cancellationMeta,

    /// `false` kalau `GET /orders/{id}/cancellation-request` belum ada di
    /// server (404 HTML) — mis. mock dimatikan. Layar lalu kembali ke
    /// penjelasan lama, alih-alih menawarkan formulir yang pasti gagal.
    @Default(true) bool cancellationSupported,

    /// Polis Secure+ pesanan ini, kalau ada.
    InsurancePolicyModel? insurance,
    @Default(<String, dynamic>{}) Map<String, dynamic> insuranceMeta,

    /// Status polis berhasil diketahui. Tanpa `GET /orders/{id}/insurance`
    /// (endpoint diusulkan) aplikasi tidak tahu apakah perlindungan sudah
    /// aktif; kartu opt-in tetap ditawarkan, dengan risiko opt-in ganda
    /// ditolak server.
    @Default(false) bool insuranceKnown,

    /// Sedang mengaktifkan Secure+ (terpisah dari [isSubmitting] supaya
    /// tombol aksi status tidak ikut terkunci).
    @Default(false) bool isOptingIn,
  }) = OrderDetailLoaded;

  const factory OrderDetailState.error(DataError error) = OrderDetailError;

  bool get canAct => switch (this) {
        OrderDetailLoaded(:final isSubmitting) => !isSubmitting,
        _ => false,
      };
}
