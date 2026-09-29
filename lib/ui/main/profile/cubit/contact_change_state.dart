part of 'contact_change_cubit.dart';

@freezed
abstract class ContactChangeState with _$ContactChangeState {
  const ContactChangeState._();

  const factory ContactChangeState({
    required ContactType type,
    String? newValue,

    /// `null` = belum meminta OTP.
    ContactChangeChallenge? challenge,
    @Default(<String, dynamic>{}) Map<String, dynamic> meta,
    @Default(false) bool isBusy,
    DataError? error,

    /// Endpoint belum ada di backend (mock dimatikan).
    @Default(false) bool unavailable,
  }) = _ContactChangeState;

  bool get isCompleted => challenge?.isCompleted ?? false;
}
