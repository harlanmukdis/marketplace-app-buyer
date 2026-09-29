// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatConversationModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'store_id')
  int get storeId;
  @StringJson()
  @JsonKey(name: 'store_name')
  String get storeName;

  /// `null` untuk percakapan yang belum berisi pesan apa pun — dan itu
  /// mungkin terjadi, karena `POST /chat/conversations` membuat barisnya
  /// lebih dulu tanpa pesan.
  @ServerDateTimeJson()
  @JsonKey(name: 'last_message_at')
  DateTime? get lastMessageAt;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// 🔴 **Selalu `0`, dan jangan dipercaya.**
  ///
  /// Kolomnya ada di skema, tapi **tidak ada satu pun kode di backend yang
  /// pernah menaikkan atau mengosongkannya** — `send_message` hanya
  /// memperbarui `last_message_at`, dan `mark_read` hanya menyentuh
  /// `chat_messages.read_at`. Menampilkannya sebagai lencana "belum dibaca"
  /// berarti memasang angka yang permanen nol.
  ///
  /// Dimodelkan supaya keberadaannya terdokumentasi — bukan untuk dipakai.
  /// Lihat [hasReliableUnreadCount].
  @IntJson()
  @JsonKey(name: 'buyer_unread_count')
  int get buyerUnreadCount;

  /// Create a copy of ChatConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatConversationModelCopyWith<ChatConversationModel> get copyWith =>
      _$ChatConversationModelCopyWithImpl<ChatConversationModel>(
          this as ChatConversationModel, _$identity);

  /// Serializes this ChatConversationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatConversationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.buyerUnreadCount, buyerUnreadCount) ||
                other.buyerUnreadCount == buyerUnreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storeId, storeName,
      lastMessageAt, createdAt, buyerUnreadCount);

  @override
  String toString() {
    return 'ChatConversationModel(id: $id, storeId: $storeId, storeName: $storeName, lastMessageAt: $lastMessageAt, createdAt: $createdAt, buyerUnreadCount: $buyerUnreadCount)';
  }
}

/// @nodoc
abstract mixin class $ChatConversationModelCopyWith<$Res> {
  factory $ChatConversationModelCopyWith(ChatConversationModel value,
          $Res Function(ChatConversationModel) _then) =
      _$ChatConversationModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() @JsonKey(name: 'store_name') String storeName,
      @ServerDateTimeJson()
      @JsonKey(name: 'last_message_at')
      DateTime? lastMessageAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @IntJson() @JsonKey(name: 'buyer_unread_count') int buyerUnreadCount});
}

/// @nodoc
class _$ChatConversationModelCopyWithImpl<$Res>
    implements $ChatConversationModelCopyWith<$Res> {
  _$ChatConversationModelCopyWithImpl(this._self, this._then);

  final ChatConversationModel _self;
  final $Res Function(ChatConversationModel) _then;

  /// Create a copy of ChatConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
    Object? buyerUnreadCount = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageAt: freezed == lastMessageAt
          ? _self.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerUnreadCount: null == buyerUnreadCount
          ? _self.buyerUnreadCount
          : buyerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatConversationModel].
