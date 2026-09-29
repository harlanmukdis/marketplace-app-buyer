// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewFormState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReviewFormState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReviewFormState()';
  }
}

/// @nodoc
class $ReviewFormStateCopyWith<$Res> {
  $ReviewFormStateCopyWith(
      ReviewFormState _, $Res Function(ReviewFormState) __);
}

/// Adds pattern-matching-related methods to [ReviewFormState].
extension ReviewFormStatePatterns on ReviewFormState {
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
    TResult Function(ReviewFormLoading value)? loading,
    TResult Function(ReviewFormReady value)? ready,
    TResult Function(ReviewFormError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ReviewFormLoading() when loading != null:
        return loading(_that);
      case ReviewFormReady() when ready != null:
        return ready(_that);
      case ReviewFormError() when error != null:
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
    required TResult Function(ReviewFormLoading value) loading,
    required TResult Function(ReviewFormReady value) ready,
    required TResult Function(ReviewFormError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case ReviewFormLoading():
        return loading(_that);
      case ReviewFormReady():
        return ready(_that);
      case ReviewFormError():
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
    TResult? Function(ReviewFormLoading value)? loading,
    TResult? Function(ReviewFormReady value)? ready,
    TResult? Function(ReviewFormError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ReviewFormLoading() when loading != null:
        return loading(_that);
      case ReviewFormReady() when ready != null:
        return ready(_that);
      case ReviewFormError() when error != null:
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
            String productName,
            String optionLabel,
            int storeId,
            MyReviewModel? editing,
            int rating,
            String comment,
            bool isAnonymous,
            bool isSubmitting,
            DataError? submitError,
            bool submitted,
            MyReviewModel? updated)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ReviewFormLoading() when loading != null:
        return loading();
      case ReviewFormReady() when ready != null:
        return ready(
            _that.productName,
            _that.optionLabel,
            _that.storeId,
            _that.editing,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.isSubmitting,
            _that.submitError,
            _that.submitted,
            _that.updated);
      case ReviewFormError() when error != null:
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
            String productName,
            String optionLabel,
            int storeId,
            MyReviewModel? editing,
            int rating,
            String comment,
            bool isAnonymous,
            bool isSubmitting,
            DataError? submitError,
            bool submitted,
            MyReviewModel? updated)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case ReviewFormLoading():
        return loading();
      case ReviewFormReady():
        return ready(
            _that.productName,
            _that.optionLabel,
            _that.storeId,
            _that.editing,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.isSubmitting,
            _that.submitError,
            _that.submitted,
            _that.updated);
      case ReviewFormError():
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
            String productName,
            String optionLabel,
            int storeId,
            MyReviewModel? editing,
            int rating,
            String comment,
            bool isAnonymous,
            bool isSubmitting,
            DataError? submitError,
            bool submitted,
            MyReviewModel? updated)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ReviewFormLoading() when loading != null:
        return loading();
      case ReviewFormReady() when ready != null:
        return ready(
            _that.productName,
            _that.optionLabel,
            _that.storeId,
            _that.editing,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.isSubmitting,
            _that.submitError,
            _that.submitted,
            _that.updated);
      case ReviewFormError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ReviewFormLoading extends ReviewFormState {
  const ReviewFormLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReviewFormLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReviewFormState.loading()';
  }
}

/// @nodoc

class ReviewFormReady extends ReviewFormState {
  const ReviewFormReady(
      {required this.productName,
      this.optionLabel = '',
      this.storeId = 0,
      this.editing,
      this.rating = 5,
      this.comment = '',
      this.isAnonymous = false,
      this.isSubmitting = false,
      this.submitError,
      this.submitted = false,
      this.updated})
      : super._();

  /// Snapshot dari baris pesanan (ulasan baru) atau dari `GET /me/reviews`
  /// (ubah ulasan) — dua sumber, jadi yang disimpan hanya yang dibutuhkan
  /// layar, bukan `OrderModel`.
  final String productName;
  @JsonKey()
  final String optionLabel;
  @JsonKey()
  final int storeId;

  /// Ulasan yang sedang diubah; `null` untuk ulasan baru.
  final MyReviewModel? editing;

  /// Default 5, seperti desain.
  @JsonKey()
  final int rating;
  @JsonKey()
  final String comment;
  @JsonKey()
  final bool isAnonymous;
  @JsonKey()
  final bool isSubmitting;
  final DataError? submitError;

  /// Ulasan diterima server. Layar menutup diri begitu ini `true`.
  @JsonKey()
  final bool submitted;

  /// Hasil `PATCH /reviews/{id}` (mode ubah), dikembalikan layar lewat
  /// `pop` supaya "Ulasan Saya" bisa mengganti barisnya tanpa memuat ulang.
  final MyReviewModel? updated;

