// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/cache/cache_config.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'cache_strategy.dart';

/// ✅ Centralized cache configuration
class CacheConfig {
  static CacheStore? _store;

  /// Get cache store (primary getter)
  static CacheStore get store {
    if (_store == null) {
      throw StateError(
        '❌ CacheConfig not initialized! Call initialize() first',
      );
    }
    return _store!;
  }

  /// ✅ NEW: Alias for convenience
  static CacheStore get cacheStore => store;

  /// Initialize cache store (call once at app startup)
  static void initialize(CacheStore store) {
    _store = store;
  }

  /// Get cache options based on strategy
  static CacheOptions getOptions(CacheStrategy strategy) {
    return switch (strategy) {
      CacheStrategy.noCache => CacheOptions(
        store: store,
        policy: CachePolicy.noCache,
      ),

      CacheStrategy.shortTerm => CacheOptions(
        store: store,
        policy: CachePolicy.refreshForceCache,
        maxStale: const Duration(minutes: 5),
        priority: CachePriority.normal,
        hitCacheOnErrorExcept: [401, 403],
      ),

      CacheStrategy.mediumTerm => CacheOptions(
        store: store,
        policy: CachePolicy.refreshForceCache,
        maxStale: const Duration(hours: 1),
        priority: CachePriority.normal,
        hitCacheOnErrorExcept: [401, 403],
      ),

      CacheStrategy.longTerm => CacheOptions(
        store: store,
        policy: CachePolicy.refreshForceCache,
        maxStale: const Duration(days: 1),
        priority: CachePriority.high,
        hitCacheOnErrorExcept: [401, 403],
      ),

      CacheStrategy.permanent => CacheOptions(
        store: store,
        policy: CachePolicy.forceCache,
        maxStale: const Duration(days: 365),
        priority: CachePriority.high,
        hitCacheOnErrorExcept: [401, 403],
      ),

      CacheStrategy.networkFirst => CacheOptions(
        store: store,
        policy: CachePolicy.request,
        maxStale: const Duration(days: 7),
        priority: CachePriority.normal,
        hitCacheOnErrorExcept: [401, 403, 404],
      ),

      CacheStrategy.cacheFirst => CacheOptions(
        store: store,
        policy: CachePolicy.forceCache,
        maxStale: const Duration(hours: 6),
        priority: CachePriority.high,
        hitCacheOnErrorExcept: [401, 403],
      ),
    };
  }
}
