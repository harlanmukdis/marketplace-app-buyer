part of 'support_list_cubit.dart';

@freezed
sealed class SupportListState with _$SupportListState {
  const factory SupportListState.loading() = SupportListLoading;

  /// [tickets] boleh kosong — itu keadaan normal bagi kebanyakan pembeli,
  /// dan layar menampilkan empty state dengan tombol buat tiket.
  const factory SupportListState.loaded({
    required List<SupportTicketModel> tickets,
    @Default(1) int page,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    DataError? loadMoreError,
  }) = SupportListLoaded;

  const factory SupportListState.error(DataError error) = SupportListError;
}
