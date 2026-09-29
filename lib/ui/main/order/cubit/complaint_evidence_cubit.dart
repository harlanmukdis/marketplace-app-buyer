import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/repositories/media_repository.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'complaint_evidence_cubit.freezed.dart';

/// Berkas yang dipilih user, sebelum diunggah. Sengaja bukan `XFile`, supaya
/// cubit tidak bergantung pada plugin `image_picker` dan bisa diuji tanpa
/// perangkat.
class PickedEvidence {
  const PickedEvidence({required this.name, required this.bytes, this.mimeType, this.size});

  final String name;
  final Uint8List bytes;
  final String? mimeType;

  /// Ukuran asli berkas. Diisi pemilih berkas supaya video yang jelas
  /// kebesaran tidak perlu dibaca utuh ke memori hanya untuk ditolak —
  /// dalam kasus itu [bytes] boleh kosong.
  final int? size;
}

/// Satu lampiran bukti komplain.
@freezed
abstract class EvidenceAttachment with _$EvidenceAttachment {
  const EvidenceAttachment._();

  const factory EvidenceAttachment({
    required int localId,
    required String fileName,
    required String mimeType,
    required Uint8List bytes,
    @Default(0) double progress,
    @Default(false) bool uploading,

    /// Hasil `POST /media/upload`; `null` selama belum berhasil.
    String? url,
    DataError? error,
  }) = _EvidenceAttachment;

  bool get isVideo => mimeType.startsWith('video/');
  bool get isDone => url != null;
  bool get isFailed => error != null && !uploading;
}

@freezed
abstract class ComplaintEvidenceState with _$ComplaintEvidenceState {
  const ComplaintEvidenceState._();

  const factory ComplaintEvidenceState({
    @Default(<EvidenceAttachment>[]) List<EvidenceAttachment> items,

    /// Berkas yang ditolak saat dipilih (format/ukuran/jumlah). Validasi
    /// lokal, jadi `message`-nya boleh tampil.
    DataError? pickError,
  }) = _ComplaintEvidenceState;

  bool get isUploading => items.any((i) => !i.isDone && !i.isFailed);
  bool get hasFailed => items.any((i) => i.isFailed);

  /// Komplain hanya boleh dikirim kalau tidak ada unggahan yang menggantung —
  /// bukti yang terlihat di layar tapi tidak ikut terkirim menyesatkan.
  bool get isSettled => !isUploading && !hasFailed;

  List<String> get uploadedUrls => [for (final i in items) if (i.url != null) i.url!];
  bool get isFull => items.length >= ComplaintEvidenceCubit.maxFiles;
}

/// Bukti foto/video komplain (docs/22 #5), diunggah lewat
/// `POST /media/upload` yang **sungguhan**.
///
/// * **Satu per satu, berurutan.** Backend dev berjalan di `php -S` yang
///   single-threaded; unggahan paralel 10 MB akan membekukan seluruh
///   aplikasi selama berjalan (pola yang sama dengan `/chat/.../poll`).
/// * **Batas aplikasi lebih ketat daripada server**: 10 MB per berkas (desain
///   §3.16) vs 20 MB server, dan hanya JPG/PNG/WEBP/MP4/MOV/WEBM — `gif` dan
///   `pdf` memang diterima server, tapi bukan bukti kondisi barang.
/// * URL hasilnya dikirim bersama `POST /orders/{id}/refund-request` sebagai
///   field yang diusulkan `evidence_urls`; **server hari ini mengabaikannya**.
class ComplaintEvidenceCubit extends Cubit<ComplaintEvidenceState> {
  ComplaintEvidenceCubit({MediaRepository? repository})
      : _repository = repository ?? injector<MediaRepository>(),
        super(const ComplaintEvidenceState());

  final MediaRepository _repository;

  static const maxFiles = 5;
  static const maxBytes = 10 * 1024 * 1024;

