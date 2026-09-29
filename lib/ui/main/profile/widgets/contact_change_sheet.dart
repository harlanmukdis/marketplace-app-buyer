import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/contact_change_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

/// Lembar ganti email / nomor HP (docs/22 #10), dipakai layar Keamanan Akun
/// dan Ubah Profil.
///
/// Mengembalikan `true` kalau kontak baru tersimpan — pemanggil memuat ulang
/// `GET /me` (`change-confirm` membalas `data: null`).
Future<bool?> showContactChangeSheet(
  BuildContext context, {
  required ContactType type,
  String? currentValue,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: XpColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => BlocProvider(
      create: (_) => ContactChangeCubit(type: type, currentValue: currentValue),
      child: _ContactChangeSheet(currentValue: currentValue),
    ),
  );
}

class _ContactChangeSheet extends StatefulWidget {
  const _ContactChangeSheet({this.currentValue});

  final String? currentValue;

  @override
  State<_ContactChangeSheet> createState() => _ContactChangeSheetState();
}

class _ContactChangeSheetState extends State<_ContactChangeSheet> {
  final _value = TextEditingController();
  final _token = TextEditingController();

  @override
  void dispose() {
    _value.dispose();
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactChangeCubit, ContactChangeState>(
      // Kode dikosongkan tiap kali permintaan baru dibuat: permintaan baru
      // membatalkan kode lama di server.
      listenWhen: (a, b) => !identical(a.request, b.request),
      listener: (_, __) => _token.clear(),
      builder: (context, state) {
        final cubit = ContactChangeCubit.get(context);
        final Widget body;
        if (state.completed) {
          body = _completed(context, state);
        } else if (state.awaitingToken) {
          body = _tokenStep(context, state, cubit);
        } else {
          body = _valueStep(context, state, cubit);
        }
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: XpColors.borderDefault,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text('Ganti ${state.type.label}', style: XpText.headingM(context)),
                const SizedBox(height: 16),
                body,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _error(BuildContext context, ContactChangeState state) {
    if (state.error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        accountErrorText(context, state.error!, overrides: const {
          ApiErrorCode.invalidToken: 'Kode verifikasi salah, sudah dipakai, atau '
              'lewat 30 menit. Periksa lagi, atau kirim ulang kode.',
          ApiErrorCode.emailTaken: 'Email ini sudah dipakai akun lain. Pakai '
              'email lain.',
          ApiErrorCode.phoneTaken: 'Nomor HP ini sudah dipakai akun lain. Pakai '
              'nomor lain.',
          ApiErrorCode.tooManyRequests: 'Terlalu banyak permintaan kode. Coba '
              'lagi dalam satu jam.',
        }),
        style: XpText.bodyS(context).copyWith(color: XpColors.danger),
      ),
    );
  }

  Widget _valueStep(BuildContext context, ContactChangeState state, ContactChangeCubit cubit) {
    final isEmail = state.type == ContactType.email;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if ((widget.currentValue ?? '').isNotEmpty)
          XpKeyValueRow(label: '${state.type.label} sekarang', value: widget.currentValue!),
        const SizedBox(height: 8),
        TextField(
          controller: _value,
          enabled: !state.isBusy,
          autofocus: true,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.phone,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: isEmail ? 'Email baru' : 'Nomor HP baru',
            hintText: isEmail ? 'nama@email.com' : '08xxxxxxxxxx',
            prefixIcon: Icon(isEmail ? Icons.mail_outline : Icons.phone_outlined),
          ),
          onSubmitted: (_) => cubit.request(_value.text),
        ),
        const SizedBox(height: 12),
        Text(
          'Demi keamananmu, kode verifikasi dikirim ke '
          '${state.type.label.toLowerCase()} lama. Perubahan tersimpan setelah '
          'kodenya dimasukkan.',
          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 16),
        _error(context, state),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: state.isBusy ? null : () => cubit.request(_value.text),
          child: state.isBusy ? const _Spinner() : const Text('Kirim Kode'),
        ),
      ],
    );
  }

  Widget _tokenStep(BuildContext context, ContactChangeState state, ContactChangeCubit cubit) {
    final label = state.type.label.toLowerCase();
    final devToken = state.request?.devVerificationToken;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Masukkan kode verifikasi yang kami kirim ke $label lama kamu '
            'untuk mengganti ke ${state.newValue}.',
            style: XpText.bodyM(context)),
        const SizedBox(height: 4),
        Text('Kode berlaku 30 menit.',
            style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
        const SizedBox(height: 16),
        // Kodenya 64 karakter — praktis hanya ditempel dari email, jadi
        // kolom biasa, bukan kotak 6 angka.
        TextField(
          controller: _token,
          enabled: !state.isBusy,
          autofocus: true,
          autocorrect: false,
          enableSuggestions: false,
          textDirection: TextDirection.ltr,
          decoration: const InputDecoration(
            labelText: 'Kode verifikasi',
            hintText: 'Tempel kode dari pesan',
            prefixIcon: Icon(Icons.key_outlined),
          ),
          onSubmitted: (_) => cubit.confirm(_token.text),
        ),
        // Hanya di debug, dan hanya bila backend berjalan dalam mode
        // development — pola yang sama dengan lupa kata sandi.
        if (kDebugMode && devToken != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: state.isBusy ? null : () => _token.text = devToken,
              child: const Text('Isi kode (dev)'),
            ),
          ),
        const SizedBox(height: 16),
        _error(context, state),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: state.isBusy ? null : () => cubit.confirm(_token.text),
          child: state.isBusy ? const _Spinner() : const Text('Simpan'),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              // Permintaan baru membatalkan kode lama. Ikut dihitung kuota
              // 3 permintaan per jam.
              onPressed: state.isBusy ? null : () => cubit.request(state.newValue ?? ''),
              child: const Text('Kirim ulang kode'),
            ),
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: state.isBusy
                  ? null
                  : () {
                      _value.text = state.newValue ?? '';
                      cubit.restart();
                    },
              child: Text('Ubah $label baru'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _completed(BuildContext context, ContactChangeState state) {
    final isEmail = state.type == ContactType.email;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.check_circle, size: 48, color: XpColors.success),
        const SizedBox(height: 12),
        Text('${state.type.label} berhasil diganti',
            textAlign: TextAlign.center, style: XpText.titleL(context)),
        const SizedBox(height: 4),
        Text(
          isEmail
              // Email adalah identitas login.
              ? 'Mulai sekarang masuk dengan ${state.newValue}.'
              : 'Nomor HP akunmu sekarang ${state.newValue}.',
          textAlign: TextAlign.center,
          style: XpText.bodyM(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Selesai'),
        ),
      ],
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
}

/// Baris kontak read-only dengan tombol "Ubah" → lembar ganti kontak. Dipakai layar
/// Keamanan Akun dan Ubah Profil; butuh `AuthCubit` di atasnya.
class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.icon,
    required this.type,
    required this.value,
    required this.user,
  });

  final IconData icon;
  final ContactType type;
  final String? value;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final auth = AuthCubit.get(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(children: [
        Icon(icon, size: 20, color: XpColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(type.label, style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
            Text(
              (value ?? '').isEmpty ? '-' : value!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: XpText.bodyM(context),
            ),
          ]),
        ),
        TextButton(
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: user == null
              ? null
              : () async {
                  final done = await showContactChangeSheet(context,
                      type: type, currentValue: value);
                  if (done == true) await auth.restoreSession();
                },
          child: const Text('Ubah'),
        ),
      ]),
    );
  }
}
