// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'order_item_id')
  int get orderItemId;
  @IntJson()
  @JsonKey(name: 'user_id')
  int get userId;
  @IntJson()
  @JsonKey(name: 'product_id')
  int get productId;

  /// 1–5.
  @IntJson()
  int get rating;
  @StringOrNullJson()
  String? get comment;
  @BoolJson()
  @JsonKey(name: 'is_anonymous')
  bool get isAnonymous;
  @StringJson()
  String get status;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Balasan penjual, atau `null` kalau belum dibalas.
  ///
  /// Dirakit server jadi objek bersarang — **bukan** string JSON seperti
  /// `data` di notifikasi atau `selected_couriers` di sesi checkout.
  ReviewReplyModel? get reply;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      _$ReviewModelCopyWithImpl<ReviewModel>(this as ReviewModel, _$identity);

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reply, reply) || other.reply == reply));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderItemId, userId,
      productId, rating, comment, isAnonymous, status, createdAt, reply);

  @override
  String toString() {
    return 'ReviewModel(id: $id, orderItemId: $orderItemId, userId: $userId, productId: $productId, rating: $rating, comment: $comment, isAnonymous: $isAnonymous, status: $status, createdAt: $createdAt, reply: $reply)';
  }
}

/// @nodoc
abstract mixin class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
          ReviewModel value, $Res Function(ReviewModel) _then) =
      _$ReviewModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
      @IntJson() @JsonKey(name: 'user_id') int userId,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @IntJson() int rating,
      @StringOrNullJson() String? comment,
      @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      ReviewReplyModel? reply});

  $ReviewReplyModelCopyWith<$Res>? get reply;
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res> implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._self, this._then);

  final ReviewModel _self;
  final $Res Function(ReviewModel) _then;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderItemId = null,
    Object? userId = null,
    Object? productId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? isAnonymous = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? reply = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderItemId: null == orderItemId
          ? _self.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _self.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reply: freezed == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReviewReplyModel?,
    ));
  }

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewReplyModelCopyWith<$Res>? get reply {
    if (_self.reply == null) {
      return null;
    }

    return $ReviewReplyModelCopyWith<$Res>(_self.reply!, (value) {
      return _then(_self.copyWith(reply: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ReviewModel].
extension ReviewModelPatterns on ReviewModel {
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
    TResult Function(_ReviewModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
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
    TResult Function(_ReviewModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel():
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
    TResult? Function(_ReviewModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            ReviewReplyModel? reply)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
        return $default(
            _that.id,
            _that.orderItemId,
            _that.userId,
            _that.productId,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.status,
            _that.createdAt,
            _that.reply);
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
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            ReviewReplyModel? reply)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel():
        return $default(
            _that.id,
            _that.orderItemId,
            _that.userId,
            _that.productId,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.status,
            _that.createdAt,
            _that.reply);
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
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            ReviewReplyModel? reply)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
        return $default(
            _that.id,
            _that.orderItemId,
            _that.userId,
            _that.productId,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.status,
            _that.createdAt,
            _that.reply);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReviewModel extends ReviewModel {
  const _ReviewModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'order_item_id') this.orderItemId = 0,
      @IntJson() @JsonKey(name: 'user_id') this.userId = 0,
      @IntJson() @JsonKey(name: 'product_id') this.productId = 0,
      @IntJson() this.rating = 0,
      @StringOrNullJson() this.comment,
      @BoolJson() @JsonKey(name: 'is_anonymous') this.isAnonymous = false,
      @StringJson() this.status = 'published',
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      this.reply})
      : super._();
  factory _ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'order_item_id')
  final int orderItemId;
  @override
  @IntJson()
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @IntJson()
  @JsonKey(name: 'product_id')
  final int productId;

  /// 1–5.
  @override
  @JsonKey()
  @IntJson()
  final int rating;
  @override
  @StringOrNullJson()
  final String? comment;
  @override
  @BoolJson()
  @JsonKey(name: 'is_anonymous')
  final bool isAnonymous;
  @override
  @JsonKey()
  @StringJson()
  final String status;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Balasan penjual, atau `null` kalau belum dibalas.
  ///
  /// Dirakit server jadi objek bersarang — **bukan** string JSON seperti
  /// `data` di notifikasi atau `selected_couriers` di sesi checkout.
  @override
  final ReviewReplyModel? reply;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReviewModelCopyWith<_ReviewModel> get copyWith =>
      __$ReviewModelCopyWithImpl<_ReviewModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReviewModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReviewModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reply, reply) || other.reply == reply));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderItemId, userId,
      productId, rating, comment, isAnonymous, status, createdAt, reply);

  @override
  String toString() {
    return 'ReviewModel(id: $id, orderItemId: $orderItemId, userId: $userId, productId: $productId, rating: $rating, comment: $comment, isAnonymous: $isAnonymous, status: $status, createdAt: $createdAt, reply: $reply)';
  }
}

