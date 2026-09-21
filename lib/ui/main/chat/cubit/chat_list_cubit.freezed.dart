// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatListState()';
  }
}

/// @nodoc
class $ChatListStateCopyWith<$Res> {
  $ChatListStateCopyWith(ChatListState _, $Res Function(ChatListState) __);
}

/// Adds pattern-matching-related methods to [ChatListState].
extension ChatListStatePatterns on ChatListState {
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
    TResult Function(ChatListLoading value)? loading,
    TResult Function(ChatListEmpty value)? empty,
    TResult Function(ChatListLoaded value)? loaded,
    TResult Function(ChatListError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ChatListLoading() when loading != null:
        return loading(_that);
      case ChatListEmpty() when empty != null:
        return empty(_that);
      case ChatListLoaded() when loaded != null:
        return loaded(_that);
      case ChatListError() when error != null:
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
    required TResult Function(ChatListLoading value) loading,
    required TResult Function(ChatListEmpty value) empty,
    required TResult Function(ChatListLoaded value) loaded,
    required TResult Function(ChatListError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatListLoading():
        return loading(_that);
      case ChatListEmpty():
        return empty(_that);
      case ChatListLoaded():
        return loaded(_that);
      case ChatListError():
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
    TResult? Function(ChatListLoading value)? loading,
    TResult? Function(ChatListEmpty value)? empty,
    TResult? Function(ChatListLoaded value)? loaded,
    TResult? Function(ChatListError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatListLoading() when loading != null:
        return loading(_that);
      case ChatListEmpty() when empty != null:
        return empty(_that);
      case ChatListLoaded() when loaded != null:
        return loaded(_that);
      case ChatListError() when error != null:
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
    TResult Function()? empty,
    TResult Function(
            List<ChatConversationModel> conversations, DataError? actionError)?
        loaded,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ChatListLoading() when loading != null:
        return loading();
      case ChatListEmpty() when empty != null:
        return empty();
      case ChatListLoaded() when loaded != null:
        return loaded(_that.conversations, _that.actionError);
      case ChatListError() when error != null:
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
    required TResult Function() empty,
    required TResult Function(
            List<ChatConversationModel> conversations, DataError? actionError)
        loaded,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatListLoading():
        return loading();
      case ChatListEmpty():
        return empty();
      case ChatListLoaded():
        return loaded(_that.conversations, _that.actionError);
      case ChatListError():
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
    TResult? Function()? empty,
    TResult? Function(
            List<ChatConversationModel> conversations, DataError? actionError)?
        loaded,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case ChatListLoading() when loading != null:
        return loading();
      case ChatListEmpty() when empty != null:
        return empty();
      case ChatListLoaded() when loaded != null:
        return loaded(_that.conversations, _that.actionError);
      case ChatListError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ChatListLoading extends ChatListState {
  const ChatListLoading() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatListLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatListState.loading()';
  }
}

/// @nodoc

class ChatListEmpty extends ChatListState {
  const ChatListEmpty() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ChatListEmpty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ChatListState.empty()';
  }
}

/// @nodoc

class ChatListLoaded extends ChatListState {
  const ChatListLoaded(
      {required final List<ChatConversationModel> conversations,
      this.actionError})
      : _conversations = conversations,
        super._();

  final List<ChatConversationModel> _conversations;
  List<ChatConversationModel> get conversations {
    if (_conversations is EqualUnmodifiableListView) return _conversations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversations);
  }

  final DataError? actionError;

  /// Create a copy of ChatListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatListLoadedCopyWith<ChatListLoaded> get copyWith =>
      _$ChatListLoadedCopyWithImpl<ChatListLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatListLoaded &&
            const DeepCollectionEquality()
                .equals(other._conversations, _conversations) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_conversations), actionError);

  @override
  String toString() {
    return 'ChatListState.loaded(conversations: $conversations, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $ChatListLoadedCopyWith<$Res>
    implements $ChatListStateCopyWith<$Res> {
  factory $ChatListLoadedCopyWith(
          ChatListLoaded value, $Res Function(ChatListLoaded) _then) =
      _$ChatListLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<ChatConversationModel> conversations, DataError? actionError});
}

/// @nodoc
class _$ChatListLoadedCopyWithImpl<$Res>
    implements $ChatListLoadedCopyWith<$Res> {
  _$ChatListLoadedCopyWithImpl(this._self, this._then);

  final ChatListLoaded _self;
  final $Res Function(ChatListLoaded) _then;

  /// Create a copy of ChatListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? conversations = null,
    Object? actionError = freezed,
  }) {
    return _then(ChatListLoaded(
      conversations: null == conversations
          ? _self._conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ChatConversationModel>,
      actionError: freezed == actionError
          ? _self.actionError
          : actionError // ignore: cast_nullable_to_non_nullable
              as DataError?,
    ));
  }
}

/// @nodoc

class ChatListError extends ChatListState {
  const ChatListError(this.error) : super._();

  final DataError error;

  /// Create a copy of ChatListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatListErrorCopyWith<ChatListError> get copyWith =>
      _$ChatListErrorCopyWithImpl<ChatListError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatListError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'ChatListState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $ChatListErrorCopyWith<$Res>
    implements $ChatListStateCopyWith<$Res> {
  factory $ChatListErrorCopyWith(
          ChatListError value, $Res Function(ChatListError) _then) =
      _$ChatListErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$ChatListErrorCopyWithImpl<$Res>
    implements $ChatListErrorCopyWith<$Res> {
  _$ChatListErrorCopyWithImpl(this._self, this._then);

  final ChatListError _self;
  final $Res Function(ChatListError) _then;

  /// Create a copy of ChatListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(ChatListError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
