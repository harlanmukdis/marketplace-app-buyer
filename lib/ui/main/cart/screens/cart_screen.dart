import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/cart/cubit/cart_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Keranjang belanja, dikelompokkan per toko sesuai bentuk `GET /cart`.
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
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      body: SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
          // Kegagalan satu aksi ditampilkan sebagai snackbar, bukan layar
          // error: isi keranjang masih sahih dan tetap harus terlihat.
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
          builder: (context, state) {
            return switch (state) {
              CartLoading() => const Center(child: CircularProgressIndicator()),
              CartError(:final error) => _ErrorView(
                  message: errorMessageFor(context, error),
                  onRetry: () => CartCubit.get(context).load(),
                ),
              CartReady(:final cart) => cart.isEmpty
                  ? const _EmptyView()
                  : _CartList(state: state),
            };
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is! CartReady || state.cart.isEmpty) {
            return const SizedBox.shrink();
          }
          return _SummaryBar(cart: state.cart);
        },
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  const _CartList({required this.state});

  final CartReady state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => CartCubit.get(context).load(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
        itemCount: state.cart.groups.length,
        itemBuilder: (context, index) => _StoreGroup(
          group: state.cart.groups[index],
          mutatingIds: state.mutatingItemIds,
        ),
      ),
    );
  }
}

class _StoreGroup extends StatelessWidget {
  const _StoreGroup({required this.group, required this.mutatingIds});

  final CartStoreGroup group;
  final Set<int> mutatingIds;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.storefront_outlined,
                size: 18, color: dark ? kDarkSecondColor : kLightSecondColor),
            6.sbw,
            Expanded(
              child: Text(
                group.storeName,
                style: AppStyles.styleSemiBold16(context).copyWith(
                  color: dark ? kDarkSecondColor : kLightSecondColor,
                ),
              ),
            ),
          ],
        ),
        8.sbh,
        for (final item in group.items)
          _CartLine(item: item, isMutating: mutatingIds.contains(item.id)),
        20.sbh,
      ],
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({required this.item, required this.isMutating});

  final CartItemModel item;
  final bool isMutating;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Opacity(
      // Hanya baris yang sedang dikirim yang diredupkan — sisanya tetap bisa
      // disentuh, supaya keranjang tidak terasa membeku tiap satu tombol
      // ditekan.
      opacity: isMutating ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: isMutating
                  ? null
                  : (value) => CartCubit.get(context)
                      .setSelected(item.id, value ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: dark ? kDarkSecondColor : kLightSecondColor,
                    ),
                  ),
                  if (item.optionLabel.isNotEmpty) ...[
                    2.sbh,
                    Text(
                      item.optionLabel,
                      style: AppStyles.styleRegular12(context)
                          .copyWith(color: muted),
                    ),
                  ],
                  4.sbh,
                  Text(
                    formatRupiah(item.price),
                    style: AppStyles.styleSemiBold14(context).copyWith(
                      color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
                    ),
                  ),
                  6.sbh,
                  _QuantityStepper(item: item, enabled: !isMutating),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Hapus',
              onPressed: isMutating
                  ? null
                  : () => CartCubit.get(context).removeItem(item.id),
              icon: const Icon(Icons.delete_outline, color: kDeleteColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.item, required this.enabled});

  final CartItemModel item;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final border = dark ? kDarkThirdColor : kLightThirdColor;

    return Row(
      children: [
        _StepButton(
          icon: item.quantity <= 1 ? Icons.delete_outline : Icons.remove,
          // Pada kuantitas 1, tombol "−" menghapus baris. Mengirim `0` ke
          // server akan menyisakan baris berkuantitas nol yang tetap tampil
          // dan tetap dihitung item_count.
          onPressed: enabled
              ? () => CartCubit.get(context).decrement(item.id)
              : null,
          border: border,
        ),
        SizedBox(
          width: 44,
          child: Text(
            '${item.quantity}',
            textAlign: TextAlign.center,
            style: AppStyles.styleMedium14(context).copyWith(
              color: dark ? kDarkSecondColor : kLightSecondColor,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          onPressed: enabled && item.quantity < CartCubit.maxQuantityPerLine
              ? () => CartCubit.get(context).increment(item.id)
              : null,
          border: border,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onPressed,
    required this.border,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed == null ? border : null,
        ),
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.cart});

  final CartSnapshot cart;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final summary = cart.summary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // Ditulis eksplisit "terpilih" karena ringkasan memang
                    // hanya menghitung baris yang dicentang — total yang tidak
                    // cocok dengan isi keranjang terlihat seperti bug.
                    'Total ${summary.itemCount} barang terpilih',
                    style: AppStyles.styleRegular12(context).copyWith(
                      color: dark ? kDarkThirdColor : kLightThirdColor,
                    ),
                  ),
                  Text(
                    formatRupiah(summary.subtotal),
                    style: AppStyles.styleSemiBold18(context).copyWith(
                      color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              // Checkout belum ditulis ulang setelah pindah backend; tombolnya
              // jujur alih-alih memanggil endpoint yang belum ada lapisannya.
              onPressed: cart.hasSelection
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Checkout belum tersedia'),
                        ),
                      )
                  : null,
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
          16.sbh,
          Text(
            'Keranjang masih kosong',
            style: AppStyles.styleMedium16(context).copyWith(
              color: dark ? kDarkSecondColor : kLightSecondColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
            16.sbh,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            16.sbh,
            FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}
