import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/voucher_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/voucher_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'voucher_cubit.freezed.dart';
part 'voucher_state.dart';

DataError _localValidation(String message) => DataError(
      code: ClientErrorCode.localValidation,
      message: message,
      kind: DataErrorKind.api,
    );

/// Layar voucher: voucher saya, rekomendasi untuk keranjang, dan kode manual.
///
/// Seluruh endpoint-nya **sungguhan** — hanya kosong di dev karena belum ada
/// voucher yang di-seed. Jadi keadaan kosong adalah keadaan normal, bukan
/// sudut yang jarang.
///
/// 🔴 Rekomendasi dan "Gunakan Otomatis" **hanya diminta kalau ada baris
/// keranjang tercentang**: dengan keranjang kosong servernya menyusun
/// `store_id IN ()` dan membalas 500 HTML. Penjaganya di sini, bukan di
/// layar, supaya tidak ada jalur yang lupa.
class VoucherCubit extends Cubit<VoucherState> {
  VoucherCubit()
      : _vouchers = injector<VoucherRepository>(),
        _cart = injector<CartRepository>(),
        super(const VoucherState.loading());

  static VoucherCubit get(BuildContext context) => BlocProvider.of(context);

  final VoucherRepository _vouchers;
  final CartRepository _cart;

  Future<void> load() async {
    emit(const VoucherState.loading());
    // Paralel, di-`await` terpisah: kegagalan salah satunya tidak boleh jadi
    // unhandled async error.
    final cartFuture = _cart.fetchCart();
    final claimedFuture = _vouchers.fetchMyVouchers();

    final cart = await cartFuture;
    final claimed = await claimedFuture;
    if (isClosed) return;

    final CartSummaryModel summary;
    switch (cart) {
      case DataSuccess(:final data):
        summary = data.summary;
      case DataEmpty():
        summary = const CartSummaryModel();
      case DataFailed(:final error):
        emit(VoucherState.error(error));
        return;
      case DataLoading():
        return;
    }

    var ready = VoucherState.ready(summary: summary) as VoucherReady;
    ready = switch (claimed) {
      DataSuccess(:final data) => ready.copyWith(claimed: data),
      DataFailed(:final error) => ready.copyWith(claimedError: error),
      _ => ready,
    };
    emit(ready);
    await _loadRecommended();
  }

  /// Memasang kode ke keranjang (`POST /cart/apply-voucher`).
  ///
  /// Slot yang sudah terisi (ongkir / platform / toko yang sama) **diganti**
  /// server, bukan ditolak — jadi tidak ada konfirmasi "ganti voucher?" di
  /// sini; daftar terpasang hasil baca ulang yang menunjukkannya.
  Future<void> apply(String rawCode) async {
    final current = state;
    if (current is! VoucherReady || current.busyCode != null) return;
    final code = rawCode.trim();
    if (code.isEmpty) {
      emit(current.copyWith(
          actionError: _localValidation('Masukkan kode voucher dulu.')));
      return;
    }
    if (current.summary.isEmpty) {
      // Voucher divalidasi terhadap baris tercentang (min. belanja, toko);
      // tanpa isi, penolakannya pasti dan tidak menjelaskan apa-apa.
      emit(current.copyWith(
        actionError: _localValidation(
            'Pilih barang di keranjang dulu sebelum memakai voucher.'),
      ));
      return;
    }

    emit(current.copyWith(busyCode: code, actionError: null, notice: null));
    final result = await _cart.applyVoucher(code);
    if (isClosed) return;
    await _afterCartMutation(result, notice: 'Voucher $code dipakai.');
  }

  Future<void> remove(String code) async {
    final current = state;
    if (current is! VoucherReady || current.busyCode != null) return;
    emit(current.copyWith(busyCode: code, actionError: null, notice: null));
    final result = await _cart.removeVoucher(code);
    if (isClosed) return;
    await _afterCartMutation(result, notice: 'Voucher $code dilepas.');
  }

