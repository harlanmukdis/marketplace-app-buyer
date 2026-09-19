import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/reward/reward_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Badge "Dapat bonus koin" di ringkasan keranjang.
///
/// Menembak `POST /checkout/calculate`, yang menghitung dari isi keranjang
/// **tanpa membuat sesi checkout dan tanpa mereservasi stok** — jadi aman
/// dipanggil dari layar keranjang setiap kali isinya berubah.
///
/// 🔴 Kalimatnya sengaja berbunyi "**dapat**", bukan "**punya**": koinnya
/// berstatus `pending_release` dan baru dilepas saat pesanan selesai —
/// dibatalkan kalau pesanan batal. Menyebutnya saldo akan membuat pembeli
/// mengira sudah memilikinya.
///
/// Tanpa cubit tersendiri: satu nilai, satu panggilan, tidak ada aksi. Sebuah
/// [FutureBuilder] cukup, dan menambah cubit di sini hanya akan menambah
/// berkas tanpa menambah kejelasan.
class RewardPreviewBadge extends StatefulWidget {
  const RewardPreviewBadge({super.key, required this.subtotal});

  /// Dipakai sebagai **kunci muat ulang**, bukan untuk dihitung: begitu
  /// subtotal berubah, estimasinya ditembak ulang.
  final double subtotal;

  @override
  State<RewardPreviewBadge> createState() => _RewardPreviewBadgeState();
}

class _RewardPreviewBadgeState extends State<RewardPreviewBadge> {
  late Future<DataState<RewardPreviewModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = injector<RewardRepository>().previewFromCart();
  }

  @override
  void didUpdateWidget(RewardPreviewBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subtotal != widget.subtotal) {
      setState(() {
        _future = injector<RewardRepository>().previewFromCart();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<RewardPreviewModel>>(
      future: _future,
      builder: (context, snapshot) {
        final result = snapshot.data;
        // Selama dimuat, gagal, atau nol koin: tidak menampilkan apa pun.
        // Ini hiasan yang menyenangkan, bukan informasi yang dibutuhkan untuk
        // membayar — spanduk error untuk itu hanya akan jadi kebisingan.
        if (result is! DataSuccess<RewardPreviewModel>) {
          return const SizedBox.shrink();
        }
        final preview = result.data;
        if (!preview.hasReward) return const SizedBox.shrink();

        final dark = isAppDarkMode();
        return Padding(
          padding: const EdgeInsetsDirectional.only(top: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 13,
                color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
              ),
              4.sbw,
              Text(
                'Dapat ${formatNumber(preview.estimatedCoins)} koin',
                style: AppStyles.styleRegular11(context).copyWith(
                  color: dark ? kDarkPrimaryColor : kLightPrimaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
