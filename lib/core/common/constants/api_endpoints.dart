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
  static const String profile = '/users/me';

  // ── Business ──────────────────────────────────────────────────
  static const String products = '/products';
  static const String categories = '/categories';
  static const String banners = '/public/content/banners';
  static const String venues = '/public/venues';
  static const String venueDetail = '/public/venues/detail/{slug}';
  static const String venueSchedule = '/public/venues/{slug}/schedule';
  static const String sportTypes = '/public/lookup/sport-types';
  static const String promotions = '/public/promotions';
  static const String toggleFavorite = '/public/venues/me/favorites';
  static const String favorites = '/public/venues/me/favorites';
  static const String searchHistory = '/public/venues/me/search-history';

  // ── Booking ──────────────────────────────────────────────────
  static const String bookings = '/customer/bookings';
  static const String bookingDetail = '/customer/bookings/{id}';
  static const String cancelBooking = '/customer/bookings/{id}';
  static const String myBookings = '/customer/bookings';
  static const String reviews = '/customer/reviews';
  static const String uploadReview = '/customer/reviews/upload';

  // ── Public endpoints (không cần auth) ─────────────────────────
  static const List<String> publicEndpoints = [
    login,
    register,
    verifyEmail,
    refreshToken,
    forgotPassword,
    resetPassword,
    banners,
    venues,
    venueDetail,
    venueSchedule,
    sportTypes,
    promotions,
  ];
}
