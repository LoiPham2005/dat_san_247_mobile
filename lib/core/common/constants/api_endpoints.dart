// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // ── User ──────────────────────────────────────────────────────
  static const String profile = '/user/profile';

  // ── Business ──────────────────────────────────────────────────
  static const String products = '/products';
  static const String categories = '/categories';

  // ── Public endpoints (không cần auth) ─────────────────────────
  static const List<String> publicEndpoints = [
    login,
    register,
    verifyEmail,
    refreshToken,
    forgotPassword,
    resetPassword,
  ];
}
