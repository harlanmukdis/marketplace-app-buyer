import 'package:marketplace_app_member/ui/main/auth/screens/forgot_password_screen.dart';
import 'package:marketplace_app_member/ui/main/auth/screens/reset_password_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/account_security_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/edit_profile_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/settings_screen.dart';
import 'package:marketplace_app_member/ui/main/review/screens/my_reviews_screen.dart';
import 'package:marketplace_app_member/ui/main/voucher/screens/voucher_screen.dart';
import 'package:marketplace_app_member/ui/main/address/screens/address_list_screen.dart';
import 'package:marketplace_app_member/ui/main/cart/screens/cart_screen.dart';
import 'package:marketplace_app_member/ui/main/catalog/screens/search_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_cancel_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_complaint_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_invoice_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_tracking_screen.dart';
import 'package:marketplace_app_member/ui/main/review/screens/review_form_screen.dart';
import 'package:marketplace_app_member/ui/main/store/screens/followed_stores_screen.dart';
import 'package:marketplace_app_member/ui/main/store/screens/store_screen.dart';
import 'package:marketplace_app_member/ui/main/support/screens/support_list_screen.dart';
import 'package:marketplace_app_member/ui/main/support/screens/support_new_ticket_screen.dart';
import 'package:marketplace_app_member/ui/main/support/screens/support_ticket_screen.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/bank_accounts_screen.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/withdrawal_pin_screen.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:marketplace_app_member/ui/main/auth/screens/login_screen.dart';
import 'package:marketplace_app_member/ui/main/catalog/screens/product_detail_screen.dart';
import 'package:marketplace_app_member/ui/main/chat/screens/chat_list_screen.dart';
import 'package:marketplace_app_member/ui/main/chat/screens/chat_room_screen.dart';
import 'package:marketplace_app_member/ui/main/checkout/screens/checkout_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_detail_screen.dart';
import 'package:marketplace_app_member/ui/main/notification/screens/notification_screen.dart';
import 'package:marketplace_app_member/ui/main/order/screens/order_list_screen.dart';
import 'package:marketplace_app_member/ui/main/reward/screens/reward_screen.dart';
import 'package:marketplace_app_member/ui/main/payment/screens/payment_screen.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/wallet_screen.dart';
import 'package:marketplace_app_member/ui/main/auth/screens/register_screen.dart';
import '../../features/auth/presentation/views/welcome_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/shared/views/home_layout.dart';
import '../../features/spalsh/splash_screen.dart';

