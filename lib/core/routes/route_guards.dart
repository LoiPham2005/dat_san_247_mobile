// // ════════════════════════════════════════════════════════════════
// // 📁 2. Route Guards (Auth & Redirects)
// // ════════════════════════════════════════════════════════════════
// // lib/core/routes/route_guards.dart

// import 'package:flutter/widgets.dart';
// import 'package:flutter_base_template/core/di/injection.dart';
// import 'package:flutter_base_template/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'route_names.dart';

// class RouteGuards {
//   RouteGuards._();

//   /// Auth guard - Redirect to login if not authenticated
//   static String? authGuard(BuildContext context, GoRouterState state) {
//     final authBloc = getIt<AuthBloc>();
//     final isAuthenticated = authBloc.state is Authenticated;
//     final isGoingToAuth = state.matchedLocation.startsWith('/login') ||
//         state.matchedLocation.startsWith('/register');

//     // Not logged in -> go to login (except if already going to auth pages)
//     if (!isAuthenticated && !isGoingToAuth) {
//       return RouteNames.login;
//     }

//     // Already logged in -> redirect from login/register to home
//     if (isAuthenticated && isGoingToAuth) {
//       return RouteNames.home;
//     }

//     return null; // No redirect
//   }

//   /// Optional: Role-based guard
//   static String? adminGuard(BuildContext context, GoRouterState state) {
//     final authBloc = getIt<AuthBloc>();
//     // final userRole = authBloc.state.user?.role;

//     // if (userRole != 'admin') {
//     //   return RouteNames.home;
//     // }

//     return null;
//   }
// }
