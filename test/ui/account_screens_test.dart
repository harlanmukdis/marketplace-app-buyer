/// Smoke test layar akun: My Xpedia, Xpedia Wallet, PIN, rekening, Xpedia
/// 911, Keamanan Akun, Ubah Profil, Pengaturan, lupa/atur ulang kata sandi,
/// onboarding, dan welcome — dirender dengan repository palsu di ukuran
/// ponsel.
///
/// Yang dipatok di My Xpedia sama dengan `integration_test/`: identitas dari
/// sesi (bukan contoh UI kit), **tanpa `SvgPicture`**, lencana terverifikasi
/// hanya untuk akun `active`, dan "Keluar" menghapus token lebih dulu.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/auth/auth_session_model.dart';
import 'package:marketplace_app_member/core/domain/model/account/account_models.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/domain/model/support/support_models.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/core/domain/repositories/account_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/cart_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/support_repository.dart';
import 'package:marketplace_app_member/core/domain/repositories/wallet_repository.dart';
import 'package:marketplace_app_member/core/services/auth_events.dart';
import 'package:marketplace_app_member/core/utils/app_routes.dart';
import 'package:marketplace_app_member/core/utils/local_network.dart';
import 'package:marketplace_app_member/di/injector.dart';
import 'package:marketplace_app_member/features/auth/presentation/views/welcome_view.dart';
import 'package:marketplace_app_member/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:marketplace_app_member/ui/main/auth/screens/forgot_password_screen.dart';
import 'package:marketplace_app_member/ui/main/auth/screens/reset_password_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/account_security_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/edit_profile_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/my_xpedia_screen.dart';
import 'package:marketplace_app_member/ui/main/profile/screens/settings_screen.dart';
import 'package:marketplace_app_member/ui/main/shell/app_scope.dart';
import 'package:marketplace_app_member/ui/main/support/screens/support_list_screen.dart';
import 'package:marketplace_app_member/ui/main/support/screens/support_new_ticket_screen.dart';
import 'package:marketplace_app_member/ui/main/support/screens/support_ticket_screen.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/bank_accounts_screen.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/wallet_screen.dart';
import 'package:marketplace_app_member/ui/main/wallet/screens/withdrawal_pin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_account_repository.dart';

const _pending = UserModel(
  id: 3,
  email: 'e2e@example.id',
  fullName: 'E2E Pembeli',
  status: 'pending_verification',
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.user);

  final UserModel user;
  final List<String> calls = [];

  @override
  bool get hasSession => true;

  @override
  Future<DataState<UserModel>> me() async => DataSuccess(user);

  @override
  Future<void> logout() async => calls.add('logout');

  @override
  Future<DataState<UserModel>> updateProfile({String? fullName, String? avatarUrl}) async {
    calls.add('updateProfile:$fullName');
    return DataSuccess(user.copyWith(fullName: fullName));
  }

  @override
  Future<DataState<AuthSessionModel>> login({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<DataState<AuthSessionModel>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  }) =>
      throw UnimplementedError();

  @override
  Future<DataState<void>> forgotPassword(String email) => throw UnimplementedError();

  @override
  Future<DataState<void>> resetPassword({required String token, required String newPassword}) =>
      throw UnimplementedError();
}

class _FakeWalletRepository implements WalletRepository {
  @override
  Future<DataState<WalletModel>> fetchWallet() async => DataSuccess(WalletModel(
        id: 1,
        balance: 200000,
        transactions: [
          WalletTransactionModel(
            id: 1,
            typeCode: 'withdraw',
            amount: 50000,
            balanceAfter: 200000,
            createdAt: DateTime.utc(2026, 9, 28, 3),
          ),
        ],
      ));

  @override
  Future<DataState<List<BankAccountModel>>> fetchBankAccounts() async => const DataSuccess([
        BankAccountModel(
            id: 1, bankName: 'BCA', accountNumber: '1234567890', accountHolderName: 'E2E Pembeli'),
      ]);

  @override
  Future<DataState<WalletTopupResult>> topup({required double amount, String paymentMethod = 'qris'}) =>
      throw UnimplementedError();

  @override
  Future<DataState<WalletModel>> withdraw(WithdrawalDraft draft) => throw UnimplementedError();

  @override
  Future<DataState<void>> setWithdrawalPin({required String pin, String? currentPin}) async =>
      const DataSuccess(null);

  @override
  Future<DataState<List<BankAccountModel>>> addBankAccount({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
  }) =>
      throw UnimplementedError();

  @override
  Future<DataState<List<BankAccountModel>>> deleteBankAccount(int id) =>
      throw UnimplementedError();
}

