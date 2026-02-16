// ════════════════════════════════════════════════════════════════
// 📁 3. App Router (Main Router Config)
// ════════════════════════════════════════════════════════════════
// lib/core/routes/app_router.dart

import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/routes/app_routes_observer.dart';
import 'package:dat_san_247_mobile/routes/go_router_refresh_stream.dart';
import 'package:dat_san_247_mobile/routes/route_guards.dart';
import 'package:dat_san_247_mobile/routes/route_names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../core/services/navigation_service.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/customer/home/presentation/pages/home_page.dart';
import '../features/customer/intro/presentation/pages/welcome_page.dart';
import '../features/customer/splash/presentation/pages/splash_page.dart';
import 'pages/not_found_page.dart';

part 'app_router.g.dart';

@LazySingleton()
class AppRouter {
  final AppAuthCubit authCubit;
  final RouteGuards routeGuards;
  final NavigationService navigationService;
  final AppRoutesObserver appRoutesObserver;

  AppRouter(this.authCubit, this.routeGuards, this.navigationService, this.appRoutesObserver);

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    navigatorKey: navigationService.navigatorKey,
    debugLogDiagnostics: kDebugMode,
    restorationScopeId: 'app_router',

    // Auto-refresh when auth state changes
    refreshListenable: GoRouterRefreshStream(authCubit.stream),

    // Global redirect (auth guard)
    redirect: routeGuards.authGuard,

    observers: [appRoutesObserver],

    // Generated routes from go_router_builder
    routes: $appRoutes,

    // Error page (404)
    errorBuilder: (context, state) => NotFoundPage(error: state.error),
  );
}

// ═══════════════════════════════════════════════════════════════
// 📁 Typed Routes Definition
// ═══════════════════════════════════════════════════════════════

@TypedGoRoute<SplashRoute>(path: RouteNames.splash)
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<WelcomeRoute>(path: RouteNames.welcome)
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  const WelcomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const WelcomePage();
}

@TypedGoRoute<LoginRoute>(path: RouteNames.login)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

@TypedGoRoute<HomeRoute>(path: RouteNames.home)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}
