import 'package:freezed_annotation/freezed_annotation.dart';

part 'collar.freezed.dart';
part 'collar.g.dart';

/// Represents a pet collar device
@freezed
class Collar with _$Collar {
  const factory Collar({
    /// 15-digit IMEI number from QR code
    required String imei,

    /// Backend-provided token for API authentication
    required String collarToken,

    /// Display name for the collar (e.g., "Krypto's Collar")
    required String deviceName,

    /// ID of the pet this collar is attached to
    required String petId,

    /// Current connection status
    @Default(CollarStatus.disconnected) CollarStatus status,

    /// Firmware version (optional, received from device)
    String? firmwareVersion,

    /// Battery level percentage (0-100)
    int? batteryLevel,

    /// Last time the collar synced with the app
    DateTime? lastSync,

    /// WiFi SSID the collar is connected to (for geofence)
    String? wifiSSID,

    /// RSSI threshold for geofence OUT (pet leaving home)
    int? geofenceOutThreshold,

    /// RSSI threshold for geofence IN (pet at home)
    int? geofenceInThreshold,

    /// Whether the collar is currently in lost mode
    @Default(false) bool isLost,
  }) = _Collar;

  factory Collar.fromJson(Map<String, dynamic> json) => _$CollarFromJson(json);
}

/// Connection status of the collar
enum CollarStatus {
  /// Not connected via Bluetooth
  disconnected,

  /// Scanning for the device
  scanning,

  /// Attempting to connect
  connecting,

  /// Connected via Bluetooth
  connected,

  /// Pairing in progress (IMEI verification, registration)
  pairing,

  /// Setup complete, ready for normal operation
  ready,

  /// Error state
  error,
}
