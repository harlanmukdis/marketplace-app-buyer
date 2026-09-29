import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/support_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/support_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'support_list_cubit.freezed.dart';
part 'support_list_state.dart';

/// Daftar tiket Xpedia 911 milik user.
///
/// ⚠️ Bentuknya mengikuti `/orders`: **20 per halaman, tanpa `meta`**. Adanya
/// halaman berikutnya disimpulkan dari halaman terakhir yang terisi penuh
/// ([SupportService.serverPageSize]) — satu permintaan sia-sia kalau jumlah
/// tiket kebetulan kelipatan 20, tapi tidak ada tiket yang tersembunyi.
class SupportListCubit extends Cubit<SupportListState> {
  SupportListCubit()
      : _repository = injector<SupportRepository>(),
        super(const SupportListState.loading());

  static SupportListCubit get(BuildContext context) => BlocProvider.of(context);

  final SupportRepository _repository;

  Future<void> load() async {
    emit(const SupportListState.loading());
    final result = await _repository.fetchTickets(page: 1);
    if (isClosed) return;
    emit(switch (result) {
      DataSuccess(:final data) => SupportListState.loaded(
          tickets: data,
          hasMore: data.length >= SupportService.serverPageSize,
        ),
      DataFailed(:final error) => SupportListState.error(error),
      _ => const SupportListState.loaded(tickets: []),
    });
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! SupportListLoaded || !current.hasMore || current.isLoadingMore) return;
    emit(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final nextPage = current.page + 1;
    final result = await _repository.fetchTickets(page: nextPage);
    if (isClosed) return;

    emit(switch (result) {
      DataSuccess(:final data) => current.copyWith(
          // Id yang sudah ada dibuang: tiket baru yang lahir di antara dua
          // permintaan menggeser OFFSET, sehingga baris terakhir halaman
          // sebelumnya muncul lagi di halaman ini.
          tickets: [
            ...current.tickets,
            ...data.where((t) => !current.tickets.any((c) => c.id == t.id)),
          ],
          page: nextPage,
          hasMore: data.length >= SupportService.serverPageSize,
          isLoadingMore: false,
        ),
      DataFailed(:final error) =>
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      _ => current.copyWith(hasMore: false, isLoadingMore: false),
    });
  }
}
