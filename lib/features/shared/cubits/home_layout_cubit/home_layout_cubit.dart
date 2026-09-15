import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/local_network.dart';
import 'package:marketplace_app_member/ui/main/catalog/screens/catalog_home_screen.dart';
import 'package:marketplace_app_member/ui/main/cart/screens/cart_screen.dart';
import 'package:marketplace_app_member/ui/main/wishlist/screens/wishlist_screen.dart';
import '../../../profile/presentaion/views/profile_view.dart';
import '../../../trending/trending_view.dart';

part 'home_layout_state.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutState> {
  HomeLayoutCubit() : super(HomeViewInitial());

  static HomeLayoutCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNav());
  }

  List<Widget> screens = [
    // Home versi API. `HomePage` milik UI kit sengaja tidak dipakai lagi —
    // isinya tab t-shirt/blazer/sepatu dari 11 ProductModel yang di-hardcode
    // di HomePageCubit, tanpa menyentuh backend.
    const CatalogHomeScreen(),
    const TrendingView(),
    // Wishlist versi API. `FavoritesView` kit tidak dipakai: isinya daftar
    // produk hardcoded, sementara wishlist di sini tersimpan di server.
    const WishlistScreen(),
    // Keranjang versi API. `MyCart` milik kit tidak dipakai: isinya daftar
    // hardcoded bertotal dolar, sedangkan keranjang di sini dikelompokkan per
    // toko dan tiap baris merujuk `product_variant_id`.
    const CartScreen(),
    const ProfileView(),
  ];

  Locale locale = const Locale('ar');

  Future<String> getCachedSavedLanguage() async {
    final String? cachedLanguageCode = await CachedHelper.getData('LOCALE');
    if (cachedLanguageCode != null) {
      debugPrint('cachedLanguageCode');
      return cachedLanguageCode;
    } else {
      debugPrint('cachedLanguageCodeEn');
      return 'en';
    }
  }

  Future<void> getSavedLanguage() async {
    final String cachedLanguageCode = await getCachedSavedLanguage();
    locale = Locale(cachedLanguageCode);
    emit(ChangeLocalState());
  }

  Future<void> cachedLanguageCode(String languageCode) async {
    CachedHelper.saveData('LOCALE', languageCode);
    locale = Locale(languageCode);
    emit(ChangeLocalState());
  }
}
