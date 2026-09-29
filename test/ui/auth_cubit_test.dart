import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/auth/auth_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/core/services/auth_events.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/ui/main/auth/cubit/auth_cubit.dart';

const _user = UserModel(
  id: 3,
  email: 'budi@example.id',
  phone: '081200000001',
  fullName: 'Budi',
  status: 'active',
  roles: [UserRoleModel(code: 'buyer', name: 'Buyer')],
);

const _session = AuthSessionModel(
  accessToken: 'access',
  refreshToken: 'refresh',
  expiresIn: 900,
);

DataError _error(String code, {int? status}) => DataError(
      code: code,
      message: code,
      statusCode: status,
      kind: DataErrorKind.api,
    );

class _FakeAuthRepository implements AuthRepository {
  DataState<AuthSessionModel> loginResult = const DataSuccess(_session);
  DataState<AuthSessionModel> registerResult =
      const DataSuccess(_session, meta: {'auto_login': true});
  DataState<UserModel> meResult = const DataSuccess(_user);

  @override
  bool hasSession = false;

  bool loggedOut = false;

  @override
  Future<DataState<AuthSessionModel>> login({
    required String email,
    required String password,
  }) async =>
      loginResult;

  @override
  Future<DataState<AuthSessionModel>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  }) async =>
      registerResult;

  @override
  Future<DataState<UserModel>> me() async => meResult;

  @override
  Future<void> logout() async => loggedOut = true;

  DataState<UserModel>? updateResult;
  String? lastUpdatedName;

  @override
  Future<DataState<UserModel>> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    lastUpdatedName = fullName;
    return updateResult ?? meResult;
  }

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

