import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/function/custom_app_bar.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/order_detail_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_status_chip.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Detail satu pesanan.
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderDetailCubit(orderId)..load(),
      child: const _OrderDetailBody(),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Scaffold(
      backgroundColor: dark ? kDarkColor : kWhiteColor,
      appBar: customAppBar(context, 'Detail Pesanan'),
      body: BlocConsumer<OrderDetailCubit, OrderDetailState>(
        listenWhen: (previous, current) =>
            current is OrderDetailLoaded && current.actionError != null,
        listener: (context, state) {
          final error = (state as OrderDetailLoaded).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessageFor(context, error))),
            );
          OrderDetailCubit.get(context).clearActionError();
        },
        builder: (context, state) {
          return switch (state) {
            OrderDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            OrderDetailError(:final error) => _Message(
                title: errorMessageFor(context, error),
                onRetry: () => OrderDetailCubit.get(context).load(),
              ),
            OrderDetailLoaded() => _Loaded(state: state),
          };
        },
      ),
      bottomNavigationBar: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state is! OrderDetailLoaded) return const SizedBox.shrink();
          return _ActionBar(state: state);
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final OrderDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final order = state.order;

    return RefreshIndicator(
      onRefresh: () => OrderDetailCubit.get(context).load(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.orderNumber,
                  style: AppStyles.styleSemiBold18(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
              ),
              OrderStatusChip(status: order.status, label: order.statusLabel),
            ],
          ),
          4.sbh,
          Text(
            formatServerDateTime(order.createdAt),
            style: AppStyles.styleRegular12(context).copyWith(
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
          if (order.awaitsPayment) ...[
            12.sbh,
            Container(
              padding: const EdgeInsetsDirectional.all(12),
              decoration: BoxDecoration(
                color: kWarningColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Bayar dalam ${formatCountdown(order.paymentTimeLeft)}',
                style: AppStyles.styleMedium14(context)
                    .copyWith(color: kWarningColor),
              ),
            ),
          ],
          24.sbh,
          const _SectionTitle(title: 'Barang'),
          8.sbh,
          for (final item in order.items) _ItemRow(item: item),
          24.sbh,
          const _SectionTitle(title: 'Rincian biaya'),
          8.sbh,
          _CostRow(label: 'Subtotal', value: order.subtotal),
          _CostRow(label: 'Ongkos kirim', value: order.shippingCost),
          if (order.discountTotal > 0)
            _CostRow(label: 'Diskon', value: -order.discountTotal),
          const Divider(),
          _CostRow(
            label: 'Total',
            value: order.grandTotal,
            emphasize: true,
          ),
          24.sbh,
          const _SectionTitle(title: 'Pengiriman'),
          8.sbh,
          _InfoRow(label: 'Kurir', value: _courierLabel(order)),
          _InfoRow(
            label: 'No. resi',
            // Resi baru terisi setelah penjual menyerahkan paket ke kurir.
            value: order.trackingNumber ?? 'Belum tersedia',
          ),
          if (order.statusHistory.isNotEmpty) ...[
            24.sbh,
            const _SectionTitle(title: 'Riwayat'),
            8.sbh,
            for (final entry in order.statusHistory) _HistoryRow(entry: entry),
          ],
          32.sbh,
        ],
      ),
    );
  }
}

/// Mis. "JNT · EZ". Tanda hubung kalau kurirnya belum dipilih — yang bisa
/// terjadi pada pesanan lama sebelum kurir wajib.
String _courierLabel(OrderModel order) {
  final parts = [order.courierCode, order.courierService]
      .whereType<String>()
      .where((value) => value.isNotEmpty)
      .map((value) => value.toUpperCase());
  return parts.isEmpty ? '-' : parts.join(' · ');
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Text(
      title,
      style: AppStyles.styleSemiBold16(context).copyWith(
        color: dark ? kDarkSecondColor : kLightSecondColor,
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Nama snapshot: sengaja tidak diambil ulang dari katalog,
                  // supaya pesanan lama tetap menunjukkan apa yang dibeli
                  // walau produknya sudah berubah nama atau dihapus.
                  item.productName,
                  style: AppStyles.styleMedium14(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
                if (item.optionLabel.isNotEmpty)
                  Text(
                    item.optionLabel,
                    style: AppStyles.styleRegular12(context).copyWith(
                      color: dark ? kDarkThirdColor : kLightThirdColor,
                    ),
                  ),
                Text(
                  '${item.quantity} × ${formatRupiah(item.price)}',
                  style: AppStyles.styleRegular12(context).copyWith(
                    color: dark ? kDarkThirdColor : kLightThirdColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatRupiah(item.subtotal),
            style: AppStyles.styleMedium14(context).copyWith(
              color: dark ? kDarkSecondColor : kLightSecondColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final style = emphasize
        ? AppStyles.styleSemiBold16(context).copyWith(
            color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
          )
        : AppStyles.styleRegular14(context).copyWith(
            color: dark ? kDarkThirdColor : kLightThirdColor,
          );

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(formatRupiah(value), style: style),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.styleRegular14(context).copyWith(
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppStyles.styleMedium14(context).copyWith(
                color: dark ? kDarkSecondColor : kLightSecondColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final OrderStatusHistoryModel entry;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(top: 4, end: 8),
            child: Icon(Icons.circle, size: 8),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: AppStyles.styleMedium14(context).copyWith(
                    color: dark ? kDarkSecondColor : kLightSecondColor,
                  ),
                ),
                Text(
                  formatServerDateTime(entry.createdAt),
                  style: AppStyles.styleRegular12(context).copyWith(
                    color: dark ? kDarkThirdColor : kLightThirdColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol aksi sesuai status.
///
/// Hanya aksi yang **sah menurut status saat ini** yang ditampilkan. Ini bukan
/// sekadar kerapian: `POST /orders/{id}/complete` membalas halaman HTML
/// berstatus 200 kalau transisinya tidak sah, yang tidak bisa dijelaskan ke
/// user. Menyaring di sini membuat kasus itu tidak pernah terpicu.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.state});

  final OrderDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final actions = <Widget>[];

    if (order.canCancel) {
      actions.add(
        OutlinedButton(
          onPressed: state.canAct ? () => _confirmCancel(context) : null,
          child: const Text('Batalkan'),
        ),
      );
    }
    if (order.canConfirmDelivery) {
      actions.add(
        FilledButton(
          onPressed: state.canAct
              ? () => OrderDetailCubit.get(context).confirmDelivery()
              : null,
          child: const Text('Barang diterima'),
        ),
      );
    }
    if (order.canComplete) {
      actions.add(
        FilledButton(
          onPressed:
              state.canAct ? () => OrderDetailCubit.get(context).complete() : null,
          child: const Text('Selesaikan pesanan'),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (final action in actions) ...[8.sbw, action],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = OrderDetailCubit.get(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan pesanan?'),
        content: const Text(
          'Pesanan yang sudah dibatalkan tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.cancel();
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.onRetry});

  final String title;
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
              title,
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
