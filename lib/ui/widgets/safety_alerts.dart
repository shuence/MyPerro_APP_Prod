import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);

class SafetyAlerts {
  static void showLowBatteryAlert(BuildContext context, String petName, int batteryLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.battery_alert, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Low Battery'),
          ],
        ),
        content: Text(
          '$petName\'s collar battery is at $batteryLevel%. Please charge the collar soon to maintain tracking.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Share Last Location'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: _brandOrange),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showCollarOfflineAlert(BuildContext context, String petName, String lastSeen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.signal_wifi_off, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            const Text('Collar Offline'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$petName\'s collar is offline.'),
            const SizedBox(height: 8),
            Text('Last seen: $lastSeen'),
            const SizedBox(height: 16),
            const Text(
              'Troubleshooting steps:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• Check if collar is charged'),
            const Text('• Move to an open area'),
            const Text('• Restart the collar'),
            const Text('• Check cellular coverage'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('View Last Location'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: _brandOrange),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showGPSFixAlert(BuildContext context, String petName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.gps_off, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            const Text('Searching GPS'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$petName\'s collar is searching for GPS signal.'),
            const SizedBox(height: 16),
            const Text(
              'Tips for better GPS signal:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• Move to an open sky area'),
            const Text('• Avoid indoor/underground areas'),
            const Text('• Wait a few minutes for signal'),
            const Text('• Ensure collar is properly positioned'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: _brandOrange),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Widget buildLowBatteryBanner(String petName, int batteryLevel, VoidCallback onDismiss) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.battery_alert, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Low Battery Warning',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _grey900,
                  ),
                ),
                Text(
                  '$petName\'s collar battery is at $batteryLevel%',
                  style: const TextStyle(color: _grey700, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, color: _grey700),
          ),
        ],
      ),
    );
  }
}

class PetSwitcher extends StatelessWidget {
  final List<String> pets;
  final String selectedPet;
  final Function(String) onPetChanged;

  const PetSwitcher({
    super.key,
    required this.pets,
    required this.selectedPet,
    required this.onPetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Pet:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _grey900,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE9E9E9)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedPet,
                  isExpanded: true,
                  items: pets.map((pet) {
                    return DropdownMenuItem<String>(
                      value: pet,
                      child: Text(pet),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onPetChanged(value);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
