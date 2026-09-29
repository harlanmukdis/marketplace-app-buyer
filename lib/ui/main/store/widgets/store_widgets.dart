import 'package:flutter/material.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Potongan UI toko yang dipakai storefront, kartu toko di halaman produk,
/// dan daftar toko yang diikuti.

/// Logo toko: gambar kalau ada, inisial kalau tidak. Persegi membulat (r12)
/// di storefront, lingkaran di tempat lain — mengikuti desain masing-masing.
class StoreLogo extends StatelessWidget {
  const StoreLogo({
    super.key,
    required this.name,
    required this.logoUrl,
    this.size = 44,
    this.rounded = false,
  });

  final String name;
  final String? logoUrl;
  final double size;

  /// `true` = persegi r12 (storefront), `false` = lingkaran.
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    final radius = rounded ? BorderRadius.circular(XpRadius.l) : BorderRadius.circular(size);
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: XpColors.navy, borderRadius: radius),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: (size >= 56 ? XpText.titleL(context) : XpText.titleM(context))
            .copyWith(color: Colors.white),
      ),
    );
    final url = logoUrl?.trim();
    if (url == null || url.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}

/// Satu angka kinerja toko. [simulated] menandai metrik yang datanya dari
/// mock API (lihat `PendingApiMock`).
typedef StoreMetric = ({
  String value,
  String label,
  IconData? icon,
  StoreMetricTone tone,
  bool simulated,
});

/// Warna nilai metrik. Enum, bukan `Color`: [XpColors] membaca preferensi
/// tema di tiap panggilan, jadi warnanya baru ditentukan saat digambar.
enum StoreMetricTone { star, success, neutral }

/// Metrik yang **benar-benar punya dasar** dari `partners-performance`.
///
/// * Rating hanya kalau ada ulasan — tidak pernah "0,0" (design_buyer.md §5).
/// * Transaksi sukses hanya kalau toko sudah punya pesanan: "0%" untuk toko
///   baru terbaca sebagai toko buruk, padahal belum ada yang diukur.
/// * Tingkat balas chat hanya kalau ada yang terukur; waktu balas rata-rata
///   (angka sungguhan dari server) ikut di labelnya supaya baris tetap empat
///   kolom seperti desain.
/// * 🔶 "Online / Aktif sekarang" hanya kalau `online_status` terisi — di
///   server selalu `null`, jadi hari ini datanya dari mock ([meta] memuat
///   `meta.mock_fields`) dan metriknya ditandai [StoreMetric.simulated].
List<StoreMetric> storeMetricsOf(
  StorePerformanceModel? performance, {
  Map<String, dynamic>? meta,
}) {
  if (performance == null) return const [];
  final reply = performance.avgReplyMinutes;
  final onlineSimulated = isMockMeta(meta) &&
      ((meta!['mock_fields'] as List?)?.contains('service_performance.online_status') ??
          meta['mock'] == true);
  return [
    if (performance.hasRating)
      (
        value: '${formatRating(performance.ratingAverage)}/5',
        label: '${formatCompact(performance.totalReviews)} ulasan',
        icon: Icons.star_rounded,
        tone: StoreMetricTone.star,
        simulated: false,
      ),
    if (performance.totalOrders > 0)
      (
        value: formatPercent(performance.successRatePercent),
        label: 'Transaksi sukses',
        icon: null,
        tone: StoreMetricTone.success,
        simulated: false,
      ),
    // Nol tanpa waktu balas = belum ada chat yang bisa diukur, bukan toko
    // yang tidak pernah membalas.
    if (performance.responseRatePercent > 0 || reply != null)
      (
        value: formatPercent(performance.responseRatePercent),
        label: reply != null && reply > 0 ? 'Balas ${_replyLabel(reply)}' : 'Chat dibalas',
        icon: null,
        tone: StoreMetricTone.neutral,
        simulated: false,
      ),
    if (performance.hasOnlineStatus)
      performance.isOnline
          ? (
              value: 'Online',
              label: 'Aktif sekarang',
              icon: Icons.circle,
              tone: StoreMetricTone.success,
              simulated: onlineSimulated,
            )
          : (
              value: _lastActiveLabel(performance.lastActiveAt),
              label: 'Terakhir aktif',
              icon: null,
              tone: StoreMetricTone.neutral,
              simulated: onlineSimulated,
            ),
  ];
}

String _replyLabel(int minutes) =>
    minutes < 60 ? '± $minutes mnt' : '± ${(minutes / 60).round()} jam';

/// "5 mnt lalu" / "3 jam lalu" / "2 hari lalu". Offline tanpa waktu → "Offline".
String _lastActiveLabel(DateTime? at) {
  if (at == null) return 'Offline';
  final diff = DateTime.now().difference(at);
  if (diff.inMinutes < 1) return 'Baru saja';
  if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
  if (diff.inHours < 24) return '${diff.inHours} jam lalu';
  return '${diff.inDays} hari lalu';
}

/// Kotak metrik berkolom dengan garis pemisah (kartu toko di halaman produk
/// dan baris statistik storefront).
class StoreMetricsBox extends StatelessWidget {
  const StoreMetricsBox({super.key, required this.metrics});

  final List<StoreMetric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();
    final box = Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: XpColors.primarySubtle,
        borderRadius: BorderRadius.circular(XpRadius.m),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < metrics.length; i++) ...[
              if (i > 0) VerticalDivider(width: 1, color: XpColors.borderSubtle),
              Expanded(child: _MetricCell(metric: metrics[i])),
            ],
          ],
        ),
      ),
    );
    if (!metrics.any((m) => m.simulated)) return box;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        box,
        const SizedBox(height: 6),
        Row(
          children: [
            const SimulatedBadge(meta: null, force: true),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Status online toko masih simulasi.',
                style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.metric});

  final StoreMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = switch (metric.tone) {
      StoreMetricTone.star => XpColors.star,
      StoreMetricTone.success => XpColors.success,
      StoreMetricTone.neutral => null,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (metric.icon != null) ...[
                Icon(metric.icon, size: metric.icon == Icons.circle ? 10 : 16, color: color),
                const SizedBox(width: 2),
              ],
              Flexible(
                child: Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: XpText.titleM(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: metric.icon == null ? color : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

/// Nama toko + lencana status + Signature, dalam satu Wrap supaya nama
/// panjang turun baris dengan rapi.
class StoreNameLine extends StatelessWidget {
  const StoreNameLine({super.key, required this.store, this.large = false});

  final StoreModel store;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final status = store.sellerStatus;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          store.name,
          style: large
              ? XpText.titleL(context).copyWith(fontWeight: FontWeight.w700)
              : XpText.titleL(context),
        ),
        if (status != SellerStatus.unverified)
          Icon(Icons.verified, size: 18, color: XpColors.primary),
      ],
    );
  }
}