/// @nodoc
abstract mixin class _$ReviewModelCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$ReviewModelCopyWith(
          _ReviewModel value, $Res Function(_ReviewModel) _then) =
      __$ReviewModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
      @IntJson() @JsonKey(name: 'user_id') int userId,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @IntJson() int rating,
      @StringOrNullJson() String? comment,
      @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
      @StringJson() String status,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      ReviewReplyModel? reply});

  @override
  $ReviewReplyModelCopyWith<$Res>? get reply;
}

/// @nodoc
class __$ReviewModelCopyWithImpl<$Res> implements _$ReviewModelCopyWith<$Res> {
  __$ReviewModelCopyWithImpl(this._self, this._then);

  final _ReviewModel _self;
  final $Res Function(_ReviewModel) _then;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orderItemId = null,
    Object? userId = null,
    Object? productId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? isAnonymous = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? reply = freezed,
  }) {
    return _then(_ReviewModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderItemId: null == orderItemId
          ? _self.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _self.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reply: freezed == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReviewReplyModel?,
    ));
  }

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewReplyModelCopyWith<$Res>? get reply {
    if (_self.reply == null) {
      return null;
    }

    return $ReviewReplyModelCopyWith<$Res>(_self.reply!, (value) {
      return _then(_self.copyWith(reply: value));
    });
  }
}

