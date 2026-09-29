import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/identity_verification_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/login_devices_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/contact_change_sheet.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/identity_status_pill.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Keamanan Akun: verifikasi identitas, kontak akun, kata sandi & PIN, dan
/// perangkat yang sedang login.
///
/// Sumber datanya bercampur, dan layar menandainya:
///
/// * **Perangkat aktif** — `GET/DELETE /me/sessions`, sungguhan.
/// * **Verifikasi KTP** (docs/22 #4) dan **ganti email/HP** (#10) — kontrak
///   usulan yang dijawab mock di debug; seksinya berlencana "Simulasi".
///   Dengan mock mati, seksinya disembunyikan / menjelaskan belum tersedia.
/// * **Kata sandi** — tidak ada endpoint ganti sandi; satu-satunya jalan
///   adalah reset lewat email, jadi barisnya membuka alur itu.
class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..restoreSession()),
        BlocProvider(create: (_) => IdentityVerificationCubit()..load()),
        BlocProvider(create: (_) => LoginDevicesCubit()..load()),
      ],
      child: const _AccountSecurityBody(),
    );
  }
}

class _AccountSecurityBody extends StatelessWidget {
  const _AccountSecurityBody();

  Future<void> _refresh(BuildContext context) => Future.wait([
        AuthCubit.get(context).restoreSession(),
        IdentityVerificationCubit.get(context).load(),
        LoginDevicesCubit.get(context).load(),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Keamanan Akun'),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: const [
            _IdentitySection(),
            _ContactSection(),
            _GroupHeader('Kata Sandi & PIN'),
            _PasswordSection(),
            _GroupHeader('Perangkat Aktif'),
            _DevicesSection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title, {this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: XpText.labelM(context).copyWith(color: XpColors.textSecondary, letterSpacing: 0.8),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Verifikasi identitas
// ---------------------------------------------------------------------------

class _IdentitySection extends StatelessWidget {
  const _IdentitySection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
      builder: (context, state) {
        final Widget child = switch (state) {
          IdentityVerificationLoading() => const SizedBox(
              height: 72, child: Center(child: CircularProgressIndicator())),
          // Endpoint belum ada: seksinya tidak dijanjikan sama sekali.
          IdentityVerificationUnavailable() => const SizedBox.shrink(),
          IdentityVerificationError(:final error) => XpCard(
              child: Row(children: [
                Expanded(
                  child: Text(accountErrorText(context, error),
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
                ),
                TextButton(
                  onPressed: IdentityVerificationCubit.get(context).load,
                  child: const Text('Coba lagi'),
                ),
              ]),
            ),
          IdentityVerificationReady(:final verification, :final meta) =>
            _card(context, verification, meta),
        };
        if (state is IdentityVerificationUnavailable) return child;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _GroupHeader(
              'Verifikasi Identitas',
              trailing: state is IdentityVerificationReady
                  ? SimulatedBadge(meta: state.meta)
                  : null,
            ),
            child,
          ],
        );
      },
    );
  }

  Widget _card(BuildContext context, IdentityVerificationModel v, Map<String, dynamic> meta) {
    final status = v.statusValue;
    final description = switch (status) {
      IdentityStatus.none => 'Verifikasi KTP memastikan satu KTP hanya untuk satu akun '
          'Xpedia, supaya akunmu tidak bisa diduplikasi orang lain.',
      IdentityStatus.pending => 'Data KTP-mu sedang ditinjau. Nama lengkap dikunci '
          'selama peninjauan.',
      IdentityStatus.verified => 'Identitasmu terverifikasi. Nama lengkap dan KTP tidak '
          'bisa diubah sendiri — hubungi Xpedia 911 bila ada yang keliru.',
      IdentityStatus.rejected => v.rejectionReason ?? 'Pengajuan belum bisa disetujui. '
          'Periksa data KTP-mu lalu ajukan ulang.',
    };
    return XpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.badge_outlined, color: XpColors.primary),
            const SizedBox(width: 12),
            Expanded(child: Text('KTP', style: XpText.titleM(context))),
            IdentityStatusPill(status: status),
          ]),
          const SizedBox(height: 8),
          Text(description, style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
          if (v.idCardNumberMasked != null || v.fullName != null) ...[
            const SizedBox(height: 8),
            if (v.fullName != null) XpKeyValueRow(label: 'Nama sesuai KTP', value: v.fullName!),
            if (v.idCardNumberMasked != null)
              XpKeyValueRow(label: 'NIK', value: v.idCardNumberMasked!),
            if (v.verifiedAt != null)
              XpKeyValueRow(label: 'Terverifikasi', value: formatServerDate(v.verifiedAt)),
          ],
          if (v.canSubmit || v.isPending) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: v.isPending
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      onPressed: IdentityVerificationCubit.get(context).load,
                      child: const Text('Periksa Status'),
                    )
                  : FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      onPressed: () => _openForm(context),
                      child: Text(status == IdentityStatus.rejected
                          ? 'Ajukan Ulang'
                          : 'Verifikasi Sekarang'),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  void _openForm(BuildContext context) {
    final cubit = IdentityVerificationCubit.get(context);
    final auth = AuthCubit.get(context).state;
    final name = auth is AuthAuthenticated ? auth.user?.fullName : null;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: XpColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      // Cubit layar diteruskan: lembar hidup di rute terpisah, di luar
      // `BlocProvider` layar ini.
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _IdentityFormSheet(initialName: name),
      ),
    );
  }
}

