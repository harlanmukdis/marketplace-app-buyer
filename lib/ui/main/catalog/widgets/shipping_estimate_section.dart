import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/shipping_estimate_cubit.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Ongkir ke alamat utama pembeli, di halaman produk.
///
/// Menembak `GET /products/{id}/shipping-estimate`, yang **tidak mereservasi
/// stok** — berbeda dari membuat sesi checkout hanya untuk mengintip ongkir.
///
/// Menyembunyikan dirinya sendiri kalau user belum masuk, belum punya alamat
/// lengkap, atau permintaannya gagal: ongkir di sini informasi pelengkap, dan
/// spanduk error untuk itu hanya akan jadi kebisingan di halaman produk.
class ShippingEstimateSection extends StatelessWidget {
  const ShippingEstimateSection({
    super.key,
    required this.productId,
    required this.variantId,
  });

  final int productId;

  /// Berganti saat user memilih varian lain — berat dan gudang asalnya beda,
  /// jadi ongkirnya pun beda.
  final int? variantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ShippingEstimateCubit(productId)..load(variantId: variantId),
      child: _EstimateBody(variantId: variantId),
    );
  }
}

class _EstimateBody extends StatefulWidget {
  const _EstimateBody({required this.variantId});

  final int? variantId;

  @override
  State<_EstimateBody> createState() => _EstimateBodyState();
}

class _EstimateBodyState extends State<_EstimateBody> {
  @override
  void didUpdateWidget(_EstimateBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Varian berganti → ongkirnya dihitung ulang. Alamatnya sudah ditahan
    // cubit, jadi ini satu permintaan, bukan dua.
    if (oldWidget.variantId != widget.variantId) {
      ShippingEstimateCubit.get(context).load(variantId: widget.variantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShippingEstimateCubit, ShippingEstimateState>(
      builder: (context, state) {
        return switch (state) {
          ShippingEstimateHidden() => const SizedBox.shrink(),
          ShippingEstimateLoading() => const _LoadingRow(),
          ShippingEstimateUnavailable(:final address) =>
            _UnavailableRow(city: address.city),
          ShippingEstimateReady() => _ReadyRow(state: state),
        };
      },
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
          8.sbw,
          Text(
            'Menghitung ongkir…',
            style: AppStyles.styleRegular12(context).copyWith(
              color: dark ? kDarkThirdColor : kLightThirdColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnavailableRow extends StatelessWidget {
  const _UnavailableRow({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: kWarningColor),
          6.sbw,
          Expanded(
            child: Text(
              // Penting diketahui SEBELUM barangnya masuk keranjang: tanpa
              // kurir, checkout akan buntu di pemilihan pengiriman.
              'Belum ada kurir yang melayani pengiriman ke '
              '${city.isEmpty ? 'alamat Anda' : city}.',
              style: AppStyles.styleRegular12(context)
                  .copyWith(color: kWarningColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadyRow extends StatelessWidget {
  const _ReadyRow({required this.state});

  final ShippingEstimateReady state;

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();
    final muted = dark ? kDarkThirdColor : kLightThirdColor;
    final cheapest = state.cheapest;
    final city = state.address.city;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.payments_outlined, size: 16, color: muted),
              6.sbw,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: AppStyles.styleRegular12(context)
                        .copyWith(color: muted),
                    children: [
                      TextSpan(
                        text: 'Ongkir ke '
                            '${city.isEmpty ? 'alamat Anda' : city} mulai ',
                      ),
                      TextSpan(
                        text: formatRupiah(cheapest.cost),
                        style: AppStyles.styleMedium12(context).copyWith(
                          color: dark ? kDarkSecondColor : kLightSecondColor,
                        ),
                      ),
                      TextSpan(text: ' · ${_etaOf(cheapest)}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (state.hasAlternatives) ...[
            4.sbh,
            Theme(
              // ExpansionTile menggambar garis pemisahnya sendiri; dimatikan
              // supaya menyatu dengan blok pengiriman di sekitarnya.
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsetsDirectional.only(start: 22),
                childrenPadding:
                    const EdgeInsetsDirectional.only(start: 22, bottom: 8),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(
                  'Lihat ${state.options.length} pilihan kurir',
                  style: AppStyles.styleRegular12(context)
                      .copyWith(color: muted),
                ),
                children: [
                  for (final option in state.options)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.serviceName,
                              style: AppStyles.styleRegular12(context)
                                  .copyWith(color: muted),
                            ),
                          ),
                          Text(
                            formatRupiah(option.cost),
                            style: AppStyles.styleMedium12(context).copyWith(
                              color:
                                  dark ? kDarkSecondColor : kLightSecondColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Perkiraan waktu tiba, `null`-aman terhadap tarif yang tidak mengisinya.
  static String _etaOf(ShippingOptionModel option) {
    final min = option.etdMinDays;
    final max = option.etdMaxDays;
    if (min <= 0 && max <= 0) return 'estimasi tiba menyusul';
    if (min == max) return '$min hari';
    return '$min–$max hari';
  }
}
