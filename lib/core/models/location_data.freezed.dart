// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GPSCoordinate _$GPSCoordinateFromJson(Map<String, dynamic> json) {
  return _GPSCoordinate.fromJson(json);
}

/// @nodoc
mixin _$GPSCoordinate {
  /// Latitude in degrees
  double get latitude => throw _privateConstructorUsedError;

  /// Longitude in degrees
  double get longitude => throw _privateConstructorUsedError;

  /// When this coordinate was captured
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Accuracy in meters (optional)
  double? get accuracy => throw _privateConstructorUsedError;

  /// Serializes this GPSCoordinate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GPSCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GPSCoordinateCopyWith<GPSCoordinate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GPSCoordinateCopyWith<$Res> {
  factory $GPSCoordinateCopyWith(
          GPSCoordinate value, $Res Function(GPSCoordinate) then) =
      _$GPSCoordinateCopyWithImpl<$Res, GPSCoordinate>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      DateTime timestamp,
      double? accuracy});
}

/// @nodoc
class _$GPSCoordinateCopyWithImpl<$Res, $Val extends GPSCoordinate>
    implements $GPSCoordinateCopyWith<$Res> {
  _$GPSCoordinateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GPSCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? timestamp = null,
    Object? accuracy = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GPSCoordinateImplCopyWith<$Res>
    implements $GPSCoordinateCopyWith<$Res> {
  factory _$$GPSCoordinateImplCopyWith(
          _$GPSCoordinateImpl value, $Res Function(_$GPSCoordinateImpl) then) =
      __$$GPSCoordinateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      DateTime timestamp,
      double? accuracy});
}

