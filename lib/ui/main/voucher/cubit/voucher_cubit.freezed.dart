// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoucherState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VoucherState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VoucherState()';
  }
}

/// @nodoc
class $VoucherStateCopyWith<$Res> {
  $VoucherStateCopyWith(VoucherState _, $Res Function(VoucherState) __);
}

/// Adds pattern-matching-related methods to [VoucherState].
extension VoucherStatePatterns on VoucherState {
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
    TResult Function(VoucherLoading value)? loading,
    TResult Function(VoucherReady value)? ready,
    TResult Function(VoucherError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case VoucherLoading() when loading != null:
        return loading(_that);
      case VoucherReady() when ready != null:
        return ready(_that);
      case VoucherError() when error != null:
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
    required TResult Function(VoucherLoading value) loading,
    required TResult Function(VoucherReady value) ready,
    required TResult Function(VoucherError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case VoucherLoading():
        return loading(_that);
      case VoucherReady():
        return ready(_that);
      case VoucherError():
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
    TResult? Function(VoucherLoading value)? loading,
    TResult? Function(VoucherReady value)? ready,
    TResult? Function(VoucherError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case VoucherLoading() when loading != null:
        return loading(_that);
      case VoucherReady() when ready != null:
        return ready(_that);
      case VoucherError() when error != null:
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
            CartSummaryModel summary,
            List<VoucherModel> claimed,
            DataError? claimedError,
            List<AppliedVoucherModel> recommended,
            DataError? recommendedError,
            String? busyCode,
            bool autoApplying,
            DataError? actionError,
            String? notice)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case VoucherLoading() when loading != null:
        return loading();
      case VoucherReady() when ready != null:
        return ready(
            _that.summary,
            _that.claimed,
            _that.claimedError,
            _that.recommended,
            _that.recommendedError,
            _that.busyCode,
            _that.autoApplying,
            _that.actionError,
            _that.notice);
      case VoucherError() when error != null:
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
            CartSummaryModel summary,
            List<VoucherModel> claimed,
            DataError? claimedError,
            List<AppliedVoucherModel> recommended,
            DataError? recommendedError,
            String? busyCode,
            bool autoApplying,
            DataError? actionError,
            String? notice)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case VoucherLoading():
        return loading();
      case VoucherReady():
        return ready(
            _that.summary,
            _that.claimed,
            _that.claimedError,
            _that.recommended,
            _that.recommendedError,
            _that.busyCode,
            _that.autoApplying,
            _that.actionError,
            _that.notice);
      case VoucherError():
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
            CartSummaryModel summary,
            List<VoucherModel> claimed,
            DataError? claimedError,
            List<AppliedVoucherModel> recommended,
            DataError? recommendedError,
            String? busyCode,
            bool autoApplying,
            DataError? actionError,
            String? notice)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case VoucherLoading() when loading != null:
        return loading();
      case VoucherReady() when ready != null:
        return ready(
            _that.summary,
            _that.claimed,
            _that.claimedError,
            _that.recommended,
            _that.recommendedError,
            _that.busyCode,
            _that.autoApplying,
            _that.actionError,
            _that.notice);
      case VoucherError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class VoucherLoading extends VoucherState {
  const VoucherLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VoucherLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VoucherState.loading()';
  }
}

/// @nodoc

class VoucherReady extends VoucherState {
  const VoucherReady(
      {required this.summary,
      final List<VoucherModel> claimed = const <VoucherModel>[],
      this.claimedError,
      final List<AppliedVoucherModel> recommended =
          const <AppliedVoucherModel>[],
      this.recommendedError,
      this.busyCode,
      this.autoApplying = false,
      this.actionError,
      this.notice})
      : _claimed = claimed,
        _recommended = recommended,
        super._();