/// @nodoc
mixin _$ReviewReplyModel {
  @StringOrNullJson()
  @JsonKey(name: 'reply_text')
  String? get replyText;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of ReviewReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewReplyModelCopyWith<ReviewReplyModel> get copyWith =>
      _$ReviewReplyModelCopyWithImpl<ReviewReplyModel>(
          this as ReviewReplyModel, _$identity);

  /// Serializes this ReviewReplyModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewReplyModel &&
            (identical(other.replyText, replyText) ||
                other.replyText == replyText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, replyText, createdAt);

  @override
  String toString() {
    return 'ReviewReplyModel(replyText: $replyText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ReviewReplyModelCopyWith<$Res> {
  factory $ReviewReplyModelCopyWith(
          ReviewReplyModel value, $Res Function(ReviewReplyModel) _then) =
      _$ReviewReplyModelCopyWithImpl;
  @useResult
  $Res call(
      {@StringOrNullJson() @JsonKey(name: 'reply_text') String? replyText,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$ReviewReplyModelCopyWithImpl<$Res>
    implements $ReviewReplyModelCopyWith<$Res> {
  _$ReviewReplyModelCopyWithImpl(this._self, this._then);

  final ReviewReplyModel _self;
  final $Res Function(ReviewReplyModel) _then;

  /// Create a copy of ReviewReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? replyText = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      replyText: freezed == replyText
          ? _self.replyText
          : replyText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReviewReplyModel].
extension ReviewReplyModelPatterns on ReviewReplyModel {
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
    TResult Function(_ReviewReplyModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewReplyModel() when $default != null:
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
    TResult Function(_ReviewReplyModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewReplyModel():
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
    TResult? Function(_ReviewReplyModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewReplyModel() when $default != null:
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
            @StringOrNullJson() @JsonKey(name: 'reply_text') String? replyText,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewReplyModel() when $default != null:
        return $default(_that.replyText, _that.createdAt);
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
            @StringOrNullJson() @JsonKey(name: 'reply_text') String? replyText,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewReplyModel():
        return $default(_that.replyText, _that.createdAt);
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
            @StringOrNullJson() @JsonKey(name: 'reply_text') String? replyText,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewReplyModel() when $default != null:
        return $default(_that.replyText, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReviewReplyModel extends ReviewReplyModel {
  const _ReviewReplyModel(
      {@StringOrNullJson() @JsonKey(name: 'reply_text') this.replyText,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
      : super._();
  factory _ReviewReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewReplyModelFromJson(json);

  @override
  @StringOrNullJson()
  @JsonKey(name: 'reply_text')
  final String? replyText;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Create a copy of ReviewReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReviewReplyModelCopyWith<_ReviewReplyModel> get copyWith =>
      __$ReviewReplyModelCopyWithImpl<_ReviewReplyModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReviewReplyModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReviewReplyModel &&
            (identical(other.replyText, replyText) ||
                other.replyText == replyText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, replyText, createdAt);

  @override
  String toString() {
    return 'ReviewReplyModel(replyText: $replyText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ReviewReplyModelCopyWith<$Res>
    implements $ReviewReplyModelCopyWith<$Res> {
  factory _$ReviewReplyModelCopyWith(
          _ReviewReplyModel value, $Res Function(_ReviewReplyModel) _then) =
      __$ReviewReplyModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@StringOrNullJson() @JsonKey(name: 'reply_text') String? replyText,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$ReviewReplyModelCopyWithImpl<$Res>
    implements _$ReviewReplyModelCopyWith<$Res> {
  __$ReviewReplyModelCopyWithImpl(this._self, this._then);

  final _ReviewReplyModel _self;
  final $Res Function(_ReviewReplyModel) _then;

  /// Create a copy of ReviewReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? replyText = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_ReviewReplyModel(
      replyText: freezed == replyText
          ? _self.replyText
          : replyText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$MyReviewModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'order_id')
  int get orderId;
  @IntJson()
  @JsonKey(name: 'order_item_id')
  int get orderItemId;
  @IntJson()
  @JsonKey(name: 'product_id')
  int get productId;
  @IntJson()
  @JsonKey(name: 'store_id')
  int get storeId;
  @StringOrNullJson()
  @JsonKey(name: 'product_name')
  String? get productName;

  /// Snapshot opsi varian dari baris pesanan, mis. `{"warna": "Navy"}`.
  @JsonMapJson()
  @JsonKey(name: 'variant_options')
  Map<String, dynamic>? get variantOptions;
  @IntJson()
  int get rating;
  @StringOrNullJson()
  String? get comment;
  @BoolJson()
  @JsonKey(name: 'is_anonymous')
  bool get isAnonymous;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// `created_at` + 30 hari (desain §3.24: "dapat memperbarui penilaian ini
  /// dalam kurun waktu 30 hari setelah dikirimkan").
  @ServerDateTimeJson()
  @JsonKey(name: 'editable_until')
  DateTime? get editableUntil;

  /// Dihitung server. Aplikasi tetap memeriksa [editableUntil] juga (lihat
  /// [canEdit]) supaya layar yang dibiarkan terbuka melewati tenggat tidak
  /// menawarkan tombol yang pasti ditolak.
  @BoolJson()
  @JsonKey(name: 'is_editable')
  bool get isEditable;

  /// Create a copy of MyReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyReviewModelCopyWith<MyReviewModel> get copyWith =>
      _$MyReviewModelCopyWithImpl<MyReviewModel>(
          this as MyReviewModel, _$identity);

  /// Serializes this MyReviewModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyReviewModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality()
                .equals(other.variantOptions, variantOptions) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.editableUntil, editableUntil) ||
                other.editableUntil == editableUntil) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      orderItemId,
      productId,
      storeId,
      productName,
      const DeepCollectionEquality().hash(variantOptions),
      rating,
      comment,
      isAnonymous,
      createdAt,
      updatedAt,
      editableUntil,
      isEditable);

  @override
  String toString() {
    return 'MyReviewModel(id: $id, orderId: $orderId, orderItemId: $orderItemId, productId: $productId, storeId: $storeId, productName: $productName, variantOptions: $variantOptions, rating: $rating, comment: $comment, isAnonymous: $isAnonymous, createdAt: $createdAt, updatedAt: $updatedAt, editableUntil: $editableUntil, isEditable: $isEditable)';
  }
}

/// @nodoc
abstract mixin class $MyReviewModelCopyWith<$Res> {
  factory $MyReviewModelCopyWith(
          MyReviewModel value, $Res Function(MyReviewModel) _then) =
      _$MyReviewModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'order_id') int orderId,
      @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringOrNullJson() @JsonKey(name: 'product_name') String? productName,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      Map<String, dynamic>? variantOptions,
      @IntJson() int rating,
      @StringOrNullJson() String? comment,
      @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'editable_until')
      DateTime? editableUntil,
      @BoolJson() @JsonKey(name: 'is_editable') bool isEditable});
}

/// @nodoc
class _$MyReviewModelCopyWithImpl<$Res>
    implements $MyReviewModelCopyWith<$Res> {
  _$MyReviewModelCopyWithImpl(this._self, this._then);

  final MyReviewModel _self;
  final $Res Function(MyReviewModel) _then;

  /// Create a copy of MyReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? orderItemId = null,
    Object? productId = null,
    Object? storeId = null,
    Object? productName = freezed,
    Object? variantOptions = freezed,
    Object? rating = null,
    Object? comment = freezed,
    Object? isAnonymous = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? editableUntil = freezed,
    Object? isEditable = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderItemId: null == orderItemId
          ? _self.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: freezed == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      variantOptions: freezed == variantOptions
          ? _self.variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _self.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      editableUntil: freezed == editableUntil
          ? _self.editableUntil
          : editableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEditable: null == isEditable
          ? _self.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MyReviewModel].
extension MyReviewModelPatterns on MyReviewModel {
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
    TResult Function(_MyReviewModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyReviewModel() when $default != null:
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
    TResult Function(_MyReviewModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewModel():
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
    TResult? Function(_MyReviewModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'order_id') int orderId,
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringOrNullJson()
            @JsonKey(name: 'product_name')
            String? productName,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'editable_until')
            DateTime? editableUntil,
            @BoolJson() @JsonKey(name: 'is_editable') bool isEditable)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyReviewModel() when $default != null:
        return $default(
            _that.id,
            _that.orderId,
            _that.orderItemId,
            _that.productId,
            _that.storeId,
            _that.productName,
            _that.variantOptions,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.createdAt,
            _that.updatedAt,
            _that.editableUntil,
            _that.isEditable);
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
            @IntJson() @JsonKey(name: 'order_id') int orderId,
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringOrNullJson()
            @JsonKey(name: 'product_name')
            String? productName,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'editable_until')
            DateTime? editableUntil,
            @BoolJson() @JsonKey(name: 'is_editable') bool isEditable)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewModel():
        return $default(
            _that.id,
            _that.orderId,
            _that.orderItemId,
            _that.productId,
            _that.storeId,
            _that.productName,
            _that.variantOptions,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.createdAt,
            _that.updatedAt,
            _that.editableUntil,
            _that.isEditable);
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
            @IntJson() @JsonKey(name: 'order_id') int orderId,
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringOrNullJson()
            @JsonKey(name: 'product_name')
            String? productName,
            @JsonMapJson()
            @JsonKey(name: 'variant_options')
            Map<String, dynamic>? variantOptions,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'updated_at')
            DateTime? updatedAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'editable_until')
            DateTime? editableUntil,
            @BoolJson() @JsonKey(name: 'is_editable') bool isEditable)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewModel() when $default != null:
        return $default(
            _that.id,
            _that.orderId,
            _that.orderItemId,
            _that.productId,
            _that.storeId,
            _that.productName,
            _that.variantOptions,
            _that.rating,
            _that.comment,
            _that.isAnonymous,
            _that.createdAt,
            _that.updatedAt,
            _that.editableUntil,
            _that.isEditable);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MyReviewModel extends MyReviewModel {
  const _MyReviewModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'order_id') this.orderId = 0,
      @IntJson() @JsonKey(name: 'order_item_id') this.orderItemId = 0,
      @IntJson() @JsonKey(name: 'product_id') this.productId = 0,
      @IntJson() @JsonKey(name: 'store_id') this.storeId = 0,
      @StringOrNullJson() @JsonKey(name: 'product_name') this.productName,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      final Map<String, dynamic>? variantOptions,
      @IntJson() this.rating = 0,
      @StringOrNullJson() this.comment,
      @BoolJson() @JsonKey(name: 'is_anonymous') this.isAnonymous = false,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') this.updatedAt,
      @ServerDateTimeJson() @JsonKey(name: 'editable_until') this.editableUntil,
      @BoolJson() @JsonKey(name: 'is_editable') this.isEditable = false})
      : _variantOptions = variantOptions,
        super._();
  factory _MyReviewModel.fromJson(Map<String, dynamic> json) =>
      _$MyReviewModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'order_id')
  final int orderId;
  @override
  @IntJson()
  @JsonKey(name: 'order_item_id')
  final int orderItemId;
  @override
  @IntJson()
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  @IntJson()
  @JsonKey(name: 'store_id')
  final int storeId;
  @override
  @StringOrNullJson()
  @JsonKey(name: 'product_name')
  final String? productName;

  /// Snapshot opsi varian dari baris pesanan, mis. `{"warna": "Navy"}`.
  final Map<String, dynamic>? _variantOptions;

  /// Snapshot opsi varian dari baris pesanan, mis. `{"warna": "Navy"}`.
  @override
  @JsonMapJson()
  @JsonKey(name: 'variant_options')
  Map<String, dynamic>? get variantOptions {
    final value = _variantOptions;
    if (value == null) return null;
    if (_variantOptions is EqualUnmodifiableMapView) return _variantOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  @IntJson()
  final int rating;
  @override
  @StringOrNullJson()
  final String? comment;
  @override
  @BoolJson()
  @JsonKey(name: 'is_anonymous')
  final bool isAnonymous;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// `created_at` + 30 hari (desain §3.24: "dapat memperbarui penilaian ini
  /// dalam kurun waktu 30 hari setelah dikirimkan").
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'editable_until')
  final DateTime? editableUntil;

  /// Dihitung server. Aplikasi tetap memeriksa [editableUntil] juga (lihat
  /// [canEdit]) supaya layar yang dibiarkan terbuka melewati tenggat tidak
  /// menawarkan tombol yang pasti ditolak.
  @override
  @BoolJson()
  @JsonKey(name: 'is_editable')
  final bool isEditable;

  /// Create a copy of MyReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyReviewModelCopyWith<_MyReviewModel> get copyWith =>
      __$MyReviewModelCopyWithImpl<_MyReviewModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MyReviewModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyReviewModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality()
                .equals(other._variantOptions, _variantOptions) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.editableUntil, editableUntil) ||
                other.editableUntil == editableUntil) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      orderItemId,
      productId,
      storeId,
      productName,
      const DeepCollectionEquality().hash(_variantOptions),
      rating,
      comment,
      isAnonymous,
      createdAt,
      updatedAt,
      editableUntil,
      isEditable);

  @override
  String toString() {
    return 'MyReviewModel(id: $id, orderId: $orderId, orderItemId: $orderItemId, productId: $productId, storeId: $storeId, productName: $productName, variantOptions: $variantOptions, rating: $rating, comment: $comment, isAnonymous: $isAnonymous, createdAt: $createdAt, updatedAt: $updatedAt, editableUntil: $editableUntil, isEditable: $isEditable)';
  }
}

