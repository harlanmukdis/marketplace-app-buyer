// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_layout_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeLayoutState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeLayoutState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeLayoutState()';
  }
}

/// @nodoc
class $HomeLayoutStateCopyWith<$Res> {
  $HomeLayoutStateCopyWith(
      HomeLayoutState _, $Res Function(HomeLayoutState) __);
}

/// Adds pattern-matching-related methods to [HomeLayoutState].
extension HomeLayoutStatePatterns on HomeLayoutState {
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
    TResult Function(HomeLayoutLoading value)? loading,
    TResult Function(HomeLayoutLoaded value)? loaded,
    TResult Function(HomeLayoutHidden value)? hidden,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeLayoutLoading() when loading != null:
        return loading(_that);
      case HomeLayoutLoaded() when loaded != null:
        return loaded(_that);
      case HomeLayoutHidden() when hidden != null:
        return hidden(_that);
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
    required TResult Function(HomeLayoutLoading value) loading,
    required TResult Function(HomeLayoutLoaded value) loaded,
    required TResult Function(HomeLayoutHidden value) hidden,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLayoutLoading():
        return loading(_that);
      case HomeLayoutLoaded():
        return loaded(_that);
      case HomeLayoutHidden():
        return hidden(_that);
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
    TResult? Function(HomeLayoutLoading value)? loading,
    TResult? Function(HomeLayoutLoaded value)? loaded,
    TResult? Function(HomeLayoutHidden value)? hidden,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLayoutLoading() when loading != null:
        return loading(_that);
      case HomeLayoutLoaded() when loaded != null:
        return loaded(_that);
      case HomeLayoutHidden() when hidden != null:
        return hidden(_that);
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
    TResult Function(List<HomeSectionModel> sections)? loaded,
    TResult Function()? hidden,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HomeLayoutLoading() when loading != null:
        return loading();
      case HomeLayoutLoaded() when loaded != null:
        return loaded(_that.sections);
      case HomeLayoutHidden() when hidden != null:
        return hidden();
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
    required TResult Function(List<HomeSectionModel> sections) loaded,
    required TResult Function() hidden,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLayoutLoading():
        return loading();
      case HomeLayoutLoaded():
        return loaded(_that.sections);
      case HomeLayoutHidden():
        return hidden();
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
    TResult? Function(List<HomeSectionModel> sections)? loaded,
    TResult? Function()? hidden,
  }) {
    final _that = this;
    switch (_that) {
      case HomeLayoutLoading() when loading != null:
        return loading();
      case HomeLayoutLoaded() when loaded != null:
        return loaded(_that.sections);
      case HomeLayoutHidden() when hidden != null:
        return hidden();
      case _:
        return null;
    }
  }
}

/// @nodoc

class HomeLayoutLoading implements HomeLayoutState {
  const HomeLayoutLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeLayoutLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeLayoutState.loading()';
  }
}

/// @nodoc

class HomeLayoutLoaded implements HomeLayoutState {
  const HomeLayoutLoaded({required final List<HomeSectionModel> sections})
      : _sections = sections;

  final List<HomeSectionModel> _sections;
  List<HomeSectionModel> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  /// Create a copy of HomeLayoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeLayoutLoadedCopyWith<HomeLayoutLoaded> get copyWith =>
      _$HomeLayoutLoadedCopyWithImpl<HomeLayoutLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeLayoutLoaded &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_sections));

  @override
  String toString() {
    return 'HomeLayoutState.loaded(sections: $sections)';
  }
}

/// @nodoc
abstract mixin class $HomeLayoutLoadedCopyWith<$Res>
    implements $HomeLayoutStateCopyWith<$Res> {
  factory $HomeLayoutLoadedCopyWith(
          HomeLayoutLoaded value, $Res Function(HomeLayoutLoaded) _then) =
      _$HomeLayoutLoadedCopyWithImpl;
  @useResult
  $Res call({List<HomeSectionModel> sections});
}

/// @nodoc
class _$HomeLayoutLoadedCopyWithImpl<$Res>
    implements $HomeLayoutLoadedCopyWith<$Res> {
  _$HomeLayoutLoadedCopyWithImpl(this._self, this._then);

  final HomeLayoutLoaded _self;
  final $Res Function(HomeLayoutLoaded) _then;

  /// Create a copy of HomeLayoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sections = null,
  }) {
    return _then(HomeLayoutLoaded(
      sections: null == sections
          ? _self._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<HomeSectionModel>,
    ));
  }
}

/// @nodoc

class HomeLayoutHidden implements HomeLayoutState {
  const HomeLayoutHidden();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HomeLayoutHidden);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HomeLayoutState.hidden()';
  }
}

// dart format on
