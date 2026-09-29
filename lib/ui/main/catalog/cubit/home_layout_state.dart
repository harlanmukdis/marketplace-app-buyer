part of 'home_layout_cubit.dart';

@freezed
sealed class HomeLayoutState with _$HomeLayoutState {
  const factory HomeLayoutState.loading() = HomeLayoutLoading;

  const factory HomeLayoutState.loaded({required List<HomeSectionModel> sections}) =
      HomeLayoutLoaded;

  /// Tidak ada yang ditampilkan: `[]`, semua section kosong, atau gagal.
  const factory HomeLayoutState.hidden() = HomeLayoutHidden;
}
