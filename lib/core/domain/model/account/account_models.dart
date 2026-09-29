import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/util/json_converters.dart';

part 'account_models.freezed.dart';
part 'account_models.g.dart';

// ---------------------------------------------------------------------------
// Sesi login — `GET /me/sessions` (endpoint SUNGGUHAN)
// ---------------------------------------------------------------------------

/// Satu baris `user_sessions`, dari `GET /me/sessions`.
///
/// Kolomnya persis `SELECT id, device_id, ip_address, user_agent, created_at,
/// expires_at` di `Jwt_auth::list_sessions` — **tidak ada "terakhir aktif"**
/// dan **tidak ada penanda sesi yang sedang dipakai**.
///
/// 🔴 Satu baris ≠ satu perangkat. `Jwt_auth::refresh()` memanggil
/// `issue_tokens()` yang **menyisipkan baris baru** setiap kali access token
/// diperbarui (tiap 15 menit), tanpa mencabut baris lama — diverifikasi ke
/// server: sesudah refresh, sesi lama tetap tercantum dan refresh token
/// lamanya tetap sah. Karena itu layar mengelompokkannya lewat
/// [groupLoginSessions], bukan menampilkannya mentah.
@freezed
abstract class LoginSessionModel with _$LoginSessionModel {
  const factory LoginSessionModel({
    @IntJson() required int id,
    @StringOrNullJson() @JsonKey(name: 'device_id') String? deviceId,
    @StringOrNullJson() @JsonKey(name: 'ip_address') String? ipAddress,
    @StringOrNullJson() @JsonKey(name: 'user_agent') String? userAgent,
    @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
    @ServerDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,

    /// **Field usulan** (belum dikirim server). Kalau kelak ada, nilainya
    /// menang atas tebakan [groupLoginSessions].
    @JsonKey(name: 'is_current', fromJson: _boolOrNull) bool? isCurrent,
  }) = _LoginSessionModel;

  factory LoginSessionModel.fromJson(Map<String, dynamic> json) =>
      _$LoginSessionModelFromJson(json);
}

bool? _boolOrNull(Object? raw) =>
    raw == null ? null : const BoolJson().fromJson(raw);

/// Satu "perangkat" di layar Keamanan Akun: kumpulan sesi dengan
/// `device_id` + `user_agent` + `ip_address` yang sama.
class LoginDevice {
  const LoginDevice({
    required this.key,
    required this.sessions,
    required this.isCurrent,
  });

  final String key;

  /// Terbaru lebih dulu. Mencabut perangkat berarti mencabut **semuanya**:
  /// mencabut baris terbaru saja menyisakan refresh token lama yang masih
  /// sah (lihat catatan [LoginSessionModel]).
  final List<LoginSessionModel> sessions;

  /// Perangkat yang sedang dipakai. Ditebak — lihat [groupLoginSessions].
  final bool isCurrent;

  LoginSessionModel get latest => sessions.first;

  /// Waktu sesi terbaru dibuat. Bukan "terakhir aktif" sungguhan (server
  /// tidak mencatatnya), tapi karena setiap refresh membuat baris baru,
  /// angkanya paling lambat 15 menit di belakang aktivitas terakhir.
  DateTime? get lastSeenAt => latest.createdAt;

  String? get ipAddress => latest.ipAddress;

  String get label => describeUserAgent(latest.userAgent);

  List<int> get sessionIds => [for (final s in sessions) s.id];
}

/// Lama access token menurut server (`expires_in`), dipakai untuk menghitung
/// kapan token yang sedang dipegang diterbitkan.
const Duration kAccessTokenLifetime = Duration(seconds: 900);