extension ChatConversationModelPatterns on ChatConversationModel {
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
    TResult Function(_ChatConversationModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatConversationModel() when $default != null:
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
    TResult Function(_ChatConversationModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatConversationModel():
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
    TResult? Function(_ChatConversationModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatConversationModel() when $default != null:
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
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @ServerDateTimeJson()
            @JsonKey(name: 'last_message_at')
            DateTime? lastMessageAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @IntJson()
            @JsonKey(name: 'buyer_unread_count')
            int buyerUnreadCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatConversationModel() when $default != null:
        return $default(_that.id, _that.storeId, _that.storeName,
            _that.lastMessageAt, _that.createdAt, _that.buyerUnreadCount);
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
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @ServerDateTimeJson()
            @JsonKey(name: 'last_message_at')
            DateTime? lastMessageAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @IntJson()
            @JsonKey(name: 'buyer_unread_count')
            int buyerUnreadCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatConversationModel():
        return $default(_that.id, _that.storeId, _that.storeName,
            _that.lastMessageAt, _that.createdAt, _that.buyerUnreadCount);
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
            @IntJson() @JsonKey(name: 'store_id') int storeId,
            @StringJson() @JsonKey(name: 'store_name') String storeName,
            @ServerDateTimeJson()
            @JsonKey(name: 'last_message_at')
            DateTime? lastMessageAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @IntJson()
            @JsonKey(name: 'buyer_unread_count')
            int buyerUnreadCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatConversationModel() when $default != null:
        return $default(_that.id, _that.storeId, _that.storeName,
            _that.lastMessageAt, _that.createdAt, _that.buyerUnreadCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatConversationModel extends ChatConversationModel {
  const _ChatConversationModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'store_id') this.storeId = 0,
      @StringJson() @JsonKey(name: 'store_name') this.storeName = '',
      @ServerDateTimeJson()
      @JsonKey(name: 'last_message_at')
      this.lastMessageAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      @IntJson()
      @JsonKey(name: 'buyer_unread_count')
      this.buyerUnreadCount = 0})
      : super._();
  factory _ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'store_id')
  final int storeId;
  @override
  @StringJson()
  @JsonKey(name: 'store_name')
  final String storeName;

  /// `null` untuk percakapan yang belum berisi pesan apa pun — dan itu
  /// mungkin terjadi, karena `POST /chat/conversations` membuat barisnya
  /// lebih dulu tanpa pesan.
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'last_message_at')
  final DateTime? lastMessageAt;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// 🔴 **Selalu `0`, dan jangan dipercaya.**
  ///
  /// Kolomnya ada di skema, tapi **tidak ada satu pun kode di backend yang
  /// pernah menaikkan atau mengosongkannya** — `send_message` hanya
  /// memperbarui `last_message_at`, dan `mark_read` hanya menyentuh
  /// `chat_messages.read_at`. Menampilkannya sebagai lencana "belum dibaca"
  /// berarti memasang angka yang permanen nol.
  ///
  /// Dimodelkan supaya keberadaannya terdokumentasi — bukan untuk dipakai.
  /// Lihat [hasReliableUnreadCount].
  @override
  @IntJson()
  @JsonKey(name: 'buyer_unread_count')
  final int buyerUnreadCount;

  /// Create a copy of ChatConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatConversationModelCopyWith<_ChatConversationModel> get copyWith =>
      __$ChatConversationModelCopyWithImpl<_ChatConversationModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatConversationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatConversationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.buyerUnreadCount, buyerUnreadCount) ||
                other.buyerUnreadCount == buyerUnreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storeId, storeName,
      lastMessageAt, createdAt, buyerUnreadCount);

  @override
  String toString() {
    return 'ChatConversationModel(id: $id, storeId: $storeId, storeName: $storeName, lastMessageAt: $lastMessageAt, createdAt: $createdAt, buyerUnreadCount: $buyerUnreadCount)';
  }
}

/// @nodoc
abstract mixin class _$ChatConversationModelCopyWith<$Res>
    implements $ChatConversationModelCopyWith<$Res> {
  factory _$ChatConversationModelCopyWith(_ChatConversationModel value,
          $Res Function(_ChatConversationModel) _then) =
      __$ChatConversationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'store_id') int storeId,
      @StringJson() @JsonKey(name: 'store_name') String storeName,
      @ServerDateTimeJson()
      @JsonKey(name: 'last_message_at')
      DateTime? lastMessageAt,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @IntJson() @JsonKey(name: 'buyer_unread_count') int buyerUnreadCount});
}

