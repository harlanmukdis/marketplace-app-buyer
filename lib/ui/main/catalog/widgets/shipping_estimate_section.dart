import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/checkout/checkout_models.dart';
import 'package:marketplace_app_member/ui/main/catalog/cubit/shipping_estimate_cubit.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Kartu pengiriman di halaman produk: asal kirim, ongkir ke alamat utama
/// pembeli, dan kurir toko (`detail_produk_jbl_tune_770nc` §3).
///
/// Ongkirnya dari `GET /products/{id}/shipping-estimate`, yang **tidak
/// mereservasi stok** — berbeda dari membuat sesi checkout hanya untuk
/// mengintip ongkir.
///
/// Baris ongkir menyembunyikan dirinya sendiri kalau user belum masuk, belum
/// punya alamat lengkap, atau permintaannya gagal: ongkir di sini informasi
/// pelengkap, dan spanduk error untuk itu hanya akan jadi kebisingan. Kalau
/// asal kirim dan kurir pun tidak diketahui, seluruh kartunya hilang.
///
/// Salinan desain "Gratis Ongkir ke Seluruh Indonesia" **tidak** dipakai —
/// tidak ada data gratis ongkir di API ini; yang tampil ongkir sungguhan.
class ShippingEstimateSection extends StatelessWidget {
  const ShippingEstimateSection({
    super.key,
    required this.productId,
    required this.variantId,
    this.origin = '',
    this.courierNames = const [],
  });

  final int productId;

  /// "Dikirim dari …" — dari `warehouse_city`/`warehouse_province` varian,
  /// jadi tanpa panggilan tambahan.
  final String origin;

  /// Kurir yang dilayani toko, dari `couriers[]` di detail produk.
  final List<String> courierNames;

  /// Berganti saat user memilih varian lain — berat dan gudang asalnya beda,
  /// jadi ongkirnya pun beda.
  final int? variantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ShippingEstimateCubit(productId)..load(variantId: variantId),
      child: _EstimateBody(
        variantId: variantId,
        origin: origin,
        courierNames: courierNames,
      ),
    );
  }
}

class _EstimateBody extends StatefulWidget {
  const _EstimateBody({
    required this.variantId,
    required this.origin,
    required this.courierNames,
  });

  final int? variantId;
  final String origin;
  final List<String> courierNames;

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
        final estimate = switch (state) {
          ShippingEstimateHidden() => null,
          ShippingEstimateLoading() => const _LoadingRow(),
          ShippingEstimateUnavailable(:final address) =>
            _UnavailableRow(city: address.city),
          ShippingEstimateReady() => _ReadyRow(state: state),
        };
        final origin = widget.origin.trim();
        if (estimate == null && origin.isEmpty && widget.courierNames.isEmpty) {
          return const SizedBox.shrink();
        }
        return XpCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: XpColors.primarySubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_shipping_outlined,
                    size: 20, color: XpColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pengiriman', style: XpText.titleM(context)),
                    if (origin.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('Dikirim dari $origin',
                            style: XpText.bodyS(context)
                                .copyWith(color: XpColors.textSecondary)),
                      ),
                    if (estimate != null)
                      Padding(padding: const EdgeInsets.only(top: 4), child: estimate),
                    if (widget.courierNames.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Kurir: ${widget.courierNames.join(', ')}',
                          style: XpText.caption(context)
                              .copyWith(color: XpColors.textTertiary),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2, color: XpColors.textTertiary),
        ),
        const SizedBox(width: 8),
        Text('Menghitung ongkir…',
            style: XpText.bodyS(context).copyWith(color: XpColors.textTertiary)),
      ],
    );
  }
}

class _UnavailableRow extends StatelessWidget {
  const _UnavailableRow({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 16, color: XpColors.warning),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            // Penting diketahui SEBELUM barangnya masuk keranjang: tanpa
            // kurir, checkout akan buntu di pemilihan pengiriman.
            'Belum ada kurir yang melayani pengiriman ke '
            '${city.isEmpty ? 'alamat Anda' : city}.',
            style: XpText.bodyS(context).copyWith(color: const Color(0xff8C5002)),
          ),
        ),
      ],
    );
  }
}

class _ReadyRow extends StatefulWidget {
  const _ReadyRow({required this.state});

  final ShippingEstimateReady state;

  @override
  State<_ReadyRow> createState() => _ReadyRowState();
}

class _ReadyRowState extends State<_ReadyRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cheapest = state.cheapest;
    final city = state.address.city;
    final muted = XpText.bodyS(context).copyWith(color: XpColors.textSecondary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: muted,
            children: [
              TextSpan(text: 'Ongkir ke ${city.isEmpty ? 'alamat Anda' : city} mulai '),
              TextSpan(text: formatRupiah(cheapest.cost), style: XpText.labelM(context)),
              TextSpan(text: ' • ${_etaOf(cheapest)}'),
            ],
          ),
        ),
        if (state.hasAlternatives) ...[
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: Row(
                children: [
                  Text('Lihat ${state.options.length} pilihan kurir',
                      style: XpText.labelM(context).copyWith(color: XpColors.primary)),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      size: 20, color: XpColors.primary),
                ],
              ),
            ),
          ),
          if (_expanded)
            for (final option in state.options)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(option.serviceName, style: muted)),
                    Text(formatRupiah(option.cost), style: XpText.labelM(context)),
                  ],
                ),
              ),
        ],
      ],
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
