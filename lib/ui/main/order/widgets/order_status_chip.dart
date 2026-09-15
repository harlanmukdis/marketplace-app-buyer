import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/domain/model/order/order_models.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';

/// Label status pesanan berwarna.
///
/// Warnanya mengelompokkan status menurut **apa yang harus dilakukan user**,
/// bukan menurut urutan alurnya: merah berarti berhenti (batal/ditolak),
/// oranye berarti menunggu tindakan, hijau berarti beres.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status, required this.label});

  final OrderStatus status;
  final String label;

  Color get _color => switch (status) {
        OrderStatus.pending => kWarningColor,
        OrderStatus.cancelled ||
        OrderStatus.refundRejected =>
          kErrorColor,
        OrderStatus.completed ||
        OrderStatus.delivered ||
        OrderStatus.refundApproved =>
          kSuccessColor,
        _ => kLightPrimaryColor,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppStyles.styleMedium12(context).copyWith(color: _color),
      ),
    );
  }
}
