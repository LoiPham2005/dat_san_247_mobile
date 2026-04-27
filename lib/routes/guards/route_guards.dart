import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_state.dart';
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
    // Intercept payment gateway deep links before GoRouter resets the nav stack.
    // datsan247://payment-return has an empty path ('/') so GoRouter can't match
    // it to any route — redirect to /payment-return with parsed result.
    if (state.uri.scheme == 'datsan247' && state.uri.host == 'payment-return') {
      final p = state.uri.queryParameters;
      final method = (p['method'] ?? '').toLowerCase();
      String bookingCode = '';
      String success = '0';

      if (method == 'momo') {
        bookingCode = p['orderId'] ?? '';
        success = p['resultCode'] == '0' ? '1' : '0';
      } else if (method == 'vnpay') {
        bookingCode = p['vnp_TxnRef'] ?? '';
        success = p['vnp_ResponseCode'] == '00' ? '1' : '0';
      } else if (method == 'zalopay') {
        bookingCode = p['orderId'] ?? p['apptransid']?.split('_').lastOrNull ?? '';
        success = p['return_code'] == '1' ? '1' : '0';
      }

      return Uri(
        path: RouteNames.paymentReturn,
        queryParameters: {'method': method, 'bookingCode': bookingCode, 'success': success},
      ).toString();
    }

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
      return _getDashboardByMode();
    }

    // 3. Role-based Authorization & Shell routing
    if (isLoggedIn) {
      final user = _appAuthCubit.state.user;
      final mode = _appAuthCubit.state.loginMode;
      
      // Hậu kiểm Role thực tế để đảm bảo không vào nhầm DashBoard
      AppLoginMode actualMode = mode;
      if (mode == AppLoginMode.owner && user?.role?.slug != 'owner') {
        actualMode = AppLoginMode.customer;
      } else if (mode == AppLoginMode.staff && user?.isVenueStaff != true) {
        actualMode = AppLoginMode.customer;
      }

      // If at main root, check if we need to redirect to a specific shell
      if (location == RouteNames.main) {
        if (actualMode == AppLoginMode.staff) return RouteNames.venueStaff;
        if (actualMode == AppLoginMode.owner) return RouteNames.owner;
        return RouteNames.main;
      }
      
      // Prevent access to Staff screens if not in Staff mode
      if (location.startsWith('/venue-staff') && actualMode != AppLoginMode.staff) {
        return RouteNames.main;
      }
      
      // Prevent access to Owner screens if not in Owner mode
      if (location.startsWith('/owner') && actualMode != AppLoginMode.owner) {
        return RouteNames.main;
      }
    }

    return null;
  }

  String _getDashboardByMode() {
    final mode = _appAuthCubit.state.loginMode;

    if (mode == AppLoginMode.owner) return RouteNames.owner;
    if (mode == AppLoginMode.staff) return RouteNames.venueStaff;
    
    return RouteNames.main;
  }
}