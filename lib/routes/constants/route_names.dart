// 📁 1. Route Names (Constants)
// ════════════════════════════════════════════════════════════════
// lib/core/routes/route_names.dart

/// Centralized route names - Single source of truth
class RouteNames {
  RouteNames._();

  // ═══════════════════════════════════════════════════════════════
  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  // ═══════════════════════════════════════════════════════════════
  // Main App
  static const String main = '/main';
  static const String home = '/home'; // Customer Home
  static const String venueSearch = '/venue-search';
  static const String venues = '/venues';
  static const String googleMap = '/google-map-example';
}
