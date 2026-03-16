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
  };

  // Routes that authenticated users should not access (auth pages)
  static const _authOnlyRoutes = {
    RouteNames.onboarding,
    RouteNames.login,
    RouteNames.register,
    RouteNames.otp,
    RouteNames.forgotPassword,
  };

  FutureOr<String?> authGuard(BuildContext context, GoRouterState state) {
    final bool isLoggedIn = _appAuthCubit.state.isAuthenticated;
    final String location = state.matchedLocation;

    final bool isPublicPage = _publicRoutes.contains(location);
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
