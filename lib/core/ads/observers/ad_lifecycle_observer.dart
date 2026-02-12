// ════════════════════════════════════════════════════════════════
// 📁 lib/core/ads/observers/ad_lifecycle_observer.dart (NEW)
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';

import '../services/ad_manager.dart';

/// Observes app lifecycle to manage ads efficiently
class AdLifecycleObserver extends WidgetsBindingObserver {
  AdLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  final _manager = getIt<AdManager>();
  AppLifecycleState? _lastState;
  DateTime? _pausedAt;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🔄 App lifecycle: ${state.name}');

    // Notify ad manager
    _manager.onAppLifecycleChanged(state);

    // Handle state changes
    switch (state) {
      case AppLifecycleState.resumed:
        _onResumed();
        break;
      case AppLifecycleState.paused:
        _onPaused();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }

    _lastState = state;
  }

  void _onResumed() {
    // Check if should show resume ad
    if (_pausedAt != null) {
      final pauseDuration = DateTime.now().difference(_pausedAt!);

      // Only show if paused for more than 30 seconds
      if (pauseDuration.inSeconds > 30) {
        _showResumeAdIfNeeded();
      }
    }
  }

  void _onPaused() {
    _pausedAt = DateTime.now();
  }

  Future<void> _showResumeAdIfNeeded() async {
    // Wait a bit for UI to settle
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      await _manager.showOnResumeAd();
    } catch (e) {
      debugPrint('❌ Failed to show resume ad: $e');
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
