import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/auth/auth_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/core/services/auth_events.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/features/spalsh/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _user = UserModel(
  id: 3,
  email: 'budi@example.id',
  phone: '081200000001',
  fullName: 'Budi',
  status: 'active',
  roles: [UserRoleModel(code: 'buyer', name: 'Buyer')],
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.hasSession, required this.meResult});

  @override
  final bool hasSession;
  final DataState<UserModel> meResult;

  @override
  Future<DataState<UserModel>> me() async => meResult;

  @override
  Future<DataState<AuthSessionModel>> login({
    required String email,
    required String password,
  }) async =>
      throw UnimplementedError();

  @override
  Future<DataState<AuthSessionModel>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> logout() async {}

  @override
  Future<DataState<UserModel>> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async =>
      meResult;

  @override
  Future<DataState<void>> forgotPassword(String email) async =>
      const DataSuccess(null);

  @override
  Future<DataState<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async =>
      const DataSuccess(null);

}

/// Rute yang sedang aktif menurut `go_router`.
///
/// Dibaca dari `routeInformationProvider`, bukan `currentConfiguration`, karena
/// yang terakhir hanya terisi kalau ada widget `Router` yang mendengarkan —
/// sedangkan test ini memasang `SplashView` sendirian.
String currentRoute() => router.routeInformationProvider.value.uri.toString();

Future<void> pumpSplash(
  WidgetTester tester, {
  required bool hasSession,
  DataState<UserModel> meResult = const DataSuccess(_user),
}) async {
  injector
    ..registerSingleton<AuthRepository>(
      _FakeAuthRepository(hasSession: hasSession, meResult: meResult),
    )
    ..registerSingleton<AuthEvents>(AuthEvents());

  await tester.pumpWidget(const MaterialApp(home: SplashView()));

  // Splash menahan dirinya 2 detik demi animasi; jangan pakai pumpAndSettle
  // karena ada AnimationController.repeat() yang tidak pernah selesai.
  await tester.pump(const Duration(seconds: 3));
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
    router.go('/');
  });

  tearDown(() async {
    await injector.reset();
  });

  testWidgets(
    'pindah walau state sesi sudah ada SEBELUM listener terpasang',
    (tester) async {
      // Ini regresi yang sesungguhnya. Pada kasus "belum pernah login",
      // `restoreSession()` memanggil emit(unauthenticated) secara SINKRON di
      // dalam `BlocProvider.create` — sebelum `BlocListener` berlangganan.
      // `BlocListener` tidak memutar ulang state yang sudah ada, jadi versi
      // yang menyimpan state dari listener akan macet di splash selamanya.
      await pumpSplash(tester, hasSession: false);

      expect(
        currentRoute(),
        contains(AppRoutes.onboarding),
        reason: 'splash macet — state sesi terlewat karena emit terjadi '
            'sebelum listener terpasang',
      );

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('sesi sah diarahkan ke home layout', (tester) async {
    await pumpSplash(tester, hasSession: true);

    expect(currentRoute(), contains(AppRoutes.homeLayout));

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('sesi ditolak server diarahkan ke login, bukan onboarding',
      (tester) async {
    await pumpSplash(
      tester,
      hasSession: true,
      meResult: const DataFailed(
        DataError(
          code: ApiErrorCode.unauthenticated,
          message: 'expired',
          statusCode: 401,
          kind: DataErrorKind.api,
        ),
      ),
    );

    // User ini sudah pernah punya akun — mengulang onboarding salah.
    expect(currentRoute(), contains(AppRoutes.login));

    await tester.pumpWidget(const SizedBox());
  });
}