class _IdentityFormSheet extends StatefulWidget {
  const _IdentityFormSheet({this.initialName});

  final String? initialName;

  @override
  State<_IdentityFormSheet> createState() => _IdentityFormSheetState();
}

class _IdentityFormSheetState extends State<_IdentityFormSheet> {
  final _nik = TextEditingController();
  late final _name = TextEditingController(text: widget.initialName ?? '');

  @override
  void dispose() {
    _nik.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await IdentityVerificationCubit.get(context)
        .submit(idCardNumber: _nik.text, fullName: _name.text);
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
      builder: (context, state) {
        final ready = state is IdentityVerificationReady ? state : null;
        final busy = ready?.isSubmitting ?? false;
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Expanded(child: Text('Verifikasi KTP', style: XpText.headingM(context))),
                  SimulatedBadge(meta: ready?.meta),
                ]),
                const SizedBox(height: 8),
                Text(
                  'Isi persis seperti yang tertulis di KTP. Setelah terverifikasi, '
                  'nama lengkap tidak bisa diubah sendiri.',
                  style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nik,
                  enabled: !busy,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'NIK (16 digit)',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _name,
                  enabled: !busy,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama lengkap sesuai KTP',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                if (ready?.submitError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(accountErrorText(context, ready!.submitError!),
                        style: XpText.bodyS(context).copyWith(color: XpColors.danger)),
                  ),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: busy ? null : _submit,
                  child: busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Ajukan Verifikasi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Kontak akun
