// ════════════════════════════════════════════════════════════════
// 📁 Typed Routes Definition
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/otp_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/reset_password_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/booking_confirm_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/booking_detail_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/booking_success_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/cancel_booking_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/payment_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/time_slot_picker_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/write_review_page.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/pages/deals_page.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/presentation/pages/favorite_venues_page.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/presentation/pages/invoice_list_page.dart';
import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';
import 'package:dat_san_247_mobile/features/customer/notification/presentation/pages/notifications_page.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/presentation/pages/promotions_page.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/presentation/pages/recurring_booking_page.dart';
import 'package:dat_san_247_mobile/features/customer/support/presentation/pages/support_ticket_list_page.dart';
import 'package:dat_san_247_mobile/features/customer/profile/presentation/pages/profile_settings_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/pages/venue_map_page.dart';
import 'package:dat_san_247_mobile/features/customer/home/presentation/pages/home_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/presentation/pages/venue_detail_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/pages/venue_list_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/pages/venue_search_page.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/presentation/pages/my_waitlist_page.dart';
import 'package:dat_san_247_mobile/features/customer/wallet/presentation/pages/wallet_page.dart';
import 'package:dat_san_247_mobile/features/owner/main/presentation/pages/owner_shell_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/check_in_confirm_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/court_status/presentation/pages/court_status_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/main/presentation/pages/venue_staff_shell_page.dart';
import 'package:dat_san_247_mobile/features/example/presentation/pages/google_map_example_page.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/onboarding_page.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/splash_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/pages/staff_dashboard_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/pages/staff_notifications_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/pages/staff_system_notifications_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/presentation/pages/pricing_rules_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/presentation/pages/venue_services_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/models/staff_schedule_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/pages/staff_booking_detail_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/pages/today_schedule_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/pages/weekly_schedule_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/pages/staff_management_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/pages/staff_profile_page.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

// ─── Auth Routes ─────────────────────────────────────────────
@TypedGoRoute<SplashRoute>(path: RouteNames.splash)
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<OnboardingRoute>(path: RouteNames.onboarding)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const OnboardingPage();
}

@TypedGoRoute<LoginRoute>(path: RouteNames.login)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

@TypedGoRoute<RegisterRoute>(path: RouteNames.register)
class RegisterRoute extends GoRouteData with $RegisterRoute {
  const RegisterRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const RegisterPage();
}

@TypedGoRoute<OtpRoute>(path: RouteNames.otp)
class OtpRoute extends GoRouteData with $OtpRoute {
  const OtpRoute({required this.contactInfo});
  final String contactInfo;

  @override
  Widget build(BuildContext context, GoRouterState state) => OtpPage(contactInfo: contactInfo);
}

@TypedGoRoute<ForgotPasswordRoute>(path: RouteNames.forgotPassword)
class ForgotPasswordRoute extends GoRouteData with $ForgotPasswordRoute {
  const ForgotPasswordRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const ForgotPasswordPage();
}

@TypedGoRoute<ResetPasswordRoute>(path: RouteNames.resetPassword)
class ResetPasswordRoute extends GoRouteData with $ResetPasswordRoute {
  const ResetPasswordRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const ResetPasswordPage();
}

// ─── Main Shell & Home ─────────────────────────────────────────────
@TypedGoRoute<MainShellRoute>(path: RouteNames.main)
class MainShellRoute extends GoRouteData with $MainShellRoute {
  const MainShellRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const MainShellPage();
}

@TypedGoRoute<HomeRoute>(path: RouteNames.home)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@TypedGoRoute<VenueSearchRoute>(path: RouteNames.venueSearch)
class VenueSearchRoute extends GoRouteData with $VenueSearchRoute {
  const VenueSearchRoute({this.initialQuery});
  final String? initialQuery;

  @override
  Widget build(BuildContext context, GoRouterState state) => VenueSearchPage(initialQuery: initialQuery);
}

@TypedGoRoute<VenueListRoute>(path: RouteNames.venues)
class VenueListRoute extends GoRouteData with $VenueListRoute {
  const VenueListRoute({this.query, this.district});
  final String? query;
  final String? district;

