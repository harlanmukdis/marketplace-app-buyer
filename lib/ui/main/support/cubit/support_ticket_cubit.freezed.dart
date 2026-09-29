// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_ticket_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportTicketState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SupportTicketState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SupportTicketState()';
  }
}

/// @nodoc
class $SupportTicketStateCopyWith<$Res> {
  $SupportTicketStateCopyWith(
      SupportTicketState _, $Res Function(SupportTicketState) __);
}

/// Adds pattern-matching-related methods to [SupportTicketState].
extension SupportTicketStatePatterns on SupportTicketState {
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
    TResult Function(SupportTicketLoading value)? loading,
    TResult Function(SupportTicketReady value)? ready,
    TResult Function(SupportTicketError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SupportTicketLoading() when loading != null:
        return loading(_that);
      case SupportTicketReady() when ready != null:
        return ready(_that);
      case SupportTicketError() when error != null:
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
    required TResult Function(SupportTicketLoading value) loading,
    required TResult Function(SupportTicketReady value) ready,
    required TResult Function(SupportTicketError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportTicketLoading():
        return loading(_that);
      case SupportTicketReady():
        return ready(_that);
      case SupportTicketError():
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
    TResult? Function(SupportTicketLoading value)? loading,
    TResult? Function(SupportTicketReady value)? ready,
    TResult? Function(SupportTicketError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportTicketLoading() when loading != null:
        return loading(_that);
      case SupportTicketReady() when ready != null:
        return ready(_that);
      case SupportTicketError() when error != null:
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
            SupportTicketModel ticket,
            List<SupportMessageModel> messages,
            DataError? messagesError,
            bool isSending,
            DataError? actionError)?
        ready,
    TResult Function(DataError error)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SupportTicketLoading() when loading != null:
        return loading();
      case SupportTicketReady() when ready != null:
        return ready(_that.ticket, _that.messages, _that.messagesError,
            _that.isSending, _that.actionError);
      case SupportTicketError() when error != null:
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
            SupportTicketModel ticket,
            List<SupportMessageModel> messages,
            DataError? messagesError,
            bool isSending,
            DataError? actionError)
        ready,
    required TResult Function(DataError error) error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportTicketLoading():
        return loading();
      case SupportTicketReady():
        return ready(_that.ticket, _that.messages, _that.messagesError,
            _that.isSending, _that.actionError);
      case SupportTicketError():
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
            SupportTicketModel ticket,
            List<SupportMessageModel> messages,
            DataError? messagesError,
            bool isSending,
            DataError? actionError)?
        ready,
    TResult? Function(DataError error)? error,
  }) {
    final _that = this;
    switch (_that) {
      case SupportTicketLoading() when loading != null:
        return loading();
      case SupportTicketReady() when ready != null:
        return ready(_that.ticket, _that.messages, _that.messagesError,
            _that.isSending, _that.actionError);
      case SupportTicketError() when error != null:
        return error(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SupportTicketLoading implements SupportTicketState {
  const SupportTicketLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SupportTicketLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SupportTicketState.loading()';
  }
}

/// @nodoc

class SupportTicketReady implements SupportTicketState {
  const SupportTicketReady(
      {required this.ticket,
      final List<SupportMessageModel> messages = const <SupportMessageModel>[],
      this.messagesError,
      this.isSending = false,
      this.actionError})
      : _messages = messages;

  final SupportTicketModel ticket;
  final List<SupportMessageModel> _messages;
  @JsonKey()
  List<SupportMessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// Percakapan gagal dimuat, walau tiketnya terbaca.
  final DataError? messagesError;
  @JsonKey()
  final bool isSending;
  final DataError? actionError;

  /// Create a copy of SupportTicketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportTicketReadyCopyWith<SupportTicketReady> get copyWith =>
      _$SupportTicketReadyCopyWithImpl<SupportTicketReady>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupportTicketReady &&
            (identical(other.ticket, ticket) || other.ticket == ticket) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.messagesError, messagesError) ||
                other.messagesError == messagesError) &&
            (identical(other.isSending, isSending) ||
                other.isSending == isSending) &&
            (identical(other.actionError, actionError) ||
                other.actionError == actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      ticket,
      const DeepCollectionEquality().hash(_messages),
      messagesError,
      isSending,
      actionError);

  @override
  String toString() {
    return 'SupportTicketState.ready(ticket: $ticket, messages: $messages, messagesError: $messagesError, isSending: $isSending, actionError: $actionError)';
  }
}

/// @nodoc
abstract mixin class $SupportTicketReadyCopyWith<$Res>
    implements $SupportTicketStateCopyWith<$Res> {
  factory $SupportTicketReadyCopyWith(
          SupportTicketReady value, $Res Function(SupportTicketReady) _then) =
      _$SupportTicketReadyCopyWithImpl;
  @useResult
  $Res call(
      {SupportTicketModel ticket,
      List<SupportMessageModel> messages,
      DataError? messagesError,
      bool isSending,
      DataError? actionError});

  $SupportTicketModelCopyWith<$Res> get ticket;
}

/// @nodoc
class _$SupportTicketReadyCopyWithImpl<$Res>
    implements $SupportTicketReadyCopyWith<$Res> {
  _$SupportTicketReadyCopyWithImpl(this._self, this._then);

  final SupportTicketReady _self;
  final $Res Function(SupportTicketReady) _then;

  /// Create a copy of SupportTicketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ticket = null,
    Object? messages = null,
    Object? messagesError = freezed,
    Object? isSending = null,
    Object? actionError = freezed,
  }) {
    return _then(SupportTicketReady(
      ticket: null == ticket
          ? _self.ticket
          : ticket // ignore: cast_nullable_to_non_nullable
              as SupportTicketModel,
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<SupportMessageModel>,
      messagesError: freezed == messagesError
          ? _self.messagesError
          : messagesError // ignore: cast_nullable_to_non_nullable
              as DataError?,
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

  /// Create a copy of SupportTicketState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupportTicketModelCopyWith<$Res> get ticket {
    return $SupportTicketModelCopyWith<$Res>(_self.ticket, (value) {
      return _then(_self.copyWith(ticket: value));
    });
  }
}

/// @nodoc

class SupportTicketError implements SupportTicketState {
  const SupportTicketError(this.error);

  final DataError error;

  /// Create a copy of SupportTicketState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupportTicketErrorCopyWith<SupportTicketError> get copyWith =>
      _$SupportTicketErrorCopyWithImpl<SupportTicketError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupportTicketError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'SupportTicketState.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $SupportTicketErrorCopyWith<$Res>
    implements $SupportTicketStateCopyWith<$Res> {
  factory $SupportTicketErrorCopyWith(
          SupportTicketError value, $Res Function(SupportTicketError) _then) =
      _$SupportTicketErrorCopyWithImpl;
  @useResult
  $Res call({DataError error});
}

/// @nodoc
class _$SupportTicketErrorCopyWithImpl<$Res>
    implements $SupportTicketErrorCopyWith<$Res> {
  _$SupportTicketErrorCopyWithImpl(this._self, this._then);

  final SupportTicketError _self;
  final $Res Function(SupportTicketError) _then;

  /// Create a copy of SupportTicketState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(SupportTicketError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as DataError,
    ));
  }
}

// dart format on
