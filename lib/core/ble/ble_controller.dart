import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ble_constants.dart';
import 'ble_permissions.dart';
import 'ble_service.dart';

// ==================== State Classes ====================

/// BLE connection state
class BleState {
  final BleConnectionState connectionState;
  final BluetoothDevice? device;
  final NordicUartService? nordicService;
  final String? imei;
  final BleError? error;
  final String? errorMessage;
  final Stream<String>? notificationStream;

  const BleState({
    this.connectionState = BleConnectionState.disconnected,
    this.device,
    this.nordicService,
    this.imei,
    this.error,
    this.errorMessage,
    this.notificationStream,
  });

  BleState copyWith({
    BleConnectionState? connectionState,
    BluetoothDevice? device,
    NordicUartService? nordicService,
    String? imei,
    BleError? error,
    String? errorMessage,
    Stream<String>? notificationStream,
  }) {
    return BleState(
      connectionState: connectionState ?? this.connectionState,
      device: device ?? this.device,
      nordicService: nordicService ?? this.nordicService,
      imei: imei ?? this.imei,
      error: error,
      errorMessage: errorMessage,
      notificationStream: notificationStream ?? this.notificationStream,
    );
  }

  bool get isConnected =>
      connectionState == BleConnectionState.connected ||
      connectionState == BleConnectionState.discovering ||
      connectionState == BleConnectionState.ready;

  bool get isReady => connectionState == BleConnectionState.ready;

  bool get hasError => connectionState == BleConnectionState.error;
}

// ==================== BLE Controller ====================

/// BLE Controller for managing collar connection and communication
class BleController extends StateNotifier<BleState> {
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  BleController() : super(const BleState());

  // ==================== Permission & Status ====================

  /// Check Bluetooth status and permissions
  Future<BluetoothStatus> checkStatus() async {
    return await BlePermissions.checkStatus();
  }

  /// Request BLE permissions
  Future<PermissionResult> requestPermissions() async {
    return await BlePermissions.requestPermissions();
  }

  // ==================== Scanning ====================

  /// Scan for collar device by IMEI
  ///
  /// Updates state to scanning, then connected when found
  ///
  /// Returns true if device found, false if timeout
  Future<bool> scanForCollar(String imei) async {
    try {
      // Update state to scanning
      state = state.copyWith(
        connectionState: BleConnectionState.scanning,
        imei: imei,
        error: null,
        errorMessage: null,
      );

      // Scan for device
      final scanResult = await BleService.scanForCollar(imei: imei);

      if (scanResult == null) {
        // Device not found
        state = state.copyWith(
          connectionState: BleConnectionState.error,
          error: BleError.deviceNotFound,
          errorMessage: BleError.deviceNotFound.message,
        );
        return false;
      }

      // Device found - update state
      state = state.copyWith(
        connectionState: BleConnectionState.disconnected,
        device: scanResult.device,
      );

      return true;
    } on BleException catch (e) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: e.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: BleError.unknown,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // ==================== Connection Management ====================

  /// Connect to the scanned device
  ///
  /// Must call scanForCollar() first
  ///
  /// Returns true on success, false on failure
  Future<bool> connect() async {
    final device = state.device;
    if (device == null) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: BleError.unknown,
        errorMessage: 'No device to connect to. Call scanForCollar() first.',
      );
      return false;
    }

