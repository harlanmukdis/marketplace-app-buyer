import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/domain/model/wishlist/wishlist_item_model.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Wishlist pembeli. Menggantikan `FavoritesView` bawaan kit yang datanya
/// hardcoded.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WishlistCubit()..load(),
      child: const _WishlistBody(),
    );
  }
}

class _WishlistBody extends StatelessWidget {
  const _WishlistBody();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      body: SafeArea(
        child: BlocConsumer<WishlistCubit, WishlistState>(
          listenWhen: (previous, current) =>
              current is WishlistReady && current.actionError != null,
          listener: (context, state) {
            final error = (state as WishlistReady).actionError!;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(errorMessageFor(context, error))),
              );
            WishlistCubit.get(context).clearActionError();
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Wishlist',
                      style: AppStyles.styleSemiBold18(context).copyWith(
                        color: dark ? kDarkSecondColor : kLightSecondColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => WishlistCubit.get(context).load(),
                    child: switch (state) {
                      WishlistLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      WishlistError(:final error) => _Scrollable(
                          child: _Message(
                            icon: Icons.cloud_off_rounded,
                            title: errorMessageFor(context, error),
                            actionLabel: 'Coba lagi',
                            onAction: () => WishlistCubit.get(context).load(),
                          ),
                        ),
                      WishlistReady(:final items) => items.isEmpty
                          ? const _Scrollable(
                              child: _Message(
                                icon: Icons.favorite_border,
                                title: 'Belum ada produk yang disimpan.',
                              ),
                            )
                          : _List(state: state),
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.state});

  final WishlistReady state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return _WishlistRow(
          item: item,
          isMutating: state.mutatingProductIds.contains(item.productId),
        );
      },
    );
  }
}

class _WishlistRow extends StatelessWidget {
  const _WishlistRow({required this.item, required this.isMutating});

  final WishlistItemModel item;
  final bool isMutating;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;

    return Opacity(
      opacity: isMutating ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 12),
        child: InkWell(
          onTap: () => context.push(AppRoutes.productDetailPath(item.productId)),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  // Berbeda dari listing katalog, wishlist MEMBAWA image_url —
                  // jadi di sini gambarnya nyata, bukan placeholder.
                  child: item.imageUrl == null
                      ? Container(
                          color: dark ? kLightSecondColor : kBorderColor,
                          child: Icon(Icons.image_outlined, color: muted),
                        )
                      : Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: dark ? kLightSecondColor : kBorderColor,
                            child: Icon(Icons.broken_image_outlined,
                                color: muted),
                          ),
                        ),
                ),
              ),
              12.sbw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.styleMedium14(context).copyWith(
                        color: dark ? kDarkSecondColor : kLightSecondColor,
                      ),
                    ),
                    4.sbh,
                    Text(
                      formatRupiah(item.minPrice),
                      style: AppStyles.styleSemiBold14(context).copyWith(
                        color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
                      ),
                    ),
                    if (!item.isAvailable) ...[
                      4.sbh,
                      Text(
                        // Produk yang diarsipkan penjual tetap tersimpan di
                        // wishlist. Ditandai, bukan disembunyikan — user perlu
                        // tahu kenapa barangnya tidak ada lagi di katalog.
                        'Produk sudah tidak tersedia',
                        style: AppStyles.styleRegular12(context)
                            .copyWith(color: kErrorColor),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hapus dari wishlist',
                onPressed: isMutating
                    ? null
                    // Parameternya id PRODUK, bukan wishlist_item_id.
                    : () => WishlistCubit.get(context).remove(item.productId),
                icon: const Icon(Icons.favorite, color: kDeleteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: constraints.maxHeight, child: child),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 48, color: dark ? kDarkThirdColor : kLightThirdColor),
            16.sbh,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.styleMedium16(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
            if (actionLabel != null) ...[
              16.sbh,
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
