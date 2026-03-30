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
    RouteNames.resetPassword,
    RouteNames.venueSearch,
    RouteNames.venues,
    RouteNames.venueMap,
  };

  // Public route prefixes - cho các route có dynamic params như /venue-detail/:id
  static const _publicPrefixes = [
    '/venue-detail/',
    '/venues',
    '/venue-search',
    '/venue-map',
    '/time-slot-picker',
  ];

  // Routes that authenticated users should not access (auth pages)
  static const _authOnlyRoutes = {
    RouteNames.onboarding,
    RouteNames.login,
    RouteNames.register,
    RouteNames.otp,
    RouteNames.forgotPassword,
    RouteNames.resetPassword,
  };

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

    // 2. Logged in + Auth page (login/register) → redirect to appropriate dashboard
    if (isLoggedIn && isAuthPage) {
      return _getDashboardByRole();
    }

    // 3. Logged in + trying to access Main Shell (Customer) but has different role
    if (isLoggedIn && location == RouteNames.main) {
      return _getDashboardByRole();
    }

    // 4. Role-based Authorization for specific prefix
    if (isLoggedIn) {
      final user = _appAuthCubit.state.user;
      final role = user?.role?.slug;

      if (location.startsWith('/owner') && role != 'OWNER') {
        return _getDashboardByRole();
      }
      if (location.startsWith('/venue-staff') && !(role == 'STAFF' || user?.isVenueStaff == true)) {
        return _getDashboardByRole();
      }
    }

    return null;
  }

  String _getDashboardByRole() {
    final user = _appAuthCubit.state.user;
    final role = user?.role?.slug.toUpperCase();

    if (role == 'OWNER') return RouteNames.owner;
    if (role == 'STAFF' || user?.isVenueStaff == true) return RouteNames.venueStaff;
    
    return RouteNames.main;
  }
}






















// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
// import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
// import 'package:go_router/go_router.dart';
// import 'package:injectable/injectable.dart';

// /// 🛡️ Auth Route Guard
// ///
// /// - Redirect unauthenticated users to login when accessing protected pages
// /// - Redirect authenticated users away from auth pages (login/register/welcome)
// /// - Splash page is always accessible (handles its own navigation)
// @LazySingleton()
// class RouteGuards {
//   final AppAuthCubit _appAuthCubit;

//   RouteGuards(this._appAuthCubit);

//   // Routes that don't require authentication
//   static const _publicRoutes = {
//     RouteNames.splash,
//     RouteNames.onboarding,
//     RouteNames.login,
//     RouteNames.register,
//     RouteNames.otp,
//     RouteNames.forgotPassword,
//     RouteNames.googleMap,
//     RouteNames.home,
//     RouteNames.main,
//     RouteNames.venueSearch,
//     RouteNames.venues,
//     RouteNames.deals,
//   };

//   // Routes that authenticated users should not access (auth pages)
//   static const _authOnlyRoutes = {
//     RouteNames.onboarding,
//     RouteNames.login,
//     RouteNames.register,
//     RouteNames.otp,
//     RouteNames.forgotPassword,
//   };

//   // Public route prefixes - cho các route có dynamic params như /venue-detail/:id
//   static const _publicPrefixes = [
//     '/venue-detail/',
//     '/venues',
//     '/venue-search',
//     '/time-slot-picker',
//     '/google-map-example',
//   ];

//   FutureOr<String?> authGuard(BuildContext context, GoRouterState state) {
//     final bool isLoggedIn = _appAuthCubit.state.isAuthenticated;
//     final String location = state.matchedLocation;

//     final bool isPublicByPrefix = _publicPrefixes.any((prefix) => location.startsWith(prefix));
//     final bool isPublicPage = _publicRoutes.contains(location) || isPublicByPrefix;
//     final bool isAuthPage = _authOnlyRoutes.contains(location);

//     // 1. Not logged in + protected page → redirect to login
//     if (!isLoggedIn && !isPublicPage) {
//       return RouteNames.login;
//     }

//     if (isLoggedIn && isAuthPage) {
//       return RouteNames.main;
//     }

//     // 2. Role-based Authorization
//     if (isLoggedIn) {
//       final user = _appAuthCubit.state.user;
//       final roleId = user?.roleId;

//       // Restrict /owner to OWNER role
//       if (location.startsWith('/owner') && roleId != 'OWNER') {
//         return RouteNames.main;
//       }

//       // Restrict /venue-staff to STAFF role
//       if (location.startsWith('/venue-staff') && roleId != 'STAFF') {
//         return RouteNames.main;
//       }
//     }

//     // 3. No redirect needed
//     return null;
//   }
// }
