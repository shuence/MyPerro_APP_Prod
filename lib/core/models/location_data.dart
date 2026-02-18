import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_data.freezed.dart';
part 'location_data.g.dart';

/// Represents a GPS coordinate with timestamp
@freezed
class GPSCoordinate with _$GPSCoordinate {
  const factory GPSCoordinate({
    /// Latitude in degrees
    required double latitude,

    /// Longitude in degrees
    required double longitude,

    /// When this coordinate was captured
    required DateTime timestamp,

    /// Accuracy in meters (optional)
    double? accuracy,
  }) = _GPSCoordinate;

  factory GPSCoordinate.fromJson(Map<String, dynamic> json) =>
      _$GPSCoordinateFromJson(json);
}

/// Result of a GPS verification test comparing phone and collar coordinates
@freezed
class GPSTestResult with _$GPSTestResult {
  const factory GPSTestResult({
    /// Location from the phone
    required GPSCoordinate phoneLocation,

    /// Location from the collar
    required GPSCoordinate collarLocation,

    /// Distance between phone and collar in meters
    required double distanceMeters,

    /// Whether the test passed verification
    required bool isVerified,

    /// Attempt number (1, 2, 3)
    @Default(1) int attemptNumber,

    /// Verification threshold used (20m or 50m)
    double? thresholdMeters,
  }) = _GPSTestResult;

  factory GPSTestResult.fromJson(Map<String, dynamic> json) =>
      _$GPSTestResultFromJson(json);
}

/// Extension methods for GPSCoordinate
extension GPSCoordinateExtension on GPSCoordinate {
  /// Format coordinate as "lat,long" string for BLE transmission
  String toLatLongString() {
    return '$latitude,$longitude';
  }

  /// Parse coordinate from "lat,long" string received via BLE
  static GPSCoordinate fromLatLongString(String latLong) {
    final parts = latLong.split(',');
    if (parts.length != 2) {
      throw FormatException('Invalid lat,long format: $latLong');
    }

    return GPSCoordinate(
      latitude: double.parse(parts[0].trim()),
      longitude: double.parse(parts[1].trim()),
      timestamp: DateTime.now(),
    );
  }
}

/// Extension methods for GPSTestResult
extension GPSTestResultExtension on GPSTestResult {
  /// Whether the distance is within 20 meters (immediate pass)
  bool get isWithin20Meters => distanceMeters <= 20;

  /// Whether the distance is within 50 meters (fallback pass)
  bool get isWithin50Meters => distanceMeters <= 50;

  /// Get a human-readable result message
  String get resultMessage {
    if (isVerified) {
      return 'GPS Verified! Distance: ${distanceMeters.toStringAsFixed(1)}m';
    } else {
      return 'Test Failed. Distance: ${distanceMeters.toStringAsFixed(1)}m (max: ${thresholdMeters?.toStringAsFixed(0) ?? "50"}m)';
    }
  }

  /// Calculate distance between two GPS coordinates using Haversine formula
  ///
  /// Returns distance in meters
  static double _calculateDistance(
    GPSCoordinate coord1,
    GPSCoordinate coord2,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    // Convert to radians
    final lat1 = coord1.latitude * math.pi / 180;
    final lat2 = coord2.latitude * math.pi / 180;
    final dLat = (coord2.latitude - coord1.latitude) * math.pi / 180;
    final dLon = (coord2.longitude - coord1.longitude) * math.pi / 180;

    // Haversine formula
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c; // Distance in meters
  }

  /// Create a GPSTestResult from two coordinates
  ///
  /// Calculates distance and determines if test is verified based on:
  /// - First attempt: Pass if within 20m
  /// - Retry attempts: Pass if within 50m
  static GPSTestResult fromCoordinates({
    required GPSCoordinate phoneLocation,
    required GPSCoordinate collarLocation,
    required int attemptNumber,
  }) {
    final distance = _calculateDistance(phoneLocation, collarLocation);

    // Determine threshold and verification
    final bool isVerified;
    final double threshold;

    if (attemptNumber == 1) {
      // First attempt: must be within 20m
      threshold = 20.0;
      isVerified = distance <= threshold;
    } else {
      // Retry attempts: allow up to 50m
      threshold = 50.0;
      isVerified = distance <= threshold;
    }

    return GPSTestResult(
      phoneLocation: phoneLocation,
      collarLocation: collarLocation,
      distanceMeters: distance,
      isVerified: isVerified,
      attemptNumber: attemptNumber,
      thresholdMeters: threshold,
    );
  }
}

/// Lost mode location data sent to backend
@freezed
class LostModeLocation with _$LostModeLocation {
  const factory LostModeLocation({
    /// Array of 3 GPS coordinates (t=0, t=3, t=6 seconds)
    required List<GPSCoordinate> coordinates,

    /// Collar token for authentication
    required String collarToken,

    /// When this batch was created
    required DateTime timestamp,
  }) = _LostModeLocation;

  factory LostModeLocation.fromJson(Map<String, dynamic> json) =>
      _$LostModeLocationFromJson(json);
}