  /// Ringkasan keranjang: `vouchers` yang terpasang + `item_count` baris
  /// tercentang.
  final CartSummaryModel summary;
  final List<VoucherModel> _claimed;
  @JsonKey()
  List<VoucherModel> get claimed {
    if (_claimed is EqualUnmodifiableListView) return _claimed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_claimed);
  }

  final DataError? claimedError;

  /// Kosong — dan **tidak diminta** — selama tidak ada baris tercentang:
  /// servernya membalas 500 untuk keranjang kosong.
  final List<AppliedVoucherModel> _recommended;

  /// Kosong — dan **tidak diminta** — selama tidak ada baris tercentang:
  /// servernya membalas 500 untuk keranjang kosong.
  @JsonKey()
  List<AppliedVoucherModel> get recommended {
    if (_recommended is EqualUnmodifiableListView) return _recommended;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommended);
  }

  final DataError? recommendedError;

  /// Kode yang sedang dipasang/dilepas/diklaim, untuk mengunci tombolnya
  /// saja.
  final String? busyCode;
  @JsonKey()
  final bool autoApplying;
  final DataError? actionError;

  /// Kalimat sukses sekali tampil (snackbar), mis. "Voucher dipasang".
  final String? notice;

  /// Create a copy of VoucherState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VoucherReadyCopyWith<VoucherReady> get copyWith =>
      _$VoucherReadyCopyWithImpl<VoucherReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VoucherReady &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._claimed, _claimed) &&
            (identical(other.claimedError, claimedError) ||
                other.claimedError == claimedError) &&
            const DeepCollectionEquality()
                .equals(other._recommended, _recommended) &&
            (identical(other.recommendedError, recommendedError) ||
                other.recommendedError == recommendedError) &&
            (identical(other.busyCode, busyCode) ||
                other.busyCode == busyCode) &&
            (identical(other.autoApplying, autoApplying) ||
                other.autoApplying == autoApplying) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError) &&
            (identical(other.notice, notice) || other.notice == notice));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_claimed),
      claimedError,
      const DeepCollectionEquality().hash(_recommended),
      recommendedError,
      busyCode,
      autoApplying,
      actionError,
      notice);

  @override
  String toString() {
    return 'VoucherState.ready(summary: $summary, claimed: $claimed, claimedError: $claimedError, recommended: $recommended, recommendedError: $recommendedError, busyCode: $busyCode, autoApplying: $autoApplying, actionError: $actionError, notice: $notice)';
  }
}

/// @nodoc
abstract mixin class $VoucherReadyCopyWith<$Res>
    implements $VoucherStateCopyWith<$Res> {
  factory $VoucherReadyCopyWith(
          VoucherReady value, $Res Function(VoucherReady) _then) =
      _$VoucherReadyCopyWithImpl;
  @useResult
  $Res call(
      {CartSummaryModel summary,
      List<VoucherModel> claimed,
      DataError? claimedError,
      List<AppliedVoucherModel> recommended,
      DataError? recommendedError,
      String? busyCode,
      bool autoApplying,
      DataError? actionError,
      String? notice});

  $CartSummaryModelCopyWith<$Res> get summary;
}

/// @nodoc
class _$VoucherReadyCopyWithImpl<$Res> implements $VoucherReadyCopyWith<$Res> {
  _$VoucherReadyCopyWithImpl(this._self, this._then);

  final VoucherReady _self;
  final $Res Function(VoucherReady) _then;

  /// Create a copy of VoucherState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? summary = null,
    Object? claimed = null,
    Object? claimedError = freezed,
    Object? recommended = null,
    Object? recommendedError = freezed,
    Object? busyCode = freezed,
    Object? autoApplying = null,
    Object? actionError = freezed,
    Object? notice = freezed,
  }) {
    return _then(VoucherReady(
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as CartSummaryModel,
      claimed: null == claimed
          ? _self._claimed
          : claimed // ignore: cast_nullable_to_non_nullable
              as List<VoucherModel>,
      claimedError: freezed == claimedError
          ? _self.claimedError
          : claimedError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      recommended: null == recommended
          ? _self._recommended
          : recommended // ignore: cast_nullable_to_non_nullable
              as List<AppliedVoucherModel>,
      recommendedError: freezed == recommendedError
          ? _self.recommendedError
          : recommendedError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      busyCode: freezed == busyCode
          ? _self.busyCode
          : busyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      autoApplying: null == autoApplying
          ? _self.autoApplying
          : autoApplying // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      notice: freezed == notice
          ? _self.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of VoucherState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartSummaryModelCopyWith<$Res> get summary {
    return $CartSummaryModelCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc

class VoucherError extends VoucherState {
  const VoucherError(this.error) : super._();

  final DataError error;

  /// Create a copy of VoucherState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VoucherErrorCopyWith<VoucherError> get copyWith =>
      _$VoucherErrorCopyWithImpl<VoucherError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VoucherError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'VoucherState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $VoucherErrorCopyWith<$Res>
    implements $VoucherStateCopyWith<$Res> {
  factory $VoucherErrorCopyWith(
          VoucherError value, $Res Function(VoucherError) _then) =
      _$VoucherErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$VoucherErrorCopyWithImpl<$Res> implements $VoucherErrorCopyWith<$Res> {
  _$VoucherErrorCopyWithImpl(this._self, this._then);

  final VoucherError _self;
  final $Res Function(VoucherError) _then;

  /// Create a copy of VoucherState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(VoucherError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
