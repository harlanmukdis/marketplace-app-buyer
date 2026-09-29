import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';

/// Pil status verifikasi identitas (KTP).
///
/// Labelnya sengaja **menyebut KTP**, tidak sekadar "Terverifikasi": pil
/// "Terverifikasi" di My Xpedia sudah berarti status akun `active`, dan dua
/// pil bertuliskan sama dengan arti berbeda hanya membingungkan.
class IdentityStatusPill extends StatelessWidget {
  const IdentityStatusPill({super.key, required this.status});

  final IdentityStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, icon, tone) = switch (status) {
      IdentityStatus.verified => (
          'KTP terverifikasi',
          Icons.badge,
          XpTone(XpColors.primarySubtle, XpColors.primary),
        ),
      IdentityStatus.pending => (
          'KTP sedang ditinjau',
          Icons.hourglass_top,
          XpOrderTones.processing,
        ),
      IdentityStatus.rejected => (
          'Verifikasi KTP ditolak',
          Icons.error_outline,
          XpTone(XpColors.dangerSubtle, XpColors.danger),
        ),
      IdentityStatus.none => (
          'KTP belum diverifikasi',
          Icons.badge_outlined,
          XpOrderTones.cancelled,
        ),
    };
    return XpPill(label: label, icon: icon, tone: tone);
  }
}