/// @nodoc
abstract mixin class _$MyReviewModelCopyWith<$Res>
    implements $MyReviewModelCopyWith<$Res> {
  factory _$MyReviewModelCopyWith(
          _MyReviewModel value, $Res Function(_MyReviewModel) _then) =
      __$MyReviewModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'order_id') int orderId,
      @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
      @IntJson() @JsonKey(name: 'product_id') int productId,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringOrNullJson() @JsonKey(name: 'product_name') String? productName,
      @JsonMapJson()
      @JsonKey(name: 'variant_options')
      Map<String, dynamic>? variantOptions,
      @IntJson() int rating,
      @StringOrNullJson() String? comment,
      @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'editable_until')
      DateTime? editableUntil,
      @BoolJson() @JsonKey(name: 'is_editable') bool isEditable});
}

/// @nodoc
class __$MyReviewModelCopyWithImpl<$Res>
    implements _$MyReviewModelCopyWith<$Res> {
  __$MyReviewModelCopyWithImpl(this._self, this._then);

  final _MyReviewModel _self;
  final $Res Function(_MyReviewModel) _then;

  /// Create a copy of MyReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? orderItemId = null,
    Object? productId = null,
    Object? storeId = null,
    Object? productName = freezed,
    Object? variantOptions = freezed,
    Object? rating = null,
    Object? comment = freezed,
    Object? isAnonymous = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? editableUntil = freezed,
    Object? isEditable = null,
  }) {
    return _then(_MyReviewModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderItemId: null == orderItemId
          ? _self.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: freezed == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      variantOptions: freezed == variantOptions
          ? _self._variantOptions
          : variantOptions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _self.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      editableUntil: freezed == editableUntil
          ? _self.editableUntil
          : editableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEditable: null == isEditable
          ? _self.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
