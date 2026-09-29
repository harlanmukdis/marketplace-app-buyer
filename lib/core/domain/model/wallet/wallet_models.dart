import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'wallet_models.freezed.dart';
part 'wallet_models.g.dart';

/// Jenis mutasi saldo, sesuai `ENUM` kolom `wallet_transactions.type`.
///
/// ⚠️ **Arah mutasi ditentukan jenisnya, bukan tanda `amount`.** Kolom
/// `amount` di database dikomentari "selalu positif; arah ditentukan oleh
/// `type`" — jadi menampilkan `amount` apa adanya akan membuat penarikan dan
/// pembelian terlihat seperti pemasukan.
enum WalletTxType {
  topup('topup', 'Isi saldo', credit: true),
  withdraw('withdraw', 'Penarikan', credit: false),
  transferIn('transfer_in', 'Transfer masuk', credit: true),
  transferOut('transfer_out', 'Transfer keluar', credit: false),
  cashback('cashback', 'Cashback', credit: true),
  commission('commission', 'Komisi', credit: true),
  revenue('revenue', 'Pendapatan', credit: true),
  refund('refund', 'Pengembalian dana', credit: true),
  fee('fee', 'Biaya', credit: false),
  adjustment('adjustment', 'Penyesuaian', credit: true),

  /// Membayar pesanan dari saldo — checkout wallet-only sejak backend
  /// `d9ecb33` (skema `42_wallet_only_checkout.sql`). Tanpa entri ini ia jatuh
  /// ke [unknown] yang dianggap kredit, sehingga setiap belanja tampil sebagai
  /// pemasukan di riwayat dompet.
  orderPayment('order_payment', 'Pembayaran pesanan', credit: false),

  /// Jenis yang belum dikenal aplikasi.
  ///
  /// Sengaja dianggap **kredit** supaya tidak menampilkan tanda minus pada
  /// mutasi yang sebenarnya menambah saldo. Salah tanda pada uang lebih
  /// merugikan daripada label yang kurang spesifik — dan `balanceAfter` tetap
  /// menunjukkan kebenarannya.
  unknown('', 'Mutasi lain', credit: true);

  const WalletTxType(this.code, this.label, {required this.credit});

  final String code;
  final String label;

  /// `true` menambah saldo, `false` mengurangi.
  final bool credit;

  static WalletTxType fromCode(String? raw) {
    for (final type in values) {
      if (type.code == raw) return type;
    }
    return unknown;
  }
}

/// Dompet user beserta riwayat mutasinya, dari `GET /wallet`.
///
/// Dompet **dibuat otomatis** saat pertama kali dibaca, jadi akun baru selalu
/// mendapat saldo `0` — bukan `404`.
///
/// ⚠️ [transactions] dipatok **50 terakhir** di server dan **tidak ada
/// paginasi** untuk riwayat lama. Jangan menawarkan "muat lebih banyak".
@freezed
abstract class WalletModel with _$WalletModel {
  const WalletModel._();

