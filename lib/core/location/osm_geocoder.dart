// lib/core/location/osm_geocoder.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Free reverse geocoder using Nominatim (OpenStreetMap).
/// No API key required. Please respect usage policy.
/// https://operations.osmfoundation.org/policies/nominatim/
class OsmGeocoder {
  final String userAgent; // e.g. "MyPerroApp/1.0 (contact@company.com)"
  final String? contactEmail;

  OsmGeocoder({
    required this.userAgent,
    this.contactEmail,
  });

  Future<String> reverseGeocode(double lat, double lon) async {
    final params = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'format': 'json',
      if (contactEmail != null && contactEmail!.isNotEmpty)
        'email': contactEmail!,
    };

    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', params);

    final res = await http.get(
      uri,
      headers: {
        'User-Agent': userAgent,
        'Accept': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw 'Reverse geocoding failed (${res.statusCode})';
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    final display = data['display_name'] as String?;
    return display?.trim().isNotEmpty == true ? display! : 'Unknown address';
    // You can also use "address" object for custom formatting.
  }
}
