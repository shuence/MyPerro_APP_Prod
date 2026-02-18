import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../models/registration.dart';
import '../models/location_data.dart';

/// Provider for the HTTP client
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Provider for the API client
final apiClientProvider = Provider<ApiClient>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return ApiClient(client: httpClient);
});

/// Provider for the API service
final apiServiceProvider = Provider<ApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiService(apiClient);
});

/// Service layer for API operations
class ApiService {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  /// Register collar with backend
  ///
  /// Returns [RegistrationResponse] with status and collar token
  ///
  /// Throws [ApiException] on failure
  Future<RegistrationResponse> registerCollar({
    required String imei,
    required String userId,
    required String userToken,
  }) async {
    final request = RegistrationRequest(
      imei: imei,
      userId: userId,
      userToken: userToken,
    );

    return await _apiClient.registerCollar(request);
  }

  /// Update collar lost status
  ///
  /// Call this when collar enters or exits lost mode
  ///
  /// Throws [ApiException] on failure
  Future<void> setCollarLost({
    required String collarToken,
    required bool isLost,
  }) async {
    await _apiClient.setCollarLost(
      collarToken: collarToken,
      isLost: isLost,
    );
  }

  /// Send batch of location updates during lost mode
  ///
  /// [coordinates] - List of 3 GPS coordinates (t=0, t=3, t=6)
  ///
  /// Throws [ApiException] on failure
  Future<void> sendLostModeLocations({
    required String collarToken,
    required List<GPSCoordinate> coordinates,
  }) async {
    // Convert coordinates to API format
    final locations = coordinates.map((coord) {
      return {
        'lat': coord.latitude,
        'lng': coord.longitude,
        'timestamp': coord.timestamp.toIso8601String(),
      };
    }).toList();

    await _apiClient.sendLostModeLocations(
      collarToken: collarToken,
      locations: locations,
    );
  }
}

/// State notifier for tracking API loading states
class ApiLoadingNotifier extends StateNotifier<Map<String, bool>> {
  ApiLoadingNotifier() : super({});

  void setLoading(String key, bool loading) {
    state = {...state, key: loading};
  }

  bool isLoading(String key) {
    return state[key] ?? false;
  }
}

/// Provider for API loading states
final apiLoadingProvider =
    StateNotifierProvider<ApiLoadingNotifier, Map<String, bool>>((ref) {
  return ApiLoadingNotifier();
});
