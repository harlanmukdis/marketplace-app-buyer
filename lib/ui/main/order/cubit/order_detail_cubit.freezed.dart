// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderDetailState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderDetailState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderDetailState()';
  }
}

/// @nodoc
class $OrderDetailStateCopyWith<$Res> {
  $OrderDetailStateCopyWith(
      OrderDetailState _, $Res Function(OrderDetailState) __);
}

/// Adds pattern-matching-related methods to [OrderDetailState].
extension OrderDetailStatePatterns on OrderDetailState {
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
    TResult Function(OrderDetailLoading value)? loading,
    TResult Function(OrderDetailLoaded value)? loaded,
    TResult Function(OrderDetailError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading(_that);
      case OrderDetailLoaded() when loaded != null:
        return loaded(_that);
      case OrderDetailError() when error != null:
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
    required TResult Function(OrderDetailLoading value) loading,
    required TResult Function(OrderDetailLoaded value) loaded,
    required TResult Function(OrderDetailError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading():
        return loading(_that);
      case OrderDetailLoaded():
        return loaded(_that);
      case OrderDetailError():
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
    TResult? Function(OrderDetailLoading value)? loading,
    TResult? Function(OrderDetailLoaded value)? loaded,
    TResult? Function(OrderDetailError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading(_that);
      case OrderDetailLoaded() when loaded != null:
        return loaded(_that);
      case OrderDetailError() when error != null:
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
            OrderModel order,
            bool isSubmitting,
            DataError? actionError,
            OrderTrackingModel? tracking,
            Map<String, dynamic> trackingMeta,
            List<ShipmentEvidenceModel> evidence,
            CancellationRequestModel? cancellationRequest,
            Map<String, dynamic> cancellationMeta,
            bool cancellationSupported,
            InsurancePolicyModel? insurance,
            Map<String, dynamic> insuranceMeta,
            bool insuranceKnown,
            bool isOptingIn)?
        loaded,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading();
      case OrderDetailLoaded() when loaded != null:
        return loaded(
            _that.order,
            _that.isSubmitting,
            _that.actionError,
            _that.tracking,
            _that.trackingMeta,
            _that.evidence,
            _that.cancellationRequest,
            _that.cancellationMeta,
            _that.cancellationSupported,
            _that.insurance,
            _that.insuranceMeta,
            _that.insuranceKnown,
            _that.isOptingIn);
      case OrderDetailError() when error != null:
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
            OrderModel order,
            bool isSubmitting,
            DataError? actionError,
            OrderTrackingModel? tracking,
            Map<String, dynamic> trackingMeta,
            List<ShipmentEvidenceModel> evidence,
            CancellationRequestModel? cancellationRequest,
            Map<String, dynamic> cancellationMeta,
            bool cancellationSupported,
            InsurancePolicyModel? insurance,
            Map<String, dynamic> insuranceMeta,
            bool insuranceKnown,
            bool isOptingIn)
        loaded,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading():
        return loading();
      case OrderDetailLoaded():
        return loaded(
            _that.order,
            _that.isSubmitting,
            _that.actionError,
            _that.tracking,
            _that.trackingMeta,
            _that.evidence,
            _that.cancellationRequest,
            _that.cancellationMeta,
            _that.cancellationSupported,
            _that.insurance,
            _that.insuranceMeta,
            _that.insuranceKnown,
            _that.isOptingIn);
      case OrderDetailError():
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
            OrderModel order,
            bool isSubmitting,
            DataError? actionError,
            OrderTrackingModel? tracking,
            Map<String, dynamic> trackingMeta,
            List<ShipmentEvidenceModel> evidence,
            CancellationRequestModel? cancellationRequest,
            Map<String, dynamic> cancellationMeta,
            bool cancellationSupported,
            InsurancePolicyModel? insurance,
            Map<String, dynamic> insuranceMeta,
            bool insuranceKnown,
            bool isOptingIn)?
        loaded,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case OrderDetailLoading() when loading != null:
        return loading();
      case OrderDetailLoaded() when loaded != null:
        return loaded(
            _that.order,
            _that.isSubmitting,
            _that.actionError,
            _that.tracking,
            _that.trackingMeta,
            _that.evidence,
            _that.cancellationRequest,
            _that.cancellationMeta,
            _that.cancellationSupported,
            _that.insurance,
            _that.insuranceMeta,
            _that.insuranceKnown,
            _that.isOptingIn);
      case OrderDetailError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class OrderDetailLoading extends OrderDetailState {
  const OrderDetailLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OrderDetailLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OrderDetailState.loading()';
  }
}

