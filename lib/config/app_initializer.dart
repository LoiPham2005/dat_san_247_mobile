// ════════════════════════════════════════════════════════════════
// 📁 lib/core/config/app_initializer.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/config/app_bloc_observer.dart';
import 'package:dat_san_247_mobile/config/app_observer.dart';
import 'package:dat_san_247_mobile/config/environment_config.dart';
import 'package:dat_san_247_mobile/config/system_ui_manager.dart';
import 'package:dat_san_247_mobile/core/ads/observers/ad_lifecycle_observer.dart';
import 'package:dat_san_247_mobile/core/ads/services/ad_manager.dart';
import 'package:dat_san_247_mobile/core/cache/app_cache_manager.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/l10n/localization_service.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/core/theme/theme_cubit.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:dat_san_247_mobile/core/utils/logger_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🎯 Quản lý toàn bộ quá trình khởi tạo app
class AppInitializer {
  AppInitializer._();

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  // ✅ Add lifecycle observer instance
  static AdLifecycleObserver? _adLifecycleObserver;

  /// ✅ Entry point: Khởi tạo app
  static Future<void> initialize() async {
    if (_isInitialized) {
      Logger.warning('App already initialized, skipping...', tag: 'INIT');
      return;
    }

    try {
      final stopwatch = Stopwatch()..start();

      // Initialize Firebase
      await Firebase.initializeApp();

      // Phase 1: Config & Setup
      EnvironmentConfig.printInfo();
      LoggerConfig.configure();
      await SystemUIManager.instance.initialize();
      Logger.success('SystemUIManager initialized', tag: 'INIT');
      AppObserver().initialize();
      _configureBlocObserver();

      // Phase 3: DI (DI PHẢI TRƯỚC Ads)
      await configureDependencies();

      // Phase 4: Managers & Services
      final adManager = await getIt.getAsync<AdManager>();
      await adManager.initialize();

      // ✅ NEW: Initialize Ad Lifecycle Observer
      _adLifecycleObserver = AdLifecycleObserver();
      Logger.success('AdLifecycleObserver initialized', tag: 'INIT');

      await _initializeCacheManager();
      await _initializeServices();

      stopwatch.stop();
      _isInitialized = true;

      Logger.success('App initialized in ${stopwatch.elapsedMilliseconds}ms', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize app', error: e, stackTrace: stackTrace, tag: 'INIT');
      _isInitialized = false;
      await _handleInitializationError();
      rethrow;
    }
  }

  /// 🧹 Xử lý cleanup khi initialization fail
  static Future<void> _handleInitializationError() async {
    try {
      AppObserver().dispose();
      SystemUIManager.instance.dispose(); // ✅ Cleanup SystemUIManager
      _adLifecycleObserver?.dispose(); // ✅ Cleanup observer
      _adLifecycleObserver = null;
      await resetDependencies();
      _isInitialized = false;
      Logger.warning('Cleaned up after init failure', tag: 'INIT');
    } catch (e) {
      Logger.error('Cleanup error', error: e, tag: 'INIT');
    }
  }

  /// 🔍 Setup BLoC observer (chỉ cho Dev/Staging)
  static void _configureBlocObserver() {
    if (EnvironmentConfig.isDev || EnvironmentConfig.isStaging) {
      Bloc.observer = AppBlocObserver();
    }
  }

  /// ⚙️ Khởi tạo services (theme, localization)
  static Future<void> _initializeServices() async {
    try {
      await Future.wait([
        getIt<ThemeCubit>().initTheme(),
        getIt<LocaleCubit>().initLocale(),
        getIt<AppAuthCubit>().init(),
      ]);

      Logger.success('Services initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to init services', error: e, stackTrace: stackTrace, tag: 'INIT');
      rethrow;
    }
  }

  /// ✅ NEW: Initialize file caches
  static Future<void> _initializeCacheManager() async {
    try {
      final cacheManager = getIt<AppCacheManager>();
      await cacheManager.initialize();
      Logger.success('AppCacheManager initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to init AppCacheManager', error: e, stackTrace: stackTrace, tag: 'INIT');
      rethrow;
    }
  }
}
