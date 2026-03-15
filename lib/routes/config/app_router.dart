// ════════════════════════════════════════════════════════════════
// 📁 3. App Router (Main Router Config)
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/core/services/manager/navigation_service.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:dat_san_247_mobile/routes/base/app_routes_observer.dart';
import 'package:dat_san_247_mobile/routes/base/go_router_refresh_stream.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:dat_san_247_mobile/routes/guards/route_guards.dart';
import 'package:dat_san_247_mobile/routes/pages/not_found_page.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppRouter {
  final AppAuthCubit appAuthCubit;
  final RouteGuards routeGuards;
  final NavigationService navigationService;
  final AppRoutesObserver appRoutesObserver;

  AppRouter(
    this.appAuthCubit,
    this.routeGuards,
    this.navigationService,
    this.appRoutesObserver,
  );

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    navigatorKey: navigationService.navigatorKey,
    debugLogDiagnostics: kDebugMode,
    restorationScopeId: 'app_router',

    // Auto-refresh when auth state changes
    refreshListenable: GoRouterRefreshStream(appAuthCubit.stream),

    // Global redirect (auth guard)
    redirect: routeGuards.authGuard,

    observers: [appRoutesObserver, FlutterSmartDialog.observer],

    // Generated routes from app_routes.dart
    routes: $appRoutes,

    // Error page (404)
    errorBuilder: (context, state) => NotFoundPage(error: state.error),
  );
}
