import 'package:marketplace_app_member/core/data/datasources/remote/service/media_service.dart';
import 'package:marketplace_app_member/core/data/repositories/media_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/media_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/home_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/live_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/location_service.dart';
import 'package:marketplace_app_member/core/data/repositories/home_repository_impl.dart';
import 'package:marketplace_app_member/core/data/repositories/live_repository_impl.dart';
import 'package:marketplace_app_member/core/data/repositories/location_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/home_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/live_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/location_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/voucher_service.dart';
import 'package:marketplace_app_member/core/data/repositories/voucher_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/voucher_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/account_service.dart';
import 'package:marketplace_app_member/core/data/repositories/account_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/store_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/support_service.dart';
import 'package:marketplace_app_member/core/data/repositories/store_repository_impl.dart';
import 'package:marketplace_app_member/core/data/repositories/support_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/store_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/support_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/chat_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data/repositories/chat_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/chat_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/notification_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data/repositories/notification_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/notification_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/payment_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/review_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/reward_service.dart';
import 'package:marketplace_app_member/core/data/repositories/reward_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/reward_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wishlist_service.dart';
import 'package:marketplace_app_member/core/data/repositories/wallet_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/core/data/repositories/review_repository_impl.dart';
import 'package:marketplace_app_member/core/data/repositories/wishlist_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/review_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/wishlist_repository.dart';
import 'package:marketplace_app_member/core/data/repositories/order_repository_impl.dart';
import 'package:marketplace_app_member/core/data/repositories/payment_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/order_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/payment_repository.dart';
import 'package:marketplace_app_member/core/data/repositories/address_repository_impl.dart';
import 'package:marketplace_app_member/core/data/repositories/checkout_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/address_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/checkout_repository.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/core/data/repositories/cart_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/data/repositories/auth_repository_impl.dart';
import 'package:marketplace_app_member/core/data/repositories/catalog_repository_impl.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/catalog_repository.dart';
import 'package:marketplace_app_member/core/services/token_store.dart';
import 'package:marketplace_app_member/di/injector.dart';

/// Pendaftaran seluruh `*RepositoryImpl`.
///
/// Dijalankan **setelah** `initializeService()` karena setiap repository
/// menerima service sebagai dependency:
///
/// ```dart
/// injector.registerLazySingleton<AuthRepository>(
///   () => AuthRepositoryImpl(injector<AuthService>()),
/// );
/// ```
///
/// Kontrak yang tidak boleh dilanggar: **repository tidak pernah throw**.
/// Setiap method membungkus panggilan service dan mengembalikan
/// `DataState<T>`. Pakai mixin `RepositoryGuard`
/// (`core/data/repositories/repository_guard.dart`) supaya pembungkusnya
/// tidak disalin ulang di tiap repository:
///
/// ```dart
/// class CatalogRepositoryImpl with RepositoryGuard implements CatalogRepository {
///   @override
///   Future<DataState<ProductModel>> fetchProduct(int id) =>
///       guard(() => _service.fetchProduct(id));
/// }
/// ```
///
/// Yang didaftarkan adalah **antarmuka** dari `core/domain/repositories/`,
/// dengan implementasi dari `core/data/repositories/` — supaya cubit
/// bergantung pada abstraksi dan bisa diganti fake saat test.
void initializeRepository() {
  injector.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      injector<AuthService>(),
      injector<TokenStore>(),
    ),
  );

  injector.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(injector<CatalogService>()),
  );

  injector.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(injector<CartService>()),
  );

  injector.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(injector<AddressService>()),
  );

  injector.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      injector<CheckoutService>(),
      injector<WalletService>(),
    ),
  );

  injector.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(injector<OrderService>()),
  );

  injector.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(injector<PaymentService>()),
  );

  injector.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(injector<WishlistService>()),
  );

  injector.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(injector<ReviewService>()),
  );

  injector.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(injector<WalletService>()),
  );

  injector.registerLazySingleton<RewardRepository>(
    () => RewardRepositoryImpl(injector<RewardService>()),
  );

  injector.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(injector<ChatService>()),
  );

  injector.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(injector<NotificationService>()),
  );

  injector.registerLazySingleton<StoreRepository>(
    () => StoreRepositoryImpl(injector<StoreService>()),
  );

  injector.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(injector<SupportService>()),
  );

  injector.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(injector<AccountService>(), injector<AuthService>()),
  );

  injector.registerLazySingleton<VoucherRepository>(
    () => VoucherRepositoryImpl(injector<VoucherService>()),
  );

  injector.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(injector<HomeService>()),
  );

  injector.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(injector<LocationService>()),
  );

  injector.registerLazySingleton<LiveRepository>(
    () => LiveRepositoryImpl(injector<LiveService>()),
  );

  injector.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(injector<MediaService>()),
  );
}
