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
  static const String main = '/main';
  static const String home = '/home'; // Customer Home
  static const String venueSearch = '/venue-search';
  static const String venues = '/venues';
  static const String venueDetail = '/venue-detail/:slugOrId';
  static const String timeSlotPicker = '/time-slot-picker';
  static const String bookingConfirm = '/booking-confirm';
  static const String payment = '/payment';
  static const String bookingSuccess = '/booking-success';
  static const String bookingDetail = '/booking-detail';
  static const String cancelBooking = '/cancel-booking';
  static const String writeReview = '/write-review';
  static const String recurringBookings = '/recurring-bookings';
  static const String myWaitlist = '/my-waitlist';
  static const String wallet = '/wallet';
  static const String invoices = '/invoices';
  static const String promotions = '/promotions';
  static const String favoriteVenues = '/favorite-venues';
  static const String notifications = '/notifications';
  static const String supportTickets = '/support-tickets';
  static const String profileSettings = '/profile-settings';
  static const String owner = '/owner';
  static const String venueStaff = '/venue-staff';
  static const String googleMap = '/google-map-example';
  static const String deals = '/deals';
  static const String venueMap = '/venue-map';
}
