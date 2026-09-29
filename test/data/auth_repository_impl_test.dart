import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data/repositories/auth_repository_impl.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/auth/auth_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/services/token_store.dart';

/// Service palsu yang meniru bentuk respons yang **sudah diverifikasi** ke
/// marketplace-api: `register` tanpa token sama sekali, `login` tanpa data
/// user, `PATCH /me` tanpa isi.
class _FakeAuthService extends AuthService {
  _FakeAuthService() : super(Dio());

  bool registerCalled = false;
  bool loginCalled = false;
  bool logoutCalled = false;
  int meCalls = 0;
  String? patchedName;

  ApiException? loginError;
  ApiException? registerError;
  ApiException? logoutError;

  @override
  Future<ApiEnvelope<RegisterResultModel>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  }) async {
    registerCalled = true;
    if (registerError != null) throw registerError!;
    return const ApiEnvelope(
      // Register hanya mengembalikan ini — tidak ada access token, tidak ada
      // refresh token.
      data: RegisterResultModel(userId: 3, devVerificationToken: 'dev-token'),
      statusCode: 201,
    );
  }

  @override
  Future<ApiEnvelope<AuthSessionModel>> login({
    required String email,
    required String password,
  }) async {
    loginCalled = true;
    if (loginError != null) throw loginError!;
    return const ApiEnvelope(
      data: AuthSessionModel(
        accessToken: 'access-dari-login',
        refreshToken: 'refresh-token',
        expiresIn: 900,
      ),
      statusCode: 200,
    );
  }

  @override
  Future<ApiEnvelope<dynamic>> logout({required String refreshToken}) async {
    logoutCalled = true;
    if (logoutError != null) throw logoutError!;
    return const ApiEnvelope(data: null, statusCode: 200);
  }

  @override
  Future<ApiEnvelope<UserModel>> me() async {
    meCalls++;
    return ApiEnvelope(
      data: UserModel(
        id: 3,
        email: 'budi@example.id',
        phone: '081200000001',
        fullName: patchedName ?? 'Budi',
        status: 'pending_verification',
        roles: const [UserRoleModel(code: 'buyer', name: 'Buyer')],
      ),
      statusCode: 200,
    );
  }

  @override
  Future<ApiEnvelope<dynamic>> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    patchedName = fullName;
    // Bentuk aslinya: sukses tapi `data: null`.
    return const ApiEnvelope(data: null, statusCode: 200);
  }
}

/// TokenStore palsu yang mencatat apa yang tersimpan, tanpa menyentuh
/// keychain maupun SharedPreferences.
class _FakeTokenStore extends TokenStore {
  _FakeTokenStore() : super(const FlutterSecureStorage());

  final List<Map<String, Object?>> sessions = [];
  final List<Map<String, Object?>> profiles = [];
  bool cleared = false;
  String? storedRefreshToken = 'refresh-lama';

  @override
  bool get hasSession => sessions.isNotEmpty;

  @override
  String? get refreshToken => storedRefreshToken;

  @override
  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
    int? userId,
    String? role,
    String? buyerSegment,
  }) async {
    sessions.add({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    });
  }

  @override
  Future<void> saveProfile({
    int? userId,
    String? role,
    String? buyerSegment,
    String? fullName,
  }) async {
    profiles.add({'userId': userId, 'role': role, 'fullName': fullName});
  }

  @override
  Future<void> clear() async => cleared = true;
}

ApiException _apiError(String code, {int status = 409}) => ApiException(
      DataError(
        code: code,
        message: code,
        statusCode: status,
        kind: DataErrorKind.api,
      ),
    );