void main() {
  late _FakeAuthRepository repository;
  late AuthEvents authEvents;

  setUp(() {
    repository = _FakeAuthRepository();
    authEvents = AuthEvents();
    // Cubit menarik dependency-nya dari injector (konvensi Part 2
    // CLAUDE.md), jadi test mendaftarkan versi palsunya.
    injector
      ..registerSingleton<AuthRepository>(repository)
      ..registerSingleton<AuthEvents>(authEvents);
  });

  tearDown(() async {
    await injector.reset();
    await authEvents.dispose();
  });

  group('login', () {
    test('sukses berujung authenticated dengan profil terisi', () async {
      final cubit = AuthCubit();
      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.login(email: 'budi@example.id', password: 'secret123');
      await Future<void>.delayed(Duration.zero);

      expect(states.first, isA<AuthLoading>());
      expect(cubit.state, isA<AuthAuthenticated>());
      // Peran datang sebagai daftar sekarang, bukan satu kode.
      expect((cubit.state as AuthAuthenticated).user?.isBuyer, isTrue);
      await cubit.close();
    });

    test('kredensial salah berujung unauthenticated dengan error', () async {
      repository.loginResult =
          DataFailed(_error(ApiErrorCode.invalidCredentials, status: 401));

      final cubit = AuthCubit();
      await cubit.login(email: 'budi@example.id', password: 'salah');

      expect(cubit.state, isA<AuthUnauthenticated>());
      expect((cubit.state as AuthUnauthenticated).error?.code,
          ApiErrorCode.invalidCredentials);
      await cubit.close();
    });

    test('GET /auth/me gagal TIDAK menggagalkan login', () async {
      // Token sudah tersimpan dan sah; menendang user ke login hanya karena
      // profilnya belum termuat akan membuat login terasa rusak.
      repository.meResult = DataFailed(_error('CLIENT_NETWORK'));

      final cubit = AuthCubit();
      await cubit.login(email: 'budi@example.id', password: 'secret123');

      expect(cubit.state, isA<AuthAuthenticated>());
      expect((cubit.state as AuthAuthenticated).user, isNull);
      await cubit.close();
    });
  });

  group('register', () {
    test('auto_login false berujung registeredNeedsLogin', () async {
      repository.registerResult =
          const DataSuccess(_session, meta: {'auto_login': false});

      final cubit = AuthCubit();
      await cubit.register(
        email: 'budi@example.id',
        password: 'secret123',
        fullName: 'Budi',
        phone: '081200000001',
        idCardNumber: '3171010101010001',
      );

      // Bukan authenticated (tidak ada refresh token) dan bukan gagal
      // (akunnya sudah terbentuk).
      expect(cubit.state, isA<AuthRegisteredNeedsLogin>());
      await cubit.close();
    });
  });

  group('restoreSession', () {
    test('tanpa token tersimpan langsung unauthenticated tanpa request',
        () async {
      repository.hasSession = false;

      final cubit = AuthCubit();
      await cubit.restoreSession();

      expect(cubit.state, isA<AuthUnauthenticated>());
      expect((cubit.state as AuthUnauthenticated).error, isNull);
      await cubit.close();
    });

    test('token ditolak server berujung logout', () async {
      repository.hasSession = true;
      repository.meResult =
          DataFailed(_error(ApiErrorCode.unauthenticated, status: 401));

      final cubit = AuthCubit();
      await cubit.restoreSession();

      expect(repository.loggedOut, isTrue);
      expect(cubit.state, isA<AuthUnauthenticated>());
      await cubit.close();
    });

    test('gangguan jaringan TIDAK mem-logout user', () async {
      // Ini pembedaan yang penting: sesi 30 hari tidak boleh hilang hanya
      // karena sinyal sempat mati.
      repository.hasSession = true;
      repository.meResult = DataFailed(_error(ClientErrorCode.network));

      final cubit = AuthCubit();
      await cubit.restoreSession();

      expect(repository.loggedOut, isFalse);
      expect(cubit.state, isA<AuthAuthenticated>());
      await cubit.close();
    });
  });

  group('ubah profil', () {
    /// Menyiapkan cubit yang sudah berstatus authenticated.
    Future<AuthCubit> signedIn() async {
      repository.hasSession = true;
      final cubit = AuthCubit();
      await cubit.restoreSession();
      return cubit;
    }

    test('menyimpan nama lalu memancarkan user hasil baca ulang', () async {
      // `PATCH /me` membalas `data: null`, jadi user terbaru hanya bisa
      // didapat dari `GET /me` — repository yang menanggungnya.
      final cubit = await signedIn();

      final saved = await cubit.updateProfile(fullName: 'Budi Baru');

      expect(saved, isTrue);
      expect(repository.lastUpdatedName, 'Budi Baru');
      expect((cubit.state as AuthAuthenticated).user, isNotNull);
      expect((cubit.state as AuthAuthenticated).isSaving, isFalse);
      await cubit.close();
    });

    test('🔴 gagal menyimpan TIDAK melempar user ke layar masuk', () async {
      // Ini yang membedakannya dari jalur login: memancarkan
      // `unauthenticated` di sini akan mementalkan user keluar hanya karena
      // gagal menyimpan nama.
      final cubit = await signedIn();
      repository.updateResult = const DataFailed(
        DataError(code: 'NETWORK', message: 'NETWORK', kind: DataErrorKind.api),
      );

      final saved = await cubit.updateProfile(fullName: 'Budi Baru');

      expect(saved, isFalse);
      final state = cubit.state;
      expect(state, isA<AuthAuthenticated>(),
          reason: 'sesinya masih sah — yang gagal hanya penyimpanan');
      expect((state as AuthAuthenticated).actionError, isNotNull);
      expect(state.user, isNotNull, reason: 'user lama dipertahankan');
      await cubit.close();
    });

    test('tidak mengirim dua permintaan saat sedang menyimpan', () async {
      final cubit = await signedIn();
      repository.lastUpdatedName = null;

      await Future.wait([
        cubit.updateProfile(fullName: 'Pertama'),
        cubit.updateProfile(fullName: 'Kedua'),
      ]);

      expect(repository.lastUpdatedName, 'Pertama',
          reason: 'panggilan kedua diabaikan selagi yang pertama berjalan');
      await cubit.close();
    });

    test('ditolak saat belum masuk', () async {
      final cubit = AuthCubit();

      expect(await cubit.updateProfile(fullName: 'X'), isFalse);
      expect(repository.lastUpdatedName, isNull);
      await cubit.close();
    });

    test('clearActionError membuang pesannya', () async {
      final cubit = await signedIn();
      repository.updateResult = const DataFailed(
        DataError(code: 'NETWORK', message: 'NETWORK', kind: DataErrorKind.api),
      );
      await cubit.updateProfile(fullName: 'Budi Baru');

      cubit.clearActionError();

      expect((cubit.state as AuthAuthenticated).actionError, isNull);
      await cubit.close();
    });
  });

  group('force logout dari interceptor', () {
    test('siaran AuthEvents mengubah status jadi unauthenticated', () async {
      final cubit = AuthCubit();
      expect(cubit.state, isA<AuthInitial>());

      authEvents.emitForceLogout();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<AuthUnauthenticated>());
      expect((cubit.state as AuthUnauthenticated).error?.isUnauthenticated,
          isTrue);
      await cubit.close();
    });
  });
}
