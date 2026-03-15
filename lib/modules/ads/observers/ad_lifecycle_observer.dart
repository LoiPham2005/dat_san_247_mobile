import 'package:flutter/material.dart';

import '../services/ad_manager.dart';

// ─────────────────────────────────────────────────────────────────
// AD LIFECYCLE OBSERVER — auto show App Open khi app resume
// ─────────────────────────────────────────────────────────────────

class AdLifecycleObserver extends WidgetsBindingObserver {
  AdLifecycleObserver(
    this._manager, {
    this.resumeDelay = const Duration(milliseconds: 500),
    this.onResumed,
    this.onPaused,
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  final AdManager _manager;
  final Duration resumeDelay;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;

  DateTime? _pausedAt;
  bool _disposed = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    _manager.onLifecycle(state);

    if (state == AppLifecycleState.resumed) {
      if (_pausedAt != null) {
        final elapsed = DateTime.now().difference(_pausedAt!).inSeconds;
        if (elapsed >= _manager.config.appOpenInterval) {
          Future.delayed(resumeDelay, () {
            if (!_disposed) _manager.showOnResumeAd();
          });
        }
      }
      _pausedAt = null;
      onResumed?.call();
    } else if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
      onPaused?.call();
    }
  }

  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
  }
}
