import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../models/registration.dart';

/// HTTP API client for backend communication
class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// POST /register - Register collar with backend
  ///
  /// Request:
  /// ```json
  /// {
  ///   "imei": "123456789012345",
  ///   "userId": "user_123",
  ///   "userToken": "token_abc"
  /// }
  /// ```
  ///
  /// Response:
  /// ```json
  /// {
  ///   "status": "alreadyRegisteredCurrentUser|alreadyRegisteredOtherUser|newlyRegistered",
  ///   "collarToken": "token_xyz",
  ///   "message": "Success message"
  /// }
  /// ```
  Future<RegistrationResponse> registerCollar(
    RegistrationRequest request,
  ) async {
    try {
      final url = Uri.parse('${Env.apiUrl}${ApiEndpoints.register}');

      _logRequest('POST', url.toString(), request.toJson());

      final response = await _client
          .post(
            url,
            headers: _buildHeaders(),
            body: jsonEncode(request.toJson()),
          )
          .timeout(Duration(seconds: Env.apiTimeoutSeconds));

      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return RegistrationResponse.fromJson(jsonData);
      } else if (response.statusCode == 400) {
        throw ApiException(
          'Invalid request: ${response.body}',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        throw ApiException(
          'Unauthorized: Invalid user credentials',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 409) {
        // Conflict - collar already registered to another user
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return RegistrationResponse.fromJson(jsonData);
      } else if (response.statusCode >= 500) {
        throw ApiException(
          'Server error: Please try again later',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          'Registration failed: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(
        'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw ApiException(
        'Request timed out. Please try again.',
      );
    } on FormatException {
      throw ApiException(
        'Invalid response format from server.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to register collar: $e');
    }
  }

  /// POST /is_lost - Update collar lost status
  ///
  /// Request:
  /// ```json
  /// {
  ///   "collarToken": "token_xyz",
  ///   "isLost": true
  /// }
  /// ```
  ///
  /// Response:
  /// ```json
  /// {
  ///   "success": true,
  ///   "message": "Status updated"
  /// }
  /// ```
  Future<void> setCollarLost({
    required String collarToken,
    required bool isLost,
  }) async {
    try {
      final url = Uri.parse('${Env.apiUrl}${ApiEndpoints.isLost}');

      final requestBody = {
        'collarToken': collarToken,
        'isLost': isLost,
      };

      _logRequest('POST', url.toString(), requestBody);

      final response = await _client
          .post(
            url,
            headers: _buildHeaders(authToken: collarToken),
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: Env.apiTimeoutSeconds));

      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Success
        return;
      } else if (response.statusCode == 401) {
        throw ApiException(
          'Unauthorized: Invalid collar token',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 404) {
        throw ApiException(
          'Collar not found',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode >= 500) {
        throw ApiException(
          'Server error: Please try again later',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          'Failed to update lost status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(
        'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw ApiException(
        'Request timed out. Please try again.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to update lost status: $e');
    }
  }

  /// POST /location - Send lost mode location updates
  ///
  /// Request:
  /// ```json
  /// {
  ///   "collarToken": "token_xyz",
  ///   "locations": [
  ///     {"lat": 12.34, "lng": 56.78, "timestamp": "2024-01-01T12:00:00Z"},
  ///     {"lat": 12.35, "lng": 56.79, "timestamp": "2024-01-01T12:00:03Z"},
  ///     {"lat": 12.36, "lng": 56.80, "timestamp": "2024-01-01T12:00:06Z"}
  ///   ]
  /// }
  /// ```
  Future<void> sendLostModeLocations({
    required String collarToken,
    required List<Map<String, dynamic>> locations,
  }) async {
    try {
      final url = Uri.parse('${Env.apiUrl}${ApiEndpoints.location}');

      final requestBody = {
        'collarToken': collarToken,
        'locations': locations,
      };

      _logRequest('POST', url.toString(), requestBody);

      final response = await _client
          .post(
            url,
            headers: _buildHeaders(authToken: collarToken),
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: Env.apiTimeoutSeconds));

      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401) {
        throw ApiException(
          'Unauthorized: Invalid collar token',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode >= 500) {
        throw ApiException(
          'Server error: Please try again later',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          'Failed to send locations: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(
        'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw ApiException(
        'Request timed out. Please try again.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to send locations: $e');
    }
  }

  /// Build common HTTP headers
  Map<String, String> _buildHeaders({String? authToken}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  /// Log API request (only in debug mode)
  void _logRequest(String method, String url, Map<String, dynamic>? body) {
    if (Env.enableApiLogging) {
      print('🌐 API Request: $method $url');
      if (body != null) {
        print('📤 Body: ${jsonEncode(body)}');
      }
    }
  }

  /// Log API response (only in debug mode)
  void _logResponse(http.Response response) {
    if (Env.enableApiLogging) {
      print('📥 API Response: ${response.statusCode}');
      if (response.body.isNotEmpty) {
        print('📦 Body: ${response.body}');
      }
    }
  }

  /// Close the HTTP client
  void dispose() {
    _client.close();
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException ($statusCode): $message';
    }
    return 'ApiException: $message';
  }
}

/// Timeout exception
class TimeoutException implements Exception {
  final String message;

  TimeoutException([this.message = 'Operation timed out']);

  @override
  String toString() => 'TimeoutException: $message';
}
