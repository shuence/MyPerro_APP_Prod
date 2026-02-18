// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Collar _$CollarFromJson(Map<String, dynamic> json) {
  return _Collar.fromJson(json);
}

/// @nodoc
mixin _$Collar {
  /// 15-digit IMEI number from QR code
  String get imei => throw _privateConstructorUsedError;

  /// Backend-provided token for API authentication
  String get collarToken => throw _privateConstructorUsedError;

  /// Display name for the collar (e.g., "Krypto's Collar")
  String get deviceName => throw _privateConstructorUsedError;

  /// ID of the pet this collar is attached to
  String get petId => throw _privateConstructorUsedError;

  /// Current connection status
  CollarStatus get status => throw _privateConstructorUsedError;

  /// Firmware version (optional, received from device)
  String? get firmwareVersion => throw _privateConstructorUsedError;

  /// Battery level percentage (0-100)
  int? get batteryLevel => throw _privateConstructorUsedError;

  /// Last time the collar synced with the app
  DateTime? get lastSync => throw _privateConstructorUsedError;

  /// WiFi SSID the collar is connected to (for geofence)
  String? get wifiSSID => throw _privateConstructorUsedError;

  /// RSSI threshold for geofence OUT (pet leaving home)
  int? get geofenceOutThreshold => throw _privateConstructorUsedError;

  /// RSSI threshold for geofence IN (pet at home)
  int? get geofenceInThreshold => throw _privateConstructorUsedError;

  /// Whether the collar is currently in lost mode
  bool get isLost => throw _privateConstructorUsedError;

  /// Serializes this Collar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollarCopyWith<Collar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollarCopyWith<$Res> {
  factory $CollarCopyWith(Collar value, $Res Function(Collar) then) =
      _$CollarCopyWithImpl<$Res, Collar>;
  @useResult
  $Res call(
      {String imei,
      String collarToken,
      String deviceName,
      String petId,
      CollarStatus status,
      String? firmwareVersion,
      int? batteryLevel,
      DateTime? lastSync,
      String? wifiSSID,
      int? geofenceOutThreshold,
      int? geofenceInThreshold,
      bool isLost});
}

/// @nodoc
class _$CollarCopyWithImpl<$Res, $Val extends Collar>
    implements $CollarCopyWith<$Res> {
  _$CollarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? collarToken = null,
    Object? deviceName = null,
    Object? petId = null,
    Object? status = null,
    Object? firmwareVersion = freezed,
    Object? batteryLevel = freezed,
    Object? lastSync = freezed,
    Object? wifiSSID = freezed,
    Object? geofenceOutThreshold = freezed,
    Object? geofenceInThreshold = freezed,
    Object? isLost = null,
  }) {
    return _then(_value.copyWith(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      collarToken: null == collarToken
          ? _value.collarToken
          : collarToken // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CollarStatus,
      firmwareVersion: freezed == firmwareVersion
          ? _value.firmwareVersion
          : firmwareVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      wifiSSID: freezed == wifiSSID
          ? _value.wifiSSID
          : wifiSSID // ignore: cast_nullable_to_non_nullable
              as String?,
      geofenceOutThreshold: freezed == geofenceOutThreshold
          ? _value.geofenceOutThreshold
          : geofenceOutThreshold // ignore: cast_nullable_to_non_nullable
              as int?,
      geofenceInThreshold: freezed == geofenceInThreshold
          ? _value.geofenceInThreshold
          : geofenceInThreshold // ignore: cast_nullable_to_non_nullable
              as int?,
      isLost: null == isLost
          ? _value.isLost
          : isLost // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollarImplCopyWith<$Res> implements $CollarCopyWith<$Res> {
  factory _$$CollarImplCopyWith(
          _$CollarImpl value, $Res Function(_$CollarImpl) then) =
      __$$CollarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String imei,
      String collarToken,
      String deviceName,
      String petId,
      CollarStatus status,
      String? firmwareVersion,
      int? batteryLevel,
      DateTime? lastSync,
      String? wifiSSID,
      int? geofenceOutThreshold,
      int? geofenceInThreshold,
      bool isLost});
}

