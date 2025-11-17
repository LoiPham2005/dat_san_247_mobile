// ════════════════════════════════════════════════════════════════
// 📁 3. App Router (Main Router Config)
// ════════════════════════════════════════════════════════════════
// lib/core/routes/app_router.dart

import 'package:flutter_base_template/core/di/injection.dart';
import 'package:flutter_base_template/core/routes/pages/not_found_page.dart';
import 'package:flutter_base_template/core/routes/route_names.dart';
import 'package:flutter_base_template/core/services/navigation_service.dart';
import 'package:flutter_base_template/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_base_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_base_template/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_base_template/features/welcome/presentation/pages/welcom_page.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    navigatorKey: getIt<NavigationService>().navigatorKey,
    debugLogDiagnostics: true,
    restorationScopeId: 'app_router',

    // Global redirect (auth guard)
    // redirect: RouteGuards.authGuard,
    routes: [
      // ═════════════════════════════════════════════════════════════
      // Auth Routes
      // ═════════════════════════════════════════════════════════════
      GoRoute(
        path: RouteNames.splash,
        // name: RouteNames.splashName,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: RouteNames.welcome,
        // name: RouteNames.welcomeName,
        builder: (context, state) => const WelcomPage(),
      ),

      GoRoute(
        path: RouteNames.login,
        // name: RouteNames.loginName,
        builder: (context, state) => const LoginPage(),
      ),

      // ═════════════════════════════════════════════════════════════
      // Main App Routes
      // ═════════════════════════════════════════════════════════════
      GoRoute(
        path: RouteNames.home,
        // name: RouteNames.homeName,
        builder: (context, state) => const HomePage(),
      ),
    ],

    // Error page (404)
    errorBuilder: (context, state) => NotFoundPage(error: state.error),
  );
}
