import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myperro_app_merged/core/ble/ble_controller.dart';
import 'package:myperro_app_merged/core/models/location_data.dart';
import 'package:geolocator/geolocator.dart';
import 'setup_complete_screen.dart';

/// GPS test screen - Validates collar's GPS functionality
///
/// Flow:
/// 1. Get phone's current GPS coordinates
/// 2. Send "start GPS Test" command to collar
/// 3. Wait for collar's GPS coordinates (up to 3 minutes)
/// 4. Calculate distance between phone and collar
/// 5. Verify distance:
///    - < 20m: Pass immediately
///    - 20-50m: Retry (up to 2 retries)
///    - > 50m: Fail
/// 6. Send verification result to collar
/// 7. Navigate to setup complete
class GpsTestScreen extends ConsumerStatefulWidget {
  final String imei;
  final String collarToken;

  const GpsTestScreen({
    super.key,
    required this.imei,
    required this.collarToken,
  });

  @override
  ConsumerState<GpsTestScreen> createState() => _GpsTestScreenState();
}

class _GpsTestScreenState extends ConsumerState<GpsTestScreen> {
  GpsTestStep _currentStep = GpsTestStep.instructions;
  String? _errorMessage;
  GPSCoordinate? _phoneLocation;
  GPSCoordinate? _collarLocation;
  GPSTestResult? _testResult;
  int _attemptNumber = 1;
  static const int _maxAttempts = 2;
  bool _isProcessing = false;

