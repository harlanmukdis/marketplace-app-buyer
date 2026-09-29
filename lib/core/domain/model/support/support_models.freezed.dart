// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportTicketModel {
  @IntJson()
  int get id;
  @StringJson()
  @JsonKey(name: 'ticket_number')
  String get ticketNumber;
  @StringJson()
  String get category;
  @StringJson()
  String get subject;
  @StringOrNullJson()
  String? get description;
  @IntOrNullJson()
  @JsonKey(name: 'related_order_id')
  int? get relatedOrderId;

  /// `open`, `in_progress`, `resolved`, `closed`.
  @StringJson()
  String get status;
  @ServerDateTimeJson()
  @JsonKey(name: 'resolved_at')
  DateTime? get resolvedAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportTicketModelCopyWith<SupportTicketModel> get copyWith =>
      _$SupportTicketModelCopyWithImpl<SupportTicketModel>(
          this as SupportTicketModel, _$identity);

  /// Serializes this SupportTicketModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupportTicketModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketNumber, ticketNumber) ||
                other.ticketNumber == ticketNumber) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.relatedOrderId, relatedOrderId) ||
                other.relatedOrderId == relatedOrderId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ticketNumber, category,
      subject, description, relatedOrderId, status, resolvedAt, createdAt);

  @override
  String toString() {
    return 'SupportTicketModel(id: $id, ticketNumber: $ticketNumber, category: $category, subject: $subject, description: $description, relatedOrderId: $relatedOrderId, status: $status, resolvedAt: $resolvedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $SupportTicketModelCopyWith<$Res> {
  factory $SupportTicketModelCopyWith(
          SupportTicketModel value, $Res Function(SupportTicketModel) _then) =
      _$SupportTicketModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'ticket_number') String ticketNumber,
      @StringJson() String category,
      @StringJson() String subject,
      @StringOrNullJson() String? description,
      @IntOrNullJson() @JsonKey(name: 'related_order_id') int? relatedOrderId,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$SupportTicketModelCopyWithImpl<$Res>
    implements $SupportTicketModelCopyWith<$Res> {
  _$SupportTicketModelCopyWithImpl(this._self, this._then);

  final SupportTicketModel _self;
  final $Res Function(SupportTicketModel) _then;

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketNumber = null,
    Object? category = null,
    Object? subject = null,
    Object? description = freezed,
    Object? relatedOrderId = freezed,
    Object? status = null,
    Object? resolvedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      ticketNumber: null == ticketNumber
          ? _self.ticketNumber
          : ticketNumber // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _self.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedOrderId: freezed == relatedOrderId
          ? _self.relatedOrderId
          : relatedOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      resolvedAt: freezed == resolvedAt
          ? _self.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SupportTicketModel].