/// @nodoc

class OrderDetailLoaded extends OrderDetailState {
  const OrderDetailLoaded(
      {required this.order,
      this.isSubmitting = false,
      this.actionError,
      this.tracking,
      final Map<String, dynamic> trackingMeta = const <String, dynamic>{},
      final List<ShipmentEvidenceModel> evidence =
          const <ShipmentEvidenceModel>[],
      this.cancellationRequest,
      final Map<String, dynamic> cancellationMeta = const <String, dynamic>{},
      this.cancellationSupported = true,
      this.insurance,
      final Map<String, dynamic> insuranceMeta = const <String, dynamic>{},
      this.insuranceKnown = false,
      this.isOptingIn = false})
      : _trackingMeta = trackingMeta,
        _evidence = evidence,
        _cancellationMeta = cancellationMeta,
        _insuranceMeta = insuranceMeta,
        super._();

  final OrderModel order;

  /// Sedang mengirim aksi status (batal / konfirmasi terima / selesai /
  /// ajukan pembatalan / komplain).
  @JsonKey()
  final bool isSubmitting;
  final DataError? actionError;

  /// Resi & status pengiriman; `null` selama penjual belum membuat resi —
  /// atau kalau permintaannya gagal. Pelengkap, jadi kegagalannya tidak
  /// menggagalkan halaman.
  final OrderTrackingModel? tracking;

  /// `meta` respons tracking — membawa `mock_fields: [tracking_history]`
  /// selama riwayat kurir masih disimulasikan.
  final Map<String, dynamic> _trackingMeta;

