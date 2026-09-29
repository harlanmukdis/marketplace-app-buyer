// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WalletState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WalletState()';
  }
}

/// @nodoc
class $WalletStateCopyWith<$Res> {
  $WalletStateCopyWith(WalletState _, $Res Function(WalletState) __);
}

/// Adds pattern-matching-related methods to [WalletState].
extension WalletStatePatterns on WalletState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WalletLoading value)? loading,
    TResult Function(WalletReady value)? ready,
    TResult Function(WalletError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case WalletLoading() when loading != null:
        return loading(_that);
      case WalletReady() when ready != null:
        return ready(_that);
      case WalletError() when error != null:
        return error(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WalletLoading value) loading,
    required TResult Function(WalletReady value) ready,
    required TResult Function(WalletError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case WalletLoading():
        return loading(_that);
      case WalletReady():
        return ready(_that);
      case WalletError():
        return error(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WalletLoading value)? loading,
    TResult? Function(WalletReady value)? ready,
    TResult? Function(WalletError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case WalletLoading() when loading != null:
        return loading(_that);
      case WalletReady() when ready != null:
        return ready(_that);
      case WalletError() when error != null:
        return error(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            WalletModel wallet,
            List<BankAccountModel> bankAccounts,
            DataError? bankAccountsError,
            bool withdrawalSubmitted,
            bool pinSaved,
            bool isSubmitting,
            DataError? actionError,
            WalletTopupResult? pendingTopup)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case WalletLoading() when loading != null:
        return loading();
      case WalletReady() when ready != null:
        return ready(
            _that.wallet,
            _that.bankAccounts,
            _that.bankAccountsError,
            _that.withdrawalSubmitted,
            _that.pinSaved,
            _that.isSubmitting,
            _that.actionError,
            _that.pendingTopup);
      case WalletError() when error != null:
        return error(_that.error);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            WalletModel wallet,
            List<BankAccountModel> bankAccounts,
            DataError? bankAccountsError,
            bool withdrawalSubmitted,
            bool pinSaved,
            bool isSubmitting,
            DataError? actionError,
            WalletTopupResult? pendingTopup)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case WalletLoading():
        return loading();
      case WalletReady():
        return ready(
            _that.wallet,
            _that.bankAccounts,
            _that.bankAccountsError,
            _that.withdrawalSubmitted,
            _that.pinSaved,
            _that.isSubmitting,
            _that.actionError,
            _that.pendingTopup);
      case WalletError():
        return error(_that.error);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            WalletModel wallet,
            List<BankAccountModel> bankAccounts,
            DataError? bankAccountsError,
            bool withdrawalSubmitted,
            bool pinSaved,
            bool isSubmitting,
            DataError? actionError,
            WalletTopupResult? pendingTopup)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case WalletLoading() when loading != null:
        return loading();
      case WalletReady() when ready != null:
        return ready(
            _that.wallet,
            _that.bankAccounts,
            _that.bankAccountsError,
            _that.withdrawalSubmitted,
            _that.pinSaved,
            _that.isSubmitting,
            _that.actionError,
            _that.pendingTopup);
      case WalletError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class WalletLoading extends WalletState {
  const WalletLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WalletLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WalletState.loading()';
  }
}

/// @nodoc

class WalletReady extends WalletState {
  const WalletReady(
      {required this.wallet,
      final List<BankAccountModel> bankAccounts = const <BankAccountModel>[],
      this.bankAccountsError,
      this.withdrawalSubmitted = false,
      this.pinSaved = false,
      this.isSubmitting = false,
      this.actionError,
      this.pendingTopup})
      : _bankAccounts = bankAccounts,
        super._();

  final WalletModel wallet;

  /// Rekening tersimpan. Kegagalan memuatnya **tidak** menggagalkan layar
  /// — saldo tetap tampil, hanya penarikan yang belum bisa dipakai.
  final List<BankAccountModel> _bankAccounts;

