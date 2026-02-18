// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GPSCoordinateImpl _$$GPSCoordinateImplFromJson(Map<String, dynamic> json) =>
    _$GPSCoordinateImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$GPSCoordinateImplToJson(_$GPSCoordinateImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timestamp': instance.timestamp.toIso8601String(),
      'accuracy': instance.accuracy,
    };

_$GPSTestResultImpl _$$GPSTestResultImplFromJson(Map<String, dynamic> json) =>
    _$GPSTestResultImpl(
      phoneLocation:
          GPSCoordinate.fromJson(json['phoneLocation'] as Map<String, dynamic>),
      collarLocation: GPSCoordinate.fromJson(
          json['collarLocation'] as Map<String, dynamic>),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      isVerified: json['isVerified'] as bool,
      attemptNumber: (json['attemptNumber'] as num?)?.toInt() ?? 1,
      thresholdMeters: (json['thresholdMeters'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$GPSTestResultImplToJson(_$GPSTestResultImpl instance) =>
    <String, dynamic>{
      'phoneLocation': instance.phoneLocation,
      'collarLocation': instance.collarLocation,
      'distanceMeters': instance.distanceMeters,
      'isVerified': instance.isVerified,
      'attemptNumber': instance.attemptNumber,
      'thresholdMeters': instance.thresholdMeters,
    };

_$LostModeLocationImpl _$$LostModeLocationImplFromJson(
        Map<String, dynamic> json) =>
    _$LostModeLocationImpl(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => GPSCoordinate.fromJson(e as Map<String, dynamic>))
          .toList(),
      collarToken: json['collarToken'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$LostModeLocationImplToJson(
        _$LostModeLocationImpl instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'collarToken': instance.collarToken,
      'timestamp': instance.timestamp.toIso8601String(),
    };
