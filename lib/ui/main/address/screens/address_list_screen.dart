import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';
import 'package:marketplace_app_member/ui/main/address/screens/address_form_sheet.dart';
import 'package:marketplace_app_member/util/error_message.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Kelola alamat pengiriman (desain `kelola_alamat_pengiriman_xpedia_buyer`).
///
/// Batas **3 alamat** ditegakkan `AddressCubit`, bukan server (docs/22 #9) —
/// layar ini hanya memantulkannya lewat penghitung kapasitas dan tombol
/// tambah yang mati saat penuh.
///
/// Yang sengaja tidak dibangun dari desainnya:
///
/// * **peta pinpoint** — alamat tidak punya koordinat yang terisi dan app
///   belum punya peta (lihat `map_screen.dart` yang dimatikan);
/// * **"Alamat Kirim Terpilih"** — pilihan alamat kirim hanya ada di dalam
///   sesi checkout, bukan keadaan yang tersimpan di akun;
/// * **catatan enkripsi "Xpedia Secure+"** — tidak ada fitur backend yang
///   menyamarkan identitas penerima ke kurir, jadi klaimnya tidak ditulis.
class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressCubit()..load(),
      child: const _AddressListBody(),
    );
  }
}

class _AddressListBody extends StatelessWidget {
  const _AddressListBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(
        title: 'Kelola Alamat Pengiriman',
        actions: [SupportActionButton()],
      ),
      body: BlocConsumer<AddressCubit, AddressState>(
        // Tidak memanggil clearActionError: lembar formulir juga menampilkan
        // error yang sama di dalam dirinya, karena snackbar di sini tertutup
        // lembar modal.
        listenWhen: (previous, current) =>
            current is AddressReady &&
            current.actionError != null &&
            (previous is! AddressReady ||
                previous.actionError != current.actionError),
        listener: (context, state) {
          final error = (state as AddressReady).actionError!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(errorMessageFor(context, error))),
            );
        },
        builder: (context, state) {
          return switch (state) {
            AddressLoading() =>
              const Center(child: CircularProgressIndicator()),
            AddressError(:final error) => XpEmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Alamat belum bisa dimuat',
                message: errorMessageFor(context, error),
                actionLabel: 'Coba lagi',
                onAction: () => AddressCubit.get(context).load(),
              ),
            AddressReady() => _AddressList(state: state),
          };
        },
      ),
    );
  }
}

class _AddressList extends StatelessWidget {
  const _AddressList({required this.state});

  final AddressReady state;

  @override
  Widget build(BuildContext context) {
    final addresses = state.addresses;
    final primaryId = state.primary?.id;

    return RefreshIndicator(
      onRefresh: () => AddressCubit.get(context).load(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _CapacityCard(used: addresses.length),
          const SizedBox(height: 12),
          if (addresses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text('Belum ada alamat', style: XpText.titleM(context)),
                  const SizedBox(height: 4),
                  Text(
                    'Tambahkan alamat supaya pesanan bisa dikirim.',
                    textAlign: TextAlign.center,
                    style: XpText.bodyS(context)
                        .copyWith(color: XpColors.textSecondary),
                  ),
                ],
              ),
            ),
          for (final address in addresses)
            _AddressCard(
              address: address,
              // Server membolehkan beberapa alamat bertanda utama; yang
              // ditandai "Utama" di sini adalah yang juga dipakai checkout.
              isPrimary: address.id == primaryId && address.isPrimary,
              busy: state.isSaving,
            ),
          _AddTile(remaining: state.remainingSlots, busy: state.isSaving),
        ],
      ),
    );
  }
}

/// "Kapasitas Alamat Tersimpan": pil n / 3, meter tiga segmen, sisa slot.
class _CapacityCard extends StatelessWidget {
  const _CapacityCard({required this.used});

  final int used;

  @override
  Widget build(BuildContext context) {
    const max = AddressCubit.maxAddresses;
    final shown = used > max ? max : used;
    final left = max - shown;

    return XpCard(
      color: XpColors.primarySubtle,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 20, color: XpColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Kapasitas Alamat Tersimpan',
                    style: XpText.titleM(context)),
              ),
              XpPill(
                label: '$used / $max Alamat',
                tone: XpTone(XpColors.primary, Colors.white),
                large: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Kamu dapat menyimpan maksimal $max alamat pengiriman.',
            style:
                XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < max; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          i < shown ? XpColors.primary : XpColors.borderSubtle,
                      borderRadius: BorderRadius.circular(XpRadius.full),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text('$shown Terpakai',
                    style: XpText.caption(context)
                        .copyWith(color: XpColors.textTertiary)),
              ),
              Text(
                left > 0 ? 'Sisa $left slot alamat' : 'Kuota alamat penuh',
                style: XpText.labelS(context).copyWith(
                  color: left > 0 ? XpColors.primary : XpColors.danger,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.isPrimary,
    required this.busy,
  });

  final AddressModel address;
  final bool isPrimary;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final cubit = AddressCubit.get(context);
    final label = address.label.trim();

