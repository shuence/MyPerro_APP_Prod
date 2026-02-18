import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_constants.dart';
import 'ble_permissions.dart';

/// BLE Service for collar communication using Nordic UART Service
class BleService {
  // Prevent instantiation
  BleService._();

  // ==================== Device Scanning ====================

  /// Scan for collar device by IMEI
  ///
  /// Returns [ScanResult] when device is found, or null if timeout occurs
  ///
  /// The collar advertises with device name = IMEI (15 digits)
  static Future<ScanResult?> scanForCollar({
    required String imei,
    Duration timeout = BleConstants.scanTimeout,
  }) async {
    // Check permissions first
    final status = await BlePermissions.checkStatus();
    if (!status.ready) {
      throw BleException(
        error: status.error ?? BleError.unknown,
        message: status.userMessage,
      );
    }

    // Stop any ongoing scan
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    final completer = Completer<ScanResult?>();
    StreamSubscription<List<ScanResult>>? scanSubscription;

    // Listen for scan results
    scanSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        for (final result in results) {
          // Check if device name matches IMEI
          if (result.device.platformName == imei ||
              result.advertisementData.localName == imei) {
            completer.complete(result);
            scanSubscription?.cancel();
            FlutterBluePlus.stopScan();
            return;
          }
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(
            BleException(
              error: BleError.unknown,
              message: 'Scan error: $error',
            ),
          );
        }
      },
    );

    // Start scanning
    await FlutterBluePlus.startScan(
      timeout: timeout,
      androidUsesFineLocation: true,
    );

    // Set timeout
    Timer(timeout, () {
      if (!completer.isCompleted) {
        scanSubscription?.cancel();
        FlutterBluePlus.stopScan();
        completer.complete(null);
      }
    });

    return completer.future;
  }

  // ==================== Connection Management ====================

  /// Connect to a BLE device
  ///
  /// Returns connected [BluetoothDevice]
  ///
  /// Throws [BleException] on connection failure
  static Future<BluetoothDevice> connect({
    required BluetoothDevice device,
    Duration timeout = BleConstants.connectionTimeout,
  }) async {
    try {
      // Connect to device
      await device.connect(
        timeout: timeout,
        autoConnect: false,
      );

      // Wait for connection state to be connected
      await device.connectionState
          .firstWhere((state) => state == BluetoothConnectionState.connected)
          .timeout(timeout);

      return device;
    } on TimeoutException {
      throw BleException(
        error: BleError.connectionTimeout,
        message: BleError.connectionTimeout.message,
      );
    } catch (e) {
      throw BleException(
        error: BleError.connectionFailed,
        message: 'Connection failed: $e',
      );
    }
  }

  /// Disconnect from a BLE device
  static Future<void> disconnect(BluetoothDevice device) async {
    try {
      await device.disconnect();
    } catch (e) {
      // Ignore disconnect errors
    }
  }

  // ==================== Service Discovery ====================

  /// Discover Nordic UART Service and characteristics
  ///
  /// Returns [NordicUartService] with RX and TX characteristics
  ///
  /// Throws [BleException] if service or characteristics not found
  static Future<NordicUartService> discoverNordicUartService({
    required BluetoothDevice device,
  }) async {
    try {
      // Discover all services
      final services = await device.discoverServices();

      // Find Nordic UART Service
      final nordicService = services.firstWhere(
        (service) =>
            service.uuid.toString().toUpperCase() ==
            BleConstants.nordicUartServiceUuid.toUpperCase(),
        orElse: () => throw BleException(
          error: BleError.serviceNotFound,
          message: BleError.serviceNotFound.message,
        ),
      );

      // Find RX characteristic (write to collar)
      final rxCharacteristic = nordicService.characteristics.firstWhere(
        (char) =>
            char.uuid.toString().toUpperCase() ==
            BleConstants.nordicUartRxUuid.toUpperCase(),
        orElse: () => throw BleException(
          error: BleError.characteristicNotFound,
          message: 'RX characteristic not found',
        ),
      );

      // Find TX characteristic (read from collar)
      final txCharacteristic = nordicService.characteristics.firstWhere(
        (char) =>
            char.uuid.toString().toUpperCase() ==
            BleConstants.nordicUartTxUuid.toUpperCase(),
        orElse: () => throw BleException(
          error: BleError.characteristicNotFound,
          message: 'TX characteristic not found',
        ),
      );

      return NordicUartService(
        service: nordicService,
        rxCharacteristic: rxCharacteristic,
        txCharacteristic: txCharacteristic,
      );
    } catch (e) {
      if (e is BleException) rethrow;
      throw BleException(
        error: BleError.serviceNotFound,
        message: 'Service discovery failed: $e',
      );
    }
  }

  // ==================== Data Communication ====================

  /// Subscribe to TX characteristic notifications
  ///
  /// Returns stream of responses from collar
  ///
  /// Must be called before sending commands
  static Future<Stream<String>> subscribeToNotifications({
    required BluetoothCharacteristic txCharacteristic,
  }) async {
    try {
      // Enable notifications
      await txCharacteristic.setNotifyValue(true);

      // Return stream of decoded strings
      return txCharacteristic.lastValueStream.map((bytes) {
        return utf8.decode(bytes);
      });
    } catch (e) {
      throw BleException(
        error: BleError.subscribeFailed,
        message: 'Failed to subscribe to notifications: $e',
      );
    }
  }

  /// Send command to collar via RX characteristic
  ///
  /// Throws [BleException] on write failure
  static Future<void> sendCommand({
    required BluetoothCharacteristic rxCharacteristic,
    required String command,
  }) async {
    try {
      final bytes = utf8.encode(command);
      await rxCharacteristic.write(bytes, withoutResponse: false);
    } catch (e) {
      throw BleException(
        error: BleError.writeFailed,
        message: 'Failed to send command: $e',
      );
    }
  }

  /// Send command and wait for specific response
  ///
  /// Returns the response string
  ///
  /// Throws [BleException] on timeout or error
  static Future<String> sendCommandAndWaitForResponse({
    required BluetoothCharacteristic rxCharacteristic,
    required Stream<String> notificationStream,
    required String command,
    Duration timeout = BleConstants.commandTimeout,
    bool Function(String response)? responseValidator,
  }) async {
    try {
      // Send command
      await sendCommand(
        rxCharacteristic: rxCharacteristic,
        command: command,
      );

      // Wait for response
      final response = await notificationStream.firstWhere(
        (response) {
          // Use custom validator if provided
          if (responseValidator != null) {
            return responseValidator(response);
          }
          // Otherwise accept any non-empty response
          return response.isNotEmpty;
        },
      ).timeout(timeout);

      return response;
    } on TimeoutException {
      throw BleException(
        error: BleError.responseTimeout,
        message: 'No response received within ${timeout.inSeconds}s',
      );
    } catch (e) {
      if (e is BleException) rethrow;
      throw BleException(
        error: BleError.noResponse,
        message: 'Failed to receive response: $e',
      );
    }
  }

  // ==================== High-Level Commands ====================

  /// Request IMEI from collar
  ///
  /// Returns 15-digit IMEI string
  static Future<String> requestImei({
    required BluetoothCharacteristic rxCharacteristic,
    required Stream<String> notificationStream,
  }) async {
    final response = await sendCommandAndWaitForResponse(
      rxCharacteristic: rxCharacteristic,
      notificationStream: notificationStream,
      command: BleConstants.cmdSendImei,
      responseValidator: (response) => BleConstants.isValidImei(response),
    );

    if (!BleConstants.isValidImei(response)) {
      throw BleException(
        error: BleError.invalidResponse,
        message: 'Invalid IMEI format: $response',
      );
    }

    return response;
  }

  /// Send collar token to collar after registration
  static Future<void> sendCollarToken({
    required BluetoothCharacteristic rxCharacteristic,
    required String collarToken,
  }) async {
    await sendCommand(
      rxCharacteristic: rxCharacteristic,
      command: BleConstants.cmdCollarToken(collarToken),
    );
  }

  /// Start geofence setup
  ///
  /// Returns when collar confirms geofence is set
  static Future<void> setupGeofence({
    required BluetoothCharacteristic rxCharacteristic,
    required Stream<String> notificationStream,
  }) async {
    final response = await sendCommandAndWaitForResponse(
      rxCharacteristic: rxCharacteristic,
      notificationStream: notificationStream,
      command: BleConstants.cmdSetGeofence,
      timeout: BleConstants.geofenceTimeout,
      responseValidator: (response) =>
          response == BleConstants.respGeofenceSet,
    );

    if (response != BleConstants.respGeofenceSet) {
      throw BleException(
        error: BleError.invalidResponse,
        message: 'Unexpected geofence response: $response',
      );
    }
  }

  /// Start GPS test
  ///
  /// Returns GPS coordinates from collar
  static Future<Map<String, double>> startGpsTest({
    required BluetoothCharacteristic rxCharacteristic,
    required Stream<String> notificationStream,
  }) async {
    final response = await sendCommandAndWaitForResponse(
      rxCharacteristic: rxCharacteristic,
      notificationStream: notificationStream,
      command: BleConstants.cmdStartGpsTest,
      timeout: BleConstants.gpsTestTimeout,
    );

    final coordinates = BleConstants.parseGpsCoordinates(response);
    if (coordinates == null) {
      throw BleException(
        error: BleError.invalidResponse,
        message: 'Invalid GPS coordinates format: $response',
      );
    }

    return coordinates;
  }

  /// Notify collar that GPS test passed
  static Future<void> notifyLocationVerified({
    required BluetoothCharacteristic rxCharacteristic,
  }) async {
    await sendCommand(
      rxCharacteristic: rxCharacteristic,
      command: BleConstants.cmdLocationVerified,
    );
  }

  /// Notify collar that GPS test failed (retry needed)
  static Future<void> notifyTestFailed({
    required BluetoothCharacteristic rxCharacteristic,
  }) async {
    await sendCommand(
      rxCharacteristic: rxCharacteristic,
      command: BleConstants.cmdTestFailed,
    );
  }
}

// ==================== Helper Classes ====================

/// Nordic UART Service wrapper
class NordicUartService {
  final BluetoothService service;
  final BluetoothCharacteristic rxCharacteristic;
  final BluetoothCharacteristic txCharacteristic;

  NordicUartService({
    required this.service,
    required this.rxCharacteristic,
    required this.txCharacteristic,
  });
}

/// BLE Exception
class BleException implements Exception {
  final BleError error;
  final String message;

  BleException({
    required this.error,
    required this.message,
  });

  @override
  String toString() => 'BleException: $message (${error.name})';
}
