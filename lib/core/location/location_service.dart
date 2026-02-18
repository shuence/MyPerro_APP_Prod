// lib/core/location/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Ensure services are enabled and permission is granted.
  /// Throws with human-friendly messages when blocked.
  Future<void> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable them and try again.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw 'Location permission denied. You can enable it in Settings.';
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission permanently denied. Enable it from Settings.';
    }
  }

  /// Get current position with sensible accuracy & timeout.
  Future<Position> currentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 12),
    );
  }
}
