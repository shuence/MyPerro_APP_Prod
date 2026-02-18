import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myperro_app_merged/core/ble/ble_controller.dart';
import 'gps_test_screen.dart';

/// Geofence setup screen - Configures collar's WiFi geofence
///
/// Flow:
/// 1. Show instructions to user
/// 2. User confirms they're at home WiFi
/// 3. Send "set geofence" command via BLE
/// 4. Collar measures WiFi RSSI and saves thresholds
/// 5. Wait for "Geofence is set" response
/// 6. Navigate to GPS test
class GeofenceSetupScreen extends ConsumerStatefulWidget {
  final String imei;
  final String collarToken;

  const GeofenceSetupScreen({
    super.key,
    required this.imei,
    required this.collarToken,
  });

  @override
  ConsumerState<GeofenceSetupScreen> createState() =>
      _GeofenceSetupScreenState();
}

class _GeofenceSetupScreenState extends ConsumerState<GeofenceSetupScreen> {
  GeofenceStep _currentStep = GeofenceStep.instructions;
  String? _errorMessage;
  bool _isProcessing = false;

  Future<void> _startGeofenceSetup() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _currentStep = GeofenceStep.measuring;
      _errorMessage = null;
    });

    try {
      final bleController = ref.read(bleControllerProvider.notifier);

      // Check if BLE is still ready
      final state = ref.read(bleControllerProvider);
      if (!state.isReady) {
        _showError('Bluetooth connection lost. Please restart setup.');
        return;
      }

      // Send geofence setup command
      final success = await bleController.setupGeofence();

      if (!success) {
        final errorState = ref.read(bleControllerProvider);
        _showError(
          errorState.errorMessage ?? 'Failed to set up geofence',
        );
        return;
      }

      // Success!
      setState(() {
        _currentStep = GeofenceStep.success;
      });

      // Wait to show success animation
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      // Navigate to GPS test
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GpsTestScreen(
            imei: widget.imei,
            collarToken: widget.collarToken,
          ),
        ),
      );
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _currentStep = GeofenceStep.error;
      _errorMessage = message;
      _isProcessing = false;
    });
  }

  void _retry() {
    _startGeofenceSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofence Setup'),
        automaticallyImplyLeading: _currentStep != GeofenceStep.measuring,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress indicator
              _buildProgressIndicator(),

              const SizedBox(height: 32),

              // Content
              Expanded(
                child: _currentStep == GeofenceStep.instructions
                    ? _buildInstructions()
                    : _currentStep == GeofenceStep.measuring
                        ? _buildMeasuring()
                        : _currentStep == GeofenceStep.success
                            ? _buildSuccess()
                            : _buildError(),
              ),

              // Action button
              if (_currentStep == GeofenceStep.instructions)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startGeofenceSetup,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start Geofence Setup',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else if (_currentStep == GeofenceStep.error)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _retry,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Retry',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildStepCircle(1, 'Pair', true),
        _buildStepLine(true),
        _buildStepCircle(2, 'Register', true),
        _buildStepLine(true),
        _buildStepCircle(
          3,
          'Geofence',
          _currentStep != GeofenceStep.instructions,
        ),
        _buildStepLine(false),
        _buildStepCircle(4, 'GPS Test', false),
      ],
    );
  }

  Widget _buildStepCircle(int number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    '$number',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isActive ? Colors.green : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildInstructions() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Up Home Geofence',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'The collar uses WiFi signal strength to detect when your pet leaves or enters your home.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Instructions card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Important Instructions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  '1',
                  'Ensure you are connected to your home WiFi',
                  Icons.wifi,
                ),
                _buildInstructionItem(
                  '2',
                  'Keep the collar within 5 meters of your router',
                  Icons.router,
                ),
                _buildInstructionItem(
                  '3',
                  'The setup will take approximately 10-15 seconds',
                  Icons.timer,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // How it works
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline),
                    SizedBox(width: 8),
                    Text(
                      'How it works',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'The collar will measure your WiFi signal strength (RSSI) and set:'
                  '\n\n• OUT threshold: Triggers when pet leaves home'
                  '\n• IN threshold: Triggers when pet returns home'
                  '\n\nThis helps track your pet\'s location without GPS.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: Colors.blue.shade700),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasuring() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.4),
              child: Icon(
                Icons.wifi_find,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
        const SizedBox(height: 32),
        const Text(
          'Measuring WiFi Signal',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Please keep the collar near your router...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const LinearProgressIndicator(),
        const SizedBox(height: 8),
        const Text(
          'This may take 10-15 seconds',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
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
          'Geofence Set!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your home geofence has been configured successfully',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Text(
          'Proceeding to GPS test...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
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
          'Setup Failed',
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

/// Geofence setup steps
enum GeofenceStep {
  instructions,
  measuring,
  success,
  error,
}
