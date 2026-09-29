import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

part 'identity_verification_cubit.freezed.dart';
part 'identity_verification_state.dart';

/// Verifikasi identitas (KTP) — **kontrak usulan**, dijawab mock di debug
/// (docs/22 #4). Dipakai tiga layar: Keamanan Akun (pengajuan), Ubah Profil
/// (kunci nama, #11), dan My Xpedia (pil status).
///
/// Tanpa mock, endpoint-nya dibalas 404 HTML → [IdentityVerificationState.unavailable]:
/// fiturnya disembunyikan, bukan ditampilkan sebagai error, supaya build
/// tanpa mock tetap bersih.
class IdentityVerificationCubit extends Cubit<IdentityVerificationState> {
  IdentityVerificationCubit()
      : _repository = injector<AccountRepository>(),
        super(const IdentityVerificationState.loading());

  static IdentityVerificationCubit get(BuildContext context) => BlocProvider.of(context);

  final AccountRepository _repository;

  Future<void> load() async {
    final result = await _repository.fetchIdentityVerification();
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data, :final meta) =>
        IdentityVerificationState.ready(verification: data, meta: meta),
      DataFailed(:final error) when error.isRouteNotFound =>
        const IdentityVerificationState.unavailable(),
      DataFailed(:final error) => IdentityVerificationState.error(error),
      _ => const IdentityVerificationState.unavailable(),
    });
  }

  /// Mengajukan NIK + nama sesuai KTP.
  Future<bool> submit({required String idCardNumber, required String fullName}) async {
    final current = state;
    if (current is! IdentityVerificationReady || current.isSubmitting) return false;

    final nik = idCardNumber.replaceAll(RegExp(r'\s'), '');
    final name = fullName.trim();
    final DataError? invalid = !RegExp(r'^\d{16}$').hasMatch(nik)
        ? localValidationError('NIK harus 16 digit angka, sesuai KTP.')
        : name.length < 3
            ? localValidationError('Tulis nama lengkap persis seperti di KTP.')
            : null;
    if (invalid != null) {
      emit(current.copyWith(submitError: invalid));
      return false;
    }

    emit(current.copyWith(isSubmitting: true, submitError: null));
    final result = await _repository.submitIdentityVerification(
      idCardNumber: nik,
      fullName: name,
    );
    if (isClosed) return false;
    switch (result) {
      case DataSuccess(:final data, :final meta):
        emit(IdentityVerificationState.ready(verification: data, meta: meta));
        return true;
      case DataFailed(:final error):
        emit(current.copyWith(isSubmitting: false, submitError: error));
        return false;
      default:
        emit(current.copyWith(isSubmitting: false));
        return false;
    }
  }
}
