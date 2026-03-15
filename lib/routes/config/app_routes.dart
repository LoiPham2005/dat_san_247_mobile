// ════════════════════════════════════════════════════════════════
// 📁 Typed Routes Definition
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/customer/welcome/presentation/pages/welcom_page.dart';
import 'package:dat_san_247_mobile/features/example/presentation/pages/google_map_example_page.dart';
import 'package:dat_san_247_mobile/features/main/presentation/pages/main_page.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/intro.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/splash_page.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

// ─── Direct Routes ─────────────────────────────────────────────
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

@TypedGoRoute<IntroRoute>(path: RouteNames.intro)
class IntroRoute extends GoRouteData with $IntroRoute {
  final bool isFirstTime;
  const IntroRoute({this.isFirstTime = false});

  @override
  Widget build(BuildContext context, GoRouterState state) => IntroPage(isFirstTime: isFirstTime);
}

@TypedGoRoute<MainRoute>(path: RouteNames.main)
class MainRoute extends GoRouteData with $MainRoute {
  const MainRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const MainPage();
}

@TypedGoRoute<PremiumRoute>(path: RouteNames.premium)
class PremiumRoute extends GoRouteData with $PremiumRoute {
  const PremiumRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const MainPage();
}

@TypedGoRoute<SettingsRoute>(path: RouteNames.settings)
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const MainPage();
}

@TypedGoRoute<HomeRoute>(path: RouteNames.home)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MainPage();
}

@TypedGoRoute<GoogleMapRoute>(path: RouteNames.googleMap)
class GoogleMapRoute extends GoRouteData with $GoogleMapRoute {
  const GoogleMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const GoogleMapExamplePage();
}
