/// Kontrak `/auth/*` dan `/me` terhadap marketplace-api yang **benar-benar
/// jalan** di `API_BASE_URL`.
///
/// ```bash
/// flutter test test/integration/
/// ```
///
/// Tidak lagi di-skip di native: bug header `Authorization` case-sensitive
/// yang memblokir seluruh endpoint ber-token di backend lama **sudah tidak
/// ada di API ini** — `Authorization`, `authorization`, dan `AUTHORIZATION`
/// ketiganya dijawab 200. Test di bawah ikut memastikan itu tetap begitu.
///
/// Test ini **membuat user baru** setiap dijalankan (email di-stempel waktu),
/// karena tidak ada akun uji yang di-seed backend.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/config/env/env.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/config/network/dio_client.dart';
import 'package:marketplace_app_member/core/data/datasources/remote/service/auth_service.dart';
import 'package:marketplace_app_member/core/data_state.dart';

void main() {
  late AuthService auth;
  late Dio dio;

  late String email;
  late String phone;
  const password = 'RahasiaAman123';

  setUp(() {
    dio = DioClient.createBare(Env.apiBaseUrl);
    auth = AuthService(dio);
    final stamp = DateTime.now().microsecondsSinceEpoch;
    email = 'uji.$stamp@marketplace.local';
    // Nomor juga harus unik: nomor yang sudah dipakai dibalas PHONE_TAKEN.
    phone = '08${stamp.toString().substring(stamp.toString().length - 10)}';
  });

  Future<String> registerAndLogin() async {
    await auth.register(
      email: email,
      password: password,
      fullName: 'Pembeli Uji',
      phone: phone,
    );
    final session = await auth.login(email: email, password: password);
    dio.options.headers['Authorization'] = 'Bearer ${session.data.accessToken}';
    return session.data.accessToken;
  }

  group('pendaftaran', () {
    test('register TIDAK mengembalikan token, hanya user_id', () async {
      final env = await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );

      expect(env.data.userId, greaterThan(0));
      // Inilah alasan AuthRepositoryImpl.register menyusulkan login sendiri:
      // kalau berhenti di sini, user yang baru daftar tidak punya sesi.
      expect(env.data.devVerificationToken, isNotNull,
          reason: 'backend dev mode mengembalikan token verifikasi; '
              'di produksi field ini hilang dan alurnya lewat email');
    });

    test('email yang sama ditolak pada pendaftaran kedua', () async {
      await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );

      await expectLater(
        auth.register(
          email: email,
          password: password,
          fullName: 'Pembeli Uji Lagi',
          phone: '08${DateTime.now().microsecondsSinceEpoch % 1000000000}',
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('field wajib kosong dibalas VALIDATION_ERROR', () async {
      try {
        await auth.register(
            email: '', password: '', fullName: '', phone: '');
        fail('seharusnya ditolak');
      } on ApiException catch (e) {
        expect(e.error.code, ApiErrorCode.validationError);
      }
    });
  });

  group('login', () {
    test('login memakai EMAIL, dan tidak membawa data user', () async {
      await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );

      final env = await auth.login(email: email, password: password);

      expect(env.data.accessToken, isNotEmpty);
      expect(env.data.refreshToken, isNotNull);
      // 900 detik. Jauh lebih pendek dari 2 jam di backend lama, jadi refresh
      // berjalan sering dan single-flight di TokenRefresher jadi penting.
      expect(env.data.expiresIn, 900);
      expect(env.data.requiresReconsent, isFalse);
    });

    test('password salah dibalas INVALID_CREDENTIALS', () async {
      await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );

      try {
        await auth.login(email: email, password: 'salah-sekali');
        fail('seharusnya ditolak');
      } on ApiException catch (e) {
        expect(e.error.code, ApiErrorCode.invalidCredentials);
      }
    });

    test('akun yang BELUM verifikasi email tetap boleh masuk', () async {
      // Sudah diuji ke server: verifikasi email bukan gerbang login. Jangan
      // memblokir masuk hanya karena email_verified masih false.
      await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );

      final env = await auth.login(email: email, password: password);
      expect(env.data.accessToken, isNotEmpty);
    });

    test('🔴 login BERHASIL pun ikut dihitung rate limit — ke-6 dikunci',
        () async {
      // Backend v1.2.0 (commit `17df39e`) membatasi login 5x per email per 15
      // menit. Penghitungnya bertambah **sebelum** `password_verify`, jadi
      // yang dibatasi bukan percobaan gagal melainkan **semua** percobaan.
      //
      // Konsekuensinya jauh melampaui test ini: user yang masuk di ponsel,
      // tablet, lalu web akan terkunci walau tidak pernah salah password
      // sekali pun. Dan karena ada batas kedua **20x per IP**, satu IP
      // CGNAT operator seluler — yang dibagi ribuan pelanggan — bisa
      // mengunci pengguna yang tidak berbuat apa-apa.
      //
      // Dipatok di sini supaya perbaikannya (menghitung kegagalan saja, dan
      // mengosongkan penghitung saat berhasil) terlihat sebagai test merah.
      await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );

      for (var attempt = 1; attempt <= 5; attempt++) {
        final env = await auth.login(email: email, password: password);
        expect(env.data.accessToken, isNotEmpty,
            reason: 'percobaan ke-$attempt memakai password yang BENAR');
      }

      try {
        await auth.login(email: email, password: password);
        fail('percobaan ke-6 dengan password benar seharusnya dikunci');
      } on ApiException catch (e) {
        expect(e.error.code, ApiErrorCode.tooManyRequests);
        expect(e.error.statusCode, 429);
      }
    });
  });

  group('profil', () {
    test('GET /me membawa peran sebagai DAFTAR, bukan satu kode', () async {
      await registerAndLogin();
      final env = await auth.me();
      final user = env.data;

      expect(user.id, greaterThan(0));
      expect(user.email, email);
      expect(user.fullName, 'Pembeli Uji');
      // Akun baru belum aktif sampai emailnya diverifikasi — tapi login
      // tetap boleh (lihat test di grup "login").
      expect(user.status, 'pending_verification');
      expect(user.needsEmailVerification, isTrue);
      expect(user.isVerified, isFalse);

      // Satu akun bisa merangkap peran, jadi ini list. Membandingkan
      // `user.role == 'buyer'` seperti API lama akan salah untuk akun rangkap.
      expect(user.roles, isNotEmpty);
      expect(user.isBuyer, isTrue);
      expect(user.stores, isEmpty, reason: 'pembeli baru belum punya toko');

      // Dikirim sebagai "0"/"1", bukan boolean JSON.
      expect(user.emailVerified, isFalse);
      expect(user.createdAt, isNotNull);
    });

    test('PATCH /me mengubah nama — profil tidak lagi read-only', () async {
      await registerAndLogin();

      final env = await auth.updateProfile(fullName: 'Pembeli Uji Diubah');

      // Responsnya `data: null` — tidak memantulkan user hasil perubahan.
      // Itu sebabnya repository membaca ulang /me setelah menyimpan.
      expect(env.data, isNull);

      final reread = await auth.me();
      expect(reread.data.fullName, 'Pembeli Uji Diubah',
          reason: 'perubahannya harus benar-benar tersimpan');
    });

    test('tanpa token dibalas UNAUTHENTICATED', () async {
      try {
        await auth.me();
        fail('seharusnya ditolak');
      } on ApiException catch (e) {
        expect(e.error.code, ApiErrorCode.unauthenticated);
        expect(e.error.isUnauthenticated, isTrue);
      }
    });

    test('header Authorization TIDAK sensitif huruf', () async {
      // Regresi yang paling mahal di backend sebelumnya: hanya ejaan
      // "Authorization" persis yang diterima, sehingga seluruh Dart native
      // (yang melowercase nama header) tidak bisa memakai endpoint ber-token.
      // Kalau test ini merah, Android/iOS mati lagi.
      final token = await registerAndLogin();

      for (final spelling in ['Authorization', 'authorization', 'AUTHORIZATION']) {
        final probe = DioClient.createBare(Env.apiBaseUrl);
        probe.options.headers.remove('Authorization');
        probe.options.headers[spelling] = 'Bearer $token';

        final response = await probe.get<dynamic>('/me');
        expect(response.statusCode, 200, reason: 'gagal dengan ejaan "$spelling"');
      }
    });
  });

  group('verifikasi email', () {
    test('🔴 verify-email mengonsumsi token TAPI tidak menandai terverifikasi',
        () async {
      // Bug backend yang sudah dibuktikan: panggilan pertama sukses,
      // panggilan kedua dengan token yang sama dibalas INVALID_TOKEN (jadi
      // token benar-benar dipakai), tapi GET /me tetap email_verified "0".
      // Akibatnya akun tidak akan pernah bisa terverifikasi.
      //
      // Test ini akan MERAH ketika backend diperbaiki — itu kabar baik, dan
      // saat itu ekspektasinya dibalik jadi isTrue.
      final registered = await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );
      final token = registered.data.devVerificationToken;
      expect(token, isNotNull);

      await auth.verifyEmail(token: token!);

      await expectLater(
        auth.verifyEmail(token: token),
        throwsA(isA<ApiException>()),
        reason: 'token sekali pakai — panggilan kedua harus ditolak',
      );

      final session = await auth.login(email: email, password: password);
      dio.options.headers['Authorization'] =
          'Bearer ${session.data.accessToken}';
      final me = await auth.me();

      // Yang benar-benar berubah adalah status.
      expect(me.data.status, 'active');
      expect(me.data.isVerified, isTrue);

      // Yang TIDAK berubah: kolom email_verified. Inilah sebabnya
      // UserModel.isVerified membaca status, bukan kolom ini.
      expect(me.data.emailVerified, isFalse,
          reason: 'BUG BACKEND: verify-email menaikkan status ke active tapi '
              'tidak pernah menyetel email_verified. Kalau test ini gagal, '
              'backend sudah diperbaiki — ubah jadi isTrue dan isVerified '
              'boleh dikembalikan membaca kolom ini.');
    });
  });

  group('lupa password', () {
    test('forgot-password diterima server', () async {
      // Endpoint ini sama sekali tidak ada di backend sebelumnya, sehingga
      // layar reset password kit tidak punya yang bisa dipanggil.
      await auth.register(
        email: email,
        password: password,
        fullName: 'Pembeli Uji',
        phone: phone,
      );

      final env = await auth.forgotPassword(email: email);
      expect(env.statusCode, anyOf(200, 201, 202));
    });
  });
}
