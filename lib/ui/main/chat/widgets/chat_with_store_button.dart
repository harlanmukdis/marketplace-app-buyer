import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
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
/// ⚠️ **Nama toko tidak ikut dikirim**, sehingga judul ruangnya jatuh ke
/// "Chat". `GET /products/{id}` hanya membawa `store_id` — tidak ada nama
/// toko di dalamnya, dan tidak ada endpoint publik untuk menukar id jadi
/// nama. Namanya baru muncul saat ruang dibuka lewat daftar percakapan, yang
/// responsnya memang di-join ke `stores`.
class ChatWithStoreButton extends StatelessWidget {
  const ChatWithStoreButton({super.key, required this.storeId});

  final int storeId;

  @override
  Widget build(BuildContext context) {
    // Cubit lokal sekali pakai: tombol ini hanya butuh `openWithStore`, dan
    // memuat seluruh daftar percakapan demi membuka satu ruang akan jadi
    // permintaan yang terbuang.
    return BlocProvider(
      create: (_) => ChatListCubit(),
      child: _Button(storeId: storeId),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button({required this.storeId});

  final int storeId;

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

    if (mounted) context.push(AppRoutes.chatRoomPath(id));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _opening ? null : _open,
        icon: _opening
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.chat_bubble_outline, size: 18),
        label: const Text('Chat penjual'),
      ),
    );
  }
}
