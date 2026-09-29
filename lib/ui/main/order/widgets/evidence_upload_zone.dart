import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/ui/main/order/cubit/complaint_evidence_cubit.dart';
import 'package:marketplace_app_member/ui/main/order/widgets/order_widgets.dart';

/// Pemilih berkas bukti. Bisa diganti test supaya tidak memanggil plugin.
typedef EvidencePicker = Future<List<PickedEvidence>> Function();

/// Pemilih bawaan: galeri foto + video (`image_picker`).
///
/// Ukuran dibaca lebih dulu lewat `length()`; berkas yang jelas lebih dari
/// batas **tidak dibaca ke memori** — cubit tetap menolaknya dengan pesan
/// yang jelas.
Future<List<PickedEvidence>> pickEvidenceFromGallery() async {
  final files = await ImagePicker().pickMultipleMedia();
  return [
    for (final f in files)
      await () async {
        final size = await f.length();
        return PickedEvidence(
          name: f.name,
          mimeType: f.mimeType,
          size: size,
          bytes: size > ComplaintEvidenceCubit.maxBytes ? Uint8List(0) : await f.readAsBytes(),
        );
      }(),
  ];
}

/// Zona "Upload Bukti" (desain §3.16): kotak bergaris putus-putus, lalu grid
/// 4 kolom pratinjau dengan tombol hapus, progres, dan ulang-kalau-gagal.
class EvidenceUploadZone extends StatelessWidget {
  const EvidenceUploadZone({super.key, required this.pick, this.enabled = true});

  final EvidencePicker pick;
  final bool enabled;

  Future<void> _pick(BuildContext context) async {
    final cubit = context.read<ComplaintEvidenceCubit>();
    try {
      final files = await pick();
      cubit.addFiles(files);
    } on PlatformException {
      // Izin galeri ditolak / pemilih tidak tersedia di platform ini.
      if (context.mounted) {
        showOrderSnack(context, 'Galeri tidak bisa dibuka. Periksa izin akses foto.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComplaintEvidenceCubit, ComplaintEvidenceState>(
      listenWhen: (p, c) => c.pickError != null && p.pickError != c.pickError,
      listener: (context, state) {
        // Validasi lokal: satu-satunya kode yang `message`-nya boleh tampil.
        showOrderSnack(context, state.pickError!.message);
        context.read<ComplaintEvidenceCubit>().clearPickError();
      },
      builder: (context, state) {
        final canAdd = enabled && !state.isFull;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              button: true,
              enabled: canAdd,
              label: 'Upload foto atau video bukti',
              child: InkWell(
                onTap: canAdd ? () => _pick(context) : null,
                borderRadius: BorderRadius.circular(12),
                child: CustomPaint(
                  foregroundPainter: _DashedBorderPainter(color: XpColors.borderDefault),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: XpColors.primarySubtle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration:
                              BoxDecoration(color: XpColors.surface, shape: BoxShape.circle),
                          child: Icon(Icons.cloud_upload_outlined,
                              size: 32, color: canAdd ? XpColors.primary : XpColors.textPlaceholder),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.isFull
                              ? 'Maksimal ${ComplaintEvidenceCubit.maxFiles} berkas'
                              : 'Klik untuk upload foto atau video',
                          textAlign: TextAlign.center,
                          style: XpText.titleM(context),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Format: JPG, PNG, MP4, MOV (Maks. 10 MB per file)',
                          textAlign: TextAlign.center,
                          style: XpText.caption(context).copyWith(color: XpColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state.items.isNotEmpty) ...[
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [for (final item in state.items) _Tile(item: item)],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item});

  final EvidenceAttachment item;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ComplaintEvidenceCubit>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (item.isVideo || item.bytes.isEmpty)
            Container(
              color: XpColors.sunken,
              child: Icon(Icons.videocam_outlined, color: XpColors.textSecondary),
            )
          else
            Image.memory(item.bytes, fit: BoxFit.cover, gaplessPlayback: true),
          if (item.isVideo)
            Positioned(
              left: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('VID',
                    style: XpText.caption(context).copyWith(color: Colors.white)),
              ),
            ),
          if (item.uploading || (!item.isDone && !item.isFailed))
            Container(
              color: Colors.black.withValues(alpha: 0.35),
              alignment: Alignment.center,
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  value: item.uploading && item.progress > 0 ? item.progress : null,
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          if (item.isFailed)
            Material(
              color: XpColors.danger.withValues(alpha: 0.75),
              child: InkWell(
                onTap: () => cubit.retry(item.localId),
                child: Tooltip(
                  message: orderErrorMessage(context, item.error!),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, color: Colors.white),
                      Text('Ulangi', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              tooltip: 'Hapus',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              onPressed: () => cubit.remove(item.localId),
              icon: Container(
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Garis tepi putus-putus #D1D5DB (desain §3.16 memakai garis tegas;
/// inventori desain menyarankan putus-putus supaya terbaca sebagai zona
/// jatuhkan berkas).
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)));
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => oldDelegate.color != color;
}