/// @nodoc
class __$ChatConversationModelCopyWithImpl<$Res>
    implements _$ChatConversationModelCopyWith<$Res> {
  __$ChatConversationModelCopyWithImpl(this._self, this._then);

  final _ChatConversationModel _self;
  final $Res Function(_ChatConversationModel) _then;

  /// Create a copy of ChatConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? storeName = null,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
    Object? buyerUnreadCount = null,
  }) {
    return _then(_ChatConversationModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      storeId: null == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as int,
      storeName: null == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageAt: freezed == lastMessageAt
          ? _self.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerUnreadCount: null == buyerUnreadCount
          ? _self.buyerUnreadCount
          : buyerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ChatMessageModel {
  @IntJson()
  int get id;
  @IntJson()
  @JsonKey(name: 'sender_user_id')
  int get senderUserId;

  /// Kode jenis mentah; pakai [type] untuk logika.
  @StringJson()
  @JsonKey(name: 'message_type')
  String get typeCode;

  /// **Boleh `null`.** Server menerima `POST` tanpa `content` dan
  /// membalasnya `201` — tidak ada validasi sama sekali.
  @StringOrNullJson()
  String? get content;
  @IntOrNullJson()
  @JsonKey(name: 'shared_product_id')
  int? get sharedProductId;
  @IntOrNullJson()
  @JsonKey(name: 'shared_order_id')
  int? get sharedOrderId;
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Terisi saat **lawan bicara** membuka percakapan.
  ///
  /// `mark_read` hanya menyentuh pesan yang `sender_user_id`-nya **bukan**
  /// pemanggil, jadi pesan sendiri tidak pernah ditandai terbaca oleh diri
  /// sendiri — diverifikasi ke server.
  @ServerDateTimeJson()
  @JsonKey(name: 'read_at')
  DateTime? get readAt;

  /// Terisi saat lawan bicara **mengambil** pesan (`/messages` atau poll) —
  /// ditambahkan backend v1.x. Artinya membuka ruang chat kini menulis ke
  /// database.
  @ServerDateTimeJson()
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt;

  /// `sent` / `delivered` / `read`, dihitung server.
  @StringOrNullJson()
  @JsonKey(name: 'status')
  String? get deliveryStatus;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatMessageModelCopyWith<ChatMessageModel> get copyWith =>
      _$ChatMessageModelCopyWithImpl<ChatMessageModel>(
          this as ChatMessageModel, _$identity);

  /// Serializes this ChatMessageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderUserId, senderUserId) ||
                other.senderUserId == senderUserId) &&
            (identical(other.typeCode, typeCode) ||
                other.typeCode == typeCode) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sharedProductId, sharedProductId) ||
                other.sharedProductId == sharedProductId) &&
            (identical(other.sharedOrderId, sharedOrderId) ||
                other.sharedOrderId == sharedOrderId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.deliveryStatus, deliveryStatus) ||
                other.deliveryStatus == deliveryStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderUserId,
      typeCode,
      content,
      sharedProductId,
      sharedOrderId,
      createdAt,
      readAt,
      deliveredAt,
      deliveryStatus);

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, senderUserId: $senderUserId, typeCode: $typeCode, content: $content, sharedProductId: $sharedProductId, sharedOrderId: $sharedOrderId, createdAt: $createdAt, readAt: $readAt, deliveredAt: $deliveredAt, deliveryStatus: $deliveryStatus)';
  }
}

/// @nodoc
abstract mixin class $ChatMessageModelCopyWith<$Res> {
  factory $ChatMessageModelCopyWith(
          ChatMessageModel value, $Res Function(ChatMessageModel) _then) =
      _$ChatMessageModelCopyWithImpl;
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'sender_user_id') int senderUserId,
      @StringJson() @JsonKey(name: 'message_type') String typeCode,
      @StringOrNullJson() String? content,
      @IntOrNullJson() @JsonKey(name: 'shared_product_id') int? sharedProductId,
      @IntOrNullJson() @JsonKey(name: 'shared_order_id') int? sharedOrderId,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'read_at') DateTime? readAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'delivered_at')
      DateTime? deliveredAt,
      @StringOrNullJson() @JsonKey(name: 'status') String? deliveryStatus});
}

/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._self, this._then);

  final ChatMessageModel _self;
  final $Res Function(ChatMessageModel) _then;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderUserId = null,
    Object? typeCode = null,
    Object? content = freezed,
    Object? sharedProductId = freezed,
    Object? sharedOrderId = freezed,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? deliveredAt = freezed,
    Object? deliveryStatus = freezed,
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
      typeCode: null == typeCode
          ? _self.typeCode
          : typeCode // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedProductId: freezed == sharedProductId
          ? _self.sharedProductId
          : sharedProductId // ignore: cast_nullable_to_non_nullable
              as int?,
      sharedOrderId: freezed == sharedOrderId
          ? _self.sharedOrderId
          : sharedOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _self.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryStatus: freezed == deliveryStatus
          ? _self.deliveryStatus
          : deliveryStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatMessageModel].
