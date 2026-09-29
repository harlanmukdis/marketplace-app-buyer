import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';

/// Panjang PIN Xpedia Wallet. Server menolak selain 6 digit angka.
const int kPinLength = 6;

/// Enam titik penanda PIN (inventaris desain §3.11): terisi biru, sisanya
/// abu-abu, dan titik berikutnya diberi inti kecil sebagai penanda posisi.
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.filled, this.hasError = false});

  final int filled;

  /// Titik berubah merah saat PIN ditolak / konfirmasi tidak cocok.
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$filled dari $kPinLength digit PIN terisi',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < kPinLength; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            Container(
              width: 14,
              height: 14,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled
                    ? (hasError ? XpColors.danger : XpColors.primary)
                    : XpColors.sunken,
              ),
              child: i == filled
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: XpColors.textPlaceholder,
                      ),
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

/// Papan angka 3×4 untuk PIN.
///
/// Tanpa tombol konfirmasi — layar pemakai mengirim otomatis begitu digit
/// keenam masuk, sama seperti desain. Tombol biometrik di sudut kiri bawah
/// **sengaja dikosongkan**: aplikasi belum punya autentikasi biometrik, dan
/// tombol yang tidak melakukan apa-apa lebih buruk daripada tidak ada.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Widget row(List<Widget> keys) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              for (var i = 0; i < keys.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(child: keys[i]),
              ],
            ],
          ),
        );

    Widget digit(String d) => _PinKey(
          label: d,
          onTap: enabled ? () => onDigit(d) : null,
        );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          row([digit('1'), digit('2'), digit('3')]),
          row([digit('4'), digit('5'), digit('6')]),
          row([digit('7'), digit('8'), digit('9')]),
          row([
            const SizedBox(height: 56),
            digit('0'),
            _PinKey(
              icon: Icons.backspace_outlined,
              semanticLabel: 'Hapus digit',
              plain: true,
              onTap: enabled ? onBackspace : null,
            ),
          ]),
        ],
      ),
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({
    this.label,
    this.icon,
    this.semanticLabel,
    this.plain = false,
    required this.onTap,
  });

  final String? label;
  final IconData? icon;
  final String? semanticLabel;

  /// Tombol ikon tanpa latar (hapus), seperti desain.
  final bool plain;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = label != null
        ? Text(label!, style: XpText.headingL(context))
        : Icon(icon, size: 26, color: XpColors.textSecondary);
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: Material(
        color: plain ? Colors.transparent : XpColors.canvas,
        borderRadius: BorderRadius.circular(XpRadius.l),
        child: InkWell(
          borderRadius: BorderRadius.circular(XpRadius.l),
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: SizedBox(height: 56, child: Center(child: content)),
        ),
      ),
    );
  }
}

/// Isian PIN lengkap: titik + papan angka, dengan nilai dipegang sendiri.
///
/// [onCompleted] dipanggil sekali begitu enam digit terisi. Pemanggil yang
/// ingin mengosongkan isian (mis. setelah konfirmasi tidak cocok) cukup
/// memberi `key` baru (mis. `ValueKey(step)`), yang membuang state lamanya.
class PinEntry extends StatefulWidget {
  const PinEntry({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.hasError = false,
  });

  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool hasError;

  @override
  State<PinEntry> createState() => _PinEntryState();
}

class _PinEntryState extends State<PinEntry> {
  String _value = '';

  void _add(String digit) {
    if (_value.length >= kPinLength) return;
    setState(() => _value += digit);
    widget.onChanged?.call(_value);
    if (_value.length == kPinLength) widget.onCompleted(_value);
  }

  void _remove() {
    if (_value.isEmpty) return;
    setState(() => _value = _value.substring(0, _value.length - 1));
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PinDots(filled: _value.length, hasError: widget.hasError),
        const SizedBox(height: 28),
        PinPad(
          enabled: widget.enabled,
          onDigit: _add,
          onBackspace: _remove,
        ),
      ],
    );
  }
}
