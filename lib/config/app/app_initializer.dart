// ════════════════════════════════════════════════════════════════
// 📁 lib/core/config/app_initializer.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════════
import 'package:firebase_core/firebase_core.dart';
import 'package:dat_san_247_mobile/config/app/flavor_config.dart';
import 'package:dat_san_247_mobile/config/observers/app_bloc_observer.dart';
import 'package:dat_san_247_mobile/config/observers/app_observer.dart';
import 'package:dat_san_247_mobile/config/ui/system_ui_manager.dart';
import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:dat_san_247_mobile/core/common/utils/logger_config.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/core/services/crashlytics/crashlytics_service.dart';
import 'package:dat_san_247_mobile/core/services/notification/notification_service.dart';
import 'package:dat_san_247_mobile/design/l10n/cubit/locale_cubit.dart';
import 'package:dat_san_247_mobile/design/theme/cubit/theme_cubit.dart';
import 'package:dat_san_247_mobile/modules/ads/services/ad_manager.dart';
import 'package:dat_san_247_mobile/modules/iap/iap_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/base/di/injection.dart';
import '../../core/data/cache/cache_service.dart';
import '../../modules/ads/observers/ad_lifecycle_observer.dart';

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

      // ─────────────────────────────────────────────────────────────
      // Phase 0: Firebase + Crashlytics (phải là bước đầu tiên)
      // ─────────────────────────────────────────────────────────────
      await Firebase.initializeApp();
      await CrashlyticsService.instance.initialize();
      Logger.success('Firebase & Crashlytics initialized', tag: 'INIT');

      // Phase 1: Config & Setup
      FlavorConfig.printInfo();
      LoggerConfig.configure();
      await SystemUIManager.instance.initialize();
      Logger.success('SystemUIManager initialized', tag: 'INIT');
      AppObserver().initialize();
      _configureBlocObserver();

      // Phase 2: DI (phải trước Ads & Services)
      await configureDependencies();

      // Phase 4: Managers & Services
      final adManager = await getIt.getAsync<AdManager>();
      await adManager.initialize();

      // ✅ NEW: Initialize Ad Lifecycle Observer
      _adLifecycleObserver = AdLifecycleObserver(adManager);
      Logger.success('AdLifecycleObserver initialized', tag: 'INIT');

      await _initializeCacheManager();
      await _initializeServices();

      stopwatch.stop();
      _isInitialized = true;

      Logger.success('App initialized in ${stopwatch.elapsedMilliseconds}ms', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize app', error: e, stackTrace: stackTrace, tag: 'INIT');
      // _isInitialized đã là false — không cần reset
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
    if (FlavorConfig.isDev || FlavorConfig.isStg) {
      Bloc.observer = AppBlocObserver();
    }
  }

  /// ⚙️ Khởi tạo services (theme, localization)
  static Future<void> _initializeServices() async {
    try {
      await Future.wait([
        getIt<ThemeCubit>().initTheme(),
        getIt<LocaleCubit>().initLocale(),
        getIt<AppAuthCubit>().checkAuthStatus(),
        getIt<NotificationService>().initialize(),
      ]);

      // Init IAP separately to not block UI if it fails
      try {
        await getIt<IapService>().initialize();
      } catch (e) {
        Logger.error('IAP Init failed (continuing app)', error: e, tag: 'INIT');
      }

      Logger.success('Services initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to init services', error: e, stackTrace: stackTrace, tag: 'INIT');
      rethrow;
    }
  }

  /// ✅ NEW: Initialize file caches
  static Future<void> _initializeCacheManager() async {
    try {
      final cacheManager = getIt<CacheService>();
      await cacheManager.initialize();
      Logger.success('CacheService initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to init CacheService', error: e, stackTrace: stackTrace, tag: 'INIT');
      rethrow;
    }
  }
}
