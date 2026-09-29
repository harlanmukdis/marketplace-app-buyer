import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/chat/chat_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:marketplace_app_member/core/services/token_store.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'chat_room_cubit.freezed.dart';
part 'chat_room_state.dart';

/// Satu ruang percakapan.
///
/// Tiga keputusan yang dipaksa keadaan server:
///
/// 🔴 **1. Tidak memakai `/poll`, melainkan membaca ulang berkala.**
/// Endpoint poll menahan request sampai 25 detik, dan API dijalankan dengan
/// `php -S` yang **single-threaded**. Diukur ke server: satu poll menggantung
/// 25 detik dan `GET /products` yang dikirim 4 detik sesudahnya baru dijawab
/// 21 detik kemudian. Satu layar chat terbuka akan **membekukan seluruh
/// aplikasi**. Ganti ke poll hanya setelah backend berjalan multi-proses.
///
/// 🔴 **2. Urutan dari server tidak bisa dipakai apa adanya.** `ORDER BY
/// created_at DESC` tanpa pemecah seri, di atas kolom `DATETIME` beresolusi
/// satu detik: blok detik menurun tapi isi tiap detik menaik. Membalik
/// daftarnya menghasilkan percakapan yang kacau. [_merge] mengurutkannya
/// ulang menurut `(createdAt, id)` **menaik** — urutan baca percakapan.
///
/// **3. Pesan yang baru terkirim tidak bisa dirender dari balasannya.**
/// `POST .../messages` hanya membalas `{id}` — tanpa `created_at` maupun
/// `sender_user_id`. Repository yang membaca ulang.
class ChatRoomCubit extends Cubit<ChatRoomState> {
  ChatRoomCubit(this.conversationId)
      : _repository = injector<ChatRepository>(),
        _myUserId = injector<TokenStore>().userId,
        super(const ChatRoomState.loading());

  static ChatRoomCubit get(BuildContext context) => BlocProvider.of(context);

  final int conversationId;
  final ChatRepository _repository;

  /// Id user yang sedang masuk, untuk memisahkan gelembung kiri/kanan.
  ///
  /// Tidak ada field "dari saya" di respons; satu-satunya penanda adalah
  /// membandingkan `sender_user_id`.
  final int? _myUserId;

  int? get myUserId => _myUserId;

  Timer? _refreshTimer;

  /// Jeda penyegaran.
  ///
  /// Bukan angka ajaib: cukup rapat supaya percakapan terasa hidup, cukup
  /// renggang supaya satu layar chat tidak membanjiri server yang
  /// single-threaded. Tiap tik hanya membaca halaman pertama (30 pesan).
  static const Duration refreshInterval = Duration(seconds: 5);

