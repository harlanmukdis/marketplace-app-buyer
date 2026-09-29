import 'package:flutter/material.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/design/xp_colors.dart';
import 'package:marketplace_app_member/core/design/xp_text.dart';
import 'package:marketplace_app_member/ui/main/profile/widgets/account_error_text.dart';

/// Menampilkan kegagalan di dalam alur form, bukan sebagai SnackBar.
///
/// Disengaja: SnackBar menghilang sendiri dan mudah terlewat, sedangkan
/// kegagalan login/daftar adalah hal yang perlu user baca lalu tindak lanjuti.
/// Untuk kegagalan yang bisa dicoba ulang ([DataError.isRetryable]) tombol
/// "Coba lagi" ditampilkan; untuk kredensial salah tidak, karena mengulang
/// request yang sama tidak akan mengubah hasilnya.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.error, this.onRetry});

  final DataError error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final showRetry = onRetry != null && error.isRetryable;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 8, 12),
      decoration: BoxDecoration(
        color: XpColors.dangerSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: XpColors.danger, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              accountErrorText(context, error),
              style: XpText.bodyM(context),
            ),
          ),
          if (showRetry)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              child: Text(
                'Coba lagi',
                style: XpText.labelL(context).copyWith(color: XpColors.danger),
              ),
            ),
        ],
      ),
    );
  }
}
