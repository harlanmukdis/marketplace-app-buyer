import 'package:flutter/foundation.dart';
import 'package:marketplace_app_member/util/format_helper.dart';

import '../pending_api_mock.dart';

/// Rute mock domain account. Lihat `PendingApiMock` untuk aturannya dan
/// `assets/mock/pending_api/README.md` (bagian **Account**) untuk kontrak
/// yang diusulkan.
///
/// Semuanya **stateful di memori** dan hilang saat app dimulai ulang —
/// cukup untuk menjalani alurnya dari ujung ke ujung, tidak untuk dipercaya
/// sebagai data.
///
/// Yang sengaja **tidak** di-mock: `GET/DELETE /me/sessions` (sudah ada di
/// server) dan `/auth/forgot-password` + `/auth/reset-password` (sudah ada).
List<MockRoute> get accountMockRoutes => [
      // -- Verifikasi identitas (docs/22 #4) ---------------------------------
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/me/identity-verification$'),
        onRequest: (options, match) async => MockReply.ok(await _identityPayload()),
      ),
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/me/identity-verification$'),
        onRequest: (options, match) async => _submitIdentity(_body(options.data)),
      ),

      // -- Kunci nama sesudah verifikasi (docs/22 #11) ------------------------
      // `PATCH /me` SUDAH ada; yang diusulkan hanya penolakannya. Selain kasus
      // itu, permintaan diteruskan ke server apa adanya.
      MockRoute(
        method: 'PATCH',
        path: RegExp(r'^/me$'),
        onRequest: (options, match) async {
          final body = _body(options.data);
          final status = _identity?.status;
          if (body.containsKey('full_name') && (status == 'verified' || status == 'pending')) {
            return MockReply.error(
              'IDENTITY_LOCKED',
              'Nama lengkap terkunci setelah verifikasi identitas',
              statusCode: 422,
            );
          }
          return null;
        },
      ),

      // Mengingat email/HP akun dari respons `GET /me` SUNGGUHAN, supaya OTP
      // tahap pertama bisa "dikirim" ke kontak lama yang tersensor. Tidak
      // menambah field apa pun, jadi tidak menandai `mock_fields`.
      MockRoute(
        method: 'GET',
        path: RegExp(r'^/me$'),
        onResponse: (response, match) async {
          final body = response.data;
          final data = body is Map ? body['data'] : null;
          if (data is! Map) return;
          _knownContacts['email'] = data['email']?.toString();
          _knownContacts['phone'] = data['phone']?.toString();
        },
      ),

      // -- Ganti email / HP dengan OTP (docs/22 #10) --------------------------
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/me/contact-change$'),
        onRequest: (options, match) async => _startContactChange(_body(options.data)),
      ),
      MockRoute(
        method: 'POST',
        path: RegExp(r'^/me/contact-change/([^/]+)/verify$'),
        onRequest: (options, match) async =>
            _verifyContactChange(match.group(1)!, _body(options.data)),
      ),
    ];

/// OTP yang diterima mock. Dikirim di `meta.mock_otp` tiap tantangan, supaya
/// layar bisa menampilkannya sebagai petunjuk (debug saja) **tanpa**
/// mengimpor berkas ini — layar tidak boleh bergantung pada rute mock yang
/// kelak dihapus.
const String kMockOtp = '123456';

/// Pengajuan KTP berpindah dari `pending` ke hasil akhirnya pada `GET`
/// pertama sesudah jeda ini — cukup lama untuk melihat keadaan "sedang
/// ditinjau", cukup singkat untuk tidak menunggu.
const Duration kMockIdentityReviewDelay = Duration(seconds: 10);

/// Masa berlaku OTP.
const Duration kMockOtpLifetime = Duration(minutes: 5);

/// Batas salah OTP per permintaan, dan batas permintaan baru per jenis
/// kontak per jam.
const int kMockOtpMaxAttempts = 5;
const int kMockContactChangePerHour = 3;

/// Jam mock — diganti test supaya jeda 10 detik / 5 menit tidak ditunggu.
@visibleForTesting
DateTime Function() accountMockClock = DateTime.now;

