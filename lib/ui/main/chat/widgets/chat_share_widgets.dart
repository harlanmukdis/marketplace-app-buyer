import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/catalog/product_model.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_room_cubit.dart';
import 'package:marketplace_app_member/ui/main/chat/cubit/chat_share_cubit.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Kartu, laci, dan lembar untuk berbagi produk & pesanan di ruang chat.
///
/// Pesan bagikan hanya membawa `shared_product_id` / `shared_order_id` —
/// isinya diambil [ChatShareCubit] sekali per id. Selama belum termuat (atau
/// gagal, mis. pesanan yang dibagikan penjual bukan milik pembeli ini),
/// kartunya tetap tampil dengan id saja: pesan yang terbaca lebih baik
/// daripada gelembung kosong.

/// Kartu "Tanyakan produk ini" yang disematkan di atas percakapan saat ruang
/// dibuka dari halaman produk (desain §3.23 no. 2).
class PinnedProductCard extends StatelessWidget {
  const PinnedProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    final product = context.select<ChatShareCubit, ProductModel?>((c) => c.state.pinnedProduct);
    if (product == null) return const SizedBox.shrink();
    final sending = context.select<ChatRoomCubit, bool>(
        (c) => c.state is ChatRoomReady && (c.state as ChatRoomReady).isSending);

    return Container(
      color: XpColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: XpCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: 16, color: XpColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Produk Sedang Ditanyakan',
                      style: XpText.labelM(context).copyWith(color: XpColors.textSecondary)),
                ),
                IconButton(
                  tooltip: 'Tutup',
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  iconSize: 18,
                  onPressed: () => ChatShareCubit.get(context).dismissPinned(),
                  icon: Icon(Icons.close, color: XpColors.textTertiary),
                ),
              ],
            ),
            Row(
              children: [
                XpProductImage(url: product.primaryImageUrl, size: 56),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: XpText.titleM(context)),
                      const SizedBox(height: 2),
                      Text(formatRupiah(product.effectivePrice),
                          style: XpText.priceM(context).copyWith(color: XpColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(48, 40),
                    ),
                    onPressed: sending
                        ? null
                        : () async {
                            final share = ChatShareCubit.get(context);
                            final sent =
                                await ChatRoomCubit.get(context).share(productId: product.id);
                            if (sent) share.dismissPinned();
                          },
                    child: const Text('Tanyakan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu ubin di laci lampiran (desain §3.23 no. 6).
class ChatAttachTile extends StatelessWidget {
  const ChatAttachTile({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(XpRadius.l),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(XpRadius.l),
              ),
              child: Icon(icon, color: foreground),
            ),
            const SizedBox(height: 6),
            Text(label, style: XpText.labelS(context)),
          ],
        ),
      ),
    );
  }
}

/// Lembar "Bagikan Pesanan": pesanan pembeli dari toko percakapan ini.
/// Mengembalikan id pesanan terpilih lewat `Navigator.pop`.
class ChatOrderPickerSheet extends StatelessWidget {
  const ChatOrderPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('Bagikan Pesanan', style: XpText.headingM(context)),
          ),
          Expanded(
            child: BlocBuilder<ChatShareCubit, ChatShareState>(
              builder: (context, state) {
                switch (state.pickerStatus) {
                  case ChatPickerStatus.idle:
                  case ChatPickerStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case ChatPickerStatus.error:
                    return XpEmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: 'Pesanan belum bisa dimuat',
                      message: state.pickerError == null
                          ? null
                          : errorMessageFor(context, state.pickerError!),
                      actionLabel: 'Coba Lagi',
                      onAction: () => ChatShareCubit.get(context).loadOrderPicker(),
                    );
                  case ChatPickerStatus.ready:
                    if (state.pickerOrders.isEmpty) {
                      return const XpEmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'Belum ada pesanan',
                        message: 'Belum ada pesanan terbaru dari toko ini untuk dibagikan.',
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: state.pickerOrders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final order = state.pickerOrders[i];
                        return XpCard(
                          padding: const EdgeInsets.all(12),
                          onTap: () => Navigator.of(context).pop(order.id),
                          child: _OrderSummary(order: order),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final number = order.orderNumber.trim().isEmpty ? '#${order.id}' : order.orderNumber;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.receipt_long_outlined, size: 16, color: XpColors.navy),
            const SizedBox(width: 6),
            Expanded(
              child: Text(number,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: XpText.titleM(context)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OrderStatusPill(order: order),
            Text(formatRupiah(order.grandTotal), style: XpText.labelM(context)),
          ],
        ),
      ],
    );
  }
}

/// Kartu gelembung `product_share`.
class SharedProductCard extends StatefulWidget {
  const SharedProductCard({super.key, required this.productId});

  final int productId;

  @override
  State<SharedProductCard> createState() => _SharedProductCardState();
}

class _SharedProductCardState extends State<SharedProductCard> {
  @override
  void initState() {
    super.initState();
    ChatShareCubit.get(context).ensureProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final product =
        context.select<ChatShareCubit, ProductModel?>((c) => c.state.products[widget.productId]);
    return XpCard(
      padding: const EdgeInsets.all(8),
      onTap: () => context.push(AppRoutes.productDetailPath(widget.productId)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          XpProductImage(url: product?.primaryImageUrl, size: 56),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Produk dibagikan',
                    style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
                Text(
                  product?.name ?? 'Produk #${widget.productId}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: XpText.labelM(context),
                ),
                if (product != null)
                  Text(formatRupiah(product.effectivePrice),
                      style: XpText.priceS(context).copyWith(color: XpColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu gelembung `order_share`: nomor pesanan + pil status.
class SharedOrderCard extends StatefulWidget {
  const SharedOrderCard({super.key, required this.orderId});

  final int orderId;

  @override
  State<SharedOrderCard> createState() => _SharedOrderCardState();
}

class _SharedOrderCardState extends State<SharedOrderCard> {
  @override
  void initState() {
    super.initState();
    ChatShareCubit.get(context).ensureOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final order = context.select<ChatShareCubit, OrderModel?>((c) => c.state.orders[widget.orderId]);
    return XpCard(
      padding: const EdgeInsets.all(12),
      // Pesanan yang tidak bisa dibaca (bukan milik pembeli ini) tidak
      // dibuka — detailnya akan dibalas 403.
      onTap: order == null ? null : () => context.push(AppRoutes.orderDetailPath(order.id)),
      child: order == null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.receipt_long_outlined, size: 16, color: XpColors.navy),
                const SizedBox(width: 6),
                Flexible(
                  child: Text('Pesanan #${widget.orderId}', style: XpText.titleM(context)),
                ),
              ],
            )
          : _OrderSummary(order: order),
    );
  }
}
