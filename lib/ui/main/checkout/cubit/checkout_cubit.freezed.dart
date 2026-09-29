// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckoutState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CheckoutState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CheckoutState()';
  }
}

/// @nodoc
class $CheckoutStateCopyWith<$Res> {
  $CheckoutStateCopyWith(CheckoutState _, $Res Function(CheckoutState) __);
}

/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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
    TResult Function(CheckoutPreparing value)? preparing,
    TResult Function(CheckoutReady value)? ready,
    TResult Function(CheckoutConfirmed value)? confirmed,
    TResult Function(CheckoutError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing(_that);
      case CheckoutReady() when ready != null:
        return ready(_that);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that);
      case CheckoutError() when error != null:
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
    required TResult Function(CheckoutPreparing value) preparing,
    required TResult Function(CheckoutReady value) ready,
    required TResult Function(CheckoutConfirmed value) confirmed,
    required TResult Function(CheckoutError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing():
        return preparing(_that);
      case CheckoutReady():
        return ready(_that);
      case CheckoutConfirmed():
        return confirmed(_that);
      case CheckoutError():
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
    TResult? Function(CheckoutPreparing value)? preparing,
    TResult? Function(CheckoutReady value)? ready,
    TResult? Function(CheckoutConfirmed value)? confirmed,
    TResult? Function(CheckoutError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing(_that);
      case CheckoutReady() when ready != null:
        return ready(_that);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that);
      case CheckoutError() when error != null:
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
    TResult Function()? preparing,
    TResult Function(
            CheckoutSnapshot snapshot,
            CheckoutPaymentMode paymentMode,
            WalletSummaryModel? wallet,
            Map<String, dynamic>? walletMeta,
            bool walletLoading,
            DataError? walletError,
            bool isSubmitting,
            DataError? actionError,
            DataError? pinError,
            bool isToppingUp,
            int? pendingTopupTxId)?
        ready,
    TResult Function(CheckoutConfirmResult result, Map<String, dynamic>? meta)?
        confirmed,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing();
      case CheckoutReady() when ready != null:
        return ready(
            _that.snapshot,
            _that.paymentMode,
            _that.wallet,
            _that.walletMeta,
            _that.walletLoading,
            _that.walletError,
            _that.isSubmitting,
            _that.actionError,
            _that.pinError,
            _that.isToppingUp,
            _that.pendingTopupTxId);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that.result, _that.meta);
      case CheckoutError() when error != null:
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
    required TResult Function() preparing,
    required TResult Function(
            CheckoutSnapshot snapshot,
            CheckoutPaymentMode paymentMode,
            WalletSummaryModel? wallet,
            Map<String, dynamic>? walletMeta,
            bool walletLoading,
            DataError? walletError,
            bool isSubmitting,
            DataError? actionError,
            DataError? pinError,
            bool isToppingUp,
            int? pendingTopupTxId)
        ready,
    required TResult Function(
            CheckoutConfirmResult result, Map<String, dynamic>? meta)
        confirmed,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing():
        return preparing();
      case CheckoutReady():
        return ready(
            _that.snapshot,
            _that.paymentMode,
            _that.wallet,
            _that.walletMeta,
            _that.walletLoading,
            _that.walletError,
            _that.isSubmitting,
            _that.actionError,
            _that.pinError,
            _that.isToppingUp,
            _that.pendingTopupTxId);
      case CheckoutConfirmed():
        return confirmed(_that.result, _that.meta);
      case CheckoutError():
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
    TResult? Function()? preparing,
    TResult? Function(
            CheckoutSnapshot snapshot,
            CheckoutPaymentMode paymentMode,
            WalletSummaryModel? wallet,
            Map<String, dynamic>? walletMeta,
            bool walletLoading,
            DataError? walletError,
            bool isSubmitting,
            DataError? actionError,
            DataError? pinError,
            bool isToppingUp,
            int? pendingTopupTxId)?
        ready,
    TResult? Function(CheckoutConfirmResult result, Map<String, dynamic>? meta)?
        confirmed,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CheckoutPreparing() when preparing != null:
        return preparing();
      case CheckoutReady() when ready != null:
        return ready(
            _that.snapshot,
            _that.paymentMode,
            _that.wallet,
            _that.walletMeta,
            _that.walletLoading,
            _that.walletError,
            _that.isSubmitting,
            _that.actionError,
            _that.pinError,
            _that.isToppingUp,
            _that.pendingTopupTxId);
      case CheckoutConfirmed() when confirmed != null:
        return confirmed(_that.result, _that.meta);
      case CheckoutError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class CheckoutPreparing extends CheckoutState {
  const CheckoutPreparing() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CheckoutPreparing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CheckoutState.preparing()';
  }
}

