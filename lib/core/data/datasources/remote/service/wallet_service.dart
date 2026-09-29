import 'package:dio/dio.dart';
import 'package:marketplace_app_member/config/network/api_envelope.dart';
import 'package:marketplace_app_member/config/network/api_exception.dart';
import 'package:marketplace_app_member/core/domain/model/wallet/wallet_models.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

/// Panggilan HTTP untuk `/wallet*` **sisi pembeli**.
///
/// ⚠️ **`POST /wallet/transfer` sengaja tidak dibuatkan method.** Endpointnya
/// ada dan berfungsi, tapi menuntut `to_user_id` — **id internal numerik**
/// penerima. Satu-satunya endpoint yang bisa menukar email/nama jadi id adalah
/// `/admin/users*`, yang dijawab `403` untuk token buyer. Jadi tidak ada cara
/// sah bagi app member menemukan id tujuan, dan menyediakan method-nya hanya
/// mengundang layar yang tidak mungkin diisi. Tambahkan begitu backend
/// menyediakan pencarian penerima.
///
/// ⚠️ **`/stores/{id}/wallet` juga tidak ada di sini** — itu dompet toko,
/// butuh permission `wallet.view`, dan ditolak untuk pembeli biasa.
class WalletService {
  WalletService(this._dio);

  final Dio _dio;

  /// `GET /wallet` — saldo beserta riwayat mutasi.
  ///
  /// Dompet **dibuat otomatis** kalau belum ada, jadi akun baru dapat saldo
  /// `0`, bukan `404`.
  ///
  /// ⚠️ Riwayatnya dipatok **50 terakhir** di server, tanpa paginasi maupun
  /// filter. Tidak ada cara mengambil mutasi yang lebih lama.
  Future<ApiEnvelope<WalletModel>> fetchWallet() async {
    const context = 'GET /wallet';
    try {
      final response = await _dio.get<dynamic>('/wallet');
      return parseEnvelope(
        response,
        (raw) => WalletModel.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /wallet/topup` — memulai pengisian saldo.
  ///
  /// ⚠️ **Saldo belum bertambah sesudah panggilan ini.** Yang terbentuk hanya
  /// `payment_transactions` berstatus `pending`; saldo dikredit callback
  /// penyedia setelah topup dibayar. `payment_transaction_id` di balasannya
  /// dipakai langsung oleh layar pembayaran yang sudah ada.
  ///
  /// [paymentMethod] default `qris` di server kalau tidak dikirim.
  Future<ApiEnvelope<WalletTopupResult>> topup({
    required double amount,
    String paymentMethod = 'qris',
  }) async {
    const context = 'POST /wallet/topup';
    try {
      final response = await _dio.post<dynamic>(
        '/wallet/topup',
        data: {'amount': amount, 'payment_method': paymentMethod},
      );
      return parseEnvelope(
        response,
        (raw) =>
            WalletTopupResult.fromJson(Map<String, dynamic>.from(raw as Map)),
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /wallet/withdraw` → id pengajuan penarikan.
  ///
  /// Body `{amount, pin, bank_account_id}`. 🔴 **Setiap penolakan memakai
  /// kode yang sama**, `422 WITHDRAWAL_REJECTED` — di bawah minimum, PIN
  /// belum disetel, PIN salah, rekening tidak ada, dan saldo kurang hanya
  /// dibedakan `message`, yang tidak boleh dicocokkan. Karena itu minimum,
  /// rekening, dan kecukupan saldo diperiksa lebih dulu di aplikasi
  /// (`WalletCubit`), sehingga yang tersisa dari server praktis berarti PIN
  /// salah atau belum disetel.
  ///
  /// 🔴 **Lebih dari 5 percobaan per 15 menit → `429 TOO_MANY_REQUESTS`, dan
  /// PIN yang BENAR pun dihitung** (penghitungnya naik sebelum
  /// `password_verify`, cacat yang sama dengan rate limit login). Jangan
  /// pernah mengulang panggilan ini otomatis.
  ///
  /// Saldo **langsung didebit** saat pengajuan dibuat. ⚠️ Kalau admin
  /// menolaknya, saldo itu **tidak dikembalikan** — bug backend yang dicatat
  /// di CHANGELOG-nya sendiri.
  Future<ApiEnvelope<int>> withdraw(WithdrawalDraft draft) async {
    const context = 'POST /wallet/withdraw';
    try {
      final response = await _dio.post<dynamic>(
        '/wallet/withdraw',
        data: draft.toJson(),
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/withdrawal-pin` — menyetel atau mengganti PIN penarikan.
  ///
  /// Penyetelan pertama cukup `{pin}`; mengganti menuntut [currentPin], dan
  /// PIN lama yang salah dibalas `422 VALIDATION_ERROR`. PIN harus 6 digit
  /// angka. ⚠️ **Tidak ada cara bertanya apakah PIN sudah disetel** — `GET`
  /// pada path ini jatuh ke `GET /wallet` — jadi layar menawarkan keduanya.
  Future<ApiEnvelope<dynamic>> setWithdrawalPin({
    required String pin,
    String? currentPin,
  }) async {
    const context = 'POST /me/withdrawal-pin';
    try {
      final response = await _dio.post<dynamic>(
        '/me/withdrawal-pin',
        data: {
          'pin': pin,
          if (currentPin != null && currentPin.isNotEmpty)
            'current_pin': currentPin,
        },
      );
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `GET /me/bank-accounts`.
  Future<ApiEnvelope<List<BankAccountModel>>> fetchBankAccounts() async {
    const context = 'GET /me/bank-accounts';
    try {
      final response = await _dio.get<dynamic>('/me/bank-accounts');
      return parseEnvelopeList(response, BankAccountModel.fromJson,
          context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `POST /me/bank-accounts` → id rekening baru.
  ///
  /// Nama pemilik yang tidak sama dengan nama akun, field kosong, dan rekening
  /// keempat semuanya dibalas `422 VALIDATION_ERROR`.
  Future<ApiEnvelope<int>> addBankAccount({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
  }) async {
    const context = 'POST /me/bank-accounts';
    try {
      final response = await _dio.post<dynamic>(
        '/me/bank-accounts',
        data: {
          'bank_name': bankName.trim(),
          'account_number': accountNumber.trim(),
          'account_holder_name': accountHolderName.trim(),
        },
      );
      return parseEnvelope(
        response,
        (raw) => raw is Map ? asInt(raw['id']) : 0,
        context: context,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }

  /// `DELETE /me/bank-accounts/{id}`. Id asing dibalas `422 VALIDATION_ERROR`.
  Future<ApiEnvelope<dynamic>> deleteBankAccount(int id) async {
    final context = 'DELETE /me/bank-accounts/$id';
    try {
      final response = await _dio.delete<dynamic>('/me/bank-accounts/$id');
      return parseEnvelope(response, (raw) => raw, context: context);
    } on DioException catch (e) {
      throw ApiException.fromDio(e, context: context);
    }
  }
}
