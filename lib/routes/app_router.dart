// ════════════════════════════════════════════════════════════════
// 📁 3. App Router (Main Router Config)
// ════════════════════════════════════════════════════════════════
// lib/core/routes/app_router.dart

import 'package:dat_san_247_mobile/core/services/navigation_service.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:dat_san_247_mobile/features/customer/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/customer/bottomMenu/pages/bottom_menu_custom.dart';
import 'package:dat_san_247_mobile/features/customer/intro/presentation/pages/welcome_page.dart';
import 'package:dat_san_247_mobile/features/customer/splash/presentation/pages/splash_page.dart';
// import 'package:dat_san_247_mobile/features/customer/welcome/presentation/pages/welcom_page.dart';
import 'package:dat_san_247_mobile/routes/app_routes_observer.dart';
import 'package:dat_san_247_mobile/routes/go_router_refresh_stream.dart';
import 'package:dat_san_247_mobile/routes/pages/not_found_page.dart';
import 'package:dat_san_247_mobile/routes/route_guards.dart';
import 'package:dat_san_247_mobile/routes/route_names.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppRouter {
  final AuthBloc authBloc;
  final RouteGuards routeGuards;
  final NavigationService navigationService;
  final AppRoutesObserver appRoutesObserver;

  AppRouter(this.authBloc, this.routeGuards, this.navigationService, this.appRoutesObserver);

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.welcome,
    navigatorKey: navigationService.navigatorKey,
    debugLogDiagnostics: kDebugMode,
    restorationScopeId: 'app_router',

    // Auto-refresh when auth state changes
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    // Global redirect (auth guard)
    redirect: routeGuards.authGuard,

    observers: [appRoutesObserver],

    routes: [
      // ═════════════════════════════════════════════════════════════
      // Auth Routes
      // ═════════════════════════════════════════════════════════════
      GoRoute(path: RouteNames.splash, builder: (context, state) => const SplashPage()),

      GoRoute(path: RouteNames.welcome, builder: (context, state) => const WelcomePage()),

      // GoRoute(path: RouteNames.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: RouteNames.login, builder: (context, state) => const LoginPage()),

      GoRoute(path: RouteNames.register, builder: (context, state) => const RegisterPage()),

      // ═════════════════════════════════════════════════════════════
      // Main App Routes
      // ═════════════════════════════════════════════════════════════
      GoRoute(path: RouteNames.home, builder: (context, state) => const BottomMenuCustom()),
    ],

    // Error page (404)
    errorBuilder: (context, state) => NotFoundPage(error: state.error),
  );
}
