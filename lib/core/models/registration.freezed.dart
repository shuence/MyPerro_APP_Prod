// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) {
  return _RegistrationRequest.fromJson(json);
}

/// @nodoc
mixin _$RegistrationRequest {
  /// 15-digit IMEI from the collar
  String get imei => throw _privateConstructorUsedError;

  /// Current user's ID
  String get userId => throw _privateConstructorUsedError;

  /// Current user's authentication token
  String get userToken => throw _privateConstructorUsedError;

  /// Serializes this RegistrationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationRequestCopyWith<RegistrationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationRequestCopyWith<$Res> {
  factory $RegistrationRequestCopyWith(
          RegistrationRequest value, $Res Function(RegistrationRequest) then) =
      _$RegistrationRequestCopyWithImpl<$Res, RegistrationRequest>;
  @useResult
  $Res call({String imei, String userId, String userToken});
}

/// @nodoc
class _$RegistrationRequestCopyWithImpl<$Res, $Val extends RegistrationRequest>
    implements $RegistrationRequestCopyWith<$Res> {
  _$RegistrationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? userId = null,
    Object? userToken = null,
  }) {
    return _then(_value.copyWith(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userToken: null == userToken
          ? _value.userToken
          : userToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationRequestImplCopyWith<$Res>
    implements $RegistrationRequestCopyWith<$Res> {
  factory _$$RegistrationRequestImplCopyWith(_$RegistrationRequestImpl value,
          $Res Function(_$RegistrationRequestImpl) then) =
      __$$RegistrationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String imei, String userId, String userToken});
}

/// @nodoc
class __$$RegistrationRequestImplCopyWithImpl<$Res>
    extends _$RegistrationRequestCopyWithImpl<$Res, _$RegistrationRequestImpl>
    implements _$$RegistrationRequestImplCopyWith<$Res> {
  __$$RegistrationRequestImplCopyWithImpl(_$RegistrationRequestImpl _value,
      $Res Function(_$RegistrationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? userId = null,
    Object? userToken = null,
  }) {
    return _then(_$RegistrationRequestImpl(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userToken: null == userToken
          ? _value.userToken
          : userToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationRequestImpl implements _RegistrationRequest {
  const _$RegistrationRequestImpl(
      {required this.imei, required this.userId, required this.userToken});

  factory _$RegistrationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationRequestImplFromJson(json);

  /// 15-digit IMEI from the collar
  @override
  final String imei;

  /// Current user's ID
  @override
  final String userId;

  /// Current user's authentication token
  @override
  final String userToken;

  @override
  String toString() {
    return 'RegistrationRequest(imei: $imei, userId: $userId, userToken: $userToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationRequestImpl &&
            (identical(other.imei, imei) || other.imei == imei) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userToken, userToken) ||
                other.userToken == userToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, imei, userId, userToken);

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationRequestImplCopyWith<_$RegistrationRequestImpl> get copyWith =>
      __$$RegistrationRequestImplCopyWithImpl<_$RegistrationRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationRequestImplToJson(
      this,
    );
  }
}

abstract class _RegistrationRequest implements RegistrationRequest {
  const factory _RegistrationRequest(
      {required final String imei,
      required final String userId,
      required final String userToken}) = _$RegistrationRequestImpl;

  factory _RegistrationRequest.fromJson(Map<String, dynamic> json) =
      _$RegistrationRequestImpl.fromJson;

  /// 15-digit IMEI from the collar
  @override
  String get imei;

  /// Current user's ID
  @override
  String get userId;

  /// Current user's authentication token
  @override
  String get userToken;

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationRequestImplCopyWith<_$RegistrationRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegistrationResponse _$RegistrationResponseFromJson(Map<String, dynamic> json) {
  return _RegistrationResponse.fromJson(json);
}

/// @nodoc
mixin _$RegistrationResponse {
  /// Registration status (A, B, or C from SRS)
  RegistrationStatus get status => throw _privateConstructorUsedError;

  /// Backend-generated collar token (for Cases A & C)
  String? get collarToken => throw _privateConstructorUsedError;

  /// Human-readable message
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this RegistrationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationResponseCopyWith<RegistrationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationResponseCopyWith<$Res> {
  factory $RegistrationResponseCopyWith(RegistrationResponse value,
          $Res Function(RegistrationResponse) then) =
      _$RegistrationResponseCopyWithImpl<$Res, RegistrationResponse>;
  @useResult
  $Res call({RegistrationStatus status, String? collarToken, String? message});
}

/// @nodoc
class _$RegistrationResponseCopyWithImpl<$Res,
        $Val extends RegistrationResponse>
    implements $RegistrationResponseCopyWith<$Res> {
  _$RegistrationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? collarToken = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      collarToken: freezed == collarToken
          ? _value.collarToken
          : collarToken // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationResponseImplCopyWith<$Res>
    implements $RegistrationResponseCopyWith<$Res> {
  factory _$$RegistrationResponseImplCopyWith(_$RegistrationResponseImpl value,
          $Res Function(_$RegistrationResponseImpl) then) =
      __$$RegistrationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RegistrationStatus status, String? collarToken, String? message});
}

/// @nodoc
class __$$RegistrationResponseImplCopyWithImpl<$Res>
    extends _$RegistrationResponseCopyWithImpl<$Res, _$RegistrationResponseImpl>
    implements _$$RegistrationResponseImplCopyWith<$Res> {
  __$$RegistrationResponseImplCopyWithImpl(_$RegistrationResponseImpl _value,
      $Res Function(_$RegistrationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? collarToken = freezed,
    Object? message = freezed,
  }) {
    return _then(_$RegistrationResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      collarToken: freezed == collarToken
          ? _value.collarToken
          : collarToken // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationResponseImpl implements _RegistrationResponse {
  const _$RegistrationResponseImpl(
      {required this.status, this.collarToken, this.message});

  factory _$RegistrationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationResponseImplFromJson(json);

  /// Registration status (A, B, or C from SRS)
  @override
  final RegistrationStatus status;

  /// Backend-generated collar token (for Cases A & C)
  @override
  final String? collarToken;

  /// Human-readable message
  @override
  final String? message;

  @override
  String toString() {
    return 'RegistrationResponse(status: $status, collarToken: $collarToken, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.collarToken, collarToken) ||
                other.collarToken == collarToken) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, collarToken, message);

  /// Create a copy of RegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationResponseImplCopyWith<_$RegistrationResponseImpl>
      get copyWith =>
          __$$RegistrationResponseImplCopyWithImpl<_$RegistrationResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationResponseImplToJson(
      this,
    );
  }
}

abstract class _RegistrationResponse implements RegistrationResponse {
  const factory _RegistrationResponse(
      {required final RegistrationStatus status,
      final String? collarToken,
      final String? message}) = _$RegistrationResponseImpl;

  factory _RegistrationResponse.fromJson(Map<String, dynamic> json) =
      _$RegistrationResponseImpl.fromJson;

  /// Registration status (A, B, or C from SRS)
  @override
  RegistrationStatus get status;

  /// Backend-generated collar token (for Cases A & C)
  @override
  String? get collarToken;

  /// Human-readable message
  @override
  String? get message;

  /// Create a copy of RegistrationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationResponseImplCopyWith<_$RegistrationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