extension ChatMessageModelPatterns on ChatMessageModel {
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
    TResult Function(_ChatMessageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessageModel() when $default != null:
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
    TResult Function(_ChatMessageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageModel():
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
    TResult? Function(_ChatMessageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageModel() when $default != null:
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
            @StringJson() @JsonKey(name: 'message_type') String typeCode,
            @StringOrNullJson() String? content,
            @IntOrNullJson()
            @JsonKey(name: 'shared_product_id')
            int? sharedProductId,
            @IntOrNullJson()
            @JsonKey(name: 'shared_order_id')
            int? sharedOrderId,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson() @JsonKey(name: 'read_at') DateTime? readAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'delivered_at')
            DateTime? deliveredAt,
            @StringOrNullJson()
            @JsonKey(name: 'status')
            String? deliveryStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessageModel() when $default != null:
        return $default(
            _that.id,
            _that.senderUserId,
            _that.typeCode,
            _that.content,
            _that.sharedProductId,
            _that.sharedOrderId,
            _that.createdAt,
            _that.readAt,
            _that.deliveredAt,
            _that.deliveryStatus);
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
            @StringJson() @JsonKey(name: 'message_type') String typeCode,
            @StringOrNullJson() String? content,
            @IntOrNullJson()
            @JsonKey(name: 'shared_product_id')
            int? sharedProductId,
            @IntOrNullJson()
            @JsonKey(name: 'shared_order_id')
            int? sharedOrderId,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson() @JsonKey(name: 'read_at') DateTime? readAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'delivered_at')
            DateTime? deliveredAt,
            @StringOrNullJson() @JsonKey(name: 'status') String? deliveryStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageModel():
        return $default(
            _that.id,
            _that.senderUserId,
            _that.typeCode,
            _that.content,
            _that.sharedProductId,
            _that.sharedOrderId,
            _that.createdAt,
            _that.readAt,
            _that.deliveredAt,
            _that.deliveryStatus);
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
            @StringJson() @JsonKey(name: 'message_type') String typeCode,
            @StringOrNullJson() String? content,
            @IntOrNullJson()
            @JsonKey(name: 'shared_product_id')
            int? sharedProductId,
            @IntOrNullJson()
            @JsonKey(name: 'shared_order_id')
            int? sharedOrderId,
            @ServerDateTimeJson()
            @JsonKey(name: 'created_at')
            DateTime? createdAt,
            @ServerDateTimeJson() @JsonKey(name: 'read_at') DateTime? readAt,
            @ServerDateTimeJson()
            @JsonKey(name: 'delivered_at')
            DateTime? deliveredAt,
            @StringOrNullJson()
            @JsonKey(name: 'status')
            String? deliveryStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessageModel() when $default != null:
        return $default(
            _that.id,
            _that.senderUserId,
            _that.typeCode,
            _that.content,
            _that.sharedProductId,
            _that.sharedOrderId,
            _that.createdAt,
            _that.readAt,
            _that.deliveredAt,
            _that.deliveryStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatMessageModel extends ChatMessageModel {
  const _ChatMessageModel(
      {@IntJson() required this.id,
      @IntJson() @JsonKey(name: 'sender_user_id') this.senderUserId = 0,
      @StringJson() @JsonKey(name: 'message_type') this.typeCode = '',
      @StringOrNullJson() this.content,
      @IntOrNullJson() @JsonKey(name: 'shared_product_id') this.sharedProductId,
      @IntOrNullJson() @JsonKey(name: 'shared_order_id') this.sharedOrderId,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') this.createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'read_at') this.readAt,
      @ServerDateTimeJson() @JsonKey(name: 'delivered_at') this.deliveredAt,
      @StringOrNullJson() @JsonKey(name: 'status') this.deliveryStatus})
      : super._();
  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  @override
  @IntJson()
  final int id;
  @override
  @IntJson()
  @JsonKey(name: 'sender_user_id')
  final int senderUserId;

  /// Kode jenis mentah; pakai [type] untuk logika.
  @override
  @StringJson()
  @JsonKey(name: 'message_type')
  final String typeCode;

  /// **Boleh `null`.** Server menerima `POST` tanpa `content` dan
  /// membalasnya `201` — tidak ada validasi sama sekali.
  @override
  @StringOrNullJson()
  final String? content;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'shared_product_id')
  final int? sharedProductId;
  @override
  @IntOrNullJson()
  @JsonKey(name: 'shared_order_id')
  final int? sharedOrderId;
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Terisi saat **lawan bicara** membuka percakapan.
  ///
  /// `mark_read` hanya menyentuh pesan yang `sender_user_id`-nya **bukan**
  /// pemanggil, jadi pesan sendiri tidak pernah ditandai terbaca oleh diri
  /// sendiri — diverifikasi ke server.
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'read_at')
  final DateTime? readAt;

  /// Terisi saat lawan bicara **mengambil** pesan (`/messages` atau poll) —
  /// ditambahkan backend v1.x. Artinya membuka ruang chat kini menulis ke
  /// database.
  @override
  @ServerDateTimeJson()
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;

  /// `sent` / `delivered` / `read`, dihitung server.
  @override
  @StringOrNullJson()
  @JsonKey(name: 'status')
  final String? deliveryStatus;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatMessageModelCopyWith<_ChatMessageModel> get copyWith =>
      __$ChatMessageModelCopyWithImpl<_ChatMessageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatMessageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderUserId, senderUserId) ||
                other.senderUserId == senderUserId) &&
            (identical(other.typeCode, typeCode) ||
                other.typeCode == typeCode) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sharedProductId, sharedProductId) ||
                other.sharedProductId == sharedProductId) &&
            (identical(other.sharedOrderId, sharedOrderId) ||
                other.sharedOrderId == sharedOrderId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.deliveryStatus, deliveryStatus) ||
                other.deliveryStatus == deliveryStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderUserId,
      typeCode,
      content,
      sharedProductId,
      sharedOrderId,
      createdAt,
      readAt,
      deliveredAt,
      deliveryStatus);

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, senderUserId: $senderUserId, typeCode: $typeCode, content: $content, sharedProductId: $sharedProductId, sharedOrderId: $sharedOrderId, createdAt: $createdAt, readAt: $readAt, deliveredAt: $deliveredAt, deliveryStatus: $deliveryStatus)';
  }
}

