import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_list_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_status_chip.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Daftar pesanan pembeli.
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderListCubit()..load(),
      child: const _OrderListBody(),
    );
  }
}

class _OrderListBody extends StatefulWidget {
  const _OrderListBody();

  @override
  State<_OrderListBody> createState() => _OrderListBodyState();
}

class _OrderListBodyState extends State<_OrderListBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      OrderListCubit.get(context).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, 'Pesanan Saya'),
      body: BlocBuilder<OrderListCubit, OrderListState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => OrderListCubit.get(context).refresh(),
            child: switch (state) {
              OrderListLoading() =>
                const Center(child: CircularProgressIndicator()),
              OrderListError(:final error) => _Scrollable(
                  child: _Message(
                    icon: Icons.cloud_off_rounded,
                    title: errorMessageFor(context, error),
                    actionLabel: 'Coba lagi',
                    onAction: () => OrderListCubit.get(context).refresh(),
                  ),
                ),
              OrderListEmpty() => const _Scrollable(
                  child: _Message(
                    icon: Icons.receipt_long_outlined,
                    title: 'Belum ada pesanan.',
                  ),
                ),
              OrderListLoaded() => _List(
                  state: state,
                  controller: _scrollController,
                ),
            },
          );
        },
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.state, required this.controller});

  final OrderListLoaded state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: state.orders.length + 1,
      itemBuilder: (context, index) {
        if (index == state.orders.length) return _footer(context);
        return _OrderCard(order: state.orders[index]);
      },
    );
  }

  Widget _footer(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final error = state.loadMoreError;
    if (error != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
        child: Center(
          child: TextButton.icon(
            onPressed: () => OrderListCubit.get(context).loadMore(),
            icon: const Icon(Icons.refresh),
            label: Text(errorMessageFor(context, error)),
          ),
        ),
      );
    }
    return const SizedBox(height: 16);
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push(AppRoutes.orderDetailPath(order.id)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsetsDirectional.all(12),
          decoration: BoxDecoration(
            border:
                Border.all(color: dark ? kDarkThirdColor : kBorderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      style: AppStyles.styleMedium14(context).copyWith(
                        color: dark ? kDarkSecondColor : kLightSecondColor,
                      ),
                    ),
                  ),
                  OrderStatusChip(
                    status: order.status,
                    label: order.statusLabel,
                  ),
                ],
              ),
              6.sbh,
              Text(
                formatServerDateTime(order.createdAt),
                style: AppStyles.styleRegular12(context).copyWith(
                  color: dark ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
              8.sbh,
              Text(
                formatRupiah(order.grandTotal),
                style: AppStyles.styleSemiBold16(context).copyWith(
                  color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
                ),
              ),
              if (order.awaitsPayment) ...[
                6.sbh,
                Text(
                  'Bayar dalam ${formatCountdown(order.paymentTimeLeft)}',
                  style: AppStyles.styleRegular12(context)
                      .copyWith(color: kWarningColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Membungkus pesan agar tetap bisa ditarik untuk refresh.
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