@visibleForTesting
void resetAccountMockState() {
  _identity = null;
  _contactRequests.clear();
  _contactRequestLog.clear();
  _knownContacts.clear();
  _requestCounter = 0;
  accountMockClock = DateTime.now;
}

// ---------------------------------------------------------------------------

class _IdentityRecord {
  _IdentityRecord({required this.idCardNumber, required this.fullName, required this.submittedAt});

  final String idCardNumber;
  final String fullName;
  final DateTime submittedAt;
  String status = 'pending';
  DateTime? verifiedAt;
  String? rejectionReason;
}

_IdentityRecord? _identity;

Future<Map<String, dynamic>> _identityPayload() async {
  final record = _identity;
  final base = await MockFixtures.load<Map<String, dynamic>>('account/identity_verification.json');
  if (record == null) return base;

  final now = accountMockClock();
  if (record.status == 'pending' && now.difference(record.submittedAt) >= kMockIdentityReviewDelay) {
    // Pemicu penolakan khusus mock: NIK berakhiran 0000. Di server, hasil
    // ini datang dari peninjauan tim Xpedia.
    if (record.idCardNumber.endsWith('0000')) {
      record
        ..status = 'rejected'
        ..rejectionReason = 'Foto KTP tidak terbaca. Ajukan ulang dengan data yang sesuai.';
    } else {
      record
        ..status = 'verified'
        ..verifiedAt = now;
    }
  }

  return {
    ...base,
    'status': record.status,
    'id_card_number_masked': _maskIdCard(record.idCardNumber),
    'full_name': record.fullName,
    'rejection_reason': record.rejectionReason,
    'submitted_at': formatForServer(record.submittedAt),
    'verified_at': formatForServer(record.verifiedAt),
  };
}

Future<MockReply> _submitIdentity(Map<String, dynamic> body) async {
  final nik = (body['id_card_number'] ?? '').toString().trim();
  final name = (body['full_name'] ?? '').toString().trim();
  if (!RegExp(r'^\d{16}$').hasMatch(nik) || name.isEmpty) {
    return MockReply.error('VALIDATION_ERROR', 'NIK harus 16 digit dan nama wajib diisi');
  }
  final current = _identity?.status;
  if (current == 'pending' || current == 'verified') {
    return MockReply.error('INVALID_STATE', 'Identitas sudah diajukan', statusCode: 422);
  }
  // Pemicu khusus mock untuk "1 KTP = 1 akun": NIK berisi satu digit berulang
  // dianggap sudah dipakai akun lain.
  if (RegExp(r'^(\d)\1{15}$').hasMatch(nik)) {
    return MockReply.error('ID_CARD_ALREADY_USED', 'NIK sudah terdaftar di akun lain',
        statusCode: 409);
  }
  _identity = _IdentityRecord(idCardNumber: nik, fullName: name, submittedAt: accountMockClock());
  return MockReply.ok(await _identityPayload(), statusCode: 201);
}

// ---------------------------------------------------------------------------

class _ContactRequest {
  _ContactRequest({
    required this.id,
    required this.type,
    required this.newValue,
    required this.expiresAt,
  });

  final String id;
  final String type;
  final String newValue;
  String stage = 'current_contact';
  DateTime expiresAt;
  int attempts = 0;
}

final Map<String, _ContactRequest> _contactRequests = {};
final List<(String, DateTime)> _contactRequestLog = [];
final Map<String, String?> _knownContacts = {};
int _requestCounter = 0;

