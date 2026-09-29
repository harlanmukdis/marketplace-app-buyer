import 'package:flutter/material.dart';

import 'xp_colors.dart';
import 'xp_text.dart';

/// Komponen dasar design system Xpedia (design_buyer.md §3–4).
///
/// Sebelum ini tiap layar punya salinan pribadi `_Message`/`_ErrorView`/
/// `_EmptyView`. Yang di sini menggantikannya supaya empty state, kartu, dan
/// pil di seluruh app punya satu bentuk.

/// Kartu konten: latar surface, border 1dp, radius 12, **tanpa bayangan
/// tebal** ("Cards use a border, not a heavy shadow").
class XpCard extends StatelessWidget {
  const XpCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.color,
    this.borderColor,
    this.radius = XpRadius.l,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: borderColor ?? XpColors.borderSubtle),
    );
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: color ?? XpColors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Pil berwarna: chip stok (tinggi 22, Label/S) dan status pesanan (tinggi 24,
/// Label/M).
class XpPill extends StatelessWidget {
  const XpPill({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
    this.large = false,
  });

  final String label;
  final XpTone tone;
  final IconData? icon;

  /// `true` untuk pil status pesanan (24dp), `false` untuk chip stok (22dp).
  final bool large;

  @override
  Widget build(BuildContext context) {
    final style = (large ? XpText.labelM(context) : XpText.labelS(context))
        .copyWith(color: tone.foreground);
    return Container(
      height: large ? 24 : 22,
      padding: EdgeInsets.symmetric(horizontal: large ? 10 : 8),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(large ? XpRadius.full : XpRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: tone.foreground),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// Empty state: ikon, satu baris Title/M, satu baris Body/S, satu aksi utama.
/// **Tanpa ilustrasi besar** (design_buyer.md §4).
class XpEmptyState extends StatelessWidget {
  const XpEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: XpColors.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: iconColor ?? XpColors.primary),
            ),
            const SizedBox(height: 16),
            Text(title, style: XpText.titleM(context), textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 4),
              Text(
                message!,
                style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Header seksi: judul Heading/M dengan tautan "Lihat Semua" opsional.
class XpSectionHeader extends StatelessWidget {
  const XpSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.leading,
    this.padding = const EdgeInsets.fromLTRB(16, 24, 16, 12),
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? leading;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: XpText.headingM(context)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                  ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            InkWell(
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(actionLabel!,
                        style: XpText.labelL(context).copyWith(color: XpColors.primary)),
                    Icon(Icons.chevron_right, size: 20, color: XpColors.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Stepper kuantitas: minus, nilai, plus. Tinggi 36; minus mati di batas
/// minimum (design_buyer.md §4). Area sentuh tiap tombol tetap 36×36 di dalam
/// baris setinggi 36 — cukup karena barisnya sendiri tidak punya aksi lain.
class XpQuantityStepper extends StatelessWidget {
  const XpQuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canDec = enabled && value > min;
    final canInc = enabled && (max == null || value < max!);
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: XpColors.sunken,
        borderRadius: BorderRadius.circular(XpRadius.m),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: canDec ? () => onChanged(value - 1) : null,
            tooltip: 'Kurangi',
          ),
          SizedBox(
            width: 36,
            child: Text('$value',
                textAlign: TextAlign.center, style: XpText.titleM(context)),
          ),
          _StepButton(
            icon: Icons.add,
            onTap: canInc ? () => onChanged(value + 1) : null,
            tooltip: 'Tambah',
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap, required this.tooltip});

  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(XpRadius.m),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 18,
            color: onTap == null ? XpColors.textPlaceholder : XpColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Banner info/peringatan dalam kartu berwarna lembut.
class XpBanner extends StatelessWidget {
  const XpBanner({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.tone = XpBannerTone.info,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? message;
  final XpBannerTone tone;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      XpBannerTone.info => (XpColors.primarySubtle, XpColors.primary),
      XpBannerTone.success => (XpColors.successSubtle, XpColors.success),
      XpBannerTone.warning => (XpColors.warningSubtle, const Color(0xff8C5002)),
      XpBannerTone.danger => (XpColors.dangerSubtle, XpColors.danger),
    };
    return XpCard(
      color: bg,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: XpText.titleM(context)),
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(message!,
                        style: XpText.bodyS(context)
                            .copyWith(color: XpColors.textSecondary)),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

enum XpBannerTone { info, success, warning, danger }

/// Baris label–nilai di ringkasan biaya.
class XpKeyValueRow extends StatelessWidget {
  const XpKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool emphasize;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final labelStyle = emphasize
        ? XpText.titleM(context)
        : XpText.bodyM(context).copyWith(color: XpColors.textSecondary);
    final valueStyle = (emphasize ? XpText.priceM(context) : XpText.bodyM(context))
        .copyWith(color: valueColor);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          const SizedBox(width: 12),
          Flexible(child: Text(value, style: valueStyle, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

/// Bilah aksi bawah yang lengket (sticky CTA), dengan garis atas tipis.
class XpBottomBar extends StatelessWidget {
  const XpBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: XpColors.surface,
        border: Border(top: BorderSide(color: XpColors.borderSubtle)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(top: false, child: child),
    );
  }
}

/// Ikon aksi app bar dengan lencana jumlah (dipakai ikon keranjang).
class XpBadgeIcon extends StatelessWidget {
  const XpBadgeIcon({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.count = 0,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final int count;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 24, color: XpColors.textPrimary),
          if (count > 0)
            PositionedDirectional(
              top: -6,
              end: -8,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18),
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: XpColors.danger,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: XpColors.surface, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: XpText.labelS(context).copyWith(color: Colors.white, height: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Logo teks "Xpedia" — sekaligus tombol Beranda (design_buyer.md §5 no. 3).
class XpLogo extends StatelessWidget {
  const XpLogo({super.key, this.onTap, this.color});

  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      'Xpedia',
      style: XpText.headingL(context).copyWith(
        fontWeight: FontWeight.w700,
        color: color ?? XpColors.primary,
        letterSpacing: -0.5,
      ),
    );
    if (onTap == null) return text;
    return Semantics(
      button: true,
      label: 'Beranda',
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: text),
      ),
    );
  }
}

/// Avatar inisial untuk toko/pengguna tanpa foto.
class XpInitialAvatar extends StatelessWidget {
  const XpInitialAvatar({super.key, required this.name, this.size = 40, this.imageUrl});

  final String name;
  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: XpColors.primarySubtle, shape: BoxShape.circle),
      child: Text(initials.isEmpty ? '?' : initials,
          style: XpText.titleM(context).copyWith(color: XpColors.primary)),
    );
    final url = imageUrl;
    if (url == null || url.isEmpty) return fallback;
    return ClipOval(
      child: Image.network(url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback),
    );
  }
}