// Define route constants
class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String resetPassword = '/resetPassword';
  static const String register = '/register';

  /// Detail penawaran ber-API.
  ///
  /// Memakai **path parameter**, bukan `state.extra` seperti route lain di
  /// file ini. Alasannya bukan selera: `extra` tidak ikut serta di URL, jadi
  /// di web sekali user me-refresh halaman detail, `extra`-nya hilang dan
  /// `state.extra! as int` melempar. Dengan `/product/:id` halaman ini tahan
  /// refresh dan bisa dibagikan sebagai tautan.
  ///
  /// Route `productDetails` milik kit dibiarkan apa adanya karena masih
  /// dipakai layar favorites/trending yang belum dimigrasikan.
  static const String productDetail = '/product';

  /// Membangun path detail untuk sebuah produk.
  static String productDetailPath(int productId) => '/product/$productId';

  /// Checkout ber-API.
  ///
  /// Dinamai `checkoutSession` karena `AppRoutes.checkout` milik kit sudah
  /// terpakai `CheckoutView` lama yang belum dimigrasikan. Membuka rute ini
  /// **mereservasi stok 15 menit**, dan meninggalkannya membatalkan sesinya.
  static const String checkoutSession = '/checkoutSession';

  /// Daftar pesanan pembeli.
  static const String orders = '/orders';

  /// Detail pesanan. Path parameter, bukan `extra`, agar tahan refresh di web.
  static const String orderDetail = '/order';

  static String orderDetailPath(int orderId) => '/order/$orderId';

  /// Pembayaran satu transaksi.
  ///
  /// Ber-parameter **id transaksi**, bukan id order: satu transaksi menutup
  /// semua order yang lahir dari satu sesi checkout.
  static const String payment = '/payment';

  static String paymentPath(int transactionId) => '/payment/$transactionId';

  /// Dompet: saldo, riwayat mutasi, topup, penarikan.
  static const String wallet = '/wallet';

  /// Poin, koin, tingkat loyalitas, dan riwayat cashback.
  static const String reward = '/reward';

  /// Daftar percakapan dengan toko.
  static const String chatList = '/chats';

  /// Satu ruang percakapan. Path parameter, bukan `extra`, agar tahan
  /// refresh di web. Nama toko dikirim lewat `extra` sebagai pelengkap —
  /// tidak ada endpoint untuk menukar id percakapan jadi nama toko, jadi
  /// judulnya jatuh ke 'Chat' kalau ruang dibuka tanpa melewati daftar.
  static const String chatRoom = '/chat-room';

  static String chatRoomPath(int conversationId) =>
      '/chat-room/$conversationId';

  // --- Xpedia (desain Stitch) ---
  //
  // Seluruhnya path parameter, bukan `extra`, dengan alasan yang sama dengan
  // `productDetail`: tahan refresh di web.

  /// Keranjang. Bukan tab — desain Xpedia menaruhnya sebagai ikon app bar
  /// berlencana (design_buyer.md §4 "Bottom navigation").
  static const String cart = '/cart';

  /// Hasil pencarian: `/search?q=…`. Tanpa filter dan tanpa urutan.
  static const String search = '/search';

  static String searchPath(String query) =>
      Uri(path: search, queryParameters: {'q': query}).toString();

  /// Halaman toko.
  static const String store = '/store';

  static String storePath(int storeId) => '/store/$storeId';

  static const String followedStores = '/following';

  static const String addresses = '/addresses';

  /// Xpedia 911 — satu-satunya merek layanan pelanggan.
  static const String support = '/xpedia-911';

  static String supportTicketPath(int ticketId) => '/xpedia-911/$ticketId';

  /// Membuat tiket baru, opsional terkait satu pesanan:
  /// `/xpedia-911/new?order=12`.
  static String supportNewPath({int? orderId}) => Uri(
        path: '/xpedia-911/new',
        queryParameters: orderId == null ? null : {'order': '$orderId'},
      ).toString();

  static String orderTrackingPath(int orderId) => '/order/$orderId/tracking';

  static String orderInvoicePath(int orderId) => '/order/$orderId/invoice';

  static String orderCancelPath(int orderId) => '/order/$orderId/cancel';

  static String orderComplaintPath(int orderId) => '/order/$orderId/complaint';

  /// Formulir ulasan satu baris pesanan: `/order/12/review/34`.
  static String orderReviewPath(int orderId, int orderItemId) =>
      '/order/$orderId/review/$orderItemId';

  static const String bankAccounts = '/wallet/bank-accounts';

  /// Perangkat yang login, verifikasi identitas (KTP), dan ganti email/HP.
  static const String accountSecurity = '/account-security';

  /// Voucher milik pembeli + pasang ke keranjang.
  static const String vouchers = '/vouchers';

  /// Ulasan yang pernah ditulis pembeli — bisa diedit 30 hari.
  static const String myReviews = '/my-reviews';

  static const String withdrawalPin = '/wallet/pin';

  static const String homeLayout = '/homeLayout';
  static const String editProfile = '/editProfile';
  static const String settings = '/settings';
  static const String forgotPassword = '/forgotPassword';
  /// Kotak masuk notifikasi ber-API.
  ///
  /// Dulu mengarah ke `NotificationsLayout` milik kit — cangkang dua tab
  /// (Notifikasi | Pesan) berisi data contoh. Sejak notifikasi disambungkan ke
  /// API, rute ini mengarah ke layar sungguhan, dan tab "Pesan" **sengaja
  /// tidak dibawa serta**: domain chat belum ditulis, dan tab palsu di sebelah
  /// tab sungguhan lebih menyesatkan daripada tidak ada tab sama sekali.
  /// Cangkang tab bisa dihidupkan lagi saat chat dikerjakan.
  static const String notifications = '/notifications';
}

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    // --- Xpedia (desain Stitch) ---
    GoRoute(
      path: AppRoutes.accountSecurity,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const AccountSecurityScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.vouchers,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const VoucherScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.myReviews,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const MyReviewsScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const CartScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.search,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: SearchScreen(query: state.uri.queryParameters['q'] ?? ''),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.store}/:id',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: StoreScreen(storeId: int.parse(state.pathParameters['id']!)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.followedStores,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const FollowedStoresScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addresses,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const AddressListScreen(),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.support}/new',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: SupportNewTicketScreen(orderId: int.tryParse(state.uri.queryParameters['order'] ?? '')),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.support}/:id',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: SupportTicketScreen(ticketId: int.parse(state.pathParameters['id']!)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.support,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const SupportListScreen(),
        );
      },
    ),
    GoRoute(
      path: '/order/:id/tracking',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: OrderTrackingScreen(orderId: int.parse(state.pathParameters['id']!)),
        );
      },
    ),
    GoRoute(
      path: '/order/:id/invoice',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: OrderInvoiceScreen(orderId: int.parse(state.pathParameters['id']!)),
        );
      },
    ),
    GoRoute(
      path: '/order/:id/cancel',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: OrderCancelScreen(orderId: int.parse(state.pathParameters['id']!)),
        );
      },
    ),
    GoRoute(
      path: '/order/:id/complaint',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: OrderComplaintScreen(orderId: int.parse(state.pathParameters['id']!)),
        );
      },
    ),
    GoRoute(
      path: '/order/:id/review/:itemId',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: ReviewFormScreen(orderId: int.parse(state.pathParameters['id']!), orderItemId: int.parse(state.pathParameters['itemId']!)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bankAccounts,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const BankAccountsScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.withdrawalPin,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const WithdrawalPinScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const SplashView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const OnboardingView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.welcome,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const WelcomeView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const LoginScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: ResetPasswordScreen(
            email: state.uri.queryParameters['email'],
            token: state.uri.queryParameters['token'],
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.orders,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const OrderListScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.wallet,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const WalletScreen(),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.orderDetail}/:id',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: OrderDetailScreen(orderId: id),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.payment}/:txId',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final id = int.tryParse(state.pathParameters['txId'] ?? '') ?? 0;
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: PaymentScreen(transactionId: id),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.checkoutSession,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const CheckoutScreen(),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.productDetail}/:id',
      pageBuilder: (BuildContext context, GoRouterState state) {
        // Id yang tidak bisa dibaca diperlakukan sebagai 0 — layarnya lalu
        // menampilkan "Produk tidak ditemukan", bukan melempar.
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: ProductDetailScreen(productId: id),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const RegisterScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.homeLayout,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const HomeLayout(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const EditProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const SettingsScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const ForgotPasswordScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chatList,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const ChatListScreen(),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.chatRoom}/:id',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: ChatRoomScreen(
            conversationId:
                int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
            storeName: state.extra as String?,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.reward,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const RewardScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notifications,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeThroughTransitionPageWrapper(
          transitionKey: state.pageKey,
          page: const NotificationScreen(),
        );
      },
    ),
  ],
);

// Create a reusable FadeThroughTransitionPageWrapper
class FadeThroughTransitionPageWrapper extends Page {
  const FadeThroughTransitionPageWrapper({
    required this.page,
    required this.transitionKey,
  }) : super(key: transitionKey);

  final Widget page;
  final ValueKey transitionKey;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
    );
  }
}
