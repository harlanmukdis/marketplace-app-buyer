import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/support_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

part 'support_new_ticket_cubit.freezed.dart';
part 'support_new_ticket_state.dart';

/// Formulir tiket Xpedia 911 baru.
///
/// 🔴 [relatedOrderId] **dipatok saat cubit dibuat** dan tidak bisa diubah
/// dari formulir. Server tidak memeriksa kepemilikan pesanan yang dirujuk,
/// dan id pesanan yang tidak ada meledak jadi 500 HTML (pelanggaran foreign
/// key). Satu-satunya sumber id yang aman adalah pesanan milik user yang
/// sedang dibuka — yang datang lewat rute.
class SupportNewTicketCubit extends Cubit<SupportNewTicketState> {
  SupportNewTicketCubit({this.relatedOrderId})
      : _repository = injector<SupportRepository>(),
        super(SupportNewTicketState(
          // Tiket dari halaman pesanan hampir pasti soal pesanan itu.
          category: relatedOrderId != null ? SupportCategory.orderTransaction : null,
        ));

  static SupportNewTicketCubit get(BuildContext context) => BlocProvider.of(context);

  final SupportRepository _repository;
  final int? relatedOrderId;

  static const int maxSubjectLength = 150;

  void selectCategory(SupportCategory category) =>
      emit(state.copyWith(category: category, error: null));

  Future<void> submit({required String subject, required String description}) async {
    if (state.isSubmitting || state.created != null) return;

    final problem = switch ((state.category, subject.trim(), description.trim())) {
      (null, _, _) => 'Pilih kategori masalah',
      (_, '', _) => 'Tulis subjek tiket',
      (_, final s, _) when s.length > maxSubjectLength =>
        'Subjek maksimal $maxSubjectLength karakter',
      (_, _, '') => 'Ceritakan masalahmu di deskripsi',
      _ => null,
    };
    if (problem != null) {
      emit(state.copyWith(error: localValidationError(problem)));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));
    final result = await _repository.createTicket(
      category: state.category!,
      subject: subject.trim(),
      description: description.trim(),
      relatedOrderId: relatedOrderId,
    );
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => state.copyWith(isSubmitting: false, created: data),
      DataFailed(:final error) => state.copyWith(isSubmitting: false, error: error),
      _ => state.copyWith(isSubmitting: false),
    });
  }
}
