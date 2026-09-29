import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Potongan UI bersama layar-layar pasca-beli (daftar, detail, lacak,
/// invoice, batal, komplain).

/// Pesan error untuk layar pesanan. Kode khusus pesanan (`INVALID_SEAL_CODE`,
/// `INVOICE_NOT_AVAILABLE`, `TOO_MANY_REQUESTS`) sudah dipetakan
/// [errorMessageFor]; `error.message` server tetap tidak pernah ditampilkan.
///
/// Kode dari **kontrak yang diusulkan** (mock, `assets/mock/pending_api/`)
/// dipetakan di sini dulu, karena `error_message.dart` bersama belum
/// mengenalnya. Pindahkan ke sana begitu backend membangun endpoint-nya.
String orderErrorMessage(BuildContext context, DataError error) =>
    switch (error.code) {
      OrderPendingErrorCode.cancellationNotAllowed =>
        'Permohonan pembatalan hanya bisa diajukan saat pesanan sedang dikemas atau dikirim.',
      OrderPendingErrorCode.cancellationRequestExists =>
        'Pesanan ini sudah punya permohonan pembatalan.',
      OrderPendingErrorCode.reviewEditWindowClosed =>
        'Ulasan hanya bisa diubah dalam 30 hari setelah dikirim.',
      OrderPendingErrorCode.reviewNotFound => 'Ulasan tidak ditemukan.',
      OrderPendingErrorCode.uploadFailed =>
        'Berkas gagal diunggah. Pastikan formatnya JPG, PNG, MP4, atau MOV dan ukurannya sesuai.',
      _ => errorMessageFor(context, error),
    };

/// Kode error baru dari kontrak pasca-beli yang diusulkan, plus
/// `UPLOAD_FAILED` milik `POST /media/upload` yang sudah ada tapi belum
/// dipetakan di `ApiErrorCode`.
abstract final class OrderPendingErrorCode {
  static const cancellationNotAllowed = 'CANCELLATION_NOT_ALLOWED';
  static const cancellationRequestExists = 'CANCELLATION_REQUEST_EXISTS';
  static const reviewEditWindowClosed = 'REVIEW_EDIT_WINDOW_CLOSED';
  static const reviewNotFound = 'REVIEW_NOT_FOUND';
  static const uploadFailed = 'UPLOAD_FAILED';
}

void showOrderSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> copyWithToast(BuildContext context, String value, String toast) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (context.mounted) showOrderSnack(context, toast);
}

/// Mis. "JNE · REG". `null` kalau kurir belum tercatat.
String? courierLabelOf(String? code, String? service) {
  final parts = [code, service]
      .whereType<String>()
      .where((v) => v.trim().isNotEmpty)
      .map((v) => v.toUpperCase())
      .toList();
  return parts.isEmpty ? null : parts.join(' · ');
}

/// Apakah pesanan ini pernah benar-benar dibayar.
///
/// Pesanan `cancelled` bisa lahir dari dua jalan: batal sebelum bayar
/// (tanpa refund) atau sesudah bayar (dana kembali ke Xpedia Wallet).
/// Satu-satunya pembedanya riwayat status — `GET /orders/{id}` tidak membawa
/// status pembayaran sendiri.
bool orderWasPaid(OrderModel order) {
  if (order.isPending) return false;
  if (!order.isCancelled) return true;
  return order.statusHistory.any((h) => h.status == OrderStatus.paid);
}

/// Seksi putih selebar layar, 8dp dari seksi berikutnya (desain §3.13).
class OrderSection extends StatelessWidget {
  const OrderSection({super.key, required this.child, this.title, this.trailing});

  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: XpColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(child: Text(title!, style: XpText.titleL(context))),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

/// Nama toko dari [StoreDirectoryCubit]. `GET /orders` hanya membawa
/// `store_id`, jadi pemanggil wajib `ensure([storeId])` lebih dulu; selama
/// belum termuat, yang tampil "Toko".
class OrderStoreName extends StatelessWidget {
  const OrderStoreName({super.key, required this.storeId, this.style, this.onTap});

