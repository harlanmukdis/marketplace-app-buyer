part of 'chat_room_cubit.dart';

/// Status satu ruang percakapan.
///
/// Tidak ada varian `empty`: percakapan tanpa pesan adalah keadaan yang sah
/// dan sering terjadi — `POST /chat/conversations` membuat barisnya lebih dulu
/// tanpa pesan apa pun. Ruangnya tetap [ChatRoomReady] dengan daftar kosong,
/// supaya kolom ketik tetap bisa dipakai.
@freezed
sealed class ChatRoomState with _$ChatRoomState {
  const ChatRoomState._();

  const factory ChatRoomState.loading() = ChatRoomLoading;

  const factory ChatRoomState.ready({
    required List<ChatMessageModel> messages,

    /// Sedang mengirim pesan.
    @Default(false) bool isSending,

    /// Isi pesan yang sedang dikirim, dirender sebagai gelembung "menunggu"
    /// (ikon jam) di ujung percakapan.
    ///
    /// Bukan [ChatMessageModel] palsu: pesan sungguhan baru ada setelah baca
    /// ulang (balasan `POST` hanya `{id}`), dan menyisipkan model karangan ke
    /// [messages] berarti ia ikut diurutkan dan digabung seolah datang dari
    /// server. Dikosongkan lagi begitu pengiriman selesai, berhasil maupun
    /// gagal.
    String? pendingText,
    DataError? actionError,
  }) = ChatRoomReady;

  const factory ChatRoomState.error(DataError error) = ChatRoomError;
}
