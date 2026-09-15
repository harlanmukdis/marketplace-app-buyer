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
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderItemId, userId,
      productId, rating, comment, isAnonymous, status, createdAt);

  @override
  String toString() {
    return 'ReviewModel(id: $id, orderItemId: $orderItemId, userId: $userId, productId: $productId, rating: $rating, comment: $comment, isAnonymous: $isAnonymous, status: $status, createdAt: $createdAt)';
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
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
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
    ));
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
            DateTime? createdAt)?
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
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)
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
            @IntJson() @JsonKey(name: 'order_item_id') int orderItemId,
            @IntJson() @JsonKey(name: 'user_id') int userId,
            @IntJson() @JsonKey(name: 'product_id') int productId,
            @IntJson() int rating,
            @StringOrNullJson() String? comment,
            @BoolJson() @JsonKey(name: 'is_anonymous') bool isAnonymous,
            @StringJson() String status,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt)?
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
            _that.createdAt);
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
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt})
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
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderItemId, userId,
      productId, rating, comment, isAnonymous, status, createdAt);

  @override
  String toString() {
    return 'ReviewModel(id: $id, orderItemId: $orderItemId, userId: $userId, productId: $productId, rating: $rating, comment: $comment, isAnonymous: $isAnonymous, status: $status, createdAt: $createdAt)';
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
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt});
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
    ));
  }
}

// dart format on
