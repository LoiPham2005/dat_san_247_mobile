// ════════════════════════════════════════════════════════════════
// 📁 3. App Router (Main Router Config)
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/core/services/manager/navigation_service.dart';
import 'package:dat_san_247_mobile/routes/base/app_routes_observer.dart';
import 'package:dat_san_247_mobile/routes/base/go_router_refresh_stream.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:dat_san_247_mobile/routes/guards/route_guards.dart';
import 'package:dat_san_247_mobile/routes/pages/not_found_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../features/venue_staff/dashboard/presentation/pages/staff_dashboard_page.dart';
import '../../features/venue_staff/dashboard/presentation/pages/staff_notifications_page.dart';
import '../../features/venue_staff/dashboard/presentation/pages/staff_system_notifications_page.dart';
import '../../features/venue_staff/pricing/presentation/pages/pricing_rules_page.dart';
import '../../features/venue_staff/pricing/presentation/pages/venue_services_page.dart';
import '../../features/venue_staff/schedule/presentation/pages/staff_booking_detail_page.dart';
import '../../features/venue_staff/schedule/presentation/pages/today_schedule_page.dart';
import '../../features/venue_staff/schedule/presentation/pages/weekly_schedule_page.dart';
import '../../features/venue_staff/staff_profile/presentation/pages/staff_management_page.dart';
import '../../features/venue_staff/staff_profile/presentation/pages/staff_profile_page.dart';
import '../../features/venue_staff/check_in/presentation/pages/check_in_confirm_page.dart';
import '../../features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
import '../../features/venue_staff/court_status/presentation/pages/court_status_page.dart';

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

    routes: [
      // ── Generated routes from app_routes.dart ──
      ...$appRoutes,
    ],

    // 404
    errorBuilder: (context, state) => NotFoundPage(error: state.error),
  );
}
