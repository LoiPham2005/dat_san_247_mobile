// lib/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  // domain
  static const String domainDev = 'http://192.168.2.4:3000';
  static const String domainStg = 'http://192.168.2.7:3000';
  static const String domainProd = 'http://192.168.2.7:3000';

  // Base URLs
  static const String baseUrlDev = '$domainDev/api';
  static const String baseUrlStg = '$domainStg/api';
  static const String baseUrlProd = '$domainProd/api';

  // ════════════════════════════════════════════════════════════════
  // 🌍 CONFIGURATION CONSTANTS (Merged from .env)
  // ════════════════════════════════════════════════════════════════

  // WebSocket URLs
  static const String wsUrlDev = 'ws://192.168.2.4:3000/ws';
  static const String wsUrlStg = 'ws://192.168.2.7:3000/ws';
  static const String wsUrlProd = 'wss://api.example.com/ws';

  // Feature Flags (Dev / Stg / Prod)
  static const bool enableLoggingDev = true;
  static const bool enableLoggingStg = true;
  static const bool enableLoggingProd = false;

  static const bool enableDebugToolsDev = true;
  static const bool enableDebugToolsStg = true;
  static const bool enableDebugToolsProd = false;

  static const bool enableAnalyticsDev = false;
  static const bool enableAnalyticsStg = true;
  static const bool enableAnalyticsProd = true;

  // Timeouts (Seconds)
  static const int connectTimeoutDev = 30;
  static const int connectTimeoutStg = 30;
  static const int connectTimeoutProd = 30;

  static const int receiveTimeoutDev = 30;
  static const int receiveTimeoutStg = 30;
  static const int receiveTimeoutProd = 30;

  // API Keys (Hardcoded - Consider secure storage for real prod keys)
  static const String googleMapsApiKeyDev = 'android_key_dev';
  static const String googleMapsApiKeyStg = 'android_key_stg';
  static const String googleMapsApiKeyProd = 'android_key_prod';

  static const String stripePublicKeyDev = 'pk_test_dev';
  static const String stripePublicKeyStg = 'pk_test_stg';
  static const String stripePublicKeyProd = 'pk_live_prod';

  // ════════════════════════════════════════════════════════════════
  // 🔗 ENDPOINTS
  // ════════════════════════════════════════════════════════════════

  // test
  static const String apiEndpoints = '/apiEndpoints';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/user/profile';
  static const String logout = '/auth/logout';

  static const String products = '/products';
  static const String categories = '/categories';

  // 🔓 Danh sách các API public (không cần xác thực)
  static const List<String> publicEndpoints = [
    login,
    register,
    refreshToken,
    forgotPassword,
    resetPassword,
  ];
}
