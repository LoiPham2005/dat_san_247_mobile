// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/services/navigation_service.dart (TỐI ƯU - CHỈ GLOBAL)
// // ════════════════════════════════════════════════════════════════
// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart'; // ✅ Thêm import

// /// Global navigation service - CHỈ dùng khi KHÔNG CÓ BuildContext
// ///
// /// ⚠️ LƯU Ý: Ưu tiên dùng context.push() thay vì service này!
// ///
// /// Use cases cho NavigationService:
// /// - Từ background services (FCM, notifications)
// /// - Từ business logic layer (không có context)
// /// - Từ static methods/callbacks
// @LazySingleton() // ✅ THÊM DÒNG NÀY
// class NavigationService {
//   factory NavigationService() => _instance;
//   NavigationService._();
//   static final NavigationService _instance = NavigationService._();

//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   BuildContext? get context => navigatorKey.currentContext;
//   NavigatorState? get navigator => navigatorKey.currentState;

//   // ═══════════════════════════════════════════════════════════════
//   // PUSH METHODS
//   // ═══════════════════════════════════════════════════════════════

//   Future<T?>? push<T>(Widget page) {
//     return navigator?.push<T>(MaterialPageRoute(builder: (_) => page));
//   }

//   Future<T?>? pushNamed<T>(String routeName, {Object? arguments}) {
//     return navigator?.pushNamed<T>(routeName, arguments: arguments);
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // PUSH REPLACEMENT METHODS
//   // ═══════════════════════════════════════════════════════════════

//   Future<T?>? pushReplacement<T, TO>(Widget page, {TO? result}) {
//     return navigator?.pushReplacement<T, TO>(
//       MaterialPageRoute(builder: (_) => page),
//       result: result,
//     );
//   }

//   Future<T?>? pushReplacementNamed<T, TO>(String routeName, {TO? result, Object? arguments}) {
//     return navigator?.pushReplacementNamed<T, TO>(routeName, result: result, arguments: arguments);
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // PUSH AND REMOVE UNTIL METHODS
//   // ═══════════════════════════════════════════════════════════════

//   Future<T?>? pushAndRemoveUntil<T>(Widget page, bool Function(Route<dynamic>) predicate) {
//     return navigator?.pushAndRemoveUntil<T>(MaterialPageRoute(builder: (_) => page), predicate);
//   }

//   Future<T?>? pushNamedAndRemoveUntil<T>(
//     String routeName,
//     bool Function(Route<dynamic>) predicate, {
//     Object? arguments,
//   }) {
//     return navigator?.pushNamedAndRemoveUntil<T>(routeName, predicate, arguments: arguments);
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // POP METHODS
//   // ═══════════════════════════════════════════════════════════════

//   void pop<T>([T? result]) {
//     navigator?.pop<T>(result);
//   }

//   void popUntil(bool Function(Route<dynamic>) predicate) {
//     navigator?.popUntil(predicate);
//   }

//   bool canPop() {
//     return navigator?.canPop() ?? false;
//   }

//   void maybePop<T>([T? result]) {
//     navigator?.maybePop<T>(result);
//   }

//   void popToRoot() {
//     navigator?.popUntil((route) => route.isFirst);
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // UTILITY METHODS
//   // ═══════════════════════════════════════════════════════════════

//   /// Unfocus keyboard globally
//   void unfocus() {
//     if (context != null) {
//       FocusScope.of(context!).unfocus();
//     }
//   }

//   /// Request focus globally
//   void requestFocus(FocusNode node) {
//     if (context != null) {
//       FocusScope.of(context!).requestFocus(node);
//     }
//   }

//   /// Check if context is available
//   bool get hasContext => context != null;

//   /// Get current route name
//   String? get currentRouteName {
//     final route = ModalRoute.of(context!);
//     return route?.settings.name;
//   }
// }

// // ════════════════════════════════════════════════════════════════
// // 🔧 3. Navigation Service (Only for no-context cases)
// // ════════════════════════════════════════════════════════════════
// // lib/core/services/navigation_service.dart

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:injectable/injectable.dart';

// /// ⚠️ CHỈ DÙNG KHI KHÔNG CÓ CONTEXT
// /// Use cases:
// /// - Background notifications (FCM)
// /// - Business logic callbacks
// /// - Static utility methods
// @LazySingleton()
// class NavigationService {
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   BuildContext? get context => navigatorKey.currentContext;

//   // ═══════════════════════════════════════════════════════════════
//   // GoRouter Methods (via context)
//   // ═══════════════════════════════════════════════════════════════