/// Mengelompokkan sesi jadi perangkat dan menandai perangkat ini.
///
/// Server tidak memberi tahu sesi mana yang sedang dipakai, dan aplikasi
/// tidak mengirim `X-Device-Id` (header yang dibaca `issue_tokens`). Tapi
/// setiap penerbitan token **membuat baris baru**, jadi baris milik perangkat
/// ini adalah yang `created_at`-nya paling dekat dengan saat token terakhir
/// diterbitkan ([tokenIssuedAt] = kedaluwarsa access token − 900 detik).
/// Selisih di atas [tolerance] dianggap tidak cocok — jam perangkat bisa
/// melenceng, dan lebih baik tidak menandai apa pun daripada menandai
/// perangkat orang lain sebagai "perangkat ini".
///
/// [LoginSessionModel.isCurrent] dari server, kalau kelak ada, didahulukan.
List<LoginDevice> groupLoginSessions(
  List<LoginSessionModel> sessions, {
  DateTime? tokenIssuedAt,
  Duration tolerance = const Duration(minutes: 2),
}) {
  final groups = <String, List<LoginSessionModel>>{};
  for (final s in sessions) {
    final key = '${s.deviceId ?? ''}|${s.userAgent ?? ''}|${s.ipAddress ?? ''}';
    groups.putIfAbsent(key, () => []).add(s);
  }

  String? currentKey;
  final serverMarked = sessions.where((s) => s.isCurrent == true);
  if (serverMarked.isNotEmpty) {
    final s = serverMarked.first;
    currentKey =
        '${s.deviceId ?? ''}|${s.userAgent ?? ''}|${s.ipAddress ?? ''}';
  } else if (tokenIssuedAt != null) {
    Duration? best;
    for (final entry in groups.entries) {
      for (final s in entry.value) {
        final created = s.createdAt;
        if (created == null) continue;
        final diff = created.difference(tokenIssuedAt).abs();
        if (diff <= tolerance && (best == null || diff < best)) {
          best = diff;
          currentKey = entry.key;
        }
      }
    }
  }

  final epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  final devices = [
    for (final entry in groups.entries)
      LoginDevice(
        key: entry.key,
        sessions: [...entry.value]..sort(
            (a, b) => (b.createdAt ?? epoch).compareTo(a.createdAt ?? epoch)),
        isCurrent: entry.key == currentKey,
      ),
  ];
  // Perangkat ini paling atas, sisanya terbaru dulu.
  devices.sort((a, b) {
    if (a.isCurrent != b.isCurrent) return a.isCurrent ? -1 : 1;
    return (b.lastSeenAt ?? epoch).compareTo(a.lastSeenAt ?? epoch);
  });
  return devices;
}

/// Nama perangkat yang bisa dibaca manusia dari `User-Agent`.
///
/// Aplikasi native mengirim UA bawaan Dio (`Dart/3.11 (dart:io)`) yang tidak
/// menyebut perangkat apa pun, jadi hanya bisa ditulis "Aplikasi Xpedia".
String describeUserAgent(String? ua) {
  final raw = (ua ?? '').trim();
  if (raw.isEmpty) return 'Perangkat tidak dikenal';
  final lower = raw.toLowerCase();
  if (lower.startsWith('dart/')) return 'Aplikasi Xpedia';

  final os = lower.contains('android')
      ? 'Android'
      : (lower.contains('iphone') || lower.contains('ipad'))
          ? 'iOS'
          : lower.contains('mac os')
              ? 'macOS'
              : lower.contains('windows')
                  ? 'Windows'
                  : lower.contains('linux')
                      ? 'Linux'
                      : null;
  final browser = lower.contains('edg/')
      ? 'Edge'
      : lower.contains('chrome/')
          ? 'Chrome'
          : lower.contains('firefox/')
              ? 'Firefox'
              : lower.contains('safari/')
                  ? 'Safari'
                  : null;
  if (browser != null && os != null) return '$browser di $os';
  if (browser != null) return browser;
  if (os != null) return os;
  // Klien lain (curl, Postman, …): tampilkan token pertamanya saja.
  return raw.split(RegExp(r'[\s/]')).first;
}

// ---------------------------------------------------------------------------
// Verifikasi identitas (KTP) — MOCK, docs/22 #4 dan #11
// ---------------------------------------------------------------------------

enum IdentityStatus {
  none('none'),
  pending('pending'),
  verified('verified'),
  rejected('rejected');

  const IdentityStatus(this.code);

  final String code;

  static IdentityStatus parse(String? raw) {
    for (final s in values) {
      if (s.code == raw) return s;
    }
    return IdentityStatus.none;
  }
}

/// `GET /me/identity-verification` — **kontrak usulan**, belum ada di
/// backend (lihat `assets/mock/pending_api/README.md` bagian Account).
@freezed
abstract class IdentityVerificationModel with _$IdentityVerificationModel {
  const IdentityVerificationModel._();