  @override
  Widget build(BuildContext context, GoRouterState state) => VenueListPage(initialQuery: query, initialDistrict: district);
}

@TypedGoRoute<VenueDetailRoute>(path: RouteNames.venueDetail)
class VenueDetailRoute extends GoRouteData with $VenueDetailRoute {
  const VenueDetailRoute({required this.slugOrId});
  final String slugOrId;

  @override
  Widget build(BuildContext context, GoRouterState state) => VenueDetailPage(slugOrId: slugOrId);
}

// ─── Booking ─────────────────────────────────────────────
@TypedGoRoute<TimeSlotPickerRoute>(path: RouteNames.timeSlotPicker)
class TimeSlotPickerRoute extends GoRouteData with $TimeSlotPickerRoute {
  const TimeSlotPickerRoute({required this.courtId, required this.venueName});
  final String courtId;
  final String venueName;

  @override
  Widget build(BuildContext context, GoRouterState state) => TimeSlotPickerPage(courtId: courtId, venueName: venueName);
}

@TypedGoRoute<BookingConfirmRoute>(path: RouteNames.bookingConfirm)
class BookingConfirmRoute extends GoRouteData with $BookingConfirmRoute {
  const BookingConfirmRoute({this.$extra});
  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extra = $extra ?? {};
    return BookingConfirmPage(
      courtId: extra['courtId'] ?? '',
      courtName: extra['courtName'] ?? '',
      venueId: extra['venueId'] ?? '',
      venueName: extra['venueName'] ?? '',
      venueAddress: extra['venueAddress'] ?? '',
      bookingDate: extra['bookingDate'] ?? '',
      selectedSlots: extra['selectedSlots'] ?? [],
    );
  }
}

@TypedGoRoute<PaymentRoute>(path: RouteNames.payment)
class PaymentRoute extends GoRouteData with $PaymentRoute {
  const PaymentRoute({this.$extra});
  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extra = $extra ?? {};
    return PaymentPage(
      venueName: extra['venueName'] ?? '',
      courtName: extra['courtName'] ?? '',
      bookingDate: extra['bookingDate'] ?? '',
      startTime: extra['startTime'] ?? '',
      endTime: extra['endTime'] ?? '',
      totalAmount: (extra['totalAmount'] as num?)?.toDouble() ?? 0,
      paymentMethod: extra['paymentMethod'] ?? 'MOMO',
    );
  }
}

@TypedGoRoute<BookingSuccessRoute>(path: RouteNames.bookingSuccess)
class BookingSuccessRoute extends GoRouteData with $BookingSuccessRoute {
  const BookingSuccessRoute({this.$extra});
  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extra = $extra ?? {};
    return BookingSuccessPage(
      bookingCode: extra['bookingCode'] ?? '',
      checkInCode: extra['checkInCode'] ?? '',
      venueName: extra['venueName'] ?? '',
      courtName: extra['courtName'] ?? '',
      bookingDate: extra['bookingDate'] ?? '',
      startTime: extra['startTime'] ?? '',
      endTime: extra['endTime'] ?? '',
      totalAmount: (extra['totalAmount'] as num?)?.toDouble() ?? 0,
    );
  }
}

@TypedGoRoute<BookingDetailRoute>(path: RouteNames.bookingDetail)
class BookingDetailRoute extends GoRouteData with $BookingDetailRoute {
  const BookingDetailRoute({this.$extra});
  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extra = $extra ?? {};
    final booking = BookingListItemModel(
      id: extra['id'] ?? '',
      bookingCode: extra['bookingCode'] ?? '',
      checkInCode: extra['checkInCode'],
      venueName: extra['venueName'] ?? '',
      courtName: extra['courtName'] ?? '',
      venueAddress: extra['venueAddress'] ?? '',
      venueThumbnailUrl: extra['venueThumbnailUrl'],
      bookingDate: extra['bookingDate'] != null ? DateTime.parse(extra['bookingDate']) : DateTime.now(),
      startTime: extra['startTime'] ?? '',
      endTime: extra['endTime'] ?? '',
      status: BookingStatus.values.firstWhere(
        (e) => e.name == extra['status'],
        orElse: () => BookingStatus.PENDING,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == extra['paymentStatus'],
        orElse: () => PaymentStatus.PENDING,
      ),
      totalAmount: (extra['totalAmount'] as num?)?.toDouble() ?? 0,
      cancellationDeadline: extra['cancellationDeadline'] != null ? DateTime.parse(extra['cancellationDeadline']) : null,
      createdAt: extra['createdAt'] != null ? DateTime.parse(extra['createdAt']) : DateTime.now(),
    );
    return BookingDetailPage(booking: booking);
  }
}