//   void go(String path, {Object? extra}) {
//     if (context != null) context!.go(path, extra: extra);
//   }

//   void push(String path, {Object? extra}) {
//     if (context != null) context!.push(path, extra: extra);
//   }

//   void replace(String path, {Object? extra}) {
//     if (context != null) {
//       context!.replace(path, extra: extra);
//     }
//   }

//   void pop<T>([T? result]) {
//     if (context != null) context!.pop(result);
//   }

//   void popToRoot() {
//     if (context != null) {
//       while (context!.canPop()) {
//         context!.pop();
//       }
//     }
//   }

//   bool get hasContext => context != null;

//   void unfocus() {
//     if (context != null) FocusScope.of(context!).unfocus();
//   }
// }

// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/navigation_service.dart (UPDATED - SUPPORT BOTH)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// ⚠️ CHỈ DÙNG KHI KHÔNG CÓ CONTEXT
///
/// Use cases:
/// - Background notifications (FCM)
/// - Business logic callbacks
/// - Static utility methods
///
/// Example:
/// ```dart
/// // In FCM handler (no context available)
/// getIt<NavigationService>().goTo('/notification-detail');
/// ```
@LazySingleton()
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;
  NavigatorState? get navigator => navigatorKey.currentState;

  // ═══════════════════════════════════════════════════════════════
  // 🚀 GO_ROUTER METHODS (Recommended)
  // ═══════════════════════════════════════════════════════════════

  /// Navigate to route (replace current)
  /// Example: service.goTo('/home')
  void goTo(String path, {Object? extra}) {
    if (context != null) context!.go(path, extra: extra);
  }

  /// Push new route
  /// Example: service.pushTo('/details')
  Future<T?>? pushTo<T>(String path, {Object? extra}) {
    return context?.push<T>(path, extra: extra);
  }

  /// Replace current route
  /// Example: service.replaceTo('/login')
  void replaceTo(String path, {Object? extra}) {
    if (context != null) context!.replace(path, extra: extra);
  }

  /// Pop current route (GoRouter)
  /// Example: service.popRoute()
  void popRoute<T>([T? result]) {
    if (context != null) context!.pop(result);
  }

  /// Pop to root (GoRouter)
  void popToRoot() {
    if (context != null) {
      while (context!.canPop()) {
        context!.pop();
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔧 TRADITIONAL NAVIGATOR METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Push widget page
  /// Example: service.navPush(DetailsPage())
  Future<T?>? navPush<T>(Widget page) {
    return navigator?.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Push custom route
  /// Example: service.navPushRoute(customRoute)
  Future<T?>? navPushRoute<T>(Route<T> route) {
    return navigator?.push<T>(route);
  }

  /// Push and replace current
  /// Example: service.navReplace(HomePage())
  Future<T?>? navReplace<T, TO>(Widget page, {TO? result}) {
    return navigator?.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Push and remove until
  /// Example: service.navPushAndClear(HomePage(), (route) => false)
  Future<T?>? navPushAndClear<T>(
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) {
    return navigator?.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  /// Push and remove all
  /// Example: service.navPushAndRemoveAll(LoginPage())
  Future<T?>? navPushAndRemoveAll<T>(Widget page) {
    return navPushAndClear<T>(page, (route) => false);
  }

  /// Pop current route (Navigator)
  /// Example: service.navPop()
  void navPop<T>([T? result]) {
    navigator?.pop<T>(result);
  }

  /// Pop until predicate
  /// Example: service.navPopUntil((route) => route.isFirst)
  void navPopUntil(bool Function(Route<dynamic>) predicate) {
    navigator?.popUntil(predicate);
  }

  /// Pop to first route (Navigator)
  /// Example: service.navPopToRoot()
  void navPopToRoot() {
    navigator?.popUntil((route) => route.isFirst);
  }

  // ═══════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Check if context is available
  bool get hasContext => context != null;

  /// Check if can pop (Navigator)
  bool get canNavPop => navigator?.canPop() ?? false;

  /// Check if can pop (GoRouter)
  bool get canPopRoute => context?.canPop() ?? false;

  /// Unfocus keyboard globally
  void unfocus() {
    if (context != null) FocusScope.of(context!).unfocus();
  }

  /// Request focus globally
  void requestFocus(FocusNode node) {
    if (context != null) FocusScope.of(context!).requestFocus(node);
  }

  /// Get current route name (Navigator)
  String? get currentRouteName {
    if (context == null) return null;
    final route = ModalRoute.of(context!);
    return route?.settings.name;
  }
}