  const factory IdentityVerificationModel({
    @StringJson() @Default('none') String status,

    /// Hanya 4 digit terakhir yang terlihat (`************3456`). NIK utuh
    /// tidak pernah dikirim balik.
    @StringOrNullJson()
    @JsonKey(name: 'id_card_number_masked')
    String? idCardNumberMasked,
    @StringOrNullJson() @JsonKey(name: 'full_name') String? fullName,
    @StringOrNullJson()
    @JsonKey(name: 'rejection_reason')
    String? rejectionReason,
    @ServerDateTimeJson() @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @ServerDateTimeJson() @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  }) = _IdentityVerificationModel;

  factory IdentityVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$IdentityVerificationModelFromJson(json);

  IdentityStatus get statusValue => IdentityStatus.parse(status);

  bool get isVerified => statusValue == IdentityStatus.verified;
  bool get isPending => statusValue == IdentityStatus.pending;

  /// Boleh mengirim (ulang) data KTP.
  bool get canSubmit =>
      statusValue == IdentityStatus.none ||
      statusValue == IdentityStatus.rejected;

  /// docs/22 #11: sesudah terverifikasi, nama lengkap tidak bisa diubah
  /// sendiri. Selama `pending` pun dikunci — kalau tidak, nama bisa diganti
  /// di antara pengajuan dan persetujuan, sehingga yang disetujui bukan nama
  /// yang tampil.
  bool get locksFullName => isVerified || isPending;
}

// ---------------------------------------------------------------------------
// Ganti email / nomor HP dengan OTP — MOCK, docs/22 #10
// ---------------------------------------------------------------------------

enum ContactType {
  email('email', 'Email'),
  phone('phone', 'Nomor HP');

  const ContactType(this.code, this.label);

  final String code;
  final String label;
}

/// Tahap tantangan OTP.
///
/// docs/22 #10: kode dikirim **ke kontak lama dulu** (membuktikan pemilik
/// akun yang meminta), **lalu ke kontak baru** (membuktikan kontaknya milik
/// user). Perubahan baru disimpan sesudah tahap kedua.
enum ContactChangeStage {
  currentContact('current_contact'),
  newContact('new_contact'),
  completed('completed');

  const ContactChangeStage(this.code);

  final String code;

  static ContactChangeStage parse(String? raw) {
    for (final s in values) {
      if (s.code == raw) return s;
    }
    return ContactChangeStage.currentContact;
  }
}

/// Balasan `POST /me/contact-change` dan `POST /me/contact-change/{id}/verify`.
@freezed
abstract class ContactChangeChallenge with _$ContactChangeChallenge {
  const ContactChangeChallenge._();

  const factory ContactChangeChallenge({
    @StringJson() @JsonKey(name: 'request_id') @Default('') String requestId,
    @StringJson() @Default('email') String type,
    @StringJson() @Default('current_contact') String stage,

    /// Tujuan OTP yang sudah disensor (`bu***@contoh.id`, `0812****7890`).
    @StringOrNullJson() @JsonKey(name: 'otp_sent_to') String? otpSentTo,
    @ServerDateTimeJson() @JsonKey(name: 'expires_at') DateTime? expiresAt,

    /// Terisi hanya saat [stage] `completed`.
    @StringOrNullJson() @JsonKey(name: 'new_value') String? newValue,
  }) = _ContactChangeChallenge;

  factory ContactChangeChallenge.fromJson(Map<String, dynamic> json) =>
      _$ContactChangeChallengeFromJson(json);

  ContactChangeStage get stageValue => ContactChangeStage.parse(stage);

  bool get isCompleted => stageValue == ContactChangeStage.completed;
}

// ---------------------------------------------------------------------------
// Lupa kata sandi — endpoint SUNGGUHAN
// ---------------------------------------------------------------------------

/// Hasil `POST /auth/forgot-password`.
///
/// Server menjawab **sama persis** untuk email terdaftar maupun tidak
/// (`"Bila email terdaftar, instruksi reset password sudah dikirim"`), jadi
/// layar tidak boleh menulis "email terkirim" seolah pasti.
///
/// [devResetToken] hanya ada saat backend berjalan dengan
/// `ENVIRONMENT === 'development'` **dan** emailnya terdaftar — itu
/// satu-satunya cara menguji reset tanpa kotak surat sungguhan.
class PasswordResetRequest {
  const PasswordResetRequest({this.devResetToken});

  final String? devResetToken;
}
