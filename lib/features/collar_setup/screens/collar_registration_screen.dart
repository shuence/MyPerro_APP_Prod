import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myperro/core/api/api_client.dart';
import 'package:myperro/core/api/api_service.dart';
import 'package:myperro/core/ble/ble_controller.dart';
import 'package:myperro/core/models/registration.dart';
import 'geofence_setup_screen.dart';

/// Collar registration screen - Handles backend registration and token transmission
///
/// Flow:
/// 1. POST /register with IMEI, userId, userToken
/// 2. Handle response:
///    - Case A: Already registered to current user → Send token → Continue
///    - Case B: Already registered to other user → Show error
///    - Case C: Newly registered → Send token → Continue
/// 3. Send CollarToken via BLE
/// 4. Navigate to geofence setup
class CollarRegistrationScreen extends ConsumerStatefulWidget {
  final String imei;

  const CollarRegistrationScreen({
    super.key,
    required this.imei,
  });

  @override
  ConsumerState<CollarRegistrationScreen> createState() =>
      _CollarRegistrationScreenState();
}

class _CollarRegistrationScreenState
    extends ConsumerState<CollarRegistrationScreen> {
  RegistrationStep _currentStep = RegistrationStep.registering;
  String? _errorMessage;
  RegistrationResponse? _registrationResponse;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRegistrationFlow();
    });
  }

  Future<void> _startRegistrationFlow() async {
    try {
      setState(() {
        _currentStep = RegistrationStep.registering;
        _errorMessage = null;
      });

      // TODO: Get user credentials from authentication service
      // For now using placeholder values
      const userId = 'user_123';
      const userToken = 'token_abc';

      // Step 1: Register with backend
      final apiService = ref.read(apiServiceProvider);

      try {
        final response = await apiService.registerCollar(
          imei: widget.imei,
          userId: userId,
          userToken: userToken,
        );

        setState(() {
          _registrationResponse = response;
        });

        // Handle different registration statuses
        if (response.status.isFailure) {
          // Case B: Already registered to another user
          _showError(
            'This collar is already registered to another user.\n\n'
            'If you purchased this collar, please contact support to transfer ownership.',
          );
          return;
        }

        // Case A or C: Success
        final collarToken = response.collarToken;
        if (collarToken == null) {
          _showError('Registration succeeded but no collar token received');
          return;
        }

        // Step 2: Send collar token via BLE
        setState(() {
          _currentStep = RegistrationStep.sendingToken;
        });

        final bleController = ref.read(bleControllerProvider.notifier);
        final tokenSent = await bleController.sendCollarToken(collarToken);

        if (!tokenSent) {
          final state = ref.read(bleControllerProvider);
          _showError(
            'Failed to send token to collar via Bluetooth.\n'
            '${state.errorMessage ?? "Unknown error"}',
          );
          return;
        }

        // Step 3: Save collar data locally
        setState(() {
          _currentStep = RegistrationStep.savingData;
        });

        // TODO: Save collar data with petId when we have pet selection
        // For now, we'll handle this in the integration phase

        // Success!
        setState(() {
          _currentStep = RegistrationStep.success;
        });

        // Show success message based on case
        String successMessage;
        if (response.status == RegistrationStatus.alreadyRegisteredCurrentUser) {
          successMessage = 'Collar reconnected successfully!';
        } else {
          successMessage = 'Collar registered successfully!';
        }

        // Wait to show success animation
        await Future.delayed(const Duration(milliseconds: 1500));

        if (!mounted) return;

        // Navigate to geofence setup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GeofenceSetupScreen(
              imei: widget.imei,
              collarToken: collarToken,
            ),
          ),
        );
      } on ApiException catch (e) {
        _showError('Registration failed: ${e.message}');
      }
    } catch (e) {
      _showError('Unexpected error: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      _currentStep = RegistrationStep.error;
      _errorMessage = message;
    });
  }

  void _retry() {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    _startRegistrationFlow().then((_) {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registering Collar'),
        automaticallyImplyLeading: _currentStep == RegistrationStep.error,
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
                    const Icon(Icons.pets, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registering Collar',
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

              // Content
              Expanded(
                child: _currentStep == RegistrationStep.error
                    ? _buildErrorState()
                    : _currentStep == RegistrationStep.success
                        ? _buildSuccessState()
                        : _buildProgressState(),
              ),

              // Action Button
              if (_currentStep == RegistrationStep.error)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isRetrying ? null : _retry,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isRetrying
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

  Widget _buildProgressState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated icon
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, double value, child) {
            return Transform.rotate(
              angle: value * 6.28,
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

        // Registration status info
        if (_registrationResponse != null) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _registrationResponse!.message ?? 'Processing...',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuccessState() {
    final isReconnection =
        _registrationResponse?.status ==
        RegistrationStatus.alreadyRegisteredCurrentUser;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 100,
          color: Colors.green.shade600,
        ),
        const SizedBox(height: 32),
        Text(
          isReconnection ? 'Collar Reconnected!' : 'Registration Successful!',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          _registrationResponse?.message ?? 'Collar setup in progress...',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Text(
          'Proceeding to geofence setup...',
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
          'Registration Failed',
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

/// Registration steps enum
enum RegistrationStep {
  registering,
  sendingToken,
  savingData,
  success,
  error;

  String get title {
    switch (this) {
      case RegistrationStep.registering:
        return 'Registering Collar';
      case RegistrationStep.sendingToken:
        return 'Sending Token';
      case RegistrationStep.savingData:
        return 'Saving Data';
      case RegistrationStep.success:
        return 'Success!';
      case RegistrationStep.error:
        return 'Error';
    }
  }

  String get description {
    switch (this) {
      case RegistrationStep.registering:
        return 'Contacting server to register your collar...';
      case RegistrationStep.sendingToken:
        return 'Sending activation token to collar...';
      case RegistrationStep.savingData:
        return 'Saving collar information...';
      case RegistrationStep.success:
        return 'Collar ready for setup!';
      case RegistrationStep.error:
        return 'Something went wrong';
    }
  }

  IconData get icon {
    switch (this) {
      case RegistrationStep.registering:
        return Icons.cloud_upload;
      case RegistrationStep.sendingToken:
        return Icons.key;
      case RegistrationStep.savingData:
        return Icons.save;
      case RegistrationStep.success:
        return Icons.check_circle;
      case RegistrationStep.error:
        return Icons.error_outline;
    }
  }
}
