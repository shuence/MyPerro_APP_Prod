import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import '../onboarding/onboarding_title_screen.dart';

const _brandOrange = Color(0xFFF5832A);
const _titleBlack  = Color(0xFF1F1F1F);
const _dividerGrey = Color(0xFFE0E0E0);

class LocationOsmScreen extends StatefulWidget {
  const LocationOsmScreen({super.key});

  @override
  State<LocationOsmScreen> createState() => _LocationOsmScreenState();
}

class _LocationOsmScreenState extends State<LocationOsmScreen> {
  late GoogleMapController _mapController;

  LatLng? _center;
  String? _address;
  bool _gettingAddress = false;

  Timer? _rgTimer;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  @override
  void dispose() {
    _rgTimer?.cancel();
    super.dispose();
  }

  Future<void> _initCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled && mounted) {
        await _showDialog(
          'Location services are off',
          'Please enable location services in settings.',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (!mounted) return;
        await _showDialog(
          'Permission required',
          'Location permission is needed to pick your current address.',
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      final initial = LatLng(pos.latitude, pos.longitude);

      if (!mounted) return;
      setState(() => _center = initial);

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: initial, zoom: 16),
        ),
      );

      _reverseGeocode(initial);
    } catch (e) {
      if (!mounted) return;
      await _showDialog('Error', 'Failed to get current location: $e');
    }
  }

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() {
      _gettingAddress = true;
      _address = null;
    });
    try {
      final placemarks =
          await gc.placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final line = [
          p.name,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.postalCode,
          p.country
        ].where((e) => (e ?? '').trim().isNotEmpty).join(', ');
        setState(() => _address = line);
      } else {
        setState(() => _address = 'Unknown place');
      }
    } catch (_) {
      setState(() => _address = 'Unable to fetch address');
    } finally {
      setState(() => _gettingAddress = false);
    }
  }

  void _onCameraMove(CameraPosition position) {
    final c = position.target;
    _center = c;

    _rgTimer?.cancel();
    _rgTimer = Timer(const Duration(milliseconds: 350), () {
      _reverseGeocode(c);
    });

    setState(() {});
  }

  // ===== UI HELPERS =====
  Future<void> _showDialog(String title, String msg) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  // ===== CONTINUE HANDLER: go to OnboardingTitleScreen =====
  void _onContinue() {
    // Do not block on address string; coordinates are enough to proceed.
    if (_center == null || _gettingAddress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for location to load…')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OnboardingTitleScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // allow continue once we have coordinates and we’re not loading
    final canContinue = _center != null && !_gettingAddress;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Rounded card map
              AspectRatio(
                aspectRatio: 1.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: _dividerGrey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _buildMap(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Location',
                style: TextStyle(
                  color: _titleBlack,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Enter Address',
                style: TextStyle(
                  color: _titleBlack,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Address (read-only)
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: _dividerGrey, width: 1),
                  ),
                ),
                child: Text(
                  _gettingAddress
                      ? 'Fetching address…'
                      : (_address ?? 'Move the map to select address'),
                  style: TextStyle(
                    fontSize: 15,
                    color: _gettingAddress
                        ? Colors.grey.shade600
                        : _titleBlack,
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Continue CTA (same rounded/gradient style)
              _ContinueCTA(
                enabled: canContinue,
                onPressed: canContinue ? _onContinue : null,
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    const fallback = LatLng(28.6139, 77.2090);
    final center = _center ?? fallback;

    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 16,
      ),
      onCameraMove: _onCameraMove,
      markers: {
        Marker(
          markerId: const MarkerId('center'),
          position: center,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
    );
  }
}

// ===== Gradient CTA (reused visual language) =====
class _ContinueCTA extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;

  const _ContinueCTA({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Gradient bg = enabled
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF89A50), _brandOrange],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFCFCFCF), Color(0xFFBDBDBD)],
          );

    final bubble = Colors.white.withAlpha(enabled ? 0x44 : 0x59);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Glow
        Positioned(
          bottom: -8,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 22,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xE6F5832A), Color(0x33F5832A)],
                  ),
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: bg,
            ),
            child: InkWell(
              onTap: enabled ? onPressed : null,
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                      right: 14,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: bubble,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