void main() {
  late _FakeAuthService service;
  late _FakeTokenStore tokens;
  late AuthRepositoryImpl repository;

  setUp(() {
    service = _FakeAuthService();
    tokens = _FakeTokenStore();
    repository = AuthRepositoryImpl(service, tokens);
  });

  group('register wajib dilanjutkan login otomatis', () {
    test('memanggil login, karena register tidak memberi token apa pun',
        () async {
      final result = await repository.register(
        email: 'budi@example.id',
        password: 'secret123',
        fullName: 'Budi',
        phone: '081200000001',
        idCardNumber: '3171010101010001',
      );

      expect(service.registerCalled, isTrue);
      expect(
        service.loginCalled,
        isTrue,
        reason: 'tanpa login susulan, user yang baru mendaftar tidak punya '
            'sesi sama sekali',
      );

      final success = result as DataSuccess<AuthSessionModel>;
      expect(success.meta['auto_login'], isTrue);
      expect(success.meta['user_id'], 3);
      expect(success.data.refreshToken, 'refresh-token');

      // Hanya satu sesi tersimpan: dari login. Register tidak menghasilkan
      // apa pun yang bisa disimpan.
      expect(tokens.sessions, hasLength(1));
      expect(tokens.sessions.single['refreshToken'], 'refresh-token');
    });

    test('identitas dibaca dari /me, karena login tidak membawanya', () async {
      await repository.register(
        email: 'budi@example.id',
        password: 'secret123',
        fullName: 'Budi',
        phone: '081200000001',
        idCardNumber: '3171010101010001',
      );

      expect(service.meCalls, 1,
          reason: 'respons login kosong dari data user — /me satu-satunya '
              'sumber id, nama, dan peran');
      expect(tokens.profiles.single['role'], 'buyer');
      expect(tokens.profiles.single['userId'], 3);
    });

    test('login otomatis gagal tetap dilaporkan SUKSES dengan penanda',
        () async {
      service.loginError = _apiError('CLIENT_NETWORK', status: 0);

      final result = await repository.register(
        email: 'agus@example.id',
        password: 'secret123',
        fullName: 'Agus',
        phone: '081200000003',
        idCardNumber: '3171010101010001',
      );

      // Akunnya sungguh terbentuk. Melaporkan gagal akan membuat user
      // mendaftar ulang dan kena EMAIL_TAKEN / PHONE_TAKEN.
      expect(result, isA<DataSuccess<AuthSessionModel>>());
      final success = result as DataSuccess<AuthSessionModel>;
      expect(success.meta['auto_login'], isFalse);
      expect(success.meta['user_id'], 3);
    });

    test('register gagal tidak memanggil login dan mengembalikan DataFailed',
        () async {
      service.registerError = _apiError('PHONE_TAKEN');

      final result = await repository.register(
        email: 'budi@example.id',
        password: 'secret123',
        fullName: 'Budi',
        phone: '081200000001',
        idCardNumber: '3171010101010001',
      );

      expect(service.loginCalled, isFalse);
      expect(result, isA<DataFailed<AuthSessionModel>>());
      expect(
          (result as DataFailed<AuthSessionModel>).error.code, 'PHONE_TAKEN');
    });
  });

  group('repository tidak pernah throw', () {
    test('kegagalan login jadi DataFailed, bukan exception', () async {
      service.loginError = _apiError('INVALID_CREDENTIALS', status: 401);

      final result = await repository.login(
        email: 'budi@example.id',
        password: 'salah',
      );

      expect(result, isA<DataFailed<AuthSessionModel>>());
      final error = (result as DataFailed<AuthSessionModel>).error;
      expect(error.code, ApiErrorCode.invalidCredentials);
      expect(error.isUnauthenticated, isTrue);
    });
  });

  group('profil', () {
    test('me menyimpan identitas tanpa menyentuh token', () async {
      final result = await repository.me();

      expect(result, isA<DataSuccess<UserModel>>());
      expect(tokens.profiles, hasLength(1));
      expect(tokens.profiles.single['fullName'], 'Budi');
      // Penting: tidak lewat saveSession, jadi tidak butuh access token.
      expect(tokens.sessions, isEmpty);
    });

    test('updateProfile membaca ulang /me karena PATCH tidak mengembalikan isi',
        () async {
      final result = await repository.updateProfile(fullName: 'Budi Pratama');

      final success = result as DataSuccess<UserModel>;
      expect(success.data.fullName, 'Budi Pratama',
          reason: 'nilainya harus datang dari pembacaan ulang, bukan dari '
              'apa yang dikirim');
      expect(service.meCalls, 1);
    });

    test('peran dibaca sebagai daftar, bukan satu kode', () async {
      final result = await repository.me() as DataSuccess<UserModel>;

      expect(result.data.roles.map((r) => r.code), ['buyer']);
      expect(result.data.isBuyer, isTrue);
      expect(result.data.isSeller, isFalse);
      // Akun baru belum aktif, tapi itu tidak menghalangi login.
      expect(result.data.needsEmailVerification, isTrue);
    });
  });

  group('logout', () {
    test('mencabut sesi di server lalu menghapus lokal', () async {
      await repository.logout();

      expect(service.logoutCalled, isTrue,
          reason: 'API ini punya endpoint logout — refresh token benar-benar '
              'bisa dicabut, tidak cuma dibuang dari perangkat');
      expect(tokens.cleared, isTrue);
    });

    test('server gagal dicabut TETAP menghapus sesi lokal', () async {
      service.logoutError = _apiError('CLIENT_NETWORK', status: 0);

      await repository.logout();

      // User yang menekan "keluar" harus selalu keluar. Refresh token yang
      // gagal dicabut akan kedaluwarsa sendiri.
      expect(tokens.cleared, isTrue);
    });

    test('tanpa refresh token tersimpan, server tidak dipanggil', () async {
      tokens.storedRefreshToken = null;

      await repository.logout();

      expect(service.logoutCalled, isFalse);
      expect(tokens.cleared, isTrue);
    });
  });
}