Future<MockReply> _startContactChange(Map<String, dynamic> body) async {
  final rawType = body['type']?.toString();
  final value = (body['new_value'] ?? '').toString().trim();
  if (rawType != 'email' && rawType != 'phone') {
    return MockReply.error('VALIDATION_ERROR', 'type harus email atau phone');
  }
  final type = rawType!;
  final validFormat = type == 'email'
      ? RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
      : RegExp(r'^(\+62|62|0)8\d{7,12}$').hasMatch(value);
  if (!validFormat || value == _knownContacts[type]) {
    return MockReply.error('VALIDATION_ERROR', 'new_value tidak valid');
  }
  // Pemicu khusus mock untuk kontak yang sudah dipakai akun lain.
  if (type == 'email' && value.toLowerCase().startsWith('terpakai@')) {
    return MockReply.error('EMAIL_TAKEN', 'Email sudah terdaftar', statusCode: 409);
  }
  if (type == 'phone' && value.endsWith('00000000')) {
    return MockReply.error('PHONE_TAKEN', 'Nomor sudah terdaftar', statusCode: 409);
  }

  final now = accountMockClock();
  _contactRequestLog.removeWhere((e) => now.difference(e.$2) >= const Duration(hours: 1));
  if (_contactRequestLog.where((e) => e.$1 == type).length >= kMockContactChangePerHour) {
    return MockReply.error('TOO_MANY_REQUESTS', 'Terlalu banyak permintaan', statusCode: 429);
  }
  _contactRequestLog.add((type, now));

  // Satu permintaan aktif per jenis: meminta ulang membatalkan yang lama.
  _contactRequests.removeWhere((_, r) => r.type == type);
  final request = _ContactRequest(
    id: 'mock-cc-${now.millisecondsSinceEpoch}-${++_requestCounter}',
    type: type,
    newValue: value,
    expiresAt: now.add(kMockOtpLifetime),
  );
  _contactRequests[request.id] = request;
  return MockReply.ok(await _challengePayload(request), statusCode: 201, meta: _otpHint);
}

const Map<String, dynamic> _otpHint = {'mock_otp': kMockOtp};

Future<MockReply> _verifyContactChange(String id, Map<String, dynamic> body) async {
  final request = _contactRequests[id];
  if (request == null) {
    return MockReply.error('CONTACT_CHANGE_NOT_FOUND', 'Permintaan tidak ditemukan',
        statusCode: 404);
  }
  final now = accountMockClock();
  if (!now.isBefore(request.expiresAt)) {
    return MockReply.error('OTP_EXPIRED', 'Kode OTP kedaluwarsa');
  }
  if (request.attempts >= kMockOtpMaxAttempts) {
    return MockReply.error('TOO_MANY_REQUESTS', 'Terlalu banyak percobaan', statusCode: 429);
  }
  if ((body['otp'] ?? '').toString().trim() != kMockOtp) {
    request.attempts++;
    return MockReply.error('INVALID_OTP', 'Kode OTP salah');
  }

  if (request.stage == 'current_contact') {
    request
      ..stage = 'new_contact'
      ..attempts = 0
      ..expiresAt = now.add(kMockOtpLifetime);
    return MockReply.ok(await _challengePayload(request), meta: _otpHint);
  }

  _contactRequests.remove(id);
  _knownContacts[request.type] = request.newValue;
  final done = await MockFixtures.load<Map<String, dynamic>>('account/contact_change_completed.json');
  return MockReply.ok({
    ...done,
    'request_id': request.id,
    'type': request.type,
    'new_value': request.newValue,
  });
}

Future<Map<String, dynamic>> _challengePayload(_ContactRequest request) async {
  final base = await MockFixtures.load<Map<String, dynamic>>('account/contact_change_challenge.json');
  final target =
      request.stage == 'current_contact' ? _knownContacts[request.type] : request.newValue;
  return {
    ...base,
    'request_id': request.id,
    'type': request.type,
    'stage': request.stage,
    'otp_sent_to': target == null || target.isEmpty
        ? (request.type == 'email' ? 'email terdaftar' : 'nomor HP terdaftar')
        : maskContact(request.type, target),
    'expires_at': formatForServer(request.expiresAt),
    'new_value': null,
  };
}

// ---------------------------------------------------------------------------

Map<String, dynamic> _body(Object? data) =>
    data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};

String _maskIdCard(String nik) =>
    nik.length <= 4 ? nik : '${'*' * (nik.length - 4)}${nik.substring(nik.length - 4)}';

/// `budi@contoh.id` → `bu***@contoh.id`; `081234567890` → `0812****7890`.
@visibleForTesting
String maskContact(String type, String value) {
  if (type == 'email') {
    final at = value.indexOf('@');
    if (at <= 0) return '***';
    final local = value.substring(0, at);
    final keep = local.length <= 2 ? 1 : 2;
    return '${local.substring(0, keep)}***${value.substring(at)}';
  }
  if (value.length <= 8) return '****';
  return '${value.substring(0, 4)}${'*' * (value.length - 8)}${value.substring(value.length - 4)}';
}