class _FakeCartRepository implements CartRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _FakeSupportRepository implements SupportRepository {
  static const ticket = SupportTicketModel(
    id: 5,
    ticketNumber: 'X911-0005',
    category: 'order_transaction',
    subject: 'Paket belum sampai',
    description: 'Sudah lima hari.',
    relatedOrderId: 42,
    status: 'resolved',
  );

  @override
  Future<DataState<List<SupportTicketModel>>> fetchTickets({int page = 1}) async =>
      const DataSuccess([ticket]);

  @override
  Future<DataState<SupportTicketModel>> fetchTicket(int id) async => const DataSuccess(ticket);

  @override
  Future<DataState<List<SupportMessageModel>>> fetchMessages(int ticketId) async =>
      const DataSuccess([
        SupportMessageModel(id: 1, message: 'Halo, kami cek dulu ya.', isAdminReply: true),
        SupportMessageModel(id: 2, message: 'Terima kasih'),
      ]);

  @override
  Future<DataState<SupportTicketModel>> createTicket({
    required SupportCategory category,
    required String subject,
    required String description,
    int? relatedOrderId,
  }) =>
      throw UnimplementedError();

  @override
  Future<DataState<List<SupportMessageModel>>> sendMessage(int ticketId, String message) =>
      throw UnimplementedError();
}