  /// `meta` respons tracking — membawa `mock_fields: [tracking_history]`
  /// selama riwayat kurir masih disimulasikan.
  @JsonKey()
  Map<String, dynamic> get trackingMeta {
    if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_trackingMeta);
  }

  /// Bukti foto/video Secure+; kosong untuk pesanan biasa.
  final List<ShipmentEvidenceModel> _evidence;

  /// Bukti foto/video Secure+; kosong untuk pesanan biasa.
  @JsonKey()
  List<ShipmentEvidenceModel> get evidence {
    if (_evidence is EqualUnmodifiableListView) return _evidence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidence);
  }

  /// Permohonan pembatalan sesudah resi (docs/22 #3, endpoint diusulkan).
  final CancellationRequestModel? cancellationRequest;
  final Map<String, dynamic> _cancellationMeta;
  @JsonKey()
  Map<String, dynamic> get cancellationMeta {
    if (_cancellationMeta is EqualUnmodifiableMapView) return _cancellationMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_cancellationMeta);
  }

  /// `false` kalau `GET /orders/{id}/cancellation-request` belum ada di
  /// server (404 HTML) — mis. mock dimatikan. Layar lalu kembali ke
  /// penjelasan lama, alih-alih menawarkan formulir yang pasti gagal.
  @JsonKey()
  final bool cancellationSupported;

  /// Polis Secure+ pesanan ini, kalau ada.
  final InsurancePolicyModel? insurance;
  final Map<String, dynamic> _insuranceMeta;
  @JsonKey()
  Map<String, dynamic> get insuranceMeta {
    if (_insuranceMeta is EqualUnmodifiableMapView) return _insuranceMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_insuranceMeta);
  }

  /// Status polis berhasil diketahui. Tanpa `GET /orders/{id}/insurance`
  /// (endpoint diusulkan) aplikasi tidak tahu apakah perlindungan sudah
  /// aktif; kartu opt-in tetap ditawarkan, dengan risiko opt-in ganda
  /// ditolak server.
  @JsonKey()
  final bool insuranceKnown;

  /// Sedang mengaktifkan Secure+ (terpisah dari [isSubmitting] supaya
  /// tombol aksi status tidak ikut terkunci).
  @JsonKey()
  final bool isOptingIn;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderDetailLoadedCopyWith<OrderDetailLoaded> get copyWith =>
      _$OrderDetailLoadedCopyWithImpl<OrderDetailLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderDetailLoaded &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError) &&
            (identical(other.tracking, tracking) ||
                other.tracking == tracking) &&
            const DeepCollectionEquality()
                .equals(other._trackingMeta, _trackingMeta) &&
            const DeepCollectionEquality().equals(other._evidence, _evidence) &&
            (identical(other.cancellationRequest, cancellationRequest) ||
                other.cancellationRequest == cancellationRequest) &&
            const DeepCollectionEquality()
                .equals(other._cancellationMeta, _cancellationMeta) &&
            (identical(other.cancellationSupported, cancellationSupported) ||
                other.cancellationSupported == cancellationSupported) &&
            (identical(other.insurance, insurance) ||
                other.insurance == insurance) &&
            const DeepCollectionEquality()
                .equals(other._insuranceMeta, _insuranceMeta) &&
            (identical(other.insuranceKnown, insuranceKnown) ||
                other.insuranceKnown == insuranceKnown) &&
            (identical(other.isOptingIn, isOptingIn) ||
                other.isOptingIn == isOptingIn));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      order,
      isSubmitting,
      actionError,
      tracking,
      const DeepCollectionEquality().hash(_trackingMeta),
      const DeepCollectionEquality().hash(_evidence),
      cancellationRequest,
      const DeepCollectionEquality().hash(_cancellationMeta),
      cancellationSupported,
      insurance,
      const DeepCollectionEquality().hash(_insuranceMeta),
      insuranceKnown,
      isOptingIn);

  @override
  String toString() {
    return 'OrderDetailState.loaded(order: $order, isSubmitting: $isSubmitting, actionError: $actionError, tracking: $tracking, trackingMeta: $trackingMeta, evidence: $evidence, cancellationRequest: $cancellationRequest, cancellationMeta: $cancellationMeta, cancellationSupported: $cancellationSupported, insurance: $insurance, insuranceMeta: $insuranceMeta, insuranceKnown: $insuranceKnown, isOptingIn: $isOptingIn)';
  }
}

/// @nodoc
abstract mixin class $OrderDetailLoadedCopyWith<$Res>
    implements $OrderDetailStateCopyWith<$Res> {
  factory $OrderDetailLoadedCopyWith(
          OrderDetailLoaded value, $Res Function(OrderDetailLoaded) _then) =
      _$OrderDetailLoadedCopyWithImpl;
  @useResult
  $Res call(
      {OrderModel order,
      bool isSubmitting,
      DataError? actionError,
      OrderTrackingModel? tracking,
      Map<String, dynamic> trackingMeta,
      List<ShipmentEvidenceModel> evidence,
      CancellationRequestModel? cancellationRequest,
      Map<String, dynamic> cancellationMeta,
      bool cancellationSupported,
      InsurancePolicyModel? insurance,
      Map<String, dynamic> insuranceMeta,
      bool insuranceKnown,
      bool isOptingIn});

  $OrderModelCopyWith<$Res> get order;
  $OrderTrackingModelCopyWith<$Res>? get tracking;
  $CancellationRequestModelCopyWith<$Res>? get cancellationRequest;
  $InsurancePolicyModelCopyWith<$Res>? get insurance;
}