  final int storeId;
  final TextStyle? style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final store = context.select<StoreDirectoryCubit, StoreModel?>((c) => c.state[storeId]);
    final verified = store != null && store.sellerStatus != SellerStatus.unverified;
    // Text.rich, bukan Row: ikon ikut mengalir bersama teks sehingga nama
    // toko terpotong dengan elipsis alih-alih meluap saat ruangnya sempit
    // (mis. di samping pil "Menunggu Pembayaran").
    final row = Text.rich(
      TextSpan(children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 6),
            child: Icon(Icons.storefront_outlined, size: 18, color: XpColors.textSecondary),
          ),
        ),
        TextSpan(text: store?.name ?? 'Toko'),
        if (verified)
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Icon(Icons.verified, size: 16, color: XpColors.primary),
            ),
          ),
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style ?? XpText.labelL(context).copyWith(fontWeight: FontWeight.w600),
    );
    if (onTap == null) return row;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Align(alignment: AlignmentDirectional.centerStart, child: row),
      ),
    );
  }
}

/// Satu baris barang pesanan (snapshot). Tanpa gambar: baris pesanan hanya
/// membawa `product_variant_id`, dan menukarnya jadi foto butuh satu
/// `GET /products/{id}` per baris — itupun tanpa jalan dari varian ke produk.
class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.item, this.trailing, this.dimmed = false});

  final OrderItemModel item;
  final Widget? trailing;

  /// Barang yang ditandai penjual tidak tersedia (usulan kirim sebagian).
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.55 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const XpProductImage(url: null, size: 56),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: XpText.titleM(context)),
                  if (item.optionLabel.isNotEmpty)
                    Text(item.optionLabel,
                        style: XpText.caption(context)
                            .copyWith(color: XpColors.textTertiary)),
                  const SizedBox(height: 2),
                  Text('${item.quantity} barang x ${formatRupiah(item.price)}',
                      style: XpText.bodyS(context)
                          .copyWith(color: XpColors.textSecondary)),
                  if (!item.isAvailable)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: XpPill(
                        label: 'Tidak tersedia',
                        tone: XpTone(XpColors.dangerSubtle, XpColors.danger),
                      ),
                    ),
                  if (trailing != null) ...[const SizedBox(height: 8), trailing!],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(formatRupiah(item.subtotal), style: XpText.priceS(context)),
          ],
        ),
      ),
    );
  }
}

/// Rincian biaya. Angkanya dari server apa adanya — tidak ada yang
/// dijumlahkan di sini.
class OrderCostSummary extends StatelessWidget {
  const OrderCostSummary({
    super.key,
    required this.subtotal,
    required this.shippingCost,
    required this.discountTotal,
    required this.grandTotal,
    this.itemCount,
    this.totalCaption,
  });

  final double subtotal;
  final double shippingCost;
  final double discountTotal;
  final double grandTotal;
  final int? itemCount;
  final String? totalCaption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XpKeyValueRow(
          label: itemCount == null ? 'Subtotal Produk' : 'Subtotal Produk ($itemCount barang)',
          value: formatRupiah(subtotal),
        ),
        XpKeyValueRow(label: 'Ongkos Kirim', value: formatRupiah(shippingCost)),
        if (discountTotal > 0)
          XpKeyValueRow(
            label: 'Diskon',
            value: '-${formatRupiah(discountTotal)}',
            valueColor: XpColors.success,
          ),
        const Divider(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Pembayaran', style: XpText.titleM(context)),
                  if (totalCaption != null)
                    Text(totalCaption!,
                        style: XpText.caption(context)
                            .copyWith(color: XpColors.textTertiary)),
                ],
              ),
            ),
            Text(formatRupiah(grandTotal),
                style: XpText.priceL(context).copyWith(color: XpColors.primary)),
          ],
        ),
      ],
    );
  }
}

/// Kartu alamat tujuan dari `shipping_address` (hanya ada di detail).
class OrderAddressBlock extends StatelessWidget {
  const OrderAddressBlock({super.key, required this.address});

