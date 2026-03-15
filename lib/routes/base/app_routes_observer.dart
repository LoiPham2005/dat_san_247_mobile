import 'package:flutter/widgets.dart';
import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:injectable/injectable.dart';

/// 🗺️ Navigation observer — logs route changes
/// Only logs in debug/profile mode to avoid overhead in production
@singleton
class AppRoutesObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    Logger.info('📱 Push: ${_routeName(previousRoute)} → ${_routeName(route)}', tag: 'NAV');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    Logger.info('🔙 Pop: ${_routeName(route)} → ${_routeName(previousRoute)}', tag: 'NAV');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    Logger.info('🔁 Replace: ${_routeName(oldRoute)} → ${_routeName(newRoute)}', tag: 'NAV');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    Logger.info(
      '🗑️ Remove: ${_routeName(route)} (stack below: ${_routeName(previousRoute)})',
      tag: 'NAV',
    );
  }

  String _routeName(Route<dynamic>? route) {
    if (route == null) return 'Root';
    final name = route.settings.name;
    if (name == null || name.isEmpty) return 'Anonymous';
    return name;
  }
}
