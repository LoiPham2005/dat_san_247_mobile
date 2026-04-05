// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
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

  // ── Owner ────────────────────────────────────────────────────
  static const String ownerVenues = '/owner/venues';
  static const String ownerStats = '/owner/venues/dashboard/stats';
  static const String staffStats = '/owner/venues/dashboard/staff-stats';
  static const String ownerRevenue = '/owner/venues/dashboard/revenue';
  static const String ownerBookings = '/owner/bookings/{vId}';
  static const String updateBookingStatus = '/owner/bookings/{id}/status';
  static const String ownerVenueDetail = '/owner/venues/{id}';
  static const String ownerCourts = '/owner/venues/{vId}/courts';
  static const String ownerPricingRules = '/owner/venues/courts/{cId}/rules';
  static const String ownerAmenities = '/owner/venues/{vId}/amenities';
  static const String ownerOperatingHours = '/owner/venues/{vId}/operating-hours';
  static const String ownerExceptions = '/owner/venues/{vId}/exceptions';
  static const String ownerVenueServices = '/owner/venues/{vId}/services';
  static const String ownerRefundPolicies = '/owner/venues/{vId}/refund-policies';
  static const String ownerVerification = '/owner/venues/{vId}/verification';
  static const String ownerVenueUpload = '/owner/venues/upload';
  static const String ownerMedia = '/owner/venues/{vId}/media';

  // ── Staff Management ──────────────────────────────────────────
  static const String ownerStaff = '/venue-staff/owner/{venueId}';
  static const String ownerStaffInvites = '/venue-staff/owner/{venueId}/invites';
  static const String ownerStaffInvite = '/venue-staff/owner/invite';
  static const String ownerStaffInviteAction = '/venue-staff/owner/invite/{inviteId}';
  static const String ownerStaffStatus = '/venue-staff/owner/{staffId}/status';
  static const String ownerStaffRole = '/venue-staff/owner/{staffId}/role';
  static const String venueStaffSchedule = '/bookings/venue-staff/schedule';

  static const String ownerReviews = '/owner/reviews';
  static const String ownerReplyReview = '/owner/reviews/{id}/reply';

  // ── Finance Management ──────────────────────────────────────────
  static const String ownerWallet = '/owner/finance/wallet';
  static const String ownerBankAccounts = '/owner/finance/bank-accounts';
  static const String ownerPayouts = '/owner/finance/payouts';
  static const String ownerFinanceStats = '/owner/finance/stats';
  static const String ownerCommissions = '/owner/finance/commissions';

  // ── Public endpoints (không cần auth) ─────────────────────────
  static const List<String> publicEndpoints = [
    login,
    register,
    verifyEmail,
    verifyOtp,
    resendOtp,
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