/// @nodoc
class _$OrderDetailLoadedCopyWithImpl<$Res>
    implements $OrderDetailLoadedCopyWith<$Res> {
  _$OrderDetailLoadedCopyWithImpl(this._self, this._then);

  final OrderDetailLoaded _self;
  final $Res Function(OrderDetailLoaded) _then;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? order = null,
    Object? isSubmitting = null,
    Object? actionError = freezed,
    Object? tracking = freezed,
    Object? trackingMeta = null,
    Object? evidence = null,
    Object? cancellationRequest = freezed,
    Object? cancellationMeta = null,
    Object? cancellationSupported = null,
    Object? insurance = freezed,
    Object? insuranceMeta = null,
    Object? insuranceKnown = null,
    Object? isOptingIn = null,
  }) {
    return _then(OrderDetailLoaded(
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderModel,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      tracking: freezed == tracking
          ? _self.tracking
          : tracking // ignore: cast_nullable_to_non_nullable
              as OrderTrackingModel?,
      trackingMeta: null == trackingMeta
          ? _self._trackingMeta
          : trackingMeta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      evidence: null == evidence
          ? _self._evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as List<ShipmentEvidenceModel>,
      cancellationRequest: freezed == cancellationRequest
          ? _self.cancellationRequest
          : cancellationRequest // ignore: cast_nullable_to_non_nullable
              as CancellationRequestModel?,
      cancellationMeta: null == cancellationMeta
          ? _self._cancellationMeta
          : cancellationMeta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      cancellationSupported: null == cancellationSupported
          ? _self.cancellationSupported
          : cancellationSupported // ignore: cast_nullable_to_non_nullable
              as bool,
      insurance: freezed == insurance
          ? _self.insurance
          : insurance // ignore: cast_nullable_to_non_nullable
              as InsurancePolicyModel?,
      insuranceMeta: null == insuranceMeta
          ? _self._insuranceMeta
          : insuranceMeta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      insuranceKnown: null == insuranceKnown
          ? _self.insuranceKnown
          : insuranceKnown // ignore: cast_nullable_to_non_nullable
              as bool,
      isOptingIn: null == isOptingIn
          ? _self.isOptingIn
          : isOptingIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<$Res> get order {
    return $OrderModelCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderTrackingModelCopyWith<$Res>? get tracking {
    if (_self.tracking == null) {
      return null;
    }

    return $OrderTrackingModelCopyWith<$Res>(_self.tracking!, (value) {
      return _then(_self.copyWith(tracking: value));
    });
  }

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CancellationRequestModelCopyWith<$Res>? get cancellationRequest {
    if (_self.cancellationRequest == null) {
      return null;
    }

    return $CancellationRequestModelCopyWith<$Res>(_self.cancellationRequest!,
        (value) {
      return _then(_self.copyWith(cancellationRequest: value));
    });
  }

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InsurancePolicyModelCopyWith<$Res>? get insurance {
    if (_self.insurance == null) {
      return null;
    }

    return $InsurancePolicyModelCopyWith<$Res>(_self.insurance!, (value) {
      return _then(_self.copyWith(insurance: value));
    });
  }
}

/// @nodoc

class OrderDetailError extends OrderDetailState {
  const OrderDetailError(this.error) : super._();

  final DataError error;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderDetailErrorCopyWith<OrderDetailError> get copyWith =>
      _$OrderDetailErrorCopyWithImpl<OrderDetailError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderDetailError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'OrderDetailState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $OrderDetailErrorCopyWith<$Res>
    implements $OrderDetailStateCopyWith<$Res> {
  factory $OrderDetailErrorCopyWith(
          OrderDetailError value, $Res Function(OrderDetailError) _then) =
      _$OrderDetailErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$OrderDetailErrorCopyWithImpl<$Res>
    implements $OrderDetailErrorCopyWith<$Res> {
  _$OrderDetailErrorCopyWithImpl(this._self, this._then);

  final OrderDetailError _self;
  final $Res Function(OrderDetailError) _then;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(OrderDetailError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