/// @nodoc
class __$$GPSCoordinateImplCopyWithImpl<$Res>
    extends _$GPSCoordinateCopyWithImpl<$Res, _$GPSCoordinateImpl>
    implements _$$GPSCoordinateImplCopyWith<$Res> {
  __$$GPSCoordinateImplCopyWithImpl(
      _$GPSCoordinateImpl _value, $Res Function(_$GPSCoordinateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GPSCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? timestamp = null,
    Object? accuracy = freezed,
  }) {
    return _then(_$GPSCoordinateImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GPSCoordinateImpl implements _GPSCoordinate {
  const _$GPSCoordinateImpl(
      {required this.latitude,
      required this.longitude,
      required this.timestamp,
      this.accuracy});

  factory _$GPSCoordinateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GPSCoordinateImplFromJson(json);

  /// Latitude in degrees
  @override
  final double latitude;

  /// Longitude in degrees
  @override
  final double longitude;

  /// When this coordinate was captured
  @override
  final DateTime timestamp;

  /// Accuracy in meters (optional)
  @override
  final double? accuracy;

  @override
  String toString() {
    return 'GPSCoordinate(latitude: $latitude, longitude: $longitude, timestamp: $timestamp, accuracy: $accuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GPSCoordinateImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, latitude, longitude, timestamp, accuracy);

  /// Create a copy of GPSCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GPSCoordinateImplCopyWith<_$GPSCoordinateImpl> get copyWith =>
      __$$GPSCoordinateImplCopyWithImpl<_$GPSCoordinateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GPSCoordinateImplToJson(
      this,
    );
  }
}

abstract class _GPSCoordinate implements GPSCoordinate {
  const factory _GPSCoordinate(
      {required final double latitude,
      required final double longitude,
      required final DateTime timestamp,
      final double? accuracy}) = _$GPSCoordinateImpl;

  factory _GPSCoordinate.fromJson(Map<String, dynamic> json) =
      _$GPSCoordinateImpl.fromJson;

  /// Latitude in degrees
  @override
  double get latitude;

  /// Longitude in degrees
  @override
  double get longitude;

  /// When this coordinate was captured
  @override
  DateTime get timestamp;

  /// Accuracy in meters (optional)
  @override
  double? get accuracy;

  /// Create a copy of GPSCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GPSCoordinateImplCopyWith<_$GPSCoordinateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GPSTestResult _$GPSTestResultFromJson(Map<String, dynamic> json) {
  return _GPSTestResult.fromJson(json);
}

/// @nodoc
mixin _$GPSTestResult {
  /// Location from the phone
  GPSCoordinate get phoneLocation => throw _privateConstructorUsedError;

  /// Location from the collar
  GPSCoordinate get collarLocation => throw _privateConstructorUsedError;

  /// Distance between phone and collar in meters
  double get distanceMeters => throw _privateConstructorUsedError;

  /// Whether the test passed verification
  bool get isVerified => throw _privateConstructorUsedError;

  /// Attempt number (1, 2, 3)
  int get attemptNumber => throw _privateConstructorUsedError;

  /// Verification threshold used (20m or 50m)
  double? get thresholdMeters => throw _privateConstructorUsedError;

  /// Serializes this GPSTestResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GPSTestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GPSTestResultCopyWith<GPSTestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GPSTestResultCopyWith<$Res> {
  factory $GPSTestResultCopyWith(
          GPSTestResult value, $Res Function(GPSTestResult) then) =
      _$GPSTestResultCopyWithImpl<$Res, GPSTestResult>;
  @useResult
  $Res call(
      {GPSCoordinate phoneLocation,
      GPSCoordinate collarLocation,
      double distanceMeters,
      bool isVerified,
      int attemptNumber,
      double? thresholdMeters});

  $GPSCoordinateCopyWith<$Res> get phoneLocation;
  $GPSCoordinateCopyWith<$Res> get collarLocation;
}

/// @nodoc
class _$GPSTestResultCopyWithImpl<$Res, $Val extends GPSTestResult>
    implements $GPSTestResultCopyWith<$Res> {
  _$GPSTestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GPSTestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneLocation = null,
    Object? collarLocation = null,
    Object? distanceMeters = null,
    Object? isVerified = null,
    Object? attemptNumber = null,
    Object? thresholdMeters = freezed,
  }) {
    return _then(_value.copyWith(
      phoneLocation: null == phoneLocation
          ? _value.phoneLocation
          : phoneLocation // ignore: cast_nullable_to_non_nullable
              as GPSCoordinate,
      collarLocation: null == collarLocation
          ? _value.collarLocation
          : collarLocation // ignore: cast_nullable_to_non_nullable
              as GPSCoordinate,
      distanceMeters: null == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as double,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      attemptNumber: null == attemptNumber
          ? _value.attemptNumber
          : attemptNumber // ignore: cast_nullable_to_non_nullable
              as int,
      thresholdMeters: freezed == thresholdMeters
          ? _value.thresholdMeters
          : thresholdMeters // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  /// Create a copy of GPSTestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GPSCoordinateCopyWith<$Res> get phoneLocation {
    return $GPSCoordinateCopyWith<$Res>(_value.phoneLocation, (value) {
      return _then(_value.copyWith(phoneLocation: value) as $Val);
    });
  }

  /// Create a copy of GPSTestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GPSCoordinateCopyWith<$Res> get collarLocation {
    return $GPSCoordinateCopyWith<$Res>(_value.collarLocation, (value) {
      return _then(_value.copyWith(collarLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GPSTestResultImplCopyWith<$Res>
    implements $GPSTestResultCopyWith<$Res> {
  factory _$$GPSTestResultImplCopyWith(
          _$GPSTestResultImpl value, $Res Function(_$GPSTestResultImpl) then) =
      __$$GPSTestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GPSCoordinate phoneLocation,
      GPSCoordinate collarLocation,
      double distanceMeters,
      bool isVerified,
      int attemptNumber,
      double? thresholdMeters});

  @override
  $GPSCoordinateCopyWith<$Res> get phoneLocation;
  @override
  $GPSCoordinateCopyWith<$Res> get collarLocation;
}

/// @nodoc
class __$$GPSTestResultImplCopyWithImpl<$Res>
    extends _$GPSTestResultCopyWithImpl<$Res, _$GPSTestResultImpl>
    implements _$$GPSTestResultImplCopyWith<$Res> {
  __$$GPSTestResultImplCopyWithImpl(
      _$GPSTestResultImpl _value, $Res Function(_$GPSTestResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of GPSTestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneLocation = null,
    Object? collarLocation = null,
    Object? distanceMeters = null,
    Object? isVerified = null,
    Object? attemptNumber = null,
    Object? thresholdMeters = freezed,
  }) {
    return _then(_$GPSTestResultImpl(
      phoneLocation: null == phoneLocation
          ? _value.phoneLocation
          : phoneLocation // ignore: cast_nullable_to_non_nullable
              as GPSCoordinate,
      collarLocation: null == collarLocation
          ? _value.collarLocation
          : collarLocation // ignore: cast_nullable_to_non_nullable
              as GPSCoordinate,
      distanceMeters: null == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as double,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      attemptNumber: null == attemptNumber
          ? _value.attemptNumber
          : attemptNumber // ignore: cast_nullable_to_non_nullable
              as int,
      thresholdMeters: freezed == thresholdMeters
          ? _value.thresholdMeters
          : thresholdMeters // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GPSTestResultImpl implements _GPSTestResult {
  const _$GPSTestResultImpl(
      {required this.phoneLocation,
      required this.collarLocation,
      required this.distanceMeters,
      required this.isVerified,
      this.attemptNumber = 1,
      this.thresholdMeters});

  factory _$GPSTestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GPSTestResultImplFromJson(json);

  /// Location from the phone
  @override
  final GPSCoordinate phoneLocation;

  /// Location from the collar
  @override
  final GPSCoordinate collarLocation;

  /// Distance between phone and collar in meters
  @override
  final double distanceMeters;

  /// Whether the test passed verification
  @override
  final bool isVerified;

  /// Attempt number (1, 2, 3)
  @override
  @JsonKey()
  final int attemptNumber;

  /// Verification threshold used (20m or 50m)
  @override
  final double? thresholdMeters;

  @override
  String toString() {
    return 'GPSTestResult(phoneLocation: $phoneLocation, collarLocation: $collarLocation, distanceMeters: $distanceMeters, isVerified: $isVerified, attemptNumber: $attemptNumber, thresholdMeters: $thresholdMeters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GPSTestResultImpl &&
            (identical(other.phoneLocation, phoneLocation) ||
                other.phoneLocation == phoneLocation) &&
            (identical(other.collarLocation, collarLocation) ||
                other.collarLocation == collarLocation) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.attemptNumber, attemptNumber) ||
                other.attemptNumber == attemptNumber) &&
            (identical(other.thresholdMeters, thresholdMeters) ||
                other.thresholdMeters == thresholdMeters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneLocation, collarLocation,
      distanceMeters, isVerified, attemptNumber, thresholdMeters);

  /// Create a copy of GPSTestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GPSTestResultImplCopyWith<_$GPSTestResultImpl> get copyWith =>
      __$$GPSTestResultImplCopyWithImpl<_$GPSTestResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GPSTestResultImplToJson(
      this,
    );
  }
}

abstract class _GPSTestResult implements GPSTestResult {
  const factory _GPSTestResult(
      {required final GPSCoordinate phoneLocation,
      required final GPSCoordinate collarLocation,
      required final double distanceMeters,
      required final bool isVerified,
      final int attemptNumber,
      final double? thresholdMeters}) = _$GPSTestResultImpl;

  factory _GPSTestResult.fromJson(Map<String, dynamic> json) =
      _$GPSTestResultImpl.fromJson;

  /// Location from the phone
  @override
  GPSCoordinate get phoneLocation;

  /// Location from the collar
  @override
  GPSCoordinate get collarLocation;

  /// Distance between phone and collar in meters
  @override
  double get distanceMeters;

  /// Whether the test passed verification
  @override
  bool get isVerified;

  /// Attempt number (1, 2, 3)
  @override
  int get attemptNumber;

  /// Verification threshold used (20m or 50m)
  @override
  double? get thresholdMeters;

  /// Create a copy of GPSTestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GPSTestResultImplCopyWith<_$GPSTestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LostModeLocation _$LostModeLocationFromJson(Map<String, dynamic> json) {
  return _LostModeLocation.fromJson(json);
}

/// @nodoc
mixin _$LostModeLocation {
  /// Array of 3 GPS coordinates (t=0, t=3, t=6 seconds)
  List<GPSCoordinate> get coordinates => throw _privateConstructorUsedError;

  /// Collar token for authentication
  String get collarToken => throw _privateConstructorUsedError;

  /// When this batch was created
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this LostModeLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LostModeLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LostModeLocationCopyWith<LostModeLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LostModeLocationCopyWith<$Res> {
  factory $LostModeLocationCopyWith(
          LostModeLocation value, $Res Function(LostModeLocation) then) =
      _$LostModeLocationCopyWithImpl<$Res, LostModeLocation>;
  @useResult
  $Res call(
      {List<GPSCoordinate> coordinates,
      String collarToken,
      DateTime timestamp});
}

/// @nodoc
class _$LostModeLocationCopyWithImpl<$Res, $Val extends LostModeLocation>
    implements $LostModeLocationCopyWith<$Res> {
  _$LostModeLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LostModeLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? collarToken = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<GPSCoordinate>,
      collarToken: null == collarToken
          ? _value.collarToken
          : collarToken // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LostModeLocationImplCopyWith<$Res>
    implements $LostModeLocationCopyWith<$Res> {
  factory _$$LostModeLocationImplCopyWith(_$LostModeLocationImpl value,
          $Res Function(_$LostModeLocationImpl) then) =
      __$$LostModeLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GPSCoordinate> coordinates,
      String collarToken,
      DateTime timestamp});
}

/// @nodoc
class __$$LostModeLocationImplCopyWithImpl<$Res>
    extends _$LostModeLocationCopyWithImpl<$Res, _$LostModeLocationImpl>
    implements _$$LostModeLocationImplCopyWith<$Res> {
  __$$LostModeLocationImplCopyWithImpl(_$LostModeLocationImpl _value,
      $Res Function(_$LostModeLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of LostModeLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? collarToken = null,
    Object? timestamp = null,
  }) {
    return _then(_$LostModeLocationImpl(
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<GPSCoordinate>,
      collarToken: null == collarToken
          ? _value.collarToken
          : collarToken // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LostModeLocationImpl implements _LostModeLocation {
  const _$LostModeLocationImpl(
      {required final List<GPSCoordinate> coordinates,
      required this.collarToken,
      required this.timestamp})
      : _coordinates = coordinates;

  factory _$LostModeLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LostModeLocationImplFromJson(json);

  /// Array of 3 GPS coordinates (t=0, t=3, t=6 seconds)
  final List<GPSCoordinate> _coordinates;

  /// Array of 3 GPS coordinates (t=0, t=3, t=6 seconds)
  @override
  List<GPSCoordinate> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  /// Collar token for authentication
  @override
  final String collarToken;

  /// When this batch was created
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'LostModeLocation(coordinates: $coordinates, collarToken: $collarToken, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LostModeLocationImpl &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.collarToken, collarToken) ||
                other.collarToken == collarToken) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_coordinates),
      collarToken,
      timestamp);

  /// Create a copy of LostModeLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LostModeLocationImplCopyWith<_$LostModeLocationImpl> get copyWith =>
      __$$LostModeLocationImplCopyWithImpl<_$LostModeLocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LostModeLocationImplToJson(
      this,
    );
  }
}

abstract class _LostModeLocation implements LostModeLocation {
  const factory _LostModeLocation(
      {required final List<GPSCoordinate> coordinates,
      required final String collarToken,
      required final DateTime timestamp}) = _$LostModeLocationImpl;

  factory _LostModeLocation.fromJson(Map<String, dynamic> json) =
      _$LostModeLocationImpl.fromJson;

  /// Array of 3 GPS coordinates (t=0, t=3, t=6 seconds)
  @override
  List<GPSCoordinate> get coordinates;

  /// Collar token for authentication
  @override
  String get collarToken;

  /// When this batch was created
  @override
  DateTime get timestamp;

  /// Create a copy of LostModeLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LostModeLocationImplCopyWith<_$LostModeLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