    try {
      // Update state to connecting
      state = state.copyWith(
        connectionState: BleConnectionState.connecting,
        error: null,
        errorMessage: null,
      );

      // Connect to device
      await BleService.connect(device: device);

      // Listen to connection state changes
      _connectionSubscription?.cancel();
      _connectionSubscription = device.connectionState.listen(
        (connectionState) {
          if (connectionState == BluetoothConnectionState.disconnected) {
            _handleDisconnection();
          }
        },
      );

      // Update state to connected
      state = state.copyWith(
        connectionState: BleConnectionState.connected,
      );

      return true;
    } on BleException catch (e) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: e.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: BleError.connectionFailed,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Discover Nordic UART Service and prepare for communication
  ///
  /// Must call connect() first
  ///
  /// Returns true on success, false on failure
  Future<bool> discoverServices() async {
    final device = state.device;
    if (device == null || !state.isConnected) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: BleError.unknown,
        errorMessage: 'Device not connected',
      );
      return false;
    }

    try {
      // Update state to discovering
      state = state.copyWith(
        connectionState: BleConnectionState.discovering,
        error: null,
        errorMessage: null,
      );

      // Discover Nordic UART Service
      final nordicService = await BleService.discoverNordicUartService(
        device: device,
      );

      // Subscribe to notifications
      final notificationStream =
          await BleService.subscribeToNotifications(
        txCharacteristic: nordicService.txCharacteristic,
      );

      // Update state to ready
      state = state.copyWith(
        connectionState: BleConnectionState.ready,
        nordicService: nordicService,
        notificationStream: notificationStream,
      );

      return true;
    } on BleException catch (e) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: e.error,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        connectionState: BleConnectionState.error,
        error: BleError.serviceNotFound,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Disconnect from device
  Future<void> disconnect() async {
    final device = state.device;
    if (device == null) return;

    try {
      state = state.copyWith(
        connectionState: BleConnectionState.disconnecting,
      );

      await BleService.disconnect(device);

      _connectionSubscription?.cancel();
      _connectionSubscription = null;

      state = const BleState(); // Reset to initial state
    } catch (e) {
      // Ignore errors, just reset state
      state = const BleState();
    }
  }

  /// Handle unexpected disconnection
  void _handleDisconnection() {
    _connectionSubscription?.cancel();
    _connectionSubscription = null;

    state = state.copyWith(
      connectionState: BleConnectionState.error,
      error: BleError.connectionFailed,
      errorMessage: 'Device disconnected unexpectedly',
      nordicService: null,
      notificationStream: null,
    );
  }

  // ==================== High-Level Commands ====================

  /// Request IMEI from collar
  ///
  /// Must be in ready state
  ///
  /// Returns IMEI string or null on failure
  Future<String?> requestImei() async {
    if (!state.isReady ||
        state.nordicService == null ||
        state.notificationStream == null) {
      return null;
    }

    try {
      final imei = await BleService.requestImei(
        rxCharacteristic: state.nordicService!.rxCharacteristic,
        notificationStream: state.notificationStream!,
      );

      // Update state with IMEI
      state = state.copyWith(imei: imei);

      return imei;
    } on BleException catch (e) {
      state = state.copyWith(
        error: e.error,
        errorMessage: e.message,
      );
      return null;
    }
  }

  /// Send collar token to collar after registration
  ///
  /// Must be in ready state
  Future<bool> sendCollarToken(String collarToken) async {
    if (!state.isReady || state.nordicService == null) {
      return false;
    }

    try {
      await BleService.sendCollarToken(
        rxCharacteristic: state.nordicService!.rxCharacteristic,
        collarToken: collarToken,
      );
      return true;
    } on BleException catch (e) {
      state = state.copyWith(
        error: e.error,
        errorMessage: e.message,
      );
      return false;
    }
  }

  /// Setup geofence
  ///
  /// Must be in ready state
  Future<bool> setupGeofence() async {
    if (!state.isReady ||
        state.nordicService == null ||
        state.notificationStream == null) {
      return false;
    }

    try {
      await BleService.setupGeofence(
        rxCharacteristic: state.nordicService!.rxCharacteristic,
        notificationStream: state.notificationStream!,
      );
      return true;
    } on BleException catch (e) {
      state = state.copyWith(
        error: e.error,
        errorMessage: e.message,
      );
      return false;
    }
  }

  /// Start GPS test
  ///
  /// Must be in ready state
  ///
  /// Returns GPS coordinates or null on failure
  Future<Map<String, double>?> startGpsTest() async {
    if (!state.isReady ||
        state.nordicService == null ||
        state.notificationStream == null) {
      return null;
    }

    try {
      final coordinates = await BleService.startGpsTest(
        rxCharacteristic: state.nordicService!.rxCharacteristic,
        notificationStream: state.notificationStream!,
      );
      return coordinates;
    } on BleException catch (e) {
      state = state.copyWith(
        error: e.error,
        errorMessage: e.message,
      );
      return null;
    }
  }

  /// Notify collar that GPS test passed
  Future<bool> notifyLocationVerified() async {
    if (!state.isReady || state.nordicService == null) {
      return false;
    }

    try {
      await BleService.notifyLocationVerified(
        rxCharacteristic: state.nordicService!.rxCharacteristic,
      );
      return true;
    } on BleException catch (e) {
      state = state.copyWith(
        error: e.error,
        errorMessage: e.message,
      );
      return false;
    }
  }

  /// Notify collar that GPS test failed
  Future<bool> notifyTestFailed() async {
    if (!state.isReady || state.nordicService == null) {
      return false;
    }

    try {
      await BleService.notifyTestFailed(
        rxCharacteristic: state.nordicService!.rxCharacteristic,
      );
      return true;
    } on BleException catch (e) {
      state = state.copyWith(
        error: e.error,
        errorMessage: e.message,
      );
      return false;
    }
  }

  // ==================== Cleanup ====================

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }
}

// ==================== Riverpod Providers ====================

/// BLE Controller provider
final bleControllerProvider =
    StateNotifierProvider<BleController, BleState>((ref) {
  return BleController();
});

/// Convenience provider for connection state
final bleConnectionStateProvider = Provider<BleConnectionState>((ref) {
  return ref.watch(bleControllerProvider).connectionState;
});

/// Convenience provider for checking if BLE is ready
final bleIsReadyProvider = Provider<bool>((ref) {
  return ref.watch(bleControllerProvider).isReady;
});

/// Convenience provider for current error
final bleErrorProvider = Provider<BleError?>((ref) {
  return ref.watch(bleControllerProvider).error;
});