@TypedGoRoute<CancelBookingRoute>(path: RouteNames.cancelBooking)
class CancelBookingRoute extends GoRouteData with $CancelBookingRoute {
  const CancelBookingRoute({this.$extra});
  final BookingDetailModel? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => CancelBookingPage(booking: $extra!);
}

@TypedGoRoute<WriteReviewRoute>(path: RouteNames.writeReview)
class WriteReviewRoute extends GoRouteData with $WriteReviewRoute {
  const WriteReviewRoute({this.$extra});
  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extra = $extra ?? {};
    return WriteReviewPage(
      bookingId: extra['bookingId'] ?? '',
      venueName: extra['venueName'] ?? '',
    );
  }
}

// ─── Customer Features ─────────────────────────────────────────────
@TypedGoRoute<RecurringBookingRoute>(path: RouteNames.recurringBookings)
class RecurringBookingRoute extends GoRouteData with $RecurringBookingRoute {
  const RecurringBookingRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const RecurringBookingPage();
}

@TypedGoRoute<MyWaitlistRoute>(path: RouteNames.myWaitlist)
class MyWaitlistRoute extends GoRouteData with $MyWaitlistRoute {
  const MyWaitlistRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const MyWaitlistPage();
}

@TypedGoRoute<WalletRoute>(path: RouteNames.wallet)
class WalletRoute extends GoRouteData with $WalletRoute {
  const WalletRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const WalletPage();
}

@TypedGoRoute<InvoiceListRoute>(path: RouteNames.invoices)
class InvoiceListRoute extends GoRouteData with $InvoiceListRoute {
  const InvoiceListRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const InvoiceListPage();
}

@TypedGoRoute<PromotionsRoute>(path: RouteNames.promotions)
class PromotionsRoute extends GoRouteData with $PromotionsRoute {
  const PromotionsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const PromotionsPage();
}

@TypedGoRoute<FavoriteVenuesRoute>(path: RouteNames.favoriteVenues)
class FavoriteVenuesRoute extends GoRouteData with $FavoriteVenuesRoute {
  const FavoriteVenuesRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const FavoriteVenuesPage();
}

@TypedGoRoute<NotificationsRoute>(path: RouteNames.notifications)
class NotificationsRoute extends GoRouteData with $NotificationsRoute {
  const NotificationsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const NotificationsPage();
}

@TypedGoRoute<SupportTicketListRoute>(path: RouteNames.supportTickets)
class SupportTicketListRoute extends GoRouteData with $SupportTicketListRoute {
  const SupportTicketListRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const SupportTicketListPage();
}

@TypedGoRoute<ProfileSettingsRoute>(path: RouteNames.profileSettings)
class ProfileSettingsRoute extends GoRouteData with $ProfileSettingsRoute {
  const ProfileSettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileSettingsPage();
}

@TypedGoRoute<DealsRoute>(path: RouteNames.deals)
class DealsRoute extends GoRouteData with $DealsRoute {
  const DealsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const DealsPage();
}

// ─── Owner & Staff ─────────────────────────────────────────────
@TypedGoRoute<OwnerShellRoute>(path: RouteNames.owner)
class OwnerShellRoute extends GoRouteData with $OwnerShellRoute {
  const OwnerShellRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const OwnerShellPage();
}

@TypedGoRoute<VenueStaffShellRoute>(path: RouteNames.venueStaff)
class VenueStaffShellRoute extends GoRouteData with $VenueStaffShellRoute {
  const VenueStaffShellRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const VenueStaffShellPage();
}

