import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/home/home_layout_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/home_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'home_layout_cubit.freezed.dart';
part 'home_layout_state.dart';

/// Section home CMS (`GET /home/layout`) di atas "Rekomendasi Spesial".
///
/// **Kegagalan dan `[]` sama-sama diam** ([HomeLayoutState.hidden]): layout
/// CMS adalah hiasan di atas grid produk yang sudah berdiri sendiri. Di dev
/// endpoint-nya memang selalu `[]` (tabel CMS belum di-seed), dan spanduk
/// error di puncak beranda karena hiasan yang tidak ada jauh lebih buruk
/// daripada beranda tanpa banner.
class HomeLayoutCubit extends Cubit<HomeLayoutState> {
  HomeLayoutCubit()
      : _repository = injector<HomeRepository>(),
        super(const HomeLayoutState.loading());

  static HomeLayoutCubit get(BuildContext context) => BlocProvider.of(context);

  final HomeRepository _repository;

  Future<void> load() async {
    final result = await _repository.fetchLayout();
    if (isClosed) return;
    switch (result) {
      case DataSuccess(:final data):
        // Jenis yang belum dikenal dan section tanpa isi dilewati — judul
        // tanpa konten hanya membingungkan.
        final shown =
            data.where((s) => s.type != HomeSectionType.unknown && s.hasContent).toList();
        emit(shown.isEmpty
            ? const HomeLayoutState.hidden()
            : HomeLayoutState.loaded(sections: shown));
      case DataEmpty():
      case DataFailed():
        emit(const HomeLayoutState.hidden());
      case DataLoading():
        break;
    }
  }
}