extension SupportTicketModelPatterns on SupportTicketModel {
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
    TResult Function(_SupportTicketModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupportTicketModel() when $default != null:
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
    TResult Function(_SupportTicketModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportTicketModel():
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
    TResult? Function(_SupportTicketModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportTicketModel() when $default != null:
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
            @IntJson() int id,
            @StringJson() @JsonKey(name: 'ticket_number') String ticketNumber,
            @StringJson() String category,
            @StringJson() String subject,
            @StringOrNullJson() String? description,
            @IntOrNullJson()
            @JsonKey(name: 'related_order_id')
            int? relatedOrderId,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'resolved_at')
            DateTime? resolvedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupportTicketModel() when $default != null:
        return $default(
            _that.id,
            _that.ticketNumber,
            _that.category,
            _that.subject,
            _that.description,
            _that.relatedOrderId,
            _that.status,
            _that.resolvedAt,
            _that.createdAt);
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
            @IntJson() int id,
            @StringJson() @JsonKey(name: 'ticket_number') String ticketNumber,
            @StringJson() String category,
            @StringJson() String subject,
            @StringOrNullJson() String? description,
            @IntOrNullJson()
            @JsonKey(name: 'related_order_id')
            int? relatedOrderId,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'resolved_at')
            DateTime? resolvedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportTicketModel():
        return $default(
            _that.id,
            _that.ticketNumber,
            _that.category,
            _that.subject,
            _that.description,
            _that.relatedOrderId,
            _that.status,
            _that.resolvedAt,
            _that.createdAt);
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
            @IntJson() int id,
            @StringJson() @JsonKey(name: 'ticket_number') String ticketNumber,
            @StringJson() String category,
            @StringJson() String subject,
            @StringOrNullJson() String? description,
            @IntOrNullJson()
            @JsonKey(name: 'related_order_id')
            int? relatedOrderId,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'resolved_at')
            DateTime? resolvedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportTicketModel() when $default != null:
        return $default(
            _that.id,
            _that.ticketNumber,
            _that.category,
            _that.subject,
            _that.description,
            _that.relatedOrderId,
            _that.status,
            _that.resolvedAt,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SupportTicketModel extends SupportTicketModel {
  const _SupportTicketModel(
      {@IntJson() required this.id,
      @StringJson() @JsonKey(name: 'ticket_number') this.ticketNumber = '',
      @StringJson() this.category = '',
      @StringJson() this.subject = '',
      @StringOrNullJson() this.description,
      @IntOrNullJson() @JsonKey(name: 'related_order_id') this.relatedOrderId,
      @StringJson() this.status = 'open',
      @ServerDateTimeJson() @JsonKey(name: 'resolved_at') this.resolvedAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @StringJson()
  @JsonKey(name: 'ticket_number')
  final String ticketNumber;
  @override
  @JsonKey()
  @StringJson()
  final String category;
  @override
  @JsonKey()
  @StringJson()
  final String subject;
  @override
  @StringOrNullJson()
  final String? description;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'related_order_id')
  final int? relatedOrderId;

  /// `open`, `in_progress`, `resolved`, `closed`.
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'resolved_at')
  final DateTime? resolvedAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SupportTicketModelCopyWith<_SupportTicketModel> get copyWith =>
      __$SupportTicketModelCopyWithImpl<_SupportTicketModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SupportTicketModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SupportTicketModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketNumber, ticketNumber) ||
                other.ticketNumber == ticketNumber) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.relatedOrderId, relatedOrderId) ||
                other.relatedOrderId == relatedOrderId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ticketNumber, category,
      subject, description, relatedOrderId, status, resolvedAt, createdAt);

  @override
  String toString() {
    return 'SupportTicketModel(id: $id, ticketNumber: $ticketNumber, category: $category, subject: $subject, description: $description, relatedOrderId: $relatedOrderId, status: $status, resolvedAt: $resolvedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$SupportTicketModelCopyWith<$Res>
    implements $SupportTicketModelCopyWith<$Res> {
  factory _$SupportTicketModelCopyWith(
          _SupportTicketModel value, $Res Function(_SupportTicketModel) _then) =
      __$SupportTicketModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @StringJson() @JsonKey(name: 'ticket_number') String ticketNumber,
      @StringJson() String category,
      @StringJson() String subject,
      @StringOrNullJson() String? description,
      @IntOrNullJson() @JsonKey(name: 'related_order_id') int? relatedOrderId,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$SupportTicketModelCopyWithImpl<$Res>
    implements _$SupportTicketModelCopyWith<$Res> {
  __$SupportTicketModelCopyWithImpl(this._self, this._then);

  final _SupportTicketModel _self;
  final $Res Function(_SupportTicketModel) _then;

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? ticketNumber = null,
    Object? category = null,
    Object? subject = null,
    Object? description = freezed,
    Object? relatedOrderId = freezed,
    Object? status = null,
    Object? resolvedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_SupportTicketModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      ticketNumber: null == ticketNumber
          ? _self.ticketNumber
          : ticketNumber // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _self.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedOrderId: freezed == relatedOrderId
          ? _self.relatedOrderId
          : relatedOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      resolvedAt: freezed == resolvedAt
          ? _self.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$SupportMessageModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'sender_user_id')
  int get senderUserId;
  @BoolJson()
  @JsonKey(name: 'is_admin_reply')
  bool get isAdminReply;
  @StringJson()
  String get message;
  @StringOrNullJson()
  @JsonKey(name: 'attachment_url')
  String? get attachmentUrl;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of SupportMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportMessageModelCopyWith<SupportMessageModel> get copyWith =>
      _$SupportMessageModelCopyWithImpl<SupportMessageModel>(
          this as SupportMessageModel, _$identity);

  /// Serializes this SupportMessageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupportMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderUserId, senderUserId) ||
                other.senderUserId == senderUserId) &&
            (identical(other.isAdminReply, isAdminReply) ||
                other.isAdminReply == isAdminReply) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderUserId, isAdminReply,
      message, attachmentUrl, createdAt);

  @override
  String toString() {
    return 'SupportMessageModel(id: $id, senderUserId: $senderUserId, isAdminReply: $isAdminReply, message: $message, attachmentUrl: $attachmentUrl, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $SupportMessageModelCopyWith<$Res> {
  factory $SupportMessageModelCopyWith(
          SupportMessageModel value, $Res Function(SupportMessageModel) _then) =
      _$SupportMessageModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'sender_user_id') int senderUserId,
      @BoolJson() @JsonKey(name: 'is_admin_reply') bool isAdminReply,
      @StringJson() String message,
      @StringOrNullJson()
      @JsonKey(name: 'attachment_url')
      String? attachmentUrl,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$SupportMessageModelCopyWithImpl<$Res>
    implements $SupportMessageModelCopyWith<$Res> {
  _$SupportMessageModelCopyWithImpl(this._self, this._then);

  final SupportMessageModel _self;
  final $Res Function(SupportMessageModel) _then;

  /// Create a copy of SupportMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderUserId = null,
    Object? isAdminReply = null,
    Object? message = null,
    Object? attachmentUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderUserId: null == senderUserId
          ? _self.senderUserId
          : senderUserId // ignore: cast_nullable_to_non_nullable
              as int,
      isAdminReply: null == isAdminReply
          ? _self.isAdminReply
          : isAdminReply // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentUrl: freezed == attachmentUrl
          ? _self.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SupportMessageModel].
