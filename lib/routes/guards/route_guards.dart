import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// 🛡️ Auth Route Guard
///
/// - Redirect unauthenticated users to login when accessing protected pages
/// - Redirect authenticated users away from auth pages (login/register/welcome)
/// - Splash page is always accessible (handles its own navigation)
@LazySingleton()
class RouteGuards {
  final AppAuthCubit _appAuthCubit;

  RouteGuards(this._appAuthCubit);

  // Routes that don't require authentication
  static const _publicRoutes = {
    RouteNames.splash,
    RouteNames.onboarding,
    RouteNames.login,
    RouteNames.register,
    RouteNames.otp,
    RouteNames.forgotPassword,
    RouteNames.googleMap,
    RouteNames.home,
    RouteNames.main,
    RouteNames.venueSearch,
    RouteNames.venues,
    RouteNames.venueDetail,
    RouteNames.timeSlotPicker,


  };

  // Routes that authenticated users should not access (auth pages)
  static const _authOnlyRoutes = {
    RouteNames.onboarding,
    RouteNames.login,
    RouteNames.register,
    RouteNames.otp,
    RouteNames.forgotPassword,
  };

  // Public route prefixes - cho các route có dynamic params như /venue-detail/:id
  static const _publicPrefixes = [
    '/venue-detail/',
    '/venues',
    '/venue-search',
    '/time-slot-picker',
    '/court-detail/',
    '/booking-confirm',
    '/payment',
    '/booking-success',
    '/booking-detail',
    '/cancel-booking',
    '/write-review',
    '/recurring-bookings',
    '/my-waitlist',
    '/wallet',
    '/invoices',
    '/promotions',
    '/favorite-venues',
    '/notifications',
    '/support-tickets',
    '/profile-settings',
    '/owner',
    '/venue-staff',
    '/venue-map',
  ];

  FutureOr<String?> authGuard(BuildContext context, GoRouterState state) {
    final bool isLoggedIn = _appAuthCubit.state.isAuthenticated;
    final String location = state.matchedLocation;

    final bool isPublicByPrefix = _publicPrefixes.any((prefix) => location.startsWith(prefix));
    final bool isPublicPage = _publicRoutes.contains(location) || isPublicByPrefix;
    final bool isAuthPage = _authOnlyRoutes.contains(location);

    // 1. Not logged in + protected page → redirect to login
    if (!isLoggedIn && !isPublicPage) {
      return RouteNames.login;
    }

    if (isLoggedIn && isAuthPage) {
      return RouteNames.main;
    }
    // 3. No redirect needed
    return null;
  }
}