  Future<void> _startGpsTest() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _currentStep = GpsTestStep.gettingPhoneLocation;
      _errorMessage = null;
    });

    try {
      // Step 1: Get phone's GPS location
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _phoneLocation = GPSCoordinate(
            latitude: position.latitude,
            longitude: position.longitude,
            timestamp: DateTime.now(),
            accuracy: position.accuracy,
          );
          _currentStep = GpsTestStep.requestingCollarLocation;
        });
      } catch (e) {
        _showError('Failed to get phone location. Please enable location services.');
        return;
      }

      // Step 2: Request collar's GPS location
      final bleController = ref.read(bleControllerProvider.notifier);

      // Check if BLE is still ready
      final state = ref.read(bleControllerProvider);
      if (!state.isReady) {
        _showError('Bluetooth connection lost. Please restart setup.');
        return;
      }

      final collarCoords = await bleController.startGpsTest();

      if (collarCoords == null) {
        final errorState = ref.read(bleControllerProvider);
        _showError(
          errorState.errorMessage ?? 'Failed to get GPS coordinates from collar',
        );
        return;
      }

      setState(() {
        _collarLocation = GPSCoordinate(
          latitude: collarCoords['latitude']!,
          longitude: collarCoords['longitude']!,
          timestamp: DateTime.now(),
        );
        _currentStep = GpsTestStep.comparing;
      });

      // Small delay to show comparison state
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 3: Calculate distance and verify
      final testResult = GPSTestResultExtension.fromCoordinates(
        phoneLocation: _phoneLocation!,
        collarLocation: _collarLocation!,
        attemptNumber: _attemptNumber,
      );

      setState(() {
        _testResult = testResult;
      });

      // Step 4: Handle result
      if (testResult.isVerified) {
        // Success! Send verification to collar
        setState(() {
          _currentStep = GpsTestStep.sendingVerification;
        });

        final notified = await bleController.notifyLocationVerified();
        if (!notified) {
          _showError('GPS test passed but failed to notify collar');
          return;
        }

        // Success!
        setState(() {
          _currentStep = GpsTestStep.success;
        });

        // Wait to show success animation
        await Future.delayed(const Duration(milliseconds: 2000));

        if (!mounted) return;

        // Navigate to setup complete
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SetupCompleteScreen(
              imei: widget.imei,
              collarToken: widget.collarToken,
            ),
          ),
        );
      } else {
        // Distance too far - check if we should retry
        if (_attemptNumber < _maxAttempts && testResult.distanceMeters <= 50) {
          // Retry
          setState(() {
            _currentStep = GpsTestStep.retryPrompt;
          });

          // Send test failed to collar
          await bleController.notifyTestFailed();
        } else {
          // Failed - too far or max retries reached
          setState(() {
            _currentStep = GpsTestStep.failed;
          });

          // Send test failed to collar
          await bleController.notifyTestFailed();
        }
      }
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
      _currentStep = GpsTestStep.error;
      _errorMessage = message;
      _isProcessing = false;
    });
  }

  void _retry() {
    setState(() {
      _attemptNumber++;
      _testResult = null;
    });
    _startGpsTest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Test'),
        automaticallyImplyLeading: _currentStep == GpsTestStep.instructions ||
            _currentStep == GpsTestStep.error ||
            _currentStep == GpsTestStep.retryPrompt ||
            _currentStep == GpsTestStep.failed,
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
                child: _buildContent(),
              ),

              // Action button
              _buildActionButton(),
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
        _buildStepCircle(3, 'Geofence', true),
        _buildStepLine(true),
        _buildStepCircle(
          4,
          'GPS Test',
          _currentStep != GpsTestStep.instructions,
        ),
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

  Widget _buildContent() {
    switch (_currentStep) {
      case GpsTestStep.instructions:
        return _buildInstructions();
      case GpsTestStep.gettingPhoneLocation:
      case GpsTestStep.requestingCollarLocation:
      case GpsTestStep.comparing:
      case GpsTestStep.sendingVerification:
        return _buildProgress();
      case GpsTestStep.success:
        return _buildSuccess();
      case GpsTestStep.retryPrompt:
        return _buildRetryPrompt();
      case GpsTestStep.failed:
        return _buildFailed();
      case GpsTestStep.error:
        return _buildError();
    }
  }

  Widget _buildInstructions() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GPS Functionality Test',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'We need to verify that the collar\'s GPS is working correctly.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),

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
                      'Instructions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInstruction(
                  '1',
                  'Go outside to an open area',
                  Icons.location_on,
                ),
                _buildInstruction(
                  '2',
                  'Keep the collar with you (within 20 meters)',
                  Icons.pets,
                ),
                _buildInstruction(
                  '3',
                  'The test may take up to 3 minutes',
                  Icons.timer,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The collar needs a clear view of the sky to get a GPS fix. This may take a few minutes.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String number, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
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
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
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
                _currentStep.icon,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(),
        const SizedBox(height: 32),
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

        if (_phoneLocation != null) ...[
          const SizedBox(height: 24),
          _buildLocationCard(
            'Your Location',
            _phoneLocation!,
            Icons.smartphone,
            Colors.blue,
          ),
        ],

        if (_collarLocation != null) ...[
          const SizedBox(height: 12),
          _buildLocationCard(
            'Collar Location',
            _collarLocation!,
            Icons.pets,
            Colors.green,
          ),
        ],

        if (_testResult != null) ...[
          const SizedBox(height: 16),
          Text(
            'Distance: ${_testResult!.distanceMeters.toStringAsFixed(1)}m',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationCard(
    String title,
    GPSCoordinate coord,
    IconData icon,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${coord.latitude.toStringAsFixed(6)}, ${coord.longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: color[900],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          'GPS Test Passed!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        if (_testResult != null)
          Text(
            'Distance: ${_testResult!.distanceMeters.toStringAsFixed(1)}m',
            style: const TextStyle(fontSize: 16),
          ),
        const SizedBox(height: 8),
        Text(
          _testResult?.resultMessage ?? 'Collar GPS is working correctly',
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Text(
          'Setup complete!',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRetryPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_amber,
          size: 100,
          color: Colors.orange.shade600,
        ),
        const SizedBox(height: 32),
        const Text(
          'Distance Too Far',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 16),
        if (_testResult != null) ...[
          Text(
            'Distance: ${_testResult!.distanceMeters.toStringAsFixed(1)}m',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _testResult!.resultMessage,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: const Column(
            children: [
              Text(
                'Please move closer to the collar (within 20 meters) and try again.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Attempt $_attemptNumber of $_maxAttempts',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFailed() {
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
          'GPS Test Failed',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        if (_testResult != null) ...[
          Text(
            'Distance: ${_testResult!.distanceMeters.toStringAsFixed(1)}m',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _testResult!.resultMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade900,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        const SizedBox(height: 24),
        const Text(
          'Please ensure the collar is within 20 meters and has a clear view of the sky.',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
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
          'Test Error',
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

  Widget _buildActionButton() {
    if (_currentStep == GpsTestStep.instructions) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _startGpsTest,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Start GPS Test',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    } else if (_currentStep == GpsTestStep.retryPrompt) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _retry,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Retry Test (Attempt $_attemptNumber/$_maxAttempts)',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    } else if (_currentStep == GpsTestStep.failed ||
        _currentStep == GpsTestStep.error) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isProcessing ? null : () {
            setState(() {
              _attemptNumber = 1;
            });
            _startGpsTest();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Start Over',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// GPS test steps
enum GpsTestStep {
  instructions,
  gettingPhoneLocation,
  requestingCollarLocation,
  comparing,
  sendingVerification,
  success,
  retryPrompt,
  failed,
  error;

  String get title {
    switch (this) {
      case GpsTestStep.instructions:
        return 'GPS Test';
      case GpsTestStep.gettingPhoneLocation:
        return 'Getting Your Location';
      case GpsTestStep.requestingCollarLocation:
        return 'Getting Collar Location';
      case GpsTestStep.comparing:
        return 'Comparing Locations';
      case GpsTestStep.sendingVerification:
        return 'Sending Verification';
      case GpsTestStep.success:
        return 'Success!';
      case GpsTestStep.retryPrompt:
        return 'Retry Needed';
      case GpsTestStep.failed:
        return 'Test Failed';
      case GpsTestStep.error:
        return 'Error';
    }
  }

  String get description {
    switch (this) {
      case GpsTestStep.instructions:
        return 'Prepare for GPS test';
      case GpsTestStep.gettingPhoneLocation:
        return 'Acquiring phone GPS coordinates...';
      case GpsTestStep.requestingCollarLocation:
        return 'Collar is getting GPS fix... (this may take up to 3 minutes)';
      case GpsTestStep.comparing:
        return 'Calculating distance...';
      case GpsTestStep.sendingVerification:
        return 'Notifying collar of success...';
      case GpsTestStep.success:
        return 'GPS test passed!';
      case GpsTestStep.retryPrompt:
        return 'Distance exceeds threshold';
      case GpsTestStep.failed:
        return 'Unable to verify GPS';
      case GpsTestStep.error:
        return 'An error occurred';
    }
  }

  IconData get icon {
    switch (this) {
      case GpsTestStep.instructions:
        return Icons.gps_fixed;
      case GpsTestStep.gettingPhoneLocation:
        return Icons.my_location;
      case GpsTestStep.requestingCollarLocation:
        return Icons.satellite_alt;
      case GpsTestStep.comparing:
        return Icons.compare_arrows;
      case GpsTestStep.sendingVerification:
        return Icons.verified;
      case GpsTestStep.success:
        return Icons.check_circle;
      case GpsTestStep.retryPrompt:
        return Icons.warning_amber;
      case GpsTestStep.failed:
        return Icons.error_outline;
      case GpsTestStep.error:
        return Icons.error;
    }
  }
}