/// @nodoc

class CheckoutReady extends CheckoutState {
  const CheckoutReady(
      {required this.snapshot,
      this.paymentMode = CheckoutPaymentMode.detecting,
      this.wallet,
      final Map<String, dynamic>? walletMeta,
      this.walletLoading = false,
      this.walletError,
      this.isSubmitting = false,
      this.actionError,
      this.pinError,
      this.isToppingUp = false,
      this.pendingTopupTxId})
      : _walletMeta = walletMeta,
        super._();

  final CheckoutSnapshot snapshot;
  @JsonKey()
  final CheckoutPaymentMode paymentMode;

  /// Saldo vs tagihan (`GET /wallet` + `grand_total` sesi). Dipertahankan selama dimuat
  /// ulang supaya bloknya tidak berkedip setiap kurir diganti.
  final WalletSummaryModel? wallet;

  /// `meta` ringkasan Wallet — untuk lencana "Simulasi" (kini selalu kosong).
  final Map<String, dynamic>? _walletMeta;

  /// `meta` ringkasan Wallet — untuk lencana "Simulasi" (kini selalu kosong).
  Map<String, dynamic>? get walletMeta {
    final value = _walletMeta;
    if (value == null) return null;
    if (_walletMeta is EqualUnmodifiableMapView) return _walletMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Ringkasan Wallet sedang dimuat (ulang). Tombol bayar mati selama itu:
  /// ringkasan lama bisa menyatakan "cukup" untuk total yang sudah berubah.
  @JsonKey()
  final bool walletLoading;

  /// Gagal memuat ringkasan Wallet.
  final DataError? walletError;

  /// Sedang mengirim pilihan kurir atau konfirmasi.
  @JsonKey()
  final bool isSubmitting;
  final DataError? actionError;

  /// Penolakan PIN (`INVALID_PIN` terjemahan repository, `TOO_MANY_REQUESTS`) — ditampilkan di
  /// dalam lembar PIN, bukan sebagai snackbar di belakangnya.
  final DataError? pinError;

  /// Sedang membuat transaksi top up.
  @JsonKey()
  final bool isToppingUp;

  /// Transaksi top up yang baru dibuat dan belum dibuka layar
  /// pembayarannya. Layar membukanya lalu memanggil `topupHandled`.
  final int? pendingTopupTxId;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutReadyCopyWith<CheckoutReady> get copyWith =>
      _$CheckoutReadyCopyWithImpl<CheckoutReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutReady &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.paymentMode, paymentMode) ||
                other.paymentMode == paymentMode) &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            const DeepCollectionEquality()
                .equals(other._walletMeta, _walletMeta) &&
            (identical(other.walletLoading, walletLoading) ||
                other.walletLoading == walletLoading) &&
            (identical(other.walletError, walletError) ||
                other.walletError == walletError) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError) &&
            (identical(other.pinError, pinError) ||
                other.pinError == pinError) &&
            (identical(other.isToppingUp, isToppingUp) ||
                other.isToppingUp == isToppingUp) &&
            (identical(other.pendingTopupTxId, pendingTopupTxId) ||
                other.pendingTopupTxId == pendingTopupTxId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      snapshot,
      paymentMode,
      wallet,
      const DeepCollectionEquality().hash(_walletMeta),
      walletLoading,
      walletError,
      isSubmitting,
      actionError,
      pinError,
      isToppingUp,
      pendingTopupTxId);

  @override
  String toString() {
    return 'CheckoutState.ready(snapshot: $snapshot, paymentMode: $paymentMode, wallet: $wallet, walletMeta: $walletMeta, walletLoading: $walletLoading, walletError: $walletError, isSubmitting: $isSubmitting, actionError: $actionError, pinError: $pinError, isToppingUp: $isToppingUp, pendingTopupTxId: $pendingTopupTxId)';
  }
}

/// @nodoc
abstract mixin class $CheckoutReadyCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutReadyCopyWith(
          CheckoutReady value, $Res Function(CheckoutReady) _then) =
      _$CheckoutReadyCopyWithImpl;
  @useResult
  $Res call(
      {CheckoutSnapshot snapshot,
      CheckoutPaymentMode paymentMode,
      WalletSummaryModel? wallet,
      Map<String, dynamic>? walletMeta,
      bool walletLoading,
      DataError? walletError,
      bool isSubmitting,
      DataError? actionError,
      DataError? pinError,
      bool isToppingUp,
      int? pendingTopupTxId});

  $WalletSummaryModelCopyWith<$Res>? get wallet;
}

