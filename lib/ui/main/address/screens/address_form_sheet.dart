import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/domain/model/address/address_model.dart';
import 'package:marketplace_app_member/core/domain/model/location/location_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/ui/main/address/cubit/address_cubit.dart';
import 'package:marketplace_app_member/ui/main/address/screens/location_picker.dart';
import 'package:marketplace_app_member/util/error_message.dart';

/// Formulir alamat, dibuka sebagai bottom sheet.
///
/// Seluruh field wajib divalidasi di sini **karena server tidak
/// memvalidasinya** — `POST /me/addresses` dengan field kosong dibalas `201`
/// dan menyimpan alamat yang tidak bisa dikirimi paket.
///
/// Kota dan provinsi bisa **dipilih dari master lokasi**
/// (`GET /locations/*`) lewat tombol di ujung kolomnya — pilihan kota ikut
/// mengirim `city_id` dan mengisi provinsinya. Kolomnya tetap teks bebas:
/// master di seed baru berisi 15 kota, jadi mewajibkan pilihan akan memblokir
/// user di kota lain. Mengetik ulang nama kota melepas `city_id`-nya.
///
/// Mengembalikan `true` lewat `Navigator.pop` kalau tersimpan.
class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key, this.existing});

  /// Alamat yang sedang diubah; `null` berarti menambah baru.
  final AddressModel? existing;

  static Future<bool?> show(BuildContext context, {AddressModel? existing}) {
    final cubit = AddressCubit.get(context)..clearActionError();
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: XpColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(XpRadius.xxl)),
      ),
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

  /// Kota master yang terpilih, dan nama yang ditulisnya ke kolom kota.
  /// Kalau teks kolom berubah dari nama itu, tautan master dilepas.
  int? _cityId;
  String? _cityIdName;

  /// Provinsi master terpilih — dipakai menyaring daftar kota.
  int? _provinceId;
  String? _provinceIdName;

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
    _cityId = existing?.cityId;
    _cityIdName = existing?.cityId == null ? null : existing?.city;
    _controllers['city']!.addListener(_onCityEdited);
    _controllers['province']!.addListener(_onProvinceEdited);
  }

  void _onCityEdited() {
    if (_cityId != null && _controllers['city']!.text.trim() != _cityIdName) {
      _cityId = null;
      _cityIdName = null;
    }
  }

  void _onProvinceEdited() {
    if (_provinceId != null && _controllers['province']!.text.trim() != _provinceIdName) {
      _provinceId = null;
      _provinceIdName = null;
    }
  }

  void _setText(String key, String value) {
    _controllers[key]!.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _pickProvince(BuildContext context) async {
    final cubit = LocationPickerCubit.get(context)..loadProvinces();
    final picked = await showLocationPicker(
      context,
      title: 'Pilih Provinsi',
      optionsOf: (s) => s.provinces?.map((p) => (id: p.id, name: p.name)).toList(),
      loadingOf: (s) => s.loadingProvinces,
      onRetry: cubit.loadProvinces,
    );
    if (picked == null || !mounted) return;
    final changed = picked.id != _provinceId;
    _provinceIdName = picked.name;
    _setText('province', picked.name);
    _provinceId = picked.id;
    // Kota dari master provinsi lain tidak lagi cocok — kosongkan supaya
    // alamat tidak tersimpan "Bandung, Jawa Timur".
    if (changed && _cityId != null) {
      final city = _cityFor(cubit.state, _cityId!);
      if (city != null && city.provinceId != picked.id) {
        _cityId = null;
        _cityIdName = null;
        _setText('city', '');
      }
    }
  }

  Future<void> _pickCity(BuildContext context) async {
    final cubit = LocationPickerCubit.get(context)
      ..loadProvinces()
      ..loadCities(_provinceId);
    final key = _provinceId ?? 0;
    final picked = await showLocationPicker(
      context,
      title: 'Pilih Kota/Kabupaten',
      optionsOf: (s) => s.cities[key]?.map((c) => (id: c.id, name: c.name)).toList(),
      loadingOf: (s) => s.loadingCities,
      onRetry: () => cubit.loadCities(_provinceId),
    );
    if (picked == null || !mounted) return;
    _cityIdName = picked.name;
    _setText('city', picked.name);
    _cityId = picked.id;
    // Provinsi diturunkan dari kota — urutan kolom memang kota dulu.
    final city = _cityFor(cubit.state, picked.id);
    if (city != null) {
      await cubit.loadProvinces();
      final province = cubit.provinceById(city.provinceId);
      if (province != null && mounted) {
        _provinceIdName = province.name;
        _setText('province', province.name);
        _provinceId = province.id;
      }
    }
  }

  static CityModel? _cityFor(LocationPickerState state, int id) {
    for (final list in state.cities.values) {
      for (final c in list) {
        if (c.id == id) return c;
      }
    }
    return null;
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
        cityId: _cityId,
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final saved =
        await AddressCubit.get(context).save(_draft, id: widget.existing?.id);
    if (saved && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationPickerCubit(),
      child: Builder(builder: _buildForm),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: XpColors.primarySubtle,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add_location_alt_outlined,
                        size: 20, color: XpColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.existing == null ? 'Tambah Alamat' : 'Ubah Alamat',
                      style: XpText.headingM(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final entry in _fields.entries) ...[
                TextFormField(
                  controller: _controllers[entry.key],
                  decoration: InputDecoration(
                    labelText: entry.value,
                    suffixIcon: switch (entry.key) {
                      'city' => IconButton(
                          tooltip: 'Pilih kota dari daftar',
                          icon: const Icon(Icons.list_alt_outlined),
                          onPressed: () => _pickCity(context),
                        ),
                      'province' => IconButton(
                          tooltip: 'Pilih provinsi dari daftar',
                          icon: const Icon(Icons.list_alt_outlined),
                          onPressed: () => _pickProvince(context),
                        ),
                      _ => null,
                    },
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
                const SizedBox(height: 12),
              ],
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _isPrimary,
                onChanged: (value) =>
                    setState(() => _isPrimary = value ?? false),
                title:
                    Text('Jadikan alamat utama', style: XpText.bodyM(context)),
              ),
              const SizedBox(height: 8),
              BlocBuilder<AddressCubit, AddressState>(
                builder: (context, state) {
                  final saving = state is AddressReady && state.isSaving;
                  final error =
                      state is AddressReady ? state.actionError : null;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ditampilkan di dalam lembar ini: snackbar milik layar
                      // di belakangnya tertutup oleh lembar modal.
                      if (error != null) ...[
                        Text(
                          errorMessageFor(context, error),
                          style: XpText.bodyS(context)
                              .copyWith(color: XpColors.danger),
                        ),
                        const SizedBox(height: 8),
                      ],
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: saving ? null : _submit,
                          child: Text(saving ? 'Menyimpan…' : 'Simpan'),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
