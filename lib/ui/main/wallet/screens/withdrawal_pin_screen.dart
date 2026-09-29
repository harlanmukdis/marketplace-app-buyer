import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/wallet/cubit/wallet_cubit.dart';
import 'package:marketplace_app_member/ui/main/wallet/widgets/pin_pad.dart';

/// Membuat atau mengganti PIN 6 digit Xpedia Wallet (inventaris desain §3.11).
///
/// ⚠️ **Server tidak bisa ditanya apakah PIN sudah ada** — `GET` pada path
/// PIN jatuh ke `GET /wallet`. Karena itu dua mode ditawarkan terang-terangan
/// ("Buat PIN" dan "Ubah PIN") alih-alih menebak; menebak salah berarti
/// menyuruh user memasukkan PIN lama yang tidak pernah ada.
///
/// Satu PIN Xpedia Wallet untuk **penarikan dan pembayaran** (blueprint Buyer
/// Ch.6). Di backend hari ini PIN baru dipakai penarikan; checkout Wallet +
/// PIN masih kontrak yang diusulkan dan di-mock (`checkout_mock_routes.dart`,
/// docs/22 #2) — begitu backend membangunnya, PIN yang dibuat di sini yang
/// diverifikasi.
class WithdrawalPinScreen extends StatelessWidget {
  const WithdrawalPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletCubit()..load(),
      child: const _PinBody(),
    );
  }
}

enum _PinMode { create, change }

enum _PinStep { current, fresh, confirm }

class _PinBody extends StatefulWidget {
  const _PinBody();

  @override
  State<_PinBody> createState() => _PinBodyState();
}

class _PinBodyState extends State<_PinBody> {
  _PinMode _mode = _PinMode.create;
  _PinStep _step = _PinStep.fresh;
  String _currentPin = '';
  String _freshPin = '';
  String? _error;

  /// Dinaikkan setiap kali isian harus dikosongkan, supaya [PinEntry]
  /// dibangun ulang dengan state baru walau langkahnya sama.
  int _generation = 0;

  void _setMode(_PinMode mode) {
    setState(() {
      _mode = mode;
      _restart();
      _error = null;
    });
  }

  void _restart() {
    _step = _mode == _PinMode.change ? _PinStep.current : _PinStep.fresh;
    _currentPin = '';
    _freshPin = '';
    _generation++;
  }

  void _onCompleted(String value) {
    switch (_step) {
      case _PinStep.current:
        setState(() {
          _currentPin = value;
          _step = _PinStep.fresh;
          _error = null;
          _generation++;
        });
      case _PinStep.fresh:
        setState(() {
          _freshPin = value;
          _step = _PinStep.confirm;
          _error = null;
          _generation++;
        });
      case _PinStep.confirm:
        if (value != _freshPin) {
          setState(() {
            _error = 'PIN konfirmasi tidak sama. Masukkan PIN baru sekali lagi.';
            _step = _PinStep.fresh;
            _freshPin = '';
            _generation++;
          });
          return;
        }
        WalletCubit.get(context).setPin(
          pin: _freshPin,
          currentPin: _mode == _PinMode.change ? _currentPin : null,
        );
    }
  }

  void _onServerError(DataError error) {
    setState(() {
      _error = accountErrorText(context, error, overrides: {
        // Server membalas VALIDATION_ERROR untuk PIN lama yang salah. Pada
        // mode "Buat PIN" kode yang sama kemungkinan besar berarti PIN sudah
        // pernah dibuat dan server menuntut PIN lama.
        ApiErrorCode.validationError: _mode == _PinMode.change
            ? 'PIN lama salah. Coba lagi.'
            : 'PIN belum bisa disimpan. Kalau kamu sudah pernah membuat PIN, '
                'pilih "Ubah PIN".',
      });
      _restart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.surface,
      appBar: const XpStackAppBar(title: 'PIN Xpedia Wallet'),
      body: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (previous, current) =>
            current is WalletReady && (current.pinSaved || current.actionError != null),
        listener: (context, state) {
          final ready = state as WalletReady;
          final cubit = WalletCubit.get(context);
          if (ready.actionError != null) {
            _onServerError(ready.actionError!);
            cubit.clearActionError();
            return;
          }
          cubit.acknowledgeWithdrawal();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(_mode == _PinMode.change
                  ? 'PIN Xpedia Wallet berhasil diubah'
                  : 'PIN Xpedia Wallet berhasil dibuat'),
            ));
          if (context.canPop()) context.pop();
        },
        builder: (context, state) {
          return switch (state) {
            WalletLoading() => const Center(child: CircularProgressIndicator()),
            WalletError(:final error) => XpEmptyState(
                icon: Icons.cloud_off_rounded,
                title: 'Dompet belum bisa dimuat',
                message: accountErrorText(context, error),
                actionLabel: 'Coba lagi',
                onAction: () => WalletCubit.get(context).load(),
              ),
            WalletReady(:final isSubmitting) => _content(context, isSubmitting),
          };
        },
      ),
    );
  }

  Widget _content(BuildContext context, bool busy) {
    final (title, subtitle) = switch (_step) {
      _PinStep.current => ('Masukkan PIN Lama', 'PIN yang kamu pakai sekarang.'),
      _PinStep.fresh => (
          _mode == _PinMode.change ? 'Masukkan PIN Baru' : 'Buat PIN 6-Digit',
          'Hindari angka berurutan atau tanggal lahir.',
        ),
      _PinStep.confirm => ('Ulangi PIN Baru', 'Masukkan PIN yang sama sekali lagi.'),
    };

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          Center(
            child: SegmentedButton<_PinMode>(
              segments: const [
                ButtonSegment(value: _PinMode.create, label: Text('Buat PIN')),
                ButtonSegment(value: _PinMode.change, label: Text('Ubah PIN')),
              ],
              selected: {_mode},
              showSelectedIcon: false,
              onSelectionChanged: busy ? null : (s) => _setMode(s.first),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: XpColors.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shield_outlined, size: 32, color: XpColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: XpText.headingL(context)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
          ),
          const SizedBox(height: 28),
          Center(
            child: PinEntry(
              key: ValueKey('$_mode-$_step-$_generation'),
              enabled: !busy,
              hasError: _error != null && _step != _PinStep.confirm,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onCompleted: _onCompleted,
            ),
          ),
          SizedBox(
            height: 40,
            child: Center(
              child: busy
                  ? const SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : _error == null
                      ? null
                      : Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: XpText.bodyS(context).copyWith(color: XpColors.danger),
                        ),
            ),
          ),
          const SizedBox(height: 8),
          const XpBanner(
            icon: Icons.info_outline,
            title: 'PIN dipakai untuk menarik saldo',
            message: 'Percobaan PIN dibatasi 5 kali per 15 menit — PIN yang '
                'benar pun ikut dihitung.',
          ),
          const SizedBox(height: 12),
          // Tidak ada endpoint reset PIN; satu-satunya jalan adalah Xpedia 911.
          TextButton(
            onPressed: () => context.push(AppRoutes.support),
            child: const Text('Lupa PIN? Hubungi Xpedia 911'),
          ),
        ],
      ),
    );
  }
}
