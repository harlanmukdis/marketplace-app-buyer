import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/chat/chat_room_context.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_list_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';

/// Tombol "Chat penjual" di halaman produk.
///
/// Dipasang di sini karena **halaman produklah yang tahu `store_id`**. Daftar
/// percakapan tidak punya cara memulai percakapan baru: tidak ada pencarian
/// toko di app member, jadi satu-satunya pintu masuk adalah dari produk yang
/// dijual toko itu.
///
/// `POST /chat/conversations` bersifat **get-or-create** (tabelnya punya
/// `UNIQUE (buyer_id, store_id)`), jadi menekan tombol ini berkali-kali tidak
/// menumpuk percakapan duplikat.
///
/// `GET /products/{id}` hanya membawa `store_id`, tanpa nama toko. Pemanggil
/// yang sudah memuat profil tokonya (`GET /stores/{id}`, publik) mengoper
/// [storeName] supaya judul ruang langsung benar; tanpa itu judulnya jatuh ke
/// "Chat" sampai ruang dibuka lewat daftar percakapan, yang di-join ke
/// `stores`.
///
/// [productId] diisi halaman produk: ruang chat lalu menawarkan kartu
/// "Tanyakan produk ini" yang mengirim `product_share` — pertanyaan penjual
/// langsung punya konteks tanpa pembeli menyalin nama produk.
class ChatWithStoreButton extends StatelessWidget {
  const ChatWithStoreButton({super.key, required this.storeId, this.storeName, this.productId});

  final int storeId;
  final String? storeName;
  final int? productId;

  @override
  Widget build(BuildContext context) {
    // Cubit lokal sekali pakai: tombol ini hanya butuh `openWithStore`, dan
    // memuat seluruh daftar percakapan demi membuka satu ruang akan jadi
    // permintaan yang terbuang.
    return BlocProvider(
      create: (_) => ChatListCubit(),
      child: _Button(storeId: storeId, storeName: storeName, productId: productId),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button({required this.storeId, this.storeName, this.productId});

  final int storeId;
  final String? storeName;
  final int? productId;

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool _opening = false;

  Future<void> _open() async {
    setState(() => _opening = true);

    final cubit = ChatListCubit.get(context);
    final id = await cubit.openWithStore(widget.storeId);
    if (!mounted) return;
    setState(() => _opening = false);

    if (id == null) {
      final state = cubit.state;
      final error = state is ChatListLoaded ? state.actionError : null;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            error == null
                ? 'Gagal membuka chat.'
                : errorMessageFor(context, error),
          ),
        ));
      cubit.clearActionError();
      return;
    }

    final name = widget.storeName?.trim();
    ChatRoomContext.put(
      id,
      ChatRoomContext(storeId: widget.storeId, productId: widget.productId),
    );
    if (mounted) {
      context.push(
        AppRoutes.chatRoomPath(id),
        extra: name == null || name.isEmpty ? null : name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: _opening ? null : _open,
        style: OutlinedButton.styleFrom(
          foregroundColor: XpColors.textSecondary,
          side: BorderSide(color: XpColors.borderDefault),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(XpRadius.m)),
          textStyle: XpText.labelL(context),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        icon: _opening
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.chat_outlined, size: 18),
        label: const Text('Chat Penjual'),
      ),
    );
  }
}