  Future<void> load() async {
    emit(const ChatRoomState.loading());
    final result = await _repository.fetchMessages(conversationId);
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(ChatRoomState.ready(messages: _merge(const [], data)));
        // Menandai terbaca tidak boleh menggagalkan pembukaan ruang, jadi
        // hasilnya sengaja diabaikan.
        unawaited(_repository.markRead(conversationId));
        _startAutoRefresh();
      case DataFailed(:final error):
        emit(ChatRoomState.error(error));
      case DataEmpty():
      case DataLoading():
        break;
    }
  }

  /// Membaca ulang halaman pertama tanpa mengosongkan layar.
  ///
  /// Dipakai timer maupun tarik-untuk-segarkan. Kegagalannya **diam**: koneksi
  /// yang putus sesaat tidak boleh menghapus percakapan yang sedang dibaca
  /// atau memunculkan spanduk error tiap lima detik.
  Future<void> refresh() async {
    final current = state;
    if (current is! ChatRoomReady) return;

    final result = await _repository.fetchMessages(conversationId);
    if (isClosed) return;

    if (result case DataSuccess(:final data)) {
      final merged = _merge(current.messages, data);
      // Emit hanya kalau memang ada yang berubah — kalau tidak, daftar
      // dibangun ulang tiap lima detik dan posisi gulir bisa tersentak.
      if (merged.length != current.messages.length) {
        emit(current.copyWith(messages: merged));
        unawaited(_repository.markRead(conversationId));
      }
    }
  }

  /// Mengirim pesan. Mengembalikan `true` kalau pesannya benar-benar
  /// tersimpan di server.
  ///
  /// Teks kosong ditolak tanpa menyentuh jaringan: server menerimanya dan
  /// membalas `201` dengan `content: null`, menyisakan gelembung hampa yang
  /// tidak bisa dihapus.
  ///
  /// Nilai kembaliannya dipakai layar untuk **mengembalikan teks ke kolom
  /// ketik** saat gagal — terutama `422 CHAT_CONTENT_BLOCKED` (pesan memuat
  /// nomor HP/email/tautan), yang tidak menyimpan apa pun di server. Tanpa
  /// itu user harus mengetik ulang seluruh pesannya hanya untuk menghapus
  /// satu nomor.
  Future<bool> send(String text) async {
    final content = text.trim();
    if (content.isEmpty) return false;

    final current = state;
    if (current is! ChatRoomReady || current.isSending) return false;

    emit(current.copyWith(
      isSending: true,
      pendingText: content,
      actionError: null,
    ));
    final result =
        await _repository.sendMessage(conversationId, content: content);
    if (isClosed) return false;

    final latest = state;
    if (latest is! ChatRoomReady) return false;

    switch (result) {
      case DataSuccess(:final data):
        emit(latest.copyWith(
          messages: _merge(latest.messages, data),
          isSending: false,
          pendingText: null,
        ));
        return true;
      case DataFailed(:final error):
        emit(latest.copyWith(
          isSending: false,
          pendingText: null,
          actionError: error,
        ));
        return false;
      case DataEmpty():
      case DataLoading():
        emit(latest.copyWith(isSending: false, pendingText: null));
        return false;
    }
  }

  /// Membagikan produk (`product_share`) atau pesanan (`order_share`).
  ///
  /// Dikirim **tanpa `content`**: kartunya dirakit dari id yang dibagikan,
  /// dan tanpa teks tidak ada yang bisa tersangkut moderasi. Selama
  /// mengirim, gelembung "menunggu" menampilkan [pendingLabel].
  Future<bool> share({int? productId, int? orderId}) async {
    assert((productId == null) != (orderId == null));
    final current = state;
    if (current is! ChatRoomReady || current.isSending) return false;

    emit(current.copyWith(
      isSending: true,
      pendingText: productId != null ? 'Membagikan produk…' : 'Membagikan pesanan…',
      actionError: null,
    ));
    final result = await _repository.share(
      conversationId,
      productId: productId,
      orderId: orderId,
    );
    if (isClosed) return false;
    final latest = state;
    if (latest is! ChatRoomReady) return false;

    switch (result) {
      case DataSuccess(:final data):
        emit(latest.copyWith(
          messages: _merge(latest.messages, data),
          isSending: false,
          pendingText: null,
        ));
        return true;
      case DataFailed(:final error):
        emit(latest.copyWith(isSending: false, pendingText: null, actionError: error));
        return false;
      case DataEmpty():
      case DataLoading():
        emit(latest.copyWith(isSending: false, pendingText: null));
        return false;
    }
  }

  void clearActionError() {
    final current = state;
    if (current is! ChatRoomReady || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(refreshInterval, (_) => refresh());
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }

  /// Menggabungkan hasil baca ulang: buang yang berulang, lalu urutkan
  /// **terlama di atas** — arah baca percakapan.
  ///
  /// Pesan lama dipertahankan alih-alih diganti salinan baru, supaya daftar
  /// tidak dibangun ulang tiap tik hanya karena objeknya berbeda instance.
  static List<ChatMessageModel> _merge(
    List<ChatMessageModel> existing,
    List<ChatMessageModel> incoming,
  ) {
    final byId = <int, ChatMessageModel>{
      for (final m in incoming) m.id: m,
      for (final m in existing) m.id: m,
    };

    return byId.values.toList()
      ..sort((a, b) {
        final at = a.createdAt;
        final bt = b.createdAt;
        if (at != null && bt != null && at != bt) return at.compareTo(bt);
        // Pemecah seri yang tidak dimiliki server: id auto-increment adalah
        // satu-satunya kunci yang pasti menaik dan pasti unik.
        return a.id.compareTo(b.id);
      });
  }
}
