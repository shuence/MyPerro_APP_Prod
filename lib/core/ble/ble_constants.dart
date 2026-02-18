/// BLE (Bluetooth Low Energy) constants for collar communication
///
/// Uses Nordic UART Service (NUS) for BLE communication
class BleConstants {
  // Prevent instantiation
  BleConstants._();

  // ==================== Nordic UART Service UUIDs ====================

  /// Nordic UART Service UUID
  /// This is the main service that provides UART-like communication over BLE
  static const String nordicUartServiceUuid = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';

  /// RX Characteristic UUID (Write to collar)
  /// App writes commands to this characteristic to send data to the collar
  static const String nordicUartRxUuid = '6E400002-B5A3-F393-E0A9-E50E24DCCA9E';

  /// TX Characteristic UUID (Read from collar / Notify)
  /// Collar sends responses through this characteristic (via notifications)
  static const String nordicUartTxUuid = '6E400003-B5A3-F393-E0A9-E50E24DCCA9E';

  // ==================== BLE Commands (App → Collar) ====================

  /// Request collar to send its IMEI
  /// Collar responds with 15-digit IMEI string
  static const String cmdSendImei = 'Send IMEI';

  /// Send collar token to collar after registration
  /// Format: "CollarToken:<token>"
  /// Example: "CollarToken:abc123xyz789"
  static String cmdCollarToken(String token) => 'CollarToken:$token';

  /// Prefix for collar token command (for parsing)
  static const String cmdCollarTokenPrefix = 'CollarToken:';

  /// Command to set geofence
  /// Collar will measure WiFi RSSI and save geofence thresholds
  static const String cmdSetGeofence = 'set geofence';

  /// Command to start GPS test
  /// Collar will turn on GPS, get fix, and send coordinates
  static const String cmdStartGpsTest = 'start GPS Test';

  /// Notify collar that GPS location was verified (test passed)
  static const String cmdLocationVerified = 'location Verified';

  /// Notify collar that GPS test failed (retry needed)
  static const String cmdTestFailed = 'Test failed';

  // ==================== BLE Responses (Collar → App) ====================

  /// Response indicating geofence setup is complete
  static const String respGeofenceSet = 'Geofence is set';

  // Note: IMEI response is a 15-digit number (no constant)
  // Note: GPS coordinates response format: "latitude,longitude"

  // ==================== Timeouts & Configuration ====================

  /// How long to scan for BLE devices before giving up
  static const Duration scanTimeout = Duration(seconds: 30);

  /// How long to wait for BLE connection to establish
  static const Duration connectionTimeout = Duration(seconds: 15);

  /// How long to wait for a command response
  static const Duration commandTimeout = Duration(seconds: 10);

  /// How long to wait for GPS test response (collar needs time to get fix)
  static const Duration gpsTestTimeout = Duration(minutes: 3);

  /// Maximum time for geofence setup
  static const Duration geofenceTimeout = Duration(seconds: 30);

  // ==================== Helper Methods ====================

  /// Parse collar token from command
  /// Input: "CollarToken:abc123xyz"
  /// Output: "abc123xyz"
  static String? parseCollarToken(String command) {
    if (command.startsWith(cmdCollarTokenPrefix)) {
      return command.substring(cmdCollarTokenPrefix.length);
    }
    return null;
  }

  /// Validate IMEI format (15 digits)
  static bool isValidImei(String imei) {
    return RegExp(r'^\d{15}$').hasMatch(imei);
  }

  /// Parse GPS coordinates from BLE response
  /// Input: "12.9716,77.5946"
  /// Output: {latitude: 12.9716, longitude: 77.5946}
  static Map<String, double>? parseGpsCoordinates(String response) {
    try {
      final parts = response.split(',');
      if (parts.length != 2) return null;

      final latitude = double.parse(parts[0].trim());
      final longitude = double.parse(parts[1].trim());

      return {'latitude': latitude, 'longitude': longitude};
    } catch (e) {
      return null;
    }
  }
}

/// BLE connection states
enum BleConnectionState {
  /// Not connected, not scanning
  disconnected,

  /// Scanning for devices
  scanning,

  /// Attempting to connect
  connecting,

  /// Successfully connected
  connected,

  /// Discovering services and characteristics
  discovering,

  /// Fully ready for communication
  ready,

  /// Disconnecting
  disconnecting,

  /// Error state
  error,
}

/// BLE operation errors
enum BleError {
  /// Bluetooth is not enabled on device
  bluetoothOff,

  /// Bluetooth permissions not granted
  permissionDenied,

  /// Device not found during scan
  deviceNotFound,

  /// Connection timed out
  connectionTimeout,

  /// Failed to connect to device
  connectionFailed,

  /// Service not found on device
  serviceNotFound,

  /// Characteristic not found
  characteristicNotFound,

  /// Failed to write data
  writeFailed,

  /// Failed to subscribe to notifications
  subscribeFailed,

  /// No response received
  noResponse,

  /// Response timeout
  responseTimeout,

  /// Invalid response format
  invalidResponse,

  /// Unknown error
  unknown,
}

/// Extension for user-friendly error messages
extension BleErrorExtension on BleError {
  String get message {
    switch (this) {
      case BleError.bluetoothOff:
        return 'Bluetooth is turned off. Please enable Bluetooth.';
      case BleError.permissionDenied:
        return 'Bluetooth permissions are required. Please grant permissions.';
      case BleError.deviceNotFound:
        return 'Collar not found. Make sure the collar is powered on and nearby.';
      case BleError.connectionTimeout:
        return 'Connection timed out. Please try again.';
      case BleError.connectionFailed:
        return 'Failed to connect to collar. Please try again.';
      case BleError.serviceNotFound:
        return 'Collar service not found. Device may be incompatible.';
      case BleError.characteristicNotFound:
        return 'Communication channel not found. Device may be incompatible.';
      case BleError.writeFailed:
        return 'Failed to send command to collar. Please try again.';
      case BleError.subscribeFailed:
        return 'Failed to listen to collar responses. Please try again.';
      case BleError.noResponse:
        return 'No response from collar. Please try again.';
      case BleError.responseTimeout:
        return 'Collar did not respond in time. Please try again.';
      case BleError.invalidResponse:
        return 'Invalid response from collar. Please try again.';
      case BleError.unknown:
        return 'An unknown error occurred. Please try again.';
    }
  }
}
