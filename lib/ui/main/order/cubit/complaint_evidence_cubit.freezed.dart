// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint_evidence_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EvidenceAttachment {
  int get localId;
  String get fileName;
  String get mimeType;
  Uint8List get bytes;
  double get progress;
  bool get uploading;

  /// Hasil `POST /media/upload`; `null` selama belum berhasil.
  String? get url;
  DataError? get error;

  /// Create a copy of EvidenceAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EvidenceAttachmentCopyWith<EvidenceAttachment> get copyWith =>
      _$EvidenceAttachmentCopyWithImpl<EvidenceAttachment>(
          this as EvidenceAttachment, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EvidenceAttachment &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            const DeepCollectionEquality().equals(other.bytes, bytes) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.uploading, uploading) ||
                other.uploading == uploading) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      localId,
      fileName,
      mimeType,
      const DeepCollectionEquality().hash(bytes),
      progress,
      uploading,
      url,
      error);

  @override
  String toString() {
    return 'EvidenceAttachment(localId: $localId, fileName: $fileName, mimeType: $mimeType, bytes: $bytes, progress: $progress, uploading: $uploading, url: $url, error: $error)';
  }
}

/// @nodoc
abstract mixin class $EvidenceAttachmentCopyWith<$Res> {
  factory $EvidenceAttachmentCopyWith(
          EvidenceAttachment value, $Res Function(EvidenceAttachment) _then) =
      _$EvidenceAttachmentCopyWithImpl;
  @useResult
  $Res call(
      {int localId,
      String fileName,
      String mimeType,
      Uint8List bytes,
      double progress,
      bool uploading,
      String? url,
      DataError? error});
}

/// @nodoc
class _$EvidenceAttachmentCopyWithImpl<$Res>
    implements $EvidenceAttachmentCopyWith<$Res> {
  _$EvidenceAttachmentCopyWithImpl(this._self, this._then);

  final EvidenceAttachment _self;
  final $Res Function(EvidenceAttachment) _then;

  /// Create a copy of EvidenceAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? bytes = null,
    Object? progress = null,
    Object? uploading = null,
    Object? url = freezed,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      localId: null == localId
          ? _self.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as int,
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      bytes: null == bytes
          ? _self.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      uploading: null == uploading
          ? _self.uploading
          : uploading // ignore: cast_nullable_to_non_nullable
              as bool,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// Adds pattern-matching-related methods to [EvidenceAttachment].
extension EvidenceAttachmentPatterns on EvidenceAttachment {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_EvidenceAttachment value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EvidenceAttachment() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_EvidenceAttachment value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EvidenceAttachment():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_EvidenceAttachment value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EvidenceAttachment() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int localId,
            String fileName,
            String mimeType,
            Uint8List bytes,
            double progress,
            bool uploading,
            String? url,
            DataError? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EvidenceAttachment() when $default != null:
        return $default(
            _that.localId,
            _that.fileName,
            _that.mimeType,
            _that.bytes,
            _that.progress,
            _that.uploading,
            _that.url,
            _that.error);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            int localId,
            String fileName,
            String mimeType,
            Uint8List bytes,
            double progress,
            bool uploading,
            String? url,
            DataError? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EvidenceAttachment():
        return $default(
            _that.localId,
            _that.fileName,
            _that.mimeType,
            _that.bytes,
            _that.progress,
            _that.uploading,
            _that.url,
            _that.error);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int localId,
            String fileName,
            String mimeType,
            Uint8List bytes,
            double progress,
            bool uploading,
            String? url,
            DataError? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EvidenceAttachment() when $default != null:
        return $default(
            _that.localId,
            _that.fileName,
            _that.mimeType,
            _that.bytes,
            _that.progress,
            _that.uploading,
            _that.url,
            _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _EvidenceAttachment extends EvidenceAttachment {
  const _EvidenceAttachment(
      {required this.localId,
      required this.fileName,
      required this.mimeType,
      required this.bytes,
      this.progress = 0,
      this.uploading = false,
      this.url,
      this.error})
      : super._();

  @override
  final int localId;
  @override
  final String fileName;
  @override
  final String mimeType;
  @override
  final Uint8List bytes;
  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final bool uploading;

  /// Hasil `POST /media/upload`; `null` selama belum berhasil.
  @override
  final String? url;
  @override
  final DataError? error;

  /// Create a copy of EvidenceAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EvidenceAttachmentCopyWith<_EvidenceAttachment> get copyWith =>
      __$EvidenceAttachmentCopyWithImpl<_EvidenceAttachment>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EvidenceAttachment &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            const DeepCollectionEquality().equals(other.bytes, bytes) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.uploading, uploading) ||
                other.uploading == uploading) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      localId,
      fileName,
      mimeType,
      const DeepCollectionEquality().hash(bytes),
      progress,
      uploading,
      url,
      error);

  @override
  String toString() {
    return 'EvidenceAttachment(localId: $localId, fileName: $fileName, mimeType: $mimeType, bytes: $bytes, progress: $progress, uploading: $uploading, url: $url, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$EvidenceAttachmentCopyWith<$Res>
    implements $EvidenceAttachmentCopyWith<$Res> {
  factory _$EvidenceAttachmentCopyWith(
          _EvidenceAttachment value, $Res Function(_EvidenceAttachment) _then) =
      __$EvidenceAttachmentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int localId,
      String fileName,
      String mimeType,
      Uint8List bytes,
      double progress,
      bool uploading,
      String? url,
      DataError? error});
}