  const factory WalletModel({
    @IntJson() @Default(0) int id,
    @DoubleJson() @Default(0) double balance,

    /// Saldo yang ditahan (mis. penarikan yang sedang diproses). Tidak bisa
    /// dipakai membayar.
    @DoubleJson() @JsonKey(name: 'held_balance') @Default(0) double heldBalance,
    @StringJson() @Default('active') String status,
    @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default(<WalletTransactionModel>[])
    List<WalletTransactionModel> transactions,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  /// Saldo yang benar-benar bisa dipakai.
  double get availableBalance {
    final usable = balance - heldBalance;
    return usable < 0 ? 0 : usable;
  }

  bool get isActive => status == 'active';
  bool get hasHistory => transactions.isNotEmpty;
}

/// Satu baris buku besar saldo.
///
/// Tabelnya **append-only**: saldo di `wallets` hanyalah cache teragregasi,
/// dan baris inilah sumber kebenarannya. Karena itu [balanceAfter] layak
/// ditampilkan — ia menunjukkan saldo tepat sesudah mutasi ini, bahkan kalau
/// label jenisnya belum dikenal aplikasi.
@freezed
abstract class WalletTransactionModel with _$WalletTransactionModel {
  const WalletTransactionModel._();

  const factory WalletTransactionModel({
    @IntJson() required int id,

    /// Kode jenis mentah; pakai [type] untuk logika.
    @StringJson() @JsonKey(name: 'type') @Default('') String typeCode,

    /// **Selalu positif.** Arahnya dari [type].
    @DoubleJson() @Default(0) double amount,
    @DoubleJson()
    @JsonKey(name: 'balance_before')
    @Default(0)
    double balanceBefore,
    @DoubleJson()
    @JsonKey(name: 'balance_after')
    @Default(0)
    double balanceAfter,

    /// `order`, `refund`, `withdrawal_request`, `affiliate_commission`,
    /// `topup_request`, … — penjelas asal mutasi.
    @StringOrNullJson() @JsonKey(name: 'reference_type') String? referenceType,
    @IntOrNullJson() @JsonKey(name: 'reference_id') int? referenceId,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _WalletTransactionModel;

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionModelFromJson(json);

  WalletTxType get type => WalletTxType.fromCode(typeCode);

  bool get isCredit => type.credit;

  /// Label yang layak tampil; jenis tak dikenal jatuh ke kodenya sendiri.
  String get label => type == WalletTxType.unknown && typeCode.isNotEmpty
      ? typeCode
      : type.label;

  /// Nilai bertanda, untuk ditampilkan. Positif menambah, negatif mengurangi.
  double get signedAmount => isCredit ? amount : -amount;
}

/// Hasil `POST /wallet/topup`.
///
/// ⚠️ **Saldo belum bertambah di sini.** Endpoint ini hanya membuat
/// `payment_transactions` berstatus `pending`; saldo baru dikredit oleh
/// callback penyedia pembayaran setelah topup benar-benar dibayar.
///
/// [paymentTransactionId] bisa langsung dipakai layar pembayaran yang sudah
/// ada — topup memakai ulang alur `POST /payments/{txId}/pay` yang sama
/// dengan checkout.
@freezed
abstract class WalletTopupResult with _$WalletTopupResult {
  const factory WalletTopupResult({
    @IntJson()
    @JsonKey(name: 'payment_transaction_id')
    @Default(0)
    int paymentTransactionId,
    @StringOrNullJson() @JsonKey(name: 'topup_reference') String? reference,
    @DoubleJson() @Default(0) double amount,
  }) = _WalletTopupResult;

  factory WalletTopupResult.fromJson(Map<String, dynamic> json) =>
      _$WalletTopupResultFromJson(json);
}

/// Rekening tujuan penarikan, dari `GET /me/bank-accounts`.
///
/// Maksimal **3 rekening**, dan nama pemiliknya **wajib sama persis** (tanpa
/// memandang huruf besar-kecil) dengan `users.full_name` — kalau tidak,
/// `POST` dibalas `422 VALIDATION_ERROR`. Aturan ini dari blueprint (hanya
/// rekening atas nama sendiri).
@freezed
abstract class BankAccountModel with _$BankAccountModel {
  const BankAccountModel._();

  const factory BankAccountModel({
    @IntJson() required int id,
    @StringJson() @JsonKey(name: 'bank_name') @Default('') String bankName,
    @StringJson()
    @JsonKey(name: 'account_number')
    @Default('')
    String accountNumber,
    @StringJson()
    @JsonKey(name: 'account_holder_name')
    @Default('')
    String accountHolderName,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _BankAccountModel;

  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      _$BankAccountModelFromJson(json);

  static const int maxAccounts = 3;

  /// "•••• 7890" — cukup untuk mengenali rekening tanpa menampilkannya utuh.
  String get maskedNumber {
    final digits = accountNumber.trim();
    if (digits.length <= 4) return digits;
    return '•••• ${digits.substring(digits.length - 4)}';
  }
}

/// Isi formulir penarikan.
///
/// Sejak backend v1.x (blueprint Wallet) penarikan menuntut **PIN 6 digit**
/// dan **rekening tersimpan** (`bank_account_id`). Field bank mentah
/// (`bank_name`, dst) yang dulu dikirim kini **diabaikan** server.
class WithdrawalDraft {
  const WithdrawalDraft({
    required this.amount,
    this.bankAccountId,
    this.pin = '',
  });

  final double amount;
  final int? bankAccountId;
  final String pin;

  /// Minimum penarikan. Kini dibaca server dari config
  /// (`min_withdrawal_amount`, bawaan 50000), bukan literal — tapi belum dari
  /// `admin_settings` di DB, jadi angka ini tetap bisa melenceng.
  static const double minimumAmount = 50000;

  static final RegExp _pinPattern = RegExp(r'^\d{6}$');

  bool get meetsMinimum => amount >= minimumAmount;

  bool get hasValidPin => _pinPattern.hasMatch(pin);

  bool get isValid => meetsMinimum && bankAccountId != null && hasValidPin;

  WithdrawalDraft withPin(String value) =>
      WithdrawalDraft(amount: amount, bankAccountId: bankAccountId, pin: value);

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'bank_account_id': bankAccountId,
        'pin': pin,
      };
}