// ---------------------------------------------------------------------------

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _GroupHeader('Kontak Akun'),
            XpCard(
              padding: EdgeInsets.zero,
              child: Column(children: [
                ContactRow(
                  icon: Icons.mail_outline,
                  type: ContactType.email,
                  value: user?.email,
                  user: user,
                ),
                Divider(height: 1, color: XpColors.borderSubtle),
                ContactRow(
                  icon: Icons.phone_outlined,
                  type: ContactType.phone,
                  value: user?.phone,
                  user: user,
                ),
              ]),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Kata sandi & PIN
// ---------------------------------------------------------------------------

class _PasswordSection extends StatelessWidget {
  const _PasswordSection();

  @override
  Widget build(BuildContext context) {
    return XpCard(
      padding: EdgeInsets.zero,
      child: Column(children: [
        _LinkRow(
          icon: Icons.lock_outline,
          title: 'Ubah Kata Sandi',
          // Tidak ada endpoint ganti sandi di backend — hanya reset lewat
          // tautan email, yang sekaligus mengeluarkan semua perangkat.
          subtitle: 'Lewat tautan reset yang dikirim ke email',
          onTap: () => context.push(AppRoutes.forgotPassword),
        ),
        Divider(height: 1, color: XpColors.borderSubtle),
        _LinkRow(
          icon: Icons.pin_outlined,
          title: 'PIN Xpedia Wallet',
          subtitle: 'PIN untuk pembayaran dan penarikan',
          onTap: () => context.push(AppRoutes.withdrawalPin),
        ),
      ]),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Icon(icon, size: 20, color: XpColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: XpText.titleM(context)),
              Text(subtitle, style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
            ]),
          ),
          const Icon(Icons.chevron_right, size: 20, color: XpColors.textPlaceholder),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Perangkat aktif (sungguhan)
// ---------------------------------------------------------------------------

class _DevicesSection extends StatelessWidget {
  const _DevicesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginDevicesCubit, LoginDevicesState>(
      builder: (context, state) {
        return switch (state) {
          LoginDevicesLoading() =>
            const SizedBox(height: 96, child: Center(child: CircularProgressIndicator())),
          LoginDevicesError(:final error) => XpCard(
              child: Row(children: [
                Expanded(
                  child: Text(accountErrorText(context, error),
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
                ),
                TextButton(
                  onPressed: LoginDevicesCubit.get(context).load,
                  child: const Text('Coba lagi'),
                ),
              ]),
            ),
          LoginDevicesReady() => _ready(context, state),
        };
      },
    );
  }

  Widget _ready(BuildContext context, LoginDevicesReady state) {
    final cubit = LoginDevicesCubit.get(context);
    final others = state.devices.where((d) => !d.isCurrent).length;
    final hasCurrent = state.devices.any((d) => d.isCurrent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.actionError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: XpBanner(
              icon: Icons.error_outline,
              tone: XpBannerTone.danger,
              title: accountErrorText(context, state.actionError!),
            ),
          ),
        if (state.devices.isEmpty)
          const XpCard(
            child: XpEmptyState(
              icon: Icons.devices_other,
              title: 'Tidak ada perangkat lain',
              message: 'Hanya perangkat ini yang sedang masuk.',
            ),
          ),
        for (final device in state.devices)
          _DeviceCard(
            device: device,
            busy: state.revokingKey == device.key ||
                (state.revokingKey == LoginDevicesState.allOthersKey && !device.isCurrent),
            locked: state.revokingKey != null,
          ),
        if (others > 0 && hasCurrent) ...[
          const SizedBox(height: 4),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: XpColors.danger,
            ),
            onPressed: state.revokingKey != null
                ? null
                : () async {
                    final ok = await _confirm(
                      context,
                      title: 'Keluarkan $others perangkat lain?',
                      message: 'Perangkat itu perlu masuk lagi untuk memakai akunmu.',
                      action: 'Keluarkan',
                    );
                    if (ok) await cubit.revokeOthers();
                  },
            icon: const Icon(Icons.phonelink_erase),
            label: const Text('Keluar dari semua perangkat lain'),
          ),
        ],
        const SizedBox(height: 8),
        // Server hanya mencatat kapan sesi dibuat; waktunya diperbarui tiap
        // token diperpanjang, bukan tiap kali app dipakai.
        Text(
          hasCurrent
              ? 'Waktu yang tampil adalah saat sesi terakhir diperbarui.'
              : 'Perangkat ini belum bisa dikenali dari daftar — jam perangkat '
                  'mungkin berbeda dengan server. Waktu yang tampil adalah saat '
                  'sesi terakhir diperbarui.',
          style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device, required this.busy, required this.locked});

  final LoginDevice device;
  final bool busy;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final label = device.label;
    final icon = label.startsWith('Aplikasi')
        ? Icons.smartphone
        : (label.contains('Android') || label.contains('iOS'))
            ? Icons.phone_android
            : Icons.computer;
    final details = [
      if ((device.ipAddress ?? '').isNotEmpty) 'IP ${device.ipAddress}',
      if (device.lastSeenAt != null) formatServerDateTime(device.lastSeenAt),
    ].join(' · ');

    return XpCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: device.isCurrent ? XpColors.primarySubtle : XpColors.sunken,
                borderRadius: BorderRadius.circular(XpRadius.m),
              ),
              child: Icon(icon,
                  size: 20, color: device.isCurrent ? XpColors.primary : XpColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(
                    child: Text(label,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: XpText.titleM(context)),
                  ),
                  if (device.isCurrent) ...[
                    const SizedBox(width: 8),
                    XpPill(
                      label: 'Perangkat ini',
                      tone: XpTone(XpColors.primarySubtle, XpColors.primary),
                    ),
                  ],
                ]),
                if (details.isNotEmpty)
                  Text(details,
                      style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary)),
              ]),
            ),
          ]),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: busy
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      foregroundColor: XpColors.danger,
                    ),
                    onPressed: locked ? null : () => _onLogout(context),
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(device.isCurrent ? 'Keluar dari perangkat ini' : 'Keluarkan'),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _onLogout(BuildContext context) async {
    final devices = LoginDevicesCubit.get(context);
    final auth = AuthCubit.get(context);
    if (device.isCurrent) {
      final ok = await _confirm(
        context,
        title: 'Keluar dari perangkat ini?',
        message: 'Kamu perlu masuk lagi untuk berbelanja.',
        action: 'Keluar',
      );
      if (!ok) return;
      // Lewat logout biasa, bukan DELETE sesi: token di perangkat ini juga
      // harus dibuang, bukan hanya dicabut di server.
      await auth.logout();
      router.go(AppRoutes.login);
      return;
    }
    final ok = await _confirm(
      context,
      title: 'Keluarkan ${device.label}?',
      message: 'Perangkat itu perlu masuk lagi untuk memakai akunmu.',
      action: 'Keluarkan',
    );
    if (ok) await devices.revoke(device);
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String action,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: XpColors.danger),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(action),
        ),
      ],
    ),
  );
  return result == true;
}
