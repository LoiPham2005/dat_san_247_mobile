import 'package:flutter/widgets.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppRoutesObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    Logger.info('📱 Push: ${route.settings.name ?? route.settings.arguments ?? 'Unknown'}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    Logger.info('🔙 Pop: ${route.settings.name ?? 'Unknown'}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    Logger.info('🔀 Replace: ${newRoute?.settings.name ?? 'Unknown'}');
  }
}
