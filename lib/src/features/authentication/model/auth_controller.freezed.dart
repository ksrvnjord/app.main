// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Auth {
  String? get accessToken => throw _privateConstructorUsedError;
  DateTime? get expiration => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  bool get authenticated => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthCopyWith<Auth> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCopyWith<$Res> {
  factory $AuthCopyWith(Auth value, $Res Function(Auth) then) =
      _$AuthCopyWithImpl<$Res, Auth>;
  @useResult
  $Res call(
      {String? accessToken,
      DateTime? expiration,
      String error,
      bool authenticated});
}

/// @nodoc
class _$AuthCopyWithImpl<$Res, $Val extends Auth>
    implements $AuthCopyWith<$Res> {
  _$AuthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? expiration = freezed,
    Object? error = null,
    Object? authenticated = null,
  }) {
    return _then(_value.copyWith(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiration: freezed == expiration
          ? _value.expiration
          : expiration // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      authenticated: null == authenticated
          ? _value.authenticated
          : authenticated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthImplCopyWith<$Res> implements $AuthCopyWith<$Res> {
  factory _$$AuthImplCopyWith(
          _$AuthImpl value, $Res Function(_$AuthImpl) then) =
      __$$AuthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? accessToken,
      DateTime? expiration,
      String error,
      bool authenticated});
}

/// @nodoc
class __$$AuthImplCopyWithImpl<$Res>
    extends _$AuthCopyWithImpl<$Res, _$AuthImpl>
    implements _$$AuthImplCopyWith<$Res> {
  __$$AuthImplCopyWithImpl(_$AuthImpl _value, $Res Function(_$AuthImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? expiration = freezed,
    Object? error = null,
    Object? authenticated = null,
  }) {
    return _then(_$AuthImpl(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiration: freezed == expiration
          ? _value.expiration
          : expiration // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      authenticated: null == authenticated
          ? _value.authenticated
          : authenticated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthImpl with DiagnosticableTreeMixin implements _Auth {
  _$AuthImpl(
      {this.accessToken,
      this.expiration,
      this.error = '',
      required this.authenticated});

  @override
  final String? accessToken;
  @override
  final DateTime? expiration;
  @override
  @JsonKey()
  final String error;
  @override
  final bool authenticated;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Auth(accessToken: $accessToken, expiration: $expiration, error: $error, authenticated: $authenticated)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Auth'))
      ..add(DiagnosticsProperty('accessToken', accessToken))
      ..add(DiagnosticsProperty('expiration', expiration))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('authenticated', authenticated));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.expiration, expiration) ||
                other.expiration == expiration) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.authenticated, authenticated) ||
                other.authenticated == authenticated));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, expiration, error, authenticated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthImplCopyWith<_$AuthImpl> get copyWith =>
      __$$AuthImplCopyWithImpl<_$AuthImpl>(this, _$identity);
}

abstract class _Auth implements Auth {
  factory _Auth(
      {final String? accessToken,
      final DateTime? expiration,
      final String error,
      required final bool authenticated}) = _$AuthImpl;

  @override
  String? get accessToken;
  @override
  DateTime? get expiration;
  @override
  String get error;
  @override
  bool get authenticated;
  @override
  @JsonKey(ignore: true)
  _$$AuthImplCopyWith<_$AuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