  /// Ekstensi → MIME. Dipakai kalau pemilih berkas tidak menyebut MIME-nya
  /// (umum di web), karena server memeriksa keduanya.
  static const allowedTypes = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'webp': 'image/webp',
    'mp4': 'video/mp4',
    'mov': 'video/quicktime',
    'webm': 'video/webm',
  };

  /// Konteks unggahan. Bukan `product_photo`, jadi server tidak memberi
  /// watermark — bukti harus utuh.
  static const uploadContext = 'complaint_evidence';

  var _nextId = 1;
  final Map<int, CancelToken> _tokens = {};
  bool _pumping = false;

  static String? mimeFor(String name) {
    final dot = name.lastIndexOf('.');
    if (dot < 0) return null;
    return allowedTypes[name.substring(dot + 1).toLowerCase()];
  }

  void addFiles(List<PickedEvidence> files) {
    if (files.isEmpty) return;
    final accepted = <EvidenceAttachment>[];
    final rejected = <String>[];
    var room = maxFiles - state.items.length;
    for (final picked in files) {
      final (file, mime) = _normalize(picked);
      if (mime == null) {
        rejected.add('${file.name}: format tidak didukung');
      } else if ((file.size ?? file.bytes.length) > maxBytes) {
        rejected.add('${file.name}: lebih dari 10 MB');
      } else if (room <= 0) {
        rejected.add('${file.name}: maksimal $maxFiles berkas');
      } else {
        room--;
        accepted.add(EvidenceAttachment(
          localId: _nextId++,
          fileName: file.name,
          mimeType: mime,
          bytes: file.bytes,
        ));
      }
    }
    emit(state.copyWith(
      items: [...state.items, ...accepted],
      pickError: rejected.isEmpty
          ? null
          : DataError(
              code: ClientErrorCode.localValidation,
              message: rejected.join('\n'),
              kind: DataErrorKind.api,
            ),
    ));
    _pump();
  }

  /// Nama berkas tanpa ekstensi (sering di web) dilengkapi dari MIME-nya,
  /// karena pustaka upload CodeIgniter memeriksa ekstensi nama berkas.
  static (PickedEvidence, String?) _normalize(PickedEvidence file) {
    final mime = mimeFor(file.name);
    if (mime != null) return (file, mime);
    final fromMime = allowedTypes.entries.where((e) => e.value == file.mimeType).firstOrNull;
    if (fromMime == null) return (file, null);
    return (
      PickedEvidence(
        name: '${file.name}.${fromMime.key}',
        bytes: file.bytes,
        mimeType: file.mimeType,
        size: file.size,
      ),
      fromMime.value,
    );
  }

  void clearPickError() {
    if (state.pickError != null) emit(state.copyWith(pickError: null));
  }

  void remove(int localId) {
    _tokens.remove(localId)?.cancel();
    emit(state.copyWith(items: [for (final i in state.items) if (i.localId != localId) i]));
    _pump();
  }

  void retry(int localId) {
    _update(localId, (i) => i.copyWith(error: null, progress: 0));
    _pump();
  }

  /// Mengunggah berkas berikutnya yang belum selesai, satu per satu.
  Future<void> _pump() async {
    if (_pumping) return;
    _pumping = true;
    try {
      while (!isClosed) {
        final next = state.items
            .where((i) => !i.isDone && i.error == null && !i.uploading)
            .firstOrNull;
        if (next == null) break;
        await _upload(next);
      }
    } finally {
      _pumping = false;
    }
  }

  Future<void> _upload(EvidenceAttachment item) async {
    final token = CancelToken();
    _tokens[item.localId] = token;
    _update(item.localId, (i) => i.copyWith(uploading: true, progress: 0));
    final result = await _repository.upload(
      bytes: item.bytes,
      fileName: item.fileName,
      mimeType: item.mimeType,
      context: uploadContext,
      cancelToken: token,
      onProgress: (p) {
        if (!isClosed) _update(item.localId, (i) => i.copyWith(progress: p));
      },
    );
    _tokens.remove(item.localId);
    if (isClosed) return;
    switch (result) {
      case DataSuccess(:final data):
        _update(item.localId,
            (i) => i.copyWith(uploading: false, progress: 1, url: data.url, error: null));
      case DataFailed(:final error):
        _update(item.localId, (i) => i.copyWith(uploading: false, error: error));
      default:
        _update(item.localId, (i) => i.copyWith(uploading: false));
    }
  }

  /// Tidak melakukan apa pun kalau barisnya sudah dihapus user.
  void _update(int localId, EvidenceAttachment Function(EvidenceAttachment) change) {
    if (isClosed) return;
    emit(state.copyWith(items: [
      for (final i in state.items) i.localId == localId ? change(i) : i,
    ]));
  }

  @override
  Future<void> close() {
    for (final token in _tokens.values) {
      token.cancel();
    }
    return super.close();
  }
}