extension SupportMessageModelPatterns on SupportMessageModel {
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
    TResult Function(_SupportMessageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupportMessageModel() when $default != null:
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
    TResult Function(_SupportMessageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportMessageModel():
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
    TResult? Function(_SupportMessageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportMessageModel() when $default != null:
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
            @IntJson() int id,
            @IntJson() @JsonKey(name: 'sender_user_id') int senderUserId,
            @BoolJson() @JsonKey(name: 'is_admin_reply') bool isAdminReply,
            @StringJson() String message,
            @StringOrNullJson()
            @JsonKey(name: 'attachment_url')
            String? attachmentUrl,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupportMessageModel() when $default != null:
        return $default(_that.id, _that.senderUserId, _that.isAdminReply,
            _that.message, _that.attachmentUrl, _that.createdAt);
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
            @IntJson() int id,
            @IntJson() @JsonKey(name: 'sender_user_id') int senderUserId,
            @BoolJson() @JsonKey(name: 'is_admin_reply') bool isAdminReply,
            @StringJson() String message,
            @StringOrNullJson()
            @JsonKey(name: 'attachment_url')
            String? attachmentUrl,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportMessageModel():
        return $default(_that.id, _that.senderUserId, _that.isAdminReply,
            _that.message, _that.attachmentUrl, _that.createdAt);
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
            @IntJson() int id,
            @IntJson() @JsonKey(name: 'sender_user_id') int senderUserId,
            @BoolJson() @JsonKey(name: 'is_admin_reply') bool isAdminReply,
            @StringJson() String message,
            @StringOrNullJson()
            @JsonKey(name: 'attachment_url')
            String? attachmentUrl,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupportMessageModel() when $default != null:
        return $default(_that.id, _that.senderUserId, _that.isAdminReply,
            _that.message, _that.attachmentUrl, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SupportMessageModel implements SupportMessageModel {
  const _SupportMessageModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'sender_user_id') this.senderUserId = 0,
      @BoolJson() @JsonKey(name: 'is_admin_reply') this.isAdminReply = false,
      @StringJson() this.message = '',
      @StringOrNullJson() @JsonKey(name: 'attachment_url') this.attachmentUrl,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt});
  factory _SupportMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SupportMessageModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'sender_user_id')
  final int senderUserId;
  @override
  @BoolJson()
  @JsonKey(name: 'is_admin_reply')
  final bool isAdminReply;
  @override
  @JsonKey()
  @StringJson()
  final String message;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'attachment_url')
  final String? attachmentUrl;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of SupportMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SupportMessageModelCopyWith<_SupportMessageModel> get copyWith =>
      __$SupportMessageModelCopyWithImpl<_SupportMessageModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SupportMessageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SupportMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderUserId, senderUserId) ||
                other.senderUserId == senderUserId) &&
            (identical(other.isAdminReply, isAdminReply) ||
                other.isAdminReply == isAdminReply) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderUserId, isAdminReply,
      message, attachmentUrl, createdAt);

  @override
  String toString() {
    return 'SupportMessageModel(id: $id, senderUserId: $senderUserId, isAdminReply: $isAdminReply, message: $message, attachmentUrl: $attachmentUrl, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$SupportMessageModelCopyWith<$Res>
    implements $SupportMessageModelCopyWith<$Res> {
  factory _$SupportMessageModelCopyWith(_SupportMessageModel value,
          $Res Function(_SupportMessageModel) _then) =
      __$SupportMessageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'sender_user_id') int senderUserId,
      @BoolJson() @JsonKey(name: 'is_admin_reply') bool isAdminReply,
      @StringJson() String message,
      @StringOrNullJson()
      @JsonKey(name: 'attachment_url')
      String? attachmentUrl,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$SupportMessageModelCopyWithImpl<$Res>
    implements _$SupportMessageModelCopyWith<$Res> {
  __$SupportMessageModelCopyWithImpl(this._self, this._then);

  final _SupportMessageModel _self;
  final $Res Function(_SupportMessageModel) _then;

  /// Create a copy of SupportMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? senderUserId = null,
    Object? isAdminReply = null,
    Object? message = null,
    Object? attachmentUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_SupportMessageModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderUserId: null == senderUserId
          ? _self.senderUserId
          : senderUserId // ignore: cast_nullable_to_non_nullable
              as int,
      isAdminReply: null == isAdminReply
          ? _self.isAdminReply
          : isAdminReply // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentUrl: freezed == attachmentUrl
          ? _self.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
