// ════════════════════════════════════════════════════════════════
// 🧠 2. Cache Config
// ════════════════════════════════════════════════════════════════
// lib/core/network/cache/cache_config.dart
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'cache_strategy.dart';

class CacheConfig {
  // ✅ Make store accessible publicly
  static CacheStore? _cacheStore;
  static CacheStore get cacheStore {
    if (_cacheStore == null) {
      throw StateError('CacheConfig not initialized. Call CacheConfig.initialize() first.');
    }
    return _cacheStore!;
  }

  static void initialize(CacheStore store) {
    _cacheStore = store;
  }

  static CacheOptions getOptions(CacheStrategy strategy) {
    switch (strategy) {
      case CacheStrategy.noCache:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.noCache,
        );

      case CacheStrategy.shortTerm:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.refreshForceCache,
          maxStale: const Duration(minutes: 5),
          priority: CachePriority.normal,
          hitCacheOnErrorExcept: [401, 403],
        );

      case CacheStrategy.mediumTerm:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.refreshForceCache,
          maxStale: const Duration(hours: 1),
          priority: CachePriority.normal,
          hitCacheOnErrorExcept: [401, 403],
        );

      case CacheStrategy.longTerm:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.refreshForceCache,
          maxStale: const Duration(days: 1),
          priority: CachePriority.high,
          hitCacheOnErrorExcept: [401, 403],
        );

      case CacheStrategy.permanent:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.forceCache,
          maxStale: const Duration(days: 365),
          priority: CachePriority.high,
          hitCacheOnErrorExcept: [401, 403],
        );

      case CacheStrategy.staleWhileRevalidate:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.refreshForceCache,
          maxStale: const Duration(hours: 24),
          priority: CachePriority.high,
          hitCacheOnErrorExcept: [401, 403],
        );

      case CacheStrategy.networkFirst:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.request,
          maxStale: const Duration(days: 7),
          priority: CachePriority.normal,
          hitCacheOnErrorExcept: [401, 403, 404],
        );

      case CacheStrategy.cacheFirst:
        return CacheOptions(
          store: cacheStore,
          policy: CachePolicy.forceCache,
          maxStale: const Duration(hours: 6),
          priority: CachePriority.high,
          hitCacheOnErrorExcept: [401, 403],
        );
    }
  }
}
