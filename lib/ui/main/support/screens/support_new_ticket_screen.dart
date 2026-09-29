import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';
import 'package:marketplace_app_member/ui/main/shell/xp_app_bars.dart';
import 'package:marketplace_app_member/ui/main/support/cubit/support_new_ticket_cubit.dart';

/// Formulir tiket Xpedia 911 baru.
///
/// [orderId] hanya datang dari rute — dibuka dari halaman pesanan milik user
/// sendiri. Formulir **tidak** menyediakan kolom nomor pesanan: server tidak
/// memeriksa kepemilikannya dan meledak jadi 500 untuk id yang tidak ada.
/// Lampiran juga tidak disediakan (belum ada alur unggah di app).
class SupportNewTicketScreen extends StatelessWidget {
  const SupportNewTicketScreen({super.key, this.orderId});

  final int? orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportNewTicketCubit(relatedOrderId: orderId),
      child: _NewTicketBody(orderId: orderId),
    );
  }
}

class _NewTicketBody extends StatefulWidget {
  const _NewTicketBody({this.orderId});

  final int? orderId;

  @override
  State<_NewTicketBody> createState() => _NewTicketBodyState();
}

class _NewTicketBodyState extends State<_NewTicketBody> {
  final _subject = TextEditingController();
  final _description = TextEditingController();

  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    SupportNewTicketCubit.get(context)
        .submit(subject: _subject.text, description: _description.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XpColors.canvas,
      appBar: const XpStackAppBar(title: 'Buat Tiket Xpedia 911'),
      body: BlocConsumer<SupportNewTicketCubit, SupportNewTicketState>(
        listenWhen: (previous, current) =>
            previous.created == null && current.created != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text('Tiket terkirim. Tim Xpedia 911 akan membalas di sini.')));
          // Diganti, bukan ditumpuk: kembali dari halaman tiket tidak boleh
          // membuka formulir yang sudah terkirim.
          context.pushReplacement(AppRoutes.supportTicketPath(state.created!.id));
        },
        builder: (context, state) {
          final cubit = SupportNewTicketCubit.get(context);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (widget.orderId != null) ...[
                      XpBanner(
                        icon: Icons.inventory_2_outlined,
                        title: 'Terkait pesanan #${widget.orderId}',
                        message: 'Tim Xpedia 911 akan melihat pesanan ini '
                            'bersama tiketmu.',
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text('Kategori', style: XpText.titleM(context)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final category in SupportCategory.values)
                          ChoiceChip(
                            label: Text(category.label),
                            selected: state.category == category,
                            onSelected: state.isSubmitting
                                ? null
                                : (_) => cubit.selectCategory(category),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _subject,
                      enabled: !state.isSubmitting,
                      maxLength: SupportNewTicketCubit.maxSubjectLength,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Subjek',
                        hintText: 'Mis. Paket belum sampai',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _description,
                      enabled: !state.isSubmitting,
                      minLines: 5,
                      maxLines: 10,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        hintText: 'Ceritakan apa yang terjadi, kapan, dan apa '
                            'yang sudah kamu coba.',
                        alignLabelWithHint: true,
                      ),
                    ),
                    if (state.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        accountErrorText(context, state.error!),
                        style: XpText.bodyS(context).copyWith(color: XpColors.danger),
                      ),
                    ],
                  ],
                ),
              ),
              XpBottomBar(
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: state.isSubmitting || state.created != null ? null : _submit,
                    child: Text(state.isSubmitting ? 'Mengirim…' : 'Kirim Tiket'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