/// @nodoc
class __$EvidenceAttachmentCopyWithImpl<$Res>
    implements _$EvidenceAttachmentCopyWith<$Res> {
  __$EvidenceAttachmentCopyWithImpl(this._self, this._then);

  final _EvidenceAttachment _self;
  final $Res Function(_EvidenceAttachment) _then;

  /// Create a copy of EvidenceAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? localId = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? bytes = null,
    Object? progress = null,
    Object? uploading = null,
    Object? url = freezed,
    Object? error = freezed,
  }) {
    return _then(_EvidenceAttachment(
      localId: null == localId
          ? _self.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as int,
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      bytes: null == bytes
          ? _self.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      uploading: null == uploading
          ? _self.uploading
          : uploading // ignore: cast_nullable_to_non_nullable
              as bool,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc
mixin _$ComplaintEvidenceState {
  List<EvidenceAttachment> get items;

  /// Berkas yang ditolak saat dipilih (format/ukuran/jumlah). Validasi
  /// lokal, jadi `message`-nya boleh tampil.
  DataError? get pickError;

  /// Create a copy of ComplaintEvidenceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ComplaintEvidenceStateCopyWith<ComplaintEvidenceState> get copyWith =>
      _$ComplaintEvidenceStateCopyWithImpl<ComplaintEvidenceState>(
          this as ComplaintEvidenceState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ComplaintEvidenceState &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.pickError, pickError) ||
                other.pickError == pickError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), pickError);

  @override
  String toString() {
    return 'ComplaintEvidenceState(items: $items, pickError: $pickError)';
  }
}

/// @nodoc
abstract mixin class $ComplaintEvidenceStateCopyWith<$Res> {
  factory $ComplaintEvidenceStateCopyWith(ComplaintEvidenceState value,
          $Res Function(ComplaintEvidenceState) _then) =
      _$ComplaintEvidenceStateCopyWithImpl;
  @useResult
  $Res call({List<EvidenceAttachment> items, DataError? pickError});
}

/// @nodoc
class _$ComplaintEvidenceStateCopyWithImpl<$Res>
    implements $ComplaintEvidenceStateCopyWith<$Res> {
  _$ComplaintEvidenceStateCopyWithImpl(this._self, this._then);

  final ComplaintEvidenceState _self;
  final $Res Function(ComplaintEvidenceState) _then;

  /// Create a copy of ComplaintEvidenceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? pickError = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<EvidenceAttachment>,
      pickError: freezed == pickError
          ? _self.pickError
          : pickError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ComplaintEvidenceState].
extension ComplaintEvidenceStatePatterns on ComplaintEvidenceState {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ComplaintEvidenceState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComplaintEvidenceState() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_ComplaintEvidenceState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComplaintEvidenceState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ComplaintEvidenceState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComplaintEvidenceState() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<EvidenceAttachment> items, DataError? pickError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ComplaintEvidenceState() when $default != null:
        return $default(_that.items, _that.pickError);
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
  TResult when<TResult extends Object?>(
    TResult Function(List<EvidenceAttachment> items, DataError? pickError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComplaintEvidenceState():
        return $default(_that.items, _that.pickError);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<EvidenceAttachment> items, DataError? pickError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ComplaintEvidenceState() when $default != null:
        return $default(_that.items, _that.pickError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ComplaintEvidenceState extends ComplaintEvidenceState {
  const _ComplaintEvidenceState(
      {final List<EvidenceAttachment> items = const <EvidenceAttachment>[],
      this.pickError})
      : _items = items,
        super._();

  final List<EvidenceAttachment> _items;
  @override
  @JsonKey()
  List<EvidenceAttachment> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Berkas yang ditolak saat dipilih (format/ukuran/jumlah). Validasi
  /// lokal, jadi `message`-nya boleh tampil.
  @override
  final DataError? pickError;

  /// Create a copy of ComplaintEvidenceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ComplaintEvidenceStateCopyWith<_ComplaintEvidenceState> get copyWith =>
      __$ComplaintEvidenceStateCopyWithImpl<_ComplaintEvidenceState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ComplaintEvidenceState &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.pickError, pickError) ||
                other.pickError == pickError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), pickError);

  @override
  String toString() {
    return 'ComplaintEvidenceState(items: $items, pickError: $pickError)';
  }
}

/// @nodoc
abstract mixin class _$ComplaintEvidenceStateCopyWith<$Res>
    implements $ComplaintEvidenceStateCopyWith<$Res> {
  factory _$ComplaintEvidenceStateCopyWith(_ComplaintEvidenceState value,
          $Res Function(_ComplaintEvidenceState) _then) =
      __$ComplaintEvidenceStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<EvidenceAttachment> items, DataError? pickError});
}

/// @nodoc
class __$ComplaintEvidenceStateCopyWithImpl<$Res>
    implements _$ComplaintEvidenceStateCopyWith<$Res> {
  __$ComplaintEvidenceStateCopyWithImpl(this._self, this._then);

  final _ComplaintEvidenceState _self;
  final $Res Function(_ComplaintEvidenceState) _then;

  /// Create a copy of ComplaintEvidenceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? pickError = freezed,
  }) {
    return _then(_ComplaintEvidenceState(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<EvidenceAttachment>,
      pickError: freezed == pickError
          ? _self.pickError
          : pickError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

// dart format on
