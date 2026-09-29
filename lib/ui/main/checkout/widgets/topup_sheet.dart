import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Lembar nominal top up dari checkout. Mengembalikan nominal yang dipilih,
/// atau `null` kalau ditutup.
///
/// Nominal awalnya **kekurangan saldo dibulatkan ke atas** — itulah yang
/// hampir selalu dimaui pembeli di tengah checkout. Minimum (Rp 10.000)
/// **tidak** ditegakkan server (docs/22 #12), jadi dijaga di sini dan sekali
/// lagi di `CheckoutCubit.startTopup`.
Future<double?> showCheckoutTopupSheet(
  BuildContext context, {
  required double suggested,
  required double minimum,
  required bool simulated,
}) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: XpColors.surface,
    builder: (_) => _TopupSheet(
      suggested: suggested,
      minimum: minimum,
      simulated: simulated,
    ),
  );
}

class _TopupSheet extends StatefulWidget {
  const _TopupSheet({
    required this.suggested,
    required this.minimum,
    required this.simulated,
  });

  final double suggested;
  final double minimum;
  final bool simulated;

  @override
  State<_TopupSheet> createState() => _TopupSheetState();
}

class _TopupSheetState extends State<_TopupSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.suggested.toInt().toString());
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_controller.text.trim());
    if (amount == null || amount < widget.minimum) {
      setState(
          () => _error = 'Minimal top up ${formatRupiah(widget.minimum)}.');
      return;
    }
    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    final quick = <double>{
      widget.suggested,
      for (final v in const [50000.0, 100000.0, 500000.0])
        if (v > widget.suggested) v,
    }.take(4).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Top Up Xpedia Wallet', style: XpText.headingM(context)),
            const SizedBox(height: 4),
            Text(
              'Saldo bertambah setelah pembayaran top up berhasil. Stok '
              'pesananmu tetap ditahan selama waktu reservasi.',
              style:
                  XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Nominal top up',
                prefixText: 'Rp ',
                errorText: _error,
                helperText: 'Minimal ${formatRupiah(widget.minimum)}',
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final value in quick)
                  ChoiceChip(
                    label: Text(formatRupiah(value)),
                    selected: _controller.text == value.toInt().toString(),
                    onSelected: (_) => setState(() {
                      _controller.text = value.toInt().toString();
                      _error = null;
                    }),
                  ),
              ],
            ),
            if (widget.simulated) ...[
              const SizedBox(height: 12),
              Text(
                'Simulasi: top up tetap membuat transaksi sungguhan, tapi '
                'saldo simulasi di checkout tidak ikut bertambah.',
                style: XpText.caption(context)
                    .copyWith(color: const Color(0xff8C5002)),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Lanjut Top Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
