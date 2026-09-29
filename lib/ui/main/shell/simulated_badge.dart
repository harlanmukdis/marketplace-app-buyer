import 'package:flutter/material.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';

/// Lencana "Simulasi" untuk bagian layar yang datanya dari mock API
/// (lihat `PendingApiMock`). Tidak menggambar apa pun kalau [meta] bukan dari
/// mock — jadi aman dipasang permanen: begitu backend membangun endpoint-nya,
/// lencananya hilang sendiri.
class SimulatedBadge extends StatelessWidget {
  const SimulatedBadge({super.key, required this.meta, this.force = false});

  final Map<String, dynamic>? meta;

  /// Untuk data yang disimpan cubit tanpa `meta` (mis. hasil mutasi mock).
  final bool force;

  @override
  Widget build(BuildContext context) {
    if (!force && !isMockMeta(meta)) return const SizedBox.shrink();
    return Tooltip(
      message: 'Data simulasi — API-nya belum tersedia di backend.',
      child: XpPill(
        label: 'Simulasi',
        icon: Icons.science_outlined,
        tone: XpTone(XpColors.warningSubtle, const Color(0xff8C5002)),
      ),
    );
  }
}
