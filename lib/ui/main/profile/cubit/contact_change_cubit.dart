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

/// Ganti email / nomor HP (backend `b501fc3`, docs/22 #10): minta kode →
/// kode dikirim ke kontak **lama** → masukkan kode → tersimpan.
///
/// Satu tahap verifikasi saja — server tidak memverifikasi kontak baru; ia
/// tersimpan dengan status belum terverifikasi.
class ContactChangeCubit extends Cubit<ContactChangeState> {
  ContactChangeCubit({required ContactType type, this.currentValue})
      : _repository = injector<AccountRepository>(),
        super(ContactChangeState(type: type));

  static ContactChangeCubit get(BuildContext context) => BlocProvider.of(context);

  final AccountRepository _repository;

  /// Kontak yang sekarang. Server menolak nilai yang sama dengan
  /// `EMAIL_TAKEN`/`PHONE_TAKEN` (akun ini sendiri dianggap "pemakai"), jadi
  /// dicegah lebih dulu dengan pesan yang tepat — dan tanpa menghabiskan
  /// kuota 3 permintaan per jam.
  final String? currentValue;

  // Server tidak memvalidasi format sama sekali — hanya "tidak kosong".
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phone = RegExp(r'^(\+62|62|0)8\d{7,12}$');

  /// Meminta kode verifikasi (dikirim ke kontak lama). Dipakai juga untuk
  /// "kirim ulang": permintaan baru membatalkan kode lama.
  Future<void> request(String rawValue) async {
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
    final result = await _repository.requestContactChange(type: type, newValue: value);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => state.copyWith(isBusy: false, request: data),
      DataFailed(:final error) => state.copyWith(isBusy: false, error: error),
      _ => state.copyWith(isBusy: false),
    });
  }

  /// Menyimpan kontak baru dengan kode dari email/SMS.
  ///
  /// Kode server berupa 64 karakter hex, jadi yang diperiksa lokal hanya
  /// "tidak kosong" — ketatnya format biar server yang menentukan.
  ///
  /// `EMAIL_TAKEN`/`PHONE_TAKEN` di sini berarti kontaknya keburu dipakai
  /// akun lain, **dan kodenya sudah hangus** di server — jadi kembali ke
  /// langkah mengisi kontak, bukan menunggu kode lagi.
  Future<void> confirm(String rawToken) async {
    if (state.isBusy || !state.awaitingToken) return;
    final token = rawToken.replaceAll(RegExp(r'\s'), '');
    if (token.isEmpty) {
      emit(state.copyWith(error: localValidationError('Masukkan kode verifikasi.')));
      return;
    }
    emit(state.copyWith(isBusy: true, error: null));
    final result = await _repository.confirmContactChange(type: state.type, token: token);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess() => state.copyWith(isBusy: false, completed: true),
      DataFailed(:final error)
          when error.code == ApiErrorCode.emailTaken ||
              error.code == ApiErrorCode.phoneTaken =>
        ContactChangeState(type: state.type, newValue: state.newValue, error: error),
      DataFailed(:final error) => state.copyWith(isBusy: false, error: error),
      _ => state.copyWith(isBusy: false),
    });
  }

  /// Kembali ke langkah mengisi kontak baru. Kode lama dibiarkan kedaluwarsa
  /// — permintaan berikutnya membatalkannya di server.
  void restart() => emit(ContactChangeState(type: state.type, newValue: state.newValue));
}
