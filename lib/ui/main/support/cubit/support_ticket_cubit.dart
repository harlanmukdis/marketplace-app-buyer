import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/support_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

part 'support_ticket_cubit.freezed.dart';
part 'support_ticket_state.dart';

/// Satu tiket Xpedia 911 beserta percakapannya.
///
/// ⚠️ `description` tiket **tidak** tersimpan sebagai pesan pertama, jadi
/// layar menampilkannya terpisah di atas percakapan.
class SupportTicketCubit extends Cubit<SupportTicketState> {
  SupportTicketCubit(this.ticketId)
      : _repository = injector<SupportRepository>(),
        super(const SupportTicketState.loading());

  static SupportTicketCubit get(BuildContext context) => BlocProvider.of(context);

  final int ticketId;
  final SupportRepository _repository;

  Future<void> load() async {
    emit(const SupportTicketState.loading());
    // Diambil terpisah, lalu di-await masing-masing, supaya kegagalan salah
    // satunya tidak jadi unhandled async error.
    final ticketFuture = _repository.fetchTicket(ticketId);
    final messagesFuture = _repository.fetchMessages(ticketId);
    final ticket = await ticketFuture;
    final messages = await messagesFuture;
    if (isClosed) return;

    switch (ticket) {
      case DataSuccess(:final data):
        emit(SupportTicketState.ready(
          ticket: data,
          messages: _sorted(messages.valueOrNull ?? const []),
          // Tiket tanpa pesan itu wajar; yang gagal dimuat diberi tanda
          // supaya layar tidak mengatakan "belum ada balasan" padahal
          // balasannya hanya tidak terbaca.
          messagesError: messages is DataFailed<List<SupportMessageModel>>
              ? messages.error
              : null,
        ));
      case DataFailed(:final error):
        emit(SupportTicketState.error(error));
      case DataEmpty():
      case DataLoading():
        emit(const SupportTicketState.error(DataError(
          code: ApiErrorCode.notFound,
          message: 'Tiket tidak ditemukan',
          kind: DataErrorKind.api,
        )));
    }
  }

  /// Mengirim pesan. Menolak teks kosong sendiri (server membalas `422`), dan
  /// tidak mengirim ke tiket yang sudah selesai/ditutup.
  ///
  /// Mengembalikan `true` kalau terkirim, supaya layar tahu kapan kolom tulis
  /// boleh dikosongkan.
  Future<bool> send(String text) async {
    final current = state;
    if (current is! SupportTicketReady || current.isSending) return false;
    final message = text.trim();
    if (message.isEmpty) return false;
    if (!current.ticket.acceptsMessages) {
      emit(current.copyWith(
          actionError: localValidationError(
              'Tiket ini sudah ${current.ticket.statusLabel.toLowerCase()}. '
              'Buat tiket baru kalau masih butuh bantuan.')));
      return false;
    }

    emit(current.copyWith(isSending: true, actionError: null));
    final result = await _repository.sendMessage(ticketId, message);
    if (isClosed) return false;

    switch (result) {
      case DataSuccess(:final data):
        // Pesan pertama pengguna memindahkan tiket `open` → `in_progress`,
        // jadi tiketnya ikut dibaca ulang supaya pil statusnya tidak basi.
        final ticket = await _repository.fetchTicket(ticketId);
        if (isClosed) return true;
        emit(current.copyWith(
          isSending: false,
          messages: _sorted(data),
          messagesError: null,
          ticket: ticket.valueOrNull ?? current.ticket,
        ));
        return true;
      case DataEmpty():
        emit(current.copyWith(isSending: false));
        return true;
      case DataFailed(:final error):
        emit(current.copyWith(isSending: false, actionError: error));
        return false;
      case DataLoading():
        emit(current.copyWith(isSending: false));
        return false;
    }
  }

  void clearActionError() {
    final current = state;
    if (current is SupportTicketReady && current.actionError != null) {
      emit(current.copyWith(actionError: null));
    }
  }

  /// Urutan baca percakapan: terlama dulu, `id` sebagai pemecah seri.
  ///
  /// Urutan server tidak dijamin — `created_at` beresolusi satu detik dan
  /// endpoint lain di API ini terbukti tidak memakai pemecah seri (lihat
  /// domain chat & notifikasi).
  static List<SupportMessageModel> _sorted(List<SupportMessageModel> messages) {
    final list = [...messages];
    list.sort((a, b) {
      final at = a.createdAt, bt = b.createdAt;
      if (at != null && bt != null) {
        final byTime = at.compareTo(bt);
        if (byTime != 0) return byTime;
      }
      return a.id.compareTo(b.id);
    });
    return list;
  }
}
