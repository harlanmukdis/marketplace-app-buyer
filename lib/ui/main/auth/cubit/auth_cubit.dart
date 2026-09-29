import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:marketplace_app_member/core/data_state.dart';
import 'package:marketplace_app_member/core/domain/model/auth/user_model.dart';
import 'package:marketplace_app_member/core/domain/repositories/auth_repository.dart';
import 'package:marketplace_app_member/core/services/auth_events.dart';
import 'package:marketplace_app_member/di/injector.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
      : _repository = injector<AuthRepository>(),
        _authEvents = injector<AuthEvents>(),
        super(const AuthState.initial()) {
    // Sesi bisa mati di luar alur UI (refresh token dicabut). Interceptor
    // menyiarkannya, dan cubit ini yang menerjemahkannya jadi status.
    _forceLogoutSub = _authEvents.onForceLogout.listen((_) {
      if (isClosed) return;
      emit(const AuthState.unauthenticated(
        error: DataError(
          code: ApiErrorCode.unauthenticated,
          message: 'Sesi berakhir',
          kind: DataErrorKind.api,
        ),
      ));
    });
  }

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  final AuthRepository _repository;
  final AuthEvents _authEvents;
  late final StreamSubscription<void> _forceLogoutSub;

  /// Dipanggil saat app start untuk memutuskan layar pertama.
  ///
  /// Kalau ada token tersimpan, profil dimuat untuk memastikan token itu masih
  /// sah **dan** untuk mendapat `buyer_segment`. Kegagalan jaringan di sini
  /// tidak mem-logout user: sesinya belum tentu mati, cuma tidak terjangkau.
  Future<void> restoreSession() async {
    if (!_repository.hasSession) {
      emit(const AuthState.unauthenticated());
      return;
    }

    emit(const AuthState.loading());
    final result = await _repository.me();

    switch (result) {
      case DataSuccess(:final data):
        emit(AuthState.authenticated(user: data));
      case DataFailed(:final error):
        if (error.isUnauthenticated) {
          await _repository.logout();
          emit(AuthState.unauthenticated(error: error));
        } else {
          // Token masih dianggap sah; app boleh masuk dengan profil kosong dan
          // memuatnya lagi nanti.
          emit(const AuthState.authenticated());
        }
      case DataEmpty():
      case DataLoading():
        emit(const AuthState.authenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());

    final result = await _repository.login(email: email, password: password);

    switch (result) {
      case DataFailed(:final error):
        emit(AuthState.unauthenticated(error: error));
      case DataSuccess():
        await _loadProfileAfterAuth();
      case DataEmpty():
      case DataLoading():
        emit(const AuthState.authenticated());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String idCardNumber,
  }) async {
    emit(const AuthState.loading());

    final result = await _repository.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      idCardNumber: idCardNumber,
    );

    switch (result) {
      case DataFailed(:final error):
        emit(AuthState.unauthenticated(error: error));
      case DataSuccess(:final meta):
        if (meta['auto_login'] == false) {
          emit(const AuthState.registeredNeedsLogin());
        } else {
          await _loadProfileAfterAuth();
        }
      case DataEmpty():
      case DataLoading():
        emit(const AuthState.authenticated());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    if (!isClosed) emit(const AuthState.unauthenticated());
  }

  /// Mengubah profil lewat `PATCH /me`, lalu memancarkan user hasil baca
  /// ulang.
  ///
  /// Hanya [fullName] dan `avatar_url` yang diterima server — **email tidak
  /// bisa diubah** (ia identitas login), dan tidak ada endpoint ganti
  /// password sama sekali: yang ada hanya reset lewat token email.
  ///
  /// Mengembalikan `true` kalau tersimpan, supaya layar bisa menutup dirinya
  /// sendiri tanpa ikut menafsirkan state.
  ///
  /// ⚠️ Kegagalan **tidak** melempar user keluar dari layar: state
  /// `authenticated` dipertahankan beserta user lamanya, dan hanya
  /// [AuthAuthenticated.actionError] yang terisi. Memancarkan
  /// `unauthenticated` di sini — seperti yang dilakukan jalur login — akan
  /// mementalkan user ke layar masuk hanya karena gagal menyimpan nama.
  Future<bool> updateProfile({required String fullName}) async {
    final current = state;
    if (current is! AuthAuthenticated || current.isSaving) return false;

    emit(current.copyWith(isSaving: true, actionError: null));
    final result = await _repository.updateProfile(fullName: fullName);
    if (isClosed) return false;

    switch (result) {
      case DataSuccess(:final data):
        emit(AuthState.authenticated(user: data));
        return true;
      case DataFailed(:final error):
        emit(current.copyWith(isSaving: false, actionError: error));
        return false;
      case DataEmpty():
      case DataLoading():
        emit(current.copyWith(isSaving: false));
        return false;
    }
  }

  /// Membuang pesan error aksi setelah ditampilkan.
  void clearActionError() {
    final current = state;
    if (current is! AuthAuthenticated || current.actionError == null) return;
    emit(current.copyWith(actionError: null));
  }

  /// Memuat profil setelah token tersimpan.
  ///
  /// Gagalnya `GET /auth/me` **tidak** menggagalkan login — token sudah
  /// tersimpan dan sah. User masuk dengan profil kosong; `role` yang disimpan
  /// saat login sudah cukup untuk gating B2B.
  Future<void> _loadProfileAfterAuth() async {
    final profile = await _repository.me();
    if (isClosed) return;

    emit(switch (profile) {
      DataSuccess(:final data) => AuthState.authenticated(user: data),
      _ => const AuthState.authenticated(),
    });
  }

  @override
  Future<void> close() {
    _forceLogoutSub.cancel();
    return super.close();
  }
}
