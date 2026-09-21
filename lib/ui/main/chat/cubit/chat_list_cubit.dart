import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'chat_list_cubit.freezed.dart';
part 'chat_list_state.dart';

/// Daftar percakapan pembeli.
///
/// ⚠️ **Tidak ada lencana "belum dibaca" di sini, dan itu disengaja.** Kolom
/// `buyer_unread_count` ada di skema tapi **tidak ada satu pun kode backend
/// yang pernah mengisinya** — ia permanen `0`. Satu-satunya penanda terbaca
/// yang nyata adalah `read_at` di tiap pesan, dan daftar percakapan tidak
/// membawa pesan sama sekali. Menghitungnya berarti menembak
/// `/messages` untuk setiap baris — N+1 demi angka yang kemudian tetap
/// menghitung "pesan lawan yang belum saya buka", bukan "pesan baru".
class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit()
      : _repository = injector<ChatRepository>(),
        super(const ChatListState.loading());

  static ChatListCubit get(BuildContext context) => BlocProvider.of(context);

  final ChatRepository _repository;

  Future<void> load() async {
    emit(const ChatListState.loading());
    final result = await _repository.fetchConversations();
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(ChatListState.loaded(conversations: _sorted(data)));
      case DataEmpty():
        emit(const ChatListState.empty());
      case DataFailed(:final error):
        emit(ChatListState.error(error));
      case DataLoading():
        break;
    }
  }

  Future<void> refresh() => load();

  /// Membuka percakapan dengan satu toko lalu mengembalikan idnya.
  ///
  /// **Get-or-create di server**, jadi aman dipanggil berkali-kali dari
  /// halaman produk — tidak akan menumpuk percakapan duplikat.
  Future<int?> openWithStore(int storeId) async {
    final result = await _repository.openConversation(storeId: storeId);
    if (isClosed) return null;

    switch (result) {
      case DataSuccess(:final data):
        return data;
      case DataFailed(:final error):
        final current = state;
        if (current is ChatListLoaded) {
          emit(current.copyWith(actionError: error));
        } else {
          emit(ChatListState.error(error));
        }
        return null;
      case DataEmpty():
      case DataLoading():
        return null;
    }
  }

  void clearActionError() {
    final current = state;
    if (current is! ChatListLoaded || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  /// Terbaru di atas.
  ///
  /// Server sudah `ORDER BY last_message_at DESC`, tapi field itu **`null`
  /// untuk percakapan yang belum berisi pesan** — dan MySQL menaruh `NULL`
  /// di akhir pada urutan menurun, sehingga percakapan yang baru dibuka
  /// tenggelam di bawah percakapan lama. Diurutkan ulang memakai
  /// [ChatConversationModel.sortedAt], yang jatuh ke `created_at`.
  static List<ChatConversationModel> _sorted(
    List<ChatConversationModel> source,
  ) {
    return [...source]..sort((a, b) {
        final at = a.sortedAt;
        final bt = b.sortedAt;
        if (at == null && bt == null) return b.id.compareTo(a.id);
        if (at == null) return 1;
        if (bt == null) return -1;
        final byTime = bt.compareTo(at);
        return byTime != 0 ? byTime : b.id.compareTo(a.id);
      });
  }
}
