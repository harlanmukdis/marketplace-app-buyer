import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'reward_cubit.freezed.dart';
part 'reward_state.dart';

/// Poin, koin, tingkat loyalitas, dan riwayat cashback.
///
/// ⚠️ **Tidak ada aksi "tukar poin" di sini**, dan itu disengaja: endpointnya
/// tidak memberi imbalan apa pun sementara nominal negatif justru mencetak
/// poin — lihat `RewardService`. Layar ini murni menampilkan.
class RewardCubit extends Cubit<RewardState> {
  RewardCubit()
      : _repository = injector<RewardRepository>(),
        super(const RewardState.loading());

  static RewardCubit get(BuildContext context) => BlocProvider.of(context);

  final RewardRepository _repository;

  Future<void> load() async {
    emit(const RewardState.loading());
    final result = await _repository.fetchOverview();
    if (isClosed) return;

    switch (result) {
      case DataSuccess(:final data):
        emit(RewardState.ready(overview: data));
      case DataFailed(:final error):
        emit(RewardState.error(error));
      case DataEmpty():
      case DataLoading():
        break;
    }
  }

  Future<void> refresh() => load();
}
