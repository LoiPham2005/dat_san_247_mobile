import 'dart:async';

import 'package:dat_san_247_mobile/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../core/services/app_auth/app_auth_cubit.dart';

@injectable
class RouteGuards {
  final AppAuthCubit _authCubit;

  RouteGuards(this._authCubit);

  FutureOr<String?> authGuard(BuildContext context, GoRouterState state) {
    final bool isLoggedIn = _authCubit.state.isAuthenticated;
    final bool isLoggingIn = state.matchedLocation == RouteNames.login;

    final bool isSplash = state.matchedLocation == RouteNames.splash;
    final bool isWelcome = state.matchedLocation == RouteNames.welcome;
    final bool isRegister = state.matchedLocation == RouteNames.register;
    final bool isForgotPassword = state.matchedLocation == RouteNames.forgotPassword;

    // Public pages that don't require auth
    final bool isPublicPage =
        isSplash || isWelcome || isLoggingIn || isRegister || isForgotPassword;

    // 1. If not logged in and trying to access a protected page -> Redirect to Login
    if (!isLoggedIn && !isPublicPage) {
      return RouteNames.login;
    }

    // 2. If logged in and trying to access a public page (like login/register) -> Redirect to Home
    // Note: We might want to allow Splash to run its course, so we might exclude Splash from this check
    // or handle it differently. Usually splash redirects to home/login itself.
    if (isLoggedIn && (isLoggingIn || isRegister || isWelcome)) {
      return RouteNames.home;
    }

    // 3. No redirect needed
    return null;
  }
}
