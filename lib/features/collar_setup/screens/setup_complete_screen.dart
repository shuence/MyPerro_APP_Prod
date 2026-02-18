import 'package:flutter/material.dart';
import 'package:myperro_app_merged/ui/screens/dashboard_screens/dashboard_screen.dart';

/// Setup complete screen - Final success screen
///
/// Shows that collar setup is complete and ready to use
class SetupCompleteScreen extends StatelessWidget {
  final String imei;
  final String collarToken;

  const SetupCompleteScreen({
    super.key,
    required this.imei,
    required this.collarToken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Success animation
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green.shade600,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Title
                const Text(
                  'Setup Complete!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Your collar is now ready to keep your pet safe',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Features checklist
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'What\'s Working',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureItem(
                        Icons.bluetooth,
                        'Bluetooth Connection',
                        'Paired and ready',
                      ),
                      _buildFeatureItem(
                        Icons.cloud_done,
                        'Cloud Registration',
                        'Collar registered to your account',
                      ),
                      _buildFeatureItem(
                        Icons.wifi,
                        'Home Geofence',
                        'WiFi-based location tracking',
                      ),
                      _buildFeatureItem(
                        Icons.gps_fixed,
                        'GPS Tracking',
                        'Real-time location updates',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Collar info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.pets, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Collar IMEI',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            Text(
                              imei,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.check_circle, color: Colors.green.shade600),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to dashboard
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(petName: 'Krypto'),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Go to Dashboard',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Help text
                TextButton(
                  onPressed: () {
                    _showHelpDialog(context);
                  },
                  child: const Text('Need help? View setup guide'),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.green.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Collar Features'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your collar is now fully set up with the following features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('🔵 Bluetooth Pairing'),
              Text(
                'Stay connected to your collar when nearby for real-time updates.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text('📡 WiFi Geofencing'),
              Text(
                'Get notified when your pet leaves or enters your home area based on WiFi signal strength.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text('🗺️ GPS Tracking'),
              Text(
                'Track your pet\'s real-time location with precise GPS coordinates.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text('☁️ Cloud Sync'),
              Text(
                'All collar data is securely stored and accessible from any device.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
