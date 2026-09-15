import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/function/components.dart';
import 'package:marketplace_app_member/core/utils/app_styles.dart';
import 'package:marketplace_app_member/core/utils/constant.dart';
import 'package:marketplace_app_member/core/utils/extensions.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';

/// Formulir alamat, dibuka sebagai bottom sheet.
///
/// Seluruh field wajib divalidasi di sini **karena server tidak
/// memvalidasinya** — `POST /me/addresses` dengan field kosong dibalas `201`
/// dan menyimpan alamat yang tidak bisa dikirimi paket.
///
/// Mengembalikan `true` lewat `Navigator.pop` kalau tersimpan.
class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key, this.existing});

  /// Alamat yang sedang diubah; `null` berarti menambah baru.
  final AddressModel? existing;

  static Future<bool?> show(BuildContext context, {AddressModel? existing}) {
    final cubit = AddressCubit.get(context);
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddressFormSheet(existing: existing),
      ),
    );
  }

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late bool _isPrimary;

  static const _fields = <String, String>{
    'label': 'Label (mis. Rumah, Kantor)',
    'recipient_name': 'Nama penerima',
    'phone': 'Nomor telepon',
    'full_address': 'Alamat lengkap',
    'city': 'Kota/Kabupaten',
    'province': 'Provinsi',
    'postal_code': 'Kode pos',
  };

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _controllers = {
      'label': TextEditingController(text: existing?.label ?? 'Rumah'),
      'recipient_name':
          TextEditingController(text: existing?.recipientName ?? ''),
      'phone': TextEditingController(text: existing?.phone ?? ''),
      'full_address': TextEditingController(text: existing?.fullAddress ?? ''),
      'city': TextEditingController(text: existing?.city ?? ''),
      'province': TextEditingController(text: existing?.province ?? ''),
      'postal_code': TextEditingController(text: existing?.postalCode ?? ''),
    };
    _isPrimary = existing?.isPrimary ?? false;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  AddressDraft get _draft => AddressDraft(
        label: _controllers['label']!.text.trim(),
        recipientName: _controllers['recipient_name']!.text.trim(),
        phone: _controllers['phone']!.text.trim(),
        fullAddress: _controllers['full_address']!.text.trim(),
        city: _controllers['city']!.text.trim(),
        province: _controllers['province']!.text.trim(),
        postalCode: _controllers['postal_code']!.text.trim(),
        isPrimary: _isPrimary,
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final saved = await AddressCubit.get(context)
        .save(_draft, id: widget.existing?.id);
    if (saved && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final dark = isAppDarkMode();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.existing == null ? 'Tambah Alamat' : 'Ubah Alamat',
                style: AppStyles.styleSemiBold18(context).copyWith(
                  color: dark ? kDarkSecondColor : kLightSecondColor,
                ),
              ),
              16.sbh,
              for (final entry in _fields.entries) ...[
                TextFormField(
                  controller: _controllers[entry.key],
                  decoration: InputDecoration(
                    labelText: entry.value,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: entry.key == 'full_address' ? 2 : 1,
                  keyboardType: switch (entry.key) {
                    'phone' => TextInputType.phone,
                    'postal_code' => TextInputType.number,
                    _ => TextInputType.text,
                  },
                  // `label` boleh kosong — server mengisinya 'Rumah'. Sisanya
                  // wajib, karena server menerima apa pun dan alamat tak
                  // lengkap baru ketahuan saat paket tidak bisa dikirim.
                  validator: entry.key == 'label'
                      ? null
                      : (value) => (value ?? '').trim().isEmpty
                          ? '${entry.value} wajib diisi'
                          : null,
                ),
                12.sbh,
              ],
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _isPrimary,
                onChanged: (value) =>
                    setState(() => _isPrimary = value ?? false),
                title: const Text('Jadikan alamat utama'),
              ),
              16.sbh,
              BlocBuilder<AddressCubit, AddressState>(
                builder: (context, state) {
                  final saving = state is AddressReady && state.isSaving;
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: saving ? null : _submit,
                      child: Text(saving ? 'Menyimpan…' : 'Simpan'),
                    ),
                  );
                },
              ),
              8.sbh,
            ],
          ),
        ),
      ),
    );
  }
}
