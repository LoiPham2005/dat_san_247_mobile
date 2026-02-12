import 'package:flutter/material.dart';

/// Mixin theo dõi lifecycle của app
mixin LifecycleMixin<T extends StatefulWidget>
    on State<T>
    implements WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onInitState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    onDispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResumed();
        break;
      case AppLifecycleState.inactive:
        onAppInactive();
        break;
      case AppLifecycleState.paused:
        onAppPaused();
        break;
      case AppLifecycleState.detached:
        onAppDetached();
        break;
      case AppLifecycleState.hidden:
        onAppHidden();
        break;
    }
  }

  /// Các hook cho widget override
  void onInitState() {}
  void onDispose() {}
  void onAppResumed() {}
  void onAppInactive() {}
  void onAppPaused() {}
  void onAppDetached() {}
  void onAppHidden() {}
}
