// ════════════════════════════════════════════════════════════════
// 📁 lib/core/config/app_observer.dart (TỐI ƯU LOGGER)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/widgets.dart';
import 'package:flutter_base_template/core/config/environment_config.dart';
import 'package:flutter_base_template/core/utils/logger.dart';

/// 🔄 Monitor app lifecycle (resume, pause, detached)
class AppObserver with WidgetsBindingObserver {
  static final AppObserver _instance = AppObserver._internal();
  factory AppObserver() => _instance;
  AppObserver._internal();

  bool _isInitialized = false;
  final List<VoidCallback> _onResumeCallbacks = [];
  final List<VoidCallback> _onPauseCallbacks = [];

  /// ✅ Đăng ký callback khi app resume
  void addOnResumeCallback(VoidCallback callback) {
    if (!_onResumeCallbacks.contains(callback)) {
      _onResumeCallbacks.add(callback);
    }
  }

  /// ✅ Đăng ký callback khi app pause
  void addOnPauseCallback(VoidCallback callback) {
    if (!_onPauseCallbacks.contains(callback)) {
      _onPauseCallbacks.add(callback);
    }
  }

  /// ✅ Remove callback
  void removeOnResumeCallback(VoidCallback callback) {
    _onResumeCallbacks.remove(callback);
  }

  void removeOnPauseCallback(VoidCallback callback) {
    _onPauseCallbacks.remove(callback);
  }

  /// 🎯 Initialize observer
  void initialize() {
    if (_isInitialized) return;
    WidgetsBinding.instance.addObserver(this);
    _isInitialized = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ✅ CHỈ log nếu Dev mode
    if (EnvironmentConfig.isDev) {
      Logger.debug('Lifecycle: ${state.name}', tag: 'APP');
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _executeCallbacks(_onResumeCallbacks, 'resume');
        break;

      case AppLifecycleState.paused:
        _executeCallbacks(_onPauseCallbacks, 'pause');
        break;

      case AppLifecycleState.detached:
        if (EnvironmentConfig.isDev) {
          Logger.info('App detached', tag: 'APP');
        }
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // Không cần log
        break;
    }
  }

  /// 🔧 Execute callbacks safely
  void _executeCallbacks(List<VoidCallback> callbacks, String type) {
    for (final callback in callbacks) {
      try {
        callback();
      } catch (e, stackTrace) {
        Logger.error('Error in $type callback', error: e, stackTrace: stackTrace, tag: 'APP');
      }
    }
  }

  /// 🧹 Cleanup
  void dispose() {
    if (!_isInitialized) return;
    _onResumeCallbacks.clear();
    _onPauseCallbacks.clear();
    WidgetsBinding.instance.removeObserver(this);
    _isInitialized = false;
  }
}