/// @nodoc
class _$CheckoutReadyCopyWithImpl<$Res>
    implements $CheckoutReadyCopyWith<$Res> {
  _$CheckoutReadyCopyWithImpl(this._self, this._then);

  final CheckoutReady _self;
  final $Res Function(CheckoutReady) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? snapshot = null,
    Object? paymentMode = null,
    Object? wallet = freezed,
    Object? walletMeta = freezed,
    Object? walletLoading = null,
    Object? walletError = freezed,
    Object? isSubmitting = null,
    Object? actionError = freezed,
    Object? pinError = freezed,
    Object? isToppingUp = null,
    Object? pendingTopupTxId = freezed,
  }) {
    return _then(CheckoutReady(
      snapshot: null == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as CheckoutSnapshot,
      paymentMode: null == paymentMode
          ? _self.paymentMode
          : paymentMode // ignore: cast_nullable_to_non_nullable
              as CheckoutPaymentMode,
      wallet: freezed == wallet
          ? _self.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as WalletSummaryModel?,
      walletMeta: freezed == walletMeta
          ? _self._walletMeta
          : walletMeta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      walletLoading: null == walletLoading
          ? _self.walletLoading
          : walletLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      walletError: freezed == walletError
          ? _self.walletError
          : walletError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      pinError: freezed == pinError
          ? _self.pinError
          : pinError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      isToppingUp: null == isToppingUp
          ? _self.isToppingUp
          : isToppingUp // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingTopupTxId: freezed == pendingTopupTxId
          ? _self.pendingTopupTxId
          : pendingTopupTxId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletSummaryModelCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
      return null;
    }

    return $WalletSummaryModelCopyWith<$Res>(_self.wallet!, (value) {
      return _then(_self.copyWith(wallet: value));
    });
  }
}

/// @nodoc

class CheckoutConfirmed extends CheckoutState {
  const CheckoutConfirmed(this.result, {final Map<String, dynamic>? meta})
      : _meta = meta,
        super._();

  final CheckoutConfirmResult result;
  final Map<String, dynamic>? _meta;
  Map<String, dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutConfirmedCopyWith<CheckoutConfirmed> get copyWith =>
      _$CheckoutConfirmedCopyWithImpl<CheckoutConfirmed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutConfirmed &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(other._meta, _meta));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, result, const DeepCollectionEquality().hash(_meta));

  @override
  String toString() {
    return 'CheckoutState.confirmed(result: $result, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $CheckoutConfirmedCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutConfirmedCopyWith(
          CheckoutConfirmed value, $Res Function(CheckoutConfirmed) _then) =
      _$CheckoutConfirmedCopyWithImpl;
  @useResult
  $Res call({CheckoutConfirmResult result, Map<String, dynamic>? meta});

  $CheckoutConfirmResultCopyWith<$Res> get result;
}

/// @nodoc
class _$CheckoutConfirmedCopyWithImpl<$Res>
    implements $CheckoutConfirmedCopyWith<$Res> {
  _$CheckoutConfirmedCopyWithImpl(this._self, this._then);

  final CheckoutConfirmed _self;
  final $Res Function(CheckoutConfirmed) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? result = null,
    Object? meta = freezed,
  }) {
    return _then(CheckoutConfirmed(
      null == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as CheckoutConfirmResult,
      meta: freezed == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutConfirmResultCopyWith<$Res> get result {
    return $CheckoutConfirmResultCopyWith<$Res>(_self.result, (value) {
      return _then(_self.copyWith(result: value));
    });
  }
}

/// @nodoc

class CheckoutError extends CheckoutState {
  const CheckoutError(this.error) : super._();

  final DataError error;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutErrorCopyWith<CheckoutError> get copyWith =>
      _$CheckoutErrorCopyWithImpl<CheckoutError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'CheckoutState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $CheckoutErrorCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutErrorCopyWith(
          CheckoutError value, $Res Function(CheckoutError) _then) =
      _$CheckoutErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$CheckoutErrorCopyWithImpl<$Res>
    implements $CheckoutErrorCopyWith<$Res> {
  _$CheckoutErrorCopyWithImpl(this._self, this._then);

  final CheckoutError _self;
  final $Res Function(CheckoutError) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(CheckoutError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
