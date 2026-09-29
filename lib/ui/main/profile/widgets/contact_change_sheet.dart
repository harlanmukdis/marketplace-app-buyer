import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/config/network/mock/pending_api_mock.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/cubit/contact_change_cubit.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/shell/simulated_badge.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

/// Lembar ganti email / nomor HP (docs/22 #10), dipakai layar Keamanan Akun
/// dan Ubah Profil.
///
/// Mengembalikan `true` kalau penggantian selesai — pemanggil memuat ulang
/// `GET /me`. Selama backend belum punya endpoint-nya, perubahan itu
/// **simulasi**: `/me` tidak ikut berubah, dan lembar ini mengatakannya.
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
  final _otp = TextEditingController();

  @override
  void dispose() {
    _value.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactChangeCubit, ContactChangeState>(
      // Kode OTP dikosongkan tiap berganti tahap: kode tahap satu tidak
      // berlaku untuk tahap dua.
      listenWhen: (a, b) => a.challenge?.stage != b.challenge?.stage,
      listener: (_, __) => _otp.clear(),
      builder: (context, state) {
        final cubit = ContactChangeCubit.get(context);
        final Widget body;
        if (state.unavailable) {
          body = XpEmptyState(
            icon: Icons.construction_outlined,
            title: 'Ganti ${state.type.label.toLowerCase()} belum tersedia',
            message: 'Fitur ini sedang disiapkan. Hubungi Xpedia 911 kalau perlu '
                'mengganti kontak akunmu sekarang.',
          );
        } else if (state.isCompleted) {
          body = _completed(context, state);
        } else if (state.challenge != null) {
          body = _otpStep(context, state, cubit);
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
                Row(
                  children: [
                    Expanded(
                      child: Text('Ganti ${state.type.label}', style: XpText.headingM(context)),
                    ),
                    SimulatedBadge(meta: state.meta),
                  ],
                ),
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
        accountErrorText(context, state.error!),
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
          onSubmitted: (_) => cubit.start(_value.text),
        ),
        const SizedBox(height: 12),
        Text(
          'Demi keamananmu, kami kirim kode ke ${state.type.label.toLowerCase()} lama '
          'dulu, lalu ke ${state.type.label.toLowerCase()} baru. Perubahan baru '
          'tersimpan setelah keduanya terverifikasi.',
          style: XpText.bodyS(context).copyWith(color: XpColors.textSecondary),
        ),
        const SizedBox(height: 16),
        _error(context, state),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: state.isBusy ? null : () => cubit.start(_value.text),
          child: state.isBusy ? const _Spinner() : const Text('Kirim Kode'),
        ),
      ],
    );
  }

  Widget _otpStep(BuildContext context, ContactChangeState state, ContactChangeCubit cubit) {
    final challenge = state.challenge!;
    final isFirst = challenge.stageValue == ContactChangeStage.currentContact;
    final label = state.type.label.toLowerCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(isFirst ? 'Langkah 1 dari 2 · $label lama' : 'Langkah 2 dari 2 · $label baru',
            style: XpText.labelM(context).copyWith(color: XpColors.primary)),
        const SizedBox(height: 4),
        Text('Masukkan kode 6 angka yang dikirim ke ${challenge.otpSentTo ?? '$label kamu'}.',
            style: XpText.bodyM(context)),
        if (challenge.expiresAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Berlaku sampai ${formatServerDateTime(challenge.expiresAt)}',
                style: XpText.caption(context).copyWith(color: XpColors.textTertiary)),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _otp,
          enabled: !state.isBusy,
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: XpText.headingL(context).copyWith(letterSpacing: 8),
          decoration: const InputDecoration(hintText: '••••••', counterText: ''),
          onSubmitted: (_) => cubit.verify(_otp.text),
        ),
        // Petunjuk kode hanya dari respons mock (`meta.mock_otp`), dan hanya
        // di debug — server sungguhan mengirim kodenya ke kontak user.
        if (kDebugMode && isMockMeta(state.meta) && state.meta['mock_otp'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Simulasi: kode OTP-nya ${state.meta['mock_otp']}',
                textAlign: TextAlign.center,
                style: XpText.caption(context).copyWith(color: const Color(0xff8C5002))),
          ),
        const SizedBox(height: 16),
        _error(context, state),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: state.isBusy ? null : () => cubit.verify(_otp.text),
          child: state.isBusy ? const _Spinner() : const Text('Verifikasi'),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              // Permintaan baru untuk jenis yang sama menggantikan yang lama,
              // jadi "kirim ulang" = mulai lagi dari kontak lama.
              onPressed: state.isBusy ? null : () => cubit.start(state.newValue ?? ''),
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
    final simulated = isMockMeta(state.meta);
    final label = state.type.label.toLowerCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.check_circle, size: 48, color: XpColors.success),
        const SizedBox(height: 12),
        Text(
          simulated ? 'Verifikasi selesai (simulasi)' : '${state.type.label} berhasil diganti',
          textAlign: TextAlign.center,
          style: XpText.titleL(context),
        ),
        const SizedBox(height: 4),
        Text(
          simulated
              ? 'Kedua kode berhasil diverifikasi, tapi ini masih simulasi — backend '
                  'belum bisa menyimpan $label baru, jadi $label di akunmu belum berubah.'
              : '$label akunmu sekarang ${state.challenge?.newValue ?? state.newValue}.',
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

/// Baris kontak read-only dengan tombol "Ubah" → lembar OTP. Dipakai layar
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
                  // Server sungguhan akan mengubah `/me`; dengan mock tidak,
                  // tapi membaca ulang tetap benar untuk keduanya.
                  if (done == true) await auth.restoreSession();
                },
          child: const Text('Ubah'),
        ),
      ]),
    );
  }
}
