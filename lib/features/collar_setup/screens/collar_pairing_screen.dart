import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myperro_app_merged/core/ble/ble_controller.dart';
import 'collar_registration_screen.dart';

/// Collar pairing screen - Handles BLE connection and IMEI verification
///
/// Flow:
/// 1. Scan for BLE device with scanned IMEI as name
/// 2. Connect to collar
/// 3. Send "Send IMEI" command
/// 4. Receive collar's IMEI
/// 5. Compare scanned IMEI vs collar IMEI
/// 6. Navigate to registration if match
class CollarPairingScreen extends ConsumerStatefulWidget {
  final String imei;

  const CollarPairingScreen({
    super.key,
    required this.imei,
  });

  @override
  ConsumerState<CollarPairingScreen> createState() =>
      _CollarPairingScreenState();
}

class _CollarPairingScreenState extends ConsumerState<CollarPairingScreen> {
  PairingStep _currentStep = PairingStep.checkingPermissions;
  String? _errorMessage;
  String? _collarImei;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPairingFlow();
    });
  }

  Future<void> _startPairingFlow() async {
    try {
      // Step 1: Check permissions
      setState(() {
        _currentStep = PairingStep.checkingPermissions;
        _errorMessage = null;
      });

      final bleController = ref.read(bleControllerProvider.notifier);
      final status = await bleController.checkStatus();

      if (!status.ready) {
        // Request permissions
        final permissionResult = await bleController.requestPermissions();
        if (!permissionResult.granted) {
          _showError('Bluetooth permissions required: ${permissionResult.userMessage}');
          return;
        }
      }

      // Step 2: Scan for collar
      setState(() {
        _currentStep = PairingStep.scanning;
      });

      final found = await bleController.scanForCollar(widget.imei);
      if (!found) {
        _showError(
          'Collar not found. Make sure:\n'
          '• Collar is powered on\n'
          '• Collar is within 10 meters\n'
          '• Bluetooth is enabled',
        );
        return;
      }

      // Step 3: Connect to collar
      setState(() {
        _currentStep = PairingStep.connecting;
      });

      final connected = await bleController.connect();
      if (!connected) {
        final state = ref.read(bleControllerProvider);
        _showError(state.errorMessage ?? 'Failed to connect to collar');
        return;
      }

      // Step 4: Discover services
      setState(() {
        _currentStep = PairingStep.discoveringServices;
      });

      final servicesReady = await bleController.discoverServices();
      if (!servicesReady) {
        final state = ref.read(bleControllerProvider);
        _showError(state.errorMessage ?? 'Failed to discover collar services');
        return;
      }

      // Step 5: Request IMEI from collar
      setState(() {
        _currentStep = PairingStep.verifyingImei;
      });

      final collarImei = await bleController.requestImei();
      if (collarImei == null) {
        final state = ref.read(bleControllerProvider);
        _showError(state.errorMessage ?? 'Failed to get IMEI from collar');
        return;
      }

      setState(() {
        _collarImei = collarImei;
      });

      // Step 6: Compare IMEIs
      if (collarImei != widget.imei) {
        _showError(
          'IMEI mismatch!\n'
          'Scanned: ${widget.imei}\n'
          'Collar: $collarImei\n\n'
          'Please scan the correct QR code.',
        );
        return;
      }

      // Success! Navigate to registration
      setState(() {
        _currentStep = PairingStep.success;
      });

      // Wait a moment to show success animation
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CollarRegistrationScreen(imei: widget.imei),
        ),
      );
    } catch (e) {
      _showError('Unexpected error: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      _currentStep = PairingStep.error;
      _errorMessage = message;
    });
  }

  void _retry() {
    if (_retryCount >= _maxRetries) {
      _showError('Maximum retries reached. Please try again later.');
      return;
    }

    setState(() {
      _retryCount++;
      _errorMessage = null;
    });

    _startPairingFlow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pairing Collar'),
        automaticallyImplyLeading: _currentStep == PairingStep.error,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // IMEI Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Collar IMEI',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          widget.imei,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Progress Indicator
              Expanded(
                child: _currentStep == PairingStep.error
                    ? _buildErrorState()
                    : _currentStep == PairingStep.success
                        ? _buildSuccessState()
                        : _buildProgressState(),
              ),

              // Retry Button
              if (_currentStep == PairingStep.error)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _retry,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Retry ($_retryCount/$_maxRetries)',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated icon
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Icon(
                _currentStep.icon,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),

        const SizedBox(height: 32),

        // Progress indicator
        const CircularProgressIndicator(),

        const SizedBox(height: 32),

        // Status text
        Text(
          _currentStep.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          _currentStep.description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),

        if (_collarImei != null) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Collar IMEI: $_collarImei',
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 100,
          color: Colors.green.shade600,
        ),
        const SizedBox(height: 32),
        const Text(
          'Pairing Successful!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'IMEI verified: ${widget.imei}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        const Text(
          'Proceeding to registration...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 100,
          color: Colors.red.shade600,
        ),
        const SizedBox(height: 32),
        const Text(
          'Pairing Failed',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Text(
            _errorMessage ?? 'Unknown error occurred',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Pairing steps enum
enum PairingStep {
  checkingPermissions,
  scanning,
  connecting,
  discoveringServices,
  verifyingImei,
  success,
  error;

  String get title {
    switch (this) {
      case PairingStep.checkingPermissions:
        return 'Checking Permissions';
      case PairingStep.scanning:
        return 'Searching for Collar';
      case PairingStep.connecting:
        return 'Connecting to Collar';
      case PairingStep.discoveringServices:
        return 'Discovering Services';
      case PairingStep.verifyingImei:
        return 'Verifying IMEI';
      case PairingStep.success:
        return 'Success!';
      case PairingStep.error:
        return 'Error';
    }
  }

  String get description {
    switch (this) {
      case PairingStep.checkingPermissions:
        return 'Checking Bluetooth permissions...';
      case PairingStep.scanning:
        return 'Looking for your collar via Bluetooth...';
      case PairingStep.connecting:
        return 'Establishing connection...';
      case PairingStep.discoveringServices:
        return 'Setting up communication...';
      case PairingStep.verifyingImei:
        return 'Verifying collar identity...';
      case PairingStep.success:
        return 'Collar paired successfully!';
      case PairingStep.error:
        return 'Something went wrong';
    }
  }

  IconData get icon {
    switch (this) {
      case PairingStep.checkingPermissions:
        return Icons.security;
      case PairingStep.scanning:
        return Icons.bluetooth_searching;
      case PairingStep.connecting:
        return Icons.bluetooth_connected;
      case PairingStep.discoveringServices:
        return Icons.settings_bluetooth;
      case PairingStep.verifyingImei:
        return Icons.verified_user;
      case PairingStep.success:
        return Icons.check_circle;
      case PairingStep.error:
        return Icons.error_outline;
    }
  }
}