  /// Create a copy of ReviewFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewFormReadyCopyWith<ReviewFormReady> get copyWith =>
      _$ReviewFormReadyCopyWithImpl<ReviewFormReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewFormReady &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.optionLabel, optionLabel) ||
                other.optionLabel == optionLabel) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.editing, editing) || other.editing == editing) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError) &&
            (identical(other.submitted, submitted) ||
                other.submitted == submitted) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      productName,
      optionLabel,
      storeId,
      editing,
      rating,
      comment,
      isAnonymous,
      isSubmitting,
      submitError,
      submitted,
      updated);

  @override
  String toString() {
    return 'ReviewFormState.ready(productName: $productName, optionLabel: $optionLabel, storeId: $storeId, editing: $editing, rating: $rating, comment: $comment, isAnonymous: $isAnonymous, isSubmitting: $isSubmitting, submitError: $submitError, submitted: $submitted, updated: $updated)';
  }
}

/// @nodoc
abstract mixin class $ReviewFormReadyCopyWith<$Res>
    implements $ReviewFormStateCopyWith<$Res> {
  factory $ReviewFormReadyCopyWith(
          ReviewFormReady value, $Res Function(ReviewFormReady) _then) =
      _$ReviewFormReadyCopyWithImpl;
  @useResult
  $Res call(
      {String productName,
      String optionLabel,
      int storeId,
      MyReviewModel? editing,
      int rating,
      String comment,
      bool isAnonymous,
      bool isSubmitting,
      DataError? submitError,
      bool submitted,
      MyReviewModel? updated});

  $MyReviewModelCopyWith<$Res>? get editing;
  $MyReviewModelCopyWith<$Res>? get updated;
}

/// @nodoc
class _$ReviewFormReadyCopyWithImpl<$Res>
    implements $ReviewFormReadyCopyWith<$Res> {
  _$ReviewFormReadyCopyWithImpl(this._self, this._then);

  final ReviewFormReady _self;
  final $Res Function(ReviewFormReady) _then;

  /// Create a copy of ReviewFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? productName = null,
    Object? optionLabel = null,
    Object? storeId = null,
    Object? editing = freezed,
    Object? rating = null,
    Object? comment = null,
    Object? isAnonymous = null,
    Object? isSubmitting = null,
    Object? submitError = freezed,
    Object? submitted = null,
    Object? updated = freezed,
  }) {
    return _then(ReviewFormReady(
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      optionLabel: null == optionLabel
          ? _self.optionLabel
          : optionLabel // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      editing: freezed == editing
          ? _self.editing
          : editing // ignore: cast_nullable_to_non_nullable
              as MyReviewModel?,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: null == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      isAnonymous: null == isAnonymous
          ? _self.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      submitError: freezed == submitError
          ? _self.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as DataError?,
      submitted: null == submitted
          ? _self.submitted
          : submitted // ignore: cast_nullable_to_non_nullable
              as bool,
      updated: freezed == updated
          ? _self.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as MyReviewModel?,
    ));
  }

  /// Create a copy of ReviewFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MyReviewModelCopyWith<$Res>? get editing {
    if (_self.editing == null) {
      return null;
    }

    return $MyReviewModelCopyWith<$Res>(_self.editing!, (value) {
      return _then(_self.copyWith(editing: value));
    });
  }

  /// Create a copy of ReviewFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MyReviewModelCopyWith<$Res>? get updated {
    if (_self.updated == null) {
      return null;
    }

    return $MyReviewModelCopyWith<$Res>(_self.updated!, (value) {
      return _then(_self.copyWith(updated: value));
    });
  }
}

/// @nodoc

class ReviewFormError extends ReviewFormState {
  const ReviewFormError(this.error) : super._();

  final DataError error;

  /// Create a copy of ReviewFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewFormErrorCopyWith<ReviewFormError> get copyWith =>
      _$ReviewFormErrorCopyWithImpl<ReviewFormError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewFormError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'ReviewFormState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $ReviewFormErrorCopyWith<$Res>
    implements $ReviewFormStateCopyWith<$Res> {
  factory $ReviewFormErrorCopyWith(
          ReviewFormError value, $Res Function(ReviewFormError) _then) =
      _$ReviewFormErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$ReviewFormErrorCopyWithImpl<$Res>
    implements $ReviewFormErrorCopyWith<$Res> {
  _$ReviewFormErrorCopyWithImpl(this._self, this._then);

  final ReviewFormError _self;
  final $Res Function(ReviewFormError) _then;

  /// Create a copy of ReviewFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(ReviewFormError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