  /// Mengklaim kode ke dompet voucher (`POST /vouchers/claim`). **Tidak**
  /// memasangnya ke keranjang — dua langkah yang terpisah di server.
  Future<void> claim(String rawCode) async {
    final current = state;
    if (current is! VoucherReady || current.busyCode != null) return;
    final code = rawCode.trim();
    if (code.isEmpty) {
      emit(current.copyWith(
          actionError: _localValidation('Masukkan kode voucher dulu.')));
      return;
    }

    emit(current.copyWith(busyCode: code, actionError: null, notice: null));
    final result = await _vouchers.claim(code);
    if (isClosed) return;
    final latest = state is VoucherReady ? state as VoucherReady : current;
    switch (result) {
      case DataSuccess(:final data):
        emit(latest.copyWith(
          busyCode: null,
          claimed: data,
          claimedError: null,
          notice: 'Voucher $code disimpan ke Voucher Saya.',
        ));
      case DataFailed(:final error):
        emit(latest.copyWith(busyCode: null, actionError: error));
      case DataEmpty():
      case DataLoading():
        emit(latest.copyWith(busyCode: null));
    }
  }

  /// "Gunakan Otomatis": server memilih voucher terbaik per slot lalu
  /// langsung memasangnya.
  Future<void> autoApply() async {
    final current = state;
    if (current is! VoucherReady ||
        current.autoApplying ||
        current.busyCode != null) {
      return;
    }
    if (current.summary.isEmpty) return;

    emit(current.copyWith(autoApplying: true, actionError: null, notice: null));
    final result = await _vouchers.autoApply();
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        // Balasannya hanya daftar yang dipasang; ringkasan (dan potongan
        // totalnya) dibaca ulang dari keranjang.
        final cart = await _cart.fetchCart();
        if (isClosed) return;
        final latest = state is VoucherReady ? state as VoucherReady : current;
        emit(latest.copyWith(
          autoApplying: false,
          summary: cart is DataSuccess<CartSnapshot>
              ? cart.data.summary
              : latest.summary,
          notice: data.isEmpty
              ? 'Belum ada voucher yang bisa dipakai untuk keranjang ini.'
              : '${data.length} voucher terbaik dipakai.',
        ));
      case DataFailed(:final error):
        final latest = state is VoucherReady ? state as VoucherReady : current;
        emit(latest.copyWith(autoApplying: false, actionError: error));
      case DataEmpty():
      case DataLoading():
        final latest = state is VoucherReady ? state as VoucherReady : current;
        emit(latest.copyWith(autoApplying: false));
    }
  }

  void clearMessages() {
    final current = state;
    if (current is! VoucherReady) return;
    if (current.actionError == null && current.notice == null) return;
    emit(current.copyWith(actionError: null, notice: null));
  }

  Future<void> _afterCartMutation(
    DataState<CartSnapshot> result, {
    required String notice,
  }) async {
    final current = state;
    if (current is! VoucherReady) return;
    switch (result) {
      case DataSuccess(:final data):
        emit(current.copyWith(
            busyCode: null, summary: data.summary, notice: notice));
        // Isi slot berubah, jadi "terbaik per slot" ikut berubah.
        await _loadRecommended();
      case DataFailed(:final error):
        emit(current.copyWith(busyCode: null, actionError: error));
      case DataEmpty():
        emit(current.copyWith(
            busyCode: null, summary: const CartSummaryModel()));
      case DataLoading():
        emit(current.copyWith(busyCode: null));
    }
  }

  Future<void> _loadRecommended() async {
    final current = state;
    if (current is! VoucherReady) return;
    if (current.summary.isEmpty) {
      emit(current.copyWith(recommended: const [], recommendedError: null));
      return;
    }
    final result = await _vouchers.fetchRecommended();
    if (isClosed) return;
    final latest = state is VoucherReady ? state as VoucherReady : current;
    switch (result) {
      case DataSuccess(:final data):
        emit(latest.copyWith(recommended: data, recommendedError: null));
      case DataFailed(:final error):
        emit(latest.copyWith(recommended: const [], recommendedError: error));
      case DataEmpty():
        emit(latest.copyWith(recommended: const [], recommendedError: null));
      case DataLoading():
        break;
    }
  }
}
