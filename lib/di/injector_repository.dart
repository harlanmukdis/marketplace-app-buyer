import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/payment_service.dart';
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
    () => CheckoutRepositoryImpl(injector<CheckoutService>()),
  );

  injector.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(injector<OrderService>()),
  );

  injector.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(injector<PaymentService>()),
  );
}
