import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/store/store_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/wishlist/cubit/wishlist_cubit.dart';

/// Tiga cubit yang dipakai **lintas layar** dan karena itu disediakan di atas
/// router, bukan per layar seperti cubit lain di repo ini.
///
/// Alasannya satu per satu:
///
/// * [StoreDirectoryCubit] — `GET /products` tidak membawa nama toko, padahal
///   kartu produk desain Xpedia wajib menampilkannya bersama status penjual.
///   Menembak `GET /stores/{id}` per kartu adalah N+1; di sini satu request
///   per **toko**, dan hasilnya dipakai ulang di beranda, pencarian,
///   wishlist, dan halaman toko.
/// * [CartBadgeCubit] — lencana ikon keranjang di app bar setiap layar.
/// * [WishlistCubit] — hati di kartu produk harus sama di beranda, pencarian,
///   dan detail. Dulu tiap layar memegang instance sendiri sehingga hati
///   yang ditekan di detail tidak terlihat di beranda sebelum dimuat ulang.
///
/// Layar yang di-push router berada di luar pohon `HomeLayout`, jadi
/// satu-satunya tempat yang menaungi keduanya adalah `MaterialApp.builder`.
class AppScope extends StatelessWidget {
  const AppScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StoreDirectoryCubit()),
        BlocProvider(create: (_) => CartBadgeCubit()),
        BlocProvider(create: (_) => WishlistCubit()),
      ],
      child: child,
    );
  }
}

/// Cache profil toko per id, diisi sesuai kebutuhan kartu yang tampil.
///
/// State-nya peta `storeId → StoreModel` apa adanya; toko yang gagal dimuat
/// tidak dimasukkan dan kartu cukup tidak menampilkan baris toko.
class StoreDirectoryCubit extends Cubit<Map<int, StoreModel>> {
  StoreDirectoryCubit()
      : _repository = injector<StoreRepository>(),
        super(const {});

  final StoreRepository _repository;
  final Set<int> _inFlight = {};

  /// Memastikan toko-toko ini dimuat. Aman dipanggil berulang untuk id yang
  /// sama — yang sudah ada atau sedang dimuat dilewati.
  Future<void> ensure(Iterable<int> storeIds) async {
    final missing = storeIds
        .where((id) => id > 0 && !state.containsKey(id) && !_inFlight.contains(id))
        .toSet();
    if (missing.isEmpty) return;
    _inFlight.addAll(missing);
    final results = await Future.wait(missing.map(_repository.fetchStore));
    _inFlight.removeAll(missing);
    if (isClosed) return;
    final next = {...state};
    for (final result in results) {
      if (result case DataSuccess(:final data)) next[data.id] = data;
    }
    emit(next);
  }

  /// Memperbarui satu toko (mis. sesudah mengikuti/berhenti mengikuti).
  void put(StoreModel store) => emit({...state, store.id: store});
}

/// Jumlah baris keranjang untuk lencana di app bar.
///
/// Menghitung **baris**, bukan unit — sama dengan `item_count` server, dan
/// yang tampil di lencana Stitch ("3" untuk tiga produk).
class CartBadgeCubit extends Cubit<int> {
  CartBadgeCubit()
      : _repository = injector<CartRepository>(),
        super(0);

  final CartRepository _repository;

  Future<void> refresh() async {
    final result = await _repository.fetchCart();
    if (isClosed) return;
    if (result case DataSuccess(:final data)) emit(data.totalLines);
  }

  /// Dipakai layar yang sudah memegang snapshot keranjang, supaya lencana
  /// ikut benar tanpa request tambahan.
  void set(int lines) => emit(lines);
}
