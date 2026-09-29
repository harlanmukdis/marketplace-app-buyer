import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/cart/cart_model.dart';
import 'package:marketplace_app_member/core/domain/model/cart/voucher_model.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/voucher/cubit/voucher_cubit.dart';
import 'package:marketplace_app_member/ui/main/voucher/widgets/voucher_texts.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Voucher Belanja & Bebas Ongkir — dibuka dari kartu voucher keranjang.
///
/// Tidak ada desain mobile khusus; dibangun dari bahasa kartu voucher di
/// `keranjang_belanja_xpedia_buyer` (§3.8). Empat bagian, urut menurut apa
/// yang paling mungkin dicari pembeli yang datang dari keranjang:
///
/// 1. **kode manual** — "Pakai" memasang ke keranjang, "Klaim" menyimpan ke
///    Voucher Saya (dua langkah terpisah di server);
/// 2. **terpasang di keranjang** (dari `GET /cart/summary`), bisa dilepas;
/// 3. **rekomendasi** terbaik per slot + "Gunakan Otomatis" — hanya kalau
///    ada barang tercentang, karena servernya 500 untuk keranjang kosong;
/// 4. **Voucher Saya** (`GET /me/vouchers`).
///
/// Semua endpoint sungguhan dan **kosong di dev** (tidak ada voucher yang
/// di-seed) — keadaan kosong di sini normal, bukan kegagalan. Tidak ada
/// yang di-mock.
class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoucherCubit()..load(),
      child: const _VoucherBody(),
    );
  }
}

class _VoucherBody extends StatelessWidget {
  const _VoucherBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(
        title: 'Voucher Saya',
        actions: [SupportActionButton()],
      ),
      body: BlocConsumer<VoucherCubit, VoucherState>(
        listenWhen: (previous, current) =>
            current is VoucherReady &&
            (current.actionError != null || current.notice != null),
        listener: (context, state) {
          final ready = state as VoucherReady;
          final text = ready.actionError != null
              ? voucherErrorText(context, ready.actionError!)
              : ready.notice!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(text)));
          VoucherCubit.get(context).clearMessages();
        },
        builder: (context, state) => switch (state) {
          VoucherLoading() => const Center(child: CircularProgressIndicator()),
          VoucherError(:final error) => XpEmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Voucher belum bisa dimuat',
              message: voucherErrorText(context, error),
              actionLabel: 'Coba lagi',
              onAction: () => VoucherCubit.get(context).load(),
            ),
          VoucherReady() => _Ready(state: state),
        },
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final VoucherReady state;

  @override
  Widget build(BuildContext context) {
    final cubit = VoucherCubit.get(context);
    final summary = state.summary;
    final busy = state.busyCode != null || state.autoApplying;

    return RefreshIndicator(
      onRefresh: cubit.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _CodeInput(
            busy: busy,
            canApply: !summary.isEmpty,
          ),
          const SizedBox(height: 16),

          // --- terpasang ------------------------------------------------
          const XpSectionHeader(
            title: 'Dipakai di Keranjang',
            subtitle: 'Maks. 1 bebas ongkir + 1 voucher Xpedia + 1 per toko',
            padding: EdgeInsets.only(bottom: 8),
          ),
          if (summary.isEmpty)
            const XpBanner(
              icon: Icons.shopping_cart_outlined,
              tone: XpBannerTone.info,
              title: 'Belum ada barang yang dipilih',
              message: 'Centang barang di keranjang dulu — voucher dihitung '
                  'dari barang yang dipilih.',
            )
          else if (!summary.hasVouchers)
            const _Hint('Belum ada voucher yang dipakai.')
          else
            for (final voucher in summary.vouchers)
              _VoucherTile(
                icon: _iconFor(voucher.discountType),
                title: voucher.code,
                badge: voucherSlotLabel(voucher.category),
                subtitle: appliedVoucherValue(voucher),
                actionLabel: 'Lepas',
                outlined: true,
                busy: state.busyCode == voucher.code,
                enabled: !busy,
                onAction: () => cubit.remove(voucher.code),
              ),
          if (summary.discountAmount > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Total potongan belanja: ${formatRupiah(summary.discountAmount)}',
              style: XpText.labelL(context).copyWith(color: XpColors.success),
            ),
          ],

          // --- rekomendasi ----------------------------------------------
          if (!summary.isEmpty) ...[
            const SizedBox(height: 20),
            XpSectionHeader(
              title: 'Rekomendasi untuk Keranjang',
              subtitle: 'Voucher terbaik untuk tiap slot',
              padding: const EdgeInsets.only(bottom: 8),
              actionLabel: state.recommended.isEmpty
                  ? null
                  : (state.autoApplying ? 'Memasang…' : 'Gunakan Otomatis'),
              onAction: busy ? null : cubit.autoApply,
            ),
            if (state.recommendedError != null)
              const _Hint('Rekomendasi belum bisa dimuat. Tarik untuk memuat ulang.')
            else if (state.recommended.isEmpty)
              const _Hint('Belum ada voucher yang cocok untuk isi keranjangmu.')
            else
              for (final voucher in state.recommended)
                _VoucherTile(
                  icon: _iconFor(voucher.discountType),
                  title: voucher.code,
                  badge: voucherSlotLabel(voucher.category),
                  subtitle: appliedVoucherValue(voucher),
                  actionLabel:
                      _isApplied(summary, voucher.code) ? 'Dipakai' : 'Pakai',
                  busy: state.busyCode == voucher.code,
                  enabled: !busy && !_isApplied(summary, voucher.code),
                  onAction: () => cubit.apply(voucher.code),
                ),
          ],

          // --- voucher saya ---------------------------------------------
          const SizedBox(height: 20),
          const XpSectionHeader(
            title: 'Voucher Saya',
            padding: EdgeInsets.only(bottom: 8),
          ),
          if (state.claimedError != null)
            const _Hint('Voucher Saya belum bisa dimuat. Tarik untuk memuat ulang.')
          else if (state.claimed.isEmpty)
            XpCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: XpEmptyState(
                icon: Icons.confirmation_number_outlined,
                title: 'Belum ada voucher',
                message: 'Voucher yang kamu klaim akan tersimpan di sini.',
                actionLabel: 'Mulai Belanja',
                onAction: () => context.go(AppRoutes.homeLayout),
              ),
            )
          else
            for (final voucher in state.claimed)
              _VoucherTile(
                icon: _iconFor(voucher.discountType),
                title: voucher.name.isEmpty ? voucher.code : voucher.name,
                badge:
                    voucher.storeId == null ? 'Voucher Xpedia' : 'Voucher Toko',
                subtitle: _claimedSubtitle(voucher),
                actionLabel:
                    _isApplied(summary, voucher.code) ? 'Dipakai' : 'Pakai',
                busy: state.busyCode == voucher.code,
                // Voucher kedaluwarsa tetap ikut di daftar (server tidak
                // menyaring statusnya); memakainya hanya berujung
                // VOUCHER_INVALID.
                enabled: !busy &&
                    voucher.isUsable &&
                    !summary.isEmpty &&
                    !_isApplied(summary, voucher.code),
                onAction: () => cubit.apply(voucher.code),
              ),
        ],
      ),
    );
  }

  static bool _isApplied(CartSummaryModel summary, String code) =>
      summary.vouchers.any((v) => v.code == code);

  static String _claimedSubtitle(VoucherModel v) {
    final parts = <String>[
      claimedVoucherValue(v),
      if (v.minSpend > 0) 'Min. belanja ${formatRupiah(v.minSpend)}',
      if (!v.isUsable)
        'Sudah tidak berlaku'
      else if (v.validUntil != null)
        'Berlaku s.d. ${formatServerDate(v.validUntil)}',
    ];
    return parts.join(' · ');
  }

  static IconData _iconFor(String discountType) => switch (discountType) {
        'free_shipping' => Icons.local_shipping_outlined,
        'cashback' => Icons.savings_outlined,
        _ => Icons.confirmation_number_outlined,
      };
}

