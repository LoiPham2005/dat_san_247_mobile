import 'package:flutter/material.dart';

import '../../../core/common/utils/logger.dart';
import '../services/ad_analytics_tracker.dart';
  
// ─────────────────────────────────────────────────────────────────
// AD SCREEN TRACKER — auto log screen view qua RouteObserver
// ─────────────────────────────────────────────────────────────────

class AdScreenTracker extends RouteObserver<PageRoute<dynamic>> {
  AdScreenTracker._(this._tracker);
  final AdAnalyticsTracker _tracker;

  static AdScreenTracker? _instance;

  static void init(AdAnalyticsTracker tracker) => _instance = AdScreenTracker._(tracker);

  static AdScreenTracker get observer {
    assert(_instance != null, 'Call AdScreenTracker.init() first.');
    return _instance!;
  }

  /// Log screen view thủ công nếu cần.
  void track(String name) {
    Logger.info('📱 Screen → $name', tag: 'SCREEN');
    _tracker.onScreen(name);
  }

  void _trackRoute(Route<dynamic> r) => track(r.settings.name ?? r.runtimeType.toString());

  @override
  void didPush(Route r, Route? prev) {
    super.didPush(r, prev);
    if (r is PageRoute) _trackRoute(r);
  }

  @override
  void didPop(Route r, Route? prev) {
    super.didPop(r, prev);
    if (prev is PageRoute) _trackRoute(prev);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) _trackRoute(newRoute);
  }
}

// ─────────────────────────────────────────────────────────────────
// LOGGABLE ROUTE — mixin cho StatefulWidget
// ─────────────────────────────────────────────────────────────────

mixin LoggableRoute<T extends StatefulWidget> on State<T> implements RouteAware {
  String get screenName => widget.runtimeType.toString();

  RouteObserver<PageRoute>? _obs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _obs?.unsubscribe(this);
    _obs = AdScreenTracker.observer;
    final route = ModalRoute.of(context);
    if (route is PageRoute) _obs!.subscribe(this, route);
  }

  @override
  void dispose() {
    _obs?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() => AdScreenTracker.observer.track(screenName);
  @override
  void didPopNext() => AdScreenTracker.observer.track(screenName);
  @override
  void didPushNext() {}
  @override
  void didPop() {}
}

// ─────────────────────────────────────────────────────────────────
// LOGGABLE WIDGET — wrapper cho Stateless / GoRouter
// ─────────────────────────────────────────────────────────────────

class LoggableWidget extends StatefulWidget {
  const LoggableWidget({
    super.key,
    required this.screenName,
    required this.child,
    this.trackOnResume = true,
  });

  final String screenName;
  final Widget child;
  final bool trackOnResume;

  @override
  State<LoggableWidget> createState() => _LoggableWidgetState();
}

class _LoggableWidgetState extends State<LoggableWidget> with RouteAware {
  RouteObserver<PageRoute>? _obs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _obs?.unsubscribe(this);
    try {
      _obs = AdScreenTracker.observer;
      final route = ModalRoute.of(context);
      if (route is PageRoute) _obs!.subscribe(this, route);
    } catch (_) {}
  }

  @override
  void dispose() {
    _obs?.unsubscribe(this);
    super.dispose();
  }

  void _track() {
    try {
      AdScreenTracker.observer.track(widget.screenName);
    } catch (_) {}
  }

  @override
  void didPush() => _track();
  @override
  void didPopNext() {
    if (widget.trackOnResume) _track();
  }

  @override
  void didPushNext() {}
  @override
  void didPop() {}

  @override
  Widget build(BuildContext context) => widget.child;
}