  /// Rekening tersimpan. Kegagalan memuatnya **tidak** menggagalkan layar
  /// — saldo tetap tampil, hanya penarikan yang belum bisa dipakai.
  @JsonKey()
  List<BankAccountModel> get bankAccounts {
    if (_bankAccounts is EqualUnmodifiableListView) return _bankAccounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bankAccounts);
  }

  /// Kegagalan memuat [bankAccounts]. Dipisah supaya layar rekening tidak
  /// menampilkan "belum ada rekening" padahal daftarnya hanya gagal dimuat
  /// — user akan menambah rekening yang sebenarnya sudah ada.
  final DataError? bankAccountsError;

  /// Penarikan terakhir berhasil diajukan — dipakai layar untuk menutup
  /// lembar penarikan dan menampilkan konfirmasi.
  @JsonKey()
  final bool withdrawalSubmitted;

  /// PIN baru saja berhasil disetel.
  @JsonKey()
  final bool pinSaved;

  /// Sedang mengirim topup atau penarikan.
  @JsonKey()
  final bool isSubmitting;
  final DataError? actionError;

  /// Topup yang baru dibuat dan menunggu dibayar. Layar memakainya untuk
  /// mengarahkan ke halaman pembayaran.
  final WalletTopupResult? pendingTopup;

  /// Create a copy of WalletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalletReadyCopyWith<WalletReady> get copyWith =>
      _$WalletReadyCopyWithImpl<WalletReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalletReady &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            const DeepCollectionEquality()
                .equals(other._bankAccounts, _bankAccounts) &&
            (identical(other.bankAccountsError, bankAccountsError) ||
                other.bankAccountsError == bankAccountsError) &&
            (identical(other.withdrawalSubmitted, withdrawalSubmitted) ||
                other.withdrawalSubmitted == withdrawalSubmitted) &&
            (identical(other.pinSaved, pinSaved) ||
                other.pinSaved == pinSaved) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError) &&
            (identical(other.pendingTopup, pendingTopup) ||
                other.pendingTopup == pendingTopup));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      wallet,
      const DeepCollectionEquality().hash(_bankAccounts),
      bankAccountsError,
      withdrawalSubmitted,
      pinSaved,
      isSubmitting,
      actionError,
      pendingTopup);

  @override
  String toString() {
    return 'WalletState.ready(wallet: $wallet, bankAccounts: $bankAccounts, bankAccountsError: $bankAccountsError, withdrawalSubmitted: $withdrawalSubmitted, pinSaved: $pinSaved, isSubmitting: $isSubmitting, actionError: $actionError, pendingTopup: $pendingTopup)';
  }
}

/// @nodoc
abstract mixin class $WalletReadyCopyWith<$Res>
    implements $WalletStateCopyWith<$Res> {
  factory $WalletReadyCopyWith(
          WalletReady value, $Res Function(WalletReady) _then) =
      _$WalletReadyCopyWithImpl;
  @useResult
  $Res call(
      {WalletModel wallet,
      List<BankAccountModel> bankAccounts,
      DataError? bankAccountsError,
      bool withdrawalSubmitted,
      bool pinSaved,
      bool isSubmitting,
      DataError? actionError,
      WalletTopupResult? pendingTopup});

  $WalletModelCopyWith<$Res> get wallet;
  $WalletTopupResultCopyWith<$Res>? get pendingTopup;
}

/// @nodoc
class _$WalletReadyCopyWithImpl<$Res> implements $WalletReadyCopyWith<$Res> {
  _$WalletReadyCopyWithImpl(this._self, this._then);

  final WalletReady _self;
  final $Res Function(WalletReady) _then;

  /// Create a copy of WalletState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? wallet = null,
    Object? bankAccounts = null,
    Object? bankAccountsError = freezed,
    Object? withdrawalSubmitted = null,
    Object? pinSaved = null,
    Object? isSubmitting = null,
    Object? actionError = freezed,
    Object? pendingTopup = freezed,
  }) {
    return _then(WalletReady(
      wallet: null == wallet
          ? _self.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as WalletModel,
      bankAccounts: null == bankAccounts
          ? _self._bankAccounts
          : bankAccounts // ignore: cast_nullable_to_non_nullable
              as List<BankAccountModel>,
      bankAccountsError: freezed == bankAccountsError
          ? _self.bankAccountsError
          : bankAccountsError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      withdrawalSubmitted: null == withdrawalSubmitted
          ? _self.withdrawalSubmitted
          : withdrawalSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      pinSaved: null == pinSaved
          ? _self.pinSaved
          : pinSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      pendingTopup: freezed == pendingTopup
          ? _self.pendingTopup
          : pendingTopup // ignore: cast_nullable_to_non_nullable
              as WalletTopupResult?,
    ));
  }

  /// Create a copy of WalletState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletModelCopyWith<$Res> get wallet {
    return $WalletModelCopyWith<$Res>(_self.wallet, (value) {
      return _then(_self.copyWith(wallet: value));
    });
  }

  /// Create a copy of WalletState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletTopupResultCopyWith<$Res>? get pendingTopup {
    if (_self.pendingTopup == null) {
      return null;
    }

    return $WalletTopupResultCopyWith<$Res>(_self.pendingTopup!, (value) {
      return _then(_self.copyWith(pendingTopup: value));
    });
  }
}

/// @nodoc

class WalletError extends WalletState {
  const WalletError(this.error) : super._();

  final DataError error;

  /// Create a copy of WalletState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WalletErrorCopyWith<WalletError> get copyWith =>
      _$WalletErrorCopyWithImpl<WalletError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WalletError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'WalletState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $WalletErrorCopyWith<$Res>
    implements $WalletStateCopyWith<$Res> {
  factory $WalletErrorCopyWith(
          WalletError value, $Res Function(WalletError) _then) =
      _$WalletErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$WalletErrorCopyWithImpl<$Res> implements $WalletErrorCopyWith<$Res> {
  _$WalletErrorCopyWithImpl(this._self, this._then);

  final WalletError _self;
  final $Res Function(WalletError) _then;

  /// Create a copy of WalletState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(WalletError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
