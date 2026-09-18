import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/address_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/cart_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/checkout_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/notification_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/order_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/payment_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/review_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/reward_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wallet_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/wishlist_service.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/catalog_service.dart';
import 'package:marketplace_app_member/di/injector.dart';

/// Pendaftaran seluruh `*Service` (lapisan yang benar-benar memanggil HTTP).
///
/// Setiap service menerima instance `Dio` bernama, bukan membuat sendiri:
///
/// ```dart
/// injector.registerLazySingleton<CatalogService>(
///   () => CatalogService(injector<Dio>(instanceName: DioClient.api)),
/// );
/// ```
///
/// Aturan yang berlaku di lapisan ini:
///
/// * Service **menangkap `DioException`** dan melemparkannya kembali sebagai
///   `ApiException` dengan konteks (nama operasinya), lewat
///   `ApiException.fromDio(e, context: 'GET /orders/12')`.
/// * Service membuka amplop respons dengan `parseEnvelope` /
///   `parseEnvelopeList`, dan mengembalikan `ApiEnvelope<T>` — bukan `T`
///   telanjang — supaya `meta` dan status HTTP (200 vs 201) tidak hilang.
///   `meta` bukan hiasan: `GET /products` menaruh `facets` untuk sidebar
///   filter di sana.
/// * Cache per-id yang mahal disimpan di service sebagai `Map<int, Model>`,
///   dan panggilan massal dipotong jadi batch `Future.wait`, bukan
///   menembakkan request tanpa batas.
///
/// **Endpoint yang tidak boleh dibuatkan method di sini:** apa pun yang
/// bercakupan admin atau seller (`/admin/*`, `/stores/{id}/orders`,
/// `/orders/{id}/accept|pack|ship`, `/payments/callback/*`). Semuanya dijawab
/// `403 PERMISSION_DENIED` untuk token buyer, dan memanggilnya menandakan
/// alur yang salah sisi sedang dibangun. Satu-satunya pengecualian adalah
/// `POST /stores` — itu tombol "Buka Toko", dan memang endpoint yang memberi
/// role `seller` kepada akun member.
void initializeService() {
  final api = injector<Dio>(instanceName: DioClient.api);

  injector.registerLazySingleton<AuthService>(() => AuthService(api));
  injector.registerLazySingleton<CatalogService>(() => CatalogService(api));
  injector.registerLazySingleton<CartService>(() => CartService(api));
  injector.registerLazySingleton<AddressService>(() => AddressService(api));
  injector.registerLazySingleton<CheckoutService>(() => CheckoutService(api));
  injector.registerLazySingleton<OrderService>(() => OrderService(api));
  injector.registerLazySingleton<PaymentService>(() => PaymentService(api));
  injector.registerLazySingleton<WishlistService>(() => WishlistService(api));
  injector.registerLazySingleton<ReviewService>(() => ReviewService(api));
  injector.registerLazySingleton<WalletService>(() => WalletService(api));
  injector.registerLazySingleton<RewardService>(() => RewardService(api));
  injector.registerLazySingleton<NotificationService>(
    () => NotificationService(api),
  );
}
