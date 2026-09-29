import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/cart/cubit/cart_cubit.dart';
import 'package:marketplace_app_member/ui/main/cart/widgets/reward_preview_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_commerce.dart';
import 'package:marketplace_app_member/ui/main/voucher/widgets/voucher_texts.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Keranjang belanja (desain `keranjang_belanja_xpedia_buyer`), dibuka dari
/// ikon keranjang di app bar — **bukan** tab bawah (design_buyer.md §5).
///
/// Dikelompokkan per toko sesuai bentuk `GET /cart`. Yang sengaja tidak
/// dibangun dari desainnya, karena tidak ada datanya di API:
///
/// * **chip stok** per baris — `GET /cart` tidak mengirim stok maupun mode
///   pemenuhan; menebak "Ready Stock" untuk semua baris adalah klaim palsu;
/// * **gambar** per baris — baris keranjang tidak membawa gambar (dan tidak
///   membawa `product_id` untuk mengambilnya), jadi placeholder yang tampil;
/// * **Xpedia Secure+** per baris dan banner **Garansi Tepat Waktu** — tidak
///   ada endpoint keranjang untuk keduanya.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit()..load(),
      child: const _CartBody(),
    );
  }
}

class _CartBody extends StatelessWidget {
  const _CartBody();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Kegagalan satu aksi ditampilkan sebagai snackbar, bukan layar
        // error: isi keranjang masih sahih dan tetap harus terlihat.
        BlocListener<CartCubit, CartState>(
          listenWhen: (previous, current) =>
              current is CartReady && current.actionError != null,
          listener: (context, state) {
            final error = (state as CartReady).actionError!;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(errorMessageFor(context, error))),
              );
            CartCubit.get(context).clearActionError();
          },
        ),
        // Snapshot yang sudah dipegang layar ini dipakai langsung untuk
        // lencana app bar dan nama toko — tanpa request tambahan.
        BlocListener<CartCubit, CartState>(
          listenWhen: (previous, current) =>
              current is CartReady &&
              (previous is! CartReady || previous.cart != current.cart),
          listener: (context, state) {
            final cart = (state as CartReady).cart;
            context.read<CartBadgeCubit>().set(cart.totalLines);
            context.read<StoreDirectoryCubit>().ensure([
              for (final group in cart.groups)
                if (group.storeId != null) group.storeId!,
            ]);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: XpColors.canvas,
        appBar: const XpStackAppBar(
          title: 'Keranjang Belanja',
          actions: [SupportActionButton()],
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return switch (state) {
              CartLoading() => const Center(child: CircularProgressIndicator()),
              CartError(:final error) => XpEmptyState(
                  icon: Icons.cloud_off_rounded,
                  title: 'Keranjang belum bisa dimuat',
                  message: errorMessageFor(context, error),
                  actionLabel: 'Coba lagi',
                  onAction: () => CartCubit.get(context).load(),
                ),
              CartReady(:final cart) => cart.isEmpty
                  ? XpEmptyState(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Keranjang masih kosong',
                      message: 'Yuk, cari barang yang kamu butuhkan di Xpedia.',
                      actionLabel: 'Mulai Belanja',
                      onAction: () => context.go(AppRoutes.homeLayout),
                    )
                  : _CartList(state: state),
            };
          },
        ),
        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is! CartReady || state.cart.isEmpty) {
              return const SizedBox.shrink();
            }
            return _SummaryBar(state: state);
          },
        ),
      ),
    );
  }
}

/// Nilai checkbox tiga keadaan untuk sekumpulan baris.
bool? _triState(Iterable<CartItemModel> items) {
  if (items.isEmpty) return false;
  if (items.every((i) => i.isSelected)) return true;
  if (items.every((i) => !i.isSelected)) return false;
  return null;
}

class _CartList extends StatelessWidget {
  const _CartList({required this.state});

  final CartReady state;

