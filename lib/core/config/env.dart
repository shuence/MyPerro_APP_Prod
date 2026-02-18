/// Environment configuration for the app
class Env {
  // Prevent instantiation
  Env._();

  /// API base URL - can be overridden via environment variables
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.myperro.com',
  );

  /// Whether the app is running in development mode
  static const bool isDevelopment = bool.fromEnvironment(
    'DEVELOPMENT',
    defaultValue: true, // Default to dev mode for safety
  );

  /// API timeout in seconds
  static const int apiTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30,
  );

  /// Enable API request/response logging
  static const bool enableApiLogging = bool.fromEnvironment(
    'ENABLE_API_LOGGING',
    defaultValue: true, // Log by default in dev
  );

  /// API version
  static const String apiVersion = 'v1';

  /// Full API URL with version
  static String get apiUrl => '$apiBaseUrl/api/$apiVersion';
}

/// API endpoint paths
class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  /// POST /register - Register collar with backend
  static const String register = '/register';

  /// POST /is_lost - Update collar lost status
  static const String isLost = '/is_lost';

  /// POST /location - Send lost mode location updates
  static const String location = '/location';

  /// GET /collar/{imei} - Get collar details
  static String collarDetails(String imei) => '/collar/$imei';

  /// PUT /collar/{imei} - Update collar settings
  static String updateCollar(String imei) => '/collar/$imei';
}
