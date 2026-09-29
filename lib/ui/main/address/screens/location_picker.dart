import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/core/design/xp_widgets.dart';
import 'package:marketplace_app_member/core/domain/model/location/location_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/location_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/util/error_message.dart';

part 'location_picker.freezed.dart';

/// Master provinsi & kota untuk formulir alamat (`GET /locations/*`, publik).
///
/// ⚠️ **Seed-nya tipis: 11 provinsi, 15 kota.** Karena itu pemilih ini hanya
/// **pengisi cepat** untuk kolom teks kota/provinsi, bukan pengganti: kota
/// yang tidak terdaftar tetap bisa diketik bebas, dan alamatnya tersimpan
/// tanpa `city_id`. Dropdown murni akan memblokir user di kota yang belum
/// terdaftar.
///
/// Repository diambil **saat pertama dipakai**, bukan di konstruktor:
/// formulir alamat dibuka di banyak alur, dan membuka lembarnya tidak boleh
/// menembak master lokasi kalau user tidak pernah menyentuh pemilihnya.
class LocationPickerCubit extends Cubit<LocationPickerState> {
  LocationPickerCubit() : super(const LocationPickerState());

  static LocationPickerCubit get(BuildContext context) => BlocProvider.of(context);

  LocationRepository get _repository => injector<LocationRepository>();

  Future<void> loadProvinces() async {
    if (state.provinces != null || state.loadingProvinces) return;
    emit(state.copyWith(loadingProvinces: true, error: null));
    final result = await _repository.fetchProvinces();
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => state.copyWith(provinces: data, loadingProvinces: false),
      DataEmpty() => state.copyWith(provinces: const [], loadingProvinces: false),
      DataFailed(:final error) => state.copyWith(loadingProvinces: false, error: error),
      DataLoading() => state,
    });
  }

  /// Tanpa [provinceId]: seluruh kota aktif. Kuncinya `0` untuk "semua",
  /// karena Map freezed tidak menerima kunci `null` dengan rapi.
  Future<void> loadCities(int? provinceId) async {
    final key = provinceId ?? 0;
    if (state.cities.containsKey(key) || state.loadingCities) return;
    emit(state.copyWith(loadingCities: true, error: null));
    final result = await _repository.fetchCities(provinceId: provinceId);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) =>
        state.copyWith(cities: {...state.cities, key: data}, loadingCities: false),
      DataEmpty() =>
        state.copyWith(cities: {...state.cities, key: const []}, loadingCities: false),
      DataFailed(:final error) => state.copyWith(loadingCities: false, error: error),
      DataLoading() => state,
    });
  }

  ProvinceModel? provinceById(int id) {
    for (final p in state.provinces ?? const <ProvinceModel>[]) {
      if (p.id == id) return p;
    }
    return null;
  }
}

@freezed
abstract class LocationPickerState with _$LocationPickerState {
  const factory LocationPickerState({
    /// `null` = belum pernah dimuat.
    List<ProvinceModel>? provinces,

    /// Kota per `province_id`; kunci `0` = seluruh kota.
    @Default(<int, List<CityModel>>{}) Map<int, List<CityModel>> cities,
    @Default(false) bool loadingProvinces,
    @Default(false) bool loadingCities,
    DataError? error,
  }) = _LocationPickerState;
}

/// Satu pilihan di lembar pemilih.
typedef LocationOption = ({int id, String name});

/// Lembar pemilih provinsi/kota dengan kolom saring.
///
/// Mengembalikan pilihan lewat `Navigator.pop`, atau `null` kalau ditutup.
Future<LocationOption?> showLocationPicker(
  BuildContext context, {
  required String title,
  required List<LocationOption>? Function(LocationPickerState state) optionsOf,
  required bool Function(LocationPickerState state) loadingOf,
  required VoidCallback onRetry,
}) {
  final cubit = LocationPickerCubit.get(context);
  return showModalBottomSheet<LocationOption>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: XpColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(XpRadius.xxl)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _PickerSheet(
        title: title,
        optionsOf: optionsOf,
        loadingOf: loadingOf,
        onRetry: onRetry,
      ),
    ),
  );
}

class _PickerSheet extends StatefulWidget {
  const _PickerSheet({
    required this.title,
    required this.optionsOf,
    required this.loadingOf,
    required this.onRetry,
  });

  final String title;
  final List<LocationOption>? Function(LocationPickerState state) optionsOf;
  final bool Function(LocationPickerState state) loadingOf;
  final VoidCallback onRetry;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(widget.title, style: XpText.headingM(context)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: false,
                onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                decoration: const InputDecoration(
                  hintText: 'Cari…',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<LocationPickerCubit, LocationPickerState>(
                builder: (context, state) {
                  final options = widget.optionsOf(state);
                  if (options == null || widget.loadingOf(state)) {
                    if (state.error != null && !widget.loadingOf(state)) {
                      return XpEmptyState(
                        icon: Icons.wifi_off_rounded,
                        title: 'Daftar belum bisa dimuat',
                        message: errorMessageFor(context, state.error!),
                        actionLabel: 'Coba Lagi',
                        onAction: widget.onRetry,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
                  final shown = _query.isEmpty
                      ? options
                      : options.where((o) => o.name.toLowerCase().contains(_query)).toList();
                  return ListView(
                    children: [
                      for (final option in shown)
                        ListTile(
                          minTileHeight: 48,
                          title: Text(option.name, style: XpText.bodyM(context)),
                          onTap: () => Navigator.of(context).pop(option),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Tidak ada di daftar? Tutup lembar ini dan ketik langsung di kolomnya.',
                          style: XpText.bodyS(context).copyWith(color: XpColors.textTertiary),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