void main() {
  late _FakeAuthRepository auth;
  late FakeAccountRepository account;

  Future<void> pump(
    WidgetTester tester,
    Widget screen, {
    UserModel user = _pending,
    void Function(FakeAccountRepository)? setupAccount,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    auth = _FakeAuthRepository(user);
    account = FakeAccountRepository();
    setupAccount?.call(account);
    injector
      ..registerSingleton<AccountRepository>(account)
      ..registerSingleton<AuthRepository>(auth)
      ..registerSingleton<AuthEvents>(AuthEvents())
      ..registerSingleton<WalletRepository>(_FakeWalletRepository())
      ..registerSingleton<CartRepository>(_FakeCartRepository())
      ..registerSingleton<SupportRepository>(_FakeSupportRepository());
    await tester.pumpWidget(BlocProvider(
      create: (_) => CartBadgeCubit(),
      child: MaterialApp(home: screen),
    ));
    await tester.pumpAndSettle();
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CachedHelper.init();
  });

  tearDown(() async {
    await injector.reset();
  });

  group('My Xpedia', () {
    testWidgets('identitas dari sesi, tanpa SVG, tanpa lencana untuk akun pending',
        (tester) async {
      await pump(tester, const MyXpediaScreen());

      expect(find.text('E2E Pembeli'), findsOneWidget);
      expect(find.text('e2e@example.id'), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
      expect(find.text('Terverifikasi'), findsNothing);
      expect(find.text('Email belum diverifikasi'), findsOneWidget);
      expect(find.text('Rp 200.000'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('1 dari 3 rekening tersimpan'), 200);
      expect(find.text('1 dari 3 rekening tersimpan'), findsOneWidget);
      // design_buyer.md §5: satu-satunya merek layanan adalah Xpedia 911.
      expect(find.textContaining('Pusat Bantuan'), findsNothing);
    });

    testWidgets('menu akun baru dan pil status KTP bertanda simulasi', (tester) async {
      await pump(tester, const MyXpediaScreen());

      expect(find.text('KTP belum diverifikasi'), findsOneWidget);
      expect(find.text('Simulasi'), findsOneWidget);
      for (final row in ['Ulasan Saya', 'Voucher Saya', 'Keamanan Akun', 'Pengaturan']) {
        await tester.scrollUntilVisible(find.text(row), 200);
        expect(find.text(row), findsOneWidget);
      }
    });

    testWidgets('endpoint KTP belum ada: pilnya tidak digambar', (tester) async {
      await pump(tester, const MyXpediaScreen(),
          setupAccount: (a) => a.identity = const DataFailed(DataError(
              code: 'CLIENT_BAD_RESPONSE', message: 'html', statusCode: 404)));

      expect(find.textContaining('KTP'), findsNothing);
      expect(find.text('Simulasi'), findsNothing);
    });

    testWidgets('akun active mendapat lencana terverifikasi', (tester) async {
      await pump(tester, const MyXpediaScreen(),
          user: _pending.copyWith(status: 'active'));

      expect(find.text('Terverifikasi'), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('Keluar menghapus token sebelum pindah ke login', (tester) async {
      await pump(tester, const MyXpediaScreen());

      await tester.scrollUntilVisible(find.text('Keluar dari Akun'), 200);
      await tester.tap(find.text('Keluar dari Akun'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
      await tester.pumpAndSettle();

      expect(auth.calls, ['logout']);
      expect(router.routeInformationProvider.value.uri.toString(),
          contains(AppRoutes.login));
    });
  });

  group('Wallet', () {
    testWidgets('saldo, rekening, dan mutasi bertanda dari jenisnya', (tester) async {
      await pump(tester, const WalletScreen());

      expect(find.text('Rp 200.000'), findsWidgets);
      expect(find.text('Top Up'), findsOneWidget);
      expect(find.text('Tarik Saldo'), findsOneWidget);
      // `withdraw` mengurangi saldo walau `amount` positif.
      expect(find.text('−Rp 50.000'), findsOneWidget);
    });

    testWidgets('lembar tarik saldo: nominal di bawah minimum tidak sampai ke PIN',
        (tester) async {
      await pump(tester, const WalletScreen());

      await tester.tap(find.text('Tarik Saldo'));
      await tester.pumpAndSettle();
      expect(find.text('BCA •••• 7890'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '10000');
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Minimum penarikan'), findsOneWidget);
      expect(find.text('Masukkan PIN 6-Digit'), findsNothing);

      await tester.enterText(find.byType(TextField), '60000');
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
      expect(find.text('Masukkan PIN 6-Digit'), findsOneWidget);
      expect(find.text('Percobaan PIN terbatas'), findsOneWidget);
    });

    testWidgets('PIN: konfirmasi yang tidak sama meminta PIN baru lagi', (tester) async {
      await pump(tester, const WithdrawalPinScreen());

      expect(find.text('Buat PIN 6-Digit'), findsOneWidget);
      for (final d in '123456'.split('')) {
        await tester.tap(find.text(d).last);
      }
      await tester.pumpAndSettle();
      expect(find.text('Ulangi PIN Baru'), findsOneWidget);
      for (final d in '654321'.split('')) {
        await tester.tap(find.text(d).last);
      }
      await tester.pumpAndSettle();
      expect(find.textContaining('tidak sama'), findsOneWidget);
      expect(find.text('Buat PIN 6-Digit'), findsOneWidget);

      await tester.tap(find.text('Ubah PIN'));
      await tester.pumpAndSettle();
      expect(find.text('Masukkan PIN Lama'), findsOneWidget);
    });

    testWidgets('rekening: penghitung n / 3', (tester) async {
      await pump(tester, const BankAccountsScreen());

      expect(find.text('1 / 3'), findsOneWidget);
      expect(find.text('BCA'), findsOneWidget);
      expect(find.textContaining('•••• 7890'), findsOneWidget);
    });
  });

  group('Xpedia 911', () {
    testWidgets('daftar tiket dengan pil status', (tester) async {
      await pump(tester, const SupportListScreen());

      expect(find.text('Buat Tiket Baru'), findsOneWidget);
      expect(find.text('Paket belum sampai'), findsOneWidget);
      expect(find.text('Selesai'), findsOneWidget);
    });

    testWidgets('tiket dari pesanan menampilkan pesanannya dan kategori terpilih',
        (tester) async {
      await pump(tester, const SupportNewTicketScreen(orderId: 42));

      expect(find.text('Terkait pesanan #42'), findsOneWidget);
      final chip = tester.widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, SupportCategory.orderTransaction.label));
      expect(chip.selected, isTrue);
    });

    testWidgets('tiket selesai: kolom balas diganti ajakan tiket baru', (tester) async {
      await pump(tester, const SupportTicketScreen(ticketId: 5));

      expect(find.text('Sudah lima hari.'), findsOneWidget);
      expect(find.text('Halo, kami cek dulu ya.'), findsOneWidget);
      expect(find.text('Terima kasih'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.text('Buat Tiket Baru'), findsOneWidget);
    });
  });

  group('Keamanan Akun', () {
    testWidgets('perangkat aktif: perangkat ini di atas, yang lain bisa dikeluarkan',
        (tester) async {
      await pump(tester, const AccountSecurityScreen(),
          setupAccount: (a) => a.devices = DataSuccess([
                device(1, current: true),
                device(2,
                    ua: 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 Chrome/129.0 '
                        'Safari/537.36'),
              ]));

      expect(find.text('Verifikasi Sekarang'), findsOneWidget);
      expect(find.text('Simulasi'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Keluar dari semua perangkat lain'), 200);
      expect(find.text('Perangkat ini'), findsOneWidget);
      expect(find.text('Keluar dari perangkat ini'), findsOneWidget);
      expect(find.text('Chrome di Windows'), findsOneWidget);

      await tester.ensureVisible(find.text('Keluarkan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keluarkan'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Keluarkan'));
      await tester.pumpAndSettle();
      expect(account.calls, contains('revoke:2'));
    });

    testWidgets('ganti email: kode ke email lama, tempel, tersimpan',
        (tester) async {
      await pump(tester, const AccountSecurityScreen());

      await tester.tap(find.widgetWithText(TextButton, 'Ubah').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'baru@contoh.id');
      await tester.tap(find.text('Kirim Kode'));
      await tester.pumpAndSettle();

      expect(find.textContaining('email lama kamu'), findsOneWidget);
      expect(find.textContaining('baru@contoh.id'), findsOneWidget);
      // Tidak ada lagi simulasi di lembar ini: kontraknya sungguhan. (Seksi
      // KTP di belakangnya masih mock, jadi pencariannya dibatasi.)
      expect(
          find.descendant(
              of: find.byType(BottomSheet),
              matching: find.textContaining('Simulasi')),
          findsNothing);

      // Tombol dev mengisi token dari `dev_verification_token`.
      await tester.tap(find.text('Isi kode (dev)'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Simpan').last);
      await tester.pumpAndSettle();

      expect(account.calls, contains('confirmContact:email:dev-contact-token'));
      expect(find.text('Email berhasil diganti'), findsOneWidget);
      expect(find.textContaining('masuk dengan baru@contoh.id'), findsOneWidget);
    });

    testWidgets('endpoint KTP belum ada: seksinya disembunyikan', (tester) async {
      await pump(tester, const AccountSecurityScreen(),
          setupAccount: (a) => a.identity = const DataFailed(DataError(
              code: 'CLIENT_BAD_RESPONSE', message: 'html', statusCode: 404)));

      expect(find.text('VERIFIKASI IDENTITAS'), findsNothing);
      expect(find.text('KONTAK AKUN'), findsOneWidget);
    });
  });

  group('Ubah Profil', () {
    testWidgets('nama terisi dan tersimpan lewat PATCH /me', (tester) async {
      await pump(tester, const EditProfileScreen());

      expect(find.text('E2E Pembeli'), findsOneWidget);
      expect(find.text('e2e@example.id'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'Nama Baru');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();
      expect(auth.calls, contains('updateProfile:Nama Baru'));
    });

    testWidgets('KTP terverifikasi mengunci nama (docs/22 #11)', (tester) async {
      await pump(tester, const EditProfileScreen(),
          setupAccount: (a) => a.identity = const DataSuccess(
                IdentityVerificationModel(status: 'verified'),
                meta: mockMeta,
              ));

      final field = tester.widget<TextField>(find.byType(TextField).first);
      expect(field.readOnly, isTrue);
      expect(find.textContaining('Nama dikunci'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      final save = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Simpan'));
      expect(save.onPressed, isNull);
    });
  });

  testWidgets('Pengaturan: tema, bahasa, tautan', (tester) async {
    await pump(tester, const SettingsScreen());

    expect(find.text('Mode gelap'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Keamanan Akun'), findsOneWidget);
    expect(find.text('Xpedia 911'), findsOneWidget);
  });

  group('Lupa kata sandi', () {
    testWidgets('respons generik + tombol dev saat server mengirim token', (tester) async {
      await pump(tester, const ForgotPasswordScreen());

      await tester.enterText(find.byType(TextFormField).first, 'budi@contoh.id');
      await tester.tap(find.text('Kirim Tautan Reset'));
      await tester.pumpAndSettle();

      expect(account.calls, ['forgot:budi@contoh.id']);
      expect(find.text('Cek email kamu'), findsOneWidget);
      expect(find.textContaining('Kalau budi@contoh.id terdaftar'), findsOneWidget);
      // Test berjalan dalam mode debug, jadi tombol dev tampil.
      expect(find.text('Buka tautan reset (dev)'), findsOneWidget);
    });

    testWidgets('atur ulang: token dari rute, konfirmasi berbeda ditolak lokal',
        (tester) async {
      await pump(tester, const ResetPasswordScreen(email: 'budi@contoh.id', token: 'abc'));

      expect(find.text('abc'), findsOneWidget);
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), '123456');
      await tester.enterText(fields.at(2), '654321');
      await tester.tap(find.text('Simpan Kata Sandi'));
      await tester.pumpAndSettle();

      expect(find.text('Konfirmasi kata sandi tidak sama.'), findsOneWidget);
      expect(account.calls, isEmpty);
    });
  });

  group('Pintu masuk', () {
    const forbidden = ['iklan', 'sponsor', 'Pusat Bantuan', 'Help Center', 'asuransi'];

    testWidgets('onboarding berbahasa Indonesia, tanpa kata terlarang', (tester) async {
      await pump(tester, const OnboardingView());

      expect(find.text('Semua kebutuhan, satu aplikasi'), findsOneWidget);
      expect(find.text('Lewati'), findsOneWidget);
      expect(find.text('Lanjut'), findsOneWidget);
      for (final word in forbidden) {
        expect(find.textContaining(word), findsNothing);
      }
    });

    testWidgets('welcome menawarkan masuk dan daftar, tanpa login sosial', (tester) async {
      await pump(tester, const WelcomeView());

      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Daftar Akun Baru'), findsOneWidget);
      expect(find.textContaining('Google'), findsNothing);
    });
  });
}