  @override
  Widget build(BuildContext context) {
    final cart = state.cart;
    return Column(
      children: [
        _SelectAllStrip(state: state),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => CartCubit.get(context).load(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                for (final group in cart.groups)
                  _StoreGroupCard(
                    group: group,
                    mutatingIds: state.mutatingItemIds,
                  ),
                _VoucherBar(
                  vouchers: cart.summary.vouchers,
                  busy: state.isBusy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// "Pilih Semua (n)" + "Hapus" untuk baris tercentang.
class _SelectAllStrip extends StatelessWidget {
  const _SelectAllStrip({required this.state});

  final CartReady state;

  @override
  Widget build(BuildContext context) {
    final items = state.cart.allItems;
    final selected = items.where((i) => i.isSelected).toList();
    final value = _triState(items);

    return Container(
      color: XpColors.surface,
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Row(
        children: [
          Checkbox(
            tristate: true,
            value: value,
            onChanged: state.isBusy
                ? null
                : (_) => CartCubit.get(context).setSelectedMany(
                      items.map((i) => i.id),
                      value != true,
                    ),
          ),
          Expanded(
            child: Text('Pilih Semua (${items.length})',
                style: XpText.titleM(context)),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: XpColors.danger,
              minimumSize: const Size(48, 48),
            ),
            onPressed: selected.isEmpty || state.isBusy
                ? null
                : () => _confirmRemove(context, selected),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    List<CartItemModel> selected,
  ) async {
    final cubit = CartCubit.get(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Hapus ${selected.length} barang?'),
        content: const Text(
          'Barang yang dicentang akan dikeluarkan dari keranjang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: XpColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) await cubit.removeItems(selected.map((i) => i.id));
  }
}

class _StoreGroupCard extends StatelessWidget {
  const _StoreGroupCard({required this.group, required this.mutatingIds});

  final CartStoreGroup group;
  final Set<int> mutatingIds;

  @override
  Widget build(BuildContext context) {
    final storeId = group.storeId;
    final store = storeId == null
        ? null
        : context
            .select<StoreDirectoryCubit, StoreModel?>((c) => c.state[storeId]);
    final busy = group.items.any((i) => mutatingIds.contains(i.id));
    final value = _triState(group.items);

    return XpCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                tristate: true,
                value: value,
                onChanged: busy
                    ? null
                    : (_) => CartCubit.get(context).setSelectedMany(
                          group.items.map((i) => i.id),
                          value != true,
                        ),
              ),
              Expanded(
                child: InkWell(
                  onTap: storeId == null
                      ? null
                      : () => context.push(AppRoutes.storePath(storeId)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Row(
                      children: [
                        if (store != null) ...[
                          SellerStatusBadge(
                              status: store.sellerStatus, compact: true),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            // Nama dari `GET /cart` selalu ada; profil toko
                            // hanya menambah lencana status.
                            group.storeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: XpText.titleM(context),
                          ),
                        ),
                        if (storeId != null)
                          const Icon(Icons.chevron_right,
                              size: 20, color: XpColors.textPlaceholder),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          for (final item in group.items)
            _CartLine(item: item, isMutating: mutatingIds.contains(item.id)),
        ],
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({required this.item, required this.isMutating});

  final CartItemModel item;
  final bool isMutating;

  @override
  Widget build(BuildContext context) {
    final cubit = CartCubit.get(context);

    return Opacity(
      // Hanya baris yang sedang dikirim yang diredupkan — sisanya tetap bisa
      // disentuh, supaya keranjang tidak terasa membeku tiap satu tombol
      // ditekan.
      opacity: isMutating ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: isMutating
                  ? null
                  : (value) => cubit.setSelected(item.id, value ?? false),
            ),
            // `GET /cart` tidak membawa gambar — placeholder, bukan tebakan.
            const XpProductImage(url: null, size: 72),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: XpText.titleM(context),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Hapus',
                        constraints:
                            const BoxConstraints(minWidth: 40, minHeight: 40),
                        padding: EdgeInsets.zero,
                        onPressed:
                            isMutating ? null : () => cubit.removeItem(item.id),
                        icon: const Icon(Icons.delete_outline,
                            size: 20, color: XpColors.textPlaceholder),
                      ),
                    ],
                  ),
                  if (item.optionLabel.isNotEmpty)
                    Text(
                      'Varian: ${item.optionLabel}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: XpText.caption(context)
                          .copyWith(color: XpColors.textSecondary),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatRupiah(item.price),
                          style: XpText.priceM(context)
                              .copyWith(color: XpColors.primary),
                        ),
                      ),
                      // Minus mati di 1 (batas minimum); menghapus baris lewat
                      // ikon hapus. Aturan "< 1 menghapus" tetap di cubit
                      // supaya kuantitas 0 tidak pernah terkirim ke server.
                      XpQuantityStepper(
                        value: item.quantity,
                        max: CartCubit.maxQuantityPerLine,
                        enabled: !isMutating,
                        onChanged: (value) =>
                            cubit.changeQuantity(item.id, value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Voucher Belanja & Bebas Ongkir" (desain §3.8 bagian 4): selalu tampil,
/// membuka layar voucher, dan memuat ulang keranjang sekembalinya — voucher
/// yang dipasang di sana mengubah `GET /cart/summary`.
///
/// Voucher yang sudah terpasang (dari `GET /cart/summary`) tercantum di
/// bawahnya dan bisa langsung dilepas. Di dev daftarnya selalu kosong karena
/// belum ada voucher yang di-seed.
class _VoucherBar extends StatelessWidget {
  const _VoucherBar({required this.vouchers, required this.busy});

  final List<AppliedVoucherModel> vouchers;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return XpCard(
      color: XpColors.warningSubtle,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(12),
      onTap: busy
          ? null
          : () async {
              await context.push(AppRoutes.vouchers);
              if (context.mounted) await CartCubit.get(context).load();
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: XpColors.warning,
                  borderRadius: BorderRadius.circular(XpRadius.m),
                ),
                child: const Icon(Icons.confirmation_number_outlined,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Voucher Belanja & Bebas Ongkir',
                        style: XpText.titleM(context)),
                    Text(
                      'Gunakan voucher diskon & gratis ongkir Xpedia',
                      style: XpText.caption(context)
                          .copyWith(color: XpColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (vouchers.isNotEmpty)
                XpPill(
                  label: '${vouchers.length} Dipakai',
                  tone: const XpTone(Color(0x33F59E0B), Color(0xff8C5002)),
                ),
              Icon(Icons.chevron_right, color: XpColors.textTertiary),
            ],
          ),
          if (vouchers.isNotEmpty) const SizedBox(height: 8),
          for (final voucher in vouchers)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(voucher.code, style: XpText.labelL(context)),
                      Text(
                        appliedVoucherValue(voucher),
                        style: XpText.caption(context)
                            .copyWith(color: XpColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () =>
                          CartCubit.get(context).removeVoucher(voucher.code),
                  child: const Text('Lepas'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.state});

  final CartReady state;

  @override
  Widget build(BuildContext context) {
    final cart = state.cart;
    final summary = cart.summary;
    final items = cart.allItems;
    final value = _triState(items);

    return Container(
      decoration: BoxDecoration(
        color: XpColors.surface,
        border: Border(top: BorderSide(color: XpColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (summary.subtotal > 0)
              Container(
                width: double.infinity,
                color: XpColors.primarySubtle,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: RewardPreviewBadge(subtotal: summary.subtotal),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  Checkbox(
                    tristate: true,
                    value: value,
                    onChanged: state.isBusy
                        ? null
                        : (_) => CartCubit.get(context).setSelectedMany(
                              items.map((i) => i.id),
                              value != true,
                            ),
                  ),
                  Text('Semua', style: XpText.labelL(context)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          // Ditulis eksplisit "terpilih" karena ringkasan
                          // hanya menghitung baris yang dicentang — total yang
                          // tidak cocok dengan isi keranjang terlihat seperti
                          // bug. `item_count` menghitung baris, bukan unit.
                          'Total Tagihan · ${summary.itemCount} barang terpilih',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: XpText.caption(context)
                              .copyWith(color: XpColors.textTertiary),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            formatRupiah(summary.payableSubtotal),
                            style: XpText.priceL(context)
                                .copyWith(color: XpColors.primary),
                          ),
                        ),
                        if (summary.discountAmount > 0)
                          Text(
                            'Hemat ${formatRupiah(summary.discountAmount)}',
                            style: XpText.caption(context)
                                .copyWith(color: XpColors.success),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      // Hanya baris tercentang yang ikut — sama seperti cara
                      // server menghitung ringkasan dan membentuk sesi
                      // checkout.
                      onPressed: cart.hasSelection && !state.isBusy
                          ? () async {
                              await context.push(AppRoutes.checkoutSession);
                              // Checkout menghapus baris tercentang di server,
                              // jadi keranjang dibaca ulang saat kembali.
                              if (context.mounted) {
                                CartCubit.get(context).load();
                              }
                            }
                          : null,
                      // Dua Text terpisah supaya label "Checkout" tetap bisa
                      // dicari apa adanya oleh test app sungguhan.
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Checkout'),
                          Text(' (${summary.itemCount})'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