    return XpCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderColor: isPrimary ? XpColors.primary.withValues(alpha: 0.4) : null,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isPrimary) ...[
                XpPill(
                  label: 'Utama',
                  icon: Icons.star,
                  tone: XpTone(XpColors.primary, Colors.white),
                ),
                const SizedBox(width: 6),
              ],
              if (label.isNotEmpty)
                XpPill(
                  label: label,
                  tone: XpTone(XpColors.primarySubtle, XpColors.navy),
                ),
              const Spacer(),
              if (!address.isComplete)
                // Server menyimpan alamat berfield kosong; checkout tidak
                // menawarkannya, jadi pembeli perlu tahu alasannya di sini.
                XpPill(
                  label: 'Belum lengkap',
                  icon: Icons.error_outline,
                  tone: XpTone(XpColors.warningSubtle, const Color(0xff8C5002)),
                )
              else if (address.createdAt != null)
                Text(
                  'Disimpan ${formatServerDate(address.createdAt)}',
                  style: XpText.caption(context)
                      .copyWith(color: XpColors.textTertiary),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: address.recipientName, style: XpText.titleM(context)),
                if (address.phone.isNotEmpty)
                  TextSpan(
                    text: '  ${maskPhone(address.phone)}',
                    style: XpText.bodyS(context)
                        .copyWith(color: XpColors.textSecondary),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address.summary.isEmpty ? '-' : address.summary,
            style:
                XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (isPrimary)
                Expanded(
                  child: _NeutralButton(
                    icon: Icons.edit_outlined,
                    label: 'Ubah Alamat',
                    onPressed: busy
                        ? null
                        : () =>
                            AddressFormSheet.show(context, existing: address),
                  ),
                )
              else ...[
                Expanded(
                  child: _NeutralButton(
                    icon: Icons.verified_outlined,
                    label: 'Jadikan Alamat Utama',
                    foreground: XpColors.primary,
                    // Alamat tak lengkap tidak bisa dipakai checkout, jadi
                    // menjadikannya utama hanya akan membuat checkout jatuh
                    // ke alamat lain diam-diam.
                    onPressed: busy || !address.isComplete
                        ? null
                        : () => cubit.setPrimary(address.id),
                  ),
                ),
                const SizedBox(width: 8),
                _IconAction(
                  icon: Icons.edit_outlined,
                  tooltip: 'Ubah alamat',
                  onPressed: busy
                      ? null
                      : () => AddressFormSheet.show(context, existing: address),
                ),
              ],
              const SizedBox(width: 8),
              _IconAction(
                icon: Icons.delete_outline,
                tooltip: 'Hapus alamat',
                color: XpColors.danger,
                onPressed: busy ? null : () => _confirmDelete(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = AddressCubit.get(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus alamat ini?'),
        content: Text(
          isPrimary
              ? 'Ini alamat utama kamu. Setelah dihapus, checkout memakai '
                  'alamat lain yang tersisa.'
              : 'Alamat yang dihapus tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: XpColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) await cubit.remove(address.id);
  }
}

/// Menyamarkan nomor telepon jadi `0812****456` (design_buyer.md §6).
String maskPhone(String phone) {
  final digits = phone.trim();
  if (digits.length <= 7) return digits;
  final head = digits.substring(0, 4);
  final tail = digits.substring(digits.length - 3);
  return '$head****$tail';
}

class _NeutralButton extends StatelessWidget {
  const _NeutralButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.foreground,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: FilledButton.tonalIcon(
        style: FilledButton.styleFrom(
          backgroundColor: XpColors.sunken,
          foregroundColor: foreground ?? XpColors.textPrimary,
          minimumSize: const Size(48, 48),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XpRadius.m),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: XpColors.sunken,
        foregroundColor: color ?? XpColors.textPrimary,
        minimumSize: const Size(48, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XpRadius.m),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
    );
  }
}

/// Ubin "Tambah Alamat Baru" — mati saat kuota penuh, dengan alasannya.
class _AddTile extends StatelessWidget {
  const _AddTile({required this.remaining, required this.busy});

  final int remaining;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = remaining > 0 && !busy;

    return Opacity(
      opacity: remaining > 0 ? 1 : 0.6,
      child: XpCard(
        color: remaining > 0 ? XpColors.primarySubtle : XpColors.sunken,
        borderColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        onTap: enabled ? () => AddressFormSheet.show(context) : null,
        child: Semantics(
          button: true,
          enabled: enabled,
          label: 'Tambah Alamat Baru',
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: remaining > 0
                      ? XpColors.primary
                      : XpColors.textPlaceholder,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_location_alt_outlined,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Tambah Alamat Baru',
                style: XpText.titleM(context).copyWith(
                  color:
                      remaining > 0 ? XpColors.primary : XpColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                remaining > 0
                    ? 'Tersedia kuota simpan $remaining alamat lagi'
                    : 'Kuota penuh. Hapus salah satu alamat untuk menambah '
                        'yang baru.',
                textAlign: TextAlign.center,
                style: XpText.bodyS(context)
                    .copyWith(color: XpColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
