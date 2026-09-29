import 'package:flutter/foundation.dart';

/// Konteks yang dibawa ke ruang chat dari layar asalnya: toko dan (opsional)
/// produk yang sedang dilihat.
///
/// **Kenapa bukan argumen rute:** rute `/chat-room/:id` meneruskan `extra`
/// sebagai `String?` (nama toko) dan dibaca di `app_routes.dart`. Supaya
/// kontrak rute tidak berubah, pemanggil menitipkan konteks di sini tepat
/// sebelum `push`, dan `ChatRoomScreen` mengambilnya sekali saat dibuka.
/// Konteksnya **opsional**: ruang yang dibuka lewat daftar percakapan atau
/// refresh web tetap berfungsi — hanya tanpa kartu "Tanyakan produk ini".
@immutable
class ChatRoomContext {
  const ChatRoomContext({this.storeId, this.productId});

  final int? storeId;
  final int? productId;

  static final Map<int, ChatRoomContext> _pending = {};

  /// Dititipkan tombol "Chat Penjual" sebelum membuka ruang.
  static void put(int conversationId, ChatRoomContext context) =>
      _pending[conversationId] = context;

  /// Diambil (dan dihapus) oleh ruang chat. Dihapus supaya membuka ruang yang
  /// sama dari daftar percakapan nanti tidak memunculkan kartu produk lama.
  static ChatRoomContext? take(int conversationId) => _pending.remove(conversationId);

  @visibleForTesting
  static void reset() => _pending.clear();
}