/// @nodoc
class __$$CollarImplCopyWithImpl<$Res>
    extends _$CollarCopyWithImpl<$Res, _$CollarImpl>
    implements _$$CollarImplCopyWith<$Res> {
  __$$CollarImplCopyWithImpl(
      _$CollarImpl _value, $Res Function(_$CollarImpl) _then)
      : super(_value, _then);

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imei = null,
    Object? collarToken = null,
    Object? deviceName = null,
    Object? petId = null,
    Object? status = null,
    Object? firmwareVersion = freezed,
    Object? batteryLevel = freezed,
    Object? lastSync = freezed,
    Object? wifiSSID = freezed,
    Object? geofenceOutThreshold = freezed,
    Object? geofenceInThreshold = freezed,
    Object? isLost = null,
  }) {
    return _then(_$CollarImpl(
      imei: null == imei
          ? _value.imei
          : imei // ignore: cast_nullable_to_non_nullable
              as String,
      collarToken: null == collarToken
          ? _value.collarToken
          : collarToken // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CollarStatus,
      firmwareVersion: freezed == firmwareVersion
          ? _value.firmwareVersion
          : firmwareVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      wifiSSID: freezed == wifiSSID
          ? _value.wifiSSID
          : wifiSSID // ignore: cast_nullable_to_non_nullable
              as String?,
      geofenceOutThreshold: freezed == geofenceOutThreshold
          ? _value.geofenceOutThreshold
          : geofenceOutThreshold // ignore: cast_nullable_to_non_nullable
              as int?,
      geofenceInThreshold: freezed == geofenceInThreshold
          ? _value.geofenceInThreshold
          : geofenceInThreshold // ignore: cast_nullable_to_non_nullable
              as int?,
      isLost: null == isLost
          ? _value.isLost
          : isLost // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollarImpl implements _Collar {
  const _$CollarImpl(
      {required this.imei,
      required this.collarToken,
      required this.deviceName,
      required this.petId,
      this.status = CollarStatus.disconnected,
      this.firmwareVersion,
      this.batteryLevel,
      this.lastSync,
      this.wifiSSID,
      this.geofenceOutThreshold,
      this.geofenceInThreshold,
      this.isLost = false});

  factory _$CollarImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollarImplFromJson(json);

  /// 15-digit IMEI number from QR code
  @override
  final String imei;

  /// Backend-provided token for API authentication
  @override
  final String collarToken;

  /// Display name for the collar (e.g., "Krypto's Collar")
  @override
  final String deviceName;

  /// ID of the pet this collar is attached to
  @override
  final String petId;

  /// Current connection status
  @override
  @JsonKey()
  final CollarStatus status;

  /// Firmware version (optional, received from device)
  @override
  final String? firmwareVersion;

  /// Battery level percentage (0-100)
  @override
  final int? batteryLevel;

  /// Last time the collar synced with the app
  @override
  final DateTime? lastSync;

  /// WiFi SSID the collar is connected to (for geofence)
  @override
  final String? wifiSSID;

  /// RSSI threshold for geofence OUT (pet leaving home)
  @override
  final int? geofenceOutThreshold;

  /// RSSI threshold for geofence IN (pet at home)
  @override
  final int? geofenceInThreshold;

  /// Whether the collar is currently in lost mode
  @override
  @JsonKey()
  final bool isLost;

  @override
  String toString() {
    return 'Collar(imei: $imei, collarToken: $collarToken, deviceName: $deviceName, petId: $petId, status: $status, firmwareVersion: $firmwareVersion, batteryLevel: $batteryLevel, lastSync: $lastSync, wifiSSID: $wifiSSID, geofenceOutThreshold: $geofenceOutThreshold, geofenceInThreshold: $geofenceInThreshold, isLost: $isLost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollarImpl &&
            (identical(other.imei, imei) || other.imei == imei) &&
            (identical(other.collarToken, collarToken) ||
                other.collarToken == collarToken) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.firmwareVersion, firmwareVersion) ||
                other.firmwareVersion == firmwareVersion) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.lastSync, lastSync) ||
                other.lastSync == lastSync) &&
            (identical(other.wifiSSID, wifiSSID) ||
                other.wifiSSID == wifiSSID) &&
            (identical(other.geofenceOutThreshold, geofenceOutThreshold) ||
                other.geofenceOutThreshold == geofenceOutThreshold) &&
            (identical(other.geofenceInThreshold, geofenceInThreshold) ||
                other.geofenceInThreshold == geofenceInThreshold) &&
            (identical(other.isLost, isLost) || other.isLost == isLost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      imei,
      collarToken,
      deviceName,
      petId,
      status,
      firmwareVersion,
      batteryLevel,
      lastSync,
      wifiSSID,
      geofenceOutThreshold,
      geofenceInThreshold,
      isLost);

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollarImplCopyWith<_$CollarImpl> get copyWith =>
      __$$CollarImplCopyWithImpl<_$CollarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollarImplToJson(
      this,
    );
  }
}

abstract class _Collar implements Collar {
  const factory _Collar(
      {required final String imei,
      required final String collarToken,
      required final String deviceName,
      required final String petId,
      final CollarStatus status,
      final String? firmwareVersion,
      final int? batteryLevel,
      final DateTime? lastSync,
      final String? wifiSSID,
      final int? geofenceOutThreshold,
      final int? geofenceInThreshold,
      final bool isLost}) = _$CollarImpl;

  factory _Collar.fromJson(Map<String, dynamic> json) = _$CollarImpl.fromJson;

  /// 15-digit IMEI number from QR code
  @override
  String get imei;

  /// Backend-provided token for API authentication
  @override
  String get collarToken;

  /// Display name for the collar (e.g., "Krypto's Collar")
  @override
  String get deviceName;

  /// ID of the pet this collar is attached to
  @override
  String get petId;

  /// Current connection status
  @override
  CollarStatus get status;

  /// Firmware version (optional, received from device)
  @override
  String? get firmwareVersion;

  /// Battery level percentage (0-100)
  @override
  int? get batteryLevel;

  /// Last time the collar synced with the app
  @override
  DateTime? get lastSync;

  /// WiFi SSID the collar is connected to (for geofence)
  @override
  String? get wifiSSID;

  /// RSSI threshold for geofence OUT (pet leaving home)
  @override
  int? get geofenceOutThreshold;

  /// RSSI threshold for geofence IN (pet at home)
  @override
  int? get geofenceInThreshold;

  /// Whether the collar is currently in lost mode
  @override
  bool get isLost;

  /// Create a copy of Collar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollarImplCopyWith<_$CollarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
