import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

part 'contact_change_cubit.freezed.dart';
part 'contact_change_state.dart';

/// Ganti email / nomor HP dengan OTP dua tahap — **kontrak usulan**, dijawab
/// mock di debug (docs/22 #10). Backend belum punya endpoint ganti kontak
/// sama sekali; `PATCH /me` hanya menerima `full_name` dan `avatar_url`.
class ContactChangeCubit extends Cubit<ContactChangeState> {
  ContactChangeCubit({required ContactType type, this.currentValue})
      : _repository = injector<AccountRepository>(),
        super(ContactChangeState(type: type));

  static ContactChangeCubit get(BuildContext context) => BlocProvider.of(context);

  final AccountRepository _repository;

  /// Kontak yang sekarang, untuk menolak "ganti ke nilai yang sama" sebelum
  /// menghabiskan kuota permintaan OTP.
  final String? currentValue;

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phone = RegExp(r'^(\+62|62|0)8\d{7,12}$');

  /// Tahap 1: minta OTP (ke kontak lama).
  Future<void> start(String rawValue) async {
    if (state.isBusy) return;
    final type = state.type;
    final value = type == ContactType.phone
        ? rawValue.replaceAll(RegExp(r'[\s-]'), '')
        : rawValue.trim();
    final DataError? invalid = switch (type) {
      ContactType.email when !_email.hasMatch(value) =>
        localValidationError('Format email belum benar.'),
      ContactType.phone when !_phone.hasMatch(value) =>
        localValidationError('Nomor HP diawali 08 atau +628, 10–15 digit.'),
      _ when currentValue != null && value.toLowerCase() == currentValue!.toLowerCase() =>
        localValidationError('${type.label} baru sama dengan yang sekarang.'),
      _ => null,
    };
    if (invalid != null) {
      emit(state.copyWith(error: invalid));
      return;
    }

    emit(state.copyWith(isBusy: true, error: null, newValue: value));
    final result = await _repository.startContactChange(type: type, newValue: value);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data, :final meta) =>
        state.copyWith(isBusy: false, challenge: data, meta: meta),
      DataFailed(:final error) when error.isRouteNotFound =>
        state.copyWith(isBusy: false, unavailable: true),
      DataFailed(:final error) => state.copyWith(isBusy: false, error: error),
      _ => state.copyWith(isBusy: false),
    });
  }

  /// Tahap 2 dan 3: kirim OTP untuk tantangan yang sedang aktif.
  Future<void> verify(String otp) async {
    final challenge = state.challenge;
    if (state.isBusy || challenge == null || challenge.isCompleted) return;
    final code = otp.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      emit(state.copyWith(error: localValidationError('Kode OTP terdiri dari 6 angka.')));
      return;
    }
    emit(state.copyWith(isBusy: true, error: null));
    final result = await _repository.verifyContactChange(
      requestId: challenge.requestId,
      otp: code,
    );
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data, :final meta) =>
        state.copyWith(isBusy: false, challenge: data, meta: meta),
      DataFailed(:final error) => state.copyWith(isBusy: false, error: error),
      _ => state.copyWith(isBusy: false),
    });
  }

  /// Kembali ke langkah mengisi kontak baru. Permintaan lama dibiarkan
  /// kedaluwarsa di server — permintaan baru untuk jenis yang sama
  /// menggantikannya.
  void restart() => emit(ContactChangeState(type: state.type, newValue: state.newValue));
}
