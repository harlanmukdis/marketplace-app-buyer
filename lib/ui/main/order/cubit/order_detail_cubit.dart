import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_post_purchase_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'order_detail_cubit.freezed.dart';
part 'order_detail_state.dart';

/// Detail satu pesanan beserta aksi status yang boleh dilakukan pembeli.
///
/// ⚠️ **Setiap aksi diperiksa terhadap status order lebih dulu**, bukan
/// diserahkan ke server. Alasannya bukan kerapian: `POST /orders/{id}/complete`
/// membalas **halaman HTML berstatus 200** kalau transisinya tidak sah, yang
/// sampai ke aplikasi sebagai `CLIENT_BAD_RESPONSE` — pesan yang tidak bisa
/// dijelaskan ke user. Memeriksa lebih dulu membuat kasus itu tidak pernah
/// terjadi lewat tombol.
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this.orderId)
      : _repository = injector<OrderRepository>(),
        super(const OrderDetailState.loading());

  static OrderDetailCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final int orderId;
  final OrderRepository _repository;

  Future<void> load() async {
    emit(const OrderDetailState.loading());
    final result = await _repository.fetchOrder(orderId);
    if (isClosed) return;
    _apply(result);
    // Tiga pelengkap berjalan bersamaan; masing-masing hanya menembak kalau
    // statusnya memungkinkan ada isi, dan kegagalannya tidak menggagalkan
    // halaman.
    await Future.wait([_loadShipment(), _loadCancellation(), _loadInsurance()]);
  }

  /// Permohonan pembatalan sesudah resi. Dimuat untuk status yang bisa
  /// mengajukannya **dan** untuk pesanan batal, supaya permohonan yang
  /// disetujui tetap terlihat sebagai penjelasan pembatalannya.
  Future<void> _loadCancellation() async {
    final current = state;
    if (current is! OrderDetailLoaded) return;
    final order = current.order;
    if (!order.canRequestCancellation && !order.isCancelled) return;

    final result = await _repository.fetchCancellationRequest(orderId);
    if (isClosed) return;
    final latest = state;
    if (latest is! OrderDetailLoaded) return;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        emit(latest.copyWith(
          cancellationRequest: data,
          cancellationMeta: meta,
          cancellationSupported: true,
        ));
      case DataFailed(:final error) when error.isRouteNotFound:
        // Endpoint diusulkan belum ada (mock dimatikan): degradasi ke
        // penjelasan lama, bukan error.
        emit(latest.copyWith(cancellationSupported: false));
      default:
        break;
    }
  }

  /// Status Secure+. Tidak dimuat untuk pesanan batal — tidak ada yang bisa
  /// dilindungi lagi.
  Future<void> _loadInsurance() async {
    final current = state;
    if (current is! OrderDetailLoaded || current.order.isCancelled) return;
    final result = await _repository.fetchInsurance(orderId);
    if (isClosed) return;
    final latest = state;
    if (latest is! OrderDetailLoaded) return;
    if (result case DataSuccess(:final data, :final meta)) {
      emit(latest.copyWith(insurance: data, insuranceMeta: meta, insuranceKnown: true));
    }
  }

  /// Resi dan bukti Secure+ — dua permintaan pelengkap yang **hanya
  /// dibuat kalau statusnya memungkinkan ada isinya**. `GET /orders/{id}`
  /// sendiri sudah membawa `tracking_number`, jadi yang dicari di sini
  /// hanya stempel kirim/terima dan bukti serah terima.
  Future<void> _loadShipment() async {
    final current = state;
    if (current is! OrderDetailLoaded || !_hasShipment(current.order.status)) return;

    // Di-await terpisah supaya kegagalan salah satunya tidak jadi
    // unhandled async error.
    final trackingFuture = _repository.fetchTracking(orderId);
    final evidenceFuture = _repository.fetchShipmentEvidence(orderId);
    final tracking = await trackingFuture;
    final evidence = await evidenceFuture;
    if (isClosed) return;

    final latest = state;
    if (latest is! OrderDetailLoaded) return;
    emit(latest.copyWith(
      tracking: tracking is DataSuccess<OrderTrackingModel?> ? tracking.data : null,
      trackingMeta: tracking is DataSuccess<OrderTrackingModel?> ? tracking.meta : const {},
      evidence: evidence is DataSuccess<List<ShipmentEvidenceModel>>
          ? evidence.data
          : const [],
    ));
  }

  static bool _hasShipment(OrderStatus status) => switch (status) {
        OrderStatus.shipped ||
        OrderStatus.delivered ||
        OrderStatus.completed ||
        OrderStatus.refundRequested ||
        OrderStatus.refundApproved ||
        OrderStatus.refundRejected =>
          true,
        _ => false,
      };

  /// Membatalkan pesanan yang belum dikemas penjual (`pending` | `paid`).
  Future<void> cancel({String? reason}) => _act(
        allowed: (order) => order.canCancel,
        action: () => _repository.cancel(orderId, reason: reason),
      );

  /// Menandai barang sudah diterima (`shipped` → `delivered`).
  ///
  /// Pesanan Secure+ menuntut [sealCode] dari notifikasi pengiriman. Aplikasi
  /// tidak bisa tahu lebih dulu apakah sebuah pesanan Secure+ (status polisnya
  /// tidak ikut di `GET /orders/{id}`), jadi layar meminta kodenya hanya
  /// sesudah server membalas `INVALID_SEAL_CODE`.
  Future<void> confirmDelivery({String? sealCode}) => _act(
        allowed: (order) => order.canConfirmDelivery,
        action: () => _repository.confirmDelivery(orderId, sealCode: sealCode),
      );

  /// Menjawab usulan kirim sebagian dari penjual.
  Future<void> respondPartialFulfillment(PartialFulfillmentDecision decision) => _act(
        allowed: (order) => order.awaitsPartialDecision,
        action: () => _repository.respondPartialFulfillment(orderId, decision),
      );

  /// Komplain & refund sesudah barang diterima.
  ///
  /// [evidenceUrls] berasal dari `POST /media/upload`; dikirim sebagai body
  /// `evidence` (lihat `OrderService.requestRefund`).
  Future<void> requestRefund(String reason, {List<String> evidenceUrls = const []}) => _act(
        allowed: (order) => order.canRequestRefund && reason.trim().isNotEmpty,
        action: () => _repository.requestRefund(orderId,
            reason: reason.trim(), evidenceUrls: evidenceUrls),
      );

  /// "Ajukan Pembatalan" sesudah resi (docs/22 #3, endpoint diusulkan).
  ///
  /// Satu pesanan hanya boleh punya satu permohonan, jadi ketukan kedua
  /// sesudah ada permohonan diabaikan — begitu pula selagi yang pertama
  /// berjalan. Tidak pernah diulang otomatis.
  Future<void> requestCancellation(CancellationReason reason, {String? note}) async {
    final current = state;
    if (current is! OrderDetailLoaded ||
        current.isSubmitting ||
        current.cancellationRequest != null) {
      return;
    }
    if (!current.order.canRequestCancellation) {
      emit(current.copyWith(actionError: _notAllowed));
      return;
    }
    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result = await _repository.requestCancellation(orderId, reason: reason, note: note);
    if (isClosed) return;
    final latest = state as OrderDetailLoaded;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        emit(latest.copyWith(
          isSubmitting: false,
          cancellationRequest: data,
          cancellationMeta: meta,
        ));
      case DataFailed(:final error):
        emit(latest.copyWith(isSubmitting: false, actionError: error));
      default:
        emit(latest.copyWith(isSubmitting: false));
    }
  }

  /// Mengaktifkan Xpedia Secure+ (endpoint sungguhan).
  ///
  /// Hanya untuk pesanan yang belum dikemas (`OrderModel.canOptInSecurePlus`)
  /// dan belum punya polis: server tidak memeriksa keduanya — opt-in kedua
  /// menabrak `UNIQUE (order_id)` sebagai error database.
  Future<void> optInSecurePlus() async {
    final current = state;
    if (current is! OrderDetailLoaded || current.isOptingIn) return;
    if (!current.order.canOptInSecurePlus || (current.insurance?.isSecurePlus ?? false)) {
      emit(current.copyWith(actionError: _notAllowed));
      return;
    }
    emit(current.copyWith(isOptingIn: true, actionError: null));
    final result = await _repository.optInSecurePlus(orderId);
    if (isClosed) return;
    final latest = state as OrderDetailLoaded;
    switch (result) {
      case DataSuccess(:final data):
        emit(latest.copyWith(isOptingIn: false, insurance: data, insuranceKnown: true));
      case DataFailed(:final error):
        emit(latest.copyWith(isOptingIn: false, actionError: error));
      default:
        emit(latest.copyWith(isOptingIn: false));
    }
  }

  static const _notAllowed = DataError(
    code: ApiErrorCode.invalidTransition,
    message: 'Status pesanan tidak memungkinkan aksi ini',
    kind: DataErrorKind.api,
  );

  /// Menyelesaikan pesanan (`delivered` → `completed`).
  Future<void> complete() => _act(
        allowed: (order) => order.canComplete,
        action: () => _repository.complete(orderId),
      );

  void clearActionError() {
    final current = state;
    if (current is! OrderDetailLoaded || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  Future<void> _act({
    required bool Function(OrderModel order) allowed,
    required Future<DataState<OrderModel>> Function() action,
  }) async {
    final current = state;
    if (current is! OrderDetailLoaded || current.isSubmitting) return;

    if (!allowed(current.order)) {
      emit(current.copyWith(actionError: _notAllowed));
      return;
    }

    emit(current.copyWith(isSubmitting: true, actionError: null));
    final result = await action();
    if (isClosed) return;
    _apply(result, previous: current);
  }

  void _apply(
    DataState<OrderModel> result, {
    OrderDetailLoaded? previous,
  }) {
    switch (result) {
      case DataSuccess(:final data):
        // Pelengkap yang sudah termuat (resi, bukti, permohonan pembatalan,
        // polis) dipertahankan — aksi status tidak mengubahnya, dan memuat
        // ulang semuanya tiap tombol ditekan hanya membuang request.
        final kept = previous;
        emit(kept == null
            ? OrderDetailState.loaded(order: data)
            : kept.copyWith(order: data, isSubmitting: false, actionError: null));
      case DataFailed(:final error):
        if (previous != null) {
          // Aksi gagal tidak boleh membuang pesanan yang sudah tampil.
          emit(previous.copyWith(isSubmitting: false, actionError: error));
        } else {
          emit(OrderDetailState.error(error));
        }
      case DataEmpty():
      case DataLoading():
        break;
    }
  }
}