class _CodeInput extends StatefulWidget {
  const _CodeInput({required this.busy, required this.canApply});

  final bool busy;

  /// Memasang butuh barang tercentang; mengklaim tidak.
  final bool canApply;

  @override
  State<_CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<_CodeInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = VoucherCubit.get(context);
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Punya kode voucher?', style: XpText.titleM(context)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              hintText: 'Masukkan kode voucher',
              prefixIcon: Icon(Icons.confirmation_number_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: widget.busy || _controller.text.trim().isEmpty
                        ? null
                        : () => cubit.claim(_controller.text),
                    child: const Text('Klaim'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: widget.busy ||
                            !widget.canApply ||
                            _controller.text.trim().isEmpty
                        ? null
                        : () => cubit.apply(_controller.text),
                    child: const Text('Pakai'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '"Pakai" memasang ke keranjang. "Klaim" menyimpannya ke Voucher '
            'Saya untuk dipakai nanti.',
            style:
                XpText.caption(context).copyWith(color: XpColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _VoucherTile extends StatelessWidget {
  const _VoucherTile({
    required this.icon,
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.actionLabel,
    required this.busy,
    required this.enabled,
    required this.onAction,
    this.outlined = false,
  });

  final IconData icon;
  final String title;
  final String badge;
  final String subtitle;
  final String actionLabel;
  final bool busy;
  final bool enabled;
  final VoidCallback onAction;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final button = busy
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2))
        : outlined
            ? TextButton(
                onPressed: enabled ? onAction : null, child: Text(actionLabel))
            : FilledButton.tonal(
                onPressed: enabled ? onAction : null,
                style: FilledButton.styleFrom(minimumSize: const Size(72, 40)),
                child: Text(actionLabel),
              );

    return XpCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      color: XpColors.warningSubtle,
      borderColor: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: XpColors.warning,
              borderRadius: BorderRadius.circular(XpRadius.m),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(title, style: XpText.labelL(context)),
                    XpPill(
                      label: badge,
                      tone: const XpTone(Color(0x33F59E0B), Color(0xff8C5002)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: XpText.caption(context)
                        .copyWith(color: XpColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          button,
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text,
          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
    );
  }
}