  final OrderShippingAddress? address;

  @override
  Widget build(BuildContext context) {
    final a = address;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_outlined, size: 20, color: XpColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: a == null
              // Bukan snapshot: server menggabungkannya live ke
              // `user_addresses`, jadi alamat yang sudah dihapus jadi null.
              ? Text('Alamat tujuan sudah tidak tersedia.',
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [a.recipientName, a.phone]
                          .whereType<String>()
                          .where((v) => v.isNotEmpty)
                          .join(' · '),
                      style: XpText.titleM(context),
                    ),
                    const SizedBox(height: 2),
                    Text(a.singleLine,
                        style: XpText.bodyS(context)
                            .copyWith(color: XpColors.textSecondary)),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Tombol "Hubungi Xpedia 911" yang membuka tiket baru terkait pesanan.
class OrderSupportButton extends StatelessWidget {
  const OrderSupportButton({super.key, required this.orderId, this.compact = false});

  final int orderId;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    void open() => context.push(AppRoutes.supportNewPath(orderId: orderId));
    if (compact) {
      return TextButton.icon(
        onPressed: open,
        icon: const Icon(Icons.support_agent, size: 18),
        label: const Text('Xpedia 911'),
      );
    }
    return XpBanner(
      icon: Icons.support_agent,
      title: 'Butuh bantuan untuk pesanan ini?',
      message: 'Hubungi Xpedia 911, siap membantu 24 jam.',
      trailing: Icon(Icons.chevron_right, color: XpColors.textTertiary),
      onTap: open,
    );
  }
}

/// Tampilan gagal-muat satu layar pesanan.
class OrderLoadError extends StatelessWidget {
  const OrderLoadError({super.key, required this.error, required this.onRetry});

  final DataError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return XpEmptyState(
      icon: Icons.cloud_off_outlined,
      title: 'Gagal memuat pesanan',
      message: orderErrorMessage(context, error),
      actionLabel: 'Coba Lagi',
      onAction: onRetry,
    );
  }
}

const _shortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// "14 Mar, 09:20" dalam WIB — untuk label sempit di linimasa.
String shortServerDateTime(DateTime? instant) {
  if (instant == null) return '';
  final t = instant.toUtc().add(kServerUtcOffset);
  String two(int v) => v.toString().padLeft(2, '0');
  return '${t.day} ${_shortMonths[t.month - 1]}, ${two(t.hour)}:${two(t.minute)}';
}

/// Tombol "Chat" ke toko. Memanggil repository chat langsung karena
/// `ChatWithStoreButton` milik domain chat berbentuk tombol selebar layar,
/// sedangkan di sini tempatnya di ujung baris toko.
class OrderChatStoreButton extends StatefulWidget {
  const OrderChatStoreButton({super.key, required this.storeId});

  final int storeId;

  @override
  State<OrderChatStoreButton> createState() => OrderChatStoreButtonState();
}

class OrderChatStoreButtonState extends State<OrderChatStoreButton> {
  bool _opening = false;

  Future<void> _open() async {
    setState(() => _opening = true);
    final result = await injector<ChatRepository>().openConversation(storeId: widget.storeId);
    if (!mounted) return;
    setState(() => _opening = false);
    switch (result) {
      case DataSuccess(:final data):
        final name = context.read<StoreDirectoryCubit>().state[widget.storeId]?.name;
        context.push(AppRoutes.chatRoomPath(data), extra: name);
      case DataFailed(:final error):
        showOrderSnack(context, orderErrorMessage(context, error));
      default:
        showOrderSnack(context, 'Gagal membuka chat.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dibaca supaya tombol ikut tergambar ulang begitu nama toko termuat.
    context.select<StoreDirectoryCubit, StoreModel?>((c) => c.state[widget.storeId]);
    return FilledButton.tonalIcon(
      onPressed: _opening ? null : _open,
      icon: _opening
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.chat_outlined, size: 18),
      label: const Text('Chat'),
    );
  }
}
