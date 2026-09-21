// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatRoomState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatRoomState()';
  }
}

/// @nodoc
class $ChatRoomStateCopyWith<$Res> {
  $ChatRoomStateCopyWith(ChatRoomState _, $Res Function(ChatRoomState) __);
}

/// Adds pattern-matching-related methods to [ChatRoomState].
extension ChatRoomStatePatterns on ChatRoomState {
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
    TResult Function(ChatRoomLoading value)? loading,
    TResult Function(ChatRoomReady value)? ready,
    TResult Function(ChatRoomError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ChatRoomLoading() when loading != null:
        return loading(_that);
      case ChatRoomReady() when ready != null:
        return ready(_that);
      case ChatRoomError() when error != null:
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
    required TResult Function(ChatRoomLoading value) loading,
    required TResult Function(ChatRoomReady value) ready,
    required TResult Function(ChatRoomError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatRoomLoading():
        return loading(_that);
      case ChatRoomReady():
        return ready(_that);
      case ChatRoomError():
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
    TResult? Function(ChatRoomLoading value)? loading,
    TResult? Function(ChatRoomReady value)? ready,
    TResult? Function(ChatRoomError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatRoomLoading() when loading != null:
        return loading(_that);
      case ChatRoomReady() when ready != null:
        return ready(_that);
      case ChatRoomError() when error != null:
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
    TResult Function(List<ChatMessageModel> messages, bool isSending,
            DataError? actionError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ChatRoomLoading() when loading != null:
        return loading();
      case ChatRoomReady() when ready != null:
        return ready(_that.messages, _that.isSending, _that.actionError);
      case ChatRoomError() when error != null:
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
    required TResult Function(List<ChatMessageModel> messages, bool isSending,
            DataError? actionError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatRoomLoading():
        return loading();
      case ChatRoomReady():
        return ready(_that.messages, _that.isSending, _that.actionError);
      case ChatRoomError():
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
    TResult? Function(List<ChatMessageModel> messages, bool isSending,
            DataError? actionError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatRoomLoading() when loading != null:
        return loading();
      case ChatRoomReady() when ready != null:
        return ready(_that.messages, _that.isSending, _that.actionError);
      case ChatRoomError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ChatRoomLoading extends ChatRoomState {
  const ChatRoomLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatRoomLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatRoomState.loading()';
  }
}

/// @nodoc

class ChatRoomReady extends ChatRoomState {
  const ChatRoomReady(
      {required final List<ChatMessageModel> messages,
      this.isSending = false,
      this.actionError})
      : _messages = messages,
        super._();

  final List<ChatMessageModel> _messages;
  List<ChatMessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// Sedang mengirim pesan.
  @JsonKey()
  final bool isSending;
  final DataError? actionError;

  /// Create a copy of ChatRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatRoomReadyCopyWith<ChatRoomReady> get copyWith =>
      _$ChatRoomReadyCopyWithImpl<ChatRoomReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatRoomReady &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.isSending, isSending) ||
                other.isSending == isSending) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_messages), isSending, actionError);

  @override
  String toString() {
    return 'ChatRoomState.ready(messages: $messages, isSending: $isSending, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $ChatRoomReadyCopyWith<$Res>
    implements $ChatRoomStateCopyWith<$Res> {
  factory $ChatRoomReadyCopyWith(
          ChatRoomReady value, $Res Function(ChatRoomReady) _then) =
      _$ChatRoomReadyCopyWithImpl;
  @useResult
  $Res call(
      {List<ChatMessageModel> messages,
      bool isSending,
      DataError? actionError});
}

/// @nodoc
class _$ChatRoomReadyCopyWithImpl<$Res>
    implements $ChatRoomReadyCopyWith<$Res> {
  _$ChatRoomReadyCopyWithImpl(this._self, this._then);

  final ChatRoomReady _self;
  final $Res Function(ChatRoomReady) _then;

  /// Create a copy of ChatRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? messages = null,
    Object? isSending = null,
    Object? actionError = freezed,
  }) {
    return _then(ChatRoomReady(
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageModel>,
      isSending: null == isSending
          ? _self.isSending
          : isSending // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class ChatRoomError extends ChatRoomState {
  const ChatRoomError(this.error) : super._();

  final DataError error;

  /// Create a copy of ChatRoomState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatRoomErrorCopyWith<ChatRoomError> get copyWith =>
      _$ChatRoomErrorCopyWithImpl<ChatRoomError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatRoomError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'ChatRoomState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $ChatRoomErrorCopyWith<$Res>
    implements $ChatRoomStateCopyWith<$Res> {
  factory $ChatRoomErrorCopyWith(
          ChatRoomError value, $Res Function(ChatRoomError) _then) =
      _$ChatRoomErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$ChatRoomErrorCopyWithImpl<$Res>
    implements $ChatRoomErrorCopyWith<$Res> {
  _$ChatRoomErrorCopyWithImpl(this._self, this._then);

  final ChatRoomError _self;
  final $Res Function(ChatRoomError) _then;

  /// Create a copy of ChatRoomState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(ChatRoomError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
