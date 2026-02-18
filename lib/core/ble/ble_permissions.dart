import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ble_constants.dart';

/// Handler for BLE permissions and Bluetooth state
class BlePermissions {
  // Prevent instantiation
  BlePermissions._();

  /// Check if Bluetooth is turned on
  static Future<bool> isBluetoothOn() async {
    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      return adapterState == BluetoothAdapterState.on;
    } catch (e) {
      return false;
    }
  }

  /// Request all necessary BLE permissions
  ///
  /// Android 12+ requires:
  /// - BLUETOOTH_SCAN
  /// - BLUETOOTH_CONNECT
  /// - ACCESS_FINE_LOCATION (for BLE scanning)
  ///
  /// iOS automatically requests permissions when BLE is first used
  static Future<PermissionResult> requestPermissions() async {
    if (Platform.isAndroid) {
      return await _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      return await _requestIOSPermissions();
    } else {
      return PermissionResult(
        granted: false,
        error: BleError.unknown,
      );
    }
  }

  /// Request Android BLE permissions
  static Future<PermissionResult> _requestAndroidPermissions() async {
    try {
      // Check Android version
      final androidInfo = await _getAndroidSdkInt();

      Map<Permission, PermissionStatus> statuses;

      if (androidInfo >= 31) {
        // Android 12+ (API 31+)
        statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();
      } else {
        // Android 11 and below
        statuses = await [
          Permission.bluetooth,
          Permission.locationWhenInUse,
        ].request();
      }

      // Check if all permissions are granted
      final allGranted = statuses.values.every(
        (status) => status.isGranted,
      );

      if (allGranted) {
        return PermissionResult(granted: true);
      } else {
        // Check which permission was denied
        final deniedPermission = statuses.entries.firstWhere(
          (entry) => !entry.value.isGranted,
          orElse: () => statuses.entries.first,
        );

        return PermissionResult(
          granted: false,
          error: BleError.permissionDenied,
          deniedPermission: deniedPermission.key.toString(),
        );
      }
    } catch (e) {
      return PermissionResult(
        granted: false,
        error: BleError.unknown,
        errorMessage: e.toString(),
      );
    }
  }

  /// Request iOS BLE permissions
  /// iOS handles permissions automatically via Info.plist descriptions
  static Future<PermissionResult> _requestIOSPermissions() async {
    // iOS doesn't require explicit permission requests for BLE
    // Permissions are automatically requested when BLE is first accessed
    // Just check if Bluetooth is available
    final isOn = await isBluetoothOn();

    if (isOn) {
      return PermissionResult(granted: true);
    } else {
      return PermissionResult(
        granted: false,
        error: BleError.bluetoothOff,
      );
    }
  }

  /// Get Android SDK version
  static Future<int> _getAndroidSdkInt() async {
    if (Platform.isAndroid) {
      // Default to 31 (Android 12) for safer permission handling
      return 31;
    }
    return 0;
  }

  /// Check if permissions are already granted
  static Future<bool> arePermissionsGranted() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidSdkInt();

      if (androidInfo >= 31) {
        return await Permission.bluetoothScan.isGranted &&
               await Permission.bluetoothConnect.isGranted &&
               await Permission.locationWhenInUse.isGranted;
      } else {
        return await Permission.bluetooth.isGranted &&
               await Permission.locationWhenInUse.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permissions are handled automatically
      return await isBluetoothOn();
    }

    return false;
  }

  /// Open app settings for manual permission grant
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Check Bluetooth status and permissions
  /// Returns a detailed status result
  static Future<BluetoothStatus> checkStatus() async {
    // Check if Bluetooth is on
    final isOn = await isBluetoothOn();
    if (!isOn) {
      return BluetoothStatus(
        ready: false,
        bluetoothOn: false,
        permissionsGranted: false,
        error: BleError.bluetoothOff,
      );
    }

    // Check permissions
    final permissionsGranted = await arePermissionsGranted();
    if (!permissionsGranted) {
      return BluetoothStatus(
        ready: false,
        bluetoothOn: true,
        permissionsGranted: false,
        error: BleError.permissionDenied,
      );
    }

    // All good
    return BluetoothStatus(
      ready: true,
      bluetoothOn: true,
      permissionsGranted: true,
    );
  }

  /// Listen to Bluetooth adapter state changes
  static Stream<BluetoothAdapterState> get adapterStateStream =>
      FlutterBluePlus.adapterState;
}

/// Result of permission request
class PermissionResult {
  final bool granted;
  final BleError? error;
  final String? deniedPermission;
  final String? errorMessage;

  PermissionResult({
    required this.granted,
    this.error,
    this.deniedPermission,
    this.errorMessage,
  });

  String get userMessage {
    if (granted) return 'Permissions granted';
    if (error != null) return error!.message;
    if (errorMessage != null) return errorMessage!;
    return 'Permission denied';
  }
}

/// Bluetooth status
class BluetoothStatus {
  final bool ready;
  final bool bluetoothOn;
  final bool permissionsGranted;
  final BleError? error;

  BluetoothStatus({
    required this.ready,
    required this.bluetoothOn,
    required this.permissionsGranted,
    this.error,
  });

  String get userMessage {
    if (ready) return 'Bluetooth ready';
    if (!bluetoothOn) return 'Please turn on Bluetooth';
    if (!permissionsGranted) return 'Bluetooth permissions required';
    if (error != null) return error!.message;
    return 'Bluetooth not ready';
  }
}
