part of 'identity_verification_cubit.dart';

@freezed
sealed class IdentityVerificationState with _$IdentityVerificationState {
  const factory IdentityVerificationState.loading() = IdentityVerificationLoading;

  /// Endpoint-nya belum ada (mock dimatikan, backend belum membangunnya).
  const factory IdentityVerificationState.unavailable() = IdentityVerificationUnavailable;

  const factory IdentityVerificationState.ready({
    required IdentityVerificationModel verification,

    /// Untuk lencana "Simulasi".
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
    @Default(false) bool isSubmitting,
    DataError? submitError,
  }) = IdentityVerificationReady;

  const factory IdentityVerificationState.error(DataError error) = IdentityVerificationError;
}