/// @nodoc
abstract mixin class _$ChatMessageModelCopyWith<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  factory _$ChatMessageModelCopyWith(
          _ChatMessageModel value, $Res Function(_ChatMessageModel) _then) =
      __$ChatMessageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@IntJson() int id,
      @IntJson() @JsonKey(name: 'sender_user_id') int senderUserId,
      @StringJson() @JsonKey(name: 'message_type') String typeCode,
      @StringOrNullJson() String? content,
      @IntOrNullJson() @JsonKey(name: 'shared_product_id') int? sharedProductId,
      @IntOrNullJson() @JsonKey(name: 'shared_order_id') int? sharedOrderId,
      @ServerDateTimeJson() @JsonKey(name: 'created_at') DateTime? createdAt,
      @ServerDateTimeJson() @JsonKey(name: 'read_at') DateTime? readAt,
      @ServerDateTimeJson()
      @JsonKey(name: 'delivered_at')
      DateTime? deliveredAt,
      @StringOrNullJson() @JsonKey(name: 'status') String? deliveryStatus});
}

/// @nodoc
class __$ChatMessageModelCopyWithImpl<$Res>
    implements _$ChatMessageModelCopyWith<$Res> {
  __$ChatMessageModelCopyWithImpl(this._self, this._then);

  final _ChatMessageModel _self;
  final $Res Function(_ChatMessageModel) _then;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? senderUserId = null,
    Object? typeCode = null,
    Object? content = freezed,
    Object? sharedProductId = freezed,
    Object? sharedOrderId = freezed,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? deliveredAt = freezed,
    Object? deliveryStatus = freezed,
  }) {
    return _then(_ChatMessageModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderUserId: null == senderUserId
          ? _self.senderUserId
          : senderUserId // ignore: cast_nullable_to_non_nullable
              as int,
      typeCode: null == typeCode
          ? _self.typeCode
          : typeCode // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedProductId: freezed == sharedProductId
          ? _self.sharedProductId
          : sharedProductId // ignore: cast_nullable_to_non_nullable
              as int?,
      sharedOrderId: freezed == sharedOrderId
          ? _self.sharedOrderId
          : sharedOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _self.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryStatus: freezed == deliveryStatus
          ? _self.deliveryStatus
          : deliveryStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