// ─── Example ─────────────────────────────────────────────
// @TypedGoRoute<GoogleMapExampleRoute>(path: RouteNames.googleMap)
// class GoogleMapExampleRoute extends GoRouteData with $GoogleMapExampleRoute {
//   const GoogleMapExampleRoute();
//   @override
//   Widget build(BuildContext context, GoRouterState state) => const GoogleMapExamplePage();
// }

@TypedGoRoute<VenueMapRoute>(path: RouteNames.venueMap)
class VenueMapRoute extends GoRouteData with $VenueMapRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VenueMapPage();
  }
}

@TypedGoRoute<StaffDashboardRoute>(path: RouteNames.staffDashboard)
class StaffDashboardRoute extends GoRouteData with $StaffDashboardRoute {
  const StaffDashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const StaffDashboardPage();
}

@TypedGoRoute<StaffNotificationsRoute>(path: RouteNames.staffNotifications)
class StaffNotificationsRoute extends GoRouteData with $StaffNotificationsRoute {
  const StaffNotificationsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const StaffNotificationsPage();
}

@TypedGoRoute<StaffSystemNotificationsRoute>(path: RouteNames.staffSystemNotifications)
class StaffSystemNotificationsRoute extends GoRouteData with $StaffSystemNotificationsRoute {
  const StaffSystemNotificationsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const StaffSystemNotificationsPage();
}

@TypedGoRoute<PricingRulesRoute>(path: RouteNames.pricingRules)
class PricingRulesRoute extends GoRouteData with $PricingRulesRoute {
  const PricingRulesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const PricingRulesPage();
}

@TypedGoRoute<VenueServicesRoute>(path: RouteNames.venueServices)
class VenueServicesRoute extends GoRouteData with $VenueServicesRoute {
  const VenueServicesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const VenueServicesPage();
}

@TypedGoRoute<StaffBookingDetailRoute>(path: RouteNames.staffBookingDetail)
class StaffBookingDetailRoute extends GoRouteData with $StaffBookingDetailRoute {
  final StaffBookingDetailModel $extra;
  final bool canAddAddon;
  const StaffBookingDetailRoute({required this.$extra, this.canAddAddon = false});

  @override
  Widget build(BuildContext context, GoRouterState state) => StaffBookingDetailPage(booking: $extra, canAddAddon: canAddAddon);
}

@TypedGoRoute<TodayScheduleRoute>(path: RouteNames.todaySchedule)
class TodayScheduleRoute extends GoRouteData with $TodayScheduleRoute {
  const TodayScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TodaySchedulePage();
}

@TypedGoRoute<WeeklyScheduleRoute>(path: RouteNames.weeklySchedule)
class WeeklyScheduleRoute extends GoRouteData with $WeeklyScheduleRoute {
  const WeeklyScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const WeeklySchedulePage();
}

@TypedGoRoute<StaffManagementRoute>(path: RouteNames.staffManagement)
class StaffManagementRoute extends GoRouteData with $StaffManagementRoute {
  const StaffManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const StaffManagementPage();
}

@TypedGoRoute<StaffProfileRoute>(path: RouteNames.staffProfile)
class StaffProfileRoute extends GoRouteData with $StaffProfileRoute {
  final bool isManager;
  const StaffProfileRoute({this.isManager = false});

  @override
  Widget build(BuildContext context, GoRouterState state) => StaffProfilePage(isManager: isManager);
}

@TypedGoRoute<CheckInConfirmRoute>(path: RouteNames.checkInConfirm)
class CheckInConfirmRoute extends GoRouteData with $CheckInConfirmRoute {
  final CheckInBookingModel $extra;
  const CheckInConfirmRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) => CheckInConfirmPage(booking: $extra);
}

@TypedGoRoute<QrCheckInRoute>(path: RouteNames.qrCheckIn)
class QrCheckInRoute extends GoRouteData with $QrCheckInRoute {
  const QrCheckInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const QrCheckInPage();
}

@TypedGoRoute<CourtStatusRoute>(path: RouteNames.courtStatus)
class CourtStatusRoute extends GoRouteData with $CourtStatusRoute {
  final bool isManager;
  const CourtStatusRoute({this.isManager = false});

  @override
  Widget build(BuildContext context, GoRouterState state) => CourtStatusPage(isManager: isManager);
}
