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
/// Yang sengaja **tidak** di-mock: `GET/DELETE /me/sessions`,
/// `/auth/forgot-password` + `/auth/reset-password`, dan ganti email/HP
/// (`/me/{email,phone}/change-*`, backend `b501fc3`) — semuanya sudah ada.
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

    ];

/// Pengajuan KTP berpindah dari `pending` ke hasil akhirnya pada `GET`
/// pertama sesudah jeda ini — cukup lama untuk melihat keadaan "sedang
/// ditinjau", cukup singkat untuk tidak menunggu.
const Duration kMockIdentityReviewDelay = Duration(seconds: 10);

/// Jam mock — diganti test supaya jeda 10 detik tidak ditunggu.
@visibleForTesting
DateTime Function() accountMockClock = DateTime.now;

@visibleForTesting
void resetAccountMockState() {
  _identity = null;
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

Map<String, dynamic> _body(Object? data) =>
    data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};

String _maskIdCard(String nik) =>
    nik.length <= 4 ? nik : '${'*' * (nik.length - 4)}${nik.substring(nik.length - 4)}';
