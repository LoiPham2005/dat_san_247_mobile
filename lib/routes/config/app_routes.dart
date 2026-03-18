// ════════════════════════════════════════════════════════════════
// 📁 Typed Routes Definition
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/otp_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/time_slot_picker_page.dart';
import 'package:dat_san_247_mobile/features/customer/home/presentation/pages/home_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/presentation/pages/venue_detail_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/pages/venue_list_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/pages/venue_search_page.dart';
import 'package:dat_san_247_mobile/features/example/presentation/pages/google_map_example_page.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/onboarding_page.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/splash_page.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

// ─── Direct Routes ─────────────────────────────────────────────
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
  Widget build(BuildContext context, GoRouterState state) =>
      VenueSearchPage(initialQuery: initialQuery);
}

@TypedGoRoute<VenueListRoute>(path: RouteNames.venues)
class VenueListRoute extends GoRouteData with $VenueListRoute {
  const VenueListRoute({this.query, this.district});
  final String? query;
  final String? district;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      VenueListPage(initialQuery: query, initialDistrict: district);
}

@TypedGoRoute<VenueDetailRoute>(path: RouteNames.venueDetail)
class VenueDetailRoute extends GoRouteData with $VenueDetailRoute {
  const VenueDetailRoute({required this.slugOrId});
  final String slugOrId;

  @override
  Widget build(BuildContext context, GoRouterState state) => VenueDetailPage(slugOrId: slugOrId);
}

@TypedGoRoute<TimeSlotPickerRoute>(path: RouteNames.timeSlotPicker)
class TimeSlotPickerRoute extends GoRouteData with $TimeSlotPickerRoute {
  const TimeSlotPickerRoute({required this.courtId, required this.venueName});
  final String courtId;
  final String venueName;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TimeSlotPickerPage(courtId: courtId, venueName: venueName);
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
